import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../data/datasources/local/database_helper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/admin_metrics_stats.dart';

class AdminMetricsRepository {
  final DatabaseHelper _databaseHelper;

  AdminMetricsRepository(this._databaseHelper);

  /// Busca métricas gerais do sistema
  Future<Either<Failure, SystemMetrics>> getSystemMetrics() async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      // Usuários
      final usersData = await db.rawQuery('''
        SELECT 
          COUNT(*) as total_users,
          SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_users,
          SUM(CASE WHEN created_at >= ? THEN 1 ELSE 0 END) as new_this_month
        FROM users
      ''', [startOfMonth.toIso8601String()]);

      // Empresas
      final companiesData = await db.rawQuery('''
        SELECT 
          COUNT(*) as total_companies,
          SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_companies,
          SUM(CASE WHEN created_at >= ? THEN 1 ELSE 0 END) as new_this_month
        FROM companies
      ''', [startOfMonth.toIso8601String()]);

      // Assinaturas e receita
      final subsData = await db.rawQuery('''
        SELECT 
          COUNT(*) as total_subscriptions,
          SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active_subs,
          SUM(CASE WHEN status = 'past_due' THEN 1 ELSE 0 END) as overdue_subs
        FROM subscriptions
      ''');

      // Calcular MRR e receita total
      final allSubs = await db.query('subscriptions');
      double totalMRR = 0;
      double totalRevenue = 0;
      
      for (final sub in allSubs) {
        final amount = (sub['amount'] as num?)?.toDouble() ?? 0;
        final status = sub['status'] as String;
        
        if (status == 'active') {
          totalMRR += amount; // Assumindo billing mensal
        }
        totalRevenue += amount;
      }

      // Previsões (mock - tabela prediction_history será implementada futuramente)
      const totalPredictions = 1250;
      const predictionsThisMonth = 320;

      // Métricas de API (mock - será integrado com API real)
      const totalApiCalls = 5000;
      const apiCallsThisMonth = 1200;

      // Pagamentos falhos
      await _ensurePaymentsTableExists(db);
      final failedPayments = await db.rawQuery('''
        SELECT COUNT(*) as count
        FROM payment_records
        WHERE status = 'failed' AND created_at >= ?
      ''', [startOfMonth.toIso8601String()]);

      final totalUsers = usersData.first['total_users'] as int? ?? 0;
      final activeUsers = usersData.first['active_users'] as int? ?? 0;
      final totalCompanies = companiesData.first['total_companies'] as int? ?? 0;

      // Calcular métricas derivadas
      final arpu = totalUsers > 0 ? totalMRR / totalUsers : 0.0;
      final arpa = totalCompanies > 0 ? totalMRR / totalCompanies : 0.0;
      final avgPredictionsPerUser = totalUsers > 0 ? totalPredictions ~/ totalUsers : 0;
      
      // Taxa de crescimento (mock - precisa histórico)
      final growthRate = 5.0; // %
      final churnRate = 2.0; // %
      
      // Health score
      final healthScore = _calculateHealthScore(
        activeUsers: activeUsers,
        totalUsers: totalUsers,
        overdueSubscriptions: subsData.first['overdue_subs'] as int? ?? 0,
        totalSubscriptions: subsData.first['total_subscriptions'] as int? ?? 0,
      );

      final metrics = SystemMetrics(
        totalUsers: totalUsers,
        activeUsers: activeUsers,
        totalCompanies: totalCompanies,
        activeCompanies: companiesData.first['active_companies'] as int? ?? 0,
        totalSubscriptions: subsData.first['total_subscriptions'] as int? ?? 0,
        activeSubscriptions: subsData.first['active_subs'] as int? ?? 0,
        totalRevenue: totalRevenue,
        monthlyRecurringRevenue: totalMRR,
        averageRevenuePerUser: arpu,
        averageRevenuePerAccount: arpa,
        newUsersThisMonth: usersData.first['new_this_month'] as int? ?? 0,
        newCompaniesThisMonth: companiesData.first['new_this_month'] as int? ?? 0,
        growthRate: growthRate,
        churnRate: churnRate,
        totalPredictions: totalPredictions,
        predictionsThisMonth: predictionsThisMonth,
        averagePredictionsPerUser: avgPredictionsPerUser,
        totalApiCalls: totalApiCalls,
        apiCallsThisMonth: apiCallsThisMonth,
        apiSuccessRate: 98.5,
        systemHealthScore: healthScore,
        failedPayments: failedPayments.first['count'] as int? ?? 0,
        overdueSubscriptions: subsData.first['overdue_subs'] as int? ?? 0,
        calculatedAt: now,
      );

      return Right(metrics);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar métricas: $e'));
    }
  }

  /// Busca métricas de receita
  Future<Either<Failure, RevenueMetrics>> getRevenueMetrics() async {
    try {
      final db = await _databaseHelper.database;
      await _ensurePaymentsTableExists(db);

      // Receita diária (últimos 30 dias)
      final dailyRevenue = await _getDailyRevenue(db, 30);
      
      // Receita mensal (últimos 12 meses)
      final monthlyRevenue = await _getMonthlyRevenue(db, 12);
      
      // MRR histórico
      final mrrHistory = await _getMRRHistory(db, 12);

      // Comparação mês atual vs anterior
      final now = DateTime.now();
      final startOfThisMonth = DateTime(now.year, now.month, 1);
      final startOfLastMonth = DateTime(now.year, now.month - 1, 1);
      
      final thisMonthRevenue = dailyRevenue
          .where((d) => d.date.isAfter(startOfThisMonth))
          .fold(0.0, (sum, d) => sum + d.value);
      
      final lastMonthRevenue = await _getMonthRevenue(db, startOfLastMonth);
      
      final growthRate = lastMonthRevenue > 0
          ? ((thisMonthRevenue - lastMonthRevenue) / lastMonthRevenue) * 100
          : 0.0;

      return Right(RevenueMetrics(
        dailyRevenue: dailyRevenue,
        monthlyRevenue: monthlyRevenue,
        mrrHistory: mrrHistory,
        totalRevenueLastMonth: lastMonthRevenue,
        totalRevenueThisMonth: thisMonthRevenue,
        revenueGrowthRate: growthRate,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar métricas de receita: $e'));
    }
  }

  /// Busca métricas de crescimento de usuários
  Future<Either<Failure, UserGrowthMetrics>> getUserGrowthMetrics() async {
    try {
      final db = await _databaseHelper.database;

      // Signups diários
      final dailySignups = await _getDailySignups(db, 30);
      
      // Signups mensais
      final monthlySignups = await _getMonthlySignups(db, 12);
      
      // Histórico de usuários ativos
      final activeUsersHistory = await _getActiveUsersHistory(db, 12);

      // Comparação
      final now = DateTime.now();
      final startOfThisMonth = DateTime(now.year, now.month, 1);
      final startOfLastMonth = DateTime(now.year, now.month - 1, 1);
      
      final thisMonth = dailySignups
          .where((d) => d.date.isAfter(startOfThisMonth))
          .fold(0, (sum, d) => sum + d.value.toInt());
      
      final lastMonth = await _getMonthSignups(db, startOfLastMonth);
      
      final growthRate = lastMonth > 0
          ? ((thisMonth - lastMonth) / lastMonth) * 100
          : 0.0;

      return Right(UserGrowthMetrics(
        dailySignups: dailySignups,
        monthlySignups: monthlySignups,
        activeUsersHistory: activeUsersHistory,
        signupsLastMonth: lastMonth,
        signupsThisMonth: thisMonth,
        signupGrowthRate: growthRate,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar métricas de crescimento: $e'));
    }
  }

  /// Busca distribuição por tier
  Future<Either<Failure, TierDistribution>> getTierDistribution() async {
    try {
      final db = await _databaseHelper.database;

      final results = await db.rawQuery('''
        SELECT 
          tier,
          COUNT(*) as count
        FROM subscriptions
        GROUP BY tier
      ''');

      int freeCount = 0;
      int proCount = 0;
      int enterpriseCount = 0;

      for (final row in results) {
        final tier = row['tier'] as String;
        final count = row['count'] as int;
        
        switch (tier) {
          case 'free':
            freeCount = count;
            break;
          case 'pro':
            proCount = count;
            break;
          case 'enterprise':
            enterpriseCount = count;
            break;
        }
      }

      final total = freeCount + proCount + enterpriseCount;
      
      return Right(TierDistribution(
        freeCount: freeCount,
        proCount: proCount,
        enterpriseCount: enterpriseCount,
        freePercentage: total > 0 ? (freeCount / total) * 100 : 0,
        proPercentage: total > 0 ? (proCount / total) * 100 : 0,
        enterprisePercentage: total > 0 ? (enterpriseCount / total) * 100 : 0,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar distribuição: $e'));
    }
  }

  /// Busca métricas de uso
  Future<Either<Failure, UsageMetrics>> getUsageMetrics() async {
    try {
      // Mock data - prediction_history table will be implemented in the future
      final dailyPredictions = _generateMockDailyPredictions(30);
      final monthlyPredictions = _generateMockMonthlyPredictions(12);

      final predictionsByCompany = {
        'Empresa A': 450,
        'Empresa B': 320,
        'Empresa C': 280,
        'Empresa D': 210,
        'Empresa E': 180,
      };

      final predictionsByUser = {
        'João Silva': 150,
        'Maria Santos': 120,
        'Pedro Oliveira': 95,
        'Ana Costa': 80,
        'Carlos Lima': 75,
      };

      const predictionsLastMonth = 980;
      const predictionsThisMonth = 1120;
      final growthRate = ((predictionsThisMonth - predictionsLastMonth) / predictionsLastMonth) * 100;

      return Right(UsageMetrics(
        dailyPredictions: dailyPredictions,
        monthlyPredictions: monthlyPredictions,
        predictionsLastMonth: predictionsLastMonth,
        predictionsThisMonth: predictionsThisMonth,
        predictionsGrowthRate: growthRate,
        predictionsByCompany: predictionsByCompany,
        predictionsByUser: predictionsByUser,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar métricas de uso: $e'));
    }
  }

  /// Busca métricas de saúde do sistema
  Future<Either<Failure, SystemHealthMetrics>> getSystemHealthMetrics() async {
    try {
      final db = await _databaseHelper.database;
      await _ensurePaymentsTableExists(db);

      // Saúde de pagamentos
      final paymentHealth = await _calculatePaymentHealth(db);
      
      // Engagement de usuários
      final userEngagement = await _calculateUserEngagement(db);
      
      // Saúde de assinaturas
      final subscriptionHealth = await _calculateSubscriptionHealth(db);
      
      // Saúde de API (mock)
      const apiHealth = 98.5;
      
      // Overall health (média ponderada)
      final overallHealth = (
        paymentHealth * 0.3 +
        userEngagement * 0.3 +
        subscriptionHealth * 0.3 +
        apiHealth * 0.1
      );

      // Gerar alertas
      final alerts = await _generateHealthAlerts(
        paymentHealth: paymentHealth,
        userEngagement: userEngagement,
        subscriptionHealth: subscriptionHealth,
      );

      final criticalIssues = alerts.where((a) => a.severity == HealthAlertSeverity.critical).length;
      final warnings = alerts.where((a) => a.severity == HealthAlertSeverity.warning).length;

      return Right(SystemHealthMetrics(
        overallHealth: overallHealth,
        paymentHealth: paymentHealth,
        userEngagement: userEngagement,
        subscriptionHealth: subscriptionHealth,
        apiHealth: apiHealth,
        criticalIssues: criticalIssues,
        warnings: warnings,
        alerts: alerts,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar métricas de saúde: $e'));
    }
  }

  // ==================== HELPERS ====================

  Future<List<TimeSeriesData>> _getDailyRevenue(Database db, int days) async {
    final results = await db.rawQuery('''
      SELECT 
        DATE(created_at) as date,
        SUM(amount) as total
      FROM payment_records
      WHERE status = 'success'
        AND created_at >= date('now', '-$days days')
      GROUP BY DATE(created_at)
      ORDER BY date ASC
    ''');

    return results.map((row) => TimeSeriesData(
      date: DateTime.parse(row['date'] as String),
      value: (row['total'] as num?)?.toDouble() ?? 0,
    )).toList();
  }

  Future<List<TimeSeriesData>> _getMonthlyRevenue(Database db, int months) async {
    final results = await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', created_at) as month,
        SUM(amount) as total
      FROM payment_records
      WHERE status = 'success'
        AND created_at >= date('now', '-$months months')
      GROUP BY strftime('%Y-%m', created_at)
      ORDER BY month ASC
    ''');

    return results.map((row) {
      final month = row['month'] as String;
      final parts = month.split('-');
      return TimeSeriesData(
        date: DateTime(int.parse(parts[0]), int.parse(parts[1])),
        value: (row['total'] as num?)?.toDouble() ?? 0,
        label: month,
      );
    }).toList();
  }

  Future<List<TimeSeriesData>> _getMRRHistory(Database db, int months) async {
    // Simplificado - em produção calcular MRR real por mês
    final monthly = await _getMonthlyRevenue(db, months);
    return monthly.map((d) => TimeSeriesData(
      date: d.date,
      value: d.value, // MRR aproximado
      label: d.label,
    )).toList();
  }

  Future<double> _getMonthRevenue(Database db, DateTime month) async {
    final nextMonth = DateTime(month.year, month.month + 1);
    final results = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM payment_records
      WHERE status = 'success'
        AND created_at >= ?
        AND created_at < ?
    ''', [month.toIso8601String(), nextMonth.toIso8601String()]);

    return (results.first['total'] as num?)?.toDouble() ?? 0;
  }

  Future<List<TimeSeriesData>> _getDailySignups(Database db, int days) async {
    final results = await db.rawQuery('''
      SELECT 
        DATE(created_at) as date,
        COUNT(*) as count
      FROM users
      WHERE created_at >= date('now', '-$days days')
      GROUP BY DATE(created_at)
      ORDER BY date ASC
    ''');

    return results.map((row) => TimeSeriesData(
      date: DateTime.parse(row['date'] as String),
      value: (row['count'] as int).toDouble(),
    )).toList();
  }

  Future<List<TimeSeriesData>> _getMonthlySignups(Database db, int months) async {
    final results = await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', created_at) as month,
        COUNT(*) as count
      FROM users
      WHERE created_at >= date('now', '-$months months')
      GROUP BY strftime('%Y-%m', created_at)
      ORDER BY month ASC
    ''');

    return results.map((row) {
      final month = row['month'] as String;
      final parts = month.split('-');
      return TimeSeriesData(
        date: DateTime(int.parse(parts[0]), int.parse(parts[1])),
        value: (row['count'] as int).toDouble(),
        label: month,
      );
    }).toList();
  }

  Future<List<TimeSeriesData>> _getActiveUsersHistory(Database db, int months) async {
    // Simplificado - em produção rastrear ativos por mês
    return _getMonthlySignups(db, months);
  }

  Future<int> _getMonthSignups(Database db, DateTime month) async {
    final nextMonth = DateTime(month.year, month.month + 1);
    final results = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM users
      WHERE created_at >= ?
        AND created_at < ?
    ''', [month.toIso8601String(), nextMonth.toIso8601String()]);

    return results.first['count'] as int? ?? 0;
  }

  List<TimeSeriesData> _generateMockDailyPredictions(int days) {
    final now = DateTime.now();
    final data = <TimeSeriesData>[];
    
    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final value = 30.0 + (i % 10) * 5.0; // Mock data with variation
      data.add(TimeSeriesData(date: date, value: value));
    }
    
    return data;
  }

  List<TimeSeriesData> _generateMockMonthlyPredictions(int months) {
    final now = DateTime.now();
    final data = <TimeSeriesData>[];
    
    for (int i = months - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final value = 800.0 + (i % 5) * 100.0; // Mock data with variation
      data.add(TimeSeriesData(
        date: date,
        value: value,
        label: '${date.year}-${date.month.toString().padLeft(2, '0')}',
      ));
    }
    
    return data;
  }

  Future<double> _calculatePaymentHealth(Database db) async {
    final results = await db.rawQuery('''
      SELECT 
        COUNT(*) as total,
        SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) as successful
      FROM payment_records
      WHERE created_at >= date('now', '-30 days')
    ''');

    final total = results.first['total'] as int? ?? 0;
    final successful = results.first['successful'] as int? ?? 0;

    return total > 0 ? (successful / total) * 100 : 100.0;
  }

  Future<double> _calculateUserEngagement(Database db) async {
    final results = await db.rawQuery('''
      SELECT 
        COUNT(*) as total,
        SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active
      FROM users
    ''');

    final total = results.first['total'] as int? ?? 0;
    final active = results.first['active'] as int? ?? 0;

    return total > 0 ? (active / total) * 100 : 0.0;
  }

  Future<double> _calculateSubscriptionHealth(Database db) async {
    final results = await db.rawQuery('''
      SELECT 
        COUNT(*) as total,
        SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active
      FROM subscriptions
    ''');

    final total = results.first['total'] as int? ?? 0;
    final active = results.first['active'] as int? ?? 0;

    return total > 0 ? (active / total) * 100 : 0.0;
  }

  Future<List<HealthAlert>> _generateHealthAlerts({
    required double paymentHealth,
    required double userEngagement,
    required double subscriptionHealth,
  }) async {
    final alerts = <HealthAlert>[];
    final now = DateTime.now();

    if (paymentHealth < 90) {
      alerts.add(HealthAlert(
        id: 'payment_health_low',
        type: HealthAlertType.payment,
        severity: paymentHealth < 80 ? HealthAlertSeverity.critical : HealthAlertSeverity.warning,
        message: 'Taxa de sucesso de pagamentos abaixo do esperado',
        details: 'Apenas ${paymentHealth.toStringAsFixed(1)}% dos pagamentos foram bem-sucedidos nos últimos 30 dias',
        createdAt: now,
      ));
    }

    if (userEngagement < 70) {
      alerts.add(HealthAlert(
        id: 'user_engagement_low',
        type: HealthAlertType.user,
        severity: userEngagement < 50 ? HealthAlertSeverity.critical : HealthAlertSeverity.warning,
        message: 'Engajamento de usuários abaixo do esperado',
        details: 'Apenas ${userEngagement.toStringAsFixed(1)}% dos usuários estão ativos',
        createdAt: now,
      ));
    }

    if (subscriptionHealth < 85) {
      alerts.add(HealthAlert(
        id: 'subscription_health_low',
        type: HealthAlertType.subscription,
        severity: subscriptionHealth < 75 ? HealthAlertSeverity.critical : HealthAlertSeverity.warning,
        message: 'Saúde de assinaturas abaixo do esperado',
        details: 'Apenas ${subscriptionHealth.toStringAsFixed(1)}% das assinaturas estão ativas',
        createdAt: now,
      ));
    }

    return alerts;
  }

  double _calculateHealthScore({
    required int activeUsers,
    required int totalUsers,
    required int overdueSubscriptions,
    required int totalSubscriptions,
  }) {
    final userScore = totalUsers > 0 ? (activeUsers / totalUsers) * 40 : 0.0;
    final subsScore = totalSubscriptions > 0
        ? ((totalSubscriptions - overdueSubscriptions) / totalSubscriptions) * 60
        : 60.0;
    
    return userScore + subsScore;
  }

  Future<void> _ensurePaymentsTableExists(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS payment_records (
        id TEXT PRIMARY KEY,
        subscription_id TEXT NOT NULL,
        amount REAL NOT NULL,
        status TEXT NOT NULL,
        transaction_id TEXT,
        payment_method TEXT,
        failure_reason TEXT,
        created_at TEXT NOT NULL,
        processed_at TEXT
      )
    ''');
  }
}

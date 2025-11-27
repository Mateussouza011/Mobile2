import 'package:equatable/equatable.dart';

/// Métricas gerais do sistema
class SystemMetrics extends Equatable {
  // Contadores principais
  final int totalUsers;
  final int activeUsers;
  final int totalCompanies;
  final int activeCompanies;
  final int totalSubscriptions;
  final int activeSubscriptions;
  
  // Métricas de receita
  final double totalRevenue;
  final double monthlyRecurringRevenue; // MRR
  final double averageRevenuePerUser; // ARPU
  final double averageRevenuePerAccount; // ARPA
  
  // Métricas de crescimento
  final int newUsersThisMonth;
  final int newCompaniesThisMonth;
  final double growthRate; // % de crescimento MoM
  final double churnRate; // % de cancelamentos
  
  // Métricas de uso
  final int totalPredictions;
  final int predictionsThisMonth;
  final int averagePredictionsPerUser;
  
  // Métricas de API (se houver)
  final int totalApiCalls;
  final int apiCallsThisMonth;
  final double apiSuccessRate;
  
  // Saúde do sistema
  final double systemHealthScore; // 0-100
  final int failedPayments;
  final int overdueSubscriptions;
  
  final DateTime calculatedAt;

  const SystemMetrics({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalCompanies,
    required this.activeCompanies,
    required this.totalSubscriptions,
    required this.activeSubscriptions,
    required this.totalRevenue,
    required this.monthlyRecurringRevenue,
    required this.averageRevenuePerUser,
    required this.averageRevenuePerAccount,
    required this.newUsersThisMonth,
    required this.newCompaniesThisMonth,
    required this.growthRate,
    required this.churnRate,
    required this.totalPredictions,
    required this.predictionsThisMonth,
    required this.averagePredictionsPerUser,
    required this.totalApiCalls,
    required this.apiCallsThisMonth,
    required this.apiSuccessRate,
    required this.systemHealthScore,
    required this.failedPayments,
    required this.overdueSubscriptions,
    required this.calculatedAt,
  });

  @override
  List<Object?> get props => [
        totalUsers,
        activeUsers,
        totalCompanies,
        activeCompanies,
        totalSubscriptions,
        activeSubscriptions,
        totalRevenue,
        monthlyRecurringRevenue,
        averageRevenuePerUser,
        averageRevenuePerAccount,
        newUsersThisMonth,
        newCompaniesThisMonth,
        growthRate,
        churnRate,
        totalPredictions,
        predictionsThisMonth,
        averagePredictionsPerUser,
        totalApiCalls,
        apiCallsThisMonth,
        apiSuccessRate,
        systemHealthScore,
        failedPayments,
        overdueSubscriptions,
        calculatedAt,
      ];
}

/// Dados de série temporal para gráficos
class TimeSeriesData extends Equatable {
  final DateTime date;
  final double value;
  final String? label;

  const TimeSeriesData({
    required this.date,
    required this.value,
    this.label,
  });

  @override
  List<Object?> get props => [date, value, label];
}

/// Métricas de receita ao longo do tempo
class RevenueMetrics extends Equatable {
  final List<TimeSeriesData> dailyRevenue; // Últimos 30 dias
  final List<TimeSeriesData> monthlyRevenue; // Últimos 12 meses
  final List<TimeSeriesData> mrrHistory; // MRR ao longo do tempo
  
  final double totalRevenueLastMonth;
  final double totalRevenueThisMonth;
  final double revenueGrowthRate;

  const RevenueMetrics({
    required this.dailyRevenue,
    required this.monthlyRevenue,
    required this.mrrHistory,
    required this.totalRevenueLastMonth,
    required this.totalRevenueThisMonth,
    required this.revenueGrowthRate,
  });

  @override
  List<Object?> get props => [
        dailyRevenue,
        monthlyRevenue,
        mrrHistory,
        totalRevenueLastMonth,
        totalRevenueThisMonth,
        revenueGrowthRate,
      ];
}

/// Métricas de crescimento de usuários
class UserGrowthMetrics extends Equatable {
  final List<TimeSeriesData> dailySignups; // Últimos 30 dias
  final List<TimeSeriesData> monthlySignups; // Últimos 12 meses
  final List<TimeSeriesData> activeUsersHistory;
  
  final int signupsLastMonth;
  final int signupsThisMonth;
  final double signupGrowthRate;

  const UserGrowthMetrics({
    required this.dailySignups,
    required this.monthlySignups,
    required this.activeUsersHistory,
    required this.signupsLastMonth,
    required this.signupsThisMonth,
    required this.signupGrowthRate,
  });

  @override
  List<Object?> get props => [
        dailySignups,
        monthlySignups,
        activeUsersHistory,
        signupsLastMonth,
        signupsThisMonth,
        signupGrowthRate,
      ];
}

/// Distribuição por plano
class TierDistribution extends Equatable {
  final int freeCount;
  final int proCount;
  final int enterpriseCount;
  
  final double freePercentage;
  final double proPercentage;
  final double enterprisePercentage;

  const TierDistribution({
    required this.freeCount,
    required this.proCount,
    required this.enterpriseCount,
    required this.freePercentage,
    required this.proPercentage,
    required this.enterprisePercentage,
  });

  int get total => freeCount + proCount + enterpriseCount;

  @override
  List<Object?> get props => [
        freeCount,
        proCount,
        enterpriseCount,
        freePercentage,
        proPercentage,
        enterprisePercentage,
      ];
}

/// Métricas de uso da plataforma
class UsageMetrics extends Equatable {
  final List<TimeSeriesData> dailyPredictions; // Últimos 30 dias
  final List<TimeSeriesData> monthlyPredictions; // Últimos 12 meses
  
  final int predictionsLastMonth;
  final int predictionsThisMonth;
  final double predictionsGrowthRate;
  
  final Map<String, int> predictionsByCompany; // Top 10 empresas
  final Map<String, int> predictionsByUser; // Top 10 usuários

  const UsageMetrics({
    required this.dailyPredictions,
    required this.monthlyPredictions,
    required this.predictionsLastMonth,
    required this.predictionsThisMonth,
    required this.predictionsGrowthRate,
    required this.predictionsByCompany,
    required this.predictionsByUser,
  });

  @override
  List<Object?> get props => [
        dailyPredictions,
        monthlyPredictions,
        predictionsLastMonth,
        predictionsThisMonth,
        predictionsGrowthRate,
        predictionsByCompany,
        predictionsByUser,
      ];
}

/// Métricas de saúde do sistema
class SystemHealthMetrics extends Equatable {
  final double overallHealth; // 0-100
  
  // Componentes de saúde
  final double paymentHealth; // % pagamentos bem-sucedidos
  final double userEngagement; // % usuários ativos
  final double subscriptionHealth; // % assinaturas ativas
  final double apiHealth; // % API calls bem-sucedidas
  
  // Alertas
  final int criticalIssues;
  final int warnings;
  final List<HealthAlert> alerts;

  const SystemHealthMetrics({
    required this.overallHealth,
    required this.paymentHealth,
    required this.userEngagement,
    required this.subscriptionHealth,
    required this.apiHealth,
    required this.criticalIssues,
    required this.warnings,
    required this.alerts,
  });

  @override
  List<Object?> get props => [
        overallHealth,
        paymentHealth,
        userEngagement,
        subscriptionHealth,
        apiHealth,
        criticalIssues,
        warnings,
        alerts,
      ];
}

/// Alerta de saúde do sistema
class HealthAlert extends Equatable {
  final String id;
  final HealthAlertType type;
  final HealthAlertSeverity severity;
  final String message;
  final String? details;
  final DateTime createdAt;

  const HealthAlert({
    required this.id,
    required this.type,
    required this.severity,
    required this.message,
    this.details,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, type, severity, message, details, createdAt];
}

enum HealthAlertType {
  payment,
  subscription,
  user,
  api,
  system,
}

enum HealthAlertSeverity {
  critical,
  warning,
  info,
}

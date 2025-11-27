import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Helper para gerenciar o banco de dados SQLite
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'radiance_b2b.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de empresas
    await db.execute('''
      CREATE TABLE companies (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        slug TEXT NOT NULL UNIQUE,
        logo TEXT,
        website TEXT,
        description TEXT,
        owner_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        settings TEXT
      )
    ''');

    // Tabela de roles
    await db.execute('''
      CREATE TABLE roles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT,
        permissions TEXT NOT NULL,
        is_custom INTEGER DEFAULT 0,
        company_id TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de usuários da empresa (relação many-to-many)
    await db.execute('''
      CREATE TABLE company_users (
        id TEXT PRIMARY KEY,
        company_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        role_id TEXT NOT NULL,
        status TEXT DEFAULT 'active',
        joined_at TEXT NOT NULL,
        invited_at TEXT,
        invited_by TEXT,
        last_access_at TEXT,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE,
        FOREIGN KEY (role_id) REFERENCES roles (id),
        UNIQUE(company_id, user_id)
      )
    ''');

    // Tabela de convites
    await db.execute('''
      CREATE TABLE invitations (
        id TEXT PRIMARY KEY,
        company_id TEXT NOT NULL,
        email TEXT NOT NULL,
        role_id TEXT NOT NULL,
        invited_by TEXT NOT NULL,
        invited_at TEXT NOT NULL,
        expires_at TEXT NOT NULL,
        token TEXT UNIQUE,
        is_accepted INTEGER DEFAULT 0,
        accepted_at TEXT,
        FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE,
        FOREIGN KEY (role_id) REFERENCES roles (id)
      )
    ''');

    // Tabela de assinaturas
    await db.execute('''
      CREATE TABLE subscriptions (
        id TEXT PRIMARY KEY,
        company_id TEXT NOT NULL,
        tier TEXT NOT NULL,
        status TEXT NOT NULL,
        billing_interval TEXT DEFAULT 'monthly',
        amount REAL NOT NULL,
        currency TEXT DEFAULT 'BRL',
        start_date TEXT NOT NULL,
        end_date TEXT,
        trial_ends_at TEXT,
        cancelled_at TEXT,
        current_period_start TEXT NOT NULL,
        current_period_end TEXT NOT NULL,
        next_billing_date TEXT,
        max_predictions_per_month INTEGER NOT NULL,
        max_users INTEGER NOT NULL,
        has_api_access INTEGER DEFAULT 0,
        has_export_features INTEGER DEFAULT 0,
        has_advanced_analytics INTEGER DEFAULT 0,
        has_white_label INTEGER DEFAULT 0,
        has_priority_support INTEGER DEFAULT 0,
        abacate_pay_subscription_id TEXT,
        abacate_pay_customer_id TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de histórico de predições (atualizada com company_id)
    await db.execute('''
      CREATE TABLE prediction_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        company_id TEXT,
        carat REAL NOT NULL,
        cut TEXT NOT NULL,
        color TEXT NOT NULL,
        clarity TEXT NOT NULL,
        depth REAL NOT NULL,
        table_value REAL NOT NULL,
        x REAL NOT NULL,
        y REAL NOT NULL,
        z REAL NOT NULL,
        predicted_price REAL NOT NULL,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE SET NULL
      )
    ''');

    // Tabela de rastreamento de uso (para limites de planos)
    await db.execute('''
      CREATE TABLE usage_tracking (
        id TEXT PRIMARY KEY,
        company_id TEXT NOT NULL,
        month TEXT NOT NULL,
        predictions_count INTEGER DEFAULT 0,
        api_calls_count INTEGER DEFAULT 0,
        exports_count INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE,
        UNIQUE(company_id, month)
      )
    ''');

    // Tabela de API keys (para plano Enterprise)
    await db.execute('''
      CREATE TABLE api_keys (
        id TEXT PRIMARY KEY,
        company_id TEXT NOT NULL,
        name TEXT NOT NULL,
        key_hash TEXT NOT NULL UNIQUE,
        prefix TEXT NOT NULL,
        created_by TEXT NOT NULL,
        created_at TEXT NOT NULL,
        expires_at TEXT,
        last_used_at TEXT,
        is_active INTEGER DEFAULT 1,
        FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de audit logs
    await db.execute('''
      CREATE TABLE audit_logs (
        id TEXT PRIMARY KEY,
        company_id TEXT,
        user_id TEXT NOT NULL,
        action TEXT NOT NULL,
        resource_type TEXT NOT NULL,
        resource_id TEXT,
        details TEXT,
        ip_address TEXT,
        user_agent TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE
      )
    ''');

    // Índices para melhor performance
    await db.execute('CREATE INDEX idx_companies_slug ON companies(slug)');
    await db.execute('CREATE INDEX idx_companies_owner ON companies(owner_id)');
    await db.execute('CREATE INDEX idx_company_users_company ON company_users(company_id)');
    await db.execute('CREATE INDEX idx_company_users_user ON company_users(user_id)');
    await db.execute('CREATE INDEX idx_company_users_status ON company_users(status)');
    await db.execute('CREATE INDEX idx_invitations_company ON invitations(company_id)');
    await db.execute('CREATE INDEX idx_invitations_email ON invitations(email)');
    await db.execute('CREATE INDEX idx_subscriptions_company ON subscriptions(company_id)');
    await db.execute('CREATE INDEX idx_subscriptions_status ON subscriptions(status)');
    await db.execute('CREATE INDEX idx_prediction_history_company ON prediction_history(company_id)');
    await db.execute('CREATE INDEX idx_prediction_history_user_timestamp ON prediction_history(user_id, timestamp DESC)');
    await db.execute('CREATE INDEX idx_usage_tracking_company_month ON usage_tracking(company_id, month)');
    await db.execute('CREATE INDEX idx_api_keys_company ON api_keys(company_id)');
    await db.execute('CREATE INDEX idx_audit_logs_company ON audit_logs(company_id)');
    await db.execute('CREATE INDEX idx_audit_logs_user ON audit_logs(user_id)');
    await db.execute('CREATE INDEX idx_audit_logs_created ON audit_logs(created_at)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migração da v1 para v2: Adicionar suporte multi-tenant
      
      // Adicionar company_id à tabela prediction_history
      await db.execute('ALTER TABLE prediction_history ADD COLUMN company_id TEXT');
      
      // Criar novas tabelas multi-tenant
      await db.execute('''
        CREATE TABLE IF NOT EXISTS companies (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          slug TEXT NOT NULL UNIQUE,
          logo TEXT,
          website TEXT,
          description TEXT,
          owner_id TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          is_active INTEGER DEFAULT 1,
          settings TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS roles (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          type TEXT NOT NULL,
          description TEXT,
          permissions TEXT NOT NULL,
          is_custom INTEGER DEFAULT 0,
          company_id TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS company_users (
          id TEXT PRIMARY KEY,
          company_id TEXT NOT NULL,
          user_id TEXT NOT NULL,
          role_id TEXT NOT NULL,
          status TEXT DEFAULT 'active',
          joined_at TEXT NOT NULL,
          invited_at TEXT,
          invited_by TEXT,
          last_access_at TEXT,
          updated_at TEXT NOT NULL,
          FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE,
          FOREIGN KEY (role_id) REFERENCES roles (id),
          UNIQUE(company_id, user_id)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS invitations (
          id TEXT PRIMARY KEY,
          company_id TEXT NOT NULL,
          email TEXT NOT NULL,
          role_id TEXT NOT NULL,
          invited_by TEXT NOT NULL,
          invited_at TEXT NOT NULL,
          expires_at TEXT NOT NULL,
          token TEXT UNIQUE,
          is_accepted INTEGER DEFAULT 0,
          accepted_at TEXT,
          FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE,
          FOREIGN KEY (role_id) REFERENCES roles (id)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS subscriptions (
          id TEXT PRIMARY KEY,
          company_id TEXT NOT NULL,
          tier TEXT NOT NULL,
          status TEXT NOT NULL,
          billing_interval TEXT DEFAULT 'monthly',
          amount REAL NOT NULL,
          currency TEXT DEFAULT 'BRL',
          start_date TEXT NOT NULL,
          end_date TEXT,
          trial_ends_at TEXT,
          cancelled_at TEXT,
          current_period_start TEXT NOT NULL,
          current_period_end TEXT NOT NULL,
          next_billing_date TEXT,
          max_predictions_per_month INTEGER NOT NULL,
          max_users INTEGER NOT NULL,
          has_api_access INTEGER DEFAULT 0,
          has_export_features INTEGER DEFAULT 0,
          has_advanced_analytics INTEGER DEFAULT 0,
          has_white_label INTEGER DEFAULT 0,
          has_priority_support INTEGER DEFAULT 0,
          abacate_pay_subscription_id TEXT,
          abacate_pay_customer_id TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS usage_tracking (
          id TEXT PRIMARY KEY,
          company_id TEXT NOT NULL,
          month TEXT NOT NULL,
          predictions_count INTEGER DEFAULT 0,
          api_calls_count INTEGER DEFAULT 0,
          exports_count INTEGER DEFAULT 0,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE,
          UNIQUE(company_id, month)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS api_keys (
          id TEXT PRIMARY KEY,
          company_id TEXT NOT NULL,
          name TEXT NOT NULL,
          key_hash TEXT NOT NULL UNIQUE,
          prefix TEXT NOT NULL,
          created_by TEXT NOT NULL,
          created_at TEXT NOT NULL,
          expires_at TEXT,
          last_used_at TEXT,
          is_active INTEGER DEFAULT 1,
          FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS audit_logs (
          id TEXT PRIMARY KEY,
          company_id TEXT,
          user_id TEXT NOT NULL,
          action TEXT NOT NULL,
          resource_type TEXT NOT NULL,
          resource_id TEXT,
          details TEXT,
          ip_address TEXT,
          user_agent TEXT,
          created_at TEXT NOT NULL,
          FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE
        )
      ''');

      // Criar índices
      await db.execute('CREATE INDEX IF NOT EXISTS idx_companies_slug ON companies(slug)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_companies_owner ON companies(owner_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_company_users_company ON company_users(company_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_company_users_user ON company_users(user_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_company_users_status ON company_users(status)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_invitations_company ON invitations(company_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_invitations_email ON invitations(email)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_subscriptions_company ON subscriptions(company_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_subscriptions_status ON subscriptions(status)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_prediction_history_company ON prediction_history(company_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_usage_tracking_company_month ON usage_tracking(company_id, month)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_api_keys_company ON api_keys(company_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_audit_logs_company ON audit_logs(company_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_audit_logs_user ON audit_logs(user_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_audit_logs_created ON audit_logs(created_at)');
    }
  }

  /// Fecha o banco de dados
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Limpa todas as tabelas (útil para testes)
  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete('audit_logs');
    await db.delete('api_keys');
    await db.delete('usage_tracking');
    await db.delete('prediction_history');
    await db.delete('subscriptions');
    await db.delete('invitations');
    await db.delete('company_users');
    await db.delete('roles');
    await db.delete('companies');
  }
}

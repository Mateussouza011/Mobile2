import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Test Helpers for Admin Panel Testing
/// 
/// This file provides database helpers for testing the admin panel features.

class TestHelpers {
  // ==================== DATABASE HELPERS ====================
  
  /// Creates an in-memory test database matching production schema
  static Future<Database> createTestDatabase() async {
    return await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        // Companies table (with email for repository compatibility)
        await db.execute('''
          CREATE TABLE companies (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            slug TEXT NOT NULL UNIQUE,
            email TEXT,
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

        // Users table (matching actual User entity)
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            avatar_url TEXT,
            phone TEXT,
            is_admin INTEGER DEFAULT 0,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            is_active INTEGER DEFAULT 1,
            current_company_id TEXT,
            current_role_id TEXT,
            last_login TEXT
          )
        ''');

        // Roles table
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

        // Company users table (many-to-many)
        await db.execute('''
          CREATE TABLE company_users (
            id TEXT PRIMARY KEY,
            company_id TEXT NOT NULL,
            user_id TEXT NOT NULL,
            role_id TEXT NOT NULL,
            role TEXT NOT NULL,
            status TEXT DEFAULT 'active',
            is_active INTEGER DEFAULT 1,
            joined_at TEXT NOT NULL,
            invited_at TEXT,
            invited_by TEXT,
            last_access_at TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT,
            FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE,
            FOREIGN KEY (role_id) REFERENCES roles (id),
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
            UNIQUE(company_id, user_id)
          )
        ''');

        // Subscriptions table (production schema)
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

        // Prediction history table (adapted for repository queries)
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
            created_at TEXT NOT NULL,
            FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE SET NULL
          )
        ''');

        // Audit logs table
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

        // Indices
        await db.execute('CREATE INDEX idx_company_users_company ON company_users(company_id)');
        await db.execute('CREATE INDEX idx_company_users_user ON company_users(user_id)');
        await db.execute('CREATE INDEX idx_subscriptions_company ON subscriptions(company_id)');
        await db.execute('CREATE INDEX idx_prediction_history_company ON prediction_history(company_id)');
      },
    );
  }

  /// Seeds test database with sample data
  static Future<void> seedTestDatabase(Database db) async {
    final now = DateTime.now();
    
    // Insert test companies (with email for repository compatibility)
    await db.insert('companies', {
      'id': 'company-1',
      'name': 'Diamond Corp',
      'slug': 'diamond-corp',
      'email': 'contact@diamond.com',
      'logo': null,
      'website': 'https://diamond.com',
      'description': 'Leading diamond trading company',
      'owner_id': 'owner-1',
      'created_at': DateTime(2024, 1, 1).toIso8601String(),
      'updated_at': DateTime(2024, 1, 1).toIso8601String(),
      'is_active': 1,
      'settings': null,
    });

    await db.insert('companies', {
      'id': 'company-2',
      'name': 'Gem Trading Inc',
      'slug': 'gem-trading-inc',
      'email': 'info@gemtrading.com',
      'logo': null,
      'website': 'https://gemtrading.com',
      'description': 'Gem trading specialists',
      'owner_id': 'owner-2',
      'created_at': DateTime(2024, 2, 1).toIso8601String(),
      'updated_at': DateTime(2024, 2, 1).toIso8601String(),
      'is_active': 1,
      'settings': null,
    });

    await db.insert('companies', {
      'id': 'company-3',
      'name': 'Inactive Company',
      'slug': 'inactive-company',
      'email': 'old@company.com',
      'logo': null,
      'website': null,
      'description': 'Inactive test company',
      'owner_id': 'owner-3',
      'created_at': DateTime(2023, 1, 1).toIso8601String(),
      'updated_at': DateTime(2023, 6, 1).toIso8601String(),
      'is_active': 0,
      'settings': null,
    });

    // Insert test roles
    await db.insert('roles', {
      'id': 'role-admin',
      'name': 'Admin',
      'type': 'predefined',
      'description': 'Administrator role',
      'permissions': '["all"]',
      'is_custom': 0,
      'company_id': null,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    });

    await db.insert('roles', {
      'id': 'role-user',
      'name': 'User',
      'type': 'predefined',
      'description': 'Regular user role',
      'permissions': '["read","predict"]',
      'is_custom': 0,
      'company_id': null,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    });

    // Insert test users
    await db.insert('users', {
      'id': 'user-1',
      'name': 'John Admin',
      'email': 'john@diamond.com',
      'avatar_url': null,
      'phone': '+55 11 99999-0001',
      'is_admin': 0,
      'created_at': DateTime(2024, 1, 1).toIso8601String(),
      'updated_at': DateTime(2024, 11, 27).toIso8601String(),
      'is_active': 1,
      'current_company_id': 'company-1',
      'current_role_id': 'role-admin',
      'last_login': DateTime(2024, 11, 27, 10, 30).toIso8601String(),
    });

    await db.insert('users', {
      'id': 'user-2',
      'name': 'Jane User',
      'email': 'jane@diamond.com',
      'avatar_url': null,
      'phone': '+55 11 99999-0002',
      'is_admin': 0,
      'created_at': DateTime(2024, 1, 2).toIso8601String(),
      'updated_at': DateTime(2024, 11, 26).toIso8601String(),
      'is_active': 1,
      'current_company_id': 'company-1',
      'current_role_id': 'role-user',
      'last_login': DateTime(2024, 11, 26, 15, 45).toIso8601String(),
    });

    await db.insert('users', {
      'id': 'user-3',
      'name': 'Bob Analyst',
      'email': 'bob@gemtrading.com',
      'avatar_url': null,
      'phone': '+55 11 99999-0003',
      'is_admin': 0,
      'created_at': DateTime(2024, 2, 1).toIso8601String(),
      'updated_at': DateTime(2024, 11, 25).toIso8601String(),
      'is_active': 1,
      'current_company_id': 'company-2',
      'current_role_id': 'role-admin',
      'last_login': DateTime(2024, 11, 25, 9, 15).toIso8601String(),
    });

    await db.insert('users', {
      'id': 'user-4',
      'name': 'Disabled User',
      'email': 'disabled@test.com',
      'avatar_url': null,
      'phone': null,
      'is_admin': 0,
      'created_at': DateTime(2024, 1, 15).toIso8601String(),
      'updated_at': DateTime(2024, 10, 15).toIso8601String(),
      'is_active': 0,
      'current_company_id': null,
      'current_role_id': null,
      'last_login': DateTime(2024, 10, 1).toIso8601String(),
    });

    // Insert test company_users (this creates the relationship)
    await db.insert('company_users', {
      'id': 'cu-1',
      'company_id': 'company-1',
      'user_id': 'user-1',
      'role_id': 'role-admin',
      'role': 'admin',
      'status': 'active',
      'is_active': 1,
      'joined_at': DateTime(2024, 1, 2).toIso8601String(),
      'invited_at': null,
      'invited_by': null,
      'last_access_at': DateTime(2024, 11, 27).toIso8601String(),
      'created_at': DateTime(2024, 1, 2).toIso8601String(),
      'updated_at': DateTime(2024, 11, 27).toIso8601String(),
    });

    await db.insert('company_users', {
      'id': 'cu-2',
      'company_id': 'company-1',
      'user_id': 'user-2',
      'role_id': 'role-user',
      'role': 'user',
      'status': 'active',
      'is_active': 1,
      'joined_at': DateTime(2024, 1, 3).toIso8601String(),
      'invited_at': DateTime(2024, 1, 2).toIso8601String(),
      'invited_by': 'user-1',
      'last_access_at': DateTime(2024, 11, 26).toIso8601String(),
      'created_at': DateTime(2024, 1, 3).toIso8601String(),
      'updated_at': DateTime(2024, 11, 26).toIso8601String(),
    });

    await db.insert('company_users', {
      'id': 'cu-3',
      'company_id': 'company-2',
      'user_id': 'user-3',
      'role_id': 'role-admin',
      'role': 'admin',
      'status': 'active',
      'is_active': 1,
      'joined_at': DateTime(2024, 2, 2).toIso8601String(),
      'invited_at': null,
      'invited_by': null,
      'last_access_at': null,
      'created_at': DateTime(2024, 2, 2).toIso8601String(),
      'updated_at': DateTime(2024, 2, 2).toIso8601String(),
    });

    // Insert test subscriptions (matching production schema)
    await db.insert('subscriptions', {
      'id': 'sub-1',
      'company_id': 'company-1',
      'tier': 'pro',
      'status': 'active',
      'billing_interval': 'monthly',
      'amount': 29999.0, // R$ 299.99 in cents
      'currency': 'BRL',
      'start_date': DateTime(2024, 1, 1).toIso8601String(),
      'end_date': null,
      'trial_ends_at': null,
      'cancelled_at': null,
      'current_period_start': DateTime(2024, 11, 1).toIso8601String(),
      'current_period_end': DateTime(2024, 12, 1).toIso8601String(),
      'next_billing_date': DateTime(2024, 12, 1).toIso8601String(),
      'max_predictions_per_month': 1000,
      'max_users': 10,
      'has_api_access': 0,
      'has_export_features': 1,
      'has_advanced_analytics': 1,
      'has_white_label': 0,
      'has_priority_support': 0,
      'abacate_pay_subscription_id': null,
      'abacate_pay_customer_id': null,
      'created_at': DateTime(2024, 1, 1).toIso8601String(),
      'updated_at': DateTime(2024, 11, 1).toIso8601String(),
    });

    await db.insert('subscriptions', {
      'id': 'sub-2',
      'company_id': 'company-2',
      'tier': 'pro',
      'status': 'active',
      'billing_interval': 'monthly',
      'amount': 14999.0, // R$ 149.99 in cents
      'currency': 'BRL',
      'start_date': DateTime(2024, 2, 1).toIso8601String(),
      'end_date': null,
      'trial_ends_at': null,
      'cancelled_at': null,
      'current_period_start': DateTime(2024, 11, 1).toIso8601String(),
      'current_period_end': DateTime(2024, 12, 1).toIso8601String(),
      'next_billing_date': DateTime(2024, 12, 1).toIso8601String(),
      'max_predictions_per_month': 500,
      'max_users': 5,
      'has_api_access': 0,
      'has_export_features': 1,
      'has_advanced_analytics': 1,
      'has_white_label': 0,
      'has_priority_support': 0,
      'abacate_pay_subscription_id': null,
      'abacate_pay_customer_id': null,
      'created_at': DateTime(2024, 2, 1).toIso8601String(),
      'updated_at': DateTime(2024, 11, 1).toIso8601String(),
    });

    // Insert some test prediction history
    await db.insert('prediction_history', {
      'user_id': 'user-1',
      'company_id': 'company-1',
      'carat': 1.5,
      'cut': 'Ideal',
      'color': 'E',
      'clarity': 'VS1',
      'depth': 62.5,
      'table_value': 57.0,
      'x': 7.5,
      'y': 7.48,
      'z': 4.68,
      'predicted_price': 12500.0,
      'created_at': DateTime(2024, 11, 20).toIso8601String(),
    });

    await db.insert('prediction_history', {
      'user_id': 'user-2',
      'company_id': 'company-1',
      'carat': 2.0,
      'cut': 'Premium',
      'color': 'F',
      'clarity': 'VS2',
      'depth': 61.0,
      'table_value': 58.0,
      'x': 8.1,
      'y': 8.05,
      'z': 4.95,
      'predicted_price': 18000.0,
      'created_at': DateTime(2024, 11, 25).toIso8601String(),
    });
  }

  /// Cleans up test database
  static Future<void> cleanupTestDatabase(Database db) async {
    // Delete in order of dependencies (child tables first)
    await db.delete('audit_logs');
    await db.delete('prediction_history');
    await db.delete('subscriptions');
    await db.delete('company_users');
    await db.delete('users');
    await db.delete('roles');
    await db.delete('companies');
  }

}

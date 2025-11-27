import 'package:equatable/equatable.dart';

/// Estatísticas de uso da equipe
class TeamStats extends Equatable {
  final int totalPredictions;
  final int predictionsThisMonth;
  final int activeMembers;
  final int totalMembers;
  final double avgPredictionsPerMember;
  final DateTime period;

  const TeamStats({
    required this.totalPredictions,
    required this.predictionsThisMonth,
    required this.activeMembers,
    required this.totalMembers,
    required this.avgPredictionsPerMember,
    required this.period,
  });

  @override
  List<Object?> get props => [
        totalPredictions,
        predictionsThisMonth,
        activeMembers,
        totalMembers,
        avgPredictionsPerMember,
        period,
      ];
}

/// Atividade de um membro da equipe
class MemberActivity extends Equatable {
  final String userId;
  final String userName;
  final int predictionsCount;
  final DateTime? lastActivity;
  final List<DailyActivity> dailyActivities;

  const MemberActivity({
    required this.userId,
    required this.userName,
    required this.predictionsCount,
    this.lastActivity,
    this.dailyActivities = const [],
  });

  @override
  List<Object?> get props => [
        userId,
        userName,
        predictionsCount,
        lastActivity,
        dailyActivities,
      ];
}

/// Atividade diária
class DailyActivity extends Equatable {
  final DateTime date;
  final int count;

  const DailyActivity({
    required this.date,
    required this.count,
  });

  @override
  List<Object?> get props => [date, count];
}

/// Uso de recursos da empresa
class ResourceUsage extends Equatable {
  final int predictionsUsed;
  final int predictionsLimit;
  final int membersUsed;
  final int membersLimit;
  final int storageUsedMB;
  final int storageLimitMB;

  const ResourceUsage({
    required this.predictionsUsed,
    required this.predictionsLimit,
    required this.membersUsed,
    required this.membersLimit,
    required this.storageUsedMB,
    required this.storageLimitMB,
  });

  double get predictionsPercentage =>
      predictionsLimit > 0 ? (predictionsUsed / predictionsLimit) * 100 : 0;

  double get membersPercentage =>
      membersLimit > 0 ? (membersUsed / membersLimit) * 100 : 0;

  double get storagePercentage =>
      storageLimitMB > 0 ? (storageUsedMB / storageLimitMB) * 100 : 0;

  @override
  List<Object?> get props => [
        predictionsUsed,
        predictionsLimit,
        membersUsed,
        membersLimit,
        storageUsedMB,
        storageLimitMB,
      ];
}

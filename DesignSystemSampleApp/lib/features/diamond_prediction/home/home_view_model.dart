import 'package:flutter/foundation.dart';
import '../../../core/data/models/user_model.dart';
import '../../../core/data/models/prediction_model.dart';

class HomeViewModel extends ChangeNotifier {
  UserModel? _currentUser;
  int _totalPredictions = 0;
  double _averagePrice = 0.0;
  PredictionHistoryModel? _lastPrediction;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  int get totalPredictions => _totalPredictions;
  double get averagePrice => _averagePrice;
  PredictionHistoryModel? get lastPrediction => _lastPrediction;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  void setStats({
    required int totalPredictions,
    required double averagePrice,
    PredictionHistoryModel? lastPrediction,
  }) {
    _totalPredictions = totalPredictions;
    _averagePrice = averagePrice;
    _lastPrediction = lastPrediction;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

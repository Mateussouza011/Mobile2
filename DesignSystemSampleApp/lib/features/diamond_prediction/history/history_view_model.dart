import 'package:flutter/foundation.dart';
import '../../../core/data/models/prediction_model.dart';

class HistoryViewModel extends ChangeNotifier {
  List<PredictionHistoryModel> _predictions = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;
  static const int _pageSize = 20;

  List<PredictionHistoryModel> get predictions => _predictions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  int get pageSize => _pageSize;

  void setPredictions(List<PredictionHistoryModel> predictions, {bool append = false}) {
    if (append) {
      _predictions = [..._predictions, ...predictions];
    } else {
      _predictions = predictions;
    }
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

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setHasMore(bool hasMore) {
    _hasMore = hasMore;
    notifyListeners();
  }

  void removePrediction(int id) {
    _predictions.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void reset() {
    _predictions = [];
    _isLoading = false;
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }
}

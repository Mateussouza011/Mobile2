import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:designsystemsampleapp/domain/entities/diamond_prediction.dart';
import 'package:designsystemsampleapp/domain/usecases/get_prediction.dart';
import 'package:designsystemsampleapp/domain/usecases/save_prediction.dart';
import 'package:designsystemsampleapp/domain/usecases/get_prediction_history.dart';
import 'package:designsystemsampleapp/presentation/viewmodels/diamond_prediction_viewmodel.dart';
import 'package:designsystemsampleapp/core/errors/failures.dart';

import 'diamond_prediction_viewmodel_test.mocks.dart';

@GenerateMocks([
  GetPredictionUseCase,
  SavePredictionUseCase,
  GetPredictionHistoryUseCase,
])
void main() {
  late DiamondPredictionViewModel viewModel;
  late MockGetPredictionUseCase mockGetPredictionUseCase;
  late MockSavePredictionUseCase mockSavePredictionUseCase;
  late MockGetPredictionHistoryUseCase mockGetPredictionHistoryUseCase;

  setUp(() {
    mockGetPredictionUseCase = MockGetPredictionUseCase();
    mockSavePredictionUseCase = MockSavePredictionUseCase();
    mockGetPredictionHistoryUseCase = MockGetPredictionHistoryUseCase();

    viewModel = DiamondPredictionViewModel(
      getPredictionUseCase: mockGetPredictionUseCase,
      savePredictionUseCase: mockSavePredictionUseCase,
      getPredictionHistoryUseCase: mockGetPredictionHistoryUseCase,
    );
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('DiamondPredictionViewModel', () {
    final tPrediction = DiamondPrediction(
      carat: 1.0,
      cut: 'Ideal',
      color: 'D',
      clarity: 'IF',
      depth: 61.5,
      table: 57.0,
      x: 5.0,
      y: 5.0,
      z: 3.0,
      predictedPrice: 5000.0,
      timestamp: DateTime(2025, 11, 27),
    );

    final tParams = PredictionParams(
      carat: 1.0,
      cut: 'Ideal',
      color: 'D',
      clarity: 'IF',
      depth: 61.5,
      table: 57.0,
      x: 5.0,
      y: 5.0,
      z: 3.0,
    );

    test('should start with initial state', () {
      expect(viewModel.state, PredictionState.initial);
      expect(viewModel.currentPrediction, null);
      expect(viewModel.errorMessage, null);
      expect(viewModel.isLoading, false);
    });

    test('should emit loading then success when prediction succeeds', () async {
      // arrange
      when(mockGetPredictionUseCase(any))
          .thenAnswer((_) async => Right(tPrediction));
      when(mockSavePredictionUseCase(any, any))
          .thenAnswer((_) async => const Right(null));
      when(mockGetPredictionHistoryUseCase(any))
          .thenAnswer((_) async => const Right([]));

      // act
      await viewModel.predict();

      // assert
      expect(viewModel.state, PredictionState.success);
      expect(viewModel.currentPrediction, tPrediction);
      expect(viewModel.errorMessage, null);
    });

    test('should emit loading then error when prediction fails', () async {
      // arrange
      when(mockGetPredictionUseCase(any))
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // act
      await viewModel.predict();

      // assert
      expect(viewModel.state, PredictionState.error);
      expect(viewModel.currentPrediction, null);
      expect(viewModel.errorMessage, 'Server error');
    });

    test('should update form values correctly', () {
      // act
      viewModel.setCarat(2.0);
      viewModel.setCut('Premium');
      viewModel.setColor('E');
      viewModel.setClarity('VS1');

      // assert
      expect(viewModel.carat, 2.0);
      expect(viewModel.cut, 'Premium');
      expect(viewModel.color, 'E');
      expect(viewModel.clarity, 'VS1');
    });

    test('should reset form to default values', () {
      // arrange
      viewModel.setCarat(2.0);
      viewModel.setCut('Premium');

      // act
      viewModel.resetForm();

      // assert
      expect(viewModel.carat, 1.0);
      expect(viewModel.cut, 'Ideal');
      expect(viewModel.state, PredictionState.initial);
    });

    test('should clear result correctly', () {
      // arrange
      viewModel.predict();

      // act
      viewModel.clearResult();

      // assert
      expect(viewModel.currentPrediction, null);
      expect(viewModel.state, PredictionState.initial);
      expect(viewModel.errorMessage, null);
    });
  });
}

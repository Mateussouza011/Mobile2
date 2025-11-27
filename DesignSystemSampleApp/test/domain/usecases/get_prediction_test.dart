import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:designsystemsampleapp/core/errors/failures.dart';
import 'package:designsystemsampleapp/domain/entities/diamond_prediction.dart';
import 'package:designsystemsampleapp/domain/repositories/prediction_repository.dart';
import 'package:designsystemsampleapp/domain/usecases/get_prediction.dart';

import 'get_prediction_test.mocks.dart';

@GenerateMocks([PredictionRepository])
void main() {
  late GetPredictionUseCase usecase;
  late MockPredictionRepository mockRepository;

  setUp(() {
    mockRepository = MockPredictionRepository();
    usecase = GetPredictionUseCase(mockRepository);
  });

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

  test('should get prediction from repository', () async {
    // arrange
    when(mockRepository.getPrediction(
      carat: anyNamed('carat'),
      cut: anyNamed('cut'),
      color: anyNamed('color'),
      clarity: anyNamed('clarity'),
      depth: anyNamed('depth'),
      table: anyNamed('table'),
      x: anyNamed('x'),
      y: anyNamed('y'),
      z: anyNamed('z'),
    )).thenAnswer((_) async => Right(tPrediction));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, Right(tPrediction));
    verify(mockRepository.getPrediction(
      carat: tParams.carat,
      cut: tParams.cut,
      color: tParams.color,
      clarity: tParams.clarity,
      depth: tParams.depth,
      table: tParams.table,
      x: tParams.x,
      y: tParams.y,
      z: tParams.z,
    ));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return validation failure for invalid carat', () async {
    // arrange
    final invalidParams = PredictionParams(
      carat: -1.0, // Invalid
      cut: 'Ideal',
      color: 'D',
      clarity: 'IF',
      depth: 61.5,
      table: 57.0,
      x: 5.0,
      y: 5.0,
      z: 3.0,
    );

    // act
    final result = await usecase(invalidParams);

    // assert
    expect(result, const Left(ValidationFailure('Quilates deve ser maior que 0')));
    verifyZeroInteractions(mockRepository);
  });

  test('should return validation failure for invalid depth', () async {
    // arrange
    final invalidParams = PredictionParams(
      carat: 1.0,
      cut: 'Ideal',
      color: 'D',
      clarity: 'IF',
      depth: 150.0, // Invalid (> 100)
      table: 57.0,
      x: 5.0,
      y: 5.0,
      z: 3.0,
    );

    // act
    final result = await usecase(invalidParams);

    // assert
    expect(result, const Left(ValidationFailure('Profundidade inválida')));
    verifyZeroInteractions(mockRepository);
  });
}

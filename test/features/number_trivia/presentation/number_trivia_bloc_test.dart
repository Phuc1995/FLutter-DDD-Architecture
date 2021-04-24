import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_with_tdd/core/error/failures.dart';
import 'package:flutter_with_tdd/core/ultil/input_converter.dart';
import 'package:flutter_with_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_with_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_with_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_with_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_with_tdd/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:flutter_with_tdd/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be emty', (){
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', (){
    final tNumberString = "1";
    final tNumberPasred = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() => when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberPasred));
    
    test('should call the InputConverter to validate and convert the string to an unsigned integer', () async {
      setUpMockInputConverterSuccess();
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emmit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));
      final expected = [
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      bloc.add(GetTriviaForConcreteNumber(tNumberString));

      expectLater(bloc.state, emitsInAnyOrder(expected));
    });

    test('should get data from the concrete use case', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));

      await untilCalled(mockGetConcreteNumberTrivia(any));

      verify(mockGetConcreteNumberTrivia(Params(number: tNumberPasred)));

    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));

      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];

      expectLater(bloc.state, emitsInAnyOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberString));

    });

    test('should emit [Loading, Error] when getting data fails', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));

      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];

      expectLater(bloc.state, emitsInAnyOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberString));

    });

    test('should emit [Loading, Error] when a proper message for the error when getting data fails', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));

      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];

      expectLater(bloc.state, emitsInAnyOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberString));

    });
  });

  group('GetTriviaForRandomNumber', (){
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    // void setUpMockInputConverterSuccess() => when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberPasred));

    test('should get data from the random use case', () async {
      // setUpMockInputConverterSuccess();
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForRandomNumber());

      await untilCalled(mockGetRandomNumberTrivia(any));

      verify(mockGetRandomNumberTrivia(NoParams()));

    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      // setUpMockInputConverterSuccess();
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForRandomNumber());

      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];

      expectLater(bloc.state, emitsInAnyOrder(expected));
      bloc.add(GetTriviaForRandomNumber());

    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // setUpMockInputConverterSuccess();
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async =>  Left(ServerFailure()));

      bloc.add(GetTriviaForRandomNumber());

      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];

      expectLater(bloc.state, emitsInAnyOrder(expected));
      bloc.add(GetTriviaForRandomNumber());

    });

    test('should emit [Loading, Error] when a proper message for the error when getting data fails', () async {
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async =>  Left(CacheFailure()));

      bloc.add(GetTriviaForRandomNumber());

      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];

      expectLater(bloc.state, emitsInAnyOrder(expected));
      bloc.add(GetTriviaForRandomNumber());

    });
  });

}

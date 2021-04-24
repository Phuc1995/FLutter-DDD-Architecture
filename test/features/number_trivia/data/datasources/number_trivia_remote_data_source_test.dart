import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_with_tdd/core/error/exceptions.dart';
import 'package:flutter_with_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_with_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_with_tdd/features/number_trivia/data/models/number_trivial.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart' as matcher;
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSusscess200(){
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixtures('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404(){
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixtures('trivia.json')));
    test(
        'Should perform a GET request on a URL with number being the enpoint and with application/json',
            () async {
            setUpMockHttpClientSusscess200();

          dataSource.getConcreteNumberTrivia(tNumber);

          verify(
            mockHttpClient.get('http://numbersapi.com/$tNumber',
                headers: {'Content-Type': 'application/json'}),
          );
        });
    
    test('should return Numbertrivia when the respone code is 200', () async {
      setUpMockHttpClientSusscess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return a ServerException when the respone code is 404 or other', () async {
      setUpMockHttpClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(matcher.TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixtures('trivia.json')));
    test(
        'Should perform a GET request on a URL with number being the enpoint and with application/json',
            () async {
          setUpMockHttpClientSusscess200();

          dataSource.getRandomNumberTrivia();

          verify(
            mockHttpClient.get('http://numbersapi.com/random',
                headers: {'Content-Type': 'application/json'}),
          );
        });

    test('should return Numbertrivia when the respone code is 200', () async {
      setUpMockHttpClientSusscess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return a ServerException when the respone code is 404 or other', () async {
      setUpMockHttpClientFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(matcher.TypeMatcher<ServerException>()));
    });
  });
}

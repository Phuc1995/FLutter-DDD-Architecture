import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_with_tdd/core/error/exceptions.dart';
import 'package:flutter_with_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_with_tdd/features/number_trivia/data/models/number_trivial.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart' as matcher;

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixtures('trivia_cached.json')));

    test(
        "should return NumberTrivia from SharedPrefernences when there is one in the cache",
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixtures('trivia_cached.json'));

      final result = await dataSource.getLastNumbertrivia();

      verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, equals(tNumberTriviaModel));
    });

    test(
      'should throw a CacheExeption when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastNumbertrivia;
        // assert
        expect(() => call(), throwsA(matcher.TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'text trivia', number: 1);

    test('should call SharedPreference to cache the data', () async {
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      final expectedString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedString));
    });
  });
}

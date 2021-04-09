import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_with_tdd/features/number_trivia/data/models/number_trivial.dart';
import 'package:flutter_with_tdd/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(text: "Text test", number: 1);

  test('should be a subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a vaild model when the Json number is an integer',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(fixtures('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });

    test('should return a vaild model when the Json number is an double',
        () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixtures('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tNumberTriviaModel.toJson();

      final expectedMap = {
        "text": "Text test",
        "number": 1,
      };

      expect(result, expectedMap);
    });
  });
}

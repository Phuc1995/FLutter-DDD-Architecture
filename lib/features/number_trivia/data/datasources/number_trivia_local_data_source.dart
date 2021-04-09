import 'package:flutter_with_tdd/features/number_trivia/data/models/number_trivial.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumbertrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
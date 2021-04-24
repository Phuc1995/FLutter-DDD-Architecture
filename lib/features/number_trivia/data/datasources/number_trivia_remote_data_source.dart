import 'dart:convert';

import 'package:flutter_with_tdd/core/error/exceptions.dart';
import 'package:flutter_with_tdd/features/number_trivia/data/models/number_trivial.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async => _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async => _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async{
    final respponse = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if(respponse.statusCode == 200){
      return NumberTriviaModel.fromJson(json.decode(respponse.body));
    } else {
      throw ServerException();
    }
  }
}
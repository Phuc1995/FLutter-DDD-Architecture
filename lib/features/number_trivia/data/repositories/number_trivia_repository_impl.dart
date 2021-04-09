
import 'package:dartz/dartz.dart';
import 'package:flutter_with_tdd/core/error/failures.dart';
import 'package:flutter_with_tdd/core/platform/network_info.dart';
import 'package:flutter_with_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_with_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_with_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_with_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository{
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  NumberTriviaRepositoryImpl(this.remoteDataSource, this.localDataSource, this.networkInfo);

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
  
}
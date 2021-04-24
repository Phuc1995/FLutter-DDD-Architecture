
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_with_tdd/core/ultil/input_converter.dart';

void main(){
  InputConverter inputConverter;

  setUp((){
    inputConverter = InputConverter();
  });
  
  group('stringToUnsignedInt', () {
    test('should return an integer when the string represents an unsigned integer', () async {
      final str = '123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Right(123));
    });

    test('should return an Failure when the string is not an integer', () async {
      final str = '-1.2';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
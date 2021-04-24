
import 'package:flutter/material.dart';
import 'package:flutter_with_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_with_tdd/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
class TriviaControls extends StatefulWidget {
  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: "Input a number"),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_){
            dispathchConcrete();
          },
        ),

        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: RaisedButton(
                  child: Text("Search"),
                  color: Theme.of(context).accentColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: dispathchConcrete,
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: RaisedButton(
                  child: Text("Get random trivia"),
                  color: Theme.of(context).accentColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: dispathchRandom,
                ))
          ],
        )
      ],
    );
  }

  void dispathchConcrete(){
    controller.clear();
    bloc.BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispathchRandom(){
    controller.clear();
    bloc.BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_with_tdd/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_with_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_with_tdd/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:flutter_with_tdd/features/number_trivia/presentation/widgets/widgets.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: bloc.BlocProvider(
          create: (_) => sl<NumberTriviaBloc>(),
          child: buildBody(context),
        ),
      ),
    );
  }

  bloc.BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return bloc.BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              bloc.BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching',
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                      numberTrivia: state.trivia,
                    );
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              TriviaControls()
              // Bottom half
              // TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './counter_dart.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BlocProvider(
        create: (context) => CounterCubit(), child: const HomePage()),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CounterCubit cubit;

  @override
  void didChangeDependencies() {
    cubit = BlocProvider.of<CounterCubit>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
        centerTitle: true,
      ),
      body: BlocListener<CounterCubit, int>(
        bloc: cubit,
        listener: (context, state) {
          const snackBar = SnackBar(
            content: Text('State is reached'),
          );

          if (state == 5) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: BlocBuilder<CounterCubit, int>(
          bloc: cubit,
          builder: (BuildContext context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$state',
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      cubit.increment();
                    },
                    child: const Text('+'),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

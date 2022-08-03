import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './counter_dart.dart';
import './multiply_and_divide.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Colors.blue,
            actionTextColor: Colors.white,
            disabledActionTextColor: Colors.grey,
            contentTextStyle: TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            behavior: SnackBarBehavior.floating,
          )),
      home: BlocProvider(
          create: (context) => CounterCubit(), child: const HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CounterCubit cubit;

  //saving integer function
  final integerSavedController = TextEditingController();

  void routingToMultiply(BuildContext context, int input, int state) {
    //Routing to pages from multiply_and_divide.dart
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return MultiplyFunction(
          input: input,
          state: state,
        );
      },
    ));
  }

  void routingToDivision(BuildContext context, int input, int state) {
    //Routing to pages from multiply_and_divide.dart
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return DivideFunction(
          input: input,
          state: state,
        );
      },
    ));
  }

  @override
  void didChangeDependencies() {
    cubit = BlocProvider.of<CounterCubit>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
        centerTitle: true,
      ),
      body: BlocConsumer<CounterCubit, int>(
        bloc: cubit,
        listener: (context, state) {
          const snackBar = SnackBar(
            duration: Duration(seconds: 3),
            content: Text('You have reached the negative state stage at -10'),
          );
          const snackBar2 = SnackBar(
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text('This is the reset state value'),
          );
          const snackBar3 = SnackBar(
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text('You have reached the positive state stage at 10'),
          );

          if (state == -10) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state == 0) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar2);
          } else if (state == 10) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar3);
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Receiving the integer input from user
                TextField(
                  controller: integerSavedController,
                  decoration:
                      const InputDecoration(labelText: 'Enter your integer'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const Text(
                  'Button pushed:',
                ),
                Text(
                  '$state',
                  style: const TextStyle(
                      fontSize: 100, fontWeight: FontWeight.bold),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {
                            cubit.decrement();
                          },
                          child: const Icon(Icons.remove)),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {
                            cubit.resetValue();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'You have reset the counter'),
                                    content:
                                        const Text('Start the counts again'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Close'),
                                        child: const Text('Close'),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: const Icon(Icons.refresh)),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {
                            cubit.increment();
                          },
                          child: const Icon(Icons.add)),
                    ]),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      int input = int.parse(integerSavedController.text);
                      routingToMultiply(context, input, state);
                    },
                    child: const Text('X')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      int input = int.parse(integerSavedController.text);
                      routingToDivision(context, input, state);
                    },
                    child: const Text('÷')),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './counter_dart.dart';

void main() {
  runApp(MaterialApp(
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
      body: BlocConsumer(
        bloc: cubit,
        listener: (context, state) {
          const snackBar = SnackBar(
            duration: const Duration(seconds: 3),
            content: Text('You have reached the negative state stage at -10'),
          );
          const snackBar2 = SnackBar(
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text('This is the reset state value'),
          );
          const snackBar3 = SnackBar(
            duration: const Duration(seconds: 3),
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
        builder: (BuildContext context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Button pushed:',
                ),
                Text(
                  '$state',
                  style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
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
                                    title: Text('You have reset the counter'),
                                    content: Text('Start the counts again'),
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
                    ])
              ],
            ),
          );
        },
      ),
    );
  }
}

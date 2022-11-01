import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

void testit1() {
  print('start');

  Future(() => 1).then(print);
  Future(() => Future(() => 2)).then(print);

  Future.delayed(const Duration(seconds: 1), () => 3).then(print);

  Future.delayed(const Duration(seconds: 1), () => Future(() => 4)).then(print);
  //Future.delayed(Duration.zero , ()=>x)==Futre(()=>x)

  Future.value(5).then(print);
  Future.value(Future(() => 6)).then(print); //==Future(()=>6)

  Future.sync(() => 7).then(print); //== Future.value(7);
  Future.sync(() => Future(() => 8)).then(print); //== Future(() => 8)

  Future.microtask(() => 9).then(print);
  Future.microtask(() => Future(() => 10)).then(print);

  Future(() => 11).then(print);
  Future(() => Future(() => 12)).then(print);

  print('end');
  /*
the output will be 
flutter: start
flutter: end
flutter: 5
flutter: 7
flutter: 9
flutter: 1
flutter: 6
flutter: 8
flutter: 11
flutter: 10
flutter: 2
flutter: 12

flutter: 3
flutter: 4


  */
}

void testit2() {
  print('1');
  scheduleMicrotask(() => print('2'));

  Future.delayed(const Duration(seconds: 1), () => print('3'));

  Future(() => print('4')).then((_) => print('5')).then((_) {
    print('6');
    scheduleMicrotask(() => print('7'));
  }).then((_) => print('8'));

  scheduleMicrotask(() => print('9'));

  Future(() => print('10'))
      .then((_) => Future(() => print('11')))
      .then((_) => print(12));

  Future(() => print('13'));

  scheduleMicrotask(() => print('14'));

  print('15');
  //!micro:
  //*event :
  //?output 1 15 2 9 14 4 5 6  8 7 10 13 11 12 3
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('future and stream '),
      ),
    );
  }
}

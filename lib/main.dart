import 'dart:async';
import 'dart:developer' as devtool show log;
import 'package:flutter/material.dart';

extension Log on Object {
  void log() => devtool.log(toString());
}

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

void stream1() async {
  // Stream.periodic(const Duration(seconds: 1), (x) => x)
  //     .listen(((event) => print(event)));
  // Stream.periodic(const Duration(seconds: 2), (x) => -x)
  //     .listen(((event) => print(event)));
  // Stream.fromFutures([
  //   Future(() => 1),
  //   Future.value(2),
  //   Future.sync(() => 3),
  //   Future.microtask(() => 4)
  // ]).listen(print);
  int value = 0;
  StreamController streamController = StreamController<int>.broadcast();
  final streamSubscription = streamController.stream.listen(print);
  final otherStreamSubscription = streamController.stream.listen(print);
  Timer.periodic(const Duration(seconds: 1), (timer) {
    if (value > 5) {
      'close timer , streamcontroller , steamsubscription $value'.log();
      timer.cancel();
      streamController.close();
      streamSubscription.cancel();
      otherStreamSubscription.cancel();
    } else {
      streamController.add(value++);
    }
  });

  // streamController.stream.listen(print);

  // int max = 0;
  // await for (final value in streamController.stream) {
  //   max = value > max ? value : max;
  // }
  // max.log();
//or
  int max = 0;
  await streamController.stream.forEach((element) {
    max = max > element ? max : element;
  });

  max.log();
  asyncGenerator().listen(print);
}

var negativeStream =
    Stream<int>.periodic(const Duration(milliseconds: 500), (x) => -x);
Stream<int> asyncGenerator() async* {
  for (int i = 0; i < 5; i++) {
    yield i;
  }
  yield* negativeStream;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    stream1();
    return Scaffold(
      appBar: AppBar(
        title: Text('future and stream '),
      ),
    );
  }
}

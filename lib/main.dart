import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Picker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

List<String> names = ["Ab", "Ba", "Cb"];

// custom extension
extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NameCubit extends Cubit<String?> {
  NameCubit() : super(null);
  void PickRandomName() => emit(names.getRandomElement());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NameCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = NameCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Random picker'),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          TextButton customButton = TextButton(
              onPressed: () => cubit.PickRandomName(),
              child: const Text('Names picker'));
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Column(
                children: [
                  const Center(child: Text('None')),
                  customButton,
                ],
              );
            case ConnectionState.waiting:
              return Column(
                children: [
                  const Center(child: Text('Waiting')),
                  customButton,
                ],
              );
            case ConnectionState.active:
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customButton,
                  Container(
                    width: double.infinity,
                    color: Colors.green.shade200,
                    alignment: Alignment.center,
                    height: 300,
                    child: Text(snapshot.data ?? "No name selected"),
                  ),
                ],
              );
            case ConnectionState.done:
              return Column(
                children: [
                  const Center(child: Text('Done')),
                  customButton,
                ],
              );
          }
        },
      ),
    );
  }
}

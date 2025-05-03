import 'package:comms4_app/home_screen.dart';
import 'package:comms4_app/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => HomeViewModel())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return HomeScreen(viewModel: viewModel);
        },
      ),
    );
  }
}

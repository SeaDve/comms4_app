import 'package:comms4_app/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required HomeViewModel viewModel})
    : _viewModel = viewModel;

  final HomeViewModel _viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transmission Line')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6.0,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'IP Address',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) async {
                  try {
                    await widget._viewModel.setIpAddr(value);
                  } on Exception catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3.0,
                children: [
                  ListTile(
                    title: const Text('Connection Status'),
                    subtitle: Text(
                      widget._viewModel.isConnected
                          ? 'Connected'
                          : 'Disconnected',
                    ),
                  ),
                  ListTile(
                    title: const Text('Fault'),
                    subtitle: Text(
                      widget._viewModel.fault.isEmpty
                          ? 'None'
                          : widget._viewModel.fault,
                    ),
                  ),
                  ListTile(
                    title: const Text('Fault Distance'),
                    subtitle: Text(
                      widget._viewModel.faultDistance.toStringAsFixed(2),
                    ),
                  ),
                  ListTile(
                    title: const Text('R Voltage'),
                    subtitle: Text(
                      widget._viewModel.rVoltage.toStringAsFixed(2),
                    ),
                  ),
                  ListTile(
                    title: const Text('Y Voltage'),
                    subtitle: Text(
                      widget._viewModel.yVoltage.toStringAsFixed(2),
                    ),
                  ),
                  ListTile(
                    title: const Text('B Voltage'),
                    subtitle: Text(
                      widget._viewModel.bVoltage.toStringAsFixed(2),
                    ),
                  ),
                  ListTile(
                    title: const Text('G Voltage'),
                    subtitle: Text(
                      widget._viewModel.gVoltage.toStringAsFixed(2),
                    ),
                  ),
                  ListTile(
                    title: const Text('Temp 1'),
                    subtitle: Text(widget._viewModel.temp1.toStringAsFixed(2)),
                  ),
                  ListTile(
                    title: const Text('Temp 2'),
                    subtitle: Text(widget._viewModel.temp2.toStringAsFixed(2)),
                  ),
                  ListTile(
                    title: const Text('Temp 3'),
                    subtitle: Text(widget._viewModel.temp3.toStringAsFixed(2)),
                  ),
                  ListTile(
                    title: const Text('Temp 4'),
                    subtitle: Text(widget._viewModel.temp4.toStringAsFixed(2)),
                  ),
                  ListTile(
                    title: const Text('Overheat Fault'),
                    subtitle: Text(
                      widget._viewModel.overheatFault.isEmpty
                          ? 'None'
                          : widget._viewModel.overheatFault,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

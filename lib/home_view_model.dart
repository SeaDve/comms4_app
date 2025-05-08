import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

const remotePort = 80;

class HomeViewModel extends ChangeNotifier {
  String? _ipAddr;
  bool _isConnected = false;

  WebSocketChannel? _wsChannel;

  String _fault = '';
  double _faultDistance = 0.0;
  double _rVoltage = 0.0;
  double _yVoltage = 0.0;
  double _bVoltage = 0.0;
  double _gVoltage = 0.0;
  double _temp1 = 0.0;
  double _temp2 = 0.0;
  double _temp3 = 0.0;
  double _temp4 = 0.0;
  String _overheatFault = '';

  String? get ipAddr => _ipAddr;
  bool get isConnected => _isConnected;

  String get fault => _fault;
  double get faultDistance => _faultDistance;
  double get rVoltage => _rVoltage;
  double get yVoltage => _yVoltage;
  double get bVoltage => _bVoltage;
  double get gVoltage => _gVoltage;
  double get temp1 => _temp1;
  double get temp2 => _temp2;
  double get temp3 => _temp3;
  double get temp4 => _temp4;
  String get overheatFault => _overheatFault;

  Future<void> setIpAddr(String ipAddr) async {
    _resetData();

    _ipAddr = ipAddr;
    _isConnected = false;
    notifyListeners();

    final prevChannel = _wsChannel;
    if (prevChannel != null) {
      await prevChannel.sink.close(status.normalClosure);
    }

    final channel = WebSocketChannel.connect(
      Uri.parse('ws://$_ipAddr:$remotePort/ws'),
    );
    _wsChannel = channel;

    await channel.ready;
    _isConnected = true;
    notifyListeners();

    channel.stream.listen((message) {
      final (dataType, data) = _splitFirst(message as String, ':');

      switch (dataType) {
        case 'fault':
          _fault = data;
          break;
        case 'faultDistance':
          _faultDistance = double.parse(data);
          break;
        case 'rVoltage':
          _rVoltage = double.parse(data);
          break;
        case 'yVoltage':
          _yVoltage = double.parse(data);
          break;
        case 'bVoltage':
          _bVoltage = double.parse(data);
          break;
        case 'gVoltage':
          _gVoltage = double.parse(data);
          break;
        case 'temp1':
          _temp1 = double.parse(data);
          break;
        case 'temp2':
          _temp2 = double.parse(data);
          break;
        case 'temp3':
          _temp3 = double.parse(data);
          break;
        case 'temp4':
          _temp4 = double.parse(data);
          break;
        case 'overheatFault':
          _overheatFault = data;
          break;
        default:
          throw Exception('Unknown data type: $dataType');
      }

      notifyListeners();
    });

    await _loadData();
    notifyListeners();
  }

  Future<void> _resetData() async {
    _fault = '';
    _faultDistance = 0.0;
    _rVoltage = 0.0;
    _yVoltage = 0.0;
    _bVoltage = 0.0;
    _gVoltage = 0.0;
    _temp1 = 0.0;
    _temp2 = 0.0;
    _temp3 = 0.0;
    _temp4 = 0.0;
    _overheatFault = '';
  }

  Future<void> _loadData() async {
    if (_ipAddr == null) {
      throw Exception("IP address is not set");
    }

    final httpAuthority = _getHttpAuthority()!;
    final [
      getFaultResponse,
      getFaultDistanceResponse,
      getRVoltageResponse,
      getYVoltageResponse,
      getBVoltageResponse,
      getGVoltageResponse,
      getTemp1Response,
      getTemp2Response,
      getTemp3Response,
      getTemp4Response,
      getOverheatFaultResponse,
    ] = await Future.wait([
      _httpGet(Uri.http(httpAuthority, '/getFault')),
      _httpGet(Uri.http(httpAuthority, '/getFaultDistance')),
      _httpGet(Uri.http(httpAuthority, '/getRVoltage')),
      _httpGet(Uri.http(httpAuthority, '/getYVoltage')),
      _httpGet(Uri.http(httpAuthority, '/getBVoltage')),
      _httpGet(Uri.http(httpAuthority, '/getGVoltage')),
      _httpGet(Uri.http(httpAuthority, '/getTemp1')),
      _httpGet(Uri.http(httpAuthority, '/getTemp2')),
      _httpGet(Uri.http(httpAuthority, '/getTemp3')),
      _httpGet(Uri.http(httpAuthority, '/getTemp4')),
      _httpGet(Uri.http(httpAuthority, '/getOverheatFault')),
    ]);

    _fault = getFaultResponse;
    _faultDistance = double.parse(getFaultDistanceResponse);
    _rVoltage = double.parse(getRVoltageResponse);
    _yVoltage = double.parse(getYVoltageResponse);
    _bVoltage = double.parse(getBVoltageResponse);
    _gVoltage = double.parse(getGVoltageResponse);
    _temp1 = double.parse(getTemp1Response);
    _temp2 = double.parse(getTemp2Response);
    _temp3 = double.parse(getTemp3Response);
    _temp4 = double.parse(getTemp4Response);
    _overheatFault = getOverheatFaultResponse;
  }

  String? _getHttpAuthority() {
    if (_ipAddr == null) {
      return null;
    }

    return '$_ipAddr:$remotePort';
  }
}

Future<String> _httpGet(Uri uri) async {
  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to load data: ${response.body} (${response.statusCode})',
    );
  }

  return response.body;
}

(String, String) _splitFirst(String string, Pattern pattern) {
  int idx = string.indexOf(":");
  return (string.substring(0, idx).trim(), string.substring(idx + 1).trim());
}

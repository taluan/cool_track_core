import 'dart:io';

import 'package:api_response_log/api_response_log.dart';
import 'package:base_code_flutter/base_core.dart';
import 'package:base_code_flutter/flavor/flavor.dart';
import 'package:base_code_flutter/model/message/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:signalr_core/signalr_core.dart';


class SignalRService {
  late HubConnection _hubConnection;
  Function(ChatModel)? onMessageReceived;
  SignalRService();

  Future<void> startConnection(String? accessToken, String userId) async {
    try {
      debugPrint("startConnection: ${AppFlavor.socketUrl}");
      _hubConnection = HubConnectionBuilder()
          .withUrl(
        AppFlavor.socketUrl,
        HttpConnectionOptions(
          client: IOClient(
              HttpClient()..badCertificateCallback = (x, y, z) => true),
          transport: HttpTransportType.webSockets,
          skipNegotiation: true,
          accessTokenFactory: () async => accessToken,
        ),
      )
          .withAutomaticReconnect()
          .build();
      _hubConnection.on('ReceiveMessage', (arguments) {
        debugPrint("ReceiveMessage: $arguments");
        ApiLog.addLog(
            url:
            "Socket ${AppFlavor.socketUrl}",
            param: "ReceiveMessage",
            response: "${arguments}");
        if (arguments != null && arguments.isNotEmpty) {
          onMessageReceived?.call(ChatModel.fromJson(arguments.first));
        }
      });

      _hubConnection.onclose((error) {
        debugPrint('Connection closed: $error');
      });

      await _hubConnection.start();
      debugPrint('Connected to SignalR');
      confirmConnected(userId);
    } catch(e, s) {
      debugPrint('Error connecting to SignalR: $e');
      debugPrint(s.toString());
    }
  }

  void confirmConnected(String userId) async {
    try {
      debugPrint("ConfirmConnected");
      final deviceId = await appUtil.getDeviceId();
      _hubConnection.invoke("ConfirmConnected", args: [
        {'UserId': userId, "Channel": AppFlavor.appChannel.name, "DeviceId": deviceId}
      ]);
    } catch (e, s) {
      debugPrint(s.toString());
      debugPrint("confirmConnected error: ${e.toString()}");
    }
  }

  Future<void> stopConnection() async {
    try {
      await _hubConnection.stop();
    } catch (e, s) {
      debugPrint(s.toString());
      debugPrint("stopConnection error: ${e.toString()}");
    }
  }

  Future<void> sendMessage({required String userId, required String message, required String messageType}) async {
    if (_hubConnection.state == HubConnectionState.connected) {
      await _hubConnection.invoke('SendMessage', args: [userId, message]);
    }
  }

  HubConnectionState? get connectionState => _hubConnection.state;
}

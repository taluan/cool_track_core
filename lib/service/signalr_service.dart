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
  String _userId = "";
  SignalRService();

  Future<void> startConnection(String? accessToken, String userId) async {
    try {
      _userId = userId;
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

      onReceiveMessage();
      _hubConnection.onreconnected((text) {
        debugPrint('Connection onreconnected: $text');
        confirmConnected();
        // onReceiveMessage();
      });

      _hubConnection.onclose((error) {
        debugPrint('Connection closed: $error');
      });
      _hubConnection.onreconnecting((error) {
        debugPrint('Connection reconnecting: $error');
      });
      await connect();
    } catch(e, s) {
      debugPrint('Error connecting to SignalR: $e');
      debugPrint(s.toString());
    }
  }

  void onReceiveMessage() {
    debugPrint("onReceiveMessage");
    try {
      _hubConnection.on('ReceiveMessage', (arguments) {
        debugPrint("ReceiveMessage: $arguments");
        if (AppFlavor.isUAT) {
          ApiLog.addLog(
              url:
              "Socket ${AppFlavor.socketUrl}",
              param: "ReceiveMessage",
              response: "$arguments");
        }
        if (arguments != null && arguments.isNotEmpty) {
          onMessageReceived?.call(ChatModel.fromJson(arguments.first));
        }
      });
    } catch (e, s) {
      debugPrint(s.toString());
      debugPrint("onReceiveMessage error: ${e.toString()}");
    }
  }

  void offReceiveMessage() {
    _hubConnection.off("ReceiveMessage");
  }

  void confirmConnected() async {
    try {
      debugPrint("ConfirmConnected");
      final deviceId = await appUtil.getDeviceId();
      _hubConnection.invoke("ConfirmConnected", args: [
        {'UserId': _userId, "Channel": AppFlavor.appChannel, "DeviceId": deviceId}
      ]);
    } catch (e, s) {
      debugPrint(s.toString());
      debugPrint("confirmConnected error: ${e.toString()}");
    }
  }

  Future<bool> connect() async {
    try {
      debugPrint("ConnectionState: ${_hubConnection.state}");
      if (_hubConnection.state == HubConnectionState.connected) {
        return true;
      }
      await _hubConnection.start();
      debugPrint('Connected to SignalR');
      confirmConnected();
      return isConnected;
    } catch (e, s) {
      debugPrint(s.toString());
      debugPrint("connect error: ${e.toString()}");
    }
    return false;
  }

  Future<void> stopConnection() async {
    try {
      await _hubConnection.stop();
    } catch (e, s) {
      debugPrint(s.toString());
      debugPrint("stopConnection error: ${e.toString()}");
    }
  }

  Future<dynamic> sendMessage({required String chatId, required String senderId, required String content, required String messageType}) async {
    try {
      if (_hubConnection.state == HubConnectionState.connected) {
        final result = await _hubConnection.invoke("SendMessage", args: [
          {'chats_id': chatId, 'sender_id': senderId, "content": content, "message_type": messageType}
        ]);
        debugPrint("SendMessage socket: $result");
        if (result != null && result['data'] != null) {
          return ChatModel.fromJson(result['data']);
        }
      }
    } catch (e, s) {
      debugPrint(s.toString());
      debugPrint("SendMessage socket error: ${e.toString()}");
    }
    return null;
  }

  bool get isConnected => _hubConnection.state == HubConnectionState.connected;

  HubConnectionState? get connectionState => _hubConnection.state;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:dio/dio.dart';

// 1. 创建一个列表页面
// 2. 请求网络数据，'http://127.0.0.1:8000/api/v1/task/select_all_task_name'
// 3. 该页面被点击时，请求网络数据，并展示在列表中

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final Dio _dio = Dio();
  List<dynamic> _taskNames = []; // Add this line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务列表'),
      ),
      body: Column(children: <Widget>[
        ElevatedButton(
          onPressed: _loadTaskNames,
          child: Text('加载任务列表'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _taskNames.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_taskNames[index]),
              );
            },
          ),
        ),
      ]),
    );
  }

  Future<void> _loadTaskNames() async {
    try {
      print('Attempting to connect to server...');
      final response = await _dio.get(
        'http://127.0.0.1:8000/api/v1/task/select_all_task_name',
        options: Options(
          headers: {'accept': 'application/json'},
          // 增加超时时间
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );
      print(response);
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          // 修改这里
          _taskNames = (response.data['data'] as List<dynamic>).cast<String>();
        });
        print('Task names loaded: $_taskNames');
      } else {
        throw Exception(
            'Server returned ${response.statusCode}: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error details: $e');
      if (e is DioException) {
        print('DioError type: ${e.type}');
        print('DioError message: ${e.message}');
        print('DioError stackTrace: ${e.stackTrace}');
      }
      setState(() {
        _taskNames = ['Error occurred'];
      });
    }
  }

  // ... remove or comment out _showErrorSnackBar and testNetworkConnection methods if not needed
}

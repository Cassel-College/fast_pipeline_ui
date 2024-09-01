import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:dio/dio.dart';
import 'package:fast_pipeline_ui/http_tools.dart';
import 'package:fast_pipeline_ui/task_detail_page.dart';

// 1. 创建一个列表页面
// 2. 请求网络数据，'http://127.0.0.1:8000/api/v1/task/select_all_task_name'
// 3. 该页面被点击时，请求网络数据，并展示在列表中

class TaskPage extends StatefulWidget {
  final BuildContext? context;

  const TaskPage({Key? key, this.context}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final HttpTools _httpTools = HttpTools();
  List<String> _taskNames = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务列表'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _loadTaskNames,
              child: Text('刷新任务列表'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _taskNames.isEmpty
                    ? Center(child: Text('No tasks available'))
                    : ListView.builder(
                        itemCount: _taskNames.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: ListTile(
                              leading: Icon(Icons.task_alt, color: Colors.blue),
                              title: Text(_taskNames[index]),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () =>
                                  _navigateToTaskDetail(_taskNames[index]),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadTaskNames() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await _httpTools.get('/api/v1/task/select_all_task_name');
      setState(() {
        _taskNames = (response['data'] as List<dynamic>).cast<String>();
        _isLoading = false;
      });
      print('Task names loaded: $_taskNames');
      print('Server message: ${response['massage']}');
    } catch (e) {
      print('Error loading task names: $e');
      setState(() {
        _taskNames = [];
        _isLoading = false;
      });
      ScaffoldMessenger.of(widget.context ?? context).showSnackBar(
        SnackBar(content: Text('Error loading tasks')),
      );
    }
  }

  void _navigateToTaskDetail(String taskName) {
    Navigator.push(
      widget.context ?? context,
      MaterialPageRoute(
        builder: (context) => TaskDetailPage(taskName: taskName),
      ),
    );
  }
}

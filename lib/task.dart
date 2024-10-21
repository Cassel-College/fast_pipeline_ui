import 'dart:async';

import 'package:fast_pipeline_ui/default_empty_page.dart';
import 'package:fast_pipeline_ui/edit_task.dart';
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
  void initState() {
    super.initState();
    _loadTaskNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务列表'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTaskNames,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _taskNames.isEmpty
              ? Center(child: Text('No tasks available'))
              : ListView.builder(
                  itemCount: _taskNames.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: Icon(Icons.task_alt, color: Colors.blue),
                        title: Text(_taskNames[index]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildActionButton(
                                '查看',
                                bColor: const Color.fromARGB(255, 242, 232, 46),
                                () => _navigateToPage(
                                    _taskNames[index],
                                    TaskDetailPage(
                                        taskName: _taskNames[index],
                                        context: context))),
                            SizedBox(width: 8), // 添加间隔
                            _buildActionButton(
                                '执行',
                                bColor: Colors.green,
                                () => _navigateToPage(
                                    _taskNames[index],
                                    DefaultEmptyPage(
                                        taskName: _taskNames[index],
                                        context: context))),
                            SizedBox(width: 8), // 添加间隔
                            _buildActionButton(
                                '日志',
                                bColor: const Color.fromARGB(255, 230, 64, 233),
                                () => _navigateToPage(
                                    _taskNames[index],
                                    DefaultEmptyPage(
                                        taskName: _taskNames[index],
                                        context: context))),
                            SizedBox(width: 8), // 添加间隔
                            _buildActionButton(
                                '编辑',
                                bColor: const Color.fromARGB(255, 62, 130, 247),
                                () => _navigateToPage(
                                    _taskNames[index],
                                    EditTaskPage(
                                        taskName: _taskNames[index],
                                        context: context))),
                            SizedBox(width: 8), // 添加间隔
                            _buildActionButton(
                                '删除',
                                bColor: const Color.fromARGB(255, 219, 34, 34),
                                () => _navigateToPage(
                                    _taskNames[index],
                                    DefaultEmptyPage(
                                        taskName: _taskNames[index],
                                        context: context))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed,
      {Color? bColor}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: bColor ?? Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size(60, 30),
      ),
    );
  }

  void _navigateToPage(String taskName, Widget? page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            page ?? DefaultEmptyPage(taskName: taskName, context: context),
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
        print(response);
        _taskNames = (response['data']['folder_names'] as List<dynamic>).cast<String>();
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

  // ... 保留原有的 _loadTaskNames 方法 ...
}

// TODO: 实现 ViewTaskPage, ExecuteTaskPage, EditTaskPage, DeleteTaskPage

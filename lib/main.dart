import 'package:fast_pipeline_ui/about.dart';
import 'package:fast_pipeline_ui/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:fast_pipeline_ui/task.dart'; // 引入 TaskPage

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '任务管理器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务管理器'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildListTile(
            context,
            Icons.add,
            '创建任务',
            Colors.green,
            Colors.green[100]!,
            page: TaskPage(context: context), // 指定跳转页面
          ),
          _buildListTile(
            context,
            Icons.list,
            '查看所有任务',
            Colors.blue,
            Colors.blue[100]!,
            page: TaskPage(context: context),
          ),
          _buildListTile(
            context,
            Icons.history,
            '运行日志',
            Colors.orange,
            Colors.orange[100]!,
            page: TaskPage(context: context),
          ),
          _buildListTile(
            context,
            Icons.settings,
            '设置',
            Colors.purple,
            Colors.purple[100]!,
            page: TaskPage(context: context),
          ),
          _buildListTile(
            context,
            Icons.info,
            '关于',
            Colors.red,
            Colors.red[100]!,
            page: AboutPage(context: context),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    Color iconColor,
    Color backgroundColor, {
    Widget? page, // 使用可选的跳转页面参数
  }) {
    return Container(
      color: backgroundColor,
      child: ListTile(
        leading: Icon(icon, size: 30, color: iconColor),
        title: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        onTap: () {
          _navigateToPage(context, page);
        },
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget? page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page ?? TaskPage(context: context),
      ),
    );
  }
}

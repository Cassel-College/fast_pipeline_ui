import 'package:flutter/material.dart';

class DefaultEmptyPage extends StatelessWidget {
  final String taskName;
  final BuildContext? context;

  const DefaultEmptyPage({Key? key, required this.taskName, this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务详情: $taskName'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '没有可用的详细信息',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '任务名称: $taskName',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 返回上一个页面
                },
                child: Text('返回'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

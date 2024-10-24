import 'package:flutter/material.dart';
import 'package:fast_pipeline_ui/http_tools.dart';
import 'package:flutter_highlight/flutter_highlight.dart'; // 添加这个包来支持代码高亮
import 'package:flutter_highlight/themes/solarized-dark.dart';

class TaskDetailPage extends StatefulWidget {
  final String taskName;
  final BuildContext? context;

  const TaskDetailPage({Key? key, required this.taskName, this.context})
      : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final HttpTools _httpTools = HttpTools();
  Map<String, dynamic> _taskData = {};
  String _readmePath = "";
  bool _isLoading = true;
  String _selectedStep = '';
  Map<String, dynamic> _stepDetails = {}; // 用于存储步骤详细信息

  @override
  void initState() {
    super.initState();
    _loadTaskData();
  }

  Future<void> _loadTaskData() async {
    print('Starting _loadTaskData()');
    setState(() {
      _isLoading = true;
    });

    try {
      print('Sending API request for task: ${widget.taskName}');
      final response = await _httpTools.get(
        '/api/v1/task/select_full_info_by_task_name',
        queryParameters: {'task_name': widget.taskName},
      );
      print('API Response received: $response');

      if (response['code'] == 0) {
        print('API Warning: ${response['massage']}');
      }

      if (response['data'] != null) {
        print('Data found in response. Updating _taskData');
        setState(() {
          _taskData = response['data'];
          _isLoading = false;
        });
        print('_taskData updated: $_taskData');
        print('_taskData[step_index]: ${_taskData['step_index']}');
      } else {
        print('No data in response');
        setState(() {
          _taskData = {};
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading task data: $e');
      setState(() {
        _taskData = {};
        _isLoading = false;
      });
    }

    print(
        '_loadTaskData() completed. _isLoading: $_isLoading, _taskData: $_taskData');
  }

  Future<void> _loadStepDetails(String stepName) async {
    setState(() {
      _isLoading = true; // 显示加载状态
    });

    try {
      final response = await _httpTools.post(
        '/api/v1/step/get_step',
        data: {
          "task_name": widget.taskName,
          "step_name": stepName,
        },
      );

      if (response['code'] == 0) {
        // 处理成功的响应
        _stepDetails = response['data'];
      } else {
        // 处理错误情况
        _stepDetails = {'error': response['message']};
      }
    } catch (e) {
      _stepDetails = {'error': 'Error loading step details: $e'};
    } finally {
      setState(() {
        _isLoading = false; // 隐藏加载状态
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskName),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTaskData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _taskData.isEmpty
              ? Center(
                  child: Text('No task data available. Please try refreshing.'))
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: _buildStepStatusOverview(),
                    ),
                    Divider(),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStepNavigation(),
                          VerticalDivider(width: 1),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildStepDetails(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildStepStatusOverview() {
    final stepIndex = _taskData['step_index'] as List<dynamic>? ?? [];
    final taskFullInfo =
        _taskData['task_full_info'] as Map<String, dynamic>? ?? {};
    _readmePath = _taskData['readme_path'] as String? ?? "";
    print("readme_path: $_readmePath");
    if (stepIndex.isEmpty) {
      return Center(child: Text('No steps available'));
    }

    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stepIndex.length,
        itemBuilder: (context, index) {
          final stepName = stepIndex[index];
          final stepInfo = taskFullInfo[stepName] ?? {};
          final returnValue = stepInfo['return_value'] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: returnValue == 1 ? Colors.green : Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      stepName,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  returnValue == 1 ? 'Success' : 'Failed',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepNavigation() {
    final stepIndex = _taskData['step_index'] as List<dynamic>? ?? [];

    if (stepIndex.isEmpty) {
      return Center(child: Text('No steps available'));
    }

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: ListView.builder(
        itemCount: stepIndex.length,
        itemBuilder: (context, index) {
          final stepName = stepIndex[index];
          final isSelected = _selectedStep == stepName;
          return Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 14, 200, 98)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              title: Text(
                stepName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.blue[800] : Colors.black,
                ),
              ),
              leading: Icon(
                Icons.circle,
                color: isSelected ? Colors.blue : Colors.grey,
                size: 12,
              ),
              onTap: () {
                setState(() {
                  _selectedStep = stepName;
                });
                _loadStepDetails(stepName); // 加载步骤详细信息
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepDetails() {
    if (_selectedStep.isEmpty) {
      return Center(child: Text('Select a step to view details'));
    }

    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_stepDetails.containsKey('error')) {
      return Center(child: Text(_stepDetails['error']));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExpansionTile(
              'Script File Path', _stepDetails['script_file_path']),
          _buildExpansionTile(
              'Input File Path', _stepDetails['script_exec_input_file_path']),
          _buildExpansionTile(
              'Output File Path', _stepDetails['script_exec_output_file_path']),
          _buildExpansionTile(
              'Log File Path', _stepDetails['script_exec_log_file_path']),
        ],
      ),
    );
  }

  Widget _buildExpansionTile(String title, Map<String, dynamic> data) {
    return ExpansionTile(
      title: Text(title),
      children: [
        // 添加按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                // 编辑按钮的逻辑
              },
              child: Text('查看', style: TextStyle(fontSize: 12)),
            ),
            TextButton(
              onPressed: () {
                // 编辑按钮的逻辑
              },
              child: Text('编辑', style: TextStyle(fontSize: 12)),
            ),
            TextButton(
              onPressed: () {
                // 运行按钮的逻辑
              },
              child: Text('运行', style: TextStyle(fontSize: 12)),
            ),
            TextButton(
              onPressed: () {
                // 运行按钮的逻辑
              },
              child: Text('保存', style: TextStyle(fontSize: 12)),
            ),
            TextButton(
              onPressed: () {
                // 清除按钮的逻辑
              },
              child: Text('清除', style: TextStyle(fontSize: 12)),
            ),
            TextButton(
              onPressed: () {
                // 清除按钮的逻辑
              },
              child: Text('属性', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        ListTile(
          title: Text('File Path: ${data['file_path']}',
              style: TextStyle(fontSize: 12)),
        ),
        ListTile(
          title: Text('File Name: ${data['file_name']}',
              style: TextStyle(fontSize: 12)),
        ),
        ListTile(
          title: Text('File Type: ${data['file_type']}',
              style: TextStyle(fontSize: 12)),
        ),
        ListTile(
          title: Text('File Content:', style: TextStyle(fontSize: 12)),
        ),
        Container(
          width: double.infinity, // 自适应填充满
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            // color: Colors.black, // 暗色背景
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: HighlightView(
            data['file_info_result']['data'], // Python 代码
            language: 'python',
            theme: solarizedDarkTheme, // 选择主题
            padding: EdgeInsets.all(12),
            textStyle: TextStyle(
              fontFamily: 'Courier',
              fontSize: 14,
              color: Colors.white, // 代码字体颜色
            ),
          ),
        ),
      ],
    );
  }
}

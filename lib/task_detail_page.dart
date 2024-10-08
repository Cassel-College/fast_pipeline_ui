import 'package:flutter/material.dart';
import 'package:fast_pipeline_ui/http_tools.dart';

class TaskDetailPage extends StatefulWidget {
  final String taskName;

  const TaskDetailPage({Key? key, required this.taskName}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final HttpTools _httpTools = HttpTools();
  Map<String, dynamic> _taskData = {};
  String _readmePath = "";
  bool _isLoading = true;
  String _selectedStep = '';

  @override
  void initState() {
    super.initState();
    print('initState called');
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
              color: isSelected ? Colors.blue[100] : Colors.transparent,
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

    final taskFullInfo = _taskData['task_full_info'];
    print('taskFullInfo: $taskFullInfo');

    final selectedStepInfo = taskFullInfo?[_selectedStep];
    print('selectedStepInfo: $selectedStepInfo');

    final stepInfo = selectedStepInfo?['step_full_info'] ?? {};
    print('stepInfo: $stepInfo');

    print("-----> selected step: $_selectedStep");
    // final stepInfo = _taskData['data']?['task_full_info']?[_selectedStep]
    //         ?['step_full_info'] ??
    //     {};
    print("stepInfo: $stepInfo");

    if (stepInfo.isEmpty) {
      return Center(child: Text('No details available for this step'));
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: stepInfo.entries.map<Widget>((entry) {
        return Card(
          child: ListTile(
            title: Text(entry.key),
            subtitle: Text(entry.value.toString()),
          ),
        );
      }).toList(),
    );
  }
}

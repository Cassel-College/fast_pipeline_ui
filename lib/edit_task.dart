import 'package:flutter/material.dart';

class EditTaskPage extends StatefulWidget {
  final String taskName;
  final BuildContext? context;

  const EditTaskPage({Key? key, required this.taskName, this.context})
      : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _readmeController;
  late TextEditingController _indexController;
  List<TextEditingController> _stepControllers = [];

  @override
  void initState() {
    super.initState();
    _loadTaskData();
  }

  void _loadTaskData() {
    // TODO: Implement loading task data based on taskName
    // For now, we'll use placeholder data
    _tabController = TabController(length: 3, vsync: this);
    _readmeController = TextEditingController(text: "Task README");
    _indexController = TextEditingController(text: "Task Index");
    _stepControllers = [
      TextEditingController(text: "Step 1"),
      TextEditingController(text: "Step 2"),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _readmeController.dispose();
    _indexController.dispose();
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑任务: ${widget.taskName}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'README'),
            Tab(text: 'Index'),
            Tab(text: 'Steps'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReadmeTab(),
          _buildIndexTab(),
          _buildStepsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTask,
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _buildReadmeTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _readmeController,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Enter README content',
        ),
      ),
    );
  }

  Widget _buildIndexTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _indexController,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Enter Index content',
        ),
      ),
    );
  }

  Widget _buildStepsTab() {
    return ListView.builder(
      itemCount: _stepControllers.length + 1,
      itemBuilder: (context, index) {
        if (index == _stepControllers.length) {
          return ElevatedButton(
            onPressed: _addStep,
            child: Text('Add Step'),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _stepControllers[index],
            decoration: InputDecoration(
              hintText: 'Step ${index + 1}',
            ),
          ),
        );
      },
    );
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _saveTask() {
    // TODO: Implement save logic
    // You'll need to save the task data based on the taskName
    print('Saving task: ${widget.taskName}');
    print('README: ${_readmeController.text}');
    print('Index: ${_indexController.text}');
    for (int i = 0; i < _stepControllers.length; i++) {
      print('Step ${i + 1}: ${_stepControllers[i].text}');
    }

    // After saving, you might want to navigate back
    Navigator.pop(context);
  }
}

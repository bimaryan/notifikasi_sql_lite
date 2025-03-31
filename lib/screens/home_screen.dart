import 'package:flutter/material.dart';
import 'package:notifikasi_sql_lite/components/add_task_dialog.dart';
import 'package:notifikasi_sql_lite/components/edit_task_dialog.dart';
import 'package:notifikasi_sql_lite/components/task_item.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class HomeScreen extends StatefulWidget {
  final TaskService taskService;

  const HomeScreen({super.key, required this.taskService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    widget.taskService.checkDeadlineTasks(); // Cek deadline saat init
  }

  Future<void> _loadTasks() async {
    final tasks = await widget.taskService.getTask();
    setState(() => _tasks = tasks);
  }

  Future<void> _addTask() async {
    final newTask = await showDialog<Task>(
      context: context,
      builder: (context) => AddTaskDialog(),
    );

    if (newTask != null) {
      await widget.taskService.addTask(newTask);
      _loadTasks(); // Refresh list
    }
  }

  Future<void> _deleteTask(int id) async {
    await widget.taskService.deleteTask(id);
    _loadTasks(); // Refresh list setelah hapus
  }

  Future<void> _updateTask(Task task) async {
    final updatedTask = await showDialog<Task>(
      context: context,
      builder: (context) => EditTaskDialog(task: task),
    );

    if (updatedTask != null) {
      await widget.taskService.updateTask(updatedTask);
      _loadTasks(); // Refresh daftar setelah update
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet!'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskItem(
                  task: task,
                  onDelete: () => _deleteTask(task.id!),
                  onUpdate: () => _updateTask(task),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}

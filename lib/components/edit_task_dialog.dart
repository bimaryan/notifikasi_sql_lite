import 'package:flutter/material.dart';
import '../models/task.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;

  const EditTaskDialog({super.key, required this.task});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController _titleController;
  DateTime? _selectedDeadline;
  bool _isDeadlineExpired = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _selectedDeadline = widget.task.deadline;

    // Cek apakah deadline sudah lewat
    if (widget.task.deadline != null &&
        widget.task.deadline!.isBefore(DateTime.now())) {
      _isDeadlineExpired =
          true; // Tandai bahwa task tidak bisa diubah deadline-nya
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _pickDeadline() async {
    if (_isDeadlineExpired)
      return; // Jika sudah expired, tidak bisa pilih deadline

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDeadline = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedDeadline == null
                    ? 'No Deadline'
                    : 'Deadline: ${_selectedDeadline!.toLocal()}'.split(' ')[0],
                style: TextStyle(
                  color: _isDeadlineExpired ? Colors.red : Colors.black,
                  fontWeight:
                      _isDeadlineExpired ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              TextButton(
                onPressed: _isDeadlineExpired
                    ? null
                    : _pickDeadline, // Nonaktifkan tombol jika deadline sudah lewat
                child: const Text('Pick Date'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTask = Task(
              id: widget.task.id,
              title: _titleController.text,
              isCompleted: widget.task.isCompleted,
              deadline: _selectedDeadline,
            );
            Navigator.pop(context, updatedTask);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}

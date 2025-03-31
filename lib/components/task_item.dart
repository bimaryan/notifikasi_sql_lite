import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final Future<void> Function() onUpdate;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final isExpired =
        task.deadline != null && task.deadline!.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isExpired
              ? Colors.red
              : Colors.grey, // Jika expired, border merah
          width: 1.5,
        ),
      ),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: isExpired ? FontWeight.bold : FontWeight.normal,
            color: isExpired
                ? Colors.red
                : Colors.black, // Ubah warna jika expired
          ),
        ),
        subtitle: task.deadline != null
            ? Text(
                'Deadline: ${task.deadline!.toLocal().toString().split(' ')[0]}',
                style: TextStyle(
                  color: isExpired ? Colors.red : Colors.grey,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Edit dengan warna abu-abu jika expired
            IconButton(
              icon: Icon(Icons.edit,
                  color: isExpired ? Colors.grey : Colors.blue),
              onPressed: isExpired ? null : () async => await onUpdate(),
            ),
            // Tombol Delete tetap aktif
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

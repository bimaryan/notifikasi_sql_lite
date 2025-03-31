import 'package:notifikasi_sql_lite/helpers/database_helper.dart';
import 'package:notifikasi_sql_lite/models/task.dart';
import 'package:notifikasi_sql_lite/services/notification_service.dart';

class TaskService {
  final DatabaseHelper _dbHelper;
  final NotificationService _notificationService;

  TaskService({
    required DatabaseHelper dbHelper,
    required NotificationService notificationService,
  })  : _dbHelper = dbHelper,
        _notificationService = notificationService;

  // Fungsi untuk mengecek deadline task
  Future<void> checkDeadlineTasks() async {
    final tasks = await _dbHelper.getTasks();
    final now = DateTime.now();

    for (final task in tasks) {
      if (task.deadline != null &&
          task.deadline!.isBefore(now) &&
          !task.isCompleted) {
        await _notificationService.showNotification(
          title: 'Task Expired',
          body: '${task.title} sudah melewati deadline!',
        );
      }
    }
  }

  // Fungsi untuk mendapatkan semua task
  Future<List<Task>> getTask() async {
    return await _dbHelper.getTasks();
  }

  // Contoh fungsi lain terkait task
  Future<int> addTask(Task task) async {
    final id = await _dbHelper.insertTask(task);
    await _notificationService.showNotification(
      title: 'Task Baru',
      body: 'Task "${task.title}" telah ditambahkan!',
    );
    return id;
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    await _notificationService.showNotification(
      title: 'Task Dihapus',
      body: 'Sebuah task telah dihapus!',
    );
  }

  Future<void> updateTask(Task task) async {
    await _dbHelper.updateTask(task);
    await _notificationService.showNotification(
      title: 'Task Diperbarui',
      body: 'Task "${task.title}" telah diperbarui!',
    );
  }
}

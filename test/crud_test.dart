import 'package:flutter_test/flutter_test.dart';
import 'package:notifikasi_sql_lite/helpers/database_helper.dart';
import 'package:notifikasi_sql_lite/models/task.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper dbHelper;

  setUpAll(() async {
    // Initialize sqflite_common_ffi for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Inisialisasi database in-memory untuk testing
    dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    await db.delete('tasks');
  });

  test('Insert and retrieve tasks', () async {
    await dbHelper.insertTask(Task(title: 'Test Task'));
    final tasks = await dbHelper.getTasks();

    expect(tasks.length, 1);
    expect(tasks.first.title, 'Test Task');
  });

  test('Delete a task', () async {
    // Tambahkan tugas ke database
    final task = Task(title: 'Task to delete');
    final taskId = await dbHelper.insertTask(task);

    // Pastikan tugas telah ditambahkan
    var tasks = await dbHelper.getTasks();
    expect(tasks.length, 1);

    // Hapus tugas
    await dbHelper.deleteTask(taskId);

    // Periksa apakah tugas sudah dihapus
    tasks = await dbHelper.getTasks();
    expect(tasks.isEmpty, true);
  });

  test('Check deadline', () async {
    // Tambahkan tugas dengan deadline kemarin
    final pastDeadline = DateTime.now().subtract(const Duration(days: 1));
    final task = Task(title: 'Expired Task', deadline: pastDeadline);
    await dbHelper.insertTask(task);

    // Ambil semua tugas
    final tasks = await dbHelper.getTasks();

    // Pastikan tugas ada dan expired
    expect(tasks.isNotEmpty, true);
    expect(tasks.first.deadline!.isBefore(DateTime.now()), true);
  });
}

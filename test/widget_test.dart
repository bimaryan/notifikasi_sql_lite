import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notifikasi_sql_lite/models/task.dart';
import 'package:notifikasi_sql_lite/helpers/database_helper.dart';

// Buat mock untuk DatabaseHelper
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  testWidgets('Task List displays tasks', (WidgetTester tester) async {
    // Inisialisasi mock database helper
    final mockDbHelper = MockDatabaseHelper();

    // Atur return value untuk getTasks
    when(mockDbHelper.getTasks()).thenAnswer(
      (_) async => [Task(id: 1, title: 'Mock Task')],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FutureBuilder<List<Task>>(
            future: mockDbHelper.getTasks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No tasks available');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(snapshot.data![index].title));
                  },
                );
              }
            },
          ),
        ),
      ),
    );

    // Tunggu Future selesai
    await tester.pumpAndSettle();

    // Verifikasi apakah tugas ditampilkan
    expect(find.text('Mock Task'), findsOneWidget);
  });
}

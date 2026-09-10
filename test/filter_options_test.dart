import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_library/data/local/database.dart';
import 'package:my_library/data/repositories/library_repository.dart';
import 'package:my_library/data/seed/seeder.dart';
import 'package:my_library/domain/models/enums.dart';

void main() {
  test('filter options come back from a seeded library', () async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.ensureIndexes();
    await Seeder(db).seed();

    final options = await LibraryRepository(db)
        .filterOptions()
        .timeout(const Duration(seconds: 10));

    expect(options[FilterGroup.language], contains('English'));
    expect(options[FilterGroup.language], contains('Russian'));
    expect(options[FilterGroup.genre], contains('Fiction'));
    expect(options[FilterGroup.publisher], contains('Penguin'));
    expect(options[FilterGroup.author], contains('George Orwell'));
    expect(options[FilterGroup.format], contains('Paperback'));
    expect(options[FilterGroup.status], contains('Read'));

    await db.close();
  });
}

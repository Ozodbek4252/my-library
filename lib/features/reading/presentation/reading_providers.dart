import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/models/library_models.dart';

final currentlyReadingProvider = StreamProvider<List<ReadingEntryView>>(
  (ref) => ref.watch(readingRepositoryProvider).watchCurrentlyReading(),
);

final upNextProvider = StreamProvider<List<LibraryEntry>>(
  (ref) => ref.watch(readingRepositoryProvider).watchUpNext(),
);

final readingHistoryProvider = StreamProvider<List<HistoryEntry>>(
  (ref) => ref.watch(readingRepositoryProvider).watchHistory(),
);

/// One in-progress book, for the progress sheet.
final readingEntryProvider =
    StreamProvider.family<ReadingEntryView?, String>((ref, workId) {
  return ref.watch(readingRepositoryProvider).watchCurrentlyReading().map(
        (entries) => entries.where((e) => e.work.id == workId).firstOrNull,
      );
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/models/library_models.dart';

final bookDetailsProvider =
    StreamProvider.family<BookDetails?, String>((ref, workId) {
  return ref.watch(libraryRepositoryProvider).watchBookDetails(workId);
});

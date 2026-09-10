import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/isbn.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/layout.dart';
import '../../../core/widgets/states.dart';
import '../../../data/local/database.dart';
import '../../../data/metadata/book_metadata.dart';
import '../../../data/repositories/library_query.dart';
import '../../../domain/models/enums.dart';
import '../../../domain/models/library_models.dart';
import '../../books/presentation/add_book_screen.dart';
import '../../library/presentation/library_providers.dart';
import '../../library/presentation/widgets/book_tile.dart';

/// Free-text search across title, author, ISBN, publisher, genre and tags,
/// with the design's suggestion chips and recent queries when the field is
/// empty.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = ref.read(libraryQueryProvider).search;
    _controller.text = _query;
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 220), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  void _run(String value) {
    _controller.text = value;
    setState(() => _query = value.trim());
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _query.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                12,
                AppSpacing.screenH,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      decoration: BoxDecoration(
                        color: AppColors.paperRaised,
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        border: Border.all(
                          color: _focus.hasFocus
                              ? AppColors.ink
                              : AppColors.ruleStrong,
                          width: _focus.hasFocus ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const AppIcon(
                            AppIcons.search,
                            size: 15,
                            color: AppColors.ink,
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focus,
                              autofocus: false,
                              textInputAction: TextInputAction.search,
                              cursorColor: AppColors.accent,
                              cursorWidth: 1.5,
                              onChanged: _onChanged,
                              onSubmitted: _run,
                              style: AppText.sans(size: 14.5),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Title, author, ISBN…',
                                hintStyle: AppText.sans(
                                  size: 14.5,
                                  color: AppColors.muted2,
                                ),
                              ),
                            ),
                          ),
                          if (hasQuery)
                            GestureDetector(
                              onTap: () {
                                _controller.clear();
                                setState(() => _query = '');
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: AppIcon(
                                  AppIcons.close,
                                  size: 15,
                                  color: AppColors.faint,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.pop(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Cancel',
                        style: AppText.sans(
                          size: 14.5,
                          weight: 600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: hasQuery
                  ? _SearchResults(
                      query: _query,
                      onOpenBook: (workId) {
                        context.pop();
                        context.push(Routes.bookDetails(workId));
                      },
                    )
                  : _SearchSuggestions(onPick: _run),
            ),
          ],
        ),
      ),
    );
  }
}

/// The library query used by the search screen. Owned and wishlisted books are
/// both searchable here.
final _searchResultsProvider =
    StreamProvider.family<List<LibraryEntry>, String>((ref, query) {
  return ref.watch(libraryRepositoryProvider).watchLibrary(
        LibraryQuery(search: query, ownership: null),
        limit: 100,
      );
});

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query, required this.onOpenBook});

  final String query;
  final ValueChanged<String> onOpenBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(_searchResultsProvider(query));

    return results.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accent,
            ),
          ),
        ),
      ),
      error: (error, _) => ErrorStateView(
        message: 'The search could not be run.',
        onRetry: () => ref.invalidate(_searchResultsProvider(query)),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return _NoResults(query: query);
        }
        // Recording the query powers the "Recent" list.
        ref.read(libraryRepositoryProvider).recordSearch(query, entries.length);

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            18,
            AppSpacing.screenH,
            AppSpacing.modalBottom,
          ),
          children: [
            Text(
              '${entries.length} in your library',
              style: AppText.sans(
                size: 11,
                letterSpacing: .02,
                color: AppColors.muted2,
              ),
            ),
            const SizedBox(height: 2),
            for (final entry in entries)
              BookListRow(
                entry: entry,
                onTap: () => onOpenBook(entry.work.id),
              ),
            const SizedBox(height: 22),
            _SearchAllEditions(query: query),
          ],
        );
      },
    );
  }
}

class _NoResults extends ConsumerWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.only(top: 120, bottom: 40),
      children: [
        MessageState(
          title: 'No matches',
          message: 'Nothing in your library for “$query”. It may be a book you '
              "don't own yet.",
          icon: AppIcons.search,
          titleSize: 22,
          maxMessageWidth: 230,
          primaryLabel: 'Scan its barcode',
          onPrimary: () {
            context.pop();
            context.push(Routes.scanner);
          },
          secondaryLabel: 'Add it manually',
          onSecondary: () {
            context.pop();
            context.push(Routes.addBook);
          },
        ),
        const SizedBox(height: 26),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
          child: _SearchAllEditions(query: query),
        ),
      ],
    );
  }
}

/// Looks the query up with the metadata provider — books the user does not own
/// yet. Results can be added straight to the library.
class _SearchAllEditions extends ConsumerStatefulWidget {
  const _SearchAllEditions({required this.query});

  final String query;

  @override
  ConsumerState<_SearchAllEditions> createState() => _SearchAllEditionsState();
}

class _SearchAllEditionsState extends ConsumerState<_SearchAllEditions> {
  bool _expanded = false;
  bool _loading = false;
  String? _error;
  List<BookMetadata> _results = const [];

  Future<void> _search() async {
    setState(() {
      _expanded = true;
      _loading = true;
      _error = null;
    });
    try {
      final results = await ref
          .read(bookMetadataRepositoryProvider)
          .search(widget.query, limit: 12);
      if (mounted) setState(() => _results = results);
    } on MetadataException catch (e) {
      if (mounted) {
        setState(
          () => _error = e.failure == MetadataFailure.network
              ? "We couldn't reach the book lookup. Your own library is still "
                  'fully searchable.'
              : 'The lookup failed. Try again in a moment.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_expanded) {
      return Center(
        child: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Not in your library? '),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: _search,
                  child: Text(
                    'Search all editions',
                    style: AppText.sans(
                      size: 12.5,
                      weight: 600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          style: AppText.sans(size: 12.5, color: AppColors.muted2),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionLabel('All editions', top: 6),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accent,
                ),
              ),
            ),
          )
        else if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _error!,
              style: AppText.sans(
                size: 13,
                height: 1.5,
                color: AppColors.muted,
              ),
            ),
          )
        else if (_results.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No editions found for “${widget.query}”.',
              style: AppText.sans(size: 13, color: AppColors.muted),
            ),
          )
        else
          for (final result in _results) _ExternalResultRow(metadata: result),
      ],
    );
  }
}

class _ExternalResultRow extends ConsumerWidget {
  const _ExternalResultRow({required this.metadata});

  final BookMetadata metadata;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = LibraryEntry(
      work: Work(
        id: metadata.isbn13 ?? metadata.title,
        title: metadata.title,
        authors: metadata.authors,
        genres: metadata.genres,
        readingStatus: ReadingStatus.unread.name,
        currentPage: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      edition: null,
      editionCount: 1,
      copyCount: 0,
      addedDate: DateTime.now(),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.pop();
        context.push(
          Routes.addBook,
          extra: AddBookArgs(prefill: metadata.toDraft()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.rule)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.listPrimary,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.authorLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.listSecondary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      metadata.publisher,
                      metadata.publishedYear?.toString(),
                      metadata.isbn13 == null
                          ? null
                          : Isbn.display(metadata.isbn13!),
                    ].where((e) => e != null && e.isNotEmpty).join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.metadata,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const AppIcon(AppIcons.plus, size: 16, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}

class _SearchSuggestions extends ConsumerWidget {
  const _SearchSuggestions({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(filterOptionsProvider).value ?? const {};

    // Suggestions are drawn from the collection, so tapping one always returns
    // something.
    final suggestions = <String>[
      ...?options[FilterGroup.genre]?.take(2),
      ...?options[FilterGroup.language]?.take(2),
      ...?options[FilterGroup.publisher]?.take(2),
      ...?options[FilterGroup.author]?.take(1),
    ];

    return FutureBuilder<List<RecentSearch>>(
      future: ref.read(libraryRepositoryProvider).recentSearches(),
      builder: (context, snapshot) {
        final recents = snapshot.data ?? const <RecentSearch>[];
        return ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            0,
            AppSpacing.screenH,
            AppSpacing.modalBottom,
          ),
          children: [
            if (suggestions.isNotEmpty) ...[
              const SectionLabel('Try', top: 24),
              ChipWrap(
                children: [
                  for (final suggestion in suggestions)
                    _SuggestionChip(
                      label: suggestion,
                      onTap: () => onPick(suggestion),
                    ),
                ],
              ),
            ],
            if (recents.isNotEmpty) ...[
              const SectionLabel('Recent', top: 26, bottom: 4),
              for (final recent in recents)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onPick(recent.query),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.rule)),
                    ),
                    child: Row(
                      children: [
                        const AppIcon(
                          AppIcons.clock,
                          size: 15,
                          color: AppColors.faint,
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text(
                            recent.query,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.sans(
                              size: 14.5,
                              color: AppColors.ink2,
                            ),
                          ),
                        ),
                        Text(
                          recent.resultCount == 1
                              ? '1 book'
                              : '${recent.resultCount} books',
                          style: AppText.sans(size: 12, color: AppColors.faint),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 26),
            const _ScanPromo(),
          ],
        );
      },
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: AppColors.paperRaised,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(color: AppColors.ruleStrong),
          ),
          child: Align(
            widthFactor: 1,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.sans(size: 13, color: AppColors.inkBody),
            ),
          ),
        ),
      );
}

class _ScanPromo extends StatelessWidget {
  const _ScanPromo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paperRaised,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: AppColors.ruleStrong),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.ink,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const AppIcon(
              AppIcons.barcode,
              size: 18,
              color: AppColors.paper,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'In a bookstore?',
                  style: AppText.sans(size: 13.5, weight: 600),
                ),
                const SizedBox(height: 1),
                Text(
                  'Scanning is faster than typing.',
                  style: AppText.sans(size: 12, color: AppColors.muted2),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.pop();
              context.push(Routes.scanner);
            },
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text(
                'Scan',
                style: AppText.sans(
                  size: 13,
                  weight: 600,
                  color: AppColors.paper,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

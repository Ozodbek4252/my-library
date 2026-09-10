import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/enums.dart';
import 'providers.dart';

/// The handful of preferences the design says are remembered per user: the
/// grid/list choice, the sort order, whether the stats strip is shown, and
/// whether onboarding has been seen.
class AppSettings {
  const AppSettings({
    this.onboardingComplete = false,
    this.libraryView = LibraryView.grid,
    this.sort = SortOption.recentlyAdded,
    this.showStatsStrip = true,
    this.showCaptions = true,
  });

  final bool onboardingComplete;
  final LibraryView libraryView;
  final SortOption sort;
  final bool showStatsStrip;
  final bool showCaptions;

  AppSettings copyWith({
    bool? onboardingComplete,
    LibraryView? libraryView,
    SortOption? sort,
    bool? showStatsStrip,
    bool? showCaptions,
  }) =>
      AppSettings(
        onboardingComplete: onboardingComplete ?? this.onboardingComplete,
        libraryView: libraryView ?? this.libraryView,
        sort: sort ?? this.sort,
        showStatsStrip: showStatsStrip ?? this.showStatsStrip,
        showCaptions: showCaptions ?? this.showCaptions,
      );
}

class SettingsNotifier extends Notifier<AppSettings> {
  static const _onboarding = 'onboarding_complete';
  static const _view = 'library_view';
  static const _sort = 'library_sort';
  static const _stats = 'library_stats_strip';
  static const _captions = 'library_captions';

  @override
  AppSettings build() {
    final prefs = ref.watch(preferencesProvider);
    return AppSettings(
      onboardingComplete: prefs.getBool(_onboarding) ?? false,
      libraryView: prefs.getString(_view) == LibraryView.list.name
          ? LibraryView.list
          : LibraryView.grid,
      sort: SortOption.fromName(prefs.getString(_sort)),
      showStatsStrip: prefs.getBool(_stats) ?? true,
      showCaptions: prefs.getBool(_captions) ?? true,
    );
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingComplete: true);
    await ref.read(preferencesProvider).setBool(_onboarding, true);
  }

  Future<void> resetOnboarding() async {
    state = state.copyWith(onboardingComplete: false);
    await ref.read(preferencesProvider).setBool(_onboarding, false);
  }

  Future<void> setLibraryView(LibraryView view) async {
    state = state.copyWith(libraryView: view);
    await ref.read(preferencesProvider).setString(_view, view.name);
  }

  Future<void> setSort(SortOption sort) async {
    state = state.copyWith(sort: sort);
    await ref.read(preferencesProvider).setString(_sort, sort.name);
  }

  Future<void> toggleStatsStrip() async {
    final next = !state.showStatsStrip;
    state = state.copyWith(showStatsStrip: next);
    await ref.read(preferencesProvider).setBool(_stats, next);
  }

  Future<void> toggleCaptions() async {
    final next = !state.showCaptions;
    state = state.copyWith(showCaptions: next);
    await ref.read(preferencesProvider).setBool(_captions, next);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

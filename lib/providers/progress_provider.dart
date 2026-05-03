import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/progress.dart';

const _boxName = 'chapter_progress';

class ProgressNotifier extends Notifier<Map<int, ChapterProgress>> {
  late Box<ChapterProgress> _box;

  @override
  Map<int, ChapterProgress> build() {
    _box = Hive.box<ChapterProgress>(_boxName);
    final map = <int, ChapterProgress>{};
    for (final p in _box.values) {
      map[p.chapterId] = p;
    }
    return map;
  }

  ChapterProgress _getOrCreate(int chapterId) {
    return state[chapterId] ??
        ChapterProgress(chapterId: chapterId);
  }

  Future<void> toggleCompleted(int chapterId) async {
    final p = _getOrCreate(chapterId);
    p.isCompleted = !p.isCompleted;
    p.lastVisited = DateTime.now();
    await _box.put(chapterId, p);
    state = {...state, chapterId: p};
  }

  Future<void> markVisited(int chapterId) async {
    final p = _getOrCreate(chapterId);
    p.lastVisited = DateTime.now();
    await _box.put(chapterId, p);
    state = {...state, chapterId: p};
  }

  Future<void> toggleBookmark(int chapterId) async {
    final p = _getOrCreate(chapterId);
    p.isBookmarked = !p.isBookmarked;
    await _box.put(chapterId, p);
    state = {...state, chapterId: p};
  }

  bool isCompleted(int chapterId) => state[chapterId]?.isCompleted ?? false;
  bool isBookmarked(int chapterId) => state[chapterId]?.isBookmarked ?? false;
}

final progressProvider =
    NotifierProvider<ProgressNotifier, Map<int, ChapterProgress>>(
  ProgressNotifier.new,
);

final completedCountProvider = Provider<int>((ref) {
  final map = ref.watch(progressProvider);
  return map.values.where((p) => p.isCompleted).length;
});

Future<void> openProgressBox() async {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ChapterProgressAdapter());
  }
  if (!Hive.isBoxOpen(_boxName)) {
    await Hive.openBox<ChapterProgress>(_boxName);
  }
}

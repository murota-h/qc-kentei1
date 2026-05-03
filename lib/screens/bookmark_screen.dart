import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chapters.dart';
import '../models/chapter.dart';
import '../providers/progress_provider.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressMap = ref.watch(progressProvider);
    final bookmarked = allChapters
        .where((c) => progressMap[c.number]?.isBookmarked ?? false)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('ブックマーク')),
      body: bookmarked.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'ブックマークされたチャプターはありません',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarked.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final chapter = bookmarked[index];
                return _BookmarkTile(chapter: chapter);
              },
            ),
    );
  }
}

class _BookmarkTile extends ConsumerWidget {
  const _BookmarkTile({required this.chapter});

  final Chapter chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = ref.watch(
      progressProvider.select((m) => m[chapter.number]?.isCompleted ?? false),
    );

    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: chapter.color.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(chapter.icon, color: chapter.color, size: 20),
        ),
        title: Text(
          'Ch.${chapter.number} ${chapter.title}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          chapter.subtitle,
          style: const TextStyle(fontSize: 11),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCompleted)
              const Icon(Icons.check_circle, color: Colors.green, size: 18),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.bookmark, color: Colors.amber),
              onPressed: () => ref
                  .read(progressProvider.notifier)
                  .toggleBookmark(chapter.number),
            ),
          ],
        ),
        onTap: () => Navigator.of(context).pushNamed(
          '/chapter',
          arguments: chapter.number,
        ),
      ),
    );
  }
}

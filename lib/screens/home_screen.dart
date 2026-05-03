import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chapters.dart';
import '../models/chapter.dart';
import '../providers/progress_provider.dart';
import '../theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref.watch(completedCountProvider);
    final total = allChapters.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QC検定 1級 対策'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outlined),
            onPressed: () => Navigator.of(context).pushNamed('/bookmarks'),
          ),
        ],
      ),
      body: Column(
        children: [
          _ProgressHeader(completed: completed, total: total),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: allChapters.length,
              itemBuilder: (context, index) {
                final chapter = allChapters[index];
                return _ChapterCard(chapter: chapter);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : completed / total;
    return Container(
      color: AppColors.ch1,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '進捗：$completed / $total 章完了',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterCard extends ConsumerWidget {
  const _ChapterCard({required this.chapter});

  final Chapter chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted =
        ref.watch(progressProvider.select((m) => m[chapter.number]?.isCompleted ?? false));
    final isBookmarked =
        ref.watch(progressProvider.select((m) => m[chapter.number]?.isBookmarked ?? false));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          '/chapter',
          arguments: chapter.number,
        ),
        child: Column(
          children: [
            Container(
              height: 6,
              color: chapter.color,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(chapter.icon, color: chapter.color, size: 20),
                        const Spacer(),
                        if (isBookmarked)
                          Icon(Icons.bookmark, color: chapter.color, size: 16),
                        if (isCompleted)
                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ch. ${chapter.number}',
                      style: TextStyle(
                        color: chapter.color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      chapter.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chapter.subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

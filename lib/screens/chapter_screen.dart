import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chapters.dart';
import '../models/chapter.dart';
import '../providers/progress_provider.dart';
import '../widgets/content_block_widget.dart';

class ChapterScreen extends ConsumerStatefulWidget {
  const ChapterScreen({super.key, required this.chapterNumber});

  final int chapterNumber;

  @override
  ConsumerState<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends ConsumerState<ChapterScreen> {
  late Chapter _chapter;

  @override
  void initState() {
    super.initState();
    _chapter = findChapter(widget.chapterNumber)!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(progressProvider.notifier).markVisited(widget.chapterNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = ref.watch(
      progressProvider.select((m) => m[widget.chapterNumber]?.isCompleted ?? false),
    );
    final isBookmarked = ref.watch(
      progressProvider.select((m) => m[widget.chapterNumber]?.isBookmarked ?? false),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _chapter.color,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chapter ${_chapter.number}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            Text(
              _chapter.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_outline),
            onPressed: () =>
                ref.read(progressProvider.notifier).toggleBookmark(widget.chapterNumber),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: _chapter.blocks.length,
        itemBuilder: (context, index) {
          return ContentBlockWidget(
            block: _chapter.blocks[index],
            chapterColor: _chapter.color,
          );
        },
      ),
      bottomNavigationBar: _CompletionBar(
        chapter: _chapter,
        isCompleted: isCompleted,
        onToggle: () =>
            ref.read(progressProvider.notifier).toggleCompleted(widget.chapterNumber),
      ),
    );
  }
}

class _CompletionBar extends StatelessWidget {
  const _CompletionBar({
    required this.chapter,
    required this.isCompleted,
    required this.onToggle,
  });

  final Chapter chapter;
  final bool isCompleted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onToggle,
          style: ElevatedButton.styleFrom(
            backgroundColor: isCompleted ? Colors.green : chapter.color,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
          ),
          icon: Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked),
          label: Text(isCompleted ? '完了済み（タップで取り消し）' : 'このチャプターを完了にする'),
        ),
      ),
    );
  }
}

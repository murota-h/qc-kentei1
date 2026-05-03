import 'package:hive_flutter/hive_flutter.dart';

class ChapterProgress extends HiveObject {
  int chapterId;
  bool isCompleted;
  bool isBookmarked;
  DateTime? lastVisited;

  ChapterProgress({
    required this.chapterId,
    this.isCompleted = false,
    this.isBookmarked = false,
    this.lastVisited,
  });
}

class ChapterProgressAdapter extends TypeAdapter<ChapterProgress> {
  @override
  final int typeId = 0;

  @override
  ChapterProgress read(BinaryReader reader) {
    final chapterId = reader.readInt();
    final isCompleted = reader.readBool();
    final isBookmarked = reader.readBool();
    final hasDate = reader.readBool();
    final lastVisited = hasDate
        ? DateTime.fromMillisecondsSinceEpoch(reader.readInt())
        : null;
    return ChapterProgress(
      chapterId: chapterId,
      isCompleted: isCompleted,
      isBookmarked: isBookmarked,
      lastVisited: lastVisited,
    );
  }

  @override
  void write(BinaryWriter writer, ChapterProgress obj) {
    writer.writeInt(obj.chapterId);
    writer.writeBool(obj.isCompleted);
    writer.writeBool(obj.isBookmarked);
    if (obj.lastVisited != null) {
      writer.writeBool(true);
      writer.writeInt(obj.lastVisited!.millisecondsSinceEpoch);
    } else {
      writer.writeBool(false);
    }
  }
}

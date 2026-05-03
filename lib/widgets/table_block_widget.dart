import 'package:flutter/material.dart';
import '../models/content_block.dart';

class TableBlockWidget extends StatelessWidget {
  const TableBlockWidget({super.key, required this.block});

  final TableBlock block;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (block.title != null) ...[
          Text(
            block.title!,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
        ],
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(color: Colors.grey[300]!, width: 0.5),
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[200]),
                children: block.headers
                    .map(
                      (h) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        child: Text(
                          h,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
              ),
              ...block.rows.asMap().entries.map(
                    (entry) => TableRow(
                      decoration: BoxDecoration(
                        color: entry.key.isEven ? Colors.white : Colors.grey[50],
                      ),
                      children: entry.value
                          .map(
                            (cell) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: Text(cell, style: const TextStyle(fontSize: 12, height: 1.5)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

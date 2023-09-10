import 'package:flutter/material.dart';

class ListItemOne extends StatelessWidget {
  final String title;
  final String subtitle;
  final String subtitle_2;

  const ListItemOne({
    required this.title,
    required this.subtitle,
    required this.subtitle_2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 2.0)),
            Expanded(
              child: Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ),
            Text(
              subtitle_2,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.black87,
              ),
            ),
          ],
        ));
  }
}

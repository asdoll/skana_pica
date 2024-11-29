import 'package:flutter/material.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widget_utils.dart';

class PicaTag extends StatefulWidget {
  final String text;
  final String type;

  const PicaTag({required this.text, required this.type, super.key});

  @override
  State<PicaTag> createState() => _PicaTagState();
}

class _PicaTagState extends State<PicaTag> {
  String get type => widget.type;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        switch (type) {
          case 'tag':
          case 'category':
          case 'author':
            //Go.to(MePage());
            break;
          default:
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: context.colorScheme.primaryContainer,
        ),
        child: Text(widget.text, style: Theme.of(context).textTheme.bodySmall),
      ).rounded(16.0),
    );
  }
}

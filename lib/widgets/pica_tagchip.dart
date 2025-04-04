import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/blocker.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widget_utils.dart';

class PicaTag extends StatefulWidget {
  final String text;
  final String type;
  final TextStyle? style;
  final Color? backgroundColor;

  const PicaTag(
      {this.style,
      required this.text,
      required this.type,
      super.key,
      this.backgroundColor});

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
           Go.to(PicaCatComicsPage(id: widget.text, type: "search"),
                preventDuplicates: false);
            break;
          case 'category':
          case 'author':
            Go.to(PicaCatComicsPage(id: widget.text, type: type),
                preventDuplicates: false);
            break;
          default:
            break;
        }
      },
      onLongPress: () {
        if (widget.type == 'tag' || widget.type == 'category') {
          blockDialog(context, widget.text);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.backgroundColor ?? context.colorScheme.primaryContainer,
        ),
        child: Text(widget.text,
            style: widget.style ?? Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}

void blockDialog(BuildContext context, String keyword) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${"Block keyword".tr}"$keyword"?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'.tr)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  blocker.addKeyword(keyword);
                  toast('${"Block keyword".tr}"$keyword"');
                },
                child: Text('Ok'.tr)),
          ],
        );
      });
}

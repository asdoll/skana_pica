import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/blocker.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class PicaTag extends StatefulWidget {
  final String text;
  final String type;
  final Color? backgroundColor;

  const PicaTag(
      {required this.text,
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
          color: widget.backgroundColor ??
              context.moonTheme?.tokens.colors.frieza60,
        ),
        child: Transform.translate(
            offset: Offset(0, -1), child: Text(widget.text).small()),
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
                  showToast('${"Block keyword".tr}"$keyword"');
                },
                child: Text('Ok'.tr)),
          ],
        );
      });
}

class TagFinished extends StatelessWidget {
  const TagFinished({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Get.context!.moonTheme?.tokens.colors.cell60,
        ),
        child: Transform.translate(
            offset: Offset(0, -1), child: Text("Finished".tr).xSmall()));
  }
}

ChoiceChip picaChoiceChip(
    {required String text,
    required bool selected,
    required Function(bool) onSelected,
    Color? backgroundColor,
    Color? selectedColor,
    Color? disabledColor}) {
  return ChoiceChip(
    label: Text(
      text,
      style: Get.context!.moonTheme?.tokens.typography.heading.text12.apply(
        color: Get.context!.moonTheme?.tokens.colors.bulma,
      ),
    ).small(),
    selected: selected,
    onSelected: onSelected,
    selectedColor: selectedColor?.applyDarkMode(reverse: true, percent: 40) ?? Get.context!.moonTheme?.tokens.colors.cell
        .applyDarkMode(reverse: true, percent: 40),
    backgroundColor: backgroundColor ?? Get.context!.moonTheme?.tokens.colors.cell60,
    disabledColor: disabledColor ?? Get.context!.moonTheme?.tokens.colors.cell60,
    checkmarkColor: Get.context!.moonTheme?.tokens.colors.bulma,
  );
}

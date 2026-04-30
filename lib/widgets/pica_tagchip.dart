import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skana_pica/controller/blocker.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/util/widgetplugin.dart';

class PicaTag extends HookConsumerWidget {
  final String text;
  final String type;
  final Color? backgroundColor;

  const PicaTag(
      {required this.text,
      required this.type,
      super.key,
      this.backgroundColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        switch (type) {
          case 'tag':
            Go.to(PicaCatComicsPage(id: text, type: "search"));
            break;
          case 'category':
          case 'author':
            Go.to(PicaCatComicsPage(id: text, type: type));
            break;
          default:
            break;
        }
      },
      onLongPress: () {
        if (type == 'tag' || type == 'category') {
          blockDialog(context, text, ref);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor ??
              context.moonTheme?.tokens.colors.frieza60,
        ),
        child: Transform.translate(
            offset: Offset(0, -1), child: Text(text).small()),
      ),
    );
  }
}

void blockDialog(BuildContext context, String keyword, WidgetRef ref) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${"block_keyword".tr()}"$keyword"?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('cancel'.tr())),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(blockerProvider.notifier).addKeyword(keyword);
                  showToast('${"block_keyword".tr()}"$keyword"');
                },
                child: Text('ok'.tr())),
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
          color: context.moonTheme?.tokens.colors.cell60,
        ),
        child: Transform.translate(
            offset: Offset(0, -1), child: Text("finished".tr()).xSmall()));
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
      style: Go.context!.moonTheme?.tokens.typography.heading.text12.apply(
        color: Go.context!.moonTheme?.tokens.colors.bulma,
      ),
    ).small(),
    selected: selected,
    onSelected: onSelected,
    selectedColor: selectedColor?.applyDarkMode(reverse: true, percent: 40) ?? Go.context!.moonTheme?.tokens.colors.hit
        .applyDarkMode(reverse: true, percent: 40),
    backgroundColor: backgroundColor ?? Go.context!.moonTheme?.tokens.colors.cell60,
    disabledColor: disabledColor ?? Go.context!.moonTheme?.tokens.colors.cell60,
    checkmarkColor: Go.context!.moonTheme?.tokens.colors.bulma,
  );
}

Chip picaDeleteChip({required String text, required Function() onDeleted, Color? backgroundColor}) {
  return Chip(
    label: Text(
      text,
      style: Go.context!.moonTheme?.tokens.typography.heading.text12.apply(
        color: Go.context!.moonTheme?.tokens.colors.bulma,
      ),
    ).small(),
    backgroundColor: backgroundColor ?? Go.context!.moonTheme?.tokens.colors.cell60,
    deleteIcon: const Icon(BootstrapIcons.x),
    onDeleted: onDeleted,
  );
}



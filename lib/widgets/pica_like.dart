import 'package:flutter/material.dart';

class PicaFavorButton extends StatefulWidget {
  final String id;

  const PicaFavorButton(this.id, {super.key});

  @override
  State<PicaFavorButton> createState() => _PicaFavorButtonState();
}

class _PicaFavorButtonState extends State<PicaFavorButton> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
      onPressed: () {
        setState(() {
          liked = !liked;
        });
      },
    );
  }
}
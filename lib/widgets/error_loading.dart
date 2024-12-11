import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/api/managers/image_cache_manager.dart'
    show imageProvider;
import 'package:skana_pica/controller/comiclist.dart' show errorUrl;

class ErrorLoading extends StatelessWidget {
  final String text;

  const ErrorLoading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: imageProvider(errorUrl), width: 50, height: 50),
          SizedBox(
            height: 10,
          ),
          Text(
            text,
            style: Get.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

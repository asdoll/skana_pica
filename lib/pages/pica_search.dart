import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/controller/categories.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/pages/pica_list_comics.dart';
import 'package:skana_pica/util/leaders.dart';

class PicaSearchPage extends StatefulWidget {
  static const route = "${Mains.route}search";

  const PicaSearchPage({super.key});

  @override
  State<PicaSearchPage> createState() => _PicaSearchPageState();
}

class _PicaSearchPageState extends State<PicaSearchPage> {
  final List<String> sampleList = List.generate(6, (index) => 'Item $index');
  late SearchController controller;
  late CategoriesController categoriesController;

  @override
  void initState() {
    super.initState();
    controller = SearchController();
    categoriesController = Get.put(CategoriesController());
    categoriesController.fetchCategories();
  }

  @override
  void dispose() {
    controller.dispose();
    Get.delete<CategoriesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchAnchor.bar(
            searchController: controller,
            isFullScreen: false,
            onSubmitted: onSubmitted,
            suggestionsBuilder: (context, controller) {
              return sampleList
                  .where((element) => element
                      .toLowerCase()
                      .contains(controller.text.toLowerCase()))
                  .map((e) => ListTile(
                        title: Text(e),
                        onTap: () {
                          controller.text = e;
                        },
                      ))
                  .toList();
            }),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: categoriesController.categories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Go.to(PicaCatComicsPage(
                    id: categoriesController.categories[index],
                    type: "category"),preventDuplicates: false),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        categoriesController.getCoverImg(
                            categoriesController.categories[index]),
                        fit: BoxFit.cover,
                        width: 300,
                        height: 300,
                      ),
                      Opacity(
                        opacity: 0.4,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                categoriesController.categories[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void onSubmitted(String value) {}
}

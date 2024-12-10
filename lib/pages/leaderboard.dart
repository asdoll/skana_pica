import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skana_pica/pages/mainscreen.dart';
import 'package:skana_pica/util/leaders.dart';
import 'package:skana_pica/widgets/pica_comic_list.dart';

class LeaderboardPage extends StatefulWidget {
  static const route = "${Mains.route}leaderboard";
  final bool isMain;

  const LeaderboardPage({super.key, this.isMain = false});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.leaderboard),
              Expanded(
                child: Text("Leaderboard".tr),
              ),
              DropdownButton<String>(
                  items: leaderboardController.items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    leaderboardController.type.value = value!;
                    Leader.mainScreenEasyRefreshController.callRefresh();
                  },
                  value: leaderboardController.type.value),
            ],
          ),
        ),
        body: PicaComicsPage(
            keyword: "leaderboard",
            type: leaderboardController.type.value,
            isMain: widget.isMain,
            easyRefreshController: Leader.mainScreenEasyRefreshController),
      ),
    );
  }
}

class LeaderboardController extends GetxController {
  var items = ["H24", "D7", "D30"];
  var type = "H24".obs;
}

LeaderboardController leaderboardController = Get.put(LeaderboardController());

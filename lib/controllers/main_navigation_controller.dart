import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  var currentIndex = 0.obs;
  
  final List<String> tabTitles = [
    '홈',
    'AI추천',
    '알바지도',
    '채팅',
    '마이페이지',
  ];
  
  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
  
  String get currentTitle => tabTitles[currentIndex.value];
}

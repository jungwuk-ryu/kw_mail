import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kw_mail/controller/setting_controller.dart';
import 'package:kw_mail/entity/mail_box.dart';
import 'package:kw_mail/utils/api_manager.dart';
import 'package:kw_mail/utils/my_utils.dart';
import 'package:kw_mail/view/setting_view.dart';
import 'package:sidebarx/sidebarx.dart';

import '../entity/mail_item.dart';

class HomeController extends GetxController {
  final ApiManager _apiManager = Get.find<ApiManager>();
  final PagingController<int, MailItem> pagingController = PagingController(firstPageKey: 0);
  final SidebarXController sidebarController = SidebarXController(selectedIndex: 0, extended: true);
  final List<MailBox> mailBoxList = [];

  RxBool isLoading = RxBool(true);
  int _oldSelectedIndex = 0;
  RxList<MailItem> mailList = RxList();

  @override
  void onInit() {
    super.onInit();
    _initMailBoxList();
    _initSidebarController();
    _initPagingController();
    isLoading.value = false;
  }

  void _initMailBoxList() {
    mailBoxList.add(MailBox(boxId: "INBOX", name: "받은 메일"));
    mailBoxList.add(MailBox(boxId: "Sent", name: "보낸 메일"));
  }

  void _initPagingController() {
    pagingController.addPageRequestListener((pageKey) async {
      List<MailItem>? newMailList = await _fetchPage(pageKey);
      if (newMailList == null) {
        MyUtils.snackbar("메일 목록을 불러오지 못했어요", status: SnackStatus.error);
        return;
      }

      if (newMailList.isEmpty) {
        pagingController.appendLastPage([]);
        return;
      }

      pagingController.appendPage(newMailList, pageKey + 1);
    });
  }

  void _initSidebarController() {
    sidebarController.addListener(() {
      int index = sidebarController.selectedIndex;

      if (index == mailBoxList.length) {
        sidebarController.selectIndex(_oldSelectedIndex);
        Get.to(GetBuilder(init: SettingController(), builder: (controller) => SettingView()));
      } else {
        if (_oldSelectedIndex == index) return;
        pagingController.refresh();
      }

      _oldSelectedIndex = sidebarController.selectedIndex;
    });
  }

  MailBox getCurrentMailBox() {
    return mailBoxList[sidebarController.selectedIndex];
  }

  Future<List<MailItem>?> _fetchPage(int page) async {
    return await _apiManager.getWebMailList(getCurrentMailBox().boxId, page);
  }
}
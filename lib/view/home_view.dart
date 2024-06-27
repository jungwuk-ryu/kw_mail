import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kw_mail/controller/HomeController.dart';
import 'package:sidebarx/sidebarx.dart';

import '../entity/mail_item.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarX(
        controller: controller.sidebarController,
        items: const [
          SidebarXItem(icon: Icons.home, label: '받은 메일'),
          SidebarXItem(icon: Icons.send_rounded, label: '보낸 메일'),
          SidebarXItem(icon: Icons.settings, label: '설정'),
        ],
      ),
      body: SafeArea(
        child: body(),
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Text(controller.getCurrentMailBox().name),
        Divider(),
        Expanded(child: mailListContaier())
      ],
    );
  }

  Widget loadingContainer() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Text("로드 중"),
      ],
    );
  }

  Widget mailListContaier() {
    return PagedListView<int, MailItem>(
      pagingController: controller.pagingController,
      builderDelegate: PagedChildBuilderDelegate<MailItem>(
        itemBuilder: (context, item, index) => MailItemContainer(item)
      ),
    );
  }
}

class MailItemContainer extends StatelessWidget {
  final MailItem mail;

  const MailItemContainer(this.mail, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(mail.title),
        Text(mail.fromName),
      ],
    );
  }
}
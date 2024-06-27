import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kw_mail/controller/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: body(),
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("설정")
          ],
        ),

        Divider(),
        Container(
          width: double.infinity,
          height: 20.h,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15.r)
          ),
          child: const Text("로그아웃"),
        )
      ],
    );
  }

}
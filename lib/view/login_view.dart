import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:kw_mail/controller/login_controller.dart';
import 'package:kw_mail/service/account_service.dart';
import 'package:kw_mail/utils/api_manager.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Expanded(child: SizedBox()),
        Text("광운대 웹메일 로그인"),
        TextField(controller: controller.usernameFieldController),
        TextField(controller: controller.passwordFieldController),
        Text("비밀번호를 잊으셨나요?"),
        Container(
          width: double.infinity,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueAccent
          ),
          child: GestureDetector(
            onTap: () async {
              await controller.login();
            },
            child: Center(child: Text("로그인")),
          ),
        )
      ],
    );
  }
}
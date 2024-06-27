import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar_controller.dart';

class MyUtils {
  /// 마지막으로 표시된 스낵바의 컨트롤러
  static SnackbarController? _snackbarController;

  static String webMailSHA256(String s) {
    // UTF-8 인코딩
    List<int> messageBytes = utf8.encode(s);

    // SHA-256 해시 값 계산
    Digest digest = sha256.convert(messageBytes);

    // 16진수로 변환
    String hexHash = digest.toString();

    return hexHash;
  }

  static String webMailRawSHA256(String s) {
    /* s = Utf8Encode(s);
	var hash = CryptoJS.SHA256(s);
	return hash.toString(CryptoJS.enc.Base64); */
    // UTF-8 인코딩
    List<int> messageBytes = utf8.encode(s);

    // SHA-256 해시 값 계산
    Digest digest = sha256.convert(messageBytes);

    // Base64 인코딩
    return base64Encode(digest.bytes);
  }

  static String calculateMD5(String s) {
    var bytes = utf8.encode(s); // 문자열을 바이트 배열로 변환
    var digest = md5.convert(bytes); // MD5 해시 계산

    return digest.toString(); // 해시 값을 문자열로 반환
  }

  static Future<void> closeSnackbarNow() async {
    if (_snackbarController != null) {
      try {
        await _snackbarController!.close(withAnimations: false);
        SnackbarController tmp = _snackbarController!;
        _snackbarController = null;
        await tmp.close();
      } catch (_) {}
    }
  }

  static void snackbar(content, {title, SnackStatus? status}) async {
    IconData icon;
    Color backgroundColor;
    if (status == SnackStatus.warn) {
      icon = Icons.warning_amber_rounded;
      backgroundColor = const Color(0xFF603900);
    } else if (status == SnackStatus.error) {
      icon = Icons.error_outline_rounded;
      backgroundColor = const Color(0xFF4A0000);
    } else {
      icon = Icons.info_outline_rounded;
      backgroundColor = const Color(0xFF202020);
    }

    if (title == null || (title is String && title.isEmpty)) {
      title = null;
    } else {
      title = '$title';
    }

    if (content == null || (content is String && content.isEmpty)) {
      content = null;
    } else {
      content = '$content';
    }

    // 현재 표시되고 있는 스낵바 강제로 닫기
    await closeSnackbarNow();

    _snackbarController = Get.showSnackbar(GetSnackBar(
        titleText: title == null
            ? null
            : Text(title,
            style: TextStyle(
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.white)),
        messageText: content == null
            ? null
            : Text(content,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                fontSize: 13.sp)),
        backgroundColor: backgroundColor,
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(icon, size: 12.r),
        duration: const Duration(seconds: 2),
        padding: const EdgeInsets.all(15).r,
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 7.h),
        forwardAnimationCurve: Curves.easeOutCirc,
        reverseAnimationCurve: Curves.easeOutCirc,
        borderRadius: 8.r));
  }

}

enum SnackStatus {
  info, warn, error;
}

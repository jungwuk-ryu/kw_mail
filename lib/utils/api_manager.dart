import 'dart:convert';

import 'package:get/get.dart';
import 'package:kw_mail/entity/mail.dart';
import 'package:kw_mail/entity/mail_item.dart';
import 'package:kw_mail/utils/custom_get_connect.dart';

import 'my_utils.dart';

class ApiManager extends CustomGetConnect implements GetxService {
  static const String contentTypeForm = "application/x-www-form-urlencoded";
  static const String contentTypeJson = "application/json";

  static const String webMail = "https://wmail.kw.ac.kr/";
  static const String webMailLoginPage = "${webMail}index.jsp";
  static const String loginCrd = "${webMail}user/login.crd";
  static const String processCrd = "${webMail}user/process.crd";
  static const String webMailMain =
      "${webMail}main.crd#module%3Djson.mail.MailList%26page%3D1%26nPage%3D1%26folder%3DINBOX";
  static const String mailList = "${webMail}json/mail/MailList";
  static const String mailViewInfo = "${webMail}json/mail/MailViewInfo";

  Future<void> webmailLogin(String id, String pw) async {
    //await get(webMailLoginPage, contentType: contentTypeForm);
 //   id += "aa";

    Map<String, dynamic> loginBody = {
      'charset': 'EUC-KR',
      'my_char_set': 'default',
      'userdomain': 'kw.ac.kr',
      'locale': 'ko',
      'en_type': 'S',
      'en_userpass_md5': MyUtils.calculateMD5(pw),
      'en_userpass_sha2': MyUtils.webMailSHA256(pw),
      'en_userpass_rawsha2': MyUtils.webMailRawSHA256(pw),
      'server_type': '1',
      'userid': id,
      'userpass': '',
    };

    Response rs = await post(loginCrd, loginBody, contentType: contentTypeForm);
    await get(
        "$processCrd?credimail.sessionKey=${getCookie(
            "userInfo")}&redirect=");
    Response result = await get(webMailMain);
    print("성공 여부 : ${result.bodyString?.contains("main_fr")}");

  }

  Future<List<MailItem>?> getWebMailList(String boxId, int page) async {
    print(boxId);
    print(page);
    Response response = await post(mailList,
        "module=json.mail.MailList&folder=$boxId&prefolder=&cmd=&page_size=&page=$page&nPage=1&sequence=&sort=&msg_id=&msgIds=&method_=&checkedIds=&uncheckedIds=&seqShare=&rowNum=&preview_use=&target=&mvmail=&filter=&seqNum=&preNext_gubun=&treecmd=&srcMailBox=&dstMailbox=&search_field=&search_keyword=&search_gubun=package&menuFunction=&mail_list_gubun=&from=&mailto=&search_start=&search_end=&search=&subject=&bodytext=&fromname=&attachname=&attachbody=&mailbox=&searchdate=&tag=",
    contentType: contentTypeJson);
    if (!response.isOk) return null;

    List<MailItem> mails = [];
    try {
      Map data = jsonDecode(response.bodyString!);
      Map resultSet = data['resultSet'];
      List iLines = resultSet['iLines'];

      for (Map obj in iLines) {
        Map ILine = obj["ILine"];
        MailItem mail = MailItem(title: ILine["subject"],
            fromName: ILine["fromname"],
            id: ILine["msgid"]);
        mails.add(mail);
      }
    } catch (_) {}

    return mails;
  }

  Future<Mail?> getMail(String id) async {
    String encodedId = Uri.encodeComponent(id);
    Response response = await post(mailViewInfo, {
      "module": "json.mail.MailList",
      "submodule": "json.mail.MailViewInfo",
      "folder": "INBOX",
      "prefolder": "",
      "cmd": "",
      "page_size": "",
      "page": "1",
      "nPage": "1",
      "sequence": "1",
      "seqNum": "1",
      "sort": "",
      "msg_id": encodedId,
      "msgIds": "",
      "method_": "view",
      "checkedIds": "",
      "uncheckedIds": "",
      "seqShare": "",
      "rowNum": "",
      "securitylevel": "",
      "mvmail": "",
      "filter": "",
      "mail_list_gubun": "",
      "preNext_gubun": "",
      "char_set": "",
      "list_size": "",
      "folder_seq": "",
      "fileName": "",
      "realfileName": "",
      "check_all": "",
      "search_field": "",
      "search_keyword": "",
      "search_gubun": "",
      "msgid": "",
      "attach_num": "",
      "attach_name": ""
    },
    contentType: contentTypeJson);

    if (response.hasError) {
      return null;
    }

    Map resultSet = jsonDecode(response.bodyString!)['resultSet'];
    Mail mail = Mail.fromResultSet(resultSet);

    return mail;
  }
}
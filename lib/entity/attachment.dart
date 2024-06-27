class Attachment {
  final String name; // fileName
  final String encodedName; // attach_eml
  final String originalName; // attach_ori_eml
  final String msgId;

  Attachment({required this.encodedName, required this.originalName, required this.name, required this.msgId});

  String getDownloadUrl() {
    return "https://wmail.kw.ac.kr/mail/attachDownload.crd?fileName=$encodedName&"
        "msg_id=${Uri.encodeComponent(msgId)}&"
        "orifileName=$originalName";
  }
}
import 'attachment.dart';

class Mail {
  final String id; // msg_id
  final String body; // body
  final String fromName; // from_name
  final String fromAddress; // from_parse
  final String stringDate; // x_date
  final List<Attachment> attachments;

  Mail(
      {required this.id,
        required this.body,
        required this.fromName,
        required this.fromAddress,
        required this.stringDate,
        required this.attachments});

  factory Mail.fromResultSet(Map resultSet) {
    Map mailEml = resultSet['mailEml'];
    List<Attachment> atts = [];
    List<Map> attsRaw = resultSet['attachInfo'];
    
    for (Map attRaw in attsRaw) {
      Attachment attachment = Attachment(encodedName: attRaw['fileName'],
          originalName: attRaw['attach_eml'],
          name: attRaw['attach_ori_eml'],
          msgId: resultSet['mlEntity']['msg_id']);
      atts.add(attachment);
    }

    return Mail(id: mailEml['msg_id'],
        body: mailEml['body'],
        fromName: mailEml['from_name'],
        fromAddress: mailEml['from_parse'],
        stringDate: mailEml['x_date'],
        attachments: atts);
  }
}
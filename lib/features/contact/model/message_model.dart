class MessageModel {
  final String name;
  final String gmail;
  final String subject;
  final String message;
  final String hinttext;

  const MessageModel({
    required this.name,
    required this.gmail,
    required this.subject,
    required this.message,
    required this.hinttext,
  });
}

const List<MessageModel> messageModel = [
  MessageModel(
    name: 'Name',
    gmail: 'Email',
    subject: "Subject",
    message: "Message",
    hinttext: "How Can I help you?",
  ),
];

const String nameHintText = 'Enter your name...';
const String gmailHintText = 'Enter your gmail...';
const String subjectHintText = 'Enter your subject...';

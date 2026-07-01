class MessageModel {
  final String firstName;
  final String lastName;
  final String gmail;
  final String phone;
  final String subject;
  final String message;
  final String hinttext;

  const MessageModel({
    required this.firstName,
    required this.lastName,
    required this.gmail,
    required this.phone,
    required this.subject,
    required this.message,
    required this.hinttext,
  });
}

const List<MessageModel> messageModel = [
  MessageModel(
    firstName: 'First Name',
    lastName : 'Last Name',
    gmail    : 'Email',
    phone    : 'Phone',
    subject  : "Subject",
    message  : "Message",
    hinttext : "How Can I help you?",
  ),
];

const String firstNameHintText = 'Enter your first name...';
const String lastNameHintText  = 'Enter your last name...';
const String gmailHintText     = 'Enter your gmail...';
const String phoneHintText     = 'Enter your phone number...';
const String subjectHintText   = 'Enter your subject...';
const String errormessage      = 'Could not send message';
const String overlay           = 'success-overlay';
const String successmessage    = 'Message Sent Successfully!';
const String callback          = 'I\'ll get back to you soon!';
const String emply             = 'empty';

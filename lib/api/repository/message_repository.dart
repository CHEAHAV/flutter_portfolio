import 'package:portfolio/api/core/api_client.dart';
import 'package:portfolio/api/core/api_object.dart';
import 'package:portfolio/api/model/message.dart';
import 'package:portfolio/routes/api_route.dart';

Message mapMessage(Map<String, dynamic> item) {
  return Message(
    id: ApiObject.resolveID(item),
    firstname: ApiObject.resolveFirstName(item),
    lastname: ApiObject.resolveLastName(item),
    email: ApiObject.resolveEmail(item),
    phone: ApiObject.resolvePhone(item),
    subject: ApiObject.resolveSubject(item),
    message: ApiObject.resolveMessage(item),
  );
}

Future<void> sendContactMessage({
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
  required String subject,
  required String message,
  ApiClient? apiClient,
}) async {
  final client = apiClient ?? ApiClient();
  await client.postWebsiteForm(ApiRoutes.createMessage, {
    'first_name': firstName,
    'last_name' : lastName,
    'email'     : email,
    'phone'     : phone,
    'subject'   : subject,
    'message'   : message,
  });
}

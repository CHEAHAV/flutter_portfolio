import 'package:flutter/material.dart';
import '../../contact/contact.dart';
import '../../../api/api.dart' hide Message;
import '../../../shared/shared.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({
    super.key,
    required this.contactBackendMessage,
    this.onProfileTap,
  });

  final List<ContactBackendMessage> contactBackendMessage;
  final VoidCallback? onProfileTap;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Future<ApiModel> apiModelFuture;
  Info? _info;

  @override
  void initState() {
    super.initState();
    apiModelFuture = loadApiModel();
  }

  Future<ApiModel> loadApiModel() {
    return ApiRepository().loadApiModel();
  }

  void _retryLoadContactContent() {
    setState(() {
      apiModelFuture = loadApiModel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          apiModelFuture = loadApiModel();
        });
        await apiModelFuture;
      },
      child: Scaffold(
        appBar: MyAppBar(
          info: _info,
          index: 2,
          onProfileTap: widget.onProfileTap,
          contactme: [],
        ),
        body: FutureBuilder<ApiModel>(
          future: apiModelFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return BackendMessage(
                title: contactBackendMessage[0].title,
                message: contactBackendMessage[0].message,
                actionLabel: contactBackendMessage[0].actionLabel,
                onActionPressed: _retryLoadContactContent,
              );
            }

            final content = snapshot.data;
            if (content == null) {
              return BackendMessage(
                title: contactBackendMessage[1].title,
                message: contactBackendMessage[1].message,
              );
            }
            if (_info == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(
                  () => _info = content.info.isNotEmpty
                      ? content.info.first
                      : null,
                );
              });
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(title, style: AppStyle.headline2),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    child: Text(
                      description,
                      style: AppStyle.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (content.contactme.isNotEmpty)
                    ConnectDirect(contactme: content.contactme),
                  SizedBox(height: 10),
                  if (content.social.isNotEmpty)
                    Contact(social: content.social),
                  SizedBox(height: 10),
                  const Message(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

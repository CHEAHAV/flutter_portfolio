import 'package:flutter/material.dart';
import 'package:portfolio/api/repository/api_repository.dart';
import 'package:portfolio/api/model/api_model.dart';
import 'package:portfolio/api/model/info.dart';
import 'package:portfolio/features/contact/controller/contact.dart';
import 'package:portfolio/features/contact/controller/connect_direct.dart';
import 'package:portfolio/features/contact/controller/message.dart';
import 'package:portfolio/features/contact/model/contactbackend_message.dart';
import 'package:portfolio/features/contact/model/work.dart';
import 'package:portfolio/shared/components/backend_message.dart';
import 'package:portfolio/shared/components/myapp_bar.dart';
import 'package:portfolio/shared/style/style.dart';

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
          onProfileTap: widget.onProfileTap, contactme: [],
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
                  Message(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

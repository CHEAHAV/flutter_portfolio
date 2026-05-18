import 'package:flutter/material.dart';
import 'package:portfolio/features/contact/controller/connect_direct.dart';
import 'package:portfolio/features/contact/controller/contact.dart';
import 'package:portfolio/features/contact/controller/message.dart';
import 'package:portfolio/features/contact/model/work.dart';
import 'package:portfolio/features/home/model/home_model.dart';
import 'package:portfolio/shared/components/divider.dart';
import 'package:portfolio/shared/style/style.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final HomeModel homeModel = HomeModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(homeModel.headerdata.imageUrl),
              radius: 20,
            ),
            SizedBox(width: 16),
            Text(homeModel.headerdata.name, style: AppStyle.headline1),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(homeModel.headerdata.icon)),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: AppDivider(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: AppStyle.headline2),
              SizedBox(height: 10),
              Text(description, style: AppStyle.bodyLarge),
              SizedBox(height: 20),
              ConnectDirect(),
              SizedBox(height: 10),
              Contact(),
              SizedBox(height: 10),
              Message(),
            ],
          ),
        ),
      ),
    );
  }
}

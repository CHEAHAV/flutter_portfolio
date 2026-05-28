import 'package:flutter/material.dart';
import 'package:portfolio/api/model/contact_me.dart';
import 'package:portfolio/api/model/info.dart';
import 'package:portfolio/features/contact/model/connect_direct_url.dart';
import 'package:portfolio/features/home/model/headerdata.dart';
import 'package:portfolio/routes/app_route.dart';
import 'package:portfolio/shared/components/divider.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    required this.info,
    required this.index,
    this.onProfileTap,
    required this.contactme,
  });

  final Info? info;
  final int index;
  final VoidCallback? onProfileTap;
  final List<ContactMe> contactme;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

class _MyAppBarState extends State<MyAppBar> {
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      _showLinkError();
    }
  }

  Future<void> _openContactUrl(ContactMe item) async {
    final url = ConnectDirectUrl.urlForName(item.name);
    if (url == null) {
      _showLinkError();
      return;
    }

    await _openUrl(url);
  }

  Future<void> _openEmail() async {
    for (final item in widget.contactme) {
      final url = ConnectDirectUrl.urlForName(item.name);
      if (url == ConnectDirectUrl.emailUrl) {
        await _openContactUrl(item);
        return;
      }
    }

    await _openUrl(ConnectDirectUrl.emailUrl);
  }

  void _showLinkError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open this contact link')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerIndex = widget.index >= 0 && widget.index < headerdata.length
        ? widget.index
        : 0;

    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: GestureDetector(
              onTap:
                  widget.onProfileTap ??
                  () => Navigator.pushNamed(context, AppRoute.profilePageRoute),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundImage: widget.info != null
                      ? NetworkImage(widget.info!.image)
                      : null,
                  radius: 20,
                  child: widget.info == null
                      ? const Icon(Icons.person, size: 20)
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.accent, AppColors.accentPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              headerdata[headerIndex].name.toUpperCase(),
              style: AppStyle.headline1.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Email',
          onPressed: _openEmail,
          icon: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.accent, AppColors.accentPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: const Icon(Icons.email),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: AppDivider(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../features/home/home.dart';
import '../../routes/route.dart';
import '../../shared/shared.dart';

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
  List<ContactMe> _backendContactme = const [];
  bool            _loadingContactme = false;

  List<ContactMe> get _contactme => 
      widget.contactme.isNotEmpty ? widget.contactme: _backendContactme;

  @override
  void initState() {
    super.initState();
    _loadBackendContactmeIfNeeded();
  }

  @override
  void didUpdateWidget(covariant MyAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.contactme.isEmpty && oldWidget.contactme != widget.contactme) {
      _loadBackendContactmeIfNeeded();
    }
  }

  Future<void> _loadBackendContactmeIfNeeded() async {
    if (widget.contactme.isNotEmpty ||
        _backendContactme.isNotEmpty ||
        _loadingContactme) {
      return;
    }

    _loadingContactme = true;
    try {
      final content = await ApiRepository().loadApiModel();
      if (mounted) {
        setState(() {
          _backendContactme = content.contactme;
        });
      }
    } catch (_) {
          // Keep the app bar usable; pressing email will show the link error.
    } finally {
      _loadingContactme = false;
    }
  }

  Future<void> _openUrl(String url) async {
    final opened = await ExternalLink.open(url);
    if (!opened && mounted) {
      _showLinkError();
    }
  }

  Future<void> _openContactUrl(ContactMe item) async {
    await _openUrl(item.effectiveContactUrl);
  }

  Future<void> _openEmail() async {
    await _loadBackendContactmeIfNeeded();

    for (final item in _contactme) {
      final normalizedName        = item.name.toLowerCase();
      final normalizedDescription = item.description.toLowerCase();
      final isEmailContact        = 
          normalizedName.contains('email') ||
          normalizedName.contains('mail') ||
          normalizedDescription.contains('@') ||
          item.effectiveContactUrl.toLowerCase().startsWith('mailto:') ||
          item.effectiveContactUrl.toLowerCase().contains('mail.google.com');

      if (isEmailContact && item.effectiveContactUrl.trim().isNotEmpty) {
        await _openContactUrl(item);
        return;
      }
    }

    if (mounted) {
      _showLinkError();
    }
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
        :   0;

    return AppBar(
      automaticallyImplyLeading: false,
      title                    : Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape : BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: GestureDetector(
              onTap: 
                  widget.onProfileTap ??
                  () => Navigator.pushNamed(context, AppRoute.profilePageRoute),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child  : CircleAvatar(
                  backgroundImage: widget.info != null
                      ? NetworkImage(widget.info!.image)
                        :   null,
                  radius: 20,
                  child : widget.info == null
                      ? const Icon(Icons.person, size: 20)
                      :   null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.accent, AppColors.accentPurple],
              begin : Alignment.topLeft,
              end   : Alignment.bottomRight,
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
          tooltip  : 'Email',
          onPressed: _openEmail,
          icon     : ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.accent, AppColors.accentPurple],
              begin : Alignment.topLeft,
              end   : Alignment.bottomRight,
            ).createShader(bounds),
            child: const Icon(Icons.email),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child        : AppDivider(),
      ),
    );
  }
}

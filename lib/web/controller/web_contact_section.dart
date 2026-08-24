import 'package:flutter/material.dart';
import '../web.dart';
import '../../api/api.dart' hide Message;
import '../../features/contact/contact.dart';
import '../../shared/shared.dart';

class WebContactSection extends StatelessWidget {
  const WebContactSection({
    super.key,
    required this.contactme,
    required this.socials,
  });

  final List<ContactMe> contactme;
  final List<Social> socials;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WebHeading(
          label: webContactLabel,
          title: title,
          lead : webContactLead,
        ),
        const SizedBox(height: 40),
        if (contactme.isNotEmpty) ...[
          Text(
            webConnectTitle,
            style: AppStyle.labelLarge.copyWith(color: AppColors.accent),
          ),
          const SizedBox(height: 20),
          ...contactme.map((item) => WebContactRow(item: item)),
          const SizedBox(height: 16),
        ],
        if (socials.isNotEmpty) ...[
          Text(
            webFollowTitle,
            style: AppStyle.labelLarge.copyWith(color: AppColors.accent),
          ),
          const SizedBox(height: 18),
          WebSocialRow(socials: socials),
        ],
        const SizedBox(height: 32),
        const WebAvailabilityBadge(),
      ],
    );

    final form = WebCard(
      padding: EdgeInsets.all(isDesktop ? 30 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize      : MainAxisSize.min,
        children: [
          Text(webFormTitle, style: AppStyle.headline3.copyWith(fontSize: 19)),
          const SizedBox(height: 8),
          Text(description, style: AppStyle.bodyMedium),
          const SizedBox(height: 20),
          const Message(),
        ],
      ),
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [intro, const SizedBox(height: 36), form],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: intro),
        const SizedBox(width: 56),
        Expanded(flex: 6, child: form),
      ],
    );
  }
}

class WebContactRow extends StatefulWidget {
  const WebContactRow({super.key, required this.item});

  final ContactMe item;

  @override
  State<WebContactRow> createState() => _WebContactRowState();
}

class _WebContactRowState extends State<WebContactRow> {
  bool _hovered = false;

  Future<void> _open() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!await ExternalLink.open(widget.item.effectiveContactUrl)) {
      messenger.showSnackBar(const SnackBar(content: Text(webLinkError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: MouseRegion(
        cursor : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit : (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap   : _open,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding : const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color       : _hovered ? AppColors.card : Colors.transparent,
              borderRadius: BorderRadius.circular(AppStyle.radiusMd),
              border: Border.all(
                color: _hovered ? AppColors.accent : AppColors.divider,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width  : 40,
                  height : 40,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.divider,
                    shape: BoxShape.circle,
                  ),
                  child: Image(
                    image: ApiImage.imageProviderFor(
                      item.icon,
                      fallbackAsset: 'assets/icons/phone.png',
                    ),
                    color: AppColors.accent,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/icons/phone.png',
                        color: AppColors.accent,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name.toUpperCase(),
                        style: AppStyle.bodySmall.copyWith(
                          color        : AppColors.textSub,
                          fontFamily   : 'JetBrainsMono',
                          fontSize     : 9,
                          letterSpacing: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.bodyMedium.copyWith(
                          color     : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.north_east,
                  size : 15,
                  color: _hovered ? AppColors.accent : AppColors.textSub,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

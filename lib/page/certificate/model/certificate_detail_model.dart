import 'package:flutter/material.dart';

class CertificateFactModel {
  final IconData icon;
  final String label;

  const CertificateFactModel({required this.icon, required this.label});
}

const List<CertificateFactModel> certificateFactModel = [
  CertificateFactModel(icon: Icons.fingerprint_rounded, label: 'Credential ID'),
  CertificateFactModel(icon: Icons.event_available_rounded, label: 'Date earned'),
  CertificateFactModel(icon: Icons.apartment_rounded, label: 'Issuer'),
];

// ── Credential page copy ────────────────────────────────────
const String certificateCaseLabel = 'Credential';
const String certificateCrumbRoot = 'Career';
const String certificateBackAction = 'Back';
const String certificateViewAction = 'View certificate';
const String certificateFactsTitle = 'Credential details';
const String certificateNoLinkMessage =
    'A certificate link is not available yet.';

// ── Backend states ──────────────────────────────────────────
const String certificateErrorTitle = 'Unable to load this credential';
const String certificateErrorMessage =
    'Please check your connection and try '
    'again.';
const String certificateRetryAction = 'Try again';
const String certificateMissingTitle = 'Credential not found';
const String certificateMissingDetail =
    'Return to the career section to choose '
    'another credential.';
const String certificateLoadingLabel = 'Loading credential details';

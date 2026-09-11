import 'package:flutter/material.dart';

class ProjectModel {
  final IconData? icon;
  final String label;

  const ProjectModel({this.icon, required this.label});
}

const List<ProjectModel> projectModel = [
  ProjectModel(icon: Icons.schedule_rounded, label: 'Duration'),
  ProjectModel(icon: Icons.badge_outlined, label: 'Role'),
  ProjectModel(icon: Icons.devices_rounded, label: 'Platform'),
  ProjectModel(label: 'Overview'),
  ProjectModel(label: 'The Challenge'),
];

// ── Case study copy ─────────────────────────────────────────
const String projectCaseLabel = 'Case study';
const String projectCrumbRoot = 'Work';
const String projectBackToWork = 'Back to work';
const String projectLiveAction = 'Live project';
const String projectVisitAction = 'Visit the site';
const String projectFactsTitle = 'Project details';
const String projectNoLiveLink =
    'A live link is not published for this '
    'project yet.';

// ── Lists ───────────────────────────────────────────────────
const String projectEmptyMessage = 'No backend project yet.';

// ── Pager ───────────────────────────────────────────────────
const String projectMoreLabel = 'More work';
const String projectPreviousTag = 'Previous';
const String projectNextTag = 'Next project';

// ── Backend states ──────────────────────────────────────────
const String projectErrorTitle = 'Unable to load this project';
const String projectErrorMessage =
    'Please check your connection and try '
    'again.';
const String projectRetryAction = 'Try again';
const String projectMissingTitle = 'Project not found';
const String projectMissingDetail =
    'Browse the work section to choose '
    'another case study.';
const String projectLoadingLabel = 'Loading project details';

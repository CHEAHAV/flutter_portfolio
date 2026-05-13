import 'package:flutter/material.dart';

class SkillPage extends StatefulWidget {
  const SkillPage({super.key});

  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Skill Page!'),
      ),
    );
  }
}
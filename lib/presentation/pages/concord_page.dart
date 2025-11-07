import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:flutter/material.dart';

class ConcordPage extends StatefulWidget {
  const ConcordPage({super.key});

  @override
  State<ConcordPage> createState() => _ConcordPageState();
}

class _ConcordPageState extends State<ConcordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: MainAppBar(title: "Tunnustuskirjat"),);
  }
}

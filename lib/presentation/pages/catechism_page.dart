import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:flutter/material.dart';

class CatechismPage extends StatefulWidget {
  const CatechismPage({super.key});

  @override
  State<CatechismPage> createState() => _CatechismPageState();
}

class _CatechismPageState extends State<CatechismPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Katekismus"),
    );
  }
}

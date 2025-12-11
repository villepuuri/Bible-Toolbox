import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/data/services/api_service.dart';
import 'package:bible_toolbox/data/services/api_text_cleaner.dart';
import 'package:bible_toolbox/data/widgets/api_text_widget.dart';
import 'package:flutter/material.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  String body = "";

  @override
  void initState() {
    super.initState();
    _loadData(); // <- start async work here
  }


  Future<void> _loadData() async {
    String result = await ApiService.fetchData();

    result = ApiTextCleaner.cleanText(result);

    if (!mounted) return;
    setState(() {
      body = result;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MainAppBar(title: "Raamattu"),
      body: ApiTextWidget(body: body),
    );
  }
}

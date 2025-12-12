import 'package:bible_toolbox/core/Widgets/main_app_bar.dart';
import 'package:bible_toolbox/data/services/api_service.dart';
import 'package:bible_toolbox/data/services/article_data.dart';
import 'package:bible_toolbox/data/widgets/api_text_widget.dart';
import 'package:flutter/material.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  bool initialized = false;
  late ArticleData article;

  @override
  void initState() {
    super.initState();
    _loadData();
  }


  Future<void> _loadData() async {
    Map<String, dynamic> result = await ApiService.fetchData();

    article = ArticleData.fromJson(result);

    if (!mounted) return;
    setState(() {
      initialized = true;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        debugPrint(article.toString());
      }),
      appBar: MainAppBar(title: "Raamattu"),
      body: ApiTextWidget(body: initialized ? article.cleanBody : ""),
    );
  }
}

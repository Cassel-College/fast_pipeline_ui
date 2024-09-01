import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AboutPage extends StatefulWidget {
  final BuildContext? context;
  const AboutPage({Key? key, this.context}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String author = '';
  String version = '';
  String description = '';

  @override
  void initState() {
    super.initState();
    _loadAboutInfo();
  }

  Future<void> _loadAboutInfo() async {
    final String response =
        await rootBundle.loadString('assets/about_info.json');
    final data = json.decode(response);
    setState(() {
      author = data['author'];
      version = data['version'];
      description = data['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '作者: $author',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              '版本: $version',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              '描述: $description',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

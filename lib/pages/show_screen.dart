import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ShowReadBudgetterms extends StatelessWidget {
  final String link;

  const ShowReadBudgetterms({Key? key, required this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(link)),
        ),
      ),
    );
  }
}

class ShowReadBudgettermss extends StatelessWidget {
  final String link;

  const ShowReadBudgettermss({Key? key, required this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        bottom: false,
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(link)),
        ),
      ),
    );
  }
}

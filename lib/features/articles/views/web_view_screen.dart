import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AtwWebViewScreen extends StatefulWidget {
  const AtwWebViewScreen({Key? key}) : super(key: key);
  @override
  AtwWebViewScreenState createState() => AtwWebViewScreenState();
}

class AtwWebViewScreenState extends State<AtwWebViewScreen> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) => setState(() { _progress = progress; }),
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() { _progress = 100; });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://atw.ltd'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_progress < 100)
              LinearProgressIndicator(value: _progress / 100.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.purple,)),),
            )
          ],
        ),
      ),
    );
  }
}

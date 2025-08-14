


import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            String contact = "5351251511";
              String text = 'Hola, me gusto tu juego hiragana';
              String androidUrl = "whatsapp://send?phone=$contact&text=$text";

            // if (mounted) { // 'mounted' comprueba que el widget está en pantalla
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text('Interceptado: ${request.url} ${request.url.startsWith("https://wa.me/")} ${await canLaunchUrl(Uri.parse(androidUrl))}'),
            //       duration: const Duration(seconds: 3),
            //     ),
            //   );
            // }
              
              if (request.url.startsWith("https://wa.me/")){
                if (await canLaunchUrl(Uri.parse(androidUrl))) {
                  await launchUrl(Uri.parse(androidUrl));
                  return NavigationDecision.prevent;
                }
              }

              if (request.url.startsWith("mailto:") ||
                  request.url.startsWith("tel:") ||
                  request.url.startsWith("https://wa.me/") ||
                  request.url.contains("linkedin.com") ||
                  request.url.contains("github.com")) {
                
                if (await canLaunchUrl(Uri.parse(request.url))) {
                  await launchUrl(Uri.parse(request.url), mode: LaunchMode.externalApplication);
                }
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
        ),
      )
      ..loadFlutterAsset('assets/web/index.html');  // punto de entrada
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
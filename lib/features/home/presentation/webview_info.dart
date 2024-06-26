import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewInfo {
  final WebViewController? controller;
  final String path;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final BuildContext context;
  final int loadingProgress;
  final bool loaded;

  WebViewInfo(this.path,
      {required this.scaffoldKey,
      required this.context,
      this.controller,
      this.loadingProgress = 0,
      this.loaded = false
      });

  WebViewInfo copyWith({
    WebViewController? controller,
    String? path,
    GlobalKey<ScaffoldState>? scaffoldKey,
    BuildContext? context,
    int? loadingProgress,
    bool? loaded,
  }) {
    return WebViewInfo(
      path ?? this.path,
      controller: controller ?? this.controller,
      scaffoldKey: scaffoldKey ?? this.scaffoldKey,
      context: context ?? this.context,
      loadingProgress: loadingProgress ?? this.loadingProgress,
      loaded: loaded ?? this.loaded,
    );
  }
}

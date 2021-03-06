import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';

import 'RouteHandler.dart';

class Routes {
  // 路由管理
  static fluro.Router router;

  static String root = '/'; // 根目录
  static String search = '/search';
  static String read = '/read';
  static String login = '/login';
  static String register = '/register';
  static String modifyPassword = '/modifyPassword';
  static String detail = '/detail';
  static String chapters = '/chapters';
  static String allTagBook = '/allTagBook';
  static String vDetail = '/vDetail';
  static String lookVideo = '/lookVideo';
  static String tagVideo = '/tagVideo';
  static String fontSet = '/fontSet';
  static String sortShelf = '/sortShelf';



  // 配置route
  static void configureRoutes(fluro.Router router) {
    // 未发现对应route
    router.notFoundHandler = fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      print('route not found!');
      return;
    });
    router.define(root, handler: rootHandler);
    router.define(search, handler: searchHandler);
    router.define(read, handler: readHandler);
    router.define(login, handler: loginHandler);
    router.define(register, handler: registerHandler);
    router.define(modifyPassword, handler: modifyPasswordHandler);
    router.define(detail, handler: detailHandler);
    router.define(chapters, handler: chaptersHandler);
    router.define(allTagBook, handler: allTagBookHandler);
    router.define(vDetail, handler: vDetailHandler);
    router.define(lookVideo, handler: lookVideoHandler);
    router.define(tagVideo, handler: tagVideoHandler);
    router.define(fontSet, handler: fontSetHandler);
    router.define(sortShelf, handler: sortShelfHandler);
  }

  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配
  static Future navigateTo(BuildContext context, String path,
      {Map<String, dynamic> params,
        fluro.TransitionType transition = fluro.TransitionType.native}) {
    String query = "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }

    path = path + query;
    return router.navigateTo(context, path, transition: transition);
  }
}

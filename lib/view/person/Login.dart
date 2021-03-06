import 'package:book/common/common.dart';
import 'package:book/common/net.dart';
import 'package:book/event/event.dart';
import 'package:book/model/ShelfModel.dart';
import 'package:book/route/Routes.dart';
import 'package:book/store/Store.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  String username = '';
  bool isLogin = false;
  String pwd;

  login(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    var formData = FormData.fromMap({"name": username, "password": pwd});
    Response response =
        await Util(context).http().post(Common.login, data: formData);
    var data = response.data;
    if (data['code'] != 201) {
      BotToast.showText(text: data['msg']);
    } else {
      //收起键盘
//        SpUtil.putString('email', data['data']['email']);
//        SpUtil.putString('pwd', pwd);
      SpUtil.putString('username', username);
      // SpUtil.putBool('login', true);
      SpUtil.putString("auth", data['data']['token']);
      eventBus.fire(new SyncShelfEvent(""));

      //书架同步
      var shelf2 = Store.value<ShelfModel>(context).shelf;
      if (shelf2.length > 0) {
        for (var value in shelf2) {
          if (SpUtil.haveKey("auth")) {
            Util(null).http().get(Common.bookAction + '/${value.Id}/add');
          }
        }
      }
      // Routes.navigateTo(context, Routes.root);

      Navigator.of(context).popUntil(ModalRoute.withName('/'));
      eventBus.fire(new NavEvent(0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              SizedBox(height: 48.0),
              TextFormField(
                autofocus: false,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: '账号',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
                onChanged: (String value) {
                  this.username = value;
                },
              ),
              SizedBox(height: 8.0),
              TextFormField(
                autofocus: false,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: '密码',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
                onChanged: (String value) {
                  this.pwd = value;
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () => login(context),
                  padding: EdgeInsets.all(12),
                  child: Text(
                    '登陆',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      '忘记密码',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Routes.navigateTo(context, Routes.modifyPassword);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      '注册',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Routes.navigateTo(context, Routes.register);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../forms/Login/Login.dart';
import 'consts.dart';
import 'theme-Manager.dart';

class ServerBloc{
  BehaviorSubject<String> _serverip = BehaviorSubject<String>.seeded('127.0.0.1');
  Stream<String> get serverIPStream$ => _serverip.stream;

  ServerBloc(){
    SharedPreferences.getInstance().then((prefs) {
      String ip = prefs.getString('serverip') ?? '127.0.0.1';
      _serverip.add(ip);
    });
  }

  String getServerIP(){
    return _serverip.value;
  }
  setServerIP(String ip){
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('serverip', ip);
      _serverip.add(ip);
    });   
  }
}
ServerBloc serverBloc = ServerBloc();
String serverIP(){
  return serverBloc.getServerIP();
}

ImageProvider<dynamic> loadImage(BuildContext context, String url){
  // if (ResponsiveLayout.isSmallScreen(context))
    return AssetImage(url);
  // else
    // return NetworkImage(url);
}

enum Status{initial, loading, loaded, error, success, saving}
class MessageModel{
  Status status;
  String msg;

  MessageModel({@required this.status, @required this.msg});
}

Future<Map<String, dynamic>> postToServer({String api, dynamic body, Map<String,String> header}) async{
  if (header == null)
    header = {'Content-Type': 'application/json'};
  var res = await http.post(
    "http://${serverIP()}:8080/PamaApi/api/$api",
    headers: header,
    body: body
  );
  if(res.statusCode == 200)
    return {"msg": "Success", "body": json.decode(utf8.decode(res.bodyBytes))};
  else
    return {"msg": utf8.decode(res.bodyBytes)};
}

Future<Map<String, dynamic>> putToServer({String api, dynamic body, Map<String,String> header}) async{
  if (header == null)
    header = {'Content-Type': 'application/json'};
  var res = await http.put(
    "http://${serverIP()}:8080/PamaApi/api/$api",
    headers: header,
    body: body
  );
  if(res.statusCode == 200)
    return {"msg": "Success", "body": json.decode(utf8.decode(res.bodyBytes))};
  else
    return {"msg": utf8.decode(res.bodyBytes)};
}

Future<Map<String, dynamic>> delToServer({String api, Map<String,String> header}) async{
  if (header == null)
    header = {'Content-Type': 'application/json'};
  var res = await http.delete(
    "http://${serverIP()}:8080/PamaApi/api/$api",
    headers: header,
  );
  if(res.statusCode == 200)
    return {"msg": "Success", "body": json.decode(utf8.decode(res.bodyBytes))};
  else
    return {"msg": utf8.decode(res.bodyBytes)};
}
// Future<List<dynamic>> fetchFromServer(String f2key) async {
//   final response = await http.get('http://${serverIP()}:8080/Pama/Pama.jsp?command=$f2key');
//   if (response.statusCode == 200) {
//     if (response.body.trim().isEmpty)
//       return [];
//     else{
//       List<dynamic> post = jsonDecode(response.body);
//       return post;
//     }
//   } else {
//     throw Exception('Failed to load post');
//   }
// }

sendFile(BuildContext context, Uint8List file, String type, int id) {
  var url = Uri.parse("http://${serverIP()}:8080/PamaApi/GetFile.jsp?token=${readToken(context)}&type=$type&id=$id");
  var request = new http.MultipartRequest("POST", url);
  // Uint8List _bytesData =
  //     Base64Decoder().convert(file.toString().split(",").last);
  List<int> _selectedFile = file;

  request.files.add(http.MultipartFile.fromBytes('file', _selectedFile,
      filename: "text_upload.txt"));

  request.send().then((response) {
    print(response.statusCode);
    if (response.statusCode == 200) print("Uploaded!");
  });
}

void messageDlg({@required BuildContext context, @required String title, @required String msg, @required VoidCallback okPressed}) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("خیر"),
    onPressed:  (){
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("بلی"),
    onPressed:  (){
      okPressed();
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title, textDirection: TextDirection.rtl),
    content: Text(msg, textDirection: TextDirection.rtl),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

void myAlert({@required BuildContext context, @required String title, @required String message, Color color, Icon icon, int second = 5}){
  // Flushbar(
  //   backgroundColor: color==null ? Colors.red.withOpacity(0.8) : color.withOpacity(0.8),

  //   leftBarIndicatorColor: Colors.limeAccent,
  //   boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
  //   icon: icon==null ? Icon(Icons.error) : icon,
  //   title:  title,
  //   message:  message,
  //   duration:  Duration(seconds: second), 
  //   // mainButton: FlatButton(onPressed: (){}, child: Text('مشاهده')),
  // )..show(context);
  showFlash(
    context: context,
    duration: Duration(seconds: second),
    builder: (_, controller) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Flash(
          backgroundColor: color ?? Colors.red,
          controller: controller,
          position: FlashPosition.bottom,
          style: FlashStyle.grounded,
          child: FlashBar(
            icon: Icon(
              icon ?? Icons.face,
              size: 36.0,
              color: Colors.white,
            ),
            title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            message: Text(message.replaceAll("Exception:", ""), style: TextStyle(color: Colors.white),),
          ),
        ),
      );
    }
  );
}

showFormAsDialog({@required BuildContext context, @required Widget form, Function done, bool modal = false}){
  showDialog(
    context: context,
    barrierDismissible: !modal,
    builder: (context){
      return AlertDialog(
        content: form
      ); 
    }
  ).then((data){
    if (done != null)
      done(data);
  });
}

String yearOver18Validator(String bdate, String val){
  PersianDateTime date = PersianDateTime();

  if (bdate.isEmpty) 
    return 'تاریخ تولد مشخص نشده است';
  if (bdate.length != 10) 
    return 'تاریخ تولد صحیح نمی باشذ';

  int by = int.tryParse(bdate.substring(0, 4));
  int cy = int.tryParse(date.toJalaali().substring(0,4));

  if (cy - by > 18 && val.isEmpty)
    return 'مقدار فیلد اجباری است';
  return null;
}

String readToken(BuildContext context){
  final model = Provider.of<ThemeManager>(context, listen: false);
  return model.token;
}

String compileErrorMessage(String err){
  if (err.toLowerCase().contains("http status 404") || err.toLowerCase().contains("xmlhttprequest error"))
    return 'دسترسی به وب سرور امکان پذیر نمی باشد. لطفا از اتصال به اینترنت اطمینان حاصل نمایید';
  else if (err.toLowerCase().contains("http status 404") || err.toLowerCase().contains("xmlhttprequest error"))
    return 'خطای ۴۰۵ در سرور. لطفا پس از بروز رسانی مجددا سعی نمایید';
  else if (err.toLowerCase().contains("http status 500") || err.toLowerCase().contains("xmlhttprequest error"))
    return 'خطا در پردازش اطلاعات در وب سرور امکان پذیر نمی باشد. لطفا از اتصال به اینترنت اطمینان حاصل نمایید';
  return err.toLowerCase().replaceAll('exception:', '');
}

void analyzeError(BuildContext context, String note, {bool msg = true}){
  if (note.indexOf("Token Not Valid") >= 0)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false
    );
  else if (msg)
    myAlert(context: context, title: 'خطا', message: compileErrorMessage('$note'));
}

void confirmMessage(BuildContext context, String title, String msg, {Function yesclick, Function noClick, AlertType type = AlertType.warning}){
  Alert(
    context: context,
    type: type,    
    title: title,
    desc: msg,
    buttons: [
      DialogButton(
        color: Colors.deepOrangeAccent,
        child: Text(
          "خیر",
          style: alertButtonStyle(),
        ),
        onPressed: () => noClick==null ? Navigator.pop(context) : noClick(),
        width: 55,
      ),
      DialogButton(
        child: Text(
          "بلی",
          style: alertButtonStyle(),
        ),
        onPressed: () => yesclick==null ? Navigator.pop(context) : yesclick(),
        width: 55,
      ),
    ],
  ).show();
}

void showWaiting(BuildContext context){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context){
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey.withOpacity(0.1),
        child: Material(
          color: Colors.blueGrey.withOpacity(0.1),
          child: Center(
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoActivityIndicator(radius: 20.0,),
                    SizedBox(height: 10.0,),
                    Text('...لطفا کمی شکیبا باشید', style: gridFieldStyle(),)
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  );
}
void hideWaiting(BuildContext context){
  Navigator.pop(context);
}


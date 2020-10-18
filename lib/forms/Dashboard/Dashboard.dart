import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../classes/classes.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import '../../module/theme-Manager.dart';
import '../AddInfo/AddInfo.dart';
import '../Bank/Bank.dart';
import '../Company/Company.dart';
import '../Document/Document.dart';
import '../Gov/Gov.dart';
import '../Login/Login.dart';
import '../Raste/Raste.dart';
import '../UserGroup/UserGroup.dart';
import '../Violation/Violation.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سامانه پردازش اطلاعات و مدیریت اعضاء - پاما'),
        leading: Switch(
          value: context.watch<ThemeManager>().themeData.brightness == Brightness.dark,
          onChanged: (val){
            if (val)
              context.read<ThemeManager>().setTheme(AppTheme.Dark);
            else
              context.read<ThemeManager>().setTheme(AppTheme.Light);
          }
        ) ,
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              SideBar(user: this.user),
              Expanded(
                child: context.watch<ThemeManager>().menuitem == 0 ? FmCompany(user: this.user,) 
                     :context.watch<ThemeManager>().menuitem == 1 ? FMRaste() 
                     :context.watch<ThemeManager>().menuitem == 2 ? FmBank() 
                     :context.watch<ThemeManager>().menuitem == 3 ? FmViolation() 
                     :context.watch<ThemeManager>().menuitem == 4 ? FmDocument() 
                     :context.watch<ThemeManager>().menuitem == 5 ? FmGov() 
                     :context.watch<ThemeManager>().menuitem == 6 ? FmAddInfo() 
                     :context.watch<ThemeManager>().menuitem == 7 ? FmUserGroup() 
                     :Text('در دست طراحی می باشد', textAlign: TextAlign.center, style: titleStyle(),)
              )
            ],
          ),
        )
      ),
      endDrawer: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: ClipRRect(
          // give it your desired border radius
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(175),
          ),
          // wrap with a sizedbox for a custom width [for more flexibility]
          child: Drawer(
            semanticLabel: 'منوهای سامانه',
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: accentcolor(context)),
                    child: Text('سامانه پاما', style: titleStyle(), textAlign: TextAlign.center,)
                  ),
                  SizedBox(height: 15.0,),
                  this.user.admin ? ListTile(title: Text('اتاق اصناف و اتحادیه ها'), onTap: (){context.read<ThemeManager>().setMenuItem(0); Navigator.of(context).pop();}, selected: context.watch<ThemeManager>().menuitem == 0) : Container(),
                  this.user.admin ? ListTile(title: Text('رسته ها'), onTap: (){context.read<ThemeManager>().setMenuItem(1); Navigator.of(context).pop();}, selected: context.watch<ThemeManager>().menuitem == 1,) : Container(),
                  this.user.admin ? ListTile(title: Text('بانک ها'), onTap: (){context.read<ThemeManager>().setMenuItem(2); Navigator.of(context).pop();}, selected: context.watch<ThemeManager>().menuitem == 2,) : Container(),
                  this.user.admin ? ListTile(title: Text('تخلفات'), onTap: (){context.read<ThemeManager>().setMenuItem(3); Navigator.of(context).pop();}, selected: context.watch<ThemeManager>().menuitem == 3,) : Container(),
                  this.user.admin ? ListTile(title: Text('مدارک'), onTap: (){context.read<ThemeManager>().setMenuItem(4); Navigator.of(context).pop();}, selected: context.watch<ThemeManager>().menuitem == 4,) : Container(),
                  this.user.admin ? ListTile(title: Text('سازمان ها و دستگاه های دولتی'), onTap: (){context.read<ThemeManager>().setMenuItem(5); Navigator.of(context).pop();}, selected: context.watch<ThemeManager>().menuitem == 5,) : Container(),
                  this.user.admin ? ListTile(title: Text('اطلاعات تکمیلی'), onTap: (){context.read<ThemeManager>().setMenuItem(6); Navigator.of(context).pop();}, selected: context.watch<ThemeManager>().menuitem == 6,) : Container(),
                  this.user.admin ? ListTile(title: Text('گروه های کاربری'), onTap: (){context.read<ThemeManager>().setMenuItem(7); Navigator.of(context).pop();}, selected: context.watch<ThemeManager>().menuitem == 7,) : Container(),
                  this.user.admin ? ListTile(title: Text('تنظیمات'), onTap: (){context.read<ThemeManager>().setMenuItem(16); Navigator.of(context).pop();}, selected: context.watch<ThemeManager>().menuitem == 16,) : Container(),
                  SizedBox(height: 15,),
                  ListTile(title: Text('خروج از سامانه'), hoverColor: Colors.redAccent[100], onTap: (){
                    confirmMessage(context, "تایید خروج", "آیا مایل به خروج از سامانه می باشید؟", yesclick: () async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.remove('token');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                    });
                  }),
                ],
              ),
            ),
          )
        )
      ),
      endDrawerEnableOpenDragGesture: false,
    );
  }
}


class SideBar extends StatelessWidget {
  const SideBar({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 225.0,
      child: Column(
        children: [
          SizedBox(height: 5.0,),
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=company&id=${this.user.cmpid}"),
                ),
              ),
              Positioned(
                right: 5,
                bottom: 5,
                child: GestureDetector(
                  onTap: () async{
                    FilePickerResult result = await FilePicker.platform.pickFiles();
                    if(result != null) {
                      PlatformFile file = result.files.first;
                        
                      sendFile(context,file.bytes,"UserImage",this.user.id);
                    }
                  },
                  child: CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=user&id=${this.user.id}"),
                    ),
                  ),
                ),
              )
            ],  
          ),
          SizedBox(height: 50),
          Card(color: backgroundColor(context).withOpacity(0.5), child: Container(width: double.infinity, padding: EdgeInsets.all(8.0),child: Text('${this.user.cmpname}', style: titleStyle(), textAlign: TextAlign.center,))),
          Card(color: backgroundColor(context).withOpacity(0.5), child: Container(width: double.infinity, padding: EdgeInsets.all(8.0),child: Text('${this.user.name} ${this.user.family} خوش آمدید', style: gridFieldStyle(), textAlign: TextAlign.center,))),
          Card(color: backgroundColor(context).withOpacity(0.5), child: Container(width: double.infinity, padding: EdgeInsets.all(8.0),child: Text('${this.user.ip}', style: gridFieldStyle(), textAlign: TextAlign.center,))),
          Spacer(flex: 2,),
          // Tooltip(message: 'پشتیبانی آنلاین', child: IconButton(iconSize: 175, icon: Lottie.asset('images/support.json', height: 100), onPressed: ()=> myAlert(context: context, title: 'بزودی', message: 'پشتیبانی آنلاین در دست طراحی می باشد', color: Colors.blueGrey))),
          Tooltip(
            message: 'پشتیبانی آنلاین', 
            child: IconButton(
              iconSize: 75, 
              icon: Image.asset('images/support2.png'),
              onPressed: (){
                myAlert(context: context, title: 'بزودی', message: 'پشتیبانی آنلاین در دست طراحی می باشد', color: Colors.blueGrey);
              }
            )
          ),
          SizedBox(height: 35.0,),
        ],
      ),
    );
  }
}
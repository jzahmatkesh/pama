import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:provider/provider.dart';

import '../classes/classes.dart';
import 'consts.dart';
import 'functions.dart';
import 'searchable_dropdown.dart';
import 'theme-Manager.dart';

typedef String2VoidFunc = void Function(String);

enum ButtonType{add,del,save,exit,reload,none,other,info}

class MyTextField extends StatelessWidget{
  final String hint;
  final bool pass;
  final IconData icon;
  final TextEditingController controller;
  final String2VoidFunc onchange;
  final double width;
  final bool darkmodeForce;

  MyTextField({this.hint, this.pass = false, this.controller, this.icon, this.onchange, this.width = double.infinity, this.darkmodeForce});

  @override
  Widget build(BuildContext context) {
    bool darkmode = darkmodeForce!=null ? darkmodeForce : Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: width,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: darkmode ? Colors.white12 : Colors.transparent
      ),
      child: TextField(
        controller: controller,
        focusNode: FocusNode(),
        decoration: textDecoration(hint, icon),
        onChanged: (val){
          if (onchange != null)
            onchange(val);
        },
       style: TextStyle(color: darkmode ? Colors.white : Colors.black),
        obscureText: pass,
      ),
    );
  }
}

InputDecoration textDecoration(String label, IconData icon) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7.0),
      gapPadding: 20.0,
    ),
    fillColor: Colors.white,
    labelStyle: TextStyle(color: Colors.grey[500], fontSize: 16.0),
    labelText: label,
    prefixIcon: icon==null ? null : Icon(icon, color: Colors.grey[500], size: 15.0,),
  );
}

class MyOutlineButton extends StatelessWidget{
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color hovercolor;
  final Color color;
  final FocusNode focusnode;

  const MyOutlineButton({Key key, this.title, this.icon, this.color, this.hovercolor, this.onPressed, this.focusnode}) : super(key: key);@override

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color!=null ? color : Colors.transparent,
      ),
      margin: EdgeInsets.all(5.0),
      child: OutlineButton(
        focusNode: focusnode,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        onPressed: this.onPressed,
        hoverColor: hovercolor!=null ? hovercolor : Theme.of(context).textTheme.button.color.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(icon,),
            SizedBox(width: 5.0,),
            Text(title),
          ],
        ),
      ),
    );
  }
}

PopupMenuItem myPopupMenuItem({IconData icon,String title,int value}){
  return PopupMenuItem<int>(
    value: value,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: <Widget>[
          Icon(icon),
          SizedBox(width: 15.0,),
          Text(title),
        ],
      ),
    ),
  );
}

class MyIconButton extends StatelessWidget{
  final ButtonType type;
  final VoidCallback onPressed;
  final String hint;
  final Icon icon;

  const MyIconButton({Key key, @required this.type, this.hint, this.icon, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: hint != null
        ? hint
        : type==ButtonType.add
          ? 'جدید' 
          : type==ButtonType.del
            ? 'حذف' 
            : type==ButtonType.exit
              ? 'بازگشت'
              : type==ButtonType.save
                ? 'ذخیره'
                : type==ButtonType.reload
                  ? 'بارگذاری مجدد اطلاعات'
                  : type==ButtonType.info 
                    ? 'سایر اطلاعات'
                    : '', 
      icon: icon != null
        ? icon
        : type==ButtonType.add
          ? Icon(CupertinoIcons.plus_app)
          : type==ButtonType.del
            ? Icon(Icons.delete, color: Colors.black54) 
            : type==ButtonType.exit 
              ? Icon(CupertinoIcons.return_icon) 
              : type==ButtonType.save
                ? Icon(Icons.save, color: Colors.green)
                : type==ButtonType.reload
                  ? Icon(CupertinoIcons.goforward)
                  : type==ButtonType.info
                    ? Icon(CupertinoIcons.info_circle, color: Colors.lightBlue,)
                    : Icon(Icons.question_answer), 
      onPressed: onPressed != null ? onPressed : type == ButtonType.exit ? ()=>Navigator.pop(context) : null
    );
  }
}

void myDatePicker({BuildContext context, TextEditingController controller}){
  PersianDatePickerWidget persianDatePicker = PersianDatePicker(
    controller: controller,
  ).init();
  showDialog(
    context: context, 
    child: AlertDialog(
      content: Container(
        width: 350.0,
        height: 350.0,
        child: persianDatePicker,
      ),
    )
  );
}

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    //this fixes backspace bug
    // if (oldValue.text.length >= newValue.text.length) {
    //   return newValue;
    // }
    if (_addSeperators(oldValue.text, '/').length >= _addSeperators(newValue.text, '/').length) {
      return newValue;
    }

    var dateText = _addSeperators(newValue.text, '/');
    if (dateText.length > 10)
      dateText = dateText.substring(0, 10);
    return newValue.copyWith(text: dateText, selection: updateCursorPosition(dateText));
  }

  String _addSeperators(String value, String seperator) {
    value = value.replaceAll('/', '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 3) {
        newString += seperator;
      }
      if (i == 5) {
        newString += seperator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

class GridTextField extends StatelessWidget{
  final String hint;
  final TextEditingController controller;
  final String initialValue;
  final FocusNode focus;
  final FocusNode nextfocus;
  final double width;
  final bool autofocus;
  final bool notempty;
  final String2VoidFunc onChange;
  final bool readonly;
  final int maxlength;
  final bool passfield;
  final bool numberonly;

  final bool datepicker;
  final TextEditingController paramController;
  final Function(String) validator;

  GridTextField({@required this.hint, this.controller, this.initialValue, this.focus, this.nextfocus, this.autofocus = false, this.width = double.infinity, this.datepicker = false, this.paramController, this.notempty = false, this.onChange, this.readonly = false, this.validator, this.maxlength = 0, this.passfield = false, this.numberonly = false});

  @override
  Widget build(BuildContext context) {
    bool darkmode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onDoubleTap: (){
        if (datepicker)
          myDatePicker(context: context, controller: controller);
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: TextFormField(
          readOnly: readonly,
          inputFormatters: datepicker ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,DateTextFormatter()] : this.numberonly ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : <TextInputFormatter>[],
          initialValue: initialValue=="0" ? "" : initialValue,
          controller: initialValue==null ? controller : null,
          focusNode: focus,
          obscureText: this.passfield,
          maxLines: 1,
          validator: validator != null ? validator : (val){
            if ((val.isEmpty || val.trim() == "0") && notempty) 
              return 'مقدار فیلد اجباری است';
            return null;
          },
          // onTap: (){
          //   if (f2key == "datepicker")
          //     myDatePicker(context: context, controller: controller);
          // },
          onChanged: onChange,
          onFieldSubmitted: (v){
            focus.unfocus();
            if (nextfocus != null)
              FocusScope.of(context).requestFocus(nextfocus);
              //nextfocus.requestFocus();
          },
          autofocus: autofocus,        
          decoration: textDecoration(hint, null),
          style: TextStyle(color: darkmode ? Colors.white : Colors.black),
          maxLength: maxlength == 0 ? null : maxlength,
        ),
      ),
    );
  }
}

class MultiChooseItem extends StatelessWidget{
  final int val;
  final String hint;
  final Function onChange;
  final List<Map<String, dynamic>> items;
  MultiChooseItem({@required this.val, @required this.items, @required this.hint , @required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]),
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Tooltip(
        message: hint,
        child: DropdownButton<int>(
          underline: Container(),
          isExpanded: true,
          value: val,
          items: items.map((Map<String, dynamic> val){
            return DropdownMenuItem<int>(
              value: val['id'],
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(val['title'], textAlign: TextAlign.center,)
              )  
            );
          }).toList(),
          onChanged: onChange,
        ),
      ),
    );
  }
}

class ErrorInGrid extends StatelessWidget {
  const ErrorInGrid(this.msg, {Key key, this.info = false}) : super(key: key);

  final String msg;
  final bool info;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.info ? double.infinity : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 25.0)],
          color: this.info ? accentcolor(context) : Colors.red[300],
        ),
        padding: EdgeInsets.all(18.0),
        margin: EdgeInsets.all(8.0),
        child: Text(this.msg.toLowerCase().replaceAll('خطا exception:', 'خطا:').replaceAll('exception:', '').replaceAll('exception', ''), style: this.info ? gridFieldStyle() : titleStyle(), textAlign: TextAlign.center,),
      ),
    );
  }
}

class MyRow extends StatelessWidget {
  const MyRow({Key key, @required this.children}) : super(key: key);

  final List<dynamic> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: children.map((e){
            if (e is String || e is int)
              return Expanded(child: Text('$e'));
            if (e is Widget)
              return e;
          }).toList()
        ),
      ),
    );
  }
}

class FormHeader extends StatelessWidget {
  const FormHeader({Key key, @required this.title, this.style, this.btnRight, this.btnLeft}) : super(key: key);

  final String title;
  final MyIconButton btnRight;
  final MyIconButton btnLeft;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: appbarColor(context),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            (btnRight ?? ButtonType.none) == ButtonType.none
              ? Container() 
              : btnRight,
            Expanded(child: Text('${this.title}', textAlign: TextAlign.center, style: this.style ?? header2Style(),),),
            btnLeft == null
              ? MyIconButton(type: ButtonType.exit)
              : (btnLeft ?? ButtonType.none) == ButtonType.none
                ? Container() 
                : btnLeft,
          ],
        ),
      ),
    );
  }
}

class ForeignKeyField extends StatelessWidget{
  final String hint;
  final Map<String, dynamic> initialValue;
  final String f2key;
  final Function onChange;

  ForeignKeyField({@required this.hint, @required this.initialValue, @required this.f2key, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]),
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: FutureBuilder(
        future: f2key=="Employee" 
          ? postToServer(api: 'F2Key/Employee', body: jsonEncode({"token": readToken(context), "id": context.watch<ThemeManager>().cmpid})) 
          : postToServer(api: 'F2Key/$f2key'),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snap){
          if (snap.hasData){
            List<Company> _rows = [];
            if (snap.data['msg'] == "Success"){
              _rows = snap.data['body'].map<Company>((data) => Company.fromJson(json.decode(data))).toList();
              return SearchableDropdown.single(
                value: this.initialValue,
                hint: '$hint',
                closeButton: 'بازگشت',
                searchHint: 'جستجو ...',
                isExpanded: true,
                items: _rows.map((e){
                  return DropdownMenuItem(
                    value: {'id': e.id, 'name': e.name},
                    child: Text(e.name)
                  );
                }).toList(),
                onChanged: onChange
              );
            }
            else
              print(snap.data['msg']);
          }
          return Center(child: CupertinoActivityIndicator());
        },
      )
    );
  }
}

class DesktopIcon extends StatelessWidget {
  const DesktopIcon({Key key, @required this.title, @required this.subtitle, @required this.icon, @required this.onPressed}) : super(key: key);

  final String title;
  final String subtitle;
  final Icon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.5,
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: scaffoldcolor(context), width: 2),
        borderRadius: BorderRadius.circular(25),
      ),
      margin: EdgeInsets.all(10.0),
      child: Container(
        width: 250.0,
        height: 105.0,
        child: ListTile(
          title: Text('$title'),
          subtitle: Text('$subtitle'),
          leading: this.icon,
          onTap: this.onPressed
        ),
      ),
    );
  }
}

class PermissionChip extends StatelessWidget {
  const PermissionChip({Key key, @required this.selected, @required this.title, @required this.onSelected}) : super(key: key);

  final bool selected;
  final String title;
  final void Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: this.selected ? CircleAvatar(backgroundColor: Colors.greenAccent,) : Icon(Icons.do_not_disturb_alt, color: Colors.redAccent,),
      label: Text(this.title), 
      // selectedColor: accentcolor(context).withOpacity(0.5),
      selected: this.selected, 
      onSelected: this.onSelected
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile({Key key, 
    @required this.id, 
    @required this.title, 
    @required this.subtitle, 
    @required this.imgtype, 
    @required this.selected,
    @required this.onTap,
    this.color = Colors.green
  }) : super(key: key);

  final int id;
  final String title;
  final String imgtype;
  final String subtitle;
  final bool selected;
  final Function onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 250.0,
        child: ListTile(
          onTap: this.onTap,
          isThreeLine: true,
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: this.selected ? this.color : Colors.grey,
            child: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=$imgtype&id=$id"),
            )
          ),
          title: Text(title ?? ''), 
          subtitle: Text(subtitle ?? ''),
        ),
      ),
    );
  }
}

class UserPic extends StatelessWidget {
  const UserPic({Key key, @required this.id, this.green = false}) : super(key: key);

  final int id;
  final bool green;

  @override
  Widget build(BuildContext context) {
    return this.green
      ? CircleAvatar(
        radius: 28,
        backgroundColor: Colors.green,
        child: CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=user&id=$id"),
        ),
      )
      : CircleAvatar(
        backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=user&id=$id"),
      );
  }
}

class PeoplePic extends StatelessWidget {
  const PeoplePic({Key key, @required this.id, this.green = false}) : super(key: key);

  final int id;
  final bool green;

  @override
  Widget build(BuildContext context) {
    return this.green
      ? CircleAvatar(
        radius: 28,
        backgroundColor: Colors.green,
        child: CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=people&id=$id"),
        ),
      )
      : CircleAvatar(
        backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=people&id=$id"),
      );
  }
}

class CompanyPic extends StatelessWidget {
  const CompanyPic({Key key, @required this.id, this.green = false}) : super(key: key);

  final int id;
  final bool green;

  @override
  Widget build(BuildContext context) {
    return this.green
      ? CircleAvatar(
        radius: 28,
        backgroundColor: Colors.green,
        child: CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=company&id=$id"),
        ),
      )
      : CircleAvatar(
        backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=company&id=$id"),
      );
  }
}

class GridCaption extends StatelessWidget {
  const GridCaption({Key key, @required this.obj, this.endbuttons = 1, this.header = true, this.color, this.hover = false, this.onTap}) : super(key: key);

  final List<dynamic> obj;
  final int endbuttons;
  final bool header;
  final Color color;
  final bool hover;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return this.hover 
      ? ListTile(
        hoverColor: accentcolor(context).withOpacity(0.25),
        onTap: this.onTap,
        title: card(context),
      )
      : card(context);
  }

  Widget card(BuildContext context){
    return Card(
        color: this.color ?? appbarColor(context),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: obj.map<Widget>(
                    (e) => (e is String) 
                      ? Expanded(child: Text('$e', style: this.header ? gridFieldStyle() : TextStyle(), textAlign: this.header ? TextAlign.center : null,))
                      : e is Widget
                        ? e
                        : Container()).toList(),
                ),
              ),
              SizedBox(width: this.endbuttons * 55.0,),
            ],
          ),
        ),
      );
  }
}

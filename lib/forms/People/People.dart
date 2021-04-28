import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import 'PeopleBloc.dart';

class FmPeople extends StatelessWidget {
  const FmPeople({Key key, this.nationalid, this.justcheck, this.cmpid}) : super(key: key);

  final String nationalid;
  final bool justcheck;
  final int cmpid;

  @override
  Widget build(BuildContext context) {
    PeopleBloc _peopbloc = PeopleBloc();

    if (nationalid!=null && nationalid.isNotEmpty)
      _peopbloc.checkNationalID(context, {'nationalid': nationalid, 'family': '', 'mobile': ''}, this.justcheck);

    // _peopbloc.peopleStream$.listen((data){
    //   if (data.status == Status.loaded && this.justcheck && data.rows.length == 1){
    //     Navigator.of(context).pop(_peopbloc.peopleInfo$[0]);
    //     if ((data.msg ?? '').isNotEmpty)
    //       myAlert(context: context, title: 'موفقیت آمیز', message: data.msg, color: Colors.lightGreen);
    //   }
    // });

    Map<String, dynamic> _data = {"nationalid": "", "family": "", "mobile": ""};

    return Container(
      padding: EdgeInsets.all(5.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: StreamBuilder(
          stream: _peopbloc.peopleStream$,
          builder: (BuildContext context, AsyncSnapshot<PeopleModel> snap){
            if (snap.hasData)
              if (snap.data.status == Status.initial || snap.data.status == Status.loading || snap.data.status == Status.error){
                return Container(
                  height: 325.0,
                  width: 335.0,
                  padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GridTextField(hint: 'کد ملی', initialValue: _data['nationalid'], onChange: (val) => _data['nationalid'] = val, autofocus: true,),
                        GridTextField(hint: 'نام و نام خانوادگی', initialValue: _data['family'], onChange: (val) => _data['family'] = val,),
                        GridTextField(hint: 'تلفن/همراه', initialValue: _data['mobile'], onChange: (val) => _data['mobile'] = val,),
                        SizedBox(height: 15.0,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: (snap.data.status == Status.loading) 
                                ? Center(child: CupertinoActivityIndicator()) 
                                : MyOutlineButton(
                                  color: Colors.lightGreen, 
                                  title: 'بررسی', 
                                  icon: Icons.cloud_queue, 
                                  onPressed: () => _peopbloc.checkNationalID(context, _data, this.justcheck, cmpid: this.cmpid ?? 0)
                                ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: MyOutlineButton(color: Colors.red, title: 'انصراف', icon: Icons.redo, onPressed: (){Navigator.of(context).pop('cancel');},),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              else if (snap.data.status == Status.loaded)
                if (snap.data.rows.length == 1)
                  return PeopleInfo(people: snap.data.rows[0], peoplebloc: _peopbloc,);
                else
                  return PeopleList(rows: snap.data.rows, peoplebloc: _peopbloc);
                // if (snap.data.rows.length == 1)
                //   return PeopleInfo(people: snap.data.rows[0], peoplebloc: _peopbloc,);
                // else 
                //   return PeopleList(rows: snap.data.rows, peoplebloc: _peopbloc);
            return CupertinoActivityIndicator();       
          }
        ),
      ),
    );
  }
}

class PeopleInfo extends StatelessWidget {
  const PeopleInfo({Key key, this.peoplebloc, this.people}) : super(key: key);

  final PeopleBloc peoplebloc;
  final People people;
  
  @override
  Widget build(BuildContext context) {
    FocusNode _fnationalid  = FocusNode();
    FocusNode _fname  = FocusNode();
    FocusNode _ffamily  = FocusNode();
    FocusNode _ffather  = FocusNode();
    FocusNode _fss  = FocusNode();
    FocusNode _fbirth = FocusNode();
    FocusNode _fssplace  = FocusNode();
    FocusNode _fbirthdate  = FocusNode();
    FocusNode _fnationality  = FocusNode();
    FocusNode _freligion  = FocusNode();
    FocusNode _fmazhab  = FocusNode();
    FocusNode _freshte  = FocusNode();
    FocusNode _fenglish  = FocusNode();
    FocusNode _fbimeno  = FocusNode();
    FocusNode _fisargarinesbat  = FocusNode();
    FocusNode _femail  = FocusNode();
    FocusNode _ftel  = FocusNode();
    FocusNode _fmobile  = FocusNode();
    FocusNode _fpost  = FocusNode();
    FocusNode _faddress  = FocusNode();
    FocusNode _fpassport  = FocusNode();
    FocusNode _ftakafolcount = FocusNode();
    FocusNode _fmeliat = FocusNode();
    FocusNode _fmadrakfani = FocusNode();
    FocusNode _fbimeyear = FocusNode();
    FocusNode _fskills = FocusNode();
    FocusNode _fotherjobhistory = FocusNode();
    FocusNode _fjobpermit = FocusNode();
    FocusNode _fshahrdarimantaghe = FocusNode();
    FocusNode _fsarparast = FocusNode();
    FocusNode _fjanbazperc = FocusNode();
    FocusNode _fnote = FocusNode();

    TextEditingController _bdatecontroller = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    _bdatecontroller.text =  people.birthdate ?? '';
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Center(
        child: ListView(
          children: <Widget>[
            Card(
              child: Container(
                height: 75.0,
                color: appbarColor(context),
                child: Row(
                  children: <Widget>[
                    MyIconButton(type: ButtonType.save, onPressed: (){
                      if (_formKey.currentState.validate()){
                        people.birthdate = _bdatecontroller.text;
                        peoplebloc.savePeople(context, people);
                      }
                    }),
                    Expanded(child: Text('اطلاعات شخصی پرونده', style: TextStyle(fontFamily: 'Nazanin', fontSize: 20.0), textAlign: TextAlign.center,)),
                    MyIconButton(type: ButtonType.exit, onPressed: (){Navigator.of(context).pop('cancel');}),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.0,),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: GridTextField(hint: 'کد ملی', width: double.infinity, focus: _fnationalid, nextfocus: _fname, autofocus: true, notempty: true, onChange: (val){people.nationalid = val;}, initialValue: people.nationalid,)),
                      Expanded(child: GridTextField(hint: 'نام', width: double.infinity, focus: _fname, nextfocus: _ffamily, notempty: true, onChange: (val){people.name = val;}, initialValue: people.name)),
                      Expanded(child: GridTextField(hint: 'نام خانوادگی', width: double.infinity, focus: _ffamily, nextfocus: _ffather, notempty: true, onChange: (val){people.family = val;}, initialValue: people.family)),
                      Expanded(child: GridTextField(hint: 'نام پدر', width: double.infinity, focus: _ffather, nextfocus: _fss, notempty: true, onChange: (val){people.father = val;}, initialValue: people.father)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: GridTextField(hint: 'شماره شناسنامه', width: double.infinity, focus: _fss, nextfocus: _fssplace, notempty: true, onChange: (val){people.ss = val;}, initialValue: people.ss)),
                      Expanded(child: GridTextField(hint: 'محل صدور', width: double.infinity, focus: _fssplace, nextfocus: _fbirth, notempty: true, onChange: (val){people.ssplace = val;}, initialValue: people.ssplace)),
                      Expanded(child: GridTextField(hint: 'محل تولد', width: double.infinity, focus: _fbirth, nextfocus: _fbirthdate, notempty: true, onChange: (val){people.birth = val;}, initialValue: people.birth)),
                      Expanded(child: GridTextField(hint: 'تاریخ تولد', width: double.infinity, focus: _fbirthdate, nextfocus: _fnationality, notempty: true, controller:  _bdatecontroller, datepicker: true),),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MultiChooseItem(
                          hint: 'وضعیت تاهل',
                          val: people.single, 
                          items: [{'id': 1, 'title': 'مجرد'},{'id': 2, 'title': 'متاهل'}],
                          onChange: peoplebloc.setSingle,
                        )
                      ),
                      Expanded(child: GridTextField(hint: 'ملیت', width: double.infinity, focus: _fnationality, nextfocus: _freligion, notempty: true, onChange: (val){people.nationality = val;}, initialValue: people.nationality)),
                      Expanded(child: GridTextField(hint: 'دین', width: double.infinity, focus: _freligion, nextfocus: _fmazhab, notempty: true, onChange: (val){people.religion = val;}, initialValue: people.religion)),
                      Expanded(child: GridTextField(hint: 'مذهب', width: double.infinity, focus: _fmazhab, nextfocus: _freshte, notempty: true, onChange: (val){people.mazhab = val;}, initialValue: people.mazhab)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MultiChooseItem(
                          hint: 'جنسیت',
                          val: people.sex, 
                          items: [{'id': 1, 'title': 'مرد'},{'id': 2, 'title': 'زن'}],
                          onChange: peoplebloc.setSex,
                        )
                      ),
                      (people.sex==1) ? Expanded(
                        child: MultiChooseItem(
                          hint: 'وضعیت نظام وظیفه',
                          val: people.military, 
                          items: [{'id': 0, 'title': 'وضعیت نظام وظیفه'},{'id': 1, 'title': 'اتمام'},{'id': 2, 'title': 'معافیت'},{'id': 3, 'title': 'دانشجو'},{'id': 4, 'title': 'مشمول'}],
                          onChange: peoplebloc.setMilitary,
                        )
                      ) : Container(),
                      Expanded(
                        child: MultiChooseItem(
                          hint: 'تحصیلات',
                          val: people.education, 
                          items: [{'id': 0, 'title': 'تحصیلات'},{'id': 1, 'title': 'زیر دیپلم'},{'id': 2, 'title': 'دیپلم'},{'id': 3, 'title': 'دانشجو'},{'id': 4, 'title': 'کاردانی'},{'id': 5, 'title': 'کارشناسی'},{'id': 6, 'title': 'کارشناسی ارشد'},{'id': 7, 'title': 'دکتری'},{'id': 8, 'title': 'فوق دکتری'}],
                          onChange: peoplebloc.setEducation,
                        )
                      ),
                      Expanded(child: GridTextField(hint: 'رشته تحصیلی', width: double.infinity, focus: _freshte, nextfocus: _fenglish, onChange: (val){people.reshte = val;}, initialValue: people.reshte, notempty: true,)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: GridTextField(hint: 'زبان انگلیسی', width: double.infinity, focus: _fenglish, nextfocus: _fbimeno, onChange: (val){people.english = val;}, initialValue: people.english)),
                      Expanded(child: GridTextField(hint: 'شماره بیمه', width: double.infinity, focus: _fbimeno, nextfocus: _femail, notempty: true, onChange: (val){people.bimeno = int.parse(val);}, initialValue: '${people.bimeno}')),
                      Expanded(
                        child: MultiChooseItem(
                          hint: 'وضعیت ایثارگری',
                          val: people.isargari ?? 0, 
                          items: [{'id': 0, 'title': 'ایثارگر نیست'},{'id': 1, 'title': 'ایثارگر هست'}],
                          onChange: peoplebloc.setIsargari,
                        )
                      ),
                      people.isargari == 1 ? Expanded(child: GridTextField(hint: 'نسبت با ایثارگر', width: double.infinity, focus: _fisargarinesbat, nextfocus: _femail, notempty: true, onChange: (val){people.isargarinesbat = val;}, initialValue: people.isargarinesbat)) : Container(),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: GridTextField(hint: 'افراد تحت تکفل', numberonly: true, width: double.infinity, focus: _ftakafolcount, nextfocus: _fmeliat, onChange: (val){people.takafolcount = int.tryParse(val);}, initialValue: '${people.takafolcount}')),
                      Expanded(child: GridTextField(hint: 'ملیت', width: double.infinity, focus: _fmeliat, nextfocus: _fmadrakfani, onChange: (val){people.meliat= val;}, initialValue: people.meliat)),
                      Expanded(child: GridTextField(hint: 'مدرک فنی', width: double.infinity, focus: _fmadrakfani, nextfocus: _fbimeyear, onChange: (val){people.madrakfani = val;}, initialValue: people.madrakfani)),
                      Expanded(child: GridTextField(hint: 'سابقه بیمه', numberonly: true, width: double.infinity, focus: _fbimeyear, nextfocus: _fskills, onChange: (val){people.bimeyear = int.tryParse(val);}, initialValue: '${people.bimeyear}')),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: GridTextField(hint: 'مهارت', width: double.infinity, focus: _fskills, nextfocus: _fotherjobhistory, onChange: (val){people.skills= val;}, initialValue: people.skills)),
                      Expanded(child: GridTextField(hint: 'سایر سوابق کاری', width: double.infinity, focus: _fotherjobhistory, nextfocus: _fjobpermit, onChange: (val){people.otherjobhistory = val;}, initialValue: people.otherjobhistory)),
                      Expanded(child: GridTextField(hint: 'شماره مجوز کار', numberonly: true, width: double.infinity, focus: _fjobpermit, nextfocus: _fshahrdarimantaghe, onChange: (val){people.jobpermitno = int.tryParse(val);}, initialValue: '${people.jobpermitno}')),
                      Expanded(child: GridTextField(hint: 'منطقه شهرداری', numberonly: true, width: double.infinity, focus: _fshahrdarimantaghe, nextfocus: _fsarparast, onChange: (val){people.shahrdarimantaghe = int.tryParse(val);}, initialValue: '${people.shahrdarimantaghe}')),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: GridTextField(hint: 'سرپرست خانواده', numberonly: true, width: double.infinity, focus: _fsarparast, nextfocus: _fjanbazperc, onChange: (val){people.sarparast = int.tryParse(val);}, initialValue: '${people.sarparast}')),
                      Expanded(
                        child: MultiChooseItem(
                          hint: 'نوع شناسنامه',
                          val: (people.sskind ?? 1) < 1 ? 1 : (people.sskind ?? 1), 
                          items: [{'id': 1, 'title': 'اصلی'},{'id': 2, 'title': 'المثنی'}],
                          onChange: peoplebloc.setsskind,
                        )
                      ),
                      Expanded(child: GridTextField(hint: 'درصد جانبازی', numberonly: true, width: double.infinity, focus: _fjanbazperc, nextfocus: _fnote, onChange: (val){people.janbazperc = int.tryParse(val);}, initialValue: '${people.janbazperc}')),
                      Expanded(
                        child: MultiChooseItem(
                          hint: 'گروه خونی',
                          val: (people.blood ?? 1) < 1 ? 1 : (people.blood ?? 1), 
                          items: [{'id': 1, 'title': 'AB+'},{'id': 2, 'title': 'AB-'},{'id': 3, 'title': 'O+'},{'id': 4, 'title': 'O-'},{'id': 5, 'title': 'B-'},{'id': 6, 'title': 'B+'},{'id': 7, 'title': 'A-'},{'id': 8, 'title': 'A+'}],
                          onChange: peoplebloc.setBlood,
                        )
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MultiChooseItem(
                          hint: 'نهاد حمایتی',
                          val: people.support ?? 0, 
                          items: [{'id': 0, 'title': 'ندارد'},{'id': 1, 'title': 'کمیته امداد'},{'id': 2, 'title': 'بهزیستی'}],
                          onChange: peoplebloc.setSupport,
                        )
                      ),
                      Expanded(child: GridTextField(hint: 'توضیحات', width: double.infinity, focus: _fnote, nextfocus: _femail, onChange: (val){people.note = val;}, initialValue: people.note)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: GridTextField(hint: 'پست الکترونیک', width: double.infinity, focus: _femail, nextfocus: _ftel, onChange: (val){people.email = val;}, initialValue: people.email)),
                      Expanded(child: GridTextField(hint: 'تلفن', width: double.infinity, focus: _ftel, nextfocus: _fmobile, onChange: (val){people.tel = val;}, initialValue: people.tel)),
                      Expanded(child: GridTextField(hint: 'همراه', width: double.infinity, focus: _fmobile, nextfocus: _fpost, notempty: true, onChange: (val){people.mobile = val;}, initialValue: people.mobile)),
                      Expanded(child: GridTextField(hint: 'کد پستی', width: double.infinity, focus: _fpost, nextfocus: _fpassport, onChange: (val){people.post = val;}, initialValue: people.post)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: GridTextField(hint: 'شماره پاسپورت', width: double.infinity, focus: _fpassport, nextfocus: _faddress, onChange: (val){people.passport = val;}, initialValue: people.passport)),
                      Expanded(flex: 3, child: GridTextField(hint: 'نشانی محل سکونت', width: double.infinity, focus: _faddress, nextfocus: _fnationality, notempty: true, onChange: (val){people.address = val;}, initialValue: people.address)),
                    ],
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

class PeopleList extends StatelessWidget {
  const PeopleList({Key key, @required this.rows, @required this.peoplebloc}) : super(key: key);

  final PeopleBloc peoplebloc;
  final List<People> rows;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.65,
        height: screenHeight(context) * 0.75,
        child: Column(
          children: [
            FormHeader(title: 'شخص مورد نظر را انتخاب نمایید', btnLeft: MyIconButton(type: ButtonType.exit, onPressed: ()=> peoplebloc.backtogetNationalID())),
            GridCaption(obj: ['کد ملی', 'نام و نام خانوادگی','نام پدر','شماره همراه']),
            Expanded(
              child: ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, idx){
                  return GridCaption(
                      obj: [PeoplePic(id: rows[idx].id), SizedBox(width: 10.0,), '${rows[idx].nationalid}', '${rows[idx].name} ${rows[idx].family}', '${rows[idx].father}', '${rows[idx].mobile}'], 
                      header: false, 
                      color: idx.isOdd ? appbarColor(context) : scaffoldcolor(context), 
                      hover: true,
                      onTap: () => Navigator.of(context).pop(rows[idx]));
                }
              ),
            )
          ],
        ),
      )
    );
  }
}



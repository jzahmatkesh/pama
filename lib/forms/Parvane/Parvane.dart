import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/forms/GUnit/GUnit.dart';
import 'ParvaneBloc.dart';
import '../People/People.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';


class FmParvane extends StatelessWidget {
  final User user;

  FmParvane({@required this.user});

  @override
  Widget build(BuildContext context) {
    Bloc<int> _type = Bloc<int>()..setValue(1);
    ParvaneBloc _bloc = ParvaneBloc()..loadData(context, user, _type.value$);

    void changeKind(int i){
      _type.setValue(i);
      _bloc.loadData(context, user, _type.value$);
    }

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          FormHeader(
            title: 'لیست اعضاء / متقاضیان اتحادیه ${this.user.cmpname}',
            btnRight: MyIconButton(type: ButtonType.add, hint: 'متفاضی جدید', onPressed: ()=>showFormAsDialog(context: context, form: ParvaneInfo(bloc: _bloc, parvane: Parvane(id: 0)))),
            btnLeft: MyIconButton(type: ButtonType.none),
          ),
          StreamBuilder<int>(
            stream: _type.stream$,
            builder: (context, snap) {
              return Row(
                children: [
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: ()=>changeKind(1),
                        child: Ink(
                          color: snap.data == 1 ? accentcolor(context).withOpacity(0.4) : Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Text('اعضاء', textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: ()=>changeKind(2),
                        child: Ink(
                          color: snap.data == 2 ? accentcolor(context).withOpacity(0.4) : Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Text('متقاضیان', textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              );
            }
          ),
          GridCaption(obj: [
              'شماره عضویت',
              'نام و نام خانوادگی',
              'کد ملی',
              'شماره همراه',
              'آخرین فرآیند',
              'وضعیت فرآیند'
            ],
            endbuttons: 2,
          ),
          Expanded(
            child: StreamBuilder<ParvaneModel>(
              stream: _bloc.stream$,
              builder: (context, snap){
                if (snap.hasData){
                  if (snap.data.status == Status.error)
                    return ErrorInGrid('${snap.data.msg}');
                  if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        return Row(
                          children: [
                            SizedBox(width: 8),
                            snap.data.rows[idx].nosazicode.toLabel().expand(),
                            snap.data.rows[idx].peopname.toLabel().expand(),
                            snap.data.rows[idx].nationalid.toLabel().expand(),
                            snap.data.rows[idx].mobile.toLabel().expand(),
                            snap.data.rows[idx].lastprocess.toLabel().expand(),
                            snap.data.rows[idx].lastprocessstatus.toLabel().expand(),
                            IconButton(tooltip: 'فرآیند جدید', icon: Icon(Icons.add_box_outlined, color: Colors.blue), onPressed: (){}),
                            IconButton(tooltip: 'سایر اطلاعات شخصی', icon: Icon(Icons.info, color: Colors.blue), onPressed: ()=>showFormAsDialog(context: context, form: ParvaneInfo(bloc: _bloc, parvane: snap.data.rows[idx]))),
                          ],
                        ).card();
                      }
                    );
                }
                return Center(child: CupertinoActivityIndicator());
              }
            )
          )
        ],
      ),
    );
  }
}

class ParvaneInfo extends StatelessWidget {
  final Parvane parvane;
  final ParvaneBloc bloc;

  ParvaneInfo({@required this.bloc, @required this.parvane});

  @override
  Widget build(BuildContext context) {
    var _id = TextEditingController(text: '${this.parvane.id}');
    var _iranianasnaf = TextEditingController(text: '${this.parvane.iranianasnaf}');
    var _guname = TextEditingController(text: '${this.parvane.guname}');
    var _gubegindate = TextEditingController(text: '${this.parvane.gubegindate}');
    var _gutoolsinfo = TextEditingController(text: '${this.parvane.gutoolsinfo}');
    var _guensheabat = TextEditingController(text: '${this.parvane.guensheabat}');
    var _gubimeshobe = TextEditingController(text: '${this.parvane.gubimeshobe}');
    var _gukargahno = TextEditingController(text: '${this.parvane.gukargahno}');
    var _guzirbana = TextEditingController(text: '${this.parvane.guzirbana}');
    var _gutabaghat = TextEditingController(text: '${this.parvane.gutabaghat}');
    var _gurent = TextEditingController(text: '${this.parvane.gurent}');
    var _gudaraeicode = TextEditingController(text: '${this.parvane.gudaraeicode}');
    var _guvahedmaliati = TextEditingController(text: '${this.parvane.guvahedmaliati}');
    var _guparvandemaliat = TextEditingController(text: '${this.parvane.guparvandemaliat}');
    var _gutel = TextEditingController(text: '${this.parvane.gutel}');
    var _gufax = TextEditingController(text: '${this.parvane.gufax}');
    var _guesteghrarplace = TextEditingController(text: '${this.parvane.guesteghrarplace}');
    var _gusigntitle = TextEditingController(text: '${this.parvane.gusigntitle}');
    var _gunote = TextEditingController(text: '${this.parvane.gunote}');
    var _ecoid = TextEditingController(text: '${this.parvane.ecoid}');
    var _hoghoghiname = TextEditingController(text: '${this.parvane.hoghoghiname}');
    var _hoghoghishenasemeli = TextEditingController(text: '${this.parvane.hoghoghishenasemeli}');
    var _hoghoghisabtno = TextEditingController(text: '${this.parvane.hoghoghisabtno}');
    var _hesabno = TextEditingController(text: '${this.parvane.hesabno}');
    // var _reqdate = TextEditingController(text: '${this.parvane.reqdate}');
    // var _peopid = TextEditingController(text: '${this.parvane.peopid}');
    // var _gunitid = TextEditingController(text: '${this.parvane.gunitid}');
    // var _gubimemakan = TextEditingController(text: '${this.parvane.gubimemakan}');
    // var _gustatus = TextEditingController(text: '${this.parvane.gustatus}');
    // var _kind = TextEditingController(text: '${this.parvane.kind}');
    // var _parvandekind = TextEditingController(text: '${this.parvane.parvandekind}');
    // var _bank = TextEditingController(text: '${this.parvane.bank}');
    // var _hesabkind = TextEditingController(text: '${this.parvane.hesabkind}');
    // var _hisic = TextEditingController(text: '${this.parvane.hisic}');
    // var _isic = TextEditingController(text: '${this.parvane.isic}');
    // var _hoghoghikind = TextEditingController(text: '${this.parvane.hoghoghikind}');
    // var _hoghoghisabtdate = TextEditingController(text: '${this.parvane.hoghoghisabtdate}');
    // var _parvanekind = TextEditingController(text: '${this.parvane.parvanekind}');
    // var _datesodor = TextEditingController(text: '${this.parvane.datesodor}');
    // var _datetahvil = TextEditingController(text: '${this.parvane.datetahvil}');
    // var _etebarlen = TextEditingController(text: '${this.parvane.etebarlen}');
    // var _eparvaneno = TextEditingController(text: '${this.parvane.eparvaneno}');
    // var _note = TextEditingController(text: '${this.parvane.note}');
    // var _shenasesenfi = TextEditingController(text: '${this.parvane.shenasesenfi}');
    // var _accept = TextEditingController(text: '${this.parvane.accept}');
    // var _acceptdate = TextEditingController(text: '${this.parvane.acceptdate}');
    // var _bankname = TextEditingController(text: '${this.parvane.bankname}');
    // var _isicname = TextEditingController(text: '${this.parvane.isicname}');

    final _form = GlobalKey<FormState>();
    final _edreqdate = TextEditingController(text: this.parvane.reqdate);
    final _edhoghoghisabtdate = TextEditingController(text: this.parvane.reqdate);
    final _peopname = TextEditingController(text: this.parvane.peopname);
    final _nosazicode = TextEditingController(text: this.parvane.nosazicode);
    

    // Bloc<int> _tabidx = Bloc<int>()..setValue(1);

    Widget stepOne(){
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GridTextField(
                hint: 'فرد صنفی',
                readonly: true,
                controller: _peopname,
                notempty: true,
                icon: MyIconButton(type: ButtonType.none, hint: 'انتخاب فرد صنفی', icon: Icon(Icons.more_horiz), onPressed: ()=>showFormAsDialog(
                  context: context, 
                  form: FmPeople(
                    nationalid: "", 
                    justcheck: true
                  ), 
                  done: (dynamic data){
                    if (data is People){
                      parvane.peopid = data.id;
                      parvane.peopname = data.name+' '+data.family;
                      _peopname.text = parvane.peopname;
                    }
                  }
                ))
              ).expand(),              
              GridTextField(hint: 'شماره ایرانیان اصناف', notempty: true, controller: _iranianasnaf, autofocus: true).expand(),
              GridTextField(hint: 'تاریخ تقاضا', notempty: true, controller: _edreqdate, datepicker: true).expand(),
              GridTextField(hint: 'شماره درخواست', notempty: true, controller: _id).expand(),
            ]
          ),
          Row(
            children: [
              DropDownItems(val: parvane.kind, items: [{'id': 1, 'title': 'حقیقی'},{'id': 2, 'title': 'مشارکت مدنی'},{'id': 3, 'title': 'مشارکت حقوقی'}], hint: 'نوع متقاضی', onChange: (val)=>parvane.kind=val).expand(),
              DropDownItems(val: parvane.parvandekind, items: [{'id': 1, 'title': 'عادی'},{'id': 2, 'title': 'ایثارگران'}], hint: 'نوع پرونده', onChange: (val)=>parvane.parvandekind=val).expand(),
              GridTextField(hint: 'کد اقتصادی', notempty: true, controller: _ecoid).expand(),
            ]
          ),
          Row(
            children: [
              ForeignKeyField(hint: 'عنوان بانک', initialValue: {'id': this.parvane.bank, 'name': this.parvane.bankname}, f2key: 'Bank', onChange: (val){this.parvane.bank = val['id'];this.parvane.bankname = val['name'];},).expand(),
              GridTextField(hint: 'شماره حساب', notempty: true, controller: _hesabno).expand(),
              DropDownItems(val: parvane.hesabkind, items: [{'id': 1, 'title': 'جاری'},{'id': 2, 'title': 'سپرده'},{'id': 3, 'title': 'قرض الحسنه'}], hint: 'نوع حساب', onChange: (val)=>parvane.hesabkind=val).expand(),
            ]
          ),
          Row(
            children: [
              ForeignKeyField(hint: 'کد آیسیک', initialValue: {'hisic': this.parvane.hisic, 'isic': this.parvane.isic, 'name': this.parvane.isicname}, f2key: 'Raste', onChange: (val){this.parvane.hisic = val['hisic'];this.parvane.isic = val['isic'];this.parvane.isicname = val['name'];},).expand(),
              // GridTextField(hint: 'کد آیسیک', initialValue: '${this.parvane.hisic}', onChange: (val)=>parvane.hisic=int.tryParse(val)).expand(),
              DropDownItems(val: parvane.hoghoghikind, items: [
                {'id': 1, 'title': 'سهام خاص'},
                {'id': 2, 'title': 'سهامی عام'},
                {'id': 3, 'title': 'تضامنی'},
                {'id': 4, 'title': 'تعاونی'},
                {'id': 5, 'title': 'مسولیت محدود'},
                {'id': 6, 'title': 'غیره'}
              ], hint: 'نوع شخصیت حقوقی', onChange: (val)=>parvane.hoghoghikind=val).expand(),
              GridTextField(hint: 'عنوان شخصیت حقوقی', notempty: true, controller: _hoghoghiname).expand(),
            ]
          ),
          Row(
            children: [
              GridTextField(hint: 'شناسه ملی', notempty: true, controller: _hoghoghishenasemeli).expand(),
              GridTextField(hint: 'شماره ثبت', notempty: true, controller: _hoghoghisabtno).expand(),
              GridTextField(hint: 'تاریخ ثبت', notempty: true, controller: _edhoghoghisabtdate, datepicker: true).expand(),
              DropDownItems(val: parvane.parvanekind, items: [{'id': 1, 'title': 'موقت'},{'id': 2, 'title': 'دایم'}], hint: 'نوع پروانه', onChange: (val)=>parvane.parvanekind=val).expand(),
            ]
          ),
        ],
      );
    }

    Widget stepTwo(){
      return Column(
        children: [
          Row(
            children: [
              GridTextField(
                hint: 'واحد صنفی',
                readonly: true,
                controller: _nosazicode,
                notempty: true,
                icon: MyIconButton(type: ButtonType.none, hint: 'انتخاب واحد صنفی', icon: Icon(Icons.more_horiz), onPressed: ()=>showFormAsDialog(
                  context: context, 
                  form: FmGUnit(
                    nosazicode: "", 
                    justcheck: true
                  ), 
                  done: (dynamic data){
                    if (data is GUnit){
                      parvane.gunitid = data.id;
                      _nosazicode.text = data.nosazicode;
                    }
                  }
                ))
              ).expand(),        
              GridTextField(hint: 'نام واحد صنفی', notempty: true, controller: _guname).expand(),      
              GridTextField(hint: 'تاریخ شروه فعالیت', notempty: true, datepicker: true, controller: _gubegindate).expand(),      
            ],
          ),
          Row(
            children: [
              GridTextField(hint: 'ابزار و امکانات و تجهیزات', notempty: true, controller: _gutoolsinfo).expand(),      
              GridTextField(hint: 'انشعابات', notempty: true, controller: _guensheabat).expand(),      
              RadioButton(val: parvane.gubimemakan, hint: 'بیمه مکان', onChange: (val)=>parvane.gubimemakan=val),
              'بیمه مکان'.toLabel(),
              SizedBox(width: 10),
              GridTextField(hint: 'شعبه تامین اجتماعی', notempty: true, controller: _gubimeshobe).expand(),      
            ]
          ),
          Row(
            children: [
              GridTextField(hint: 'شماره کارگاه', notempty: true, controller: _gukargahno).expand(),      
              GridTextField(hint: 'زیربنا', controller: _guzirbana).expand(),      
              GridTextField(hint: 'تعداد طبقات', controller: _gutabaghat).expand(),      
              GridTextField(hint: 'میزان اجاره', controller: _gurent).expand(),      
            ]
          ),
          Row(
            children: [
              GridTextField(hint: 'کد رهگیری ثبت نام دارایی', notempty: true, controller: _gudaraeicode).expand(),      
              GridTextField(hint: 'واحد مالیاتی', controller: _guvahedmaliati).expand(),      
              GridTextField(hint: 'شماره پرونده مالیاتی', notempty: true, controller: _guparvandemaliat).expand(),      
              MultiChooseItem(val: parvane.gustatus, items: [{'id': 1, 'title': 'مالکیت'},{'id': 2,  'title': 'سرقفلی'}], hint: 'وضعیت مالکیت', onChange: (val)=>parvane.gustatus=val['id']).expand(),
            ]
          ),
          Row(
            children: [
              GridTextField(hint: 'تلفن', notempty: true, controller: _gutel).expand(),      
              GridTextField(hint: 'فکس', notempty: true, controller: _gufax).expand(),      
              GridTextField(hint: 'محل استقرار', notempty: true, controller: _guesteghrarplace).expand(),      
            ],
          ),
          Row(
            children: [
              GridTextField(hint: 'عنوان تابلو', notempty: true, controller: _gusigntitle).expand(),      
              GridTextField(hint: 'توضیحات', controller: _gunote).expand(),      
            ]
          ),
        ],
      );
    }

    Widget stepThree(){
      if (bloc.mobashervalue$.status != Status.loaded)
        bloc.loadMobasher(context, parvane.id);
      return Column(
        children: [
          GridCaption(
            obj: [
              IconButton(icon: Icon(Icons.add_box_outlined, color: Colors.blue), onPressed: (){}),
              'کد ملی',
              'نام',
              'نام خانوادگی',
              'نام پدر',
              'شماره شناسنامه',
              'تاریخ تولد',
              'مدرک فنی',
              'زبان انگلیسی',
            ],
            endbuttons: 1,
          ),
          StreamBuilder<ParvaneMobasherModel>(
            stream: bloc.mobasherstream$,
            builder: (context, snap){
              if (snap.hasData)
                if (snap.data.status == Status.loaded)
                  return ListView.builder(
                    itemCount: snap.data.rows.length,
                    itemBuilder: (context, idx)=>MyRow(
                      children: [
                        snap.data.rows[idx].nationalid,
                        snap.data.rows[idx].name,
                        snap.data.rows[idx].family,
                        snap.data.rows[idx].father,
                        snap.data.rows[idx].ss,
                        snap.data.rows[idx].birthdate,
                        snap.data.rows[idx].madrakfani,
                        snap.data.rows[idx].english
                      ]
                    )
                  );
              return Center(child: CupertinoActivityIndicator());
            }
          ).expand()
        ],
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Form(
        key: _form,
        child: Container(
          width: screenWidth(context) * 0.85,
          child: DefaultTabController(
            length: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormHeader(title: 'اطلاعات اعضاء / متقاضیان', btnRight: MyIconButton(type: ButtonType.other, icon: Icon(Icons.check_box_outlined, color: Colors.green,), hint: 'بعدی', onPressed: (){
                  this.parvane.reqdate = _edreqdate.text;
                  this.parvane.hoghoghisabtdate = _edhoghoghisabtdate.text;
                  this.parvane.id = _id.text.toInt();
                  this.parvane.iranianasnaf = _iranianasnaf.text.toInt();
                  this.parvane.guname = _guname.text;
                  this.parvane.gubegindate = _gubegindate.text;
                  this.parvane.gutoolsinfo = _gutoolsinfo.text;
                  this.parvane.guensheabat = _guensheabat.text;
                  this.parvane.gubimeshobe = _gubimeshobe.text;
                  this.parvane.gukargahno = _gukargahno.text.toInt();
                  this.parvane.guzirbana = _guzirbana.text.toInt();
                  this.parvane.gutabaghat = _gutabaghat.text.toInt();
                  this.parvane.gurent = _gurent.text.toDouble();
                  this.parvane.gudaraeicode = _gudaraeicode.text.toInt();
                  this.parvane.guvahedmaliati = _guvahedmaliati.text;
                  this.parvane.guparvandemaliat = _guparvandemaliat.text.toInt();
                  this.parvane.gutel = _gutel.text;
                  this.parvane.gufax = _gufax.text;
                  this.parvane.guesteghrarplace = _guesteghrarplace.text;
                  this.parvane.gusigntitle = _gusigntitle.text;
                  this.parvane.gunote = _gunote.text;
                  this.parvane.ecoid = _ecoid.text.toInt();
                  this.parvane.hoghoghiname = _hoghoghiname.text;
                  this.parvane.hoghoghishenasemeli = _hoghoghishenasemeli.text;
                  this.parvane.hoghoghisabtno = _hoghoghisabtno.text.toInt();
                  this.parvane.hesabno = _hesabno.text;

                  if (_form.currentState.validate())
                    if (this.parvane.bank == 0)
                      myAlert(context: context, title: 'مقادیر اجباری', message: 'بانک انتخاب نشده است');
                    else if (this.parvane.hisic == 0)
                      myAlert(context: context, title: 'مقادیر اجباری', message: 'رسته انتخاب نشده است');
                    else
                      bloc.saveData(context, parvane);
                })),
                TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey.shade400,
                  tabs: [
                    Tab(text: 'ثبت درخواست'),
                    Tab(text: 'واحد صنفی'),
                    Tab(text: 'معرفی مباشر'),
                    Tab(text: 'معرفی شریک'),
                    Tab(text: 'معرفی پرسنل'),
                  ], 
                  // tabsel: _tabidx,
                  // validate: ()=>_form.currentState.validate(),
                ).vMargin(),
                TabBarView(
                  children: [
                    stepOne(),
                    stepTwo(),
                    stepThree(),
                    Center(child: Text('معرفی شریک')),
                    Center(child: Text('معرفی پرسنل')),
                  ]
                ).expand()
              ],
            ),
          ),
        ).setPadding(),
      ),
    );
  }
}

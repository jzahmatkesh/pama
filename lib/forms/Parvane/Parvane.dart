import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pama/module/persiandate.dart';
import '../GUnit/GUnit.dart';
import '../ParvaneProcess/ParvaneProcess.dart';
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
            btnRight: MyIconButton(type: ButtonType.add, hint: 'متفاضی جدید', onPressed: ()=>showFormAsDialog(context: context, form: ParvaneInfo(bloc: _bloc, parvane: Parvane(id: 0, reqdate:'${PersianDate.now()}')))),
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
                        onTap: ()=>changeKind(0),
                        child: Ink(
                          color: snap.data == 0 ? accentcolor(context).withOpacity(0.4) : Colors.transparent,
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
              // 'وضعیت فرآیند'
            ],
            endbuttons: 3,
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
                            TextButton(
                              onPressed: (){
                                if (snap.data.rows[idx].lastprocess != null || snap.data.rows[idx].failprocess != null)
                                  showFormAsDialog(context: context, form: FmParvaneProcess(parvane: snap.data.rows[idx]), done: (data)=>_bloc.loadData(context, user, _type.value$));
                              },
                              child: (snap.data.rows[idx].lastprocess ?? (snap.data.rows[idx].failprocess ?? 'بدون فرآیند')).toLabel(color: snap.data.rows[idx].lastprocess != null || snap.data.rows[idx].failprocess == null ? accentcolor(context) : backgroundColor(context))
                            ).expand(),
                            // snap.data.rows[idx].lastprocessstatus.toLabel().expand(),
                            MyIconButton(
                              type: ButtonType.add, 
                              hint: 'فرآیند جدید', 
                              onPressed: ()=>showFormAsDialog(
                                context: context, 
                                form: NewParvaneProcess(
                                  parvaneid: snap.data.rows[idx].id), 
                                  done: (data){
                                    if (data !=  null && data is bool && data){
                                      _bloc.loadData(context, user, _type.value$);
                                      showFormAsDialog(context: context, form: FmParvaneProcess(parvane: snap.data.rows[idx]));
                                    }
                                  }
                              )
                            ),
                            MyIconButton(type: ButtonType.info, hint: 'سایر اطلاعات شخصی', onPressed: ()=>showFormAsDialog(context: context, form: ParvaneInfo(bloc: _bloc, parvane: snap.data.rows[idx]))),
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
    final _prsbdate = TextEditingController();
    final _prsedate = TextEditingController();
    final _edhoghoghisabtdate = TextEditingController(text: this.parvane.reqdate);
    final _peopname = TextEditingController(text: this.parvane.peopname);
    final _nosazicode = TextEditingController(text: this.parvane.nosazicode);

    Bloc<int> _tabidx = Bloc<int>()..setValue(0);
    Bloc<int> _parvanekind = Bloc<int>()..setValue(0);

    bool prcSave(){
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

      if (_form.currentState == null || _form.currentState.validate())
        if (this.parvane.bank == 0){
          myAlert(context: context, title: 'مقادیر اجباری', message: 'بانک انتخاب نشده است');
        } 
        else if (this.parvane.hisic == 0){
          myAlert(context: context, title: 'مقادیر اجباری', message: 'رسته انتخاب نشده است');
        }
        else if (this.parvane.hoghoghishenasemeli.trim().isNotEmpty && this.parvane.hoghoghishenasemeli.trim().length != 10){
          myAlert(context: context, title: 'اخطار', message: 'شناسه ملی می بایسست ۱۰ رقم باشد');
        }
        else{
          if (!this.parvane.register)
            bloc.saveData(context, parvane);
          return true;
        }
      myAlert(context: context, title: 'مقادیر اجباری', message: 'مقادیر بخشهای ثبت درخواست و واحد صنفی می بایست مشخص گردند');
      return false;
    }

    Widget parvanePeopInfo(){
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
              GridTextField(hint: 'شماره ایرانیان اصناف', notempty: true, controller: _iranianasnaf, autofocus: !this.parvane.register, readonly: this.parvane.register).expand(),
              GridTextField(hint: 'تاریخ تقاضا', notempty: true, controller: _edreqdate, datepicker: true, readonly: this.parvane.register).expand(),
              GridTextField(hint: 'شماره درخواست', notempty: true, controller: _id, readonly: this.parvane.register).expand(),
            ]
          ),
          Row(
            children: [
              ForeignKeyField(hint: 'کد آیسیک', initialValue: {'hisic': this.parvane.hisic, 'isic': this.parvane.isic, 'name': this.parvane.isicname}, f2key: 'Raste', onChange: (val){this.parvane.hisic = val['hisic'];this.parvane.isic = val['isic'];this.parvane.isicname = val['name'];},).expand(),
              DropDownItems(val: parvane.parvandekind, items: [{'id': 1, 'title': 'عادی'},{'id': 2, 'title': 'ایثارگران'}], hint: 'نوع پرونده', onChange: (val)=>parvane.parvandekind=val).expand(),
              GridTextField(hint: 'کد اقتصادی', notempty: true, controller: _ecoid, readonly: this.parvane.register).expand(),
            ]
          ),
          Row(
            children: [
              ForeignKeyField(hint: 'عنوان بانک', initialValue: {'id': this.parvane.bank, 'name': this.parvane.bankname}, f2key: 'Bank', onChange: (val){this.parvane.bank = val['id'];this.parvane.bankname = val['name'];}).expand(),
              GridTextField(hint: 'شماره حساب', notempty: true, controller: _hesabno, readonly: this.parvane.register).expand(),
              DropDownItems(val: parvane.hesabkind, items: [{'id': 1, 'title': 'جاری'},{'id': 2, 'title': 'سپرده'},{'id': 3, 'title': 'قرض الحسنه'}], hint: 'نوع حساب', onChange: (val)=>parvane.hesabkind=val).expand(),
            ]
          ),
          StreamBuilder<int>(
            stream: _parvanekind.stream$,
            builder: (_, snap)=>Column(
              children: [
                Row(
                  children: [
                    DropDownItems(val: parvane.kind, items: [{'id': 1, 'title': 'حقیقی'},{'id': 2, 'title': 'مشارکت مدنی'},{'id': 3, 'title': 'مشارکت حقوقی'}], hint: 'نوع متقاضی', onChange: (val){_parvanekind.setValue(val); parvane.kind=val;}).expand(),
                    // GridTextField(hint: 'کد آیسیک', initialValue: '${this.parvane.hisic}', onChange: (val)=>parvane.hisic=int.tryParse(val)).expand(),
                    parvane.kind==3
                      ? DropDownItems(val: parvane.hoghoghikind, items: [
                          {'id': 1, 'title': 'سهام خاص'},
                          {'id': 2, 'title': 'سهامی عام'},
                          {'id': 3, 'title': 'تضامنی'},
                          {'id': 4, 'title': 'تعاونی'},
                          {'id': 5, 'title': 'مسولیت محدود'},
                          {'id': 6, 'title': 'غیره'}
                          ], hint: 'نوع شخصیت حقوقی', onChange: (val)=>parvane.hoghoghikind=val).expand()
                      : DropDownItems(val: parvane.parvanekind, items: [{'id': 1, 'title': 'موقت'},{'id': 2, 'title': 'دایم'}], hint: 'نوع پروانه', onChange: (val)=>parvane.parvanekind=val).expand(),
                    parvane.kind==3 
                      ? GridTextField(hint: 'عنوان شخصیت حقوقی', notempty: true, controller: _hoghoghiname, readonly: this.parvane.register).expand()
                      : Container(),
                  ]
                ),
                Row(
                  children: [
                    parvane.kind==3 
                      ? GridTextField(hint: 'شناسه ملی', notempty: true, controller: _hoghoghishenasemeli, readonly: this.parvane.register).expand()
                      : Container(),
                    parvane.kind==3 
                      ? GridTextField(hint: 'شماره ثبت', notempty: true, controller: _hoghoghisabtno, readonly: this.parvane.register).expand()
                      : Container(),
                    parvane.kind==3 
                      ? GridTextField(hint: 'تاریخ ثبت', notempty: true, controller: _edhoghoghisabtdate, datepicker: true, readonly: this.parvane.register).expand()
                      : Container(),
                    parvane.kind==3
                      ? DropDownItems(val: parvane.parvanekind, items: [{'id': 1, 'title': 'موقت'},{'id': 2, 'title': 'دایم'}], hint: 'نوع پروانه', onChange: (val)=>parvane.parvanekind=val).expand()
                      : Container()
                  ]
                ),
              ],
            )
          )
        ],
      );
    }

    Widget parvaneGUNit(){
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
              GridTextField(hint: 'نام واحد صنفی', notempty: true, controller: _guname, readonly: this.parvane.register).expand(),      
              GridTextField(hint: 'تاریخ شروع فعالیت', notempty: true, datepicker: true, controller: _gubegindate, readonly: this.parvane.register).expand(),      
            ],
          ),
          Row(
            children: [
              GridTextField(hint: 'ابزار و امکانات و تجهیزات', notempty: true, controller: _gutoolsinfo, readonly: this.parvane.register).expand(),      
              GridTextField(hint: 'انشعابات', notempty: true, controller: _guensheabat, readonly: this.parvane.register).expand(),      
              RadioButton(val: parvane.gubimemakan, hint: 'بیمه مکان', onChange: (val)=>parvane.gubimemakan=val),
              'بیمه مکان'.toLabel(),
              SizedBox(width: 10),
              GridTextField(hint: 'شعبه تامین اجتماعی', notempty: true, controller: _gubimeshobe, readonly: this.parvane.register).expand(),      
            ]
          ),
          Row(
            children: [
              GridTextField(hint: 'شماره کارگاه', notempty: true, controller: _gukargahno, readonly: this.parvane.register).expand(),      
              GridTextField(hint: 'زیربنا', controller: _guzirbana, readonly: this.parvane.register).expand(),      
              GridTextField(hint: 'تعداد طبقات', controller: _gutabaghat, readonly: this.parvane.register).expand(),      
              GridTextField(hint: 'میزان اجاره', controller: _gurent, readonly: this.parvane.register).expand(),      
            ]
          ),
          Row(
            children: [
              GridTextField(hint: 'کد رهگیری ثبت نام دارایی', notempty: true, controller: _gudaraeicode, readonly: this.parvane.register).expand(),      
              GridTextField(hint: 'واحد مالیاتی', controller: _guvahedmaliati, readonly: this.parvane.register).expand(),      
              GridTextField(hint: 'شماره پرونده مالیاتی', notempty: true, controller: _guparvandemaliat, readonly: this.parvane.register).expand(),      
              DropDownItems(val: parvane.gustatus, items: [{'id': 1, 'title': 'مالکیت'},{'id': 2, 'title': 'سرقفلی'}], hint: 'وضعیت مالکیت', onChange: (val)=>parvane.gustatus=val).expand(),
            ]
          ),
          Row(
            children: [
              GridTextField(hint: 'تلفن', notempty: true, controller: _gutel, readonly: this.parvane.register).expand(),      
              GridTextField(hint: 'فکس', notempty: true, controller: _gufax, readonly: this.parvane.register).expand(),      
              GridTextField(hint: 'محل استقرار', notempty: true, controller: _guesteghrarplace, readonly: this.parvane.register).expand(),      
            ],
          ),
          Row(
            children: [
              GridTextField(hint: 'عنوان تابلو', notempty: true, controller: _gusigntitle, readonly: this.parvane.register).expand(),      
              GridTextField(hint: 'توضیحات', controller: _gunote, readonly: this.parvane.register).expand(),      
            ]
          ),
        ],
      );
    }

    Widget parvaneMObasher(){
      bloc.loadMobasher(context, parvane.id);
      return StreamBuilder<ParvaneMobasherModel>(
        stream: bloc.mobasherstream$,
        builder: (context, snap){
          if (snap.hasData)
            if (snap.data.status == Status.loaded)
              return Column(
                children: [
                  GridCaption(
                    obj: [
                      snap.data.rows.length == 0
                        ? MyIconButton(type: ButtonType.add, onPressed: ()=>showFormAsDialog(context: context, form: FmPeople(justcheck: true), done: (val)=>bloc.addMobasher(context, parvane.id, val)))
                        : Container(),
                      'کد ملی',
                      'نام',
                      'نام خانوادگی',
                      'نام پدر',
                      'شماره شناسنامه',
                      'شماره کارت',
                      'تاریخ کارت',
                      'تاریخ تحویل',
                      'توضیحات'
                    ],
                    endbuttons: 1,
                  ),
                  ListView.builder(
                    itemCount: snap.data.rows.length,
                    itemBuilder: (context, idx)=>MyRow(
                      children: [
                        SizedBox(width: 35),
                        '${snap.data.rows[idx].nationalid}',
                        '${snap.data.rows[idx].name}',
                        '${snap.data.rows[idx].family}',
                        '${snap.data.rows[idx].father}',
                        '${snap.data.rows[idx].ss}',
                        '${snap.data.rows[idx].cartid}',
                        '${snap.data.rows[idx].cartdate}',
                        '${snap.data.rows[idx].deliverdate}',
                        '${snap.data.rows[idx].note}',
                        MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delMobasher(context, snap.data.rows[idx]))
                      ]
                    )
                  ).expand()
                ],
              );
            else if (snap.data.status == Status.error)
              return ErrorInGrid('${snap.data.msg}');
          return Center(child: CupertinoActivityIndicator());
        }
      );
    }

    Widget parvanePartner(){
      bloc.loadPartner(context, parvane.id);
      return Column(
        children: [
          GridCaption(
            obj: [
              MyIconButton(type: ButtonType.add, onPressed: ()=>showFormAsDialog(context: context, form: FmPeople(justcheck: true), done: (val)=>bloc.addPartner(context, ParvanePartner(parvaneid: parvane.id, peopid: val.id, name: val.name, family: val.family, nationalid: val.nationalid, edit: true, kind: 1)))),
              'کد ملی',
              'نام',
              'نام خانوادگی',
              'نوع شراکت',
              'درصد شراکت',
              'توضیحات'
            ],
            endbuttons: 1,
          ),
          StreamBuilder<ParvanePartnerModel>(
            stream: bloc.partnerstream$,
            builder: (context, snap){
              if (snap.hasData)
                if (snap.data.status == Status.loaded)
                  return ListView.builder(
                    itemCount: snap.data.rows.length,
                    itemBuilder: (context, idx)=>MyRow(
                      onDoubleTap: ()=>bloc.editPartner(snap.data.rows[idx]),
                      children: [
                        SizedBox(width: 35),
                        '${snap.data.rows[idx].nationalid}',
                        '${snap.data.rows[idx].name}',
                        '${snap.data.rows[idx].family}',
                        snap.data.rows[idx].edit
                          ? MultiChooseItem(val: snap.data.rows[idx].kind, items: [{'id': 1, 'title': 'شریک'}, {'id': 2, 'title': 'سهامدار'}], hint: 'نوع', onChange: (val)=>snap.data.rows[idx].kind=val).expand()
                          : '${snap.data.rows[idx].kindName}',
                        snap.data.rows[idx].edit
                          ? GridTextField(hint: 'درصد', initialValue: '${snap.data.rows[idx].perc}', onChange: (val)=>snap.data.rows[idx].perc=int.tryParse(val)).expand()
                          : '${snap.data.rows[idx].perc}',
                        snap.data.rows[idx].edit
                          ? GridTextField(hint: 'توضیحات', initialValue: '${snap.data.rows[idx].note}', onChange: (val)=>snap.data.rows[idx].note=val).expand()
                          : '${snap.data.rows[idx].note}',
                        snap.data.rows[idx].edit
                          ? MyIconButton(type: ButtonType.save, onPressed: ()=>bloc.savePartner(context, snap.data.rows[idx]))
                          : MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delPartner(context, snap.data.rows[idx]))
                      ]
                    )
                  );
                else if (snap.data.status == Status.error)
                  return ErrorInGrid('${snap.data.msg}');
              return Center(child: CupertinoActivityIndicator());
            }
          ).expand(),
        ],
      );
    }

    Widget parvanePersonel(){
      bloc.loadPersonel(context, parvane.id);
      return Column(
        children: [
          GridCaption(
            obj: [
              MyIconButton(type: ButtonType.add, onPressed: ()=>showFormAsDialog(context: context, form: FmPeople(justcheck: true), done: (val)=>bloc.addPersonel(context, ParvanePersonel(parvaneid: parvane.id, peopid: val.id, name: val.name, family: val.family, nationalid: val.nationalid, edit: true, kind: 1)))),
              'کد ملی',
              'نام',
              'نام خانوادگی',
              'نوع همکاری',
              'تاریخ شروع',
              'تاریخ پایان',
              'توضیحات'
            ],
            endbuttons: 1,
          ),
          StreamBuilder<ParvanePersonelModel>(
            stream: bloc.personelstream$,
            builder: (context, snap){
              if (snap.hasData)
                if (snap.data.status == Status.loaded)
                  return ListView.builder(
                    itemCount: snap.data.rows.length,
                    itemBuilder: (context, idx){
                      if (snap.data.rows[idx].edit){
                        _prsbdate.text = snap.data.rows[idx].begindate;
                        _prsedate.text = snap.data.rows[idx].enddate;
                      }
                      return MyRow(
                        onDoubleTap: ()=>bloc.editPersonel(snap.data.rows[idx]),
                        children: [
                          SizedBox(width: 35),
                          '${snap.data.rows[idx].nationalid}',
                          '${snap.data.rows[idx].name}',
                          '${snap.data.rows[idx].family}',
                          snap.data.rows[idx].edit
                            ? MultiChooseItem(val: snap.data.rows[idx].kind, items: [{'id': 1, 'title': 'تمام وقت'}, {'id': 2, 'title': 'نیمه وقت'}], hint: 'نوع', onChange: (val)=>snap.data.rows[idx].kind=val).expand()
                            : '${snap.data.rows[idx].kindname}',
                          snap.data.rows[idx].edit
                            ? GridTextField(hint: 'شروع همکاری', controller: _prsbdate, datepicker: true).expand()
                            : '${snap.data.rows[idx].begindate}',
                          snap.data.rows[idx].edit
                            ? GridTextField(hint: 'پایان همکاری', controller: _prsedate, datepicker: true).expand()
                            : '${snap.data.rows[idx].enddate}',
                          snap.data.rows[idx].edit
                            ? GridTextField(hint: 'توضیحات', initialValue: '${snap.data.rows[idx].note}', onChange: (val)=>snap.data.rows[idx].note=val).expand()
                            : '${snap.data.rows[idx].note}',
                          snap.data.rows[idx].edit
                            ? MyIconButton(type: ButtonType.save, onPressed: (){
                                snap.data.rows[idx].begindate=_prsbdate.text; 
                                snap.data.rows[idx].enddate=_prsedate.text; 
                                bloc.savePersonel(context, snap.data.rows[idx]);
                              })
                            : MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delPersonel(context, snap.data.rows[idx]))
                        ]
                      );
                    }
                  );
                else if (snap.data.status == Status.error)
                  return ErrorInGrid('${snap.data.msg}');
              return Center(child: CupertinoActivityIndicator());
            }
          ).expand(),
        ],
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.85,
        child: StreamBuilder<int>(
          stream: _tabidx.stream$,
          builder: (context, snap) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormHeader(
                  title: 'اطلاعات اعضاء / متقاضیان', 
                  btnRight: Row(
                    children: [
                      MyIconButton(type: ButtonType.save, onPressed: ()=>prcSave()),
                      SizedBox(width: 10),
                      FancySwitch(
                        truetxt: 'ثبت شده', 
                        falsetxt: 'ثبت نشده', 
                        truecolor: Colors.green, 
                        falsecolor: Colors.red.shade300,
                        onChange: (val) async {
                          if (parvane.old == 0){
                            if (!prcSave())
                              return;
                          }
                          else if (await bloc.register(context, parvane)){
                            _tabidx.setValue(_tabidx.value$);
                          }
                        }, 
                        selected: this.parvane.register
                      ),
                    ],
                  ),
                ),
                TabBar(
                  tabsel: _tabidx.value$,
                  tabs: [
                    'ثبت درخواست',
                    'واحد صنفی',
                    'معرفی مباشر',
                    'معرفی شریک',
                    'معرفی پرسنل',
                  ], 
                  onTap: (i){
                    if (i < 2){
                      _tabidx.setValue(i);
                      Future.delayed(Duration(milliseconds: 100), ()=>prcSave());
                    }
                    else if (prcSave()) 
                      _tabidx.setValue(i);
                  }
                  // tabsel: _tabidx,
                  // validate: ()=>_form.currentState.validate(),
                ),
                IgnorePointer(
                  ignoring: this.parvane.register,
                  child: snap.data == 2
                    ? parvaneMObasher()
                    : snap.data == 3
                      ? parvanePartner()
                      : snap.data == 4
                        ? parvanePersonel()
                        : Form(
                            key: _form,
                            child: Stack(
                              children: [
                                Visibility(visible: snap.data==0, child: parvanePeopInfo()),
                                Visibility(visible: snap.data==1, child: parvaneGUNit()),
                              ],
                            ),
                          )
                ).expand()
              ]
            );
          }
      )
    )
  );}
}

class TabBar extends StatelessWidget {
  final List<String> tabs;
  final int tabsel;
  final Function(int) onTap;

  TabBar({@required this.tabs, @required this.tabsel, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    var _hover = Bloc<int>()..setValue(0);
    bool _hovered = false;
    return Container(
      width: double.infinity,
      child: StreamBuilder<int>(
        stream: _hover.stream$,
        builder: (context, hoverstream) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            height: 65,
            child: Row(
              children: tabs.asMap().map((i, e) => MapEntry(i, InkWell(
                onHover: (bool){_hovered = bool; _hover.setValue(i);},
                hoverColor: Colors.transparent,
                onTap: ()=>this.onTap(i),
                child: Container(
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: this.tabsel == i
                      ? Colors.blue.shade400
                      : hoverstream.data == i && _hovered
                        ? Colors.blue.shade100
                        : Colors.white
                  ),
                  child: '$e'.toLabel(color: (_hovered && hoverstream.data==i) || this.tabsel == i ? Colors.white : Colors.black).center()
                ),
              ).expand())).values.toList(),
            ),
          );
        }
      ),
    );
  }
}









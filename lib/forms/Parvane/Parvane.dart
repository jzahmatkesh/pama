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
                            MyIconButton(type: ButtonType.add, hint: 'فرآیند جدید', onPressed: (){}),
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


class ParvaneInfo extends StatefulWidget {
  final Parvane parvane;
  final ParvaneBloc bloc;

  ParvaneInfo({@required this.bloc, @required this.parvane});

  @override
  _ParvaneInfoState createState() => _ParvaneInfoState();
}

class _ParvaneInfoState extends State<ParvaneInfo> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _id = TextEditingController(text: '${this.widget.parvane.id}');
    var _iranianasnaf = TextEditingController(text: '${this.widget.parvane.iranianasnaf}');
    var _guname = TextEditingController(text: '${this.widget.parvane.guname}');
    var _gubegindate = TextEditingController(text: '${this.widget.parvane.gubegindate}');
    var _gutoolsinfo = TextEditingController(text: '${this.widget.parvane.gutoolsinfo}');
    var _guensheabat = TextEditingController(text: '${this.widget.parvane.guensheabat}');
    var _gubimeshobe = TextEditingController(text: '${this.widget.parvane.gubimeshobe}');
    var _gukargahno = TextEditingController(text: '${this.widget.parvane.gukargahno}');
    var _guzirbana = TextEditingController(text: '${this.widget.parvane.guzirbana}');
    var _gutabaghat = TextEditingController(text: '${this.widget.parvane.gutabaghat}');
    var _gurent = TextEditingController(text: '${this.widget.parvane.gurent}');
    var _gudaraeicode = TextEditingController(text: '${this.widget.parvane.gudaraeicode}');
    var _guvahedmaliati = TextEditingController(text: '${this.widget.parvane.guvahedmaliati}');
    var _guparvandemaliat = TextEditingController(text: '${this.widget.parvane.guparvandemaliat}');
    var _gutel = TextEditingController(text: '${this.widget.parvane.gutel}');
    var _gufax = TextEditingController(text: '${this.widget.parvane.gufax}');
    var _guesteghrarplace = TextEditingController(text: '${this.widget.parvane.guesteghrarplace}');
    var _gusigntitle = TextEditingController(text: '${this.widget.parvane.gusigntitle}');
    var _gunote = TextEditingController(text: '${this.widget.parvane.gunote}');
    var _ecoid = TextEditingController(text: '${this.widget.parvane.ecoid}');
    var _hoghoghiname = TextEditingController(text: '${this.widget.parvane.hoghoghiname}');
    var _hoghoghishenasemeli = TextEditingController(text: '${this.widget.parvane.hoghoghishenasemeli}');
    var _hoghoghisabtno = TextEditingController(text: '${this.widget.parvane.hoghoghisabtno}');
    var _hesabno = TextEditingController(text: '${this.widget.parvane.hesabno}');
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

    final _form1 = GlobalKey<FormState>();
    final _form2 = GlobalKey<FormState>();
    final _edreqdate = TextEditingController(text: this.widget.parvane.reqdate);
    final _prsbdate = TextEditingController();
    final _prsedate = TextEditingController();
    final _edhoghoghisabtdate = TextEditingController(text: this.widget.parvane.reqdate);
    final _peopname = TextEditingController(text: this.widget.parvane.peopname);
    final _nosazicode = TextEditingController(text: this.widget.parvane.nosazicode);

    // Bloc<int> _tabidx = Bloc<int>()..setValue(1);

    void prcSave({bool save = false}){
      this.widget.parvane.reqdate = _edreqdate.text;
      this.widget.parvane.hoghoghisabtdate = _edhoghoghisabtdate.text;
      this.widget.parvane.id = _id.text.toInt();
      this.widget.parvane.iranianasnaf = _iranianasnaf.text.toInt();
      this.widget.parvane.guname = _guname.text;
      this.widget.parvane.gubegindate = _gubegindate.text;
      this.widget.parvane.gutoolsinfo = _gutoolsinfo.text;
      this.widget.parvane.guensheabat = _guensheabat.text;
      this.widget.parvane.gubimeshobe = _gubimeshobe.text;
      this.widget.parvane.gukargahno = _gukargahno.text.toInt();
      this.widget.parvane.guzirbana = _guzirbana.text.toInt();
      this.widget.parvane.gutabaghat = _gutabaghat.text.toInt();
      this.widget.parvane.gurent = _gurent.text.toDouble();
      this.widget.parvane.gudaraeicode = _gudaraeicode.text.toInt();
      this.widget.parvane.guvahedmaliati = _guvahedmaliati.text;
      this.widget.parvane.guparvandemaliat = _guparvandemaliat.text.toInt();
      this.widget.parvane.gutel = _gutel.text;
      this.widget.parvane.gufax = _gufax.text;
      this.widget.parvane.guesteghrarplace = _guesteghrarplace.text;
      this.widget.parvane.gusigntitle = _gusigntitle.text;
      this.widget.parvane.gunote = _gunote.text;
      this.widget.parvane.ecoid = _ecoid.text.toInt();
      this.widget.parvane.hoghoghiname = _hoghoghiname.text;
      this.widget.parvane.hoghoghishenasemeli = _hoghoghishenasemeli.text;
      this.widget.parvane.hoghoghisabtno = _hoghoghisabtno.text.toInt();
      this.widget.parvane.hesabno = _hesabno.text;

      if (this.widget.parvane.bank == 0){
        _tabController.index = 0;
        myAlert(context: context, title: 'مقادیر اجباری', message: 'بانک انتخاب نشده است');
      } 
      else if (this.widget.parvane.hisic == 0){
        _tabController.index = 0;
        myAlert(context: context, title: 'مقادیر اجباری', message: 'رسته انتخاب نشده است');
      }
      else if (_tabController.index==0 && _form1.currentState.validate())
        _tabController.index = 1;
      else if (_tabController.index==1 && _form2.currentState.validate())
        _tabController.index = 2;
      // if (save || widget.parvane.old == 0) && _form1.currentState != null && _form2.currentState != null)
      //   widget.bloc.saveData(context, widget.parvane);
    }

    _tabController.addListener(()=>prcSave());

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
                      widget.parvane.peopid = data.id;
                      widget.parvane.peopname = data.name+' '+data.family;
                      _peopname.text = widget.parvane.peopname;
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
              DropDownItems(val: widget.parvane.kind, items: [{'id': 1, 'title': 'حقیقی'},{'id': 2, 'title': 'مشارکت مدنی'},{'id': 3, 'title': 'مشارکت حقوقی'}], hint: 'نوع متقاضی', onChange: (val)=>widget.parvane.kind=val).expand(),
              DropDownItems(val: widget.parvane.parvandekind, items: [{'id': 1, 'title': 'عادی'},{'id': 2, 'title': 'ایثارگران'}], hint: 'نوع پرونده', onChange: (val)=>widget.parvane.parvandekind=val).expand(),
              GridTextField(hint: 'کد اقتصادی', notempty: true, controller: _ecoid).expand(),
            ]
          ),
          Row(
            children: [
              ForeignKeyField(hint: 'عنوان بانک', initialValue: {'id': this.widget.parvane.bank, 'name': this.widget.parvane.bankname}, f2key: 'Bank', onChange: (val){this.widget.parvane.bank = val['id'];this.widget.parvane.bankname = val['name'];},).expand(),
              GridTextField(hint: 'شماره حساب', notempty: true, controller: _hesabno).expand(),
              DropDownItems(val: widget.parvane.hesabkind, items: [{'id': 1, 'title': 'جاری'},{'id': 2, 'title': 'سپرده'},{'id': 3, 'title': 'قرض الحسنه'}], hint: 'نوع حساب', onChange: (val)=>widget.parvane.hesabkind=val).expand(),
            ]
          ),
          Row(
            children: [
              ForeignKeyField(hint: 'کد آیسیک', initialValue: {'hisic': this.widget.parvane.hisic, 'isic': this.widget.parvane.isic, 'name': this.widget.parvane.isicname}, f2key: 'Raste', onChange: (val){this.widget.parvane.hisic = val['hisic'];this.widget.parvane.isic = val['isic'];this.widget.parvane.isicname = val['name'];},).expand(),
              // GridTextField(hint: 'کد آیسیک', initialValue: '${this.parvane.hisic}', onChange: (val)=>parvane.hisic=int.tryParse(val)).expand(),
              DropDownItems(val: widget.parvane.hoghoghikind, items: [
                {'id': 1, 'title': 'سهام خاص'},
                {'id': 2, 'title': 'سهامی عام'},
                {'id': 3, 'title': 'تضامنی'},
                {'id': 4, 'title': 'تعاونی'},
                {'id': 5, 'title': 'مسولیت محدود'},
                {'id': 6, 'title': 'غیره'}
              ], hint: 'نوع شخصیت حقوقی', onChange: (val)=>widget.parvane.hoghoghikind=val).expand(),
              GridTextField(hint: 'عنوان شخصیت حقوقی', notempty: true, controller: _hoghoghiname).expand(),
            ]
          ),
          Row(
            children: [
              GridTextField(hint: 'شناسه ملی', notempty: true, controller: _hoghoghishenasemeli).expand(),
              GridTextField(hint: 'شماره ثبت', notempty: true, controller: _hoghoghisabtno).expand(),
              GridTextField(hint: 'تاریخ ثبت', notempty: true, controller: _edhoghoghisabtdate, datepicker: true).expand(),
              DropDownItems(val: widget.parvane.parvanekind, items: [{'id': 1, 'title': 'موقت'},{'id': 2, 'title': 'دایم'}], hint: 'نوع پروانه', onChange: (val)=>widget.parvane.parvanekind=val).expand(),
            ]
          ),
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
                      widget.parvane.gunitid = data.id;
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
              RadioButton(val: widget.parvane.gubimemakan, hint: 'بیمه مکان', onChange: (val)=>widget.parvane.gubimemakan=val),
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
              MultiChooseItem(val: widget.parvane.gustatus, items: [{'id': 1, 'title': 'مالکیت'},{'id': 2,  'title': 'سرقفلی'}], hint: 'وضعیت مالکیت', onChange: (val)=>widget.parvane.gustatus=val['id']).expand(),
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

    Widget parvaneMObasher(){
      if (widget.bloc.mobashervalue$.status != Status.loaded)
        widget.bloc.loadMobasher(context, widget.parvane.id);
      return StreamBuilder<ParvaneMobasherModel>(
        stream: widget.bloc.mobasherstream$,
        builder: (context, snap){
          if (snap.hasData)
            if (snap.data.status == Status.loaded)
              return Column(
                children: [
                  GridCaption(
                    obj: [
                      snap.data.rows.length == 0
                        ? MyIconButton(type: ButtonType.add, onPressed: ()=>showFormAsDialog(context: context, form: FmPeople(justcheck: true), done: (val)=>widget.bloc.addMobasher(context, widget.parvane.id, val)))
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
                        MyIconButton(type: ButtonType.del, onPressed: ()=>widget.bloc.delMobasher(context, snap.data.rows[idx]))
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
      if (widget.bloc.partnervalue$.status != Status.loaded)
        widget.bloc.loadPartner(context, widget.parvane.id);
      return Column(
        children: [
          GridCaption(
            obj: [
              MyIconButton(type: ButtonType.add, onPressed: ()=>showFormAsDialog(context: context, form: FmPeople(justcheck: true), done: (val)=>widget.bloc.addPartner(context, ParvanePartner(parvaneid: widget.parvane.id, peopid: val.id, name: val.name, family: val.family, nationalid: val.nationalid, edit: true, kind: 1)))),
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
            stream: widget.bloc.partnerstream$,
            builder: (context, snap){
              if (snap.hasData)
                if (snap.data.status == Status.loaded)
                  return ListView.builder(
                    itemCount: snap.data.rows.length,
                    itemBuilder: (context, idx)=>MyRow(
                      onDoubleTap: ()=>widget.bloc.editPartner(snap.data.rows[idx]),
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
                          ? MyIconButton(type: ButtonType.save, onPressed: ()=>widget.bloc.savePartner(context, snap.data.rows[idx]))
                          : MyIconButton(type: ButtonType.del, onPressed: ()=>widget.bloc.delPartner(context, snap.data.rows[idx]))
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
      // if (bloc.partnervalue$.status != Status.loaded)
      widget.bloc.loadPersonel(context, widget.parvane.id);
      return Column(
        children: [
          GridCaption(
            obj: [
              MyIconButton(type: ButtonType.add, onPressed: ()=>showFormAsDialog(context: context, form: FmPeople(justcheck: true), done: (val)=>widget.bloc.addPersonel(context, ParvanePersonel(parvaneid: widget.parvane.id, peopid: val.id, name: val.name, family: val.family, nationalid: val.nationalid, edit: true, kind: 1)))),
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
            stream: widget.bloc.personelstream$,
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
                        onDoubleTap: ()=>widget.bloc.editPersonel(snap.data.rows[idx]),
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
                                widget.bloc.savePersonel(context, snap.data.rows[idx]);
                              })
                            : MyIconButton(type: ButtonType.del, onPressed: ()=>widget.bloc.delPersonel(context, snap.data.rows[idx]))
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
        child: DefaultTabController(
          length: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(title: 'اطلاعات اعضاء / متقاضیان', btnRight: MyIconButton(type: ButtonType.other, icon: Icon(Icons.check_box_outlined, color: Colors.green,), hint: 'بعدی', onPressed: (){
                if (_tabController.index < 2)
                  prcSave(save: true);
                else
                  widget.bloc.saveData(context, widget.parvane);
              })),
              TabBar(
                controller: _tabController,
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
                controller: _tabController,
                children: [
                  Form(key: _form1, child: parvanePeopInfo()),
                  Form(key: _form2, child: parvaneGUNit()),
                  parvaneMObasher(),
                  parvanePartner(),
                  parvanePersonel()
                ]
              ).expand()
            ],
          ),
        ),
      ).setPadding(),
    );
 
  }
}

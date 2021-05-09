import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                        return Card(child: Text('$idx'));
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
    final _form = GlobalKey<FormState>();
    final _edreqdate = TextEditingController(text: this.parvane.reqdate);
    final _edhoghoghisabtdate = TextEditingController(text: this.parvane.reqdate);
    final _peopname = TextEditingController(text: this.parvane.peopname);
    

    Bloc<int> _tabidx = Bloc<int>()..setValue(1);

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
              GridTextField(hint: 'شماره ایرانیان اصناف', notempty: true, initialValue: '${parvane.iranianasnaf}', autofocus: true, onChange: (val)=>parvane.iranianasnaf=int.tryParse(val)).expand(),
              GridTextField(hint: 'تاریخ تقاضا', notempty: true, initialValue: this.parvane.reqdate, controller: _edreqdate, onChange: (val)=>parvane.reqdate=val, datepicker: true).expand(),
              GridTextField(hint: 'شماره درخواست', notempty: true, initialValue: '${this.parvane.id}', onChange: (val)=>parvane.id=int.tryParse(val)).expand(),
            ]
          ),
          Row(
            children: [
              DropDownItems(val: parvane.kind, items: [{'id': 1, 'title': 'حقیقی'},{'id': 2, 'title': 'مشارکت مدنی'},{'id': 3, 'title': 'مشارکت حقوقی'}], hint: 'نوع متقاضی', onChange: (val)=>parvane.kind=val).expand(),
              DropDownItems(val: parvane.parvandekind, items: [{'id': 1, 'title': 'عادی'},{'id': 2, 'title': 'ایثارگران'}], hint: 'نوع پرونده', onChange: (val)=>parvane.parvandekind=val).expand(),
              GridTextField(hint: 'کد اقتصادی', notempty: true, initialValue: '${this.parvane.ecoid}', onChange: (val)=>parvane.ecoid=int.tryParse(val)).expand(),
            ]
          ),
          Row(
            children: [
              ForeignKeyField(hint: 'عنوان بانک', initialValue: {'id': this.parvane.bank, 'name': this.parvane.bankname}, f2key: 'Bank', onChange: (val){this.parvane.bank = val['id'];this.parvane.bankname = val['name'];},).expand(),
              GridTextField(hint: 'شماره حساب', notempty: true, initialValue: this.parvane.hesabno, onChange: (val)=>parvane.hesabno=val).expand(),
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
              GridTextField(hint: 'عنوان شخصیت حقوقی', notempty: true, initialValue: this.parvane.hoghoghiname, onChange: (val)=>parvane.hoghoghiname=val).expand(),
            ]
          ),
          Row(
            children: [
              GridTextField(hint: 'شناسه ملی', notempty: true, initialValue: this.parvane.hoghoghishenasemeli, onChange: (val)=>parvane.hoghoghishenasemeli=val).expand(),
              GridTextField(hint: 'شماره ثبت', notempty: true, initialValue: '${this.parvane.hoghoghisabtno}', onChange: (val)=>parvane.hoghoghisabtno=int.tryParse(val)).expand(),
              GridTextField(hint: 'تاریخ ثبت', notempty: true, initialValue: this.parvane.hoghoghisabtdate, controller: _edhoghoghisabtdate, onChange: (val)=>parvane.hoghoghisabtdate=val, datepicker: true).expand(),
              DropDownItems(val: parvane.parvanekind, items: [{'id': 1, 'title': 'موقت'},{'id': 2, 'title': 'دایم'}], hint: 'نوع پروانه', onChange: (val)=>parvane.parvanekind=val).expand(),
            ]
          ),
        ],
      );
    }

    Widget stepTwo(){
      return Column(
        children: [
        ],
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Form(
        key: _form,
        child: Container(
          width: screenWidth(context) * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(title: 'اطلاعات اعضاء / متقاضیان', btnRight: MyIconButton(type: ButtonType.other, icon: Icon(Icons.check_box_outlined, color: Colors.green,), hint: 'بعدی', onPressed: (){
                this.parvane.reqdate = _edreqdate.text;
                this.parvane.hoghoghisabtdate = _edhoghoghisabtdate.text;
                if (_form.currentState.validate())
                  if (this.parvane.bank == 0)
                    myAlert(context: context, title: 'مقادیر اجباری', message: 'بانک انتخاب نشده است');
                  else if (this.parvane.hisic == 0)
                    myAlert(context: context, title: 'مقادیر اجباری', message: 'رسته انتخاب نشده است');
                  else
                    bloc.saveData(context, parvane);
              })),
              TabBar(tabs: [
                {'id': 1, 'title': 'ثبت درخواست'},
                {'id': 2, 'title': 'واحد صنفی'},
                {'id': 3, 'title': 'معرفی مباشر'},
                {'id': 4, 'title': 'معرفی شریک'},
                {'id': 5, 'title': 'معرفی پرسنل'},
              ], tabsel: _tabidx,).vMargin(),
              StreamBuilder<int>(
                stream: _tabidx.stream$,
                builder: (context, snap){
                  if (snap.hasData)
                    if (snap.data == 1)
                      return stepOne();
                    else if (snap.data == 2)
                      return stepTwo();
                  return Center(child: 'مرحله انتخاب نشده است'.toLabel());
                }
              ).expand()
            ],
          ),
        ).setPadding(),
      ),
    );
  }
}

class TabBar extends StatelessWidget {
  final List<Map<String, dynamic>> tabs;
  final Bloc<int> tabsel;

  TabBar({@required this.tabs, @required this.tabsel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: accentcolor(context).withOpacity(0.15),
      child: StreamBuilder<int>(
        stream: tabsel.stream$,
        builder: (context, snap) {
          if (snap.hasData)
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...tabs.map((e) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      hoverColor: snap.data == e['id'] ? Colors.green : Colors.grey.shade100,
                      onTap: ()=>tabsel.setValue(e['id']),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: snap.data == e['id'] ? Colors.green : Colors.grey.shade100,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Center(child: Text('${e['title']}', textAlign: TextAlign.center, style: TextStyle(color: snap.data == e['id'] ? Colors.white : Colors.grey),)),
                        ),
                      ),
                    ),
                    e['id'] < 5 
                      ? Container(
                          height: 2,
                          width: 50,
                          color: appbarColor(context),
                        )
                      : Container()
                  ],
                )),
              ],
            ).setPadding();
          return Center(child: CupertinoActivityIndicator());
        }
      ),
    );
  }
}
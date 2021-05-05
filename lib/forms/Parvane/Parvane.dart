import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/forms/Parvane/ParvaneBloc.dart';
import 'package:pama/module/consts.dart';
import 'package:pama/module/functions.dart';

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
                if (_form.currentState.validate())
                  bloc.saveData(context, parvane);
              })),
              Row(
                children: [
                  GridTextField(hint: 'شماره ایرانیان اصناف', initialValue: '${parvane.iranianasnaf}', onChange: (val)=>parvane.iranianasnaf=int.tryParse(val)).expand(),
                  GridTextField(hint: 'تاریخ تقاضا', initialValue: this.parvane.reqdate, onChange: (val)=>parvane.reqdate=val, datepicker: true).expand(),
                  GridTextField(hint: 'شماره درخواست', initialValue: '${this.parvane.id}', onChange: (val)=>parvane.id=int.tryParse(val)).expand(),
                ]
              ),
              Row(
                children: [
                  DropDownItems(val: parvane.kind, items: [{'id': 1, 'title': 'حقیقی'},{'id': 2, 'title': 'مشارکت مدنی'},{'id': 3, 'title': 'مشارکت حقوقی'}], hint: 'نوع متقاضی', onChange: (val)=>parvane.kind=val).expand(),
                  DropDownItems(val: parvane.parvandekind, items: [{'id': 1, 'title': 'ایثارگران'},{'id': 2, 'title': 'عادی'}], hint: 'نوع پرونده', onChange: (val)=>parvane.parvandekind=val).expand(),
                  GridTextField(hint: 'کد اقتصادی', initialValue: '${this.parvane.ecoid}', onChange: (val)=>parvane.ecoid=int.tryParse(val)).expand(),
                ]
              ),
              Row(
                children: [
                  GridTextField(hint: 'عنوان بانک', initialValue: '${this.parvane.bank}', onChange: (val)=>parvane.bank=int.tryParse(val)).expand(),
                  GridTextField(hint: 'شماره حساب', initialValue: this.parvane.hesabno, onChange: (val)=>parvane.hesabno=val).expand(),
                  DropDownItems(val: parvane.hesabkind, items: [{'id': 1, 'title': 'جاری'},{'id': 2, 'title': 'سپرده'},{'id': 3, 'title': 'قرض الحسنه'}], hint: 'نوع حساب', onChange: (val)=>parvane.hesabkind=val).expand(),
                ]
              ),
              Row(
                children: [
                  GridTextField(hint: 'کد آیسیک', initialValue: '${this.parvane.hisic}', onChange: (val)=>parvane.hisic=int.tryParse(val)).expand(),
                  DropDownItems(val: parvane.hoghoghikind, items: [
                    {'id': 1, 'title': 'سهام خاص'},
                    {'id': 2, 'title': 'سهامی عام'},
                    {'id': 3, 'title': 'تضامنی'},
                    {'id': 4, 'title': 'تعاونی'},
                    {'id': 5, 'title': 'مسولیت محدود'},
                    {'id': 6, 'title': 'غیره'}
                  ], hint: 'نوع شخصیت حقوقی', onChange: (val)=>parvane.hoghoghikind=val).expand(),
                  GridTextField(hint: 'عنوان شخصیت حقوقی', initialValue: this.parvane.hoghoghiname, onChange: (val)=>parvane.hoghoghiname=val).expand(),
                ]
              ),
              Row(
                children: [
                  GridTextField(hint: 'شناسه ملی', initialValue: this.parvane.hoghoghishenasemeli, onChange: (val)=>parvane.hoghoghishenasemeli=val).expand(),
                  GridTextField(hint: 'شماره ثبت', initialValue: '${this.parvane.hoghoghisabtno}', onChange: (val)=>parvane.hoghoghisabtno=int.tryParse(val)).expand(),
                  GridTextField(hint: 'تاریخ ثبت', initialValue: this.parvane.hoghoghisabtdate, onChange: (val)=>parvane.hoghoghisabtdate=val, datepicker: true).expand(),
                  DropDownItems(val: parvane.parvanekind, items: [{'id': 1, 'title': 'موقت'},{'id': 2, 'title': 'دایم'}], hint: 'نوع پروانه', onChange: (val)=>parvane.parvanekind=val).expand(),
                ]
              ),
            ],
          ),
        ).setPadding(),
      ),
    );
  }
}
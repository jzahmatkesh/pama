import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import '../AddInfo/AddInfoData.dart';
import '../Attach/Attach.dart';
import 'GovBloc.dart';

class FmGov extends StatelessWidget {
  const FmGov({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GovBloc _govBloc = GovBloc()..loadData(context);

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Column(
        children: [
          FormHeader(
            title: 'سازمان ها و دستگاه های دولتی', 
            btnRight: MyIconButton(type: ButtonType.add, onPressed: () => showFormAsDialog(context: context, form: FmEditGov(govbloc: _govBloc, gov: new Gov(id: 0)))), 
            btnLeft: MyIconButton(type: ButtonType.reload, onPressed:()=>_govBloc.loadData(context))
          ),
          GridCaption(obj: ['عنوان سازمان', '', 'رابط', 'شماره همراه', 'تلفن', 'کد پستی', 'آدرس', 'توضیحات','']),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: StreamBuilder(
                stream: _govBloc.govStream$,
                builder: (BuildContext context, AsyncSnapshot<GovModel> snapshot){
                  if (snapshot.hasData)
                    if (snapshot.data.status == Status.error)
                      return ErrorInGrid(snapshot.data.msg);
                    else if (snapshot.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snapshot.data.rows.length,
                        itemBuilder: (context, idx){
                          Gov gov = snapshot.data.rows[idx];
                          return Card(
                            color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                            child: GestureDetector(
                              onDoubleTap: () => showFormAsDialog(context: context, form: FmEditGov(govbloc: _govBloc, gov: gov,)),
                              child: Row(
                                children: [
                                  SizedBox(width: 5.0,),
                                  Expanded(flex: 2, child: Text(gov.name)),
                                  Expanded(child: Text(gov.family)),
                                  Expanded(child: Text(gov.mobile)),
                                  Expanded(child: Text(gov.tel)),
                                  Expanded(child: Text(gov.post)),
                                  Expanded(child: Text(gov.address)),
                                  Expanded(child: Text(gov.note)),
                                  MyIconButton(type: ButtonType.attach, onPressed: () => showFormAsDialog(context: context, form: FmAttach(title: 'فایلهای ضمیمه ${gov.name}', tag: 'Gov', id1: gov.id))),
                                  MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.list_bullet), hint: 'اطلاعات تکمیلی', onPressed: ()=>showFormAsDialog(context: context, form: FmAddInfoData(title: 'اطلاعات تکمیلی ${gov.name}', url: 'Gov/AddInfo', header: {'govid': gov.id.toString()}))),
                                  MyIconButton(type: ButtonType.del, onPressed: () => _govBloc.delGov(context, gov)),
                                ],
                              ),
                            ),
                          );
                        });
                  return Center(child: CupertinoActivityIndicator(),);
                }
              ),
            ),
          )
        ],
      )
    );
  }
}

class FmEditGov extends StatelessWidget {
  const FmEditGov({Key key, this.govbloc, this.gov}) : super(key: key);

  final GovBloc govbloc;
  final Gov gov;

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.45,
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(title: '${gov.name ?? 'تعریف سازمان'}', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){if (_formkey.currentState.validate()) govbloc.saveGov(context, gov);})),
              SizedBox(height: 10.0,),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'عنوان سازمان', initialValue: gov.name ?? '', notempty: true, onChange: (val) => gov.name=val)),
                  Expanded(child: GridTextField(hint: 'رابط', initialValue: gov.family ?? '', notempty: true, onChange: (val) => gov.family=val)),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'شماره همراه', initialValue: gov.mobile ?? '', onChange: (val) => gov.mobile=val)),
                  Expanded(child: GridTextField(hint: 'تلفن', initialValue: gov.tel ?? '', onChange: (val) => gov.tel=val)),
                  Expanded(child: GridTextField(hint: 'کد پستی', initialValue: gov.post ?? '', onChange: (val) => gov.post=val)),
                ],
              ),
              SizedBox(height: 10.0,),
              GridTextField(hint: 'آدرس', initialValue: gov.address ?? '', onChange: (val) => gov.address=val),
              SizedBox(height: 10.0,),
              GridTextField(hint: 'توضیحات', initialValue: gov.note ?? '', onChange: (val) => gov.note=val),
            ],
          ),
        ),
      ),
    );
  }
}
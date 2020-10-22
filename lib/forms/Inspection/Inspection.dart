import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/classes/Repository.dart';
import 'package:pama/forms/Inspection/InspectionBloc.dart';
import 'package:pama/forms/People/People.dart';
import 'package:pama/module/consts.dart';
import 'package:pama/module/functions.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';

class FmInspection extends StatelessWidget {
  const FmInspection({Key key, @required this.company}) : super(key: key);

  final Company company;

  @override
  Widget build(BuildContext context) {
    InspectionBloc _inspBloc = InspectionBloc()..load(context, company.id);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.75,
        child: Column(
          children: [
            FormHeader(title: 'طرح های بازرسی و نظارت ${company.name}', btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>showFormAsDialog(context: context, form: NewInspection(bloc: _inspBloc, insp: new Inspection(cmpid: company.id, id: 0))))),
            SizedBox(height: 10),
            GridCaption(obj: ['نام طرح','','موضوع','','تاریخ آغاز','تاریخ اتمام','محدوده طرح'], endbuttons: 3),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: _inspBloc.inspStream$,
                builder: (BuildContext context, AsyncSnapshot<InspectionModel> snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (context, idx){
                          return Card(
                            color: !snap.data.rows[idx].gov && !snap.data.rows[idx].compay && idx.isOdd ? appbarColor(context) : Colors.transparent,
                            child: snap.data.rows[idx].gov
                              ? Column(
                                children: [
                                  Card(
                                    color: accentcolor(context).withOpacity(0.35),
                                    child: InspRow(inspBloc: _inspBloc, insp: snap.data.rows[idx]),
                                  ),
                                  GovList(bloc: _inspBloc, insp: snap.data.rows[idx])
                                ],
                              )
                              : snap.data.rows[idx].compay
                                ? Column(
                                  children: [
                                    Card(
                                      color: accentcolor(context).withOpacity(0.35),
                                      child: InspRow(inspBloc: _inspBloc, insp: snap.data.rows[idx]),
                                    ),
                                    CompanyList(bloc: _inspBloc, insp: snap.data.rows[idx])
                                  ],
                                )
                                :  InspRow(inspBloc: _inspBloc, insp: snap.data.rows[idx]),
                          );
                        }
                      );
                  return Center(child: CupertinoActivityIndicator());
                },
              ),
            )            
          ],
        ),
      ),
    );
  }
}

class InspRow extends StatelessWidget {
  const InspRow({Key key, @required this.inspBloc, @required this.insp}) : super(key: key);

  final InspectionBloc inspBloc;
  final Inspection insp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: ()=>showFormAsDialog(context: context, form: NewInspection(bloc: inspBloc, insp: insp)),
      child: Row(
        children: [
          SizedBox(width: 5.0),
          Expanded(flex: 2, child: Text('${insp.name}')),
          Expanded(flex: 2, child: Text('${insp.topic}')),
          Expanded(child: Text('${insp.bdate}')),
          Expanded(child: Text('${insp.edate}')),
          Expanded(child: Text('${insp.range}')),
          MyIconButton(type: ButtonType.other, hint: 'سازمان های همکار', icon: Icon(CupertinoIcons.building_2_fill), onPressed: ()=>inspBloc.setMode(context, insp.id, gov: true)),
          MyIconButton(type: ButtonType.other, hint: 'اتحادیه های همکار', icon: Icon(CupertinoIcons.person_2_square_stack), onPressed: ()=>inspBloc.setMode(context, insp.id, company: true)),
          MyIconButton(type: ButtonType.del, onPressed: ()=>inspBloc.delInspection(context, insp),)
        ],
      ),
    );
  }
}

class NewInspection extends StatelessWidget {
  const NewInspection({Key key, @required this.bloc, @required this.insp}) : super(key: key);

  final InspectionBloc bloc;
  final Inspection insp;

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    var _bdate = TextEditingController(text: insp.bdate);
    var _edate= TextEditingController(text: insp.edate);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.5,
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(
                title: insp.id > 0 ? 'ویرایش طرح ${insp.name}' : 'تعریف طرح جدید', 
                btnRight: MyIconButton(
                  type: ButtonType.save, 
                  onPressed: (){
                    insp.bdate = _bdate.text;
                    insp.edate = _edate.text;
                    if (_key.currentState.validate())
                      bloc.saveInspection(context, insp);
                  }
                )
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'نام طرح', initialValue: insp.name, onChange: (val)=>insp.name=val, autofocus: true, notempty: true)),
                  Expanded(child: GridTextField(hint: 'موضوع', initialValue: insp.topic, onChange: (val)=>insp.topic=val, notempty: true)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'تاریخ آغاز', datepicker: true, controller: _bdate, notempty: true)),
                  Expanded(child: GridTextField(hint: 'تاریخ اتمام', datepicker: true, controller: _edate, notempty: true)),
                  Expanded(child: GridTextField(hint: 'محدوده طرح', initialValue: insp.range, onChange: (val)=>insp.range=val, notempty: true)),
                ],
              ),
              GridTextField(hint: 'توضیحات', initialValue: insp.note, onChange: (val)=>insp.note=val,)
            ]
          ),
        ),
      ),
    );
  }
}

class GovList extends StatelessWidget {
  const GovList({Key key, @required this.bloc, @required this.insp}) : super(key: key);

  final InspectionBloc bloc;
  final Inspection insp;

  @override
  Widget build(BuildContext context) {
    GovRepository _govRep = GovRepository();
    return Container(
      height: 300,
      child: Column(
        children: [
          SizedBox(height: 10),
          GridCaption(
            obj: [
              MyIconButton(
                type: ButtonType.add, 
                onPressed: () => showFormAsDialog(context: context, form: ForeignKeySelect(list: _govRep.load(readToken(context)), onDone: (gov){
                  bloc.saveInspectiongov(context, Inspectiongov(govid: gov.id, govname: gov.name, insid: insp.id, note: 'addnew', edit: true));
                }))
              ),
              'عنوان سازمان', 'توضیحات', ''
            ]
          ),
          Expanded(
            child: StreamBuilder(
              stream: bloc.inspgovStream$,
              builder: (BuildContext context, AsyncSnapshot<InspectiongovModel> snap){
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid(snap.data.msg);
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        var _gov = snap.data.rows[idx];
                        return Card(
                          child: GestureDetector(
                            onDoubleTap: ()=>bloc.editModeInspectionGov(_gov),
                            child: Row(
                              children: [
                                SizedBox(width: 10.0,),
                                Expanded(child: Text(_gov.govname)),
                                Expanded(child: _gov.edit 
                                  ? GridTextField(hint: 'توضیحات', initialValue: _gov.note, onChange: (val)=>_gov.note=val, autofocus: true) 
                                  : Text(_gov.note)),
                                _gov.edit
                                  ? MyIconButton(type: ButtonType.save, onPressed: ()=>bloc.saveInspectiongov(context, _gov))
                                  : MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delInspectiongov(context, _gov))
                              ],
                            ),
                          )
                        );
                      }
                    );
                return Center(child: CupertinoActivityIndicator());
              },
            ),
          )
        ],
      ),
    );
  }
}

class CompanyList extends StatelessWidget {
  const CompanyList({Key key, @required this.bloc, @required this.insp}) : super(key: key);

  final InspectionBloc bloc;
  final Inspection insp;

  @override
  Widget build(BuildContext context) {
    CompanyRepository _comRep = CompanyRepository();
    return Container(
      height: 500,
      child: Column(
        children: [
          GridCaption(
            obj: [
              MyIconButton(
                type: ButtonType.add, 
                onPressed: () => showFormAsDialog(context: context, form: ForeignKeySelect(list: _comRep.loadCompanys(readToken(context)), onDone: (com){
                  bloc.saveInspectioncompany(context, Inspectioncompany(cmpid: com.id, cmpname: com.name, insid: insp.id, note: 'addnew', edit: true));
                }))
              ),
              'عنوان اتحادیه', 'توضیحات', ''
            ],
            endbuttons: 3,
          ),
          Expanded(
            child: StreamBuilder(
              stream: bloc.inspcompanyStream$,
              builder: (BuildContext context, AsyncSnapshot<InspectioncompanyModel> snap) {
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid(snap.data.msg);
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        Inspectioncompany _cmp = snap.data.rows[idx];
                        return Card(
                          child: GestureDetector(
                            onDoubleTap: ()=>bloc.editModeInspectionCompany(context,snap.data.rows[idx], edit: true),
                            child: _cmp.peop
                              ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(child: InspectionCompanyRow(cmp: _cmp, bloc: bloc)),
                                  FormHeader(
                                    title: 'فهرست کارشناسان', 
                                    btnRight: MyIconButton(
                                      type: ButtonType.add, 
                                      onPressed: ()=>showFormAsDialog(context: context, form: FmPeople(justcheck: true, cmpid: _cmp.cmpid), done: (obj){
                                        if (obj is People)
                                          bloc.manageCompanyPeop(context, Inspectioncompanypeop(insid: _cmp.insid, cmpid: _cmp.cmpid, peopid: obj.id, peopfamily: '${obj.name} ${obj.family}', kind: 2), save: true);
                                      })
                                    ), 
                                    btnLeft: MyIconButton(
                                      type: ButtonType.exit, 
                                      onPressed: ()=>bloc.editModeInspectionCompany(context, _cmp, peop: true)
                                    )
                                  ),
                                  CompanyPeop(bloc: bloc, cmp: _cmp, kind: 2),
                                  SizedBox(height: 10.0),
                                ],
                              )
                              : _cmp.emp
                                ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(child: InspectionCompanyRow(cmp: _cmp, bloc: bloc)),
                                    SizedBox(height: 10.0),
                                    CompanyPeop(bloc: bloc, cmp: _cmp, kind: 1),
                                    SizedBox(height: 10.0),
                                  ],
                                )
                                : InspectionCompanyRow(cmp: _cmp, bloc: bloc),
                          ),
                        );
                      }
                    );
                return Center(child: CupertinoActivityIndicator());
              }
            ),
          )
        ],
      ),
    );
  }
}

class InspectionCompanyRow extends StatelessWidget {
  const InspectionCompanyRow({Key key, @required this.cmp, @required this.bloc}) : super(key: key);

  final Inspectioncompany cmp;
  final InspectionBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(this.cmp.cmpname)),
        Expanded(flex: 2, child: this.cmp.edit 
          ? GridTextField(hint: 'توضیحات', initialValue: this.cmp.note, onChange: (val)=>this.cmp.note=val, autofocus: true)
          : Text(this.cmp.note)),
        this.cmp.edit ? Container() : MyIconButton(type: ButtonType.other, hint: 'فهرست کارشناسان', icon: Icon(CupertinoIcons.person_2_alt), onPressed: ()=>bloc.editModeInspectionCompany(context, cmp, peop: true)),
        this.cmp.edit ? Container() : MyIconButton(type: ButtonType.other, hint: 'فهرست کارکنان', icon: Icon(CupertinoIcons.person_3_fill), onPressed: ()=>bloc.editModeInspectionCompany(context, cmp, emp: true)),
        this.cmp.edit 
          ? MyIconButton(type: ButtonType.save, onPressed: ()=>bloc.saveInspectioncompany(context, this.cmp)) 
          : MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delInspectioncompany(context, this.cmp))
      ],
    );
  }
}

class CompanyPeop extends StatelessWidget {
  const CompanyPeop({Key key, @required this.bloc, @required this.cmp, @required this.kind}) : super(key: key);

  final InspectionBloc bloc;
  final Inspectioncompany cmp;
  final int kind;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.inspcmppeopStream$,
      builder: (BuildContext context, AsyncSnapshot<InspectioncompanypeopModel> snap){
        if (snap.hasData)
          if (snap.data.status == Status.error)
            return ErrorInGrid(snap.data.msg);
          else if (snap.data.status == Status.loaded)
            return Wrap(
              children: snap.data.rows.map((e) => UserTile(
                id: e.peopid, 
                title: e.peopfamily, 
                subtitle: '', 
                imgtype: 'people', 
                color: Colors.green,
                selected: (e.kind==2 || e.valid), 
                onTap: () => bloc.manageCompanyPeop(context, e)
              )).toList()
            );
        return Center(child: CupertinoActivityIndicator());
      },
    );
  }
}


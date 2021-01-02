import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/forms/AddInfo/AddInfoData.dart';
import 'package:provider/provider.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import '../../module/theme-Manager.dart';
import '../People/People.dart';
import 'CommitteeBloc.dart';

class FmCommittee extends StatelessWidget {
  const FmCommittee({Key key, @required this.company}) : super(key: key);

  final Company company;

  @override
  Widget build(BuildContext context) {
    CommitteeBloc _committeeBloc = CommitteeBloc()..load(context, company.id);

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.85,
        child: Column(
          children: [
            FormHeader(title: 'کمیسیون و جلسات ${company.name}', btnRight: MyIconButton(type: ButtonType.add, onPressed: (){context.read<ThemeManager>().setCompany(company.id);_committeeBloc.newCommittee(context, company.id);})),
            GridCaption(obj: ['نوع', 'عنوان', 'کارشناس'], endbuttons: 3,),
            Expanded(
              child: StreamBuilder(
                stream: _committeeBloc.committeeStream$,
                builder: (BuildContext context, AsyncSnapshot<CommitteeModel> snapshot){
                  if (snapshot.hasData)
                    if (snapshot.data.status == Status.error)
                      return ErrorInGrid(snapshot.data.msg);
                    else if (snapshot.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snapshot.data.rows.length,
                        itemBuilder: (BuildContext context, int idx){
                          Committee _com = snapshot.data.rows[idx];
                          return Card(
                            color: idx.isOdd && !_com.edit && !_com.member && !_com.detail ? appbarColor(context) : Colors.transparent,
                            child: _com.edit 
                              ? EditCommittee(committeeBloc: _committeeBloc, committee: _com, cmpid: company.id,) 
                              : _com.member 
                                ? PnCommitteeMember(com: _com, committeeBloc: _committeeBloc, company: company)
                                : _com.detail
                                  ? PnCommitteeDetail(com: _com, committeeBloc: _committeeBloc, company: company)
                                  : CommitteeRow(company: company, com: _com, committeeBloc: _committeeBloc),
                          );
                        }
                      );
                  return Center(child: CupertinoActivityIndicator());
                }
              )
            )
          ],
        ),
      )
    );
  }
}

class PnCommitteeMember extends StatelessWidget {
  const PnCommitteeMember({Key key,@required this.com,@required this.committeeBloc,@required this.company,}) : super(key: key);

  final Committee com;
  final CommitteeBloc committeeBloc;
  final Company company;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: accentcolor(context).withOpacity(0.5),
          child: CommitteeRow(company: company, com: com, committeeBloc: committeeBloc)
        ),
        SizedBox(height: 10.0,),
        GridCaption(
          obj: [
            MyIconButton(
              type: ButtonType.add, 
              onPressed: () => showFormAsDialog(context: context, form: FmPeople(nationalid: "", justcheck: true,), done: (dynamic data){
                if (data is People)
                  committeeBloc.addMember(context, company.id, com.id, data.id, data.name, data.family);
              })
            ),
            'نام و نام خانوادگی', 'سمت'
          ]
        ),
        Container(
          height: 350.0,
          child: StreamBuilder(
            stream: committeeBloc.committeeMemberStream$,
            builder: (BuildContext context, AsyncSnapshot<CommitteeMemberModel> snapshot){
              if (snapshot.hasData)
                if (snapshot.data.status == Status.error)
                  return ErrorInGrid(snapshot.data.msg);
                else if (snapshot.data.status == Status.loaded)
                  return ListView.builder(
                    itemCount: snapshot.data.rows.length,
                    itemBuilder: (BuildContext context,int idx){
                      CommitteeMember _mem = snapshot.data.rows[idx];
                      return Card(
                        color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                        child: GestureDetector(
                          onDoubleTap: ()=> committeeBloc.addMember(context, com.id, _mem.cmtid, _mem.peopid, _mem.name, _mem.family),
                          child: Row(
                            children: [
                              PeoplePic(id: _mem.peopid),
                              SizedBox(width: 10.0,),
                              Expanded(child: Text('${_mem.name} ${_mem.family}')),
                              Expanded(child: _mem.edit 
                                ? MultiChooseItem(val: _mem.semat, items: [{'id': 1, 'title': 'رییس'},{'id': 2, 'title': 'نایب رییس'},{'id': 3, 'title': 'منشی'},{'id': 4, 'title': 'عضو'}], hint: 'سمت', onChange: (val)=> committeeBloc.changeSemat(_mem, val))
                                : Text('${_mem.sematName()}')),
                              MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.list_bullet), hint: 'اطلاعات تکمیلی', onPressed: () => showFormAsDialog(context: context, form: FmAddInfoData(url: 'Cmp_Committee/Member/AddInfo', title: 'اطلاعات تکمیلی ${_mem.name} ${_mem.family}', header: {'cmpid': company.id.toString(), 'cmtid': this.com.id.toString(), 'peopid': _mem.peopid.toString()}))),
                              _mem.edit
                                ? MyIconButton(type: ButtonType.save, onPressed: ()=> committeeBloc.saveMember(context, _mem))
                                : MyIconButton(type: ButtonType.del, onPressed: ()=> committeeBloc.delMember(context, _mem))
                            ],
                          ),
                        ),
                      );
                    }
                  );
              return Center(child: CupertinoActivityIndicator());
            },
          ),
        ),
        SizedBox(height: 10.0,),
      ],
    );
  }
}

class CommitteeRow extends StatelessWidget {
  const CommitteeRow({Key key,@required this.company,@required this.com,@required this.committeeBloc,}) : super(key: key);

  final Company company;
  final Committee com;
  final CommitteeBloc committeeBloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){context.read<ThemeManager>().setCompany(com.cmpid); committeeBloc.editMode(com);},
      child: Row(
        children: [
          SizedBox(width: 5.0,),
          Expanded(child: Text('${this.com.kindName()}')),
          Expanded(child: Text('${this.com.name}')),
          PeoplePic(id: this.com.empid),
          SizedBox(width: 5.0,),
          Expanded(child: Text('${this.com.empfamily}')),
          this.com.kind > 2  
            ? MyIconButton(type: ButtonType.other, hint: 'اعضای کمیسیون', icon: Icon(Icons.emoji_people_outlined), onPressed: (){committeeBloc.editMode(com, member: true);committeeBloc.loadMember(context, com.cmpid, com.id);})
            : Container(width: 46.0,),
          MyIconButton(type: ButtonType.other, hint: 'فهرست جلسات/کمیسیون ها', icon: Icon(CupertinoIcons.list_bullet_below_rectangle), onPressed: (){committeeBloc.editMode(com, detail: true);committeeBloc.loadDetail(context, com.cmpid, com.id);}),
          MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.list_bullet), hint: 'اطلاعات تکمیلی', onPressed: () => showFormAsDialog(context: context, form: FmAddInfoData(url: 'Cmp_Committee/AddInfo', title: 'اطلاعات تکمیلی ${this.com.name}', header: {'cmpid': company.id.toString(), 'cmtid': this.com.id.toString()}))),
          MyIconButton(type: ButtonType.del, onPressed: () => this.committeeBloc.delCommittee(context, this.com)),
        ],
      ),
    );
  }
}

class EditCommittee extends StatelessWidget {
  const EditCommittee({Key key, @required this.committeeBloc, @required this.committee, @required this.cmpid}) : super(key: key);

  final CommitteeBloc committeeBloc;
  final Committee committee;
  final int cmpid;

  @override
  Widget build(BuildContext context) {
    committeeBloc.setnewCommitteeKind(committee.kind);
    return Row(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: committeeBloc.newCommitteeKindStream$,
            builder: (BuildContext contex, AsyncSnapshot<int> snapshot){
              return MultiChooseItem(
                hint: 'نوع', 
                val: snapshot.hasData ? snapshot.data : committee.kind, 
                onChange: (val){committee.kind=val; committeeBloc.setnewCommitteeKind(val);},
                items: this.cmpid == 1 
                  ? [{'id': 1, 'title': 'جلسه درون سازمانی'},{'id': 2, 'title': 'جلسه برون سازمانی'},{'id': 3, 'title': 'کمیسیون بازرسی و رسیدگی به شکایات'},{'id': 4, 'title': 'کمیسیون حل اختلاف و تشخیص'},{'id': 5, 'title': 'کمیسیون امور اقتصادی'},{'id': 6, 'title': 'کمیسیون آموزش و پژوهش'},{'id': 7, 'title': 'کمیسیون بودجه و تشکیلات'},{'id': 8, 'title': 'کمیسیون امور اجتماعی و فرهنگی'}]
                  : [{'id': 1, 'title': 'جلسه درون سازمانی'},{'id': 2, 'title': 'جلسه برون سازمانی'},{'id': 9, 'title': 'کمیسیون رسیدگی به شکایات'},{'id': 10, 'title': 'کمیسیون حل اختلاف'},{'id': 11, 'title': 'کمیسیون فنی'},{'id': 12, 'title': 'کمیسیون بازرسی واحد های صنفی'},{'id': 13, 'title': 'کمیسیون آموزش'}]
              );
            }
          )
        ),
        Expanded(child: GridTextField(hint: 'عنوان', initialValue: committee.name, onChange: (val) => committee.name=val, autofocus: true)),
        Expanded(child: ForeignKeyField(f2key: 'Employee', hint: 'کارشناس', initialValue: {'id': committee.empid, 'name': committee.empfamily}, onChange: (val){if (val != null){committee.empid = val['id']; committee.empfamily = val['name'];}})),
        MyIconButton(type: ButtonType.save, hint: 'ذخیره', icon: Icon(Icons.save, color: Colors.green,), onPressed: () => committeeBloc.saveCommittee(context, committee),)
      ],
    );
  }
}

class PnCommitteeDetail extends StatelessWidget {
  const PnCommitteeDetail({Key key,@required this.com,@required this.committeeBloc,@required this.company,}) : super(key: key);

  final Committee com;
  final CommitteeBloc committeeBloc;
  final Company company;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: accentcolor(context).withOpacity(0.5),
          child: CommitteeRow(company: company, com: com, committeeBloc: committeeBloc)
        ),
        SizedBox(height: 10.0,),
        GridCaption(
          obj: [
            MyIconButton(type: ButtonType.add, onPressed: (){context.read<ThemeManager>().setCompany(company.id); showFormAsDialog(context: context, form: EditDetail(commiteeBloc: committeeBloc, com: com, dtl: new CommitteeDetail(cmpid: com.cmpid, cmtid: com.id, id: 0, empid: com.empid, empfamily: com.empfamily)));}),
            'موضوع','تاریخ برگذاری','زمان برگذاری','کارشناس','توضیحات'
          ],
          endbuttons: 4,
        ),
        Container(
          height: 500.0,
          child: StreamBuilder(
            stream: committeeBloc.committeeDetailStream$,
            builder: (BuildContext context, AsyncSnapshot<CommitteeDetailModel> snapshot){
              if (snapshot.hasData)
                if (snapshot.data.status == Status.error)
                  return ErrorInGrid(snapshot.data.msg);
                else if (snapshot.data.status == Status.loaded)
                  return ListView.builder(
                    itemCount: snapshot.data.rows.length,
                    itemBuilder: (BuildContext context,int idx){
                      CommitteeDetail _dtl = snapshot.data.rows[idx];
                      return Card(
                        color: idx.isOdd && !_dtl.absent && !_dtl.mosavabat ? appbarColor(context) : Colors.transparent,
                        child: _dtl.absent 
                          ? DetailAbsent(committee: com, dtl: _dtl, committeeBloc: committeeBloc)
                          : _dtl.mosavabat
                            ? DetailMosavabat(company: company, committee: this.com, dtl: _dtl, committeeBloc: committeeBloc)
                            : CommitteeDetailRow(committee: com, dtl: _dtl, committeeBloc: committeeBloc),
                      );
                    }
                  );
              return Center(child: CupertinoActivityIndicator());
            },
          ),
        ),
        SizedBox(height: 10.0,),
      ],
    );
  }
}

class DetailAbsent extends StatelessWidget {
  const DetailAbsent({Key key,@required this.committee,@required this.dtl,@required this.committeeBloc,}) : super(key: key);

  final Committee committee;
  final CommitteeDetail dtl;
  final CommitteeBloc committeeBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: accentcolor(context).withOpacity(0.35), 
            child: CommitteeDetailRow(committee: this.committee, dtl: this.dtl, committeeBloc: this.committeeBloc)
          ),
          SizedBox(height: 15.0),
          Expanded(
            child: StreamBuilder(
              stream: committeeBloc.committeeDetailAbsentStream$,
              builder: (BuildContext context, AsyncSnapshot<CommitteeDetailAbsentModel> snapshot){
                if (snapshot.hasData)
                  if (snapshot.data.status == Status.error)
                    return ErrorInGrid(snapshot.data.msg);
                  else if (snapshot.data.status == Status.loaded)
                    return Wrap(
                      children: snapshot.data.rows.map((e) => UserTile(id: e.peopid, title: e.peopfamily, subtitle: e.detailid>0 ? '${e.semat} - غایب' : '${e.semat} - حاضر', imgtype: 'people', selected: true, color: e.detailid > 0 ? Colors.red : Colors.green, onTap: (){
                        if (e.detailid > 0)
                          committeeBloc.delDetailAbsent(context, e);
                        else  
                          committeeBloc.addDetailAbsent(context, e, dtl.id);
                      })).toList(),
                    );
                return Center(child: CupertinoActivityIndicator());
              }
            )
          ),
        ]
      ),
    );
  }
}

class CommitteeDetailRow extends StatelessWidget {
  const CommitteeDetailRow({Key key,@required this.committee, @required this.dtl,@required this.committeeBloc,}) : super(key: key);

  final CommitteeDetail dtl;
  final Committee committee;
  final CommitteeBloc committeeBloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){context.read<ThemeManager>().setCompany(dtl.cmpid); showFormAsDialog(context: context, form: EditDetail(commiteeBloc: committeeBloc, com: committee, dtl: dtl));},
      child: Row(
        children: [
          SizedBox(width: 10.0,),
          Expanded(child: Text('${dtl.title}')),
          Expanded(child: Text('${dtl.date}')),
          Expanded(child: Text('${dtl.time}')),
          PeoplePic(id: dtl.empid),
          SizedBox(width: 5,),
          Expanded(child: Text('${dtl.empfamily}')),
          Expanded(child: Text('${dtl.note}')),
          committee.kind > 2
            ? MyIconButton(type: ButtonType.other, hint: 'غایبین کمیسیون', icon: Icon(CupertinoIcons.person_badge_minus_fill), onPressed: () => committeeBloc.setDetailMode(context, dtl, absend: true))
            : Container(),
          committee.kind <= 2
            ? MyIconButton(type: ButtonType.other, hint: 'جزییات مصوبات جلسه', icon: Icon(CupertinoIcons.square_stack), onPressed: () => committeeBloc.setDetailMode(context, dtl, mosavabat: true),)
            : Container(),
          MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.list_bullet), hint: 'اطلاعات تکمیلی', onPressed: () => showFormAsDialog(context: context, form: FmAddInfoData(url: 'Cmp_Committee/Detail/AddInfo', title: 'اطلاعات تکمیلی ${dtl.title}', header: {'cmpid': dtl.cmpid.toString(), 'cmtid': dtl.cmtid.toString(), 'detailid': dtl.id.toString()}))),
          MyIconButton(type: ButtonType.del, onPressed: ()=> committeeBloc.delDetail(context, dtl),)
        ],
      ),
    );
  }
}

class EditDetail extends StatelessWidget {
  const EditDetail({Key key, @required this.commiteeBloc, @required this.com, @required this.dtl}) : super(key: key);

  final CommitteeBloc commiteeBloc;
  final CommitteeDetail dtl;
  final Committee com;

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();

    TextEditingController _eddate = TextEditingController(text: dtl.date);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.6,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(
                title: 'ویرایش اطلاعات فهرست ${com.kindName()} ${com.name}', 
                btnRight: MyIconButton(
                  type: ButtonType.save, 
                  onPressed: (){
                    if (_formkey.currentState.validate()){
                      dtl.date=_eddate.text; 
                      commiteeBloc.saveDetail(context, dtl);
                    }
                  }
                )
              ),
              SizedBox(height: 10.0,),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'موضوع', initialValue: dtl.title, onChange: (val) => dtl.title=val, autofocus: true, notempty: true,)),
                  Expanded(child: ForeignKeyField(hint: 'کارشناس', initialValue: {'id': dtl.empid, 'name': dtl.empfamily}, onChange: (val){if (val != null){dtl.empid = val['id']; dtl.empfamily = val['name'];}}, f2key: 'Employee')),
                ]
              ),
              SizedBox(height: 10.0,),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'تاریخ برگذاری', controller: _eddate, datepicker: true, notempty: true,)),
                  Expanded(child: GridTextField(hint: 'زمان برگذاری', initialValue: dtl.time, onChange: (val) => dtl.time=val, timeonly: true, notempty: true,)),
                ],
              ),
              SizedBox(height: 10.0,),
              GridTextField(hint: 'توضیحات', initialValue: dtl.note, onChange: (val) => dtl.note=val, notempty: true),
            ],
          ),
        ),
      )
    );
  }
}

class DetailMosavabat extends StatelessWidget {
  const DetailMosavabat({Key key, @required this.company, @required this.committee, @required this.committeeBloc, @required this.dtl}) : super(key: key);

  final Company company;
  final Committee committee;
  final CommitteeDetail dtl;
  final CommitteeBloc committeeBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: accentcolor(context).withOpacity(0.35),
            child: CommitteeDetailRow(committee: this.committee, dtl: dtl, committeeBloc: committeeBloc)
          ),
          SizedBox(height: 15.0),
          GridCaption(
            obj: [
              MyIconButton(
                type: ButtonType.add, 
                onPressed: (){
                  context.read<ThemeManager>().setCompany(dtl.cmpid); 
                  showFormAsDialog(context: context, form: PnEditMosavabat(committeeBloc: this.committeeBloc, mos: CommitteeDetailMosavabat(cmpid: committee.cmpid, cmtid: committee.id, detailid: dtl.id, id: 0, empid: 0, mcmpid: company.id, mcmpname: company.name)));
                }
              ), 'عنوان','واحد پیگیری','مسئول پیگیری', 'اتحادیه مرتبط'
            ], 
            endbuttons: 2
          ),
          Expanded(
            child: StreamBuilder(
              stream: committeeBloc.committeeDetailMosavabatStream$,
              builder: (BuildContext context, AsyncSnapshot<CommitteeDetailMosavabatModel> snapshot){
                if (snapshot.hasData)
                  if (snapshot.data.status == Status.error)
                    return ErrorInGrid(snapshot.data.msg);
                  else if (snapshot.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snapshot.data.rows.length,
                      itemBuilder: (context, idx){
                        CommitteeDetailMosavabat _mos = snapshot.data.rows[idx];
                        return Card(
                          color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                          child: GestureDetector(
                            onDoubleTap: (){context.read<ThemeManager>().setCompany(dtl.cmpid); showFormAsDialog(context: context, form: PnEditMosavabat(committeeBloc: this.committeeBloc, mos: _mos));},
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Expanded(child: Text('${_mos.title}')),
                                Expanded(child: Text('${_mos.vahed}')),
                                PeoplePic(id: _mos.empid),
                                SizedBox(width: 5.0,),
                                Expanded(child: Text('${_mos.empfamily}')),
                                Expanded(child: Text('${_mos.mcmpname}')),
                                MyIconButton(type: ButtonType.del, onPressed: ()=>committeeBloc.delDetailMosavabat(context, _mos),)
                              ],
                            ),
                          ),
                        );
                      }
                    );
                return Center(child: CupertinoActivityIndicator());
              }
            )
          ),
        ]
      ),
    );
  }
}

class PnEditMosavabat extends StatelessWidget {
  const PnEditMosavabat({Key key, @required this.committeeBloc, @required this.mos}) : super(key: key);

  final CommitteeBloc committeeBloc;
  final CommitteeDetailMosavabat mos;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.45,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(title: 'تعریف/ویرایش مصوبات جلسات/کمیسیون ها', btnRight: MyIconButton(type: ButtonType.save, onPressed: () => committeeBloc.saveDetailMosavabat(context, mos))),
            SizedBox(height: 10.0,),
            Row(
              children: [
                Expanded(child: GridTextField(hint: 'عنوان', initialValue: mos.title, onChange: (val)=> mos.title=val, autofocus: true)),
                Expanded(child: GridTextField(hint: 'واحد پیگیری', initialValue: mos.vahed, onChange: (val)=> mos.vahed=val)),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: [
                Expanded(child: ForeignKeyField(hint: 'مسئول پیگیری', f2key: 'Employee', initialValue: {'id': mos.empid, 'name': mos.empfamily}, onChange: (val){if (val != null){mos.empid = val['id']; mos.empfamily = val['name'];}})),
                Expanded(child: ForeignKeyField(hint: 'اتحادیه مرتبط', f2key: 'Company', initialValue: {'id': mos.mcmpid, 'name': mos.mcmpname}, onChange: (val){if (val != null){mos.mcmpid = val['id']; mos.mcmpname = val['name'];}})),
              ],
            ),
            SizedBox(height: 10.0,),
          ]
        ),
      )
    );
  }
}






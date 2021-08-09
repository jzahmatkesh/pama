import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pama/classes/Repository.dart';
import '../../classes/classes.dart';
import 'FinishParvaneProcess.dart';
import 'ParvaneProcessBloc.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';

class NewParvaneProcess extends StatelessWidget {
  final int parvaneid;

  NewParvaneProcess({@required this.parvaneid});

  @override
  Widget build(BuildContext context) {
    final PPrcBloc _bloc = PPrcBloc()..loadProcess(context: context, parvaneID: this.parvaneid);
    return Container(
      width: screenWidth(context) * 0.3,      
      height: screenHeight(context) * 0.5,
      child: Directionality(
        textDirection: TextDirection.rtl,
          child: StreamBuilder<PPrcModel>(
            stream: _bloc.stream,
            builder: (context, snap) {
              if (snap.hasData){
                if (snap.data.status == Status.error)
                  return ErrorInGrid(snap.data.msg);
                if (snap.data.status == Status.loaded)
                  if (snap.data.rows.length == 0)
                    return ErrorInGrid('فرآیندی جهت انتخاب وجود ندارد', info: true);
                  else
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx)=>
                        ListTile(
                          title: Text('${snap.data.rows[idx].title}'),
                          onTap: ()=>confirmMessage(context, 'آغاز فرآیند', 'آیا مایل به آغاز فرآیند ${snap.data.rows[idx].title} می باشید؟', yesclick: () async{
                            Navigator.pop(context);
                            if (await _bloc.newprocess(context, this.parvaneid, snap.data.rows[idx].id))
                              Navigator.pop(context, true);
                          }),
                        ).setPadding().card()
                    );
              }
              return Center(child: CupertinoActivityIndicator());
            }
          )
      ),
    );
  }
}

class FmParvaneProcess extends StatelessWidget {
  final Parvane parvane;
  final int processid;
  const FmParvaneProcess({ Key key, @required this.parvane, this.processid = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PPrcBloc _bloc = PPrcBloc()..loadParvaneProcess(context: context, parvaneID: this.parvane.id);
    return Container(
      width: screenWidth(context) * 0.95,
      height: screenHeight(context) * 0.95,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            FormHeader(title: 'لیست فرآیندهای ${parvane.peopname}'),
            GridCaption(
              obj: [
                'عنوان فرآیند'.toLabel().expand(),
                'تاریخ شروع'.toLabel().expand(),
                'مدت مجاز'.toLabel().expand(),
                'تاریخ اتمام'.toLabel().expand(),
                'روزهای باقیمانده'.toLabel().expand(),
              ],
              endbuttons: 3,
            ),
            StreamBuilder<ParvaneProcessModel>(
              stream: _bloc.pprocessstream,
              builder: (context, snap){
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid('${snap.data.msg}');
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        if (snap.data.rows[idx].showSteps)
                          return Container(
                            height: screenHeight(context) * 0.70,
                            child: Column(
                              children: [
                                ParvaneProcessRow(bloc: _bloc, data: snap.data.rows[idx]),
                                SizedBox(height: 10),
                                ParvaneProcessStepDetail(bloc: _bloc, parvane: this.parvane, pprow: snap.data.rows[idx])
                              ],
                            ),
                          ).card();
                        return ParvaneProcessRow(bloc: _bloc, data: snap.data.rows[idx]);
                      }
                    );
                return Center(child: CupertinoActivityIndicator());
              }
            ).expand()
          ],
        ),
      ),
    );
  }
}

class ParvaneProcessRow extends StatelessWidget {
  final ParvaneProcess data;
  final PPrcBloc bloc;

  const ParvaneProcessRow({ Key key, @required this.bloc, @required this.data }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        '${data.title}'.toLabel().expand(),
        '${data.startdate}'.toLabel().expand(),
        '${data.length}'.toLabel().expand(),
        '${data.enddate}'.toLabel().expand(),
        '${data.dayremind} ${data.finish>=11 ? '[ رد شده با نظر بازرسی ]' : data.finish >= 10 ? '[ رد شده با نظر هیت مدیره ]' : ''}'.toLabel().expand(),
        MyIconButton(type: ButtonType.other, icon: Icon(Icons.view_sidebar_rounded, color: accentcolor(context),), hint: 'مشاهده وضعیت فرآیند', onPressed: ()=>bloc.showParvaneProcessSteps(context, data.id)),
        data.isFinished
          ? SizedBox(width: 40)
          : MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delParvaneProcess(context: context, id: data.id))
      ]
    ).card(color: data.finish == 1 ? Colors.green.shade100 : data.finish > 1 ? Colors.deepOrange.shade100 : null);
  }
}

class ParvaneProcessStepDetail extends StatelessWidget {
  final PPrcBloc bloc;
  final ParvaneProcess pprow;
  final Parvane parvane;
  const ParvaneProcessStepDetail({@required this.bloc, @required this.pprow, @required this.parvane, Key key }) : super(key: key);

  @override
  Widget build(BuildContext context){                                 
    void stepclicked(PPStep e){
      if (e.kind == 1)
        bloc.showPPStepDocument(context, pprow.id, e.id);
      if (e.kind == 2)
        bloc.showPPStepMeeting(context, pprow.id, e.id);
      if (e.kind == 3)
        bloc.showPPStepInspection(context, pprow.id, e.id);
      if (e.kind == 4)
        bloc.showPPStepIncome(context, pprow.id, e.id);
      if (e.kind == 5)
        bloc.showPPStepCourse(context, pprow.id, e.id);
      bloc.showPPStepDetail(e);     
    }

    return StreamBuilder<PPStepModel>(
      stream: bloc.ppStepstream,
      builder: (context, snap) {
        if (snap.hasData)
          if (snap.data.status == Status.error)
            return ErrorInGrid('${snap.data.msg}');
          else if (snap.data.status == Status.loaded){
            PPStep _activestep;
            if (snap.data.rows.where((element) => element.show).length > 0)
              _activestep = snap.data.rows.where((element) => element.show).first;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 10),
                    ...snap.data.rows.map((e) => 
                      InkWell(
                        onTap: ()=>stepclicked(e),
                        hoverColor: accentcolor(context).withOpacity(0.25),
                        highlightColor: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: e.show ? accentcolor(context).withOpacity(0.3) : e.finish ? Colors.green.shade100 : Colors.grey.withOpacity(0.1),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              e.finish 
                                ? Icon(FontAwesome.check, color: e.show ? accentcolor(context).withOpacity(0.5) : Colors.green.shade200,)
                                : Container(),
                              SizedBox(width: 5),
                              Text('${e.kindName()}').center(),
                            ],
                          ),
                        )
                      ).hMargin().expand()).toList(),
                    Spacer(),
                    _activestep != null && _activestep.id > 0 && pprow.finish != 1
                      ? InkWell(
                          onTap: ()=>bloc.finishParvaneProcessStep(context, _activestep),
                          child: Container(
                            width: 170,
                            decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(12),
                              border: Border.all(color: Colors.black12)
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius:BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                                    color: _activestep.finish ? Colors.blueAccent.withOpacity(0.35) : appbarColor(context),
                                  ),
                                  child: Center(child: Text('ثبت شده', style: TextStyle(fontWeight: FontWeight.bold,))),
                                ).expand(),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius:BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                    color: !_activestep.finish ? Colors.red.withOpacity(0.35) : appbarColor(context),
                                  ),
                                  child: Center(child: Text('ثبت نشده', style: TextStyle(fontWeight: FontWeight.bold))),
                                ).expand()
                              ],
                            )
                          ),
                        )
                      : Container(),
                    SizedBox(width: 25)
                  ],
                ),
                Divider(),
                _activestep != null && _activestep.id > 0
                  ? Container(
                    margin: EdgeInsets.all(6),
                    padding: EdgeInsets.all(6),
                    color: appbarColor(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(18),
                          child: Row(
                            children: [
                              'تاریخ شروع مرحله: '.toLabel(bold: true),
                              _activestep.edate.toLabel(),
                            ],
                          ), 
                        ),
                        Container(
                          width: 2,
                          height: 40,
                          color: Colors.black12,
                        ),
                        Container(
                          padding: EdgeInsets.all(18),
                          child: Row(
                            children: [
                              'مدت مرحله: '.toLabel(bold: true),
                              '${_activestep.length} روز'.toLabel(),
                            ],
                          ), 
                          // onSelected: (_){}
                        ),
                        Container(
                          padding: EdgeInsets.all(18),
                          color: _activestep.remainday >= 0 ? Colors.green.shade300 : Colors.red.shade300,
                          child: Row(
                            children: [
                              'مدت باقیمانده: '.toLabel(bold: true),
                              '${_activestep.remainday < 0 ? ' ('+(_activestep.remainday*-1).toString()+') ' : _activestep.remainday} روز'.toLabel(),
                            ],
                          ), 
                        ),
                        _activestep.startprevend
                          ? Container(padding: EdgeInsets.all(18), child: 'شروع با اتمام مرحله قبلی'.toLabel())
                          : Container()
                      ],
                    ),
                  )
                : Container(),
                _activestep != null
                  ? _activestep.kind == 0
                    ? FinishProcess(bloc: this.bloc, parvane: this.parvane, pprow: pprow, step: _activestep)
                    : _activestep.kind == 1
                      ? DocumentList(bloc: this.bloc, finish: _activestep.finish)
                      : _activestep.kind == 2
                        ? MeetingList(bloc: this.bloc, finish: _activestep.finish)
                        : _activestep.kind == 3
                          ? InspectionList(bloc: this.bloc, finish: _activestep.finish)
                          : _activestep.kind == 4
                            ? IncomeList(bloc: this.bloc, finish: _activestep.finish)
                            : _activestep.kind == 5
                              ? CourseList(bloc: this.bloc, finish: _activestep.finish)
                              : Container()
                  : Container()
              ],
            );
        }
        return Center(child: CupertinoActivityIndicator());
      }
    ).expand();
  }
}

class DocumentList extends StatelessWidget {
  final PPrcBloc bloc;
  final bool finish;
  const DocumentList({@required this.bloc,@required this.finish, Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<PPDocumentModel>(
        stream: bloc.ppDocumentstream,
        builder: (context, snp){
          if (snp.hasData)
            if (snp.data.status == Status.error)
              return ErrorInGrid(snp.data.msg);
            else if (snp.data.status == Status.loaded)
              return SingleChildScrollView(
                child: Wrap(
                  children: snp.data.rows.map((e) => Container(
                    width: screenWidth(context) * 0.2,
                    height: screenWidth(context) * 0.195,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: appbarColor(context)
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                            color: accentcolor(context).withOpacity(0.35),
                          ),
                          child: Row(
                            children: [
                              this.finish
                                ? Container()
                                : MyIconButton(
                                  type: ButtonType.other, 
                                  hint: 'آپلود مدرک', 
                                  icon: Icon(Icons.upload_outlined), 
                                  onPressed: ()=>prcUploadImg(context: context, id: e.ppid, id1: e.ppstepid, id2: e.id, tag: 'TBPPSDocument', function: (str){e.attachname=str; bloc.refreshDocument();}),
                                ),
                              Column(
                                children: [
                                  Text('${e.documentname}', textAlign: TextAlign.center,),
                                  SizedBox(height: 10),
                                  Text('${e.kindName()}', textAlign: TextAlign.center,),
                                ],
                              ).expand(),
                            ],
                          )
                        ),
                        if (e.attachname.toLowerCase().contains("xls") || e.attachname.toLowerCase().contains("xlsx"))
                          Image.asset("images/excel.png", fit: BoxFit.cover).expand()
                        else if (e.attachname.toLowerCase().contains("mp3"))
                          Image.asset("images/mp3.png", fit: BoxFit.cover).expand()
                        else if (e.attachname.toLowerCase().contains("mp4") || e.attachname.toLowerCase().contains("avi"))
                          Image.asset("images/mp4.png", fit: BoxFit.cover).expand()
                        else if (e.attachname.toLowerCase().contains("xls") || e.attachname.toLowerCase().contains("xlsx"))
                          Image.asset("images/excel.png", fit: BoxFit.cover).expand()
                        else if (e.attachname.toLowerCase().contains("doc") || e.attachname.toLowerCase().contains("docx"))
                          Image.asset("images/Word.png", fit: BoxFit.cover).expand()
                        else if (e.attachname.toLowerCase().contains("pdf"))
                          Image.asset("images/pdf.png", fit: BoxFit.cover).expand()
                        else if (!e.attachname.toLowerCase().contains("png") && !e.attachname.toLowerCase().contains("jpg") && !e.attachname.toLowerCase().contains("jpeg") && !e.attachname.toLowerCase().contains("bmp") && e.attachname.trim().isNotEmpty)
                          Image.asset("images/other.png", fit: BoxFit.cover).expand()
                        else
                          Image.network("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=TBPPSDocument&id=${e.ppid}&id1=${e.ppstepid}&id2=${e.id}&flg=${Random().nextInt(1000)}", fit: BoxFit.cover).expand(),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: accentcolor(context).withOpacity(0.35),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                          ),
                          child: Text('${e.attachname}', textAlign: TextAlign.left,)
                        )
                      ],
                    ),
                  )).toList()
                ),
              );
          return Center(child: CupertinoActivityIndicator());
        },
      )
    ).expand();
  }
}

class IncomeList extends StatelessWidget {
  final PPrcBloc bloc;
  final bool finish;
  const IncomeList({@required this.bloc, @required this.finish, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _date = TextEditingController();
    return Column(
      children: [
        GridCaption(
          obj: [
            'عنوان مدرک',
            'مبلغ',
            'تاریخ پرداخت',
            'شناسه پرداخت',
            Text('توضیحات', style: gridFieldStyle()).expand(flex: 2)
          ],
        ),
        StreamBuilder<PPIncomeModel>(
          stream: this.bloc.ppIncomestream,
          builder: (context, snap){
            if (snap.hasData)
              if (snap.data.status == Status.error)
                return ErrorInGrid('${snap.data.msg}');
              else if (snap.data.status == Status.loaded)
                return ListView.builder(
                  itemCount: snap.data.rows.length,
                  itemBuilder: (context, idx){
                    ParvaneProcessIncome income = snap.data.rows[idx];
                    if (income.edit && !this.finish)
                      _date.text = income.date;
                    return MyRow(
                      onDoubleTap: this.finish ? null : ()=>bloc.editPPStepIncome(income),
                      children: [
                        income.incomename.toLabel().expand(),                    
                        moneySeprator(income.price).toLabel().expand(),                    
                        income.edit && !this.finish
                          ? GridTextField(hint: 'تاریخ پرداخت', datepicker: true, controller: _date, onChange: (val)=>income.date = val).expand()
                          : income.date.toLabel().expand(),
                        income.edit && !this.finish
                          ? GridTextField(hint: 'شناسه پرداخت', initialValue: income.shenase, onChange: (val)=>income.shenase = val).expand()
                          : income.shenase.toLabel().expand(),
                        income.edit && !this.finish
                          ? GridTextField(hint: 'توضیحات', initialValue: income.note, onChange: (val)=>income.note = val).expand(flex: 2)
                          : income.note.toLabel().expand(),
                        this.finish
                          ? Container()
                          : income.edit
                            ? MyIconButton(type: ButtonType.save, onPressed: (){income.date=_date.text; bloc.savePPStepIncome(context, income);})
                            : MyIconButton(type: ButtonType.edit, onPressed: ()=>bloc.editPPStepIncome(income))
                      ]
                    );
                  }
                );
            return Center(child: CupertinoActivityIndicator());
          }
        ).expand(),
      ],
    ).expand();
  }
}

class MeetingList extends StatelessWidget {
  final PPrcBloc bloc;
  final bool finish;
  const MeetingList({@required this.bloc, @required this.finish, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _edate = TextEditingController();
    TextEditingController _mdate = TextEditingController();
    return Column(
      children: [
        GridCaption(
          obj: [
            'تاریخ ارجاع',
            'تاریخ جلسه',
            'نتیجه',
            'شماره مصوبه',
            Text('خلاصه نظر', style: gridFieldStyle()).expand(flex: 2)
          ],
          endbuttons: 2,
        ),
        StreamBuilder<PPMeetingModel>(
          stream: this.bloc.ppMeetingstream,
          builder: (context, snap){
            if (snap.hasData)
              if (snap.data.status == Status.error)
                return ErrorInGrid('${snap.data.msg}');
              else if (snap.data.status == Status.loaded)
                return ListView.builder(
                  itemCount: snap.data.rows.length,
                  itemBuilder: (context, idx){
                    ParvaneProcessMeeting meet = snap.data.rows[idx];
                    if (meet.edit){
                      _edate.text = meet.edate;
                      _mdate.text = meet.mdate;
                    }
                    return MyRow(
                      onDoubleTap: this.finish ? null : ()=>bloc.editPPStepMeeting(meet),
                      children: [
                        meet.edit && !this.finish
                          ? GridTextField(hint: 'تاریخ ارجاع', controller: _edate, datepicker: true).expand()
                          : meet.edate.toLabel().expand(),
                        meet.edit && !this.finish
                          ? GridTextField(hint: 'تاریخ جلسه', controller: _mdate, datepicker: true).expand()
                          : meet.mdate.toLabel().expand(),
                        meet.edit && !this.finish
                          ? DropDownButton(val: meet.res, items: [{'id': 0, 'title': ''},{'id': 1, 'title': 'قبول'},{'id': 2, 'title': 'رد'},{'id': 3, 'title': 'مشروط'}], hint: 'نتیجه', onChange: (val)=>meet.res=val).expand()
                          : meet.resName.toLabel().expand(),
                        meet.edit && !this.finish
                          ? GridTextField(hint: 'شماره مصوبه', initialValue: '${meet.mosavabeno}', onChange: (val)=>meet.mosavabeno = int.tryParse(val)).expand()
                          : '${meet.mosavabeno}'.toLabel().expand(),
                        meet.edit && !this.finish
                          ? GridTextField(hint: 'خلاصه نظر', initialValue: meet.note, onChange: (val)=>meet.note = val).expand(flex: 2)
                          : meet.note.toLabel().expand(flex: 2),
                         this.finish
                          ? Container()
                          : meet.id > 1 && !meet.edit
                            ? MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delPPStepMeeting(context, meet))
                            : Container(width: 35),
                         this.finish
                          ? Container()
                          : meet.edit
                            ? MyIconButton(type: ButtonType.save, onPressed: (){meet.edate=_edate.text;meet.mdate=_mdate.text; bloc.savePPStepMeeting(context, meet);})
                            : MyIconButton(type: ButtonType.edit, onPressed: ()=>bloc.editPPStepMeeting(meet)),
                      ]
                    );
                  }
                );
            return Center(child: CupertinoActivityIndicator());
          }
        ).expand(),
      ],
    ).expand();
  }
}

class InspectionList extends StatelessWidget {
  final PPrcBloc bloc;
  final bool finish;
  const InspectionList({@required this.bloc, @required this.finish, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _edate = TextEditingController();
    TextEditingController _bdate = TextEditingController();
    return Column(
      children: [
        GridCaption(
          obj: [
            'تاریخ ارجاع',
            'بازرس',
            'تاریخ بازرسی',
            'درجه',
            'صندوق',
            'نتیجه',
            Text('خلاصه نظر', style: gridFieldStyle()).expand(flex: 2)
          ],
          endbuttons: 1,
        ),
        StreamBuilder<PPInspectionModel>(
          stream: this.bloc.ppInspectionstream,
          builder: (context, snap){
            if (snap.hasData)
              if (snap.data.status == Status.error)
                return ErrorInGrid('${snap.data.msg}');
              else if (snap.data.status == Status.loaded)
                return ListView.builder(
                  itemCount: snap.data.rows.length,
                  itemBuilder: (context, idx){
                    ParvaneProcessInspection insp = snap.data.rows[idx];
                    if (insp.edit){
                      _edate.text = insp.edate;
                      _bdate.text = insp.bdate;
                    }
                    return MyRow(
                      onDoubleTap: this.finish ? null : ()=>bloc.editPPStepInspection(insp),
                      children: [
                        insp.edit && !this.finish
                          ? GridTextField(hint: 'تاریخ ارجاع', controller: _edate, datepicker: true).expand()
                          : insp.edate.toLabel().expand(),
                        insp.edit && !this.finish
                          ? ForeignKeyField(hint: 'بازرس', initialValue: {'id': insp.peopid, 'name': insp.peopfamily}, onChange: (val){if (val != null){insp.peopid = val['id']; insp.peopfamily = val['name'];}}, f2key: 'Inspection').expand()
                          : insp.peopfamily.toLabel().expand(),
                        insp.edit && !this.finish
                          ? GridTextField(hint: 'تاریخ بازرسی', controller: _bdate, datepicker: true).expand()
                          : insp.bdate.toLabel().expand(),
                        insp.edit && !this.finish
                          ? DropDownButton(val: insp.degree, items: [{'id': 0, 'title': ''},{'id': 1, 'title': 'درجه یک'},{'id': 2, 'title': 'درجه دو'},{'id': 3, 'title': 'درجه سه'},{'id': 4, 'title': 'درجه چهار'}], hint: 'درجه', onChange: (val)=>insp.degree=val).expand()
                          : insp.degreeName.toLabel().expand(),
                        insp.edit && !this.finish
                          ? RadioButton(val: insp.cashdesk, hint: 'صندوق', onChange: (val)=>insp.cashdesk=val).setPadding(padd: EdgeInsets.symmetric(horizontal: 5))
                          : Switch(value: insp.cashdesk, onChanged: (val){}).setPadding(padd: EdgeInsets.symmetric(horizontal: 5)),
                        insp.edit && !this.finish
                          ? DropDownButton(val: insp.res, items: [{'id': 0, 'title': ''},{'id': 1, 'title': 'قبول'},{'id': 2, 'title': 'رد'},{'id': 3, 'title': 'مشروط'}], hint: 'نتیجه', onChange: (val)=>insp.res=val).expand()
                          : insp.resName.toLabel().expand(),
                        insp.edit && !this.finish
                          ? GridTextField(hint: 'خلاصه نظر', initialValue: insp.note, onChange: (val)=>insp.note = val).expand(flex: 2)
                          : insp.note.toLabel().expand(flex: 2),
                        this.finish
                          ? Container()
                          : insp.id > 1 && !insp.edit
                            ? MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delPPStepInspection(context, insp))
                            : Container(width: 35),
                        this.finish
                          ? Container()
                          : insp.edit
                            ? MyIconButton(type: ButtonType.save, onPressed: (){insp.edate=_edate.text;insp.bdate=_bdate.text; bloc.savePPStepInspection(context, insp);})
                            : MyIconButton(type: ButtonType.edit, onPressed: ()=>bloc.editPPStepInspection(insp)),
                      ]
                    );
                  }
                );
            return Center(child: CupertinoActivityIndicator());
          }
        ).expand(),
      ],
    ).expand();
  }
}

class CourseList extends StatelessWidget {
  final PPrcBloc bloc;
  final bool finish;
  const CourseList({@required this.bloc, @required this.finish, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridCaption(
          obj: [
            'عنوان دوره',
            'نوع دوره',
            'نحوه حضور',
            'شروع کلاس',
            'عنوان کلاس',
            'غیبت مجاز',
            'هزینه'
          ],
          endbuttons: 1,
        ),
        StreamBuilder<PPCourseModel>(
          stream: this.bloc.ppCoursestream,
          builder: (context, snap){
            if (snap.hasData)
              if (snap.data.status == Status.error)
                return ErrorInGrid('${snap.data.msg}');
              else if (snap.data.status == Status.loaded)
                return ListView.builder(
                  itemCount: snap.data.rows.length,
                  itemBuilder: (context, idx){
                    return MyRow(
                      color: snap.data.rows[idx].classid > 0 ? Colors.yellow.shade100 : null,
                      endcolor: snap.data.rows[idx].rsv ? Colors.green : null,
                      children: [
                        snap.data.rows[idx].title.toLabel().expand(),
                        snap.data.rows[idx].kindName().toLabel().expand(),
                        snap.data.rows[idx].typeName().toLabel().expand(),
                        snap.data.rows[idx].begindate.toLabel().expand(),
                        snap.data.rows[idx].classtitle.toLabel().expand(),
                        '${snap.data.rows[idx].absent}'.toLabel().expand(),
                        '${snap.data.rows[idx].price}'.toLabel().expand(),
                        this.finish
                          ? Container()
                          : snap.data.rows[idx].classid == 0
                            ? MyIconButton(type: ButtonType.other, icon: Icon(Icons.view_agenda, color: accentcolor(context)), hint: 'انتخاب کلاس', onPressed: ()=>showFormAsDialog(context: context, form: ChooseClass(bloc: bloc, course: snap.data.rows[idx])))
                            : MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delPPStepCourse(context, snap.data.rows[idx])),
                      ]
                    );
                  }
                );
            return Center(child: CupertinoActivityIndicator());
          }
        ).expand(),
      ],
    ).expand();
  }
}

class FinishProcess extends StatelessWidget {
  final PPrcBloc bloc;
  final PPStep step;  
  final ParvaneProcess pprow;
  final Parvane parvane;
  const FinishProcess({@required this.bloc, @required this.parvane, @required this.pprow, @required this.step, Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.pprow.kind == 0
      ? 'نوع فرآیند قایل تشخیص نمی باشد'.toLabel().center()
      : FinishProcess1(bloc: this.bloc, parvane: this.parvane, pprow: this.pprow);
  }
}

class ChooseClass extends StatelessWidget {
  final PPrcBloc bloc;
  final ParvaneProcessCourse course;
  const ChooseClass({@required this.bloc, @required this.course, Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Bloc<int> _state = Bloc<int>()..setValue(-1);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: screenHeight(context) * 0.75,
        width: screenWidth(context) * 0.85,
        child: Column(
          children: [
            FormHeader(
              title: 'لیست کلاسهای دوره ${this.course.title}',
              btnRight: MyIconButton(type: ButtonType.other, icon: Icon(Icons.add_alert, color: accentcolor(context),), hint: 'اضافه شدن به لیست انتظار', onPressed: () async{
                confirmMessage(context, 'رزرو دوره', 'آیا مایل به رزرو دوره ${course.title} می باشید؟', yesclick: () async{
                  if (await this.bloc.reserveCourse(context, course)){
                    bloc.showPPStepCourse(context, this.course.ppid, this.course.ppstepid);
                    Navigator.pop(context);
                  }
                  Navigator.pop(context);
                });
              }),
            ),
            GridCaption(
              obj: [
                'عنوان کلاس',
                'تاریخ برگذاری',
                this.course.type == 1 || this.course.type == 3
                  ? 'ظرفیت حضوری [باقیمانده]'
                  : Container(),
                this.course.type == 2 || this.course.type == 3
                  ? 'ظرفیت غیرحضوری [باقیمانده]'
                  : Container(),
              ],
              endbuttons: 2,
            ),
            FutureBuilder<List<Class>>(
              future: ParvaneProcessRepository.loadParvaneProcessCourseClasses(this.course.ppid, this.course.ppstepid, this.course.courseid),
              builder: (context, snap){
                if (snap.hasData)
                  return StreamBuilder<int>(
                    stream: _state.stream$,
                    builder: (context, state) {
                      if (state.hasData)
                        return state.data > -1
                          ? RegisterInClass(bloc: bloc, course: this.course, cls: snap.data[state.data], state: _state,)
                          : ListView.builder(
                              itemCount: snap.data.length,
                              itemBuilder: (context, idx)=>MyRow(
                                children: [
                                  snap.data[idx].title.toLabel().expand(),
                                  snap.data[idx].begindate.toLabel().expand(),
                                  this.course.type == 1 || this.course.type == 3
                                    ? '${snap.data[idx].hozori} - [ ${snap.data[idx].hozoriremain} ]'.toLabel().expand()
                                    : Container(),
                                  this.course.type == 2 || this.course.type == 3
                                    ? '${snap.data[idx].nothozori} - [ ${snap.data[idx].nothozoriremain} ]'.toLabel().expand()
                                    : Container(),
                                  MyOutlineButton(
                                    title: 'ثبت نام', 
                                    color: accentcolor(context), 
                                    onPressed: (){
                                      _state.setValue(idx);
                                    }
                                  ),
                                ]
                              )
                            );
                    return CupertinoActivityIndicator();
                    }
                  );
                if (snap.hasError)
                  return Center(child: Text('خطا در دریافت اطلاعات لطفا مجددا سعی نمایید'));
                return Center(child: CupertinoActivityIndicator());
              }
            ).expand()
          ],
        ),
      ),
    );
  }
}

class RegisterInClass extends StatelessWidget {
  final PPrcBloc bloc;
  final ParvaneProcessCourse course;
  final Class cls;
  final Bloc<int> state;
  const RegisterInClass({@required this.bloc , @required this.course, @required this.cls, @required this.state, Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Bloc<int> _hozortype = Bloc<int>()..setValue(course.type);
    this.course.classid = this.cls.id;
    this.course.hozori = this.course.type == 1;
    return Center(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(28),
          width: 375,
          // height:  225,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              this.course.type == 3
                ? StreamBuilder<int>(
                    stream: _hozortype.stream$,
                    builder: (context, snap) {
                      if (snap.hasData)
                        return Row(
                          children: [
                            Switch(value: snap.data == 1, onChanged: (val){_hozortype.setValue(1); this.course.hozori = val;}),
                            'حضوری'.toLabel(),
                            SizedBox(width: 15),
                            Switch(value: snap.data == 0, onChanged: (val){_hozortype.setValue(0); this.course.hozori = val;}),
                            'غیر حضوری'.toLabel(),
                          ],
                        );
                      return CupertinoActivityIndicator();
                    }
                  )
                : Container(),
              FutureBuilder<List<DClass>>(
                future: bloc.loadPPSCoursePeople(context, course.ppid, course.ppstepid, cls.courseid, cls.id),
                builder: (context, snap){
                  if (snap.hasData)
                    if (snap.data.length > 0)
                      return DropDownButton(
                        hint: 'وابستگی',
                        val: snap.data[0].peopid,
                        items: snap.data.map<Map<String, dynamic>>((e) => {'id': e.peopid, 'title': e.peopfamily}).toList(),
                        onChange: (int val){this.course.peopid=val; this.course.peopfamily = snap.data.where((element) => element.peopid==val).first.peopfamily;},
                      );
                    else
                      return 'اطلاعاتی وجود ندارد'.toLabel();
                  if (snap.hasError)
                    return snap.error.toString().toLabel();
                  return CupertinoActivityIndicator();
                }
              ),
              GridTextField(hint: 'مشخصات پرداخت', initialValue: this.course.pinfo, onChange: (val)=>this.course.pinfo=val),
              SizedBox(height: 25),
              Row(
                children: [
                  MyOutlineButton(title: 'ذخیره', color: Colors.green, icon: Icons.save, onPressed: () async{
                    if (await bloc.savePSCourse(context, this.course)){
                      bloc.showPPStepCourse(context, this.course.ppid, this.course.ppstepid);
                      Navigator.of(context).pop();
                    }
                  }),
                  SizedBox(width: 10),
                  MyOutlineButton(title: 'انصراف', color: Colors.deepOrange, icon: Icons.cancel, onPressed: ()=>state.setValue(-1)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../classes/classes.dart';
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
                          title: Text('فرآیند صدور'),
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
                                ParvaneProcessRow(bloc: _bloc, data: snap.data.rows[idx]).card(),
                                SizedBox(height: 10),
                                ParvaneProcessStepDetail(bloc: _bloc, pprow: snap.data.rows[idx])
                              ],
                            ),
                          ).card();
                        return ParvaneProcessRow(bloc: _bloc, data: snap.data.rows[idx]).card();
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
        '${data.dayremind}'.toLabel().expand(),
        data.finish 
          ? Tooltip(message: 'اتمام فرآیند', child: Icon(Icons.check_box_outlined))
          : SizedBox(width: 40),
        MyIconButton(type: ButtonType.other, icon: Icon(Icons.view_sidebar_rounded, color: accentcolor(context),), hint: 'مشاهده وضعیت فرآیند', onPressed: ()=>bloc.showParvaneProcessSteps(context, data.id)),
        MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delParvaneProcess(context: context, id: data.id))
      ]
    );
  }
}

class ParvaneProcessStepDetail extends StatelessWidget {
  final PPrcBloc bloc;
  final ParvaneProcess pprow;
  const ParvaneProcessStepDetail({@required this.bloc,@required this.pprow, Key key }) : super(key: key);

  @override
  Widget build(BuildContext context){                                 
    Bloc<Prcstep> stepid = Bloc<Prcstep>();
    return StreamBuilder<Prcstep>(
      stream: stepid.stream$,
      builder: (context, cstp) {
        return Column(
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                ...pprow.stepsList.map((e) => 
                  InkWell(
                    onTap: (){
                      if (e.kind == 1)
                        bloc.showPPStepDocument(context, pprow.id, e.id);
                      if (e.kind == 2)
                        bloc.showPPStepMeeting(context, pprow.id, e.id);
                      if (e.kind == 3)
                        bloc.showPPStepInspection(context, pprow.id, e.id);
                      if (e.kind == 4)
                        bloc.showPPStepIncome(context, pprow.id, e.id);
                      stepid.setValue(e); 
                    },
                    hoverColor: accentcolor(context).withOpacity(0.25),
                    highlightColor: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: cstp.hasData && cstp.data.id == e.id ? accentcolor(context).withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                      ),
                      child: Text('${e.kindName()}').center(),
                    )
                  ).hMargin().expand()).toList(),
                Expanded(flex: 3, child: Container())
              ],
            ),
            SizedBox(height: 10),
            cstp.hasData &&  cstp.data.kind == 1
              ? DocumentList(bloc: this.bloc)
              : cstp.hasData &&  cstp.data.kind == 2
                ? MeetingList(bloc: this.bloc)
                : cstp.hasData &&  cstp.data.kind == 3
                  ? InspectionList(bloc: this.bloc)
                  : cstp.hasData &&  cstp.data.kind == 4
                    ? IncomeList(bloc: this.bloc)
                    : Container()
          ],
        );
      }
    ).expand();
  }
}

class DocumentList extends StatelessWidget {
  final PPrcBloc bloc;
  const DocumentList({@required this.bloc, Key key }) : super(key: key);

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
                      color: Colors.grey.shade100
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                            color: Colors.amber.shade100
                          ),
                          child: Row(
                            children: [
                              MyIconButton(
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
                            color: Colors.grey.shade200,
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
  const IncomeList({@required this.bloc, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    return MyRow(
                      onDoubleTap: ()=>bloc.editPPStepIncome(income),
                      children: [
                        income.incomename.toLabel().expand(),                    
                        moneySeprator(income.price).toLabel().expand(),                    
                        income.edit
                          ? GridTextField(hint: 'تاریخ پرداخت', initialValue: income.date, datepicker: true, onChange: (val)=>income.date = val).expand()
                          : income.date.toLabel().expand(),
                        income.edit
                          ? GridTextField(hint: 'شناسه پرداخت', initialValue: income.shenase, onChange: (val)=>income.shenase = val).expand()
                          : income.shenase.toLabel().expand(),
                        income.edit
                          ? GridTextField(hint: 'توضیحات', initialValue: income.note, onChange: (val)=>income.note = val).expand(flex: 2)
                          : income.note.toLabel().expand(),
                        income.edit
                          ? MyIconButton(type: ButtonType.save, onPressed: ()=>bloc.savePPStepIncome(context, income))
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
  const MeetingList({@required this.bloc, Key key}) : super(key: key);

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
                      onDoubleTap: ()=>bloc.editPPStepMeeting(meet),
                      children: [
                        meet.edit
                          ? GridTextField(hint: 'تاریخ ارجاع', controller: _edate, datepicker: true).expand()
                          : meet.edate.toLabel().expand(),
                        meet.edit
                          ? GridTextField(hint: 'تاریخ جلسه', controller: _mdate, datepicker: true).expand()
                          : meet.mdate.toLabel().expand(),
                        meet.edit
                          ? DropDownButton(val: meet.res, items: [{'id': 0, 'title': ''},{'id': 1, 'title': 'قبول'},{'id': 2, 'title': 'رد'},{'id': 3, 'title': 'مشروط'}], hint: 'نتیجه', onChange: (val)=>meet.res=val).expand()
                          : meet.resName.toLabel().expand(),
                        meet.edit
                          ? GridTextField(hint: 'شماره مصوبه', initialValue: '${meet.mosavabeno}', onChange: (val)=>meet.mosavabeno = int.tryParse(val)).expand()
                          : '${meet.mosavabeno}'.toLabel().expand(),
                        meet.edit
                          ? GridTextField(hint: 'خلاصه نظر', initialValue: meet.note, onChange: (val)=>meet.note = val).expand(flex: 2)
                          : meet.note.toLabel().expand(flex: 2),
                        meet.id > 1 && !meet.edit
                          ? MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delPPStepMeeting(context, meet))
                          : Container(width: 35),
                        meet.edit
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
  const InspectionList({@required this.bloc, Key key}) : super(key: key);

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
            'نتیجه',
            'صندوق',
            'درجه',
            Text('خلاصه نظر', style: gridFieldStyle()).expand(flex: 2)
          ],
          endbuttons: 2,
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
                      onDoubleTap: ()=>bloc.editPPStepInspection(insp),
                      children: [
                        insp.edit
                          ? GridTextField(hint: 'تاریخ ارجاع', controller: _edate, datepicker: true).expand()
                          : insp.edate.toLabel().expand(),
                        insp.edit
                          ? GridTextField(hint: 'بازرس', initialValue: insp.peopfamily).expand()
                          : insp.peopfamily.toLabel().expand(),
                        insp.edit
                          ? GridTextField(hint: 'تاریخ بازرسی', controller: _bdate, datepicker: true).expand()
                          : insp.bdate.toLabel().expand(),
                        insp.edit
                          ? DropDownButton(val: insp.degree, items: [{'id': 0, 'title': ''},{'id': 1, 'title': 'درجه یک'},{'id': 2, 'title': 'درجه دو'},{'id': 3, 'title': 'درجه سه'},{'id': 4, 'title': 'درجه چهار'}], hint: 'درجه', onChange: (val)=>insp.degree=val).expand()
                          : insp.degreeName.toLabel().expand(),
                        insp.edit
                          ? RadioButton(val: insp.cashdesk, hint: 'صندوق', onChange: (val)=>insp.cashdesk=val)
                          : RadioButton(val: insp.cashdesk, hint: 'صندوق', onChange: (val){}),
                        insp.edit
                          ? DropDownButton(val: insp.res, items: [{'id': 0, 'title': ''},{'id': 1, 'title': 'قبول'},{'id': 2, 'title': 'رد'},{'id': 3, 'title': 'مشروط'}], hint: 'نتیجه', onChange: (val)=>insp.res=val).expand()
                          : insp.resName.toLabel().expand(),
                        insp.edit
                          ? GridTextField(hint: 'خلاصه نظر', initialValue: insp.note, onChange: (val)=>insp.note = val).expand(flex: 2)
                          : insp.note.toLabel().expand(flex: 2),
                        insp.id > 1 && !insp.edit
                          ? MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delPPStepInspection(context, insp))
                          : Container(width: 35),
                        insp.edit
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/forms/Process/ProcessBloc.dart';
import 'package:pama/module/Widgets.dart';
import 'package:pama/module/consts.dart';
import 'package:pama/module/functions.dart';

ProcessBloc _bloc;

class FmProcess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (_bloc == null)
      _bloc = ProcessBloc()..loaddata(context);
    return Container(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormHeader(
              title: 'فهرست فرآیند ها', 
              btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>_bloc.insertRow(context)), 
              btnLeft: MyIconButton(type: ButtonType.reload, onPressed: ()=>_bloc.loaddata(context))
            ),
            GridCaption(obj: [
              Text('فعال', style: gridFieldStyle()),
              Expanded(flex: 2, child: Text('عنوان فرآیند', style: gridFieldStyle(), textAlign: TextAlign.center,)),
              'نوع',
              'مدت مجاز',
              SizedBox(width: 10),  
              Text('تمدیدپذیر', style: gridFieldStyle(),),
              SizedBox(width: 10),
              Text('تمام اتحادیه ها', style: gridFieldStyle(),),
              SizedBox(width: 10),
            ], endbuttons: 1),
            Expanded(
              child: StreamBuilder(
                stream: _bloc.processStream$,
                builder: (BuildContext context, AsyncSnapshot<ProcessModel> snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (context, idx)=>
                          snap.data.rows[idx].showDetail
                            ? Column(
                              children: [
                                ProcessRow(snap.data.rows[idx], idx),
                                Card(
                                  child: Container(
                                    height: screenHeight(context) * 0.5,
                                    width: double.infinity,
                                    child: ProcessStep(process: snap.data.rows[idx]),
                                  ),
                                )
                              ],
                            )
                            : ProcessRow(snap.data.rows[idx], idx)
                      );
                    return Center(child: CupertinoActivityIndicator());
                }
              )
            )
          ]
        )
      )
    );
  }
}

class ProcessRow extends StatelessWidget {
  final Process obj;
  final int idx;
  
  ProcessRow(this.obj, this.idx);

  @override
  Widget build(BuildContext context) {
    return MyRow(
      onDoubleTap: ()=>_bloc.editRow(obj.id),
      color: idx.isOdd ? appbarColor(context) : scaffoldcolor(context),
      children: [
        Switch(value: obj.active, onChanged: (val)=>_bloc.changeActive(context, obj.id, val)),
        SizedBox(width: 10),
        obj.edit
          ? Expanded(flex: 2, child: GridTextField(hint: 'عنوان فرآیند', initialValue: obj.title, autofocus: true, onChange: (val)=>obj.title=val))
          : Expanded(flex: 2, child: Text('${obj.title}')),
        obj.edit
          ? Expanded(child: MultiChooseItem(
            val: obj.kind, 
            items: [
              {'id': 1, 'title': 'صدور'},
              {'id': 2, 'title': 'تمدید'},
              {'id': 3, 'title': 'تغییر نشانی'},
              {'id': 4, 'title': 'تغییر مالکیت'},
              {'id': 5, 'title': 'تغییر رسته'},
              {'id': 6, 'title': 'معرفی/حذف مباشز'},
              {'id': 7, 'title': 'مغرفی/حذف شریک'},
              {'id': 8, 'title': 'تغییر درجه عضویت'},
              {'id': 9, 'title': 'تعطیلی موقت'},
              {'id': 10, 'title': 'بازگشایی'},
              {'id': 11, 'title': 'ابطال'},
            ], 
            hint: 'نوع', 
            onChange: (val)=>_bloc.changeKind(obj.id, val)))
          : '${obj.kindName()}',
        '${obj.duration}',
        Tooltip(message: 'تمدید پذیر', child: Switch(value: obj.recon, onChanged: (val)=>_bloc.changeRecon(context, obj.id, val))),
        SizedBox(width: 5),
        Tooltip(message: 'تمام اتحادیه ها', child: Switch(value: obj.allcmp, onChanged: (val)=>_bloc.changeAllCmp(context, obj.id, val))),
        SizedBox(width: 5),
        obj.edit
          ? MyIconButton(type: ButtonType.save, onPressed: ()=>_bloc.saveData(context, obj))
          : MyIconButton(type: ButtonType.other, icon: Icon(Icons.swap_calls_outlined), hint: 'مراحل فرآیند', onPressed: ()=>_bloc.loadSteps(context, obj.id)),
        obj.allcmp
          ? Container(width: 42,)
          : MyIconButton(type: ButtonType.other, icon: Icon(Icons.category, color: Colors.grey[600]), hint: 'اختصاص اتحادیه ها', onPressed: (){}),
        obj.edit
          ? Container()
          : MyIconButton(type: ButtonType.del, onPressed: ()=>_bloc.delProcess(context, obj)),
      ]
    );
  }
}

class ProcessStep extends StatelessWidget {
  final Process process;
  ProcessStep({@required this.process});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          FormHeader(
            title: 'مراحل فرآیند', 
            btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>_bloc.newStep(context, this.process.id)), 
            btnLeft: MyIconButton(type: ButtonType.exit, onPressed: ()=>_bloc.loadSteps(context, this.process.id))
          ),
          GridCaption(obj: [
            Text('فعال', style: gridFieldStyle()),
            'عنوان مرحله',
            'نوع فعالیت',
            'مدت مجاز',
          ], endbuttons: 6),
          Expanded(
            child: StreamBuilder(
              stream: _bloc.prcStepStream$,
              builder: (BuildContext context, AsyncSnapshot<PrcStepModel> snap){
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid(snap.data.msg);
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        Prcstep _step = snap.data.rows[idx];
                        return MyRow(
                          onDoubleTap: ()=>_bloc.editStep(_step.id),
                          children: [
                            Switch(value: _step.active, onChanged: (val)=>_bloc.stepActive(context, _step.id, val)),
                            _step.edit 
                              ? Expanded(child: GridTextField(hint: 'عنوان مرحله', initialValue: '${_step.title}', onChange: (val)=>_step.title=val))
                              : '${_step.title}',
                            _step.edit
                              ? Expanded(
                                child: MultiChooseItem(
                                  val: _step.kind, 
                                  items: [
                                    {'id': 1, 'title': 'مدرک'},
                                    {'id': 2, 'title': 'هیت مدیره'},
                                    {'id': 3, 'title': 'بازرسی'},
                                    {'id': 4, 'title': 'حسابداری'},
                                    {'id': 5, 'title': 'آموزش'},
                                  ], 
                                  hint: 'نوع فعالیت', 
                                  onChange: (val)=>_bloc.stepKind(_step.id, val)
                                )
                              )
                              : '${_step.kindName()}',
                            _step.edit 
                              ? Expanded(child: GridTextField(hint: 'مدت مجاز مرحله', initialValue: '${_step.length}', onChange: (val)=>_step.length=int.tryParse(val)))
                              : '${_step.length}',
                            Tooltip(message: 'آغاز با اتمام مرحله قبل', child: Switch(value: _step.startprevend, onChanged: (val)=>_bloc.stepstartprevend(context, _step.id, val))),
                            Tooltip(message: 'شروع مجدد بعد از انقضاء', child: Switch(value: _step.restart, onChanged: (val)=>_bloc.steprestart(context, _step.id, val))),
                            Tooltip(message: 'ارسال پیامک', child: Switch(value: _step.sms, onChanged: (val)=>_bloc.stepsms(context, _step.id, val))),
                            Tooltip(message: 'توقف اخطار ماده 27', child: Switch(value: _step.err27, onChanged: (val)=>_bloc.steperr27(context, _step.id, val))),
                            _step.edit
                              ? SizedBox(width: 35)
                              : MyIconButton(type: ButtonType.other, icon: Icon(Icons.category_outlined), hint: 'آپلود اطلاعات', onPressed: ()=>showStepDetail(context, process, _step)),
                            _step.edit
                              ? MyIconButton(type: ButtonType.save, onPressed: ()=>_bloc.saveStep(context, _step))
                              : MyIconButton(type: ButtonType.del, onPressed: ()=>_bloc.delStep(context, _step)),
                          ]
                        );
                      }
                    );
                  return Center(child: CupertinoActivityIndicator());
              },
            )
          )
        ],
      ),      
    );
  }
}

showStepDetail(BuildContext context, Process proc, Prcstep obj){
  if (obj.kind == 1){
    _bloc.loadStepDocuemnt(context, proc.id, obj.id);
    showFormAsDialog(context: context, form: PnDocument(process: proc.title, step: obj));
  }
}

class PnDocument extends StatelessWidget {
  final Prcstep step;
  final String process;
  PnDocument({@required this.process, @required this.step});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.65,
        child: Column(
          children: [
            FormHeader(title: 'مدارک  ${step.title} $process', btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>_bloc.insertStepDocument(step.processid, step.id))),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 3),
              child: GridTextField(hint: 'جستجو ...', onChange: (val)=>_bloc.searchDocument(val)),
            ),
            GridCaption(obj: [
              'عنوان مدرک',
              'وابستگی'
            ]),
            Expanded(
              child: StreamBuilder<PrcStepDocumentModel>(
                stream: _bloc.prcStepDocuemtnStream$,
                builder: (context, snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (context, idx){
                          PrcStepDocument _doc = snap.data.rows[idx];
                          return _doc.search
                            ? MyRow(
                                onDoubleTap: ()=>_bloc.editStepDocument(_doc.id),
                                children: [
                                  _doc.edit
                                    ? Expanded(child: ForeignKeyField(hint: 'عنوان مدرک', initialValue: {'id': _doc.documentid, 'name': _doc.documentname}, f2key: 'Document', onChange: (val){_doc.documentid=val['id'];_doc.documentname=val['name'];}))
                                    : '${_doc.documentname}',
                                  _doc.edit
                                    ? Expanded(child: MultiChooseItem(
                                        val: _doc.kind == 0 ? 1 : _doc.kind, 
                                        items: [
                                          {'id': 1, 'title': 'فرد صنفی'},
                                          {'id': 2, 'title': 'پروانه کسب'},
                                          {'id': 3, 'title': 'واحد صنفی'},
                                          {'id': 4, 'title': 'شریک'},
                                          {'id': 5, 'title': 'مباشر'},
                                          {'id': 6, 'title': 'کارکنان'},
                                        ], 
                                        hint: 'وابستگی', 
                                        onChange: (val)=>_bloc.changeStepDocumentKind(_doc.id, val)
                                      ))
                                    : '${_doc.kindName()}',
                                  _doc.edit
                                    ? MyIconButton(type: ButtonType.save, onPressed: ()=>_bloc.saveStepDocument(context, _doc))
                                    : MyIconButton(type: ButtonType.del, onPressed: ()=>_bloc.delStepDocumetn(context, _doc))
                                ]
                              )
                            : Container();
                        }
                      );
                  return Center(child: CupertinoActivityIndicator());
                }
              )
            )
          ],
        ),
      ),
    );
  }
}

class PnIncome extends StatelessWidget {
  final Prcstep step;
  final String process;
  PnIncome({@required this.process, @required this.step});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.65,
        child: Column(
          children: [
            FormHeader(title: 'درآمدهای  ${step.title} $process', btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>_bloc.insertStepIncome(step.processid, step.id))),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 3),
            //   child: GridTextField(hint: 'جستجو ...', onChange: (val)=>_bloc.searchIncome(val)),
            // ),
            GridCaption(obj: [
              'عنوان درآمد',
            ]),
            Expanded(
              child: StreamBuilder<PrcStepIncomeModel>(
                stream: _bloc.prcStepIncomeStream$,
                builder: (context, snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (context, idx){
                          PrcStepIncome _doc = snap.data.rows[idx];
                          return MyRow(
                            children: [
                              _doc.incomeid == 0
                                ? Expanded(child: ForeignKeyField(hint: 'عنوان درآمد', initialValue: {'id': _doc.incomeid, 'name': _doc.incomename}, f2key: 'Income', onChange: (val){_doc.incomeid=val['id'];_doc.incomename=val['name'];}))
                                : '${_doc.incomename}',
                              MyIconButton(type: ButtonType.del, onPressed: ()=>_bloc.delStepIncome(context, _doc))
                            ]
                          );
                        }
                      );
                  return Center(child: CupertinoActivityIndicator());
                }
              )
            )
          ],
        ),
      ),
    );
  }
}



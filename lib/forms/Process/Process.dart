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
              'عنوان فرآیند',
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
                stream: _bloc.topicStream$,
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
                                    height: screenHeight(context) * 0.3,
                                    width: double.infinity,
                                    child: ProcessStep(),
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
          ? Expanded(child: GridTextField(hint: 'عنوان فرآیند', initialValue: obj.title, autofocus: true, onChange: (val)=>obj.title=val))
          : '${obj.title}',
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
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}


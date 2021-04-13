import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/classes/classes.dart';

import '../../../module/Widgets.dart';
import '../../../module/consts.dart';
import '../../../module/functions.dart';
import 'CourseBloc.dart';

class FmCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CourseBloc _bloc = CourseBloc()..loadData(context);
    return Container(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormHeader(
              title: 'دوره های آموزشی', 
              btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>showFormAsDialog(context: context, form: PnEditCourse(course: Course(id: 0)))), 
              btnLeft: MyIconButton(type: ButtonType.reload, onPressed: ()=>_bloc.loadData(context))
            ),
            GridCaption(
              obj: [
                Text('فعال', style: gridFieldStyle(),), 
                'عنوان دوره',
                'نوع دوره',
                'نحوه حضور',
                'هزینه'
              ], 
              endbuttons: 2
            ),
            Expanded(
              child: StreamBuilder<CourseModel>(
                stream: _bloc.courseblocStream$,
                builder: (context, snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (context, idx){
                          Course _crs = snap.data.rows[idx];
                          return MyRow(
                            children: [
                              Switch(value: _crs.active, onChanged: (val){}),
                              '${_crs.title}',
                              '${_crs.kindName()}',
                              '${_crs.typeName()}',
                              '${_crs.price} - ${_crs.reprice}',
                              MyIconButton(type: ButtonType.del, onPressed: ()=>_bloc.delCourse(context, _crs))
                            ]
                          );
                        }
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

class PnEditCourse extends StatelessWidget {
  final Course course;
  PnEditCourse({@required this.course});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            FormHeader(
              title: 'دوره آموزشی',
              btnRight: MyIconButton(type: ButtonType.save, onPressed: (){}),
              btnLeft: MyIconButton(type: ButtonType.exit),
            ),
            Row(
              children: [
                Expanded(child: GridTextField(hint: 'عنوان دوره', initialValue: this.course.title, onChange: (val)=>this.course.title=val)),
                SizedBox(width: 5),
                Expanded(
                  child: MultiChooseItem(
                    val: this.course.kind, 
                    items: [
                      {'id': 1, 'title': 'آزاد'},
                      {'id': 2, 'title': 'صدور و تمدید'},
                    ], 
                    hint: 'نوع دوره', 
                    onChange: (val)=>this.course.kind=val
                  )
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: MultiChooseItem(
                    val: this.course.type, 
                    items: [
                      {'id': 1, 'title': 'حضوری'},
                      {'id': 2, 'title': 'غیر حضوری'},
                      {'id': 3, 'title': 'حضوری و غیر حضوری'},
                    ], 
                    hint: 'نحوه حضور', 
                    onChange: (val)=>this.course.type=val
                  )
                ),
                SizedBox(width: 5),
                Expanded(
                  child: MultiChooseItem(
                    val: this.course.mindegree, 
                    items: [
                      {'id': 1, 'title': 'زیردیپلم'},
                      {'id': 2, 'title': 'دیپلم'},
                      {'id': 3, 'title': 'دانشجو'},
                      {'id': 4, 'title': 'کاردانی'},
                      {'id': 5, 'title': 'کارشناسی'},
                      {'id': 6, 'title': 'کارشناسی ارشد'},
                      {'id': 7, 'title': 'دکتری'},
                      {'id': 8, 'title': 'فوق دکتری'},
                    ], 
                    hint: 'حداقل مدرک', 
                    onChange: (val)=>this.course.type=val
                  )
                ),
                SizedBox(width: 5),
                Expanded(
                  child: MultiChooseItem(
                    val: this.course.maxdegree, 
                    items: [
                      {'id': 1, 'title': 'زیردیپلم'},
                      {'id': 2, 'title': 'دیپلم'},
                      {'id': 3, 'title': 'دانشجو'},
                      {'id': 4, 'title': 'کاردانی'},
                      {'id': 5, 'title': 'کارشناسی'},
                      {'id': 6, 'title': 'کارشناسی ارشد'},
                      {'id': 7, 'title': 'دکتری'},
                      {'id': 8, 'title': 'فوق دکتری'},
                    ], 
                    hint: 'حداکثر مدرک', 
                    onChange: (val)=>this.course.maxdegree=val
                  )
                )
              ],
            ),
            Row(
              children: [
                Expanded(child: GridTextField(hint: 'غیبت مجاز', initialValue: this.course.absent.toString(), numberonly: true, onChange: (val)=>this.course.absent=int.tryParse(val))),
                SizedBox(width: 5),
                Expanded(child: GridTextField(hint: 'اعتبار مدرک', initialValue: this.course.valid.toString(), numberonly: true, onChange: (val)=>this.course.valid=int.tryParse(val))),
                SizedBox(width: 5),
                Expanded(child: GridTextField(hint: 'هزینه اولیه', initialValue: this.course.price.toString(), money: true, onChange: (val)=>this.course.price=double.tryParse(val))),
                SizedBox(width: 5),
                Expanded(child: GridTextField(hint: 'هزینه مجدد', initialValue: this.course.reprice.toString(), money: true, onChange: (val)=>this.course.reprice=double.tryParse(val))),
              ]
            ),
            Row(
              children: [
                Expanded(child: GridTextField(hint: 'نمره حضوری مرتبه اول', initialValue: this.course.noh1.toString(), numberonly: true, onChange: (val)=>this.course.noh1=int.tryParse(val))),
                SizedBox(width: 5),
                Expanded(child: GridTextField(hint: 'نمره غیر حضوری مرتبه اول', initialValue: this.course.noh2.toString(), numberonly: true, onChange: (val)=>this.course.noh2=int.tryParse(val))),
                SizedBox(width: 5),
                Expanded(child: GridTextField(hint: 'نمره حضوری مرتبه بعد', initialValue: this.course.nonh1.toString(), numberonly: true, onChange: (val)=>this.course.nonh1=int.tryParse(val))),
                SizedBox(width: 5),
                Expanded(child: GridTextField(hint: 'نمره غیر حضوری مرتبه بعد', initialValue: this.course.nonh2.toString(), numberonly: true, onChange: (val)=>this.course.nonh2=int.tryParse(val))),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
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
              btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>showFormAsDialog(context: context, form: PnEditCourse(bloc: _bloc, course: Course(id: 0)))), 
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
                          if (_crs.showclass)
                            return Container(
                              height: screenHeight(context) * 0.5,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  CourseRow(bloc: _bloc, course: _crs, odd: idx.isOdd),
                                  FormHeader(
                                    title: 'لیست کلاس ها', 
                                    btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>_bloc.newClass(_crs.id)),
                                    btnLeft: MyIconButton(type: ButtonType.none),
                                  ),
                                  GridCaption(
                                    obj: [
                                      'عنوان کلاس',
                                      'تاریخ آغاز',
                                      'ظرفیت حضوری',
                                      'ظرفیت غیرحضوری',
                                    ],
                                    endbuttons: 2,
                                  ),
                                  Expanded(
                                    child: StreamBuilder<ClassModel>(
                                      stream: _bloc.classblocStream$,
                                      builder: (context, snap){
                                        if (snap.hasData)
                                          if (snap.data.status == Status.error)
                                            return ErrorInGrid(snap.data.msg);
                                          else if (snap.data.status == Status.loaded)
                                            return ListView.builder(
                                              itemCount: snap.data.rows.length,
                                              itemBuilder: (context, idx){
                                                Class _cls = snap.data.rows[idx];                                                
                                                TextEditingController _eddate = TextEditingController(text:_cls.begindate);
                                                return MyRow(
                                                  onDoubleTap: ()=>_bloc.editClass(_cls),
                                                  children: [
                                                    _cls.edit
                                                      ? Expanded(child: GridTextField(hint: 'عنوان کلاس', initialValue: _cls.title, onChange: (val)=>_cls.title=val))
                                                      : '${_cls.title}',
                                                    _cls.edit
                                                      ? Expanded(child: GridTextField(hint: 'تاریخ آغاز', controller: _eddate, datepicker: true))
                                                      : '${_cls.begindate}',
                                                    _cls.edit
                                                      ? Expanded(child: GridTextField(hint: 'ظرفیت حضوری', initialValue: '${_cls.hozori}', onChange: (val)=>_cls.hozori=int.tryParse(val)))
                                                      : '${_cls.hozori}',
                                                    _cls.edit
                                                      ? Expanded(child: GridTextField(hint: 'ظرفیت غیر حضوری', initialValue: '${_cls.nothozori}', onChange: (val)=>_cls.nothozori=int.tryParse(val)))
                                                      : '${_cls.nothozori}',
                                                    _cls.edit
                                                      ? MyIconButton(type: ButtonType.save, onPressed: (){_cls.begindate=_eddate.text; _bloc.saveClass(context, _cls);})
                                                      : MyIconButton(type: ButtonType.del, onPressed: ()=>_bloc.delClass(context, _cls))
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
                            );
                          return CourseRow(bloc: _bloc, course: _crs, odd: idx.isOdd);
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

class CourseRow extends StatelessWidget {
  final Course course;
  final CourseBloc bloc;
  final bool odd;
  CourseRow({@required this.bloc, @required this.course, @required this.odd});
  @override
  Widget build(BuildContext context) {
    return MyRow(
      onDoubleTap: ()=>showFormAsDialog(context: context, form: PnEditCourse(bloc: bloc, course: course)),
      color: this.odd ? appbarColor(context) : scaffoldcolor(context),
      children: [
        Switch(value: course.active, onChanged: (val){course.active=val;bloc.saveCourse(context, course, pop: false);}),
        '${course.title}',
        '${course.kindName()}',
        '${course.typeName()}',
        '${course.price} - ${course.reprice}',
        MyIconButton(type: ButtonType.other, hint: 'لیست کلاسها', icon: Icon(Icons.category, color: Colors.grey.shade600,), onPressed: ()=>bloc.showClass(context, this.course.id)),
        MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delCourse(context, course)),
      ]
    );
  }
}

class PnEditCourse extends StatelessWidget {
  final Course course;
  final CourseBloc bloc;
  PnEditCourse({@required this.bloc, @required this.course});
  @override
  Widget build(BuildContext context) {
    Bloc<Course> _crs = Bloc<Course>()..setValue(this.course);    
    return Container(
      width: screenWidth(context) * 0.5,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: StreamBuilder<Course>(
          stream: _crs.stream$,
          builder: (context, snap) {
            if (!snap.hasData)
              return Center(child: CupertinoActivityIndicator());
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormHeader(
                  title: 'دوره آموزشی',
                  btnRight: MyIconButton(type: ButtonType.save, onPressed: ()=>bloc.saveCourse(context, course)),
                  btnLeft: MyIconButton(type: ButtonType.exit),
                ),
                Row(
                  children: [
                    Expanded(child: GridTextField(hint: 'عنوان دوره', initialValue: snap.data.title, autofocus: true, onChange: (val)=>snap.data.title=val)),
                    SizedBox(width: 5),
                    Expanded(
                      child: MultiChooseItem(
                        val: snap.data.kind, 
                        items: [
                          {'id': 1, 'title': 'آزاد'},
                          {'id': 2, 'title': 'صدور و تمدید'},
                        ], 
                        hint: 'نوع دوره', 
                        onChange: (val){snap.data.kind=val;_crs.setValue(_crs.value$);}
                      )
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MultiChooseItem(
                        val: snap.data.type, 
                        items: [
                          {'id': 1, 'title': 'حضوری'},
                          {'id': 2, 'title': 'غیر حضوری'},
                          {'id': 3, 'title': 'حضوری و غیر حضوری'},
                        ], 
                        hint: 'نحوه حضور', 
                        onChange: (val){snap.data.type=val;_crs.setValue(_crs.value$);}
                      )
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: MultiChooseItem(
                        val: snap.data.mindegree, 
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
                        onChange: (val){snap.data.mindegree=val;_crs.setValue(_crs.value$);}
                      )
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: MultiChooseItem(
                        val: snap.data.maxdegree, 
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
                        onChange: (val){snap.data.maxdegree=val;_crs.setValue(_crs.value$);}
                      )
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: GridTextField(hint: 'غیبت مجاز', initialValue: snap.data.absent.toString(), numberonly: true, onChange: (val)=>snap.data.absent=int.tryParse(val))),
                    SizedBox(width: 5),
                    Expanded(child: GridTextField(hint: 'اعتبار مدرک', initialValue: snap.data.valid.toString(), numberonly: true, onChange: (val)=>snap.data.valid=int.tryParse(val))),
                  ]
                ),
                Row(
                  children: [
                    Expanded(child: GridTextField(hint: 'هزینه اولیه', initialValue: snap.data.price.toString(), money: true, onChange: (val)=>snap.data.price=double.tryParse(val.replaceAll(',', '')))),
                    SizedBox(width: 5),
                    Expanded(child: GridTextField(hint: 'هزینه مجدد', initialValue: snap.data.reprice.toString(), money: true, onChange: (val)=>snap.data.reprice=double.tryParse(val.replaceAll(',', '')))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: GridTextField(hint: 'نمره حضوری مرتبه اول', initialValue: snap.data.noh1.toString(), numberonly: true, onChange: (val)=>snap.data.noh1=int.tryParse(val))),
                    SizedBox(width: 5),
                    Expanded(child: GridTextField(hint: 'نمره غیر حضوری مرتبه اول', initialValue: snap.data.noh2.toString(), numberonly: true, onChange: (val)=>snap.data.noh2=int.tryParse(val))),
                  ]
                ),
                Row(
                  children: [
                    Expanded(child: GridTextField(hint: 'نمره حضوری مرتبه بعد', initialValue: snap.data.nonh1.toString(), numberonly: true, onChange: (val)=>snap.data.nonh1=int.tryParse(val))),
                    SizedBox(width: 5),
                    Expanded(child: GridTextField(hint: 'نمره غیر حضوری مرتبه بعد', initialValue: snap.data.nonh2.toString(), numberonly: true, onChange: (val)=>snap.data.nonh2=int.tryParse(val))),
                  ],
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
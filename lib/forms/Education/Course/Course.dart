import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../classes/classes.dart';
import '../../../module/theme-Manager.dart';
import 'package:provider/provider.dart';

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
                              height: screenHeight(context) * 0.75,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  CourseRow(bloc: _bloc, course: _crs, odd: idx.isOdd),
                                  Expanded(child: ClassList(bloc: _bloc, course: _crs))
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
        '${moneySeprator(course.price)} - ${moneySeprator(course.reprice)}',
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
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Container(
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
                    btnRight: MyIconButton(type: ButtonType.save, onPressed: (){if (_formKey.currentState.validate()) bloc.saveCourse(context, course);}),
                    btnLeft: MyIconButton(type: ButtonType.exit),
                  ),
                  Row(
                    children: [
                      Expanded(child: GridTextField(hint: 'عنوان دوره', initialValue: snap.data.title, autofocus: true, notempty: true, onChange: (val)=>snap.data.title=val)),
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
                      Expanded(child: GridTextField(hint: 'غیبت مجاز', initialValue: snap.data.absent.toString(), numberonly: true, notempty: true, onChange: (val)=>snap.data.absent=int.tryParse(val))),
                      SizedBox(width: 5),
                      Expanded(child: GridTextField(hint: 'اعتبار مدرک (ماه)', initialValue: snap.data.valid.toString(), numberonly: true, notempty: true, onChange: (val)=>snap.data.valid=int.tryParse(val))),
                    ]
                  ),
                  Row(
                    children: [
                      Expanded(child: GridTextField(hint: 'هزینه اولیه', initialValue: moneySeprator(snap.data.price), money: true, notempty: true, onChange: (val)=>snap.data.price=double.tryParse(val.replaceAll(',', '')))),
                      SizedBox(width: 5),
                      Expanded(child: GridTextField(hint: 'هزینه مجدد', initialValue: moneySeprator(snap.data.reprice), money: true, notempty: true, onChange: (val)=>snap.data.reprice=double.tryParse(val.replaceAll(',', '')))),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: GridTextField(hint: 'نمره حضوری مرتبه اول', initialValue: snap.data.noh1.toString(), numberonly: true, notempty: true, onChange: (val)=>snap.data.noh1=int.tryParse(val))),
                      SizedBox(width: 5),
                      Expanded(child: GridTextField(hint: 'نمره غیر حضوری مرتبه اول', initialValue: snap.data.nonh1.toString(), numberonly: true, notempty: true, onChange: (val)=>snap.data.nonh1=int.tryParse(val))),
                    ]
                  ),
                  Row(
                    children: [
                      Expanded(child: GridTextField(hint: 'نمره حضوری مرتبه بعد', initialValue: snap.data.noh2.toString(), numberonly: true, notempty: true, onChange: (val)=>snap.data.noh2=int.tryParse(val))),
                      SizedBox(width: 5),
                      Expanded(child: GridTextField(hint: 'نمره غیر حضوری مرتبه بعد', initialValue: snap.data.nonh2.toString(), numberonly: true, notempty: true, onChange: (val)=>snap.data.nonh2=int.tryParse(val))),
                    ],
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

class ClassList extends StatelessWidget {
  final CourseBloc bloc;
  final Course course;

  ClassList({@required this.bloc, @required this.course});
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Column(
      children: [
        FormHeader(
          title: 'لیست کلاس های ${course.title}', 
          btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>bloc.newClass(course.id)),
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
          child: Form(
            key: _formKey,
            child: StreamBuilder<ClassModel>(
              stream: bloc.classblocStream$,
              builder: (context, snap){
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid(snap.data.msg);
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        final _cls = snap.data.rows[idx];
                        if (_cls.showdetail)
                          return Container(
                            height: screenHeight(context) * 0.45,
                            child: Column(
                              children: [
                                ClassRow(bloc: bloc, cls: _cls, formKey: _formKey),
                                FormHeader(
                                  title: 'تقویم آموزشی ${_cls.title}',
                                  btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>bloc.newDLCass(context, _cls.id)),
                                  btnLeft: MyIconButton(type: ButtonType.none),
                                ),
                                GridCaption(
                                  obj: [
                                    'تاریخ',
                                    'ساعت',
                                    'محل برگذاری',
                                    'نوع جلسه',
                                    'سرفصل',
                                    'استاد',
                                  ]
                                ),
                                Expanded(
                                  child: StreamBuilder<DClassModel>(
                                    stream: bloc.dclassblocStream$,
                                    builder: (ctx, snap){
                                      if (snap.hasData)
                                        if (snap.data.status == Status.error)
                                          return ErrorInGrid(snap.data.msg);
                                        else if (snap.data.status == Status.loaded)
                                          return ListView.builder(
                                            itemCount: snap.data.rows.length,
                                            itemBuilder: (ctx, idx)=>DClassRow(bloc: bloc, dcls: snap.data.rows[idx])
                                          );
                                      return Center(child: CupertinoActivityIndicator());
                                    }
                                  )
                                )
                              ],
                            ),
                          );
                        return ClassRow(bloc: bloc, cls: _cls, formKey: _formKey);
                      }
                    );
                return Center(child: CupertinoActivityIndicator());
              }
            )
          )
        ),
      ],
    );
  }
}

class ClassRow extends StatelessWidget {
  final CourseBloc bloc;
  final Class cls;
  final GlobalKey<FormState> formKey;
  ClassRow({@required this.bloc, @required this.formKey, @required this.cls});
  @override
  Widget build(BuildContext context) {
    TextEditingController _eddate = TextEditingController(text:cls.begindate);
    return MyRow(
      onDoubleTap: ()=>bloc.editClass(cls),
      children: [
        cls.edit
          ? Expanded(child: GridTextField(hint: 'عنوان کلاس', initialValue: cls.title, notempty: true, onChange: (val)=>cls.title=val))
          : '${cls.title}',
        cls.edit
          ? Expanded(child: GridTextField(hint: 'تاریخ آغاز', controller: _eddate, notempty: true, datepicker: true))
          : '${cls.begindate}',
        cls.edit
          ? Expanded(child: GridTextField(hint: 'ظرفیت حضوری', initialValue: '${cls.hozori}', onChange: (val)=>cls.hozori=int.tryParse(val)))
          : '${cls.hozori}',
        cls.edit
          ? Expanded(child: GridTextField(hint: 'ظرفیت غیر حضوری', initialValue: '${cls.nothozori}', onChange: (val)=>cls.nothozori=int.tryParse(val)))
          : '${cls.nothozori}',
        cls.edit
          ? Container(width: 32)
          : MyIconButton(type: ButtonType.other, icon: Icon(Icons.category, color: Colors.grey.shade600,), hint: 'تقویم آموزشی', onPressed: ()=>bloc.loadDClass(context, cls)),
        cls.edit
          ? MyIconButton(type: ButtonType.save, onPressed: (){cls.begindate=_eddate.text; if (formKey.currentState.validate())bloc.saveClass(context, cls);})
          : MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delClass(context, cls))
      ]
    );
  }
}

class ClassDetail extends StatelessWidget {
  final Class cls;
  final CourseBloc bloc;
  ClassDetail({@required this.bloc, @required this.cls});

  @override
  Widget build(BuildContext context) {
    final _eddate = TextEditingController();
    Bloc<int> _topic = Bloc<int>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(
              title: 'تقویم آموزشی ${cls.title}',
              btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>bloc.newDLCass(context, this.cls.id)),
            ),
            GridCaption(
              obj: [
                'تاریخ',
                'ساعت',
                'محل برگذاری',
                'نوع جلسه',
                'سرفصل',
                'استاد',
              ]
            ),
            Expanded(
              child: StreamBuilder<DClassModel>(
                stream: bloc.dclassblocStream$,
                builder: (ctx, snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (ctx, idx){
                          final _dcls = snap.data.rows[idx];
                          return _dcls.edit
                            ? MyRow(
                              children: [
                                Expanded(child: GridTextField(hint: 'تاریخ', datepicker: true, controller: _eddate, notempty: true)),
                                Expanded(child: GridTextField(hint: 'ساعت', timeonly: true, notempty: true, onChange: (val)=>_dcls.time=val)),
                                Expanded(child: GridTextField(hint: 'محل برگذاری', notempty: true, onChange: (val)=>_dcls.place=val)),
                                Expanded(child: MultiChooseItem(
                                  val: _dcls.kind, 
                                  hint: 'نوع جلسه', 
                                  items: [
                                    {'id': 1, 'title': 'تدریس'},
                                    {'id': 2, 'title': 'آزمون'},
                                    {'id': 3, 'title': 'آزمون حضوری'},
                                    {'id': 4, 'title': 'آزمون غیرحضوری'},
                                  ],
                                  onChange: (val)=>bloc.changeDClassKind(_dcls, val),
                                )),
                                Expanded(child: ForeignKeyField(hint: 'سرفصل', initialValue: {'id': _dcls.topicid, 'name': _dcls.topictitle}, f2key: 'Topic', onChange: (val){
                                  print('$val');
                                  _dcls.topicid=val['id'];
                                  _dcls.topictitle=val['name'];
                                  context.read<ThemeManager>().setCompany(val['id']);
                                  _topic.setValue(1);
                                })),
                                StreamBuilder<int>(
                                  stream: _topic.stream$,
                                  builder: (context, snap){
                                    return Expanded(child: ForeignKeyField(hint: 'استاد', initialValue: {'id': _dcls.peopid, 'name': _dcls.peopfamily}, f2key: 'TopicTeacher', onChange: (val){_dcls.peopid=val['id'];_dcls.peopfamily=val['name'];}));
                                  }
                                ),
                                MyIconButton(type: ButtonType.save, onPressed: ()=>bloc.saveDClass(context, _dcls)),
                              ]
                            )
                            : MyRow(
                              children: [
                                '${_dcls.date}',
                                '${_dcls.time}',
                                '${_dcls.place}',
                                '${_dcls.kindName()}',
                                '${_dcls.topictitle}',
                                '${_dcls.peopfamily}',
                                MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delDClass(context, _dcls))
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

class DClassRow extends StatelessWidget {
  
  final DClass dcls;
  final CourseBloc bloc;

  DClassRow({@required this.bloc, @required this.dcls});
  
  @override
  Widget build(BuildContext context) {
    final _eddate = TextEditingController(text: dcls.date);
    Bloc<int> _topic = Bloc<int>();
    return Container(
      width: screenWidth(context) * 0.5,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MyRow(
          onDoubleTap: ()=>bloc.editDCLass(context, dcls),
          children: [
            dcls.edit
              ? Expanded(child: GridTextField(hint: 'تاریخ', datepicker: true, controller: _eddate, notempty: true))
              : '${dcls.date}',
            dcls.edit
              ? Expanded(child: GridTextField(hint: 'ساعت', initialValue: dcls.time, timeonly: true, notempty: true, onChange: (val)=>dcls.time=val))
              : '${dcls.time}',
            dcls.edit
              ? Expanded(child: GridTextField(hint: 'محل برگذاری', initialValue: dcls.place, notempty: true, onChange: (val)=>dcls.place=val))
              : '${dcls.place}',
            dcls.edit
              ? Expanded(child: MultiChooseItem(
                  val: dcls.kind, 
                  hint: 'نوع جلسه', 
                  items: [
                    {'id': 1, 'title': 'تدریس'},
                    {'id': 2, 'title': 'آزمون'},
                    {'id': 3, 'title': 'آزمون حضوری'},
                    {'id': 4, 'title': 'آزمون غیرحضوری'},
                  ],
                  onChange: (val)=>bloc.changeDClassKind(dcls, val),
                ))
              : '${dcls.kindName()}',
            dcls.edit
              ? Expanded(child: ForeignKeyField(hint: 'سرفصل', initialValue: {'id': dcls.topicid, 'name': dcls.topictitle}, f2key: 'Topic', onChange: (val){
                  dcls.topicid=val['id'];
                  dcls.topictitle=val['name'];
                  context.read<ThemeManager>().setCompany(val['id']);
                  _topic.setValue(1);
                }))
              : '${dcls.topictitle}',
            dcls.edit
              ? StreamBuilder<int>(
                  stream: _topic.stream$,
                  builder: (context, snap){
                    return Expanded(child: ForeignKeyField(hint: 'استاد', initialValue: {'id': dcls.peopid, 'name': dcls.peopfamily}, f2key: 'TopicTeacher', onChange: (val){dcls.peopid=val['id'];dcls.peopfamily=val['name'];}));
                  }
                )
              : '${dcls.peopfamily}',
            dcls.edit
              ? MyIconButton(type: ButtonType.save, onPressed: (){dcls.date=_eddate.text; bloc.saveDClass(context, dcls);})
              : MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delDClass(context, dcls))
          ],
        ),
      ),
    );
  }
}




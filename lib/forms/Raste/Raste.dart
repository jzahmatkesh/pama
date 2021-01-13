import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import '../Attach/Attach.dart';
import 'RasteBloc.dart';

class FMRaste extends StatelessWidget {
  const FMRaste({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RasteBloc _rasteBloc = RasteBloc()..loadData(context);
    final _debouncer = Debouncer(milliseconds: 500);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          FormHeader(
            title: 'مدیریت رسته ها', 
            btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>showFormAsDialog(context: context, form: FmEdit(rastebloc: _rasteBloc, rst: new Raste(cmpid: 0, isic: 0, old: 0, name: "", cmpname: "", active: true, kind: 1, mosavabeno: 0, pricekind: 1)))),
            btnLeft: MyIconButton(type: ButtonType.reload, onPressed: () => _rasteBloc.loadData(context)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal:25),
            height: 75,
            child: GridTextField(hint: 'جستجو بر اساس کد / عنوان / عنوان اتحادیه', onChange: (val) => _debouncer.run(() => _rasteBloc.searchRaste(val))),
          ),
          GridCaption(obj: ['آیسیک', 'عنوان رسته', '', '', 'عنوان اتحادیه', '','', 'نوع فعالیت', 'مصوبه صندوق', 'نرخ گذاری']),
          Expanded(
            child: StreamBuilder(
              stream: _rasteBloc.rasteblocStream$,
              builder: (BuildContext context, AsyncSnapshot<RasteModel> snap){
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid(snap.data.msg);
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (BuildContext context, int idx){
                        Raste _raste = snap.data.rows[idx];
                        if (!_raste.searched)
                          return Container();
                        return Card(
                          color: idx.isEven && !_raste.showdraste ? appbarColor(context) : Colors.transparent,
                          child:  _raste.showdraste 
                            ? Column(
                              children: [
                                Card(color: accentcolor(context).withOpacity(0.5), child: BuildRasteRow(raste: _raste, rasteBloc: _rasteBloc)),
                                GridCaption(
                                  obj: [
                                    MyIconButton(type: ButtonType.other, hint: 'زیر رسته جدید', icon: Icon(CupertinoIcons.plus_app), onPressed: () => showFormAsDialog(context: context, form: FmEditDRaste(rastebloc: _rasteBloc, rst: new DRaste(cmpid: _raste.cmpid, hisic: _raste.isic, isic: 0, old: 0, name: "", cmpname: _raste.cmpname, mosavabeno: 0, active: true)))),
                                    'کد آیسیک زیر رسته','عنوان زیر رسته','عنوان اتحادیه','مصوبه صندوق',
                                    MyIconButton(type: ButtonType.exit, onPressed: () => _rasteBloc.hideDRaste(_raste.isic)),
                                  ], 
                                  endbuttons: 0,
                                ),
                                Container(
                                  height: 300,
                                  child: StreamBuilder(
                                    stream: _rasteBloc.drasteblocStream$,
                                    builder: (BuildContext context, AsyncSnapshot<DRasteModel> snapshot){
                                      if (snapshot.hasData)
                                        if (snapshot.data.status == Status.error)
                                          return ErrorInGrid(snapshot.data.msg);
                                        else if (snapshot.data.status == Status.loaded)
                                          return ListView.builder(
                                            itemCount: snapshot.data.rows.length,
                                            itemBuilder: (context, idx){
                                              return Card(
                                                child: GestureDetector(
                                                  onDoubleTap: ()=> showFormAsDialog(context: context, form: FmEditDRaste(rastebloc: _rasteBloc, rst: snapshot.data.rows[idx])),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(3.0),
                                                    child: Row(
                                                      children: [
                                                        Switch(value: snapshot.data.rows[idx].active, onChanged: (val)=> _rasteBloc.setDRasteActive(context, snapshot.data.rows[idx].isic, val)),
                                                        SizedBox(width: 25),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Text('${snapshot.data.rows[idx].isic}'),    
                                                              Text('/'),
                                                              Text('${snapshot.data.rows[idx].hisic}'),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 75,),
                                                        Expanded(child: Text('${snapshot.data.rows[idx].name}')),    
                                                        Expanded(child: Text('${snapshot.data.rows[idx].cmpname}')),    
                                                        Expanded(child: Text('${snapshot.data.rows[idx].mosavabeno}')),    
                                                        MyIconButton(type: ButtonType.attach, onPressed: () => showFormAsDialog(context: context, form: FmAttach(title: 'فایلهای ضمیمه ${snapshot.data.rows[idx].name}', tag: 'DRaste', id1: snapshot.data.rows[idx].hisic, id2: snapshot.data.rows[idx].isic))),
                                                        MyIconButton(type: ButtonType.del, onPressed: () => _rasteBloc.delDraste(context, snapshot.data.rows[idx]))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          );
                                        return CupertinoActivityIndicator();
                                    }
                                  ),
                                )  
                              ],
                            )
                            : BuildRasteRow(raste: _raste, rasteBloc: _rasteBloc),
                        );
                      }
                    );
                return CupertinoActivityIndicator();
              }
            )
          )
        ],
      )
    );
  }
}

class BuildRasteRow extends StatelessWidget {
  const BuildRasteRow({
    Key key,
    @required this.raste,
    @required this.rasteBloc,
  }) : super(key: key);

  final Raste raste;
  final RasteBloc rasteBloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: ()=>showFormAsDialog(context: context, form: FmEdit(rastebloc: rasteBloc, rst: raste)),
      onTap: ()=> rasteBloc.showDRaste(context, raste.isic),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            Switch(value: raste.active, onChanged: (val) => rasteBloc.setActive(context, val, raste.isic)),
            Expanded(child: Text('${raste.isic}')),
            Expanded(flex: 3, child: Text('${raste.name}')),
            Expanded(flex: 3, child: Text('${raste.cmpname}')),
            Expanded(child: Text('${raste.kindName()}')),
            Expanded(child: Text('${raste.mosavabeno}')),
            Expanded(child: Text('${raste.priceName()}')),
            PopupMenuButton(
              tooltip: 'تنظیمات',
              itemBuilder: (_) => <PopupMenuItem<int>>[
                myPopupMenuItem(icon: Icons.supervised_user_circle, title: 'زیر رسته', value: 1),
                myPopupMenuItem(icon: Icons.people, title: 'حذف رسته', value: 2),
                myPopupMenuItem(icon: Icons.attach_file, title: 'بارگذاری فایل', value: 3),
              ],
              onSelected: (int idx) async{
                if (idx == 1)
                  rasteBloc.showDRaste(context, raste.isic);
                else if (idx == 2)
                  rasteBloc.delraste(context, raste);
                else if (idx == 3)
                  showFormAsDialog(context: context, form: FmAttach(title: 'فایلهای ضمیمه ${raste.name}', tag: 'Raste', id1: raste.isic));
              }
            ),
          ],
        ),
      ),
    );
  }
}

class FmEdit extends StatelessWidget {
  const FmEdit({Key key, @required this.rastebloc, @required this.rst}) : super(key: key);

  final RasteBloc rastebloc;
  final Raste rst;

  @override
  Widget build(BuildContext context) {
    rastebloc.newraste(rst);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.4,
        child: StreamBuilder(
          stream: rastebloc.newrasteStream$,
          builder: (BuildContext context, AsyncSnapshot<Raste> snapshot){
            if (snapshot.hasData){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormHeader(title: 'تعریف/ویرایش اطلاعات رسته', btnRight: MyIconButton(type: ButtonType.save, onPressed: () => rastebloc.saveRaste(context, snapshot.data))),
                  Card(
                    child: Row(
                      children: [
                        Expanded(child: GridTextField(hint: 'کد آیسیک', onChange: (val){snapshot.data.isic = int.parse(val);}, initialValue: snapshot.data.isic.toString())),
                        Expanded(child: GridTextField(hint: 'عنوان رسته', onChange: (val){snapshot.data.name = val;}, initialValue: snapshot.data.name)),
                      ],
                    ),
                  ),
                  Card(
                    child: ForeignKeyField(hint: 'عنوان اتحادیه', initialValue: {'id': snapshot.data.cmpid, 'name': snapshot.data.cmpname}, f2key: 'Company', onChange: (val){if (val != null){snapshot.data.cmpid = val['id'];snapshot.data.cmpname = val['name'];}})
                  ),
                  Card(
                    child: Row(
                      children: [
                        Expanded(child: GridTextField(hint: 'شماره مصوبه صندوق', onChange: (val){snapshot.data.mosavabeno=int.parse(val);}, initialValue: snapshot.data.mosavabeno.toString())),
                        Expanded(
                          child: MultiChooseItem(
                            hint: 'نوع فعالیت', 
                            val: snapshot.data.kind, 
                            items: [
                              {'id': 1, 'title': 'تولیدی'},
                              {'id': 2, 'title': 'توزیعی'},
                              {'id': 3, 'title': 'خدماتی'},
                              {'id': 4, 'title': 'خدمات فنی'},
                            ],
                            onChange: (val){rastebloc.setRasteKind(val);},
                          )
                        ),
                        Expanded(
                          child: MultiChooseItem(
                            hint: 'مشمول نرخ گذاری', 
                            val: snapshot.data.pricekind, 
                            items: [
                              {'id': 1, 'title': 'الف'},
                              {'id': 2, 'title': 'ب'},
                              {'id': 3, 'title': 'ج'},
                            ],
                            onChange: (val){rastebloc.setRastePriceKind(val);},
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(child: CupertinoActivityIndicator.partiallyRevealed(),);
          }
        ),
      )
    );
  }
}

class FmEditDRaste extends StatelessWidget {
  const FmEditDRaste({Key key, @required this.rastebloc, @required this.rst}) : super(key: key);

  final RasteBloc rastebloc;
  final DRaste rst;

  @override
  Widget build(BuildContext context) {
    rastebloc.newdraste(rst);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.4,
        child: StreamBuilder(
          stream: rastebloc.newdrasteblocStream$,
          builder: (BuildContext context, AsyncSnapshot<DRaste> snapshot){
            if (snapshot.hasData){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormHeader(title: 'تعریف/ویرایش اطلاعات رسته', btnRight: MyIconButton(type: ButtonType.save, onPressed: () => rastebloc.saveDRaste(context, snapshot.data))),
                  Card(
                    child: Row(
                      children: [
                        GridTextField(hint: 'کد آیسیک', onChange: (val){snapshot.data.isic = int.parse(val);}, initialValue: snapshot.data.isic.toString(), width: 100,),
                        Text('${rst.hisic} /'),
                        SizedBox(width: 15),
                        Expanded(child: GridTextField(hint: 'عنوان رسته', onChange: (val){snapshot.data.name = val;}, initialValue: snapshot.data.name)),
                      ],
                    ),
                  ),
                  Card(
                    child: Row(
                      children: [
                        Expanded(child: ForeignKeyField(hint: 'عنوان اتحادیه', initialValue: {'id': snapshot.data.cmpid, 'name': snapshot.data.cmpname}, f2key: 'Company', onChange: (val){if (val != null){snapshot.data.cmpid = val['id'];snapshot.data.cmpname = val['name'];}})),
                        Expanded(child: GridTextField(hint: 'شماره مصوبه صندوق', onChange: (val){snapshot.data.mosavabeno=int.parse(val);}, initialValue: snapshot.data.mosavabeno.toString())),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(child: CupertinoActivityIndicator.partiallyRevealed(),);
          }
        ),
      )
    );
  }
}




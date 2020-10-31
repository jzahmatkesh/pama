import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../classes/classes.dart';
import 'NoLicenseBloc.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import '../../module/theme-Manager.dart';
import 'package:provider/provider.dart';

class FmNoLicense extends StatelessWidget {
  const FmNoLicense({Key key, @required this.cmp}) : super(key: key);

  final Company cmp;

  @override
  Widget build(BuildContext context) {
    NoLicenseBloc _bloc = NoLicenseBloc()..load(context, cmp.id);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.85,
        height: screenHeight(context) * 0.85,
        child: Column(
          children: [
            FormHeader(
              title: 'فهرست فاقدین پروانه شناسایی شده ${cmp.name}', 
              btnRight: MyIconButton(
                type: this.cmp.id==0 ? ButtonType.none : ButtonType.add, 
                onPressed: (){
                  context.read<ThemeManager>().setCompany(this.cmp.id);
                  showFormAsDialog(context: context, form: NewNoLicense(bloc: _bloc, lcn: new Nolicense(cmpid: this.cmp.id, id: 0, isic: 0, note: '')));
                }
              ),
              btnLeft: this.cmp.id==0 ? MyIconButton(
                type: ButtonType.reload, 
                onPressed: ()=>_bloc.load(context, cmp.id)
              ) : null
            ),
            this.cmp.id == 0
              ? GridCaption(obj: ['عنوان اتحادیه','کد ملی','نام و نام خانوادگی','کد آیسیک','تلفن','کد پستی','کد نوسازی شهرسازی','نشانی','','توضیحات اجراییات',''])
              : GridCaption(obj: ['کد ملی','نام و نام خانوادگی','کد آیسیک','تلفن','کد پستی','کد نوسازی شهرسازی','نشانی','','توضیحات اجراییات','']),          
            GridTextField(hint: 'جستجو ...', onChange: (val)=>_bloc.search(val)),
            Expanded(
              child: StreamBuilder(
                stream: _bloc.nolicenseStream$,
                builder: (BuildContext context, AsyncSnapshot<NoLicenseModel> snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (context, idx){
                          Nolicense _lcn = snap.data.rows[idx];
                          if (_lcn.inSearch)
                            return Card(
                              child: Padding(
                                padding: _lcn.note.isEmpty ? EdgeInsets.symmetric(horizontal: 8) : EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                                child: GestureDetector(
                                  onDoubleTap: (){
                                    if (_lcn.note.isEmpty){
                                      context.read<ThemeManager>().setCompany(this.cmp.id);
                                      showFormAsDialog(context: context, form: NewNoLicense(bloc: _bloc, lcn: _lcn));
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      this.cmp.id==0 
                                        ? Expanded(child: Text('${_lcn.cmpname}'))
                                        : Container(),
                                      Expanded(child: Text('${_lcn.nationalid}')),
                                      Expanded(child: Text('${_lcn.name} ${_lcn.family}')),
                                      Expanded(child: Text("${_lcn.isicname}")),
                                      Expanded(child: Text('${_lcn.tel}')),
                                      Expanded(child: Text('${_lcn.post}')),
                                      Expanded(child: Text('${_lcn.nosazicode}')),
                                      Expanded(flex: 2, child: Text('${_lcn.address}')),
                                      Expanded(flex: 2, child: Text('${_lcn.note}', softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 2)),
                                      this.cmp.id == 0
                                        ? MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.doc_plaintext), hint: 'ثبت توضیحات', onPressed: ()=>showFormAsDialog(context: context, form: EditNote(bloc: _bloc, lcn: _lcn)))
                                        : _lcn.note.isEmpty 
                                          ? MyIconButton(type: ButtonType.del, onPressed: () => _bloc.delete(context, _lcn)) 
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                            );
                          return Container(height: 0);
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

class NewNoLicense extends StatelessWidget {
  const NewNoLicense({Key key, @required this.bloc, @required this.lcn}) : super(key: key);

  final NoLicenseBloc bloc;
  final Nolicense lcn;

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    TextEditingController _name = TextEditingController(text: lcn.name);
    TextEditingController _family = TextEditingController(text: lcn.family);
    return Container(
      width: screenWidth(context) * 0.65,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(
                title: 'تعریف/ویرایش اطلاعات فاقدین پروانه', 
                btnRight: MyIconButton(
                  type: ButtonType.save, 
                  onPressed: (){
                    if (_formkey.currentState.validate()){
                      lcn.name = _name.text;
                      lcn.family = _family.text;
                      bloc.save(context, lcn);
                    }
                  }
                )
              ),
              SizedBox(height: 10.0,),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'کد ملی', initialValue: lcn.nationalid, onChange: (val) async{
                    var _data = await bloc.checkNationlID(context, val);
                    if (_data != null && val.isNotEmpty){
                      _name.text = _data['name'];
                      _family.text = _data['family'];
                    }
                    else{
                      _name.text = lcn.name ?? "";
                      _family.text = lcn.family ?? "";
                    }
                    lcn.nationalid=val;
                  }, autofocus: true, notempty: true)),
                  Expanded(child: GridTextField(hint: 'نام', controller: _name, notempty: true)),
                  Expanded(child: GridTextField(hint: 'نام خانوادگی', controller: _family, notempty: true)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: ForeignKeyField(hint: 'کد آیسیک', initialValue: {'hisic': lcn.hisic, 'isic': lcn.isic, 'name': lcn.isicname}, onChange: (val){if (val != null){lcn.hisic=val['hisic'];lcn.isic=val['isic'];lcn.isicname=val['name'];}}, f2key: 'Raste',)),
                  Expanded(child: GridTextField(hint: 'تلفن', initialValue: lcn.tel, onChange: (val)=>lcn.tel=val, notempty: true)),
                  Expanded(child: GridTextField(hint: 'کد پستی', initialValue: lcn.post, onChange: (val)=>lcn.post=val, notempty: true)),
                  Expanded(child: GridTextField(hint: 'کد نوسازی شهرداری', initialValue: lcn.nosazicode, onChange: (val)=>lcn.nosazicode=val)),
                ],
              ),
              GridTextField(hint: 'نشانی', initialValue: lcn.address, onChange: (val)=>lcn.address=val, notempty: true)
            ],
          ),
        ),
      )
    );
  }
}

class EditNote extends StatelessWidget {
  const EditNote({Key key, @required this.bloc, @required this.lcn}) : super(key: key);

  final NoLicenseBloc bloc;
  final Nolicense lcn;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.35,
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(title: 'ثبت/ویرایش توضیحات اجراییات', btnRight: MyIconButton(type: ButtonType.save, onPressed: ()=>bloc.saveNote(context, lcn))),
            SizedBox(height: 15),
            MyRow(children: ['عنوان اتحادیه', '${lcn.cmpname}']),
            MyRow(children: ['کد ملی', '${lcn.nationalid}']),
            MyRow(children: ['نام و نام خانوادگی', '${lcn.name} ${lcn.family}']),
            MyRow(children: ['تلفن', '${lcn.tel}']),
            MyRow(children: ['کد آیسیک', '${lcn.isic}']),
            MyRow(children: ['نوسازی شهرسازی', '${lcn.nosazicode}']),
            SizedBox(height: 15),
            GridTextField(hint: 'توضیحات اجراییات', initialValue: lcn.note, onChange: (val)=>lcn.note=val, lines: 10,)
          ],
        ),
      ),
    );
  }
}


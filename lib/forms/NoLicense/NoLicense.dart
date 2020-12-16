import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
              title: 'فهرست فاقدین پروانه شناسایی شده ${cmp.name ?? ''}', 
              btnRight: this.cmp.id==0 ? null : Row(
                children: [
                  MyIconButton(
                    type: ButtonType.add,
                    onPressed: (){
                      context.read<ThemeManager>().setCompany(this.cmp.id);
                      showFormAsDialog(context: context, form: NewNoLicense(bloc: _bloc, lcn: new Nolicense(cmpid: this.cmp.id, id: 0, hisic: 0, isic: 0, note: '')));
                    }
                  ),
                  MyIconButton(
                    type: ButtonType.other,
                    icon: Icon(FontAwesome5.file_excel),
                    hint: 'دریافت اطلاعات از فایل اکسل',
                    onPressed: ()=>importExcel(context, readToken(context), this.cmp)
                  ),
                ],
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
                                      _lcn.isic > 0 
                                        ? Expanded(child: Tooltip(message: '${_lcn.isic} / ${_lcn.hisic}', child: Text("${_lcn.isicname}")))
                                        : Expanded(child: Tooltip(message: '${_lcn.hisic}', child: Text("${_lcn.isicname}"))),
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
                  }, autofocus: true)),
                  Expanded(child: GridTextField(hint: 'نام', controller: _name, notempty: true)),
                  Expanded(child: GridTextField(hint: 'نام خانوادگی', controller: _family, notempty: true)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: ForeignKeyField(hint: 'کد آیسیک', initialValue: {'hisic': lcn.hisic, 'isic': lcn.isic, 'name': lcn.isicname}, onChange: (val){if (val != null){lcn.hisic=val['hisic'];lcn.isic=val['isic'];lcn.isicname=val['name'];}}, f2key: 'Raste',)),
                  Expanded(child: GridTextField(hint: 'تلفن', initialValue: lcn.tel, onChange: (val)=>lcn.tel=val, notempty: true)),
                  Expanded(child: GridTextField(hint: 'کد پستی', initialValue: lcn.post, onChange: (val)=>lcn.post=val)),
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

void importExcel(BuildContext context, String token, Company comp) async{
  FilePickerResult result = await FilePicker.platform.pickFiles();
  if(result != null) {
    var bytes = result.files.first.bytes;//file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    showFormAsDialog(context: context, form: FmImportExcel(excel: excel, token: token, cmp: comp));
  }
}
class FmImportExcel extends StatelessWidget {
  const FmImportExcel({Key key, @required this.cmp, @required this.excel, @required this.token}) : super(key: key);

  final Excel excel;
  final String token;
  final Company cmp;

  @override
  Widget build(BuildContext context) {
    var table  = excel.tables.keys.first;
    bool nationalid = false, name = false, family = false, hisic = false, isic = false, tel = false, post = false, nosazi = false, address = false;
    excel.tables[table].rows[0].forEach((element) {
      nationalid = nationalid || element.toString().trim() =="کد ملی";
      name = name || element.toString().trim() =="نام";
      family = family || element.toString().trim() =="نام خانوادگی";
      hisic = hisic || element.toString().trim() =="رسته";
      isic = isic || element.toString().trim() =="زیر رسته";
      tel = tel || element.toString().trim() =="تلفن";
      post = post || element.toString().trim() =="کدپستی";
      nosazi = nosazi || element.toString().trim() =="کد نوسازی";
      address = address || element.toString().trim() =="آدرس";
    });
    ExcelBloc _excelBloc = ExcelBloc(rows: excel.tables[table].rows);
    
    void importFromExcel() async{
      bool res, messaged = false;
      try{
        showWaiting(context);
        if (_excelBloc.value.where((element) => (element.check ?? false) && !element.imported).length == 0)
          myAlert(context: context, title: 'هشدار', message: 'رکوردی انتخاب نشده است');
        else{
          _excelBloc.value.asMap().forEach((idx, element) async{
            if (idx > 0 && (element.check ?? false) && !element.imported){
              if ((res ?? true))
                if (!(element.cells[3] is int))
                  _excelBloc.checkRow(idx, null, error: '${element.cells[3]} عددی نیست و قابل درج در رسته نمی باشد'); 
                else if (!(element.cells[4] is int))
                  _excelBloc.checkRow(idx, null, error: '${element.cells[4]} عددی نیست و قابل درج در زیر رسته نمی باشد');
                else{
                  res = await _excelBloc.exportToDB(
                    context: context, 
                    api: 'Coding/ImportExcel', 
                    lcn: Nolicense(
                      token: this.token,
                      cmpid: cmp.id,
                      cmpname: cmp.name,
                      nationalid: '${element.cells[0]}',
                      name: '${element.cells[1]}',
                      family: '${element.cells[2]}',
                      hisic: element.cells[3],
                      isic: element.cells[4],
                      tel: '${element.cells[5]}',
                      post: '${element.cells[6]}',
                      nosazicode: '${element.cells[7]}',
                      address: '${element.cells[8]}',
                      id: 0,
                    )
                  );
                  if (res)
                    _excelBloc.imported(idx);
                  if (_excelBloc.value.where((element) => !element.imported).length == 1 && !messaged){
                    messaged = true;
                    Navigator.of(context).pop();
                    myAlert(context: context, title: 'موفقیت آمیز', message: '${_excelBloc.value.where((element) => element.imported).length} رکورد با موفقیت در بانک  اطلاعاتی درج گردید', color: Colors.green);
                  }
                }
            }
          });
        }
      }
      finally{
        hideWaiting(context);
      }
    }
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.75,
        height: screenHeight(context) * 0.75,
        child: Column(
          children: [
            FormHeader(title: 'دریافت اطلاعات از اکسل', btnLeft: MyIconButton(type: ButtonType.exit), btnRight: nationalid && post && name && family && tel && hisic && isic && nosazi && address ? MyIconButton(type: ButtonType.other, hint: 'درج ردیف های انتخابی در بانک اطلاعات', icon: Icon(CupertinoIcons.layers_alt), onPressed: ()=>importFromExcel()) : null,),
            SizedBox(height: 15),
            !nationalid && !name && !family && !tel && !post && !hisic && !isic && !nosazi && !address ? Container(width: screenWidth(context) * 0.65 > 600 ? 600 : screenWidth(context) * 0.50, child: Image(image: AssetImage('images/excel-coding.png'),)) : Container(),
            SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<List<ExcelRow>>(
                stream: _excelBloc.stream$, 
                builder: (context, snap)=> snap.connectionState==ConnectionState.active ? ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (context, idx)=>snap.data[idx].imported ? Container() : Container(
                    color: snap.data[idx].error != null ? Colors.red.withOpacity(0.15) : null,
                    child: Card(
                      child: Row(
                        children: [
                          nationalid && name && family && tel && post && hisic && isic && nosazi && address 
                            ? snap.data[idx].error != null 
                              ? Padding(padding: const EdgeInsets.all(4.0),child: Tooltip(message: '${snap.data[idx].error}', child: Icon(CupertinoIcons.xmark_square, color: Colors.red))) 
                              : Checkbox(value: snap.data[idx].check, onChanged: (val)=>_excelBloc.checkRow(idx, val)) 
                            : Container(height: 38,),
                          SizedBox(width: 10),
                          ... snap.data[idx].cells.map((e) =>  idx == 0
                            ? snap.data[idx].cells.indexOf(e)==0 && !nationalid 
                              ? Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))]))
                              : snap.data[idx].cells.indexOf(e)==1 && !name
                                ? Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))]))
                                : snap.data[idx].cells.indexOf(e)==2 && !family 
                                  ? Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))]))
                                  : snap.data[idx].cells.indexOf(e)==3 && !hisic 
                                    ? Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))]))
                                    : snap.data[idx].cells.indexOf(e)==4 && !isic 
                                      ? Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))]))
                                      : snap.data[idx].cells.indexOf(e)==5 && !tel 
                                        ? Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))]))
                                        : snap.data[idx].cells.indexOf(e)==6 && !post 
                                          ? Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))]))
                                          : snap.data[idx].cells.indexOf(e)==7 && !nosazi
                                            ? Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))]))
                                            : snap.data[idx].cells.indexOf(e)==8 && !address 
                                              ? Expanded(child: Row(children: [Tooltip(message: 'عنوان فیلد صحیح نمی باشد به فایل اکسل نمونه توجه فرمایید', child: Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red, size: 14)), SizedBox(width: 5), Expanded(child: Text('$e'))]))
                                              : Expanded(child: Text('$e'))
                            : Expanded(child: Text('$e'))
                          )
                        ]
                      ),
                    ),
                  )
                ) : Center(child: CupertinoActivityIndicator(),)
              ),
            )
          ],
        ),
      ),
    );
  }
}
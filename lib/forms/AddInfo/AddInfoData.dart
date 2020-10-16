import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import 'AddInfoBloc.dart';
import 'AddInfoDataBloc.dart';

class FmAddInfoData extends StatelessWidget {
  const FmAddInfoData({Key key, @required this.title, @required this.url, @required this.header}) : super(key: key);

  final String title;
  final String url;
  final Map<String, String> header;

  @override
  Widget build(BuildContext context) {
    AddinfoDataBloc _addinfoDataBloc = new AddinfoDataBloc()..loadData(context, this.url, this.header);

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.75,
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(title: this.title, btnRight: MyIconButton(type: ButtonType.add, onPressed: () => showFormAsDialog(context: context, form: NewAddInfoData(addinfodataBloc: _addinfoDataBloc, url: this.url, header: this.header,)))),
            GridCaption(obj: ['عنوان اطلاعات تکمیلی', 'توضیحات']),
            Expanded(
              child: StreamBuilder(
                stream: _addinfoDataBloc.addinfoDataStream$,
                builder: (BuildContext context, AsyncSnapshot<AddInfoDataModel> snapshot){
                  if (snapshot.hasData)
                    if (snapshot.data.status == Status.error)
                      return ErrorInGrid(snapshot.data.msg);
                    else if (snapshot.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snapshot.data.rows.length,
                        itemBuilder: (context, idx){
                          AddInfoData _addinfo = snapshot.data.rows[idx];
                          return Card(
                            child: GestureDetector(
                              onDoubleTap: () => _addinfoDataBloc.setEdit(_addinfo),
                              child: Row(
                                children: [
                                  SizedBox(width: 5.0,),
                                  Expanded(child: Text(_addinfo.name)),
                                  Expanded(child: _addinfo.edit ? EditValue(addinfodataBloc: _addinfoDataBloc, addinfo: _addinfo, url: this.url, header: this.header,) : Text(_addinfo.kind==4 ? _addinfo.note=="1" ? "بلی" : "خیر" : _addinfo.note)),
                                  _addinfo.edit ? Container() : MyIconButton(type: ButtonType.del, onPressed: () => _addinfoDataBloc.delData(context, _addinfo, this.url, this.header)),
                                ],
                              ),
                            ),
                          );
                        }
                      );
                  return Center(child: CupertinoActivityIndicator());
                }
              )
            )
          ],
        ),
      )
    );
  }
}

class EditValue extends StatelessWidget {
  const EditValue({Key key, @required this.addinfodataBloc, @required this.addinfo, @required this.url, @required this.header}) : super(key: key);

  final AddinfoDataBloc addinfodataBloc;
  final AddInfoData addinfo;
  final String url;
  final Map<String, String> header;

  @override
  Widget build(BuildContext context) {
    TextEditingController _dateController = TextEditingController(text: this.addinfo.note);

    return Row(
      children: [
        this.addinfo.kind == 4
          ? Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              FilterChip(label: Text('بلی'), onSelected: (val) => addinfodataBloc.newData(context, this.addinfo.kind, this.addinfo.addid, this.addinfo.name, '1', this.url, this.header, pop: false), padding: EdgeInsets.all(12.0), backgroundColor: Colors.greenAccent,),
              SizedBox(width: 5.0,),
              FilterChip(label: Text('خیر'), onSelected: (val) => addinfodataBloc.newData(context, this.addinfo.kind, this.addinfo.addid, this.addinfo.name, '0', this.url, this.header, pop: false), padding: EdgeInsets.all(12.0), backgroundColor: Colors.deepOrangeAccent,),
            ],
          )
          : GridTextField(hint: 'مقدار اطلاعات تکمیلی', datepicker: this.addinfo.kind == 3, controller: _dateController, width: this.addinfo.kind==1 ? 350 : 150.0, autofocus: true, numberonly: this.addinfo.kind==2,),
        Spacer(),
        this.addinfo.kind==4 ? Container() : MyIconButton(type: ButtonType.save, onPressed: ()=> addinfodataBloc.newData(context, this.addinfo.kind, this.addinfo.addid, this.addinfo.name, _dateController.text, this.url, this.header, pop: false))
      ],
    );
  }
}

class NewAddInfoData extends StatelessWidget {
  const NewAddInfoData({Key key, @required this.addinfodataBloc, @required this.url, @required this.header}) : super(key: key);

  final AddinfoDataBloc addinfodataBloc;
  final String url;
  final Map<String, String> header;

  @override
  Widget build(BuildContext context) {
    AddInfoBloc _addinfoBloc = AddInfoBloc()..loadData(context);
    TextEditingController _dateController = TextEditingController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(title: 'اطلاعات تکمیلی مورد را انتخاب نمایید'),
            Container(
              padding: EdgeInsets.all(8.0),
              child: GridTextField(hint: 'جستجو', onChange: (val) => _addinfoBloc.search(val),),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _addinfoBloc.addinfoStream$,
                builder: (BuildContext context, AsyncSnapshot<AddInfoModel> snapshot){
                  if (snapshot.hasData)
                    if (snapshot.data.status == Status.error)
                      return ErrorInGrid(snapshot.data.msg);
                    else if (snapshot.data.status == Status.loaded)
                      return Container(
                        height: screenHeight(context) *.50,
                        child: ListView.builder(
                          itemCount: snapshot.data.rows.length,
                          itemBuilder: (context, idx){
                            AddInfo _add = snapshot.data.rows[idx];
                            bool valid = false;
                            addinfodataBloc.rows$.forEach((element) {if (element.addid == _add.id) valid = true;});
                            if (!valid && _add.insearch)
                              return Card(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text(_add.name),
                                        subtitle: Text(_add.kindName()),
                                        onTap: (){_dateController.text=""; _addinfoBloc.setMode(context, _add.id, 1);}
                                      ),
                                    ),
                                    _add.edit 
                                      ? _add.kind == 4 
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min, 
                                            children: [
                                              FilterChip(label: Text('بلی'), onSelected: (val) => addinfodataBloc.newData(context, _add.kind, _add.id, _add.name, '1', this.url, this.header), padding: EdgeInsets.all(12.0), backgroundColor: Colors.greenAccent,),
                                              SizedBox(width: 5.0,),
                                              FilterChip(label: Text('خیر'), onSelected: (val) => addinfodataBloc.newData(context, _add.kind, _add.id, _add.name, '0', this.url, this.header), padding: EdgeInsets.all(12.0), backgroundColor: Colors.deepOrangeAccent,),
                                            ],
                                          )
                                        : GridTextField(hint: 'مقدار اطلاعات تکمیلی', datepicker: _add.kind == 3, controller: _dateController, width: _add.kind==1 ? 350 : 150.0, autofocus: true, numberonly: _add.kind==2,)
                                      : Container(),
                                    _add.edit && _add.kind != 4
                                      ? MyIconButton(type: ButtonType.save, onPressed: ()=> addinfodataBloc.newData(context, _add.kind, _add.id, _add.name, _dateController.text, this.url, this.header))
                                      : Container()
                                  ],
                                ),
                              );
                            return Container();
                          }
                        ),
                      );
                  return Center(child: CupertinoActivityIndicator(),);
                }
              )
            )
          ],
        )
      ),
    );
  }
}

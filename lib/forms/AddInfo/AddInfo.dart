import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import 'AddInfoBloc.dart';

class FmAddInfo extends StatelessWidget {
  const FmAddInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddInfoBloc _addInfoBloc = AddInfoBloc()..loadData(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FormHeader(
              title: 'اطلاعات تکمیلی', 
              btnRight: MyIconButton(type: ButtonType.add, onPressed: () => _addInfoBloc.newAddInfo()),
              btnLeft: MyIconButton(type: ButtonType.reload, onPressed: () => _addInfoBloc.loadData(context)),
            ),
            SizedBox(height: 10.0,),
            GridCaption(obj: ['عنوان اطلاعات تکمیلی', '', 'نوع'], endbuttons: 4,),
            Expanded(
              child: StreamBuilder(
                stream: _addInfoBloc.addinfoStream$,
                builder: (BuildContext context, AsyncSnapshot<AddInfoModel> snapshot){
                  if (snapshot.hasData)
                    if (snapshot.data.status == Status.error)
                      return ErrorInGrid(snapshot.data.msg);
                    else if (snapshot.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snapshot.data.rows.length,
                        itemBuilder: (context, idx){
                          AddInfo _add = snapshot.data.rows[idx];
                          return Card(
                            color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                            child: ! _add.notes && ! _add.forms 
                              ? AddInfoRow(add: _add, addInfoBloc: _addInfoBloc)
                              : Container(
                                height: 450.0,
                                child: Column(
                                  children: [
                                    Card(color: accentcolor(context).withOpacity(0.5), child: AddInfoRow(add: _add, addInfoBloc: _addInfoBloc)),
                                    SizedBox(height: 10.0,),
                                    _add.notes ? AddInfoNotes(addinfo: _add, addInfoBloc: _addInfoBloc) : Container(),
                                    // _add.forms ? AddInfoForms(addInfoBloc: _addInfoBloc) : Container(),
                                  ],
                                ),
                              )
                          );
                        }
                      );
                  return Center(child: CupertinoActivityIndicator(),);
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddInfoNotes extends StatelessWidget {
  const AddInfoNotes({
    Key key,
    @required this.addinfo,
    @required this.addInfoBloc,
  }) : super(key: key);

  final AddInfo addinfo;
  final AddInfoBloc addInfoBloc;

  @override
  Widget build(BuildContext context) {
    TextEditingController eddate = TextEditingController();
    return Expanded(
      child: Column(
        children: [
          FormHeader(
            title: 'مقادیر پیش فرض ${addinfo.name}', 
            btnRight: MyIconButton(type: ButtonType.add, onPressed: () => addInfoBloc.newNote(addinfo.id)), 
            btnLeft: MyIconButton(type: ButtonType.exit, onPressed: () => addInfoBloc.setMode(context, addinfo.id, 2)),
          ),
          Expanded(
            child: StreamBuilder(
              stream: addInfoBloc.noteStream$,
              builder: (BuildContext context, AsyncSnapshot<AddInfoNoteModel> snapshot){
                if (snapshot.hasData)
                  if (snapshot.data.status == Status.error)
                    return Center(child: ErrorInGrid(snapshot.data.msg));
                  else if (snapshot.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snapshot.data.rows.length,
                      itemBuilder: (context, idx){
                        AddInfoNote _note = snapshot.data.rows[idx];
                        eddate.text = _note.note;
                        return Card(
                          color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                          child: GestureDetector(
                            onDoubleTap: () => addInfoBloc.editNote(_note),
                            child: Row(
                              children: [
                                SizedBox(width: 8.0,),
                                addinfo.kind == 3
                                  ? Expanded(child: _note.edit ? GridTextField(hint: 'تاریخ', onChange: (val) => _note.note=val, autofocus: true, datepicker: addinfo.kind==3, controller: eddate,) : Text(_note.note))
                                  : Expanded(child: _note.edit ? GridTextField(hint: 'توضیحات', initialValue: _note.note, onChange: (val) => _note.note=val, autofocus: true) : Text(_note.note)),
                                _note.edit 
                                  ? MyIconButton(
                                    type: ButtonType.save, 
                                    onPressed: (){
                                      if (addinfo.kind == 3)
                                        _note.note = eddate.text;
                                      addInfoBloc.saveNote(context, addinfo.id, _note);
                                    }, 
                                  ) 
                                  : Container(),
                                snapshot.data.rows[idx].id == 0 
                                  ? Container() 
                                  : MyIconButton(type: ButtonType.del, onPressed: () => addInfoBloc.delNote(context, addinfo.id, _note)),
                              ],
                            ),
                          ),
                        );
                      }
                    );
                return Center(child: CupertinoActivityIndicator(),);
              }
            ),
          ),
        ],
      )
    );
  }
}

class AddInfoRow extends StatelessWidget {
  const AddInfoRow({
    Key key,
    @required this.add,
    @required this.addInfoBloc
  }) : super(key: key);

  final AddInfo add;
  final AddInfoBloc addInfoBloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => addInfoBloc.setMode(context, add.id, 1),
      child: Row(
        children: [
          SizedBox(width: 8.0,),
          Expanded(flex: 2, child: add.edit ? GridTextField(hint: 'عنوان', initialValue: add.name, onChange: (val)=>add.name=val, autofocus: true) : Text('${add.name}')),
          Expanded(child: add.edit
            ? MultiChooseItem(val: add.kind, items: [{'id': 1, 'title': 'حروفی'},{'id': 2, 'title': 'عددی'},{'id': 3, 'title': 'تاریخی'},{'id': 4, 'title': 'بلی و خیر'}], hint: 'نوع', onChange: (val)=> addInfoBloc.changeKind(add.id, val)) 
            : Text('${add.kindName()}')),
          add.edit || add.kind != 2
            ? SizedBox(width: 52) 
            : Tooltip(message: 'تکرار پذیر', child: Switch(value: add.dublicate, onChanged: (val) => addInfoBloc.setdublicate(context, add, val))),
          add.edit
            ? SizedBox(width: 52)
            : add.kind==4 
              ? SizedBox(width: 52) 
              : MyIconButton(type: ButtonType.other, hint: 'مقادیر پیش فرض', icon: Icon(Icons.list), onPressed: () => addInfoBloc.setMode(context, add.id, 2)),
          add.edit
            ? SizedBox(width: 52)
            : MyIconButton(type: ButtonType.other, hint: 'برگه های اجباری', icon: Icon(Icons.list_alt_sharp), onPressed: ()  => addInfoBloc.setMode(context, add.id, 3)),
          add.edit 
            ? MyIconButton(type: ButtonType.save, onPressed: ()=> addInfoBloc.saveAddInfo(context, add)) 
            : MyIconButton(type: ButtonType.del, onPressed: () => addInfoBloc.delAddInfo(context, add)),
        ],
      ),
    );
  }
}









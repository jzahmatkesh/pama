import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import 'DocumentBloc.dart';

class FmDocument extends StatelessWidget {
  const FmDocument({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentBloc _documentBloc = DocumentBloc()..loadData(context);

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Column(
        children: [
          FormHeader(
            title: 'مدارک', 
            btnRight: MyIconButton(type: ButtonType.add, onPressed: () => _documentBloc.newDocument(context)), 
            btnLeft: MyIconButton(type: ButtonType.reload, onPressed:()=>_documentBloc.loadData(context))
          ),
          GridCaption(obj: ['عنوان مدرک', Text('تاریخ اعتبار', style: gridFieldStyle(),)]),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: StreamBuilder(
                stream: _documentBloc.documentkStream$,
                builder: (BuildContext context, AsyncSnapshot<DocumentModel> snapshot){
                  if (snapshot.hasData)
                    if (snapshot.data.status == Status.error)
                      return ErrorInGrid(snapshot.data.msg);
                    else if (snapshot.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snapshot.data.rows.length,
                        itemBuilder: (context, idx){
                          Document document = snapshot.data.rows[idx];
                          return Card(
                            color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                            child: GestureDetector(
                              onDoubleTap: () => _documentBloc.editMode(document),
                              child: Row(
                                children: [
                                  document.id == 0 || document.editing
                                    ? GridTextField(hint: 'عنوان بانک', onChange: (val) => document.name = val, initialValue: document.name, width: 350, autofocus: true,) 
                                    : Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Text(document.name),
                                        )
                                      ),
                                  document.id > 0 && !document.editing 
                                    ? Switch(value: document.expdate==1, onChanged: (val) => _documentBloc.setExpDate(context, document, val))
                                    : Container(),
                                  document.id == 0 || document.editing 
                                    ? MyIconButton(type: ButtonType.save, onPressed: () => _documentBloc.saveDocument(context, document))
                                    : MyIconButton(type: ButtonType.del, onPressed: () => _documentBloc.delDocument(context, document)),
                                ],
                              ),
                            ),
                          );
                        });
                  return Center(child: CupertinoActivityIndicator(),);
                }
              ),
            ),
          )
        ],
      )
    );
  }
}
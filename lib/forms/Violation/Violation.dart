import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import 'ViolationBloc.dart';

class FmViolation extends StatelessWidget {
  const FmViolation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ViolationBloc _vioBloc = ViolationBloc()..loadData(context);

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Column(
        children: [
          FormHeader(
            title: 'تخلفات', 
            btnRight: MyIconButton(type: ButtonType.add, onPressed: () => _vioBloc.newViolation(context)), 
            btnLeft: MyIconButton(type: ButtonType.reload, onPressed:()=>_vioBloc.loadData(context))
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: StreamBuilder(
                stream: _vioBloc.violationStream$,
                builder: (BuildContext context, AsyncSnapshot<ViolationModel> snapshot){
                  if (snapshot.hasData)
                    if (snapshot.data.status == Status.error)
                      return ErrorInGrid(snapshot.data.msg);
                    else if (snapshot.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snapshot.data.rows.length,
                        itemBuilder: (context, idx){
                          Violation _vio = snapshot.data.rows[idx];
                          return Card(
                            color: idx.isEven ? appbarColor(context) : Colors.transparent,
                            child: GestureDetector(
                              onDoubleTap: () => _vioBloc.editMode(_vio),
                              child: Row(
                                children: [
                                  _vio.id == 0 || _vio.editing
                                    ? GridTextField(hint: 'عنوان تخلف', onChange: (val) => _vio.name = val, initialValue: _vio.name, width: 350, autofocus: true,) 
                                    : Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Text(_vio.name),
                                        )
                                      ),
                                  _vio.id == 0 || _vio.editing 
                                    ? MyIconButton(type: ButtonType.save, onPressed: () => _vioBloc.saveViolation(context, _vio))
                                    : MyIconButton(type: ButtonType.del, onPressed: () => _vioBloc.delViolation(context, _vio)),
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
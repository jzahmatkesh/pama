import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import 'BankBloc.dart';

class FmBank extends StatelessWidget {
  const FmBank({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BankBloc _bankBloc = BankBloc()..loadData(context);

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Column(
        children: [
          FormHeader(
            title: 'بانک ها', 
            btnRight: MyIconButton(type: ButtonType.add, onPressed: () => _bankBloc.newBank(context)), 
            btnLeft: MyIconButton(type: ButtonType.reload, onPressed: ()=>_bankBloc.loadData(context))
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: StreamBuilder(
                stream: _bankBloc.bankStream$,
                builder: (BuildContext context, AsyncSnapshot<BankModel> snapshot){
                  if (snapshot.hasData)
                    if (snapshot.data.status == Status.error)
                      return ErrorInGrid(snapshot.data.msg);
                    else if (snapshot.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snapshot.data.rows.length,
                        itemBuilder: (context, idx){
                          Bank bank = snapshot.data.rows[idx];
                          return Card(
                            color: idx.isEven ? appbarColor(context) : scaffoldcolor(context),
                            child: GestureDetector(
                              onDoubleTap: () => _bankBloc.editMode(bank),
                              child: Row(
                                children: [
                                  // Expanded(child: GridTextField(hint: 'عنوان بانک', initialValue: bank.name, onChange: (val) => bank.name=val,)),
                                  bank.id == 0 || bank.editing
                                    ? GridTextField(hint: 'عنوان بانک', onChange: (val) => bank.name = val, initialValue: bank.name, width: 350, autofocus: true,) 
                                    : Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Text(bank.name),
                                        )
                                      ),
                                  bank.id == 0 || bank.editing 
                                    ? MyIconButton(type: ButtonType.save, onPressed: () => _bankBloc.saveBank(context, bank))
                                    : MyIconButton(type: ButtonType.del, onPressed: () => _bankBloc.delBank(context, bank)),
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
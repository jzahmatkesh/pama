import 'package:flutter/material.dart';
import 'package:pama/module/consts.dart';
import '../../classes/classes.dart';
import '../../module/Widgets.dart';

import 'ParvaneProcessBloc.dart';

class FinishProcess1 extends StatelessWidget {
  final PPrcBloc bloc;
  final ParvaneProcess pprow;
  final Parvane parvane;
  const FinishProcess1({@required this.bloc, @required this.parvane, @required this.pprow, Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _edsodor = TextEditingController(text: this.parvane.datesodor);
    TextEditingController _edtahvil = TextEditingController(text: this.parvane.datetahvil);
    final _formkey = GlobalKey<FormState>();
    return AbsorbPointer(
      absorbing: this.pprow.finish != 0,
      child: Center(
        child: Form(
          key: _formkey,
          child: Container(
            width: screenWidth(context) * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    GridTextField(hint: 'شماره صنفی', notempty: true, initialValue: '${this.parvane.shenasesenfi}', numberonly: true, onChange: (val)=>parvane.shenasesenfi = int.tryParse(val)).expand(),
                    GridTextField(hint: 'مدت اعتبار', notempty: true, initialValue: '${this.parvane.etebarlen}', numberonly: true, onChange: (val)=>parvane.etebarlen = int.tryParse(val)).expand(),
                    GridTextField(hint: 'شماره پروانه', notempty: true, initialValue: '${this.parvane.eparvaneno}', numberonly: true, onChange: (val)=>parvane.eparvaneno = int.tryParse(val)).expand(),
                  ],
                ),
                Row(
                  children: [
                    GridTextField(hint: 'تاریخ صدور', notempty: true, datepicker: true, controller: _edsodor).expand(),
                    GridTextField(hint: 'تاریخ تحویل', notempty: true, datepicker: true, controller: _edtahvil).expand(),
                  ],
                ),
                Row(
                  children: [
                    GridTextField(hint: 'توضیحات', notempty: true, initialValue: '${this.parvane.note}', onChange: (val)=>parvane.note = val).expand(),
                    MyOutlineButton(title: 'صدور پروانه', color: Colors.green, icon: Icons.save, onPressed: (){
                      if (_formkey.currentState.validate()){
                        parvane.old = pprow.id;
                        parvane.datesodor = _edsodor.text;
                        parvane.datetahvil = _edtahvil.text;
                        this.bloc.sodorParvane(context, parvane);
                      }
                    })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/forms/GUnit/GUnitBloc.dart';
import 'package:pama/module/Widgets.dart';
import 'package:pama/module/consts.dart';
import 'package:pama/module/functions.dart';

class FmGUnit extends StatelessWidget {
  final bool justcheck;
  final String nosazicode;

  FmGUnit({@required this.justcheck, this.nosazicode = ""});

  @override
  Widget build(BuildContext context) {
    String _data = '';
    GUnitBloc _bloc = GUnitBloc();
    if (this.nosazicode.isNotEmpty)
      Future.delayed(Duration(milliseconds: 30), ()=>_bloc.checkNosaziCode(context, this.nosazicode, this.justcheck));
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder<GUnitModel>(
        stream: _bloc.peopleStream$,
        builder: (context, snap) {
          if (snap.hasData){
            if (snap.data.status == Status.loaded)
              return GUnitInfo(snap.data.gunit);
            return Container(
              width: screenWidth(context) * 0.3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GridTextField(hint: 'کد نوسازی', initialValue: this.nosazicode, autofocus: true, onChange: (val)=>_data=val),
                  SizedBox(height: 25),
                  snap.data.status==Status.loading
                    ? CupertinoActivityIndicator()
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyOutlineButton(color: Colors.blue, title: 'بررسی', icon: Icons.search, onPressed: ()=>_bloc.checkNosaziCode(context, _data, this.justcheck)),
                        snap.data.status==Status.error
                          ? Container(
                              margin: EdgeInsets.only(right: 15),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.red.shade100
                              ),
                              child: snap.data.msg.toLabel()
                            )
                          : Container()
                      ],
                    ),
                ],
              ),
            );
          }
          return CupertinoActivityIndicator();
        }
      ),
    );
  }
}

class GUnitInfo extends StatelessWidget {
  final GUnit gunit;
  
  GUnitInfo(this.gunit);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Container(
      width: screenWidth(context) * 0.5,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(
              title: 'اطلاعات واحد صنفی',
              btnRight: MyIconButton(type: ButtonType.save, onPressed: (){if (_formKey.currentState.validate()) print('eyvak');}),
            ),
            Row(
              children: [
                GridTextField(hint: 'کد نوسازی', initialValue: this.gunit.nosazicode, onChange: (val)=>this.gunit.nosazicode=val).expand(),
                GridTextField(hint: 'حوزه انتظامی', notempty: true,initialValue: this.gunit.hozeentezami, onChange: (val)=>this.gunit.hozeentezami=val).expand(),
                GridTextField(hint: 'مرکز بهداشت', notempty: true,initialValue: this.gunit.markazbehdasht, onChange: (val)=>this.gunit.markazbehdasht=val).expand(),
              ]
            ),
            Row(
              children: [
                GridTextField(hint: 'مساحت زمین', initialValue: '${this.gunit.zaminmasahat}', numberonly: true, onChange: (val)=>this.gunit.zaminmasahat=int.tryParse(val)).expand(),
                GridTextField(hint: 'پلاک ثبتی', initialValue: this.gunit.pelak, onChange: (val)=>this.gunit.pelak=val).expand(),
                GridTextField(hint: 'منطقه شهرداری', notempty: true,initialValue: '${this.gunit.shahrdari}', numberonly: true, onChange: (val)=>this.gunit.shahrdari=int.tryParse(val)).expand(),
              ]
            ),
            Row(
              children: [
                GridTextField(hint: 'آدرس', notempty: true,initialValue: this.gunit.address, onChange: (val)=>this.gunit.address=val).expand(),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
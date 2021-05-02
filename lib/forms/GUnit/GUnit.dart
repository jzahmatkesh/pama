import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      child: Center(
        child: StreamBuilder<GUnitModel>(
          stream: _bloc.peopleStream$,
          builder: (context, snap) {
            if (snap.hasData)
              return Container(
                width: screenWidth(context) * 0.3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GridTextField(hint: 'کد نوسازی', initialValue: this.nosazicode, onChange: (val)=>_data=val),
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
            return CupertinoActivityIndicator();
          }
        ),
      ),
    );
  }
}
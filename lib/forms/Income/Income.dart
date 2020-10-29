import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/module/theme-Manager.dart';
import 'package:provider/provider.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import 'IncomeBloc.dart';

class FmIncome extends StatelessWidget {
  const FmIncome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IncomeBloc _bloc = IncomeBloc()..loadIncome(context);
    return Container(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormHeader(title: 'فهرست درآمدها', btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>_bloc.newIncome(context)), btnLeft: MyIconButton(type: ButtonType.reload, onPressed: ()=>_bloc.loadIncome(context))),
            GridCaption(obj: [
              Text('فعال', style: gridFieldStyle()),
              'عنوان درآمد',
              'مبلغ کنونی',
              Text('پرداخت الکترونیکی', style: gridFieldStyle()),
              SizedBox(width: 15),
              Text('قابلیت استرداد', style: gridFieldStyle()),
              SizedBox(width: 15),
              Text('تخفیف پذیر', style: gridFieldStyle()),
              SizedBox(width: 15),
              Text('همه اتحادیه ها', style: gridFieldStyle()),
            ], endbuttons: 3),
            Expanded(
              child: StreamBuilder(
                stream: _bloc.incomStream$,
                builder: (BuildContext context, AsyncSnapshot<IncomeModel> snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (context, idx){
                          Income _inc = snap.data.rows[idx];
                          return _inc.share
                            ? Container(
                              height: 450,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IncomeRow(inc: _inc, bloc: _bloc),
                                  SizedBox(height: 10.0),
                                  Expanded(child: PnShare(bloc: _bloc, inc: _inc))
                                ],
                              ),
                            )
                            : _inc.pricehistory
                              ? Container(
                                height: 450,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IncomeRow(inc: _inc, bloc: _bloc),
                                    SizedBox(height: 10.0),
                                    Expanded(child: PnHistory(bloc: _bloc, inc: _inc))
                                  ],
                                ),
                              )
                              : _inc.company
                                ? Container(
                                  height: 450,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IncomeRow(inc: _inc, bloc: _bloc),
                                      SizedBox(height: 10.0),
                                      Expanded(child: PnCompany(bloc: _bloc, inc: _inc))
                                    ],
                                  ),
                                )
                                : IncomeRow(inc: _inc, bloc: _bloc, color: idx.isOdd && !_inc.share && !_inc.pricehistory && !_inc.edit ? appbarColor(context) : Colors.transparent);
                        },
                      );
                  return Center(child: CupertinoActivityIndicator());
                },
              ),
            )
          ],
        ),
      )
    );
  }
}

class IncomeRow extends StatelessWidget {
  const IncomeRow({Key key,@required this.inc,@required this.bloc, this.color}) : super(key: key);

  final Income inc;
  final IncomeBloc bloc;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return MyRow(
      onDoubleTap: ()=>bloc.setRadio(context, inc.id, edit: true),
      color: this.color,
      children: [
        Tooltip(message: 'فعال/غیرفعال', child: Switch(value: inc.active, onChanged: (val)=>bloc.setRadio(context, inc.id, act: true))),
        SizedBox(width: 20),
        inc.edit ? Expanded(child: GridTextField(hint: 'عنوان درآمد', initialValue: inc.name, onChange: (val)=>inc.name=val, autofocus: true,)) : '${inc.name}',
        '${inc.price ?? 0}',
        Tooltip(message: 'پرداخت الکترونیکی', child: Switch(value: inc.epay, onChanged: (val)=>bloc.setRadio(context, inc.id, epay: true))),
        SizedBox(width: 30),
        Tooltip(message: 'قابلیت استرداد', child: Switch(value: inc.refund, onChanged: (val)=>bloc.setRadio(context, inc.id, refund: true))),
        SizedBox(width: 30),
        Tooltip(message: 'تخفیف پذیر', child: Switch(value: inc.off, onChanged: (val)=>bloc.setRadio(context, inc.id, off: true))),
        SizedBox(width: 30),
        Tooltip(message: 'همه اتحادیه ها', child: Switch(value: inc.allcmp, onChanged: (val)=>bloc.setRadio(context, inc.id, allcmp: true))),
        SizedBox(width: 30),
        inc.edit 
          ? MyIconButton(type: ButtonType.save, onPressed: ()=>bloc.saveIncome(context, inc))
          : inc.allcmp ? Container(width: 40,) : MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.building_2_fill), hint: 'اختصاص اتحادیه', onPressed: ()=>bloc.loadIncomeCompany(context, inc.id)),
        inc.edit ? Container(width: 40,) : MyIconButton(type: ButtonType.other, hint: 'جزییات درآمد', icon: Icon(CupertinoIcons.layers_alt), onPressed: ()=>bloc.loadIncomeShare(context, inc.id)),
        inc.edit ? Container(width: 40,) : MyIconButton(type: ButtonType.other, hint: 'تاریخچه درآمد', icon: Icon(CupertinoIcons.line_horizontal_3_decrease), onPressed: ()=>bloc.loadIncomeHistory(context, inc.id)),
        inc.edit ? Container(width: 40,) : MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delIncome(context, inc))
      ]
    );
  }
}

class PnShare extends StatelessWidget {
  const PnShare({Key key,@required this.inc,@required this.bloc}) : super(key: key);

  final Income inc;
  final IncomeBloc bloc;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context) * 0.50,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridCaption(obj: [MyIconButton(type: ButtonType.add, onPressed: ()=>bloc.newIncomeShare(inc.id)),'عنوان بستانکار', Container(width: 100, child: Text('درصد', style: gridFieldStyle(),))]),
            Expanded(
              child: StreamBuilder(
                stream: bloc.incomShareStream$,
                builder: (BuildContext context, AsyncSnapshot<IncomeShareModel> snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (context, idx){
                          Incomeshare _shr = snap.data.rows[idx];
                          return MyRow(
                            onDoubleTap: ()=>bloc.editIncomeShare(_shr.id),
                            children: [
                              _shr.id==1 
                                ? 'اتاق اصناف' 
                                : _shr.id==2
                                  ? 'اتاق ایران'
                                  : _shr.edit
                                    ? Expanded(child: GridTextField(hint: 'عنوان بستانکار', initialValue: _shr.name, onChange: (val)=>_shr.name=val, autofocus: true, width: 150,))
                                    : '${_shr.name}',
                                _shr.edit
                                  ? GridTextField(hint: 'درصد', initialValue: _shr.perc.toString(), onChange: (val){
                                      if (val.isEmpty)
                                        _shr.perc = 0;
                                      else
                                        _shr.perc = int.parse(val);
                                    }, autofocus: true, width: 150,)
                                  : '${_shr.perc}',
                                _shr.edit
                                  ? MyIconButton(type: ButtonType.save, onPressed: ()=>bloc.saveIncomeShare(context, _shr))
                                  : _shr.id > 2
                                    ? MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delIncomeShare(context, _shr))
                                    : Container(width: 40,)
                            ]
                          );
                        },
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

class PnHistory extends StatelessWidget {
  const PnHistory({Key key,@required this.inc,@required this.bloc}) : super(key: key);

  final Income inc;
  final IncomeBloc bloc;
  
  @override
  Widget build(BuildContext context) {
    var _eddate = TextEditingController();
    return Container(
      width: screenWidth(context) * 0.50,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridCaption(obj: [MyIconButton(type: ButtonType.add, onPressed: ()=>bloc.newIncomeHistory(inc.id)),'از تاریخ', 'قیمت']),
            Expanded(
              child: StreamBuilder(
                stream: bloc.incomHistoryStream$,
                builder: (BuildContext context, AsyncSnapshot<IncomeHistoryModel> snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (context, idx){
                          Incomehistory _hst = snap.data.rows[idx];
                          if (_hst.edit)
                            _eddate.text = _hst.date;
                          return MyRow(
                            onDoubleTap: ()=>bloc.editIncomeHistory(_hst.id),
                            children: [
                              SizedBox(width: 100),
                              _hst.edit
                                ? Expanded(child: GridTextField(hint: 'از تاریخ', controller: _eddate, datepicker: true, autofocus: true))
                                : '${_hst.date}',
                                _hst.edit
                                  ? Expanded(child: GridTextField(hint: 'قیمت', initialValue: moneySeprator(_hst.price.toString()), money: true, onChange: (val){
                                      if (val.isEmpty)
                                        _hst.price = 0;
                                      else
                                        _hst.price = double.parse(val.replaceAll(',', ''));
                                    }, autofocus: true),
                                  )
                                  : '${moneySeprator(_hst.price.toString())}',
                                _hst.edit
                                  ? MyIconButton(type: ButtonType.save, onPressed: (){_hst.date = _eddate.text; bloc.saveIncomeHistory(context, _hst);})
                                  : MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delIncomeHistory(context, _hst))
                            ]
                          );
                        },
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

class PnCompany extends StatelessWidget {
  const PnCompany({Key key,@required this.inc,@required this.bloc}) : super(key: key);

  final Income inc;
  final IncomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          GridCaption(obj: [
            MyIconButton(type: ButtonType.add, onPressed: ()=>bloc.newIncomeCompany(inc.id)),
            'عنوان اتحادیه',
            Text('تمام رسته ها', style: gridFieldStyle()),
            // SizedBox(width: 50)
          ], endbuttons: 2),
          Expanded(
            child: StreamBuilder<IncomeCompanyModel>(
              stream: bloc.incomCompanyStream$,
              builder: (context, snap){
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid(snap.data.msg);
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        var _cmp = snap.data.rows[idx];
                        return MyRow(
                          onDoubleTap: ()=>bloc.editIncomeCompany(_cmp.cmpid),
                          children: [
                            _cmp.edit
                              ? Expanded(
                                flex: 2, 
                                child: ForeignKeyField(
                                  hint: 'انتخاب اتحادیه', 
                                  f2key: 'Company', 
                                  initialValue: {'id': _cmp.cmpid, 'name': _cmp.cmpname}, 
                                  onChange: (val){
                                    if (val != null){
                                      _cmp.cmpid = val['id'];
                                      _cmp.cmpname = val['name'];
                                    }
                                  }
                                )
                              )
                              : '${_cmp.cmpname}',
                            SizedBox(width: 45),
                            Switch(value: _cmp.allraste, onChanged: (val)=>bloc.changeAllRaste(context, _cmp)),
                            SizedBox(width: 45),
                            _cmp.allraste
                              ? Container(width: 40)
                              : MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.text_badge_checkmark), hint: 'اختصاص رسته', onPressed: (){bloc.loadIncomeCompanyRaste(context, _cmp.incid, _cmp.cmpid); showFormAsDialog(context: context, form: PnRaste(bloc: bloc, cmp: _cmp));}),
                            _cmp.edit
                              ? MyIconButton(type: ButtonType.save, onPressed: ()=>bloc.saveIncomeCompany(context, _cmp))
                              : MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delIncomeCompany(context, _cmp))
                          ]
                        );
                      }
                    );
                return Center(child: CupertinoActivityIndicator());
              },
            ),
          )
        ],
      )
    );
  }
}

class PnRaste extends StatelessWidget {
  const PnRaste({Key key, @required this.bloc, @required this.cmp}) : super(key: key);

  final IncomeBloc bloc;
  final Incomecompany cmp;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context) * 0.75,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(title: 'تخصیص رسته', btnRight: MyIconButton(type: ButtonType.add, onPressed: (){context.read<ThemeManager>().setCompany(cmp.cmpid); bloc.newIncomeCompanyRaste(cmp.incid, cmp.cmpid);})),
            GridCaption(
              obj: ['عنوان رسته',
                Text('درجه یک', style: gridFieldStyle()),
                SizedBox(width: 20),
                Text('درجه دو', style: gridFieldStyle()),
                SizedBox(width: 20),
                Text('درجه سه', style: gridFieldStyle()),
                SizedBox(width: 20),
                Text('درجه چهار', style: gridFieldStyle()),
              ]),
            Expanded(
              child: StreamBuilder<IncomeCompanyRasteModel>(
                stream: bloc.incomCompanyRasteStream$,
                builder: (context, snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (BuildContext context, int idx) {
                        var _rst = snap.data.rows[idx];
                        return MyRow(
                          onDoubleTap: (){context.read<ThemeManager>().setCompany(cmp.cmpid); bloc.editIncomeCompanyRaste(_rst.id);},
                          children: [
                            _rst.edit
                              ? Expanded(child: ForeignKeyField(hint: 'عنوان رسته', initialValue: {'hisic': _rst.hisic, 'isic': _rst.isic, 'name': _rst.name}, f2key: 'Raste', onChange: (val){if (val != null){_rst.hisic=val['hisic'];_rst.isic=val['isic'];_rst.name=val['name'];}}))
                              : '${_rst.name}',
                            Switch(value: _rst.grade1, onChanged: (val)=>bloc.changeRasteGrade(context, _rst, grade1: true)),
                            SizedBox(width: 20),
                            Switch(value: _rst.grade2, onChanged: (val)=>bloc.changeRasteGrade(context, _rst, grade2: true)),
                            Switch(value: _rst.grade3, onChanged: (val)=>bloc.changeRasteGrade(context, _rst, grade3: true)),
                            SizedBox(width: 20),
                            Switch(value: _rst.grade4, onChanged: (val)=>bloc.changeRasteGrade(context, _rst, grade4: true)),
                            SizedBox(width: 15),
                            _rst.edit
                              ? MyIconButton(type: ButtonType.save, onPressed: ()=>bloc.saveIncomeCompanyRaste(context, _rst))
                              : MyIconButton(type: ButtonType.del, onPressed: (){})
                          ]
                        );
                     },
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/classes/classes.dart';
import 'ParvaneProcessBloc.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';

class NewParvaneProcess extends StatelessWidget {
  final int parvaneid;

  NewParvaneProcess({@required this.parvaneid});

  @override
  Widget build(BuildContext context) {
    final PPrcBloc _bloc = PPrcBloc()..loadProcess(context: context, parvaneID: this.parvaneid);
    return Container(
      width: screenWidth(context) * 0.3,      
      height: screenHeight(context) * 0.5,
      child: Directionality(
        textDirection: TextDirection.rtl,
          child: StreamBuilder<PPrcModel>(
            stream: _bloc.stream,
            builder: (context, snap) {
              if (snap.hasData){
                if (snap.data.status == Status.error)
                  return ErrorInGrid(snap.data.msg);
                if (snap.data.status == Status.loaded)
                  if (snap.data.rows.length == 0)
                    return ErrorInGrid('فرآیندی جهت انتخاب وجود ندارد', info: true);
                  else
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx)=>
                        ListTile(
                          title: Text('فرآیند صدور'),
                          onTap: ()=>confirmMessage(context, 'آغاز فرآیند', 'آیا مایل به آغاز فرآیند ${snap.data.rows[idx].title} می باشید؟', yesclick: (){
                            Navigator.pop(context);
                            _bloc.newprocess(context, this.parvaneid, snap.data.rows[idx].id);
                          }),
                        ).setPadding().card()
                    );
              }
              return Center(child: CupertinoActivityIndicator());
            }
          )
      ),
    );
  }
}

class FmParvaneProcess extends StatelessWidget {
  final Parvane parvane;
  final int processid;
  const FmParvaneProcess({ Key key, @required this.parvane, this.processid = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PPrcBloc _bloc = PPrcBloc()..loadParvaneProcess(context: context, parvaneID: this.parvane.id);
    return Container(
      width: screenWidth(context) * 0.75,
      height: screenHeight(context) * 0.75,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            FormHeader(title: 'لیست فرآیندهای ${parvane.peopname}'),
            GridCaption(
              obj: [
                'عنوان فرآیند'.toLabel().expand(),
                'تاریخ شروع'.toLabel().expand(),
                'مدت مجاز'.toLabel().expand(),
                'تاریخ اتمام'.toLabel().expand(),
                'روزهای باقیمانده'.toLabel().expand(),
              ],
              endbuttons: 3,
            ),
            StreamBuilder<ParvaneProcessModel>(
              stream: _bloc.pprocessstream,
              builder: (context, snap){
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid('${snap.data.msg}');
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        if (snap.data.rows[idx].showSteps)
                          return Container(
                            height: screenHeight(context) * 0.50,
                            child: Column(
                              children: [
                                ParvaneProcessRow(bloc: _bloc, data: snap.data.rows[idx]).card(),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    ...snap.data.rows[idx].stepsList.map((e) => 
                                      InkWell(
                                        onTap: (){},
                                        hoverColor: accentcolor(context).withOpacity(0.25),
                                        highlightColor: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Colors.grey.withOpacity(0.1),
                                          ),
                                          child: Text('${e["title"]}').center(),
                                        )
                                      ).hMargin().expand()).toList(),
                                    Expanded(flex: 3, child: Container())
                                  ],
                                )  
                              ],
                            ),
                          ).card();
                        return ParvaneProcessRow(bloc: _bloc, data: snap.data.rows[idx]).card();
                      }
                    );
                return Center(child: CupertinoActivityIndicator());
              }
            ).expand()
          ],
        ),
      ),
    );
  }
}

class ParvaneProcessRow extends StatelessWidget {
  final ParvaneProcess data;
  final PPrcBloc bloc;

  const ParvaneProcessRow({ Key key, @required this.bloc, @required this.data }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        '${data.title}'.toLabel().expand(),
        '${data.startdate}'.toLabel().expand(),
        '${data.length}'.toLabel().expand(),
        '${data.enddate}'.toLabel().expand(),
        '${data.dayremind}'.toLabel().expand(),
        data.finish 
          ? Tooltip(message: 'اتمام فرآیند', child: Icon(Icons.check_box_outlined))
          : SizedBox(width: 40),
        MyIconButton(type: ButtonType.other, icon: Icon(Icons.view_sidebar_rounded, color: accentcolor(context),), hint: 'مشاهده وضعیت فرآیند', onPressed: ()=>bloc.showParvaneProcessSteps(context, data.id)),
        MyIconButton(type: ButtonType.del, onPressed: (){})
      ]
    );
  }
}






import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../classes/classes.dart';
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
                          onTap: ()=>confirmMessage(context, 'آغاز فرآیند', 'آیا مایل به آغاز فرآیند ${snap.data.rows[idx].title} می باشید؟', yesclick: () async{
                            Navigator.pop(context);
                            if (await _bloc.newprocess(context, this.parvaneid, snap.data.rows[idx].id))
                              Navigator.pop(context, true);
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
    Bloc<int> _stepid = Bloc<int>()..setValue(0);
    return Container(
      width: screenWidth(context) * 0.95,
      height: screenHeight(context) * 0.95,
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
                            height: screenHeight(context) * 0.70,
                            child: Column(
                              children: [
                                ParvaneProcessRow(bloc: _bloc, data: snap.data.rows[idx]).card(),
                                SizedBox(height: 10),
                                StreamBuilder<int>(
                                  stream: _stepid.stream$,
                                  builder: (context, cstp) {
                                    if (cstp.hasData)
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(width: 10),
                                              ...snap.data.rows[idx].stepsList.map((e) => 
                                                InkWell(
                                                  onTap: (){_stepid.setValue(e['stepid']);_bloc.showPPStepDocument(context, snap.data.rows[idx].id, e['stepid']);},
                                                  hoverColor: accentcolor(context).withOpacity(0.25),
                                                  highlightColor: Colors.grey.shade100,
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: Container(
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      color: cstp.data == e["stepid"] ? accentcolor(context).withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                                                    ),
                                                    child: Text('${e["title"]}').center(),
                                                  )
                                                ).hMargin().expand()).toList(),
                                              Expanded(flex: 3, child: Container())
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            child: StreamBuilder<PPDocumentModel>(
                                              stream: _bloc.ppDocumentstream,
                                              builder: (context, snp){
                                                if (snp.hasData)
                                                  if (snp.data.status == Status.error)
                                                    return ErrorInGrid(snp.data.msg);
                                                  else if (snp.data.status == Status.loaded)
                                                    return SingleChildScrollView(
                                                      child: Wrap(
                                                        children: snp.data.rows.map((e) => Container(
                                                          width: screenWidth(context) * 0.2,
                                                          height: screenWidth(context) * 0.195,
                                                          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            color: Colors.grey.shade100
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: double.infinity,
                                                                padding: EdgeInsets.all(12),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                                                  color: Colors.amber.shade100
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    MyIconButton(
                                                                      type: ButtonType.other, 
                                                                      hint: 'آپلود مدرک', 
                                                                      icon: Icon(Icons.upload_outlined), 
                                                                      onPressed: ()=>prcUploadImg(context: context, id: e.ppid, id1: e.ppstepid, id2: e.id, tag: 'TBPPSDocument', function: (str){e.attachname=str; _bloc.refreshDocument();}),
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Text('${e.documentname}', textAlign: TextAlign.center,),
                                                                        SizedBox(height: 10),
                                                                        Text('${e.kindName()}', textAlign: TextAlign.center,),
                                                                      ],
                                                                    ).expand(),
                                                                  ],
                                                                )
                                                              ),
                                                              if (e.attachname.toLowerCase().contains("xls") || e.attachname.toLowerCase().contains("xlsx"))
                                                                Image.asset("images/excel.png", fit: BoxFit.cover).expand()
                                                              else if (e.attachname.toLowerCase().contains("mp3"))
                                                                Image.asset("images/mp3.png", fit: BoxFit.cover).expand()
                                                              else if (e.attachname.toLowerCase().contains("mp4") || e.attachname.toLowerCase().contains("avi"))
                                                                Image.asset("images/mp4.png", fit: BoxFit.cover).expand()
                                                              else if (e.attachname.toLowerCase().contains("xls") || e.attachname.toLowerCase().contains("xlsx"))
                                                                Image.asset("images/excel.png", fit: BoxFit.cover).expand()
                                                              else if (e.attachname.toLowerCase().contains("doc") || e.attachname.toLowerCase().contains("docx"))
                                                                Image.asset("images/Word.png", fit: BoxFit.cover).expand()
                                                              else if (e.attachname.toLowerCase().contains("pdf"))
                                                                Image.asset("images/pdf.png", fit: BoxFit.cover).expand()
                                                              else if (!e.attachname.toLowerCase().contains("png") && !e.attachname.toLowerCase().contains("jpg") && !e.attachname.toLowerCase().contains("jpeg") && !e.attachname.toLowerCase().contains("bmp") && e.attachname.trim().isNotEmpty)
                                                                Image.asset("images/other.png", fit: BoxFit.cover).expand()
                                                              else
                                                                Image.network("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=TBPPSDocument&id=${e.ppid}&id1=${e.ppstepid}&id2=${e.id}&flg=${Random().nextInt(1000)}", fit: BoxFit.cover).expand(),
                                                              Container(
                                                                width: double.infinity,
                                                                padding: EdgeInsets.all(5),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.grey.shade200,
                                                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                                ),
                                                                child: Text('${e.attachname}', textAlign: TextAlign.left,)
                                                              )
                                                            ],
                                                          ),
                                                        )).toList()
                                                      ),
                                                    );
                                                    // return ListView.builder(
                                                    //   itemCount: snap.data.rows.length,
                                                    //   itemBuilder: (context, idx)=>MyRow(
                                                    //     children: [
                                                    //       '${snap.data.rows[idx].documentname} - ${snap.data.rows[idx].kindName()}'.toLabel()
                                                    //     ]
                                                    //   )
                                                    // );
                                                return Center(child: CupertinoActivityIndicator());
                                              },
                                            )
                                          ).expand()
                                        ],
                                      );
                                    return Container();
                                  }
                                ).expand() 
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






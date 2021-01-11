import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import 'AttachBloc.dart';

AttachBloc _attachBloc;
class FmAttach extends StatelessWidget{
  const FmAttach({Key key, @required this.title, @required this.tag, this.cmpid=0, this.id1 = 0, this.id2 = 0, this.id3 = 0, this.id4 = 0, this.id5 = 0}) : super(key: key);

  final String title;
  final String tag;
  final int cmpid;
  final int id1;
  final int id2;
  final int id3;
  final int id4;
  final int id5;

  @override
  Widget build(BuildContext context) {
    _attachBloc = AttachBloc(tag: tag, cmpid: cmpid, id1: id1, id2: id2, id3: id3, id4: id4, id5: id5)..loadData(context);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.75,
        height: screenHeight(context) * 0.75,
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(
              title: this.title, 
              btnRight: MyIconButton(
                type: ButtonType.add, 
                onPressed: ()=>prcUploadImg(
                  context: context, 
                  id: 0, 
                  tag: "$tag", 
                  cmpid: this.cmpid,
                  id1: this.id1,
                  id2: this.id2,
                  id3: this.id3,
                  id4: this.id4,
                  id5: this.id5,
                  ondone: ()=>_attachBloc.reLoad(context)
                )
              )
            ),
            Expanded(
              child: StreamBuilder<AttachDataModel>(
                stream: _attachBloc.attachStream$,
                builder: (context, snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.loaded)
                      return SingleChildScrollView(
                        child: Wrap(
                          children: snap.data.rows.map((e)=>Container(
                            width: 200,
                            height: 185,
                            child: ListTile(
                              onTap: ()=>launchURL('http://${serverIP()}:8080/PamaApi/LoadFile.jsp?id=${e.radif}&type=${e.ext}'),
                              title: Card(
                                child: Column(
                                  children: [
                                    SizedBox(height: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: e.filetype()=='image' 
                                            ? NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?id=${e.radif}&type=other")
                                            : AssetImage('images/${e.filetype()}.png'),
                                            fit: BoxFit.cover
                                          )
                                      ),
                                      height: 125,
                                      width: 150,
                                    ),
                                    Spacer(),
                                    Container(
                                      color: Colors.grey[200],
                                      width: double.infinity,
                                      height: 35,
                                      padding: EdgeInsets.all(4),
                                      child: Row(
                                        children: [
                                          MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.trash, color: Colors.red), hint: 'حذف', onPressed: ()=>print('delete Click')),
                                          Expanded(child: Text('${e.filename}', style: GoogleFonts.abhayaLibre(fontSize: 10), textAlign: TextAlign.left,)),
                                        ],
                                      )
                                    ),
                                  ],
                                ),
                              )
                            ),
                          )).toList()
                        ),
                      );
                      // return ListView.builder(itemCount: snap.data.rows.length, itemBuilder: (context, i)=>Card(child: Text('${snap.data.rows[i].filename}')));
                    else if (snap.data.status == Status.error)
                      return Center(child: Text('${snap.data.msg}'));
                  return Center(child: CupertinoActivityIndicator());
                },
              ),
            )
          ]
        )
      )
    );
  }
}
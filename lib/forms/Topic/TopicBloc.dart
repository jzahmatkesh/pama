
import 'package:flutter/material.dart';
import 'package:pama/classes/Repository.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/module/functions.dart';
import 'package:rxdart/rxdart.dart';

class TopicModel{
  Status status;
  List<Topic> rows;
  String msg;

  TopicModel({@required this.status, this.rows, this.msg});
}

class TopicBloc{
  TopicRepository _repo = new TopicRepository();

  BehaviorSubject<TopicModel> _topicBloc = BehaviorSubject<TopicModel>();
  Stream<TopicModel> get topicStream$ => _topicBloc.stream;

  loaddata(BuildContext context) async{
    try{
      _topicBloc.add(TopicModel(status: Status.loading));
      _topicBloc.add(TopicModel(status: Status.loaded, rows: await _repo.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e');
      _topicBloc.add(TopicModel(status: Status.error, msg: '$e'));
    }
  }

  saveData(BuildContext context, Topic top) async{

  }

  delRow(BuildContext context, Topic top) async{

  }
}
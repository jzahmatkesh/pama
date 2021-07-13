import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pama/module/consts.dart';

class F2Key{
  int id;
  String name;
  int hisic;
  int isic;

  F2Key({this.id, this.name, this.hisic, this.isic});

  F2Key.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      hisic = json['hisic'],
      isic = json['isic'];
}

class User{
  int id;
  int cmpid;
  String name;
  String family;
  String cmpname;
  String mobile;
  String ip;
  String pic;
  String lastlogin;
  int sex;
  String token;
  bool admin;
  bool ejriat;

  User({@required this.id, @required this.cmpid, @required this.sex, @required this.name, @required this.family, @required this.cmpname, @required this.mobile, this.pic, this.lastlogin, this.ip, @required this.token, this.admin = false, this.ejriat = false});

  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      cmpid = json['cmpid'],
      name = json['name'],
      family = json['family'],
      cmpname = json['cmptitle'],
      mobile = json['mobile'],
      ip = json['ip'],
      // pic = json['pic'],
      lastlogin = json['lastlogin'],
      sex = json['sex'],
      token = json['token'],
      admin = json['admin'] == 1,
      ejriat = json['ejriat'] == 1;
}

class Raste{
  int hisic;
  int isic;
  int old;
  int cmpid;
  String cmpname;
  String name;
  String draste;
  bool active;
  int kind;
  int mosavabeno;
  int pricekind;
  bool searched;
  bool showdraste;
  String token;

  String kindName(){
    if (kind==1) return "تولیدی";
    else if (kind==2) return "توزیعی";
    else if (kind==3) return "خدماتی";
    else if (kind==4) return "خدمات فنی";
    return "";
  }
  String priceName(){
    if (pricekind==1) return "الف";
    else if (pricekind==2) return "ب";
    else if (pricekind==3) return "ج";
    return "";
  }
  Raste({this.hisic, @required this.isic, @required this.old, @required this.name, this.draste, @required this.cmpid, @required this.cmpname, this.active, this.kind, this.mosavabeno, this.pricekind, this.searched = true, this.showdraste = false});

  Raste.fromJson(Map<String, dynamic> json)
    : hisic = json['hisic'],
      isic = json['isic'],
      old = json['isic'],
      cmpid = json['cmpid'],
      cmpname = json['cmpname'],
      name = json['name'],
      draste = json['draste'],
      active = json['active'] == 1,
      kind = json['kind'],
      mosavabeno = json['mosavabeno'],
      pricekind = json['pricekind'],
      searched = true,
      showdraste = false;

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['isic'] = this.isic;
      data['old'] = this.old;
      data['cmpid'] = this.cmpid;
      data['cmpname'] = this.cmpname;
      data['name'] = this.name;
      data['active'] = this.active ? 1 : 0;
      data['kind'] = this.kind;
      data['mosavabeno'] = this.mosavabeno;
      data['pricekind'] = this.pricekind;
      data['token'] = this.token;
      return data;
  }
}

class DRaste{
  int hisic;
  int isic;
  int old;
  int cmpid;
  String cmpname;
  String name;
  bool active;
  int mosavabeno;
  bool searched;
  String token;

  DRaste({@required this.hisic, @required this.isic, @required this.old, @required this.name, @required this.cmpid, @required this.cmpname, this.active, this.mosavabeno, this.searched = true, this.token});

  DRaste.fromJson(Map<String, dynamic> json)
    : hisic = json['hisic'],
      isic = json['isic'],
      old = json['isic'],
      cmpid = json['cmpid'],
      cmpname = json['cmpname'],
      name = json['name'],
      active = json['active']==1,
      mosavabeno = json['mosavabeno'],
      searched = true;

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['hisic'] = this.hisic;
      data['isic'] = this.isic;
      data['old'] = this.old;
      data['cmpid'] = this.cmpid;
      data['cmpname'] = this.cmpname;
      data['name'] = this.name;
      data['active'] = this.active ? 1 :0;
      data['mosavabeno'] = this.mosavabeno;
      data['token'] = this.token;
      return data;
  }
}

class Company{
  int id;
  int active;
  String name;
  int sabt;
  int sabtsazman; 
  String bdate;
  String edate;
  String sabtdate;
  String lastnwid;
  String lastnwdate;
  double ecoid;
  double bimeid;
  String bimeshobe;
  double nationalid;
  String tax;
  int taxid;
  String email;
  String tel;
  String fax;
  String post;
  String note;
  String address;
  int price;
  int expire;
  bool insearchquery;
  bool showinfo;
	int cntuser;
	int cntemp;
	int cntdrt;
	int cntaddinfo;
	int cntcom;
	int cntattach;
	int cntletter;
	int cntproperty;
	int cntbzr;
	int cntlcn;
	int cnttcoding;
  String andate1;
  String andate2;
  String andate3;
  String andate4;
  String made1;
  String made2;
  String made4;
  String made5;
  String made6;
  String made7;
  String token;

  Company({this.id, this.active=1, this.name, this.sabt=0, this.sabtsazman=0, this.bdate, this.edate, this.sabtdate, this.lastnwid="", this.lastnwdate, this.ecoid=0, this.bimeid=0, this.bimeshobe, this.nationalid=0, this.tax, this.taxid=0, this.email, this.tel, this.fax, this.post, this.note, this.address, this.price=0, this.expire=0, this.insearchquery = true, this.showinfo = false,
    this.cntuser,this.cntemp,this.cntdrt,this.cntaddinfo,this.cntcom,this.cntattach,this.cntletter,this.cntproperty,this.cntbzr,this.cnttcoding, this.token});

  Company.fromJson(Map<String, dynamic> data)
    : id = data['id'],
      active = data['active']==null ? 0 : data['active'],
      sabt = data['sabt']==null ? 0 : data['sabt'],
      sabtsazman = data['sabtsazman']==null ? 0 : data['sabtsazman'],
      lastnwid = data['lastnwid'],
      ecoid = data['ecoid']==null ? 0 : data['ecoid'],
      bimeid = data['bimeid']==null ? 0 : data['bimeid'],
      nationalid = data['nationalid']==null ? 0 : data['nationalid'],
      taxid = data['taxid']==null ? 0 : data['taxid'],
      price = data['price']==null ? 0 : data['pricekind'],
      expire = data['expire']==null ? 0 : data['expire'],
      name = data['name'],
      bdate = data['bdate'],
      edate = data['edate'],
      lastnwdate = data['lastnwdate'],
      sabtdate = data['sabtdate'],
      bimeshobe = data['bimeshobe'],
      tax = data['tax'],
      fax = data['fax'],
      tel = data['tel'],
      email = data['email'],
      note = data['note'],
      post = data['post'],
      address = data['address'],
      insearchquery = true,
      showinfo = false,
	    cntuser = data['cntuser'] ?? 0,
	    cntemp = data['cntemp'] ?? 0,
	    cntdrt = data['cntdrt'] ?? 0,
	    cntaddinfo = data['cntaddinfo'] ?? 0,
	    cntcom = data['cntcom'] ?? 0,
	    cntattach = data['cntattach'] ?? 0,
	    cntletter = data['cntletter'] ?? 0,
      cntproperty = data['cntproperty'] ?? 0,
      cntbzr = data['cntbzr'] ?? 0,
      cntlcn = data['cntlcn'] ?? 0,
      cnttcoding = data['cnttcoding'] ?? 0,
      andate1 = data['andate1'],
      andate2 = data['andate2'],
      andate3 = data['andate3'],
      andate4 = data['andate4'],
      made1 = data['made1'],
      made2 = data['made2'],
      made4 = data['made4'],
      made5 = data['made5'],
      made6 = data['made6'],
      made7 = data['made7'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['active'] = this.active;
    data['sabt'] = this.sabt;
    data['sabtsazman'] = this.sabtsazman;
    data['lastnwid'] = this.lastnwid;
    data['ecoid'] = this.ecoid;
    data['bimeid'] = this.bimeid;
    data['nationalid'] = this.nationalid;
    data['taxid'] = this.taxid;
    data['price'] = this.price;
    data['expire'] = this.expire;
    data['name'] = this.name;
    data['bdate'] = this.bdate;
    data['edate'] = this.edate;
    data['lastnwdate'] = this.lastnwdate;
    data['sabtdate'] = this.sabtdate;
    data['bimeshobe'] = this.bimeshobe;
    data['tax'] = this.tax;
    data['fax'] = this.fax;
    data['tel'] = this.tel;
    data['email'] = this.email;
    data['note'] = this.note;
    data['post'] = this.post;
    data['address'] = this.address;
    data['andate1'] = this.andate1;
    data['andate2'] = this.andate2;
    data['andate3'] = this.andate3;
    data['andate4'] = this.andate4;
    data['made1'] = this.made1;
    data['made2'] = this.made2;
    data['made4'] = this.made4;
    data['made5'] = this.made5;
    data['made6'] = this.made6;
    data['made7'] = this.made7;
    data['token'] = this.token;
    return data;
  }
}

class CompanyUser{
  int id;
  int peopid;
  String name;
  String family;
  String mobile;
  String nationalid;
  // int pic;
  bool active;
  String lastlogin;
  String lastpasschange;
  bool insearchquery;
  bool showgroups;
  bool ejriat;

  CompanyUser({this.id, this.peopid, this.active, this.name, this.family, this.mobile, this.nationalid, this.lastlogin, this.lastpasschange, this.showgroups = false, this.ejriat = false});

  CompanyUser.fromJson(Map<String, dynamic> data)
    : id = data['id'],
      peopid = data['peopid'],
      active = data['active'] == 1,
      name = data['name'],
      family = data['family'],
      mobile = data['mobile'],
      nationalid = data['nationalid'],
    // pic = data['pic'],
      lastlogin = data['lastlogin'],
      lastpasschange = data['lastpasschange'],
      ejriat = data['ejriat'] == 1,
      showgroups = false,
      insearchquery = true;
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['peopid'] = this.peopid;
    data['active'] = this.active ? 1 : 0;
    data['name'] = this.name;
    data['family'] = this.family;
    data['mobile'] = this.mobile;
    data['nationalid'] = this.nationalid;
    // data['pic'] = this.pic;
    data['lastlogin'] = this.lastlogin;
    data['lastpasschange'] = this.lastpasschange;
    return data;
  }

}

class CompanyUserGroups{
  int userid;
  int id;
  String name;
  bool active;

  CompanyUserGroups({this.userid, this.id, this.active, this.name});

  CompanyUserGroups.fromJson(Map<String, dynamic> data)
    : userid = data['userid'],
      id = data['id'], 
      name = data['name'], 
      active = data['active'] == 1;
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['id'] = this.id;
    data['name'] = this.name;
    data['active'] = this.active ? 1 : 0;
    return data;
  }

}

class People{
    int id;
    String name;
    String family;
    String father;
    String nationalid;
    String ss;
    String birth;
    String ssplace;
    String birthdate;
    String nationality;
    String religion;
    String mazhab;
    String reshte;
    int education;
    String english;
    int bimeno;
    int isargari;
    String isargarinesbat;
    String email;
    String tel;
    String mobile;
    String post;
    String address;
    String passport;
    int single;
    int sex;
    int military;
    String token;

    int takafolcount;
    String meliat;
    String madrakfani;
    int bimeyear;
    String skills;
    String otherjobhistory;
    int jobpermitno;
    String note;
    int sarparast;
    int sskind;
    int janbazperc;
    int blood;
    int support;
    int shahrdarimantaghe;


  People({this.id,this.name,this.family,this.father,this.nationalid,this.ss,this.birth,this.ssplace,this.birthdate,this.nationality,this.religion,
    this.mazhab,this.reshte,this.english,this.bimeno,this.isargari,this.isargarinesbat,this.email,this.tel,this.mobile,this.post,this.address,this.passport,this.single,
    this.sex,this.military,this.education,this.token,this.takafolcount=0,this.meliat,this.madrakfani,this.bimeyear=0,this.skills,this.otherjobhistory,
    this.jobpermitno=0,this.note,this.sarparast=0,this.sskind=1,this.janbazperc=0,this.blood=1,this.support=0,this.shahrdarimantaghe=0,
  });

  People.fromJson(Map<String, dynamic> data)
    : id = data['id'],
    name = data['name'],
    family = data['family'],
    father = data['father'],
    nationalid = data['nationalid'],
    ss = data['ss'],
    birth = data['birth'],
    ssplace = data['ssplace'],
    birthdate = data['birthdate'],
    nationality = data['nationality'],
    religion = data['religion'],
    mazhab = data['mazhab'],
    english = data['english'],
    bimeno = data['bimeno'] ?? 0,
    isargari = data['isargari'],
    isargarinesbat = data['isargarinesbat'],
    email = data['email'],
    tel = data['tel'],
    mobile = data['mobile'],
    post = data['post'],
    address = data['address'],
    passport = data['passport'],
    single = data['single'],
    sex = data['sex'],
    military = data['military'],
    reshte = data['reshte'],
    education = data['education'],
    takafolcount = data['takafolcount'],
    meliat = data['meliat'],
    madrakfani = data['madrakfani'],
    bimeyear = data['bimeyear'],
    skills = data['skills'],
    otherjobhistory = data['otherjobhistory'],
    jobpermitno = data['jobpermitno'],
    note = data['note'],
    sarparast = data['sarparast'],
    sskind = data['sskind'],
    janbazperc = data['janbazperc'],
    blood = data['blood'],
    support = data['support'],
    shahrdarimantaghe = data['shahrdarimantaghe'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['family'] = this.family;
    data['father'] = this.father;
    data['nationalid'] = this.nationalid;
    data['ss'] = this.ss;
    data['birth'] = this.birth;
    data['ssplace'] = this.ssplace;
    data['birthdate'] = this.birthdate;
    data['nationality'] = this.nationality;
    data['religion'] = this.religion;
    data['mazhab'] = this.mazhab;
    data['reshte'] = this.reshte;
    data['english'] = this.english;
    data['bimeno'] = this.bimeno;
    data['isargari'] = this.isargari;
    data['isargarinesbat'] = this.isargarinesbat;
    data['email'] = this.email;
    data['tel'] = this.tel;
    data['mobile'] = this.mobile;
    data['post'] = this.post;
    data['address'] = this.address;
    data['passport'] = this.passport;
    data['single'] = this.single;
    data['sex'] = this.sex;
    data['military'] = this.military;
    data['education'] = this.education;
    data['token'] = this.token;
    data['takafolcount'] = this.takafolcount;
    data['meliat'] = this.meliat;
    data['madrakfani'] = this.madrakfani;
    data['bimeyear'] = this.bimeyear;
    data['skills'] = this.skills;
    data['otherjobhistory'] = this.otherjobhistory;
    data['jobpermitno'] = this.jobpermitno;
    data['note'] = this.note;
    data['sarparast'] = this.sarparast;
    data['sskind'] = this.sskind;
    data['janbazperc'] = this.janbazperc;
    data['blood'] = this.blood;
    data['support'] = this.support;
    data['shahrdarimantaghe'] = this.shahrdarimantaghe;
    return data;
  }
}

class Employee{
	int cmpid;
  int peopid;
  String name;
  String family;
  String mobile;
  String nationalid;
	int semat;
	String hdate;
	int kind;
	int cnttype;
	String cntbdate;
	String cntedate;
	int expyear;
	String note;
	int permit;
  bool showfamily;
  String token;

  Employee({this.peopid, this.name, this.family, this.mobile, this.nationalid, this.semat, this.hdate, this.kind, this.cnttype, this.cntbdate, this.cntedate, this.expyear, this.note, this.permit, this.showfamily = false, this.token});

  Employee.fromJson(Map<String, dynamic> json)
    : peopid = json['peopid'],
	    name = json['name'],
	    family = json['family'],
	    mobile = json['mobile'],
	    nationalid = json['nationalid'],
	    semat = json['semat'],
	    hdate = json['hdate'],
	    kind = json['kind'],
	    cnttype = json['cnttype'],
	    cntbdate = json['cntbdate'],
	    cntedate = json['cntedate'],
	    expyear = json['expyear'],
	    note = json['note'],
	    permit = json['permit'],
      showfamily = false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
      json['cmpid'] = this.cmpid;
      json['peopid'] = this.peopid;
	    json['name'] = this.name;
	    json['family'] = this.family;
	    json['mobile'] = this.mobile;
	    json['nationalid'] = this.nationalid;
	    json['semat'] = this.semat;
	    json['hdate'] = this.hdate;
	    json['kind'] = this.kind;
	    json['cnttype'] = this.cnttype;
	    json['cntbdate'] = this.cntbdate;
	    json['cntedate'] = this.cntedate;
	    json['expyear'] = this.expyear;
	    json['note'] = this.note;
	    json['permit'] = this.permit;
	    json['token'] = this.token;
      return json;
  }

  String sematName(){
    switch (this.semat){
			case 1: 
        return "مشاور";
        break;
			case 2: 
        return "مدیر اجرایی";
        break;
			case 3: 
        return "بازرس";
        break;
			case 4: 
        return "حسابدار";
        break;
			case 5: 
        return "کمک حسابدار";
        break;
			case 6: 
        return "کارپرداز";
        break;
			case 7: 
        return "خدماتی";
        break;
			case 8: 
        return "کاردان اداری";
        break;
			case 9: 
        return "کارشناس اداری";
        break;
			case 10: 
        return "منشی";
        break;
			case 11: 
        return "غیره";
        break;
    }
    return "";
  }
  String kindName(){
    switch (this.kind){
			case 1: 
        return "تمام وقت";
        break;
			case 2: 
        return "نیمه وقت";
        break;
    }
    return "";
  }
  String cntTypeName(){
    switch (this.cnttype){
			case 1:
        return "شفاهی مدت دار";
        break;
			case 2:
        return "شفاهی دایم";
        break;
			case 3:
        return "کتبی موقت";
        break;
			case 4:
        return "کتبی دایم";
        break;
			case 5:
        return "سایر";
        break;
    }
    return "";
  }
}

class EmpFamily{
  int cmpid;
  int empid;
	int peopid;
  String name;
  String family;
  String mobile;
  String nationalid;
  String reshte;
  int education;
  int isargari;
	int kind;
	String job;
	String mdate;
	String note;
  String token;
  int single;

  EmpFamily({this.peopid, this.name, this.family, this.mobile, this.nationalid, this.education, this.reshte, this.isargari, this.kind, this.job, this.mdate, this.note, this.single});

  EmpFamily.fromJson(Map<String, dynamic> json)
	  : peopid = json['peopid'],
	    name = json['name'],
	    family = json['family'],
	    mobile = json['mobile'] ?? "",
	    nationalid = json['nationalid'],
      isargari = json['isargari'],
	    kind = json['kind'],
	    job = json['job'],
	    mdate = json['mdate'],
      reshte = json['reshte'],
      education = json['education'],
	    note = json['note'],
      single = json['single'];

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = new Map<String, dynamic>();
	    json['cmpid'] = this.cmpid;
	    json['empid'] = this.empid;
	    json['peopid'] = this.peopid;
	    json['name'] = this.name;
	    json['family'] = this.family;
	    json['mobile'] = this.mobile;
	    json['nationalid'] = this.nationalid;
	    json['isargari'] = this.isargari;
	    json['kind'] = this.kind;
	    json['job'] = this.job;
	    json['mdate'] = this.mdate;
	    json['note'] = this.note;
      json['reshte'] = this.reshte;
      json['token'] = this.token;
      json['education'] = this.education;
      return json;
  }

  String kindName()=>fnRelationName(this.kind);
  String isargariName()=>fnIsargariName(this.isargari);
  String educationName()=>fnEducationName(this.education);
}

class Director{
  int cmpid;
	int peopid;
	String name;
	String family;
	String nationalid;
	String mobile;
	int active;
	int semat;
	String etebardate;
	int etebarno;
	String begindate;
	int signright;
  bool showfamily;
  String token;

  Director({this.cmpid, this.peopid, this.name, this.family, this.nationalid, this.mobile, this.active,this.semat,this.etebardate,this.etebarno,this.begindate,this.signright, this.showfamily, this.token});

  Director.fromJson(Map<String, dynamic> json)
    :peopid = json['peopid'],
     name = json['name'],
     family = json['family'],
     nationalid= json['nationalid'],
     mobile = json['mobile'],
     active = json['active'],
     semat = json['semat'],
     etebardate = json['etebardate'],
     etebarno = json['etebarno'],
     begindate = json['begindate'],
     signright = json['signright'],
     showfamily = false;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['cmpid'] = this.cmpid;
     json['peopid'] = this.peopid;
     json['active'] = this.active;
     json['semat'] = this.semat;
     json['etebardate'] = this.etebardate;
     json['etebarno'] = this.etebarno;
     json['begindate'] = this.begindate;
     json['signright'] = this.signright;
     json['token'] = this.token;

     return json;
  }

  String sematName(){
    switch (this.semat){
			case 1: 
        return "رئیس";
        break;
			case 2: 
        return "نایب رئیس اول";
        break;
			case 3: 
        return "نایب رئیس دوم";
        break;
			case 4: 
        return "عضو";
        break;
			case 5: 
        return "خزانه دار";
        break;
			case 6: 
        return "بازرس";
        break;
			case 7: 
        return "دبیر";
        break;
    }
    return "";
  }
}

class DrtFamily{
	int cmpid;
  int drtid;
  int peopid;
	String name;
	String family;
	String father;
	String nationalid;
	String ss;
	String birth;
	String birthdate;
	String ssplace;
  int single;
	int education;
	String reshte;
	int isargari;
	int kind;
	String job;
	String mdate;
	String note;
  String token;

  DrtFamily({this.cmpid, this.drtid, this.peopid,this.name,this.family, this.father, this.nationalid, this.ss, this.birth, this.birthdate, this.ssplace, this.education, this.reshte, this.isargari, this.kind,this.job,this.mdate,this.note, this.token});

  DrtFamily.fromJson(Map<String, dynamic> json)
    : peopid = json['peopid'],
	   name = json['name'],
	   family = json['family'],
	   father = json['father'],
	   nationalid = json['nationalid'],
	   ss = json['ss'],
	   birth = json['birth'],
	   birthdate = json['birthdate'],
	   ssplace = json['ssplace'],
	   single = json['single'],
	   education = json['education'],
	   reshte = json['reshte'],
	   isargari = json['isargari'],
     kind = json['kind'],
     job = json['job'],
     mdate = json['mdate'],
     note = json['note'];

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['cmpid'] = this.cmpid;
     json['drtid'] = this.drtid;
     json['peopid'] = this.peopid;
     json['kind'] = this.kind;
     json['job'] = this.job;
     json['mdate'] = this.mdate;
     json['note'] = this.note;
     json['token'] = this.token;

     return json;
  }
  String kindName()=>fnRelationName(this.kind);
  String isargariName()=>fnIsargariName(this.isargari);
  String educationName()=>fnEducationName(this.education);
}

class Bank{
	int id;
  String name;
  String token;
  bool editing;

  Bank({this.id,this.name, this.token, this.editing = false});

  Bank.fromJson(Map<String, dynamic> json)
	  : id = json['id'],
  	 name = json['name'],
     editing = false;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
	   json['id'] = this.id;
  	 json['name'] = this.name;
  	 json['token'] = this.token;

     return json;
  }
}

class Violation{
	int id;
  String name;
  String token;
  bool editing;

  Violation({this.id,this.name, this.token, this.editing = false});

  Violation.fromJson(Map<String, dynamic> json)
	  : id = json['id'],
  	 name = json['name'],
     editing = false;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
	   json['id'] = this.id;
  	 json['name'] = this.name;
     json['token'] = this.token;

     return json;
  }
}

class Document{
	int id;
  String name;
  int expdate;
  String token;
  bool editing;

  Document({this.id,this.name,this.expdate = 1, this.token, this.editing = false});

  Document.fromJson(Map<String, dynamic> json)
	  : id = json['id'],
  	 name = json['name'],
  	 expdate = json['expdate'],
     editing = false;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
	   json['id'] = this.id;
  	 json['name'] = this.name;
     json['expdate'] = this.expdate;
     json['token'] = this.token;

     return json;
  }
}

class Gov{
	int id;
	String name;
	String family;
	String mobile;
	String tel;
	String post;
	String address;
	String note;
  String token;

  Gov({this.id,this.name,this.family,this.mobile="",this.tel="",this.post="",this.address="",this.note="", this.token});

  Gov.fromJson(Map<String, dynamic> json)
    :id = json['id'],
     name = json['name'],
     family = json['family'],
     mobile = json['mobile'],
     tel = json['tel'],
     post = json['post'],
     address = json['address'],
     note = json['note'];

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['id'] = this.id;
     json['name'] = this.name;
     json['family'] = this.family;
     json['mobile'] = this.mobile;
     json['tel'] = this.tel;
     json['post'] = this.post;
     json['address'] = this.address;
     json['note'] = this.note;
     json['token'] = this.token;

     return json;
  }
}

class AddInfo{
	int id;
	String name;
	int kind;
	bool dublicate;
  String token;
  bool edit;
  bool notes;
  bool forms;
  int notecount;
  bool insearch;

  AddInfo({this.id,this.name,this.kind=1,this.dublicate = false, this.token, this.edit = false, this.notes = false, this.forms = false, this.notecount = 0, this.insearch = true});

  AddInfo.fromJson(Map<String, dynamic> json)
    :id = json['id'],
     name = json['name'],
     kind = json['kind'],
     notecount = json['notecount'] ?? 0,
     dublicate = json['dublicate'] == 1,
     edit = false,
     notes = false,
     forms = false,
     insearch = true;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['token'] = this.token;
     json['id'] = this.id;
     json['name'] = this.name;
     json['kind'] = this.kind;
     json['dublicate'] = this.dublicate ? 1: 0;

     return json;
  }

  String kindName(){
    if (kind==1) return "حروفی";
    else if (kind==2) return "عددی";
    else if (kind==3) return "تاریخی";
    else if (kind==4) return "بله و خیر";
    return "";
  }
}

class AddInfoNote{
  int addid;
	int id;
	String note;
  String token;
  bool edit;

  AddInfoNote({this.addid,this.id,this.note, this.token, this.edit = false});

  AddInfoNote.fromJson(Map<String, dynamic> json)
    :addid = json['addid'],
     id = json['id'],
     note = json['note'],
     edit = false;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['addid'] = this.addid;
     json['id'] = this.id;
     json['note'] = this.note;
     json['token'] = this.token;

     return json;
  }
}

class AddInfoData{
  int addid;
  String name;
  int kind;
  String note;
  String token;
  bool edit;

  AddInfoData({this.addid,this.name,this.kind,this.note = "", this.token, this.edit = false});

  AddInfoData.fromJson(Map<String, dynamic> json)
    :addid = json['addid'],
     name = json['name'],
     kind = json['kind'],
     note = json['note'],
     edit = false;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['token'] = this.token;
     json['addid'] = this.addid;
     json['name'] = this.name;
     json['kind'] = this.kind;
     json['note'] = this.note;

     return json;
  }
}

class UserGroup{
  int id;
  String name;
  String token;
  bool edit;
  bool permission;
  bool users;

  UserGroup({this.id,this.name, this.edit = false, this.permission = false, this.users = false, this.token = ""});

  UserGroup.fromJson(Map<String, dynamic> json)
    :id = json['id'],
     name = json['name'],
     edit = false,
     permission = false,
     users = false;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['token'] = this.token;
     json['grpid'] = this.id;
     json['grpname'] = this.name;

     return json;
  }
}

class GroupPermission{
  int grpid;
  int id;
  String title;
  bool valid;
  String token;
  bool insearch;

  GroupPermission({this.grpid, this.id, this.title, this.valid, this.token, this.insearch = true});

  GroupPermission.fromJson(Map<String, dynamic> json)
    :grpid = json['grpid'],
     id = json['id'],
     title = json['title'],
     valid = json['valid'] == 1,
     insearch = true;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['token'] = this.token;
     json['grpid'] = this.grpid;
     json['prvid'] = this.id;
     json['valid'] = (this.valid ?? false) ? 1 : 0;

     return json;
  }
}

class GroupUser{
  int grpid;
  int userid;
  int cmpid;
  String cmpname;
  String family;
  String mobile;
  String username;
  String lastLogin;
  bool insearch;
  String token;
  bool valid;
  bool active;

  GroupUser({this.grpid, this.userid, this.cmpid, this.cmpname, this.family, this.mobile, this.username, this.lastLogin, this.insearch = true, this.token, this.valid, this.active});

  GroupUser.fromJson(Map<String, dynamic> json)
    :grpid = json['grpid'],
     userid = json['userid'],
     cmpid = json['cmpid'],
     cmpname = json['cmpname'],
     family = json['family'],
     mobile = json['mobile'],
     username = json['username'],
     lastLogin = json['lastlogin'],
     valid = json['valid'] == 1,
     active = json['active'] == 1,
     insearch = true;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['grpid'] = this.grpid;
     json['userid'] = this.userid;
     json['cmpname'] = this.cmpname;
     json['family'] = this.family;
     json['mobile'] = this.mobile;
     json['username'] = this.username;
     json['lastLogin'] = this.lastLogin;
     json['token'] = this.token;

     return json;
  }
}

class Committee{
  int cmpid;
  int id;
  String name;
  int kind;
  int empid;
  String empfamily;
  String token;
  bool edit;
  bool member;
  bool detail;

  Committee({this.cmpid,this.id,this.name,this.kind,this.empid,this.empfamily, this.edit = false, this.member=false, this.detail=false, this.token});

  Committee.fromJson(Map<String, dynamic> json)
    :cmpid = json['cmpid'],
     id = json['id'],
     name = json['name'],
     kind = json['kind'],
     empid = json['empid'],
     empfamily = json['empfamily'],
     edit = false,
     member = false,
     detail = false;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['cmpid'] = this.cmpid;
     json['id'] = this.id;
     json['name'] = this.name;
     json['kind'] = this.kind;
     json['empid'] = this.empid;
     json['token'] = this.token;

     return json;
  }

  String kindName(){
			if (this.kind == 1)
        return "جلسه درون سازمانی";
			if (this.kind == 2)
        return "جلسه برون سازمانی";
			if (this.kind == 3)
        return "کمیسیون بازرسی و رسیدگی به شکایات";
			if (this.kind == 4)
        return "کمیسیون حل اختلاف و تشخیص";
			if (this.kind == 5)
        return "کمیسیون امور اقتصادی";
			if (this.kind == 6)
        return "کمیسیون آموزش و پژوهش";
			if (this.kind == 7)
        return "کمیسیون بودجه و تشکیلات";
			if (this.kind == 8)
        return "کمیسیون امور اجتماعی و فرهنگی";
			if (this.kind == 9)
        return "کمیسیون رسیدگی به شکایات";
			if (this.kind == 10)
        return "کمیسیون حل اختلاف";
			if (this.kind == 11)
        return "کمیسیون فنی";
			if (this.kind == 12)
        return "کمیسیون بازرسی واحد های صنفی";
			if (this.kind == 13)
        return "کمیسیون آموزش";
      return "";
  }
}

class CommitteeMember{
  int cmpid;
  int cmtid;
  int old;
  int peopid;
  String name;
  String family;
  int semat;
  String token;
  bool edit;

  CommitteeMember({this.cmpid,this.cmtid,this.old,this.peopid,this.name,this.family,this.semat,this.token, this.edit=false});

  CommitteeMember.fromJson(Map<String, dynamic> json)
    :cmpid = json['cmpid'],
     cmtid = json['cmtid'],
     old = json['peopid'],
     peopid = json['peopid'],
     name = json['name'],
     family = json['family'],
     semat = json['semat'],
     edit = false;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['cmpid'] = this.cmpid;
     json['cmtid'] = this.cmtid;
     json['old'] = this.old ?? 0;
     json['peopid'] = this.peopid;
     json['peopid'] = this.peopid;
     json['name'] = this.name;
     json['family'] = this.family;
     json['semat'] = this.semat;
     json['token'] = this.token;

     return json;
  }

  String sematName(){
    if (this.semat == 1)
      return "رییس";
    if (this.semat == 2)
      return "نایب رییس";
    if (this.semat == 3)
      return "منشی";
    if (this.semat == 4)
      return "عضو";
    return "";
  }
}

class CommitteeDetail{
  int cmpid;
  int cmtid;
  int id;
  String title;
  String date;
  String time;
  int empid;
  String empfamily;
  String note;
  String token;
  bool edit;
  bool absent;
  bool mosavabat;

  CommitteeDetail({this.cmpid,this.cmtid,this.id,this.title,this.date,this.time,this.empid,this.empfamily,this.note,this.token, this.edit=false, this.absent=false, this.mosavabat=false});

  CommitteeDetail.fromJson(Map<String, dynamic> json)
    :cmpid = json['cmpid'],
     cmtid = json['cmtid'],
     id = json['id'],
     title = json['title'],
     date = json['date'],
     time = json['time'],
     empid = json['empid'],
     empfamily = json['empfamily'],
     note = json['note'],
     edit = false,
     absent = false,
     mosavabat = false;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['cmpid'] = this.cmpid;
     json['cmtid'] = this.cmtid;
     json['id'] = this.id;
     json['title'] = this.title;
     json['date'] = this.date ?? "";
     json['time'] = this.time ?? "";
     json['empid'] = this.empid;
     json['note'] = this.note ?? "";
     json['token'] = this.token;

     return json;
  }
}

class CommitteeDetailAbsent{
  int cmpid;
  int cmtid;
  int detailid;
  int peopid;
  String peopfamily;
  String semat;
  String token;

  CommitteeDetailAbsent({this.cmpid,this.cmtid,this.detailid,this.peopid,this.peopfamily, this.token, this.semat});

  CommitteeDetailAbsent.fromJson(Map<String, dynamic> json)
    :cmpid = json['cmpid'],
     cmtid = json['cmtid'],
     detailid = json['detailid'],
     peopid = json['peopid'],
     peopfamily = json['peopfamily'],
     semat = json['semat'];

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['cmpid'] = this.cmpid;
     json['cmtid'] = this.cmtid;
     json['id'] = this.detailid;
     json['empid'] = this.peopid;
     json['token'] = this.token;

     return json;
  }
}

class CommitteeDetailMosavabat{
  int cmpid;
  int cmtid;
  int detailid;
  int id;
  String title;
  String vahed;
  int empid;
  String empfamily;
  int mcmpid;
  String mcmpname;
  String token;

  CommitteeDetailMosavabat({this.cmpid,this.cmtid,this.detailid,this.id,this.title, this.vahed, this.empid, this.empfamily, this.mcmpid, this.mcmpname, this.token});

  CommitteeDetailMosavabat.fromJson(Map<String, dynamic> json)
    :cmpid = json['cmpid'],
     cmtid = json['cmtid'],
     detailid = json['detailid'],
     id = json['id'],
     title = json['title'],
     vahed = json['vahed'],
     empid = json['empid'],
     empfamily = json['empfamily'],
     mcmpid = json['mcmpid'],
     mcmpname = json['mcmpname'];

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
     json['cmpid'] = this.cmpid;
     json['cmtid'] = this.cmtid;
     json['detailid'] = this.detailid;
     json['id'] = this.id;
     json['title'] = this.title;
     json['vahed'] = this.vahed;
     json['empid'] = this.empid;
     json['mcmpid'] = this.mcmpid;
     json['token'] = this.token;

     return json;
  }
}

class Property{
	int cmpid;
	int id;
	int kind;
	String name;
	int active;
	String buydate;
	String owner;
	int peopid;
  String peopfamily;
	String color;
	String status;
	String pelak;
	int malekiat;
	String usage;
	String contractdate;
	double price;
	double cprice;
	int metraj;
	int age;
	String karbari;
	int tenant;
	String address;
	int accounttype;
	int bankid;
  String bankName;
	String bcondition;
	String hesabno;
	String shaba;
	String cardno;
	int internetbank;
	int tafsiliid;
	String token;

  Property({this.cmpid,this.id,this.kind,this.name,this.active,this.buydate,this.owner,this.peopid, this.peopfamily,this.color,this.status,this.pelak,this.malekiat,this.usage,this.contractdate,this.price,this.cprice,this.metraj,this.age,this.karbari,this.tenant,this.address,this.accounttype,this.bankid,this.bankName,this.bcondition,this.hesabno,this.shaba,this.cardno,this.internetbank,this.tafsiliid,this.token});

  Property.fromJson(Map<String, dynamic> json)
    :cmpid = json['cmpid'],
    id = json['id'],
    kind = json['kind'],
    name = json['name'],
    active = json['active'],
    buydate = json['buydate'],
    owner = json['owner'],
    peopid = json['peopid'],
    peopfamily = json['peopfamily'],
    color = json['color'],
    status = json['status'],
    pelak = json['pelak'],
    malekiat = json['malekiat'],
    usage = json['usage'],
    contractdate = json['contractdate'],
    price = json['price'],
    cprice = json['cprice'],
    metraj = json['metraj'],
    age = json['age'],
    karbari = json['karbari'],
    tenant = json['tenant'],
    address = json['address'],
    accounttype = json['accounttype'],
    bankid = json['bankid'],
    bankName = json['bankname'],
    bcondition = json['bcondition'],
    hesabno = json['hesabno'],
    shaba = json['shaba'],
    cardno = json['cardno'],
    internetbank = json['internetbank'],
    tafsiliid = json['tafsiliid'],
    token = json['token'];

  Map<String, dynamic> toMobileJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
    json['cmpid'] = cmpid;
    json['id'] = id;
    json['name'] = name;
    json['active'] = active;
    json['buydate'] = buydate;
    json['owner'] = owner;
    json['peopid'] = peopid;
    json['token'] = token;
    return json;
  }

  Map<String, dynamic> toCarJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
    json['cmpid'] = cmpid;
    json['id'] = id;
    json['name'] = name;
    json['buydate'] = buydate;
    json['color'] = color;
    json['status'] = status;
    json['pelak'] = pelak;
    json['peopid'] = peopid;
    json['token'] = token;
    return json;
  }

  Map<String, dynamic> toPropGHMJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
    json['cmpid'] = cmpid;
    json['id'] = id;
    json['name'] = name;
    json['malekiat'] = malekiat;
    json['usage'] = usage;
    json['contractdate'] = contractdate;
    json['price'] = price;
    json['metraj'] = metraj;
    json['age'] = age;
    json['cprice'] = cprice;
    json['karbari'] = karbari;
    json['tenant'] = tenant;
    json['pelak'] = pelak;
    json['address'] = address;
    json['token'] = token;
    return json;
  }
  
  Map<String, dynamic> toBankHesabJson(){
    Map<String, dynamic> json = new Map<String, dynamic>();
    json['cmpid'] = cmpid;
    json['id'] = id;
    json['accounttype'] = accounttype;
    json['bankid'] = bankid;
    json['buydate'] = buydate;
    json['owner'] = owner;
    json['bcondition'] = bcondition;
    json['hesabno'] = hesabno;
    json['shaba'] = shaba;
    json['cardno'] = cardno;
    json['tafsiliid'] = tafsiliid;
    json['internetbank'] = internetbank;
    json['token'] = token;
    return json;
  }

  String malekiatName(){
    return this.malekiat==1 
      ? 'تملیک' 
      : this.malekiat==2
			  ? 'استیجاری'
        : '';
  }
  String tenantName(){
    return this.tenant==1 
      ? 'اتحادیه' 
      : this.tenant==2
			  ? 'اتاق'
        : this.tenant==3
	  		  ? 'مستاجر'
          : '';
  }
  String accountTypeName(){
    return this.accounttype==1 
      ? 'جاری' 
      : this.accounttype==2
			  ? 'سپرده'
        : this.accounttype==3
	  		  ? 'قرض الحسنه'
          : '';
  }
} 

class Inspection{
    int cmpid;
    int id;
    String name;
    String topic;
    String bdate;
    String edate;
    String range;
    String note;
    String token;
    bool gov;
    bool compay;
 
    Inspection({this.cmpid,this.id,this.name,this.topic,this.bdate,this.edate,this.range,this.note, this.token, this.gov=false, this.compay=false});
 
    Inspection.fromJson(Map<String, dynamic> json):
        cmpid = json['cmpid'],
        id = json['id'],
        name = json['name'],
        topic = json['topic'],
        bdate = json['bdate'],
        edate = json['edate'],
        range = json['range'],
        note = json['note'],
        compay = false,
        gov = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['cmpid'] = this.cmpid;
        data['id'] = this.id;
        data['name'] = this.name;
        data['topic'] = this.topic;
        data['bdate'] = this.bdate;
        data['edate'] = this.edate;
        data['range'] = this.range;
        data['note'] = this.note;
        data['token'] = this.token;
        return data;
    }
}

class Inspectioncompany{
    int insid;
    int cmpid;
    String cmpname;
    String note;
    String token;
    bool edit;
    bool peop;
    bool emp;
 
    Inspectioncompany({this.insid,this.cmpid,this.cmpname,this.note, this.token, this.edit=false, this.peop=false, this.emp=false});
 
    Inspectioncompany.fromJson(Map<String, dynamic> json):
        insid = json['insid'],
        cmpid = json['cmpid'],
        cmpname = json['cmpname'],
        note = json['note'],
        edit = false,
        peop = false,
        emp = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['insid'] = this.insid;
        data['cmpid'] = this.cmpid;
        data['cmpname'] = this.cmpname;
        data['note'] = this.note;
        data['token'] = this.token;
        return data;
    }
}

class Inspectioncompanypeop{
    int insid;
    int cmpid;
    int peopid;
    String peopfamily;
    int kind;
    String token;
    bool valid;
 
    Inspectioncompanypeop({this.insid,this.cmpid,this.peopid,this.peopfamily,this.kind, this.token, this.valid});
 
    Inspectioncompanypeop.fromJson(Map<String, dynamic> json):
        insid = json['insid'],
        cmpid = json['cmpid'],
        peopid = json['peopid'],
        peopfamily = json['peopfamily'],
        kind = json['kind'],
        valid = json['valid'] == 1;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['insid'] = this.insid;
        data['cmpid'] = this.cmpid;
        data['peopid'] = this.peopid;
        data['peopfamily'] = this.peopfamily;
        data['kind'] = this.kind;
        data['token'] = this.token;
        return data;
    }
}

class Inspectiongov{
    int insid;
    int govid;
    String govname;
    String note;
    String token;
    bool edit;
 
    Inspectiongov({this.insid,this.govid,this.govname,this.note, this.token, this.edit=false});
 
    Inspectiongov.fromJson(Map<String, dynamic> json):
        insid = json['insid'],
        govid = json['govid'],
        govname = json['govname'],
        note = json['note'],
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['insid'] = this.insid;
        data['govid'] = this.govid;
        data['govname'] = this.govname;
        data['note'] = this.note;
        data['token'] = this.token;
        return data;
    }
}

class Nolicense{
    int cmpid;
    String cmpname;
    int id;
    int peopid;
    String name;
    String family;
    String nationalid;
    int hisic;
    int isic;
    String isicname;
    String tel;
    String post;
    String nosazicode;
    String address;
    String note;
    String token;
    bool inSearch;
 
    Nolicense({this.cmpid,this.cmpname="",this.id,this.peopid,this.name="",this.family="",this.nationalid="",this.hisic,this.isic,this.isicname="",this.tel="",this.post="",this.nosazicode="",this.address="",this.note="", this.token, this.inSearch = true});
 
    Nolicense.fromJson(Map<String, dynamic> json):
        cmpid = json['cmpid'],
        cmpname = json['cmpname'],
        id = json['id'],
        peopid = json['peopid'],
        name = json['name'],
        family = json['family'],
        nationalid = json['nationalid'],
        hisic = json['hisic'],
        isic = json['isic'],
        isicname = json['isicname'],
        tel = json['tel'],
        post = json['post'],
        nosazicode = json['nosazicode'],
        address = json['address'],
        note = json['note'],
        inSearch = true;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['cmpid'] = this.cmpid;
        data['id'] = this.id;
        data['name'] = this.name;
        data['family'] = this.family;
        data['nationalid'] = this.nationalid;
        data['hisic'] = this.hisic;
        data['isic'] = this.isic;
        data['tel'] = this.tel;
        data['post'] = this.post;
        data['nosazicode'] = this.nosazicode;
        data['address'] = this.address;
        data['note'] = this.note;
        data['token'] = this.token;
        return data;
    }
}

class Income{
    int id;
    String name;
    bool active;
    bool epay;
    bool refund;
    bool off;
    bool allcmp;
    String token;
    double price;
    bool edit;
    bool company;
    bool share;
    bool pricehistory;
 
    Income({this.id,this.name,this.active,this.epay,this.refund,this.off,this.allcmp, this.token, this.edit=false, this.price, this.share=false, this.pricehistory=false, this.company=false});
 
    Income.fromJson(Map<String, dynamic> json):
        id = json['id'],
        name = json['name'],
        active = json['active'] == 1,
        epay = json['epay'] == 1,
        refund = json['refund'] == 1,
        off = json['off'] == 1,
        allcmp = json['allcmp'] == 1,
        price = json['price'],
        edit = false,
        share = false,
        pricehistory = false,
        company = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        data['active'] = this.active ? 1 : 0;
        data['epay'] = this.epay ? 1 : 0;
        data['refund'] = this.refund ? 1 : 0;
        data['off'] = this.off ? 1 : 0;
        data['allcmp'] = this.allcmp ? 1 : 0;
        data['token'] = this.token;
        return data;
    }
}

class Incomeshare{
    int incid;
    int id;
    String name;
    int perc;
    String token;
    bool edit;
 
    Incomeshare({this.incid,this.id,this.name,this.perc, this.token, this.edit=false});
 
    Incomeshare.fromJson(Map<String, dynamic> json):
        incid = json['incid'],
        id = json['id'],
        name = json['name'],
        perc = json['perc'],
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['incid'] = this.incid;
        data['id'] = this.id;
        data['name'] = this.name;
        data['perc'] = this.perc;
        data['token'] = this.token;
        return data;
    }
}

class Incomehistory{
    int incid;
    int id;
    String date;
    double price;
    String token;
    bool edit;
 
    Incomehistory({this.incid,this.id,this.date,this.price, this.token, this.edit=false});
 
    Incomehistory.fromJson(Map<String, dynamic> json):
        incid = json['incid'],
        id = json['id'],
        date = json['date'],
        price = json['price'],
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['incid'] = this.incid;
        data['id'] = this.id;
        data['date'] = this.date;
        data['price'] = this.price;
        data['token'] = this.token;
        return data;
    }
}

class Incomecompany{
    int incid;
    int cmpid;
    int old;
    String cmpname;
    bool allraste;
    String token;
    bool edit;
 
    Incomecompany({this.incid,this.old,this.cmpid,this.cmpname,this.allraste, this.token, this.edit=false});
 
    Incomecompany.fromJson(Map<String, dynamic> json):
        incid = json['incid'],
        old = json['cmpid'],
        cmpid = json['cmpid'],
        cmpname = json['cmpname'],
        allraste = (json['allraste'] ?? 0) == 1,
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['incid'] = this.incid;
        data['old'] = this.old;
        data['cmpid'] = this.cmpid;
        data['cmpname'] = this.cmpname;
        data['allraste'] = this.allraste ? 1 : 0;
        data['token'] = this.token;
        return data;
    }
}

class Incomecompanyraste{
    int incid;
    int cmpid;
    int id;
    String name;
    int hisic;
    int isic;
    bool grade1;
    bool grade2;
    bool grade3;
    bool grade4;
    String token;
    bool edit;
 
    Incomecompanyraste({this.incid,this.cmpid,this.id,this.name,this.hisic,this.isic,this.grade1,this.grade2,this.grade3,this.grade4, this.token, this.edit=false});
 
    Incomecompanyraste.fromJson(Map<String, dynamic> json):
        incid = json['incid'],
        cmpid = json['cmpid'],
        id = json['id'],
        name = json['name'],
        hisic = json['hisic'],
        isic = json['isic'],
        grade1 = json['grade1'] == 1,
        grade2 = json['grade2'] == 1,
        grade3 = json['grade3'] == 1,
        grade4 = json['grade4'] == 1,
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['incid'] = this.incid;
        data['cmpid'] = this.cmpid;
        data['id'] = this.id;
        data['name'] = this.name;
        data['hisic'] = this.hisic;
        data['isic'] = this.isic;
        data['grade1'] = this.grade1 ? 1 : 0;
        data['grade2'] = this.grade2 ? 1 : 0;
        data['grade3'] = this.grade3 ? 1 : 0;
        data['grade4'] = this.grade4 ? 1 : 0;
        data['token'] = this.token;
        return data;
    }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({ this.milliseconds });

  run(VoidCallback action) {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class ExcelRow{
  bool check;
  List<dynamic> cells;
  String error;
  bool imported;

  ExcelRow({@required this.check, @required this.cells, this.error, this.imported = false});
}

class Attach{
    int radif;
    String filename;
    String ext;
    String size;
    String token;
 
    Attach({this.radif,this.filename,this.ext,this.size, this.token});
 
    Attach.fromJson(Map<String, dynamic> json):
        radif = json['radif'],
        filename = json['filename'],
        ext = json['ext'],
        size = json['size'];
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['radif'] = this.radif;
        data['filename'] = this.filename;
        data['ext'] = this.ext;
        data['size'] = this.size;
        data['token'] = this.token;
        return data;
    }

    String filetype(){
      if (this.ext=='png' || this.ext=='jpg' || this.ext=='jpeg' || this.ext=='bmp')
        return 'image';
			if (this.ext=='xls' || this.ext=='xlsx')
        return 'excel';
			if (this.ext=='doc')
        return 'word';
			if (this.ext=='pdf')
        return 'pdf';
			if (this.ext=='rar')
        return 'rar';
			if (this.ext=='ppt')
        return 'powerpoint';
			if (this.ext=='mp3')
        return 'mp3';
			if (this.ext=='mp4' || this.ext=='avi' || this.ext=='mkv' || this.ext=='ogg')
        return 'mp3';
			
      return 'other';
    }
}

class Topic{
    int id;
    String title;
    List<String> teachers;
    bool edit;
    String token;
 
    Topic({this.id,this.title, this.token, this.edit=false, this.teachers});
 
    Topic.fromJson(Map<String, dynamic> json):
        id = json['id'],
        title = json['title'],
        teachers = json['teachers'].toString().trim().split(','),
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['title'] = this.title;
        data['token'] = this.token;
        // data['teachers'] = this.teachers;
        return data;
    }
}

class TopicTeacher{
    bool valid;
    int topicid;
    int id;
    String name;
    String family;
    bool teacheract;
    bool active;
    String token;
 
    TopicTeacher({this.valid,this.topicid,this.id,this.name,this.family,this.teacheract,this.active, this.token});
 
    TopicTeacher.fromJson(Map<String, dynamic> json):
        valid = json['valid'] == 1,
        topicid = json['topicid'],
        id = json['id'],
        name = json['name'],
        family = json['family'],
        teacheract = json['teacheract'] == 1,
        active = json['active'] == 1;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['topicid'] = this.topicid;
        data['id'] = this.id;
        data['active'] = this.active ? 1 : 0;
        data['token'] = this.token;
        return data;
    }
}

class TeacherTopic{
    bool valid;
    int peopid;
    int id;
    String title;
    bool active;
    String token;
 
    TeacherTopic({this.valid,this.peopid,this.id,this.title,this.active, this.token});
 
    TeacherTopic.fromJson(Map<String, dynamic> json):
        valid = json['valid']==1,
        peopid = json['peopid'],
        id = json['id'],
        title = json['title'],
        active = json['active']==1;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['peopid'] = this.peopid;
        data['topicid'] = this.id;
        data['active'] = this.active ? 1 : 0;
        data['token'] = this.token;
        return data;
    }
}

class Teacher{
    int id;
    String nationalid;
    String name;
    String family;
    int education;
    String mobile;
    bool teacheract;
    String teacherbegindate;
    String teacherenddate;
    String shaba;
    String teachernote;
    String token;
    bool edit;
 
    Teacher({this.id,this.nationalid,this.name,this.family,this.education,this.mobile,this.teacheract=true,this.teacherbegindate='',this.teacherenddate='',this.shaba='',this.teachernote='', this.token, this.edit=false});
 
    Teacher.fromJson(Map<String, dynamic> json):
        id = json['id'],
        nationalid = json['nationalid'],
        name = json['name'],
        family = json['family'],
        education = json['education'],
        mobile = json['mobile'],
        teacheract = json['teacheract']==1,
        teacherbegindate = json['teacherbegindate'],
        teacherenddate = json['teacherenddate'],
        shaba = json['shaba'],
        teachernote = json['teachernote'],
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['teacheract'] = this.teacheract ? 1 : 0;
        data['teacherbegindate'] = this.teacherbegindate;
        data['teacherenddate'] = this.teacherenddate;
        data['shaba'] = this.shaba;
        data['teachernote'] = this.teachernote;
        data['token'] = this.token;
        return data;
    }

    String educationName()=>fnEducationName(this.education);
}

class Prcstep{
    int processid;
    int id;
    bool active;
    int kind;
    int length;
    bool startprevend;
    bool restart;
    bool sms;
    bool err27;
    String token;
    bool edit;
 
    Prcstep({this.processid,this.id,this.active,this.kind,this.length=0,this.startprevend,this.restart,this.sms,this.err27, this.token, this.edit=false});
 
    Prcstep.fromJson(Map<String, dynamic> json):
        processid = json['processid'],
        id = json['id'],
        active = json['active'] == 1,
        kind = json['kind'],
        length = json['length'],
        startprevend = json['startprevend'] == 1,
        restart = json['restart'] == 1,
        sms = json['sms'] == 1,
        err27 = json['err27'] == 1,
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['processid'] = this.processid;
        data['id'] = this.id;
        data['active'] = this.active ? 1 : 0;
        data['kind'] = this.kind;
        data['length'] = this.length;
        data['startprevend'] = this.startprevend ? 1 : 0;
        data['restart'] = this.restart ? 1 : 0;
        data['sms'] = this.sms ? 1 : 0;
        data['err27'] = this.err27 ? 1 : 0;
        data['token'] = this.token;
        return data;
    }

    String kindName(){
      switch (this.kind) {
        case 1:
          return 'مدرک';
          break;
        case 2:
          return 'هیئت مدیره';
          break;
        case 3:
          return 'بازرسی';
          break;
        case 4:
          return 'حسابداری';
          break;
        case 5:
          return 'آموزش';
          break;
      }
      return "";
    }
}

class Process{
    int id;
    bool active;
    String title;
    int kind;
    bool recon;
    bool allcmp;
    int duration;
    bool edit;
    bool showStep;
    bool showComnpany;
    String token;
 
    Process({this.id,this.active,this.title,this.kind,this.recon,this.allcmp, this.token, this.edit=false, this.duration=0, this.showStep=false,this.showComnpany=false});
 
    Process.fromJson(Map<String, dynamic> json):
        id = json['id'],
        active = json['active'] == 1,
        title = json['title'],
        kind = json['kind'],
        duration = json['duration'],
        recon = json['recon'] == 1,
        allcmp = json['allcmp'] == 1,
        showStep = false,
        showComnpany = false,
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['active'] = this.active ? 1 : 0;
        data['title'] = this.title;
        data['kind'] = this.kind;
        data['recon'] = this.recon ? 1 : 0;
        data['allcmp'] = this.allcmp ? 1 : 0;
        data['token'] = this.token;
        return data;
    }

    String kindName(){
      switch (this.kind) {
        case 1:
          return 'صدور';
          break;
        case 2:
          return 'تمدید';
          break;
        case 3:
          return 'تغییر نشانی';
          break;
        case 4:
          return 'تغییر مالکیت';
          break;
        case 5:
          return 'تغییر رسته';
          break;
        case 6:
          return 'معرفی/حذف مباشز';
          break;
        case 7:
          return 'مغرفی/حذف شریک';
          break;
        case 8:
          return 'تغییر درجه عضویت';
          break;
        case 9:
          return 'تعطیلی موقت';
          break;
        case 10:
          return '=بازگشایی';
          break;
        case 11:
          return '=ابطال';
          break;
      }
      return "";
    }
}

class PrcStepDocument{
  int processid;
  int stepid;
  int id;
  int documentid;
  String documentname;
  int kind;
  bool edit;
  bool search;
  String token;

  PrcStepDocument({this.processid,this.stepid,this.id,this.documentid,this.documentname,this.kind, this.token, this.edit=false, this.search=true});

  PrcStepDocument.fromJson(Map<String, dynamic> json):
      processid = json['processid'],
      stepid = json['stepid'],
      id = json['id'],
      documentid = json['documentid'],
      documentname = json['documentname'],
      kind = json['kind'],
      edit = false,
      search = true;

  Map<String, dynamic> toJson(){
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['processid'] = this.processid;
      data['stepid'] = this.stepid;
      data['id'] = this.id;
      data['documentid'] = this.documentid;
      data['documentname'] = this.documentname;
      data['kind'] = this.kind;
      data['token'] = this.token;
      return data;
  }

  String kindName(){
    switch (this.kind) {
        case 1:
          return 'فرد صنفی';
          break;
        case 2:
          return 'پروانه کسب';
          break;
        case 3:
          return 'واحد صنفی';
          break;
        case 4:
          return 'شریک';
          break;
        case 5:
          return 'مباشر';
          break;
        case 6:
          return 'کارکنان';
          break;
    }
    return "";
  }
}

class PrcStepIncome{
    int processid;
    int stepid;
    int incomeid;
    String incomename;
    String token;
 
    PrcStepIncome({this.processid,this.stepid,this.incomeid,this.incomename, this.token});
 
    PrcStepIncome.fromJson(Map<String, dynamic> json):
        processid = json['processid'],
        stepid = json['stepid'],
        incomeid = json['incomeid'],
        incomename = json['incomename'];
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['processid'] = this.processid;
        data['stepid'] = this.stepid;
        data['incomeid'] = this.incomeid;
        data['incomename'] = this.incomename;
        data['token'] = this.token;
        return data;
    }
}

class PrcStepCourse{
    int processid;
    int stepid;
    int courseid;
    String coursetitle;
    int kind;
    String token;
    bool edit;
 
    PrcStepCourse({this.processid,this.stepid,this.courseid,this.coursetitle,this.kind=1, this.token, this.edit=false});
 
    PrcStepCourse.fromJson(Map<String, dynamic> json):
        processid = json['processid'],
        stepid = json['stepid'],
        courseid = json['courseid'],
        coursetitle = json['coursetitle'],
        kind = json['kind'],
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['processid'] = this.processid;
        data['stepid'] = this.stepid;
        data['courseid'] = this.courseid;
        data['coursetitle'] = this.coursetitle;
        data['kind'] = this.kind;
        data['token'] = this.token;
        return data;
    }
    
    String kindName(){
      switch (this.kind) {
        case 1: return 'فرد صنفی';
        case 2: return 'مباشر';
        case 3: return 'شریک';
        case 4: return 'کارکنان';
      }
      return "";
    }
}

class PrcCompany{
    int processid;
    int cmpid;
    String cmpname;
    bool allraste;
    String token;
 
    PrcCompany({this.processid,this.cmpid,this.cmpname,this.allraste, this.token});
 
    PrcCompany.fromJson(Map<String, dynamic> json):
        processid = json['processid'],
        cmpid = json['cmpid'],
        cmpname = json['cmpname'],
        allraste = json['allraste'] == 1;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['processid'] = this.processid;
        data['cmpid'] = this.cmpid;
        data['cmpname'] = this.cmpname;
        data['allraste'] = this.allraste ? 1 : 0;
        data['token'] = this.token;
        return data;
    }
}

class PrcCmpRaste{
    int processid;
    int cmpid;
    int id;
    int hisic;
    int isic;
    String isicname;
    int degree;
    String token;
    bool edit;
 
    PrcCmpRaste({this.processid,this.cmpid,this.id=0,this.hisic=0,this.isicname='',this.isic=0,this.degree=5, this.token, this.edit=false});
 
    PrcCmpRaste.fromJson(Map<String, dynamic> json):
        processid = json['processid'],
        cmpid = json['cmpid'],
        id = json['id'],
        hisic = json['hisic'],
        isicname = json['isicname'],
        isic = json['isic'],
        degree = json['degree'],
        edit=false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['processid'] = this.processid;
        data['cmpid'] = this.cmpid;
        data['id'] = this.id;
        data['hisic'] = this.hisic;
        data['isicname'] = this.isicname;
        data['isic'] = this.isic;
        data['degree'] = this.degree;
        data['token'] = this.token;
        return data;
    }

    String degreeName(){
      switch (this.degree) {
        case 1:
          return 'درجه یک';
          break;
        case 2:
          return 'درجه دو';
          break;
        case 3:
          return 'درجه سه';
          break;
        case 4:
          return 'درجه چهار';
          break;
        case 5:
          return 'همه درجه ها';
          break;
      }
      return "";
    }
}

class Course{
    int id;
    bool active;
    String title;
    int kind;
    int type;
    int mindegree;
    int maxdegree;
    int absent;
    int valid;
    double price;
    double reprice;
    int noh1;
    int noh2;
    int nonh1;
    int nonh2;
    String token;
    bool edit;
    bool showclass;
 
    Course({this.id,this.active=true,this.title,this.kind=1,this.type=1,this.mindegree=1,this.maxdegree=1,this.absent=0,this.valid=0,this.price=0,this.reprice=0,this.noh1=10,this.noh2=10,this.nonh1=12,this.nonh2=10, this.token, this.edit=false, this.showclass = false});
 
    Course.fromJson(Map<String, dynamic> json):
        id = json['id'],
        active = json['active'] == 1,
        title = json['title'],
        kind = json['kind'],
        type = json['type'],
        mindegree = json['mindegree'],
        maxdegree = json['maxdegree'],
        absent = json['absent'],
        valid = json['valid'],
        price = json['price'],
        reprice = json['reprice'],
        noh1 = json['noh1'],
        noh2 = json['noh2'],
        nonh1 = json['nonh1'],
        nonh2 = json['nonh2'],
        showclass=false,
        edit=false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['active'] = this.active ? 1 : 0;
        data['title'] = this.title;
        data['kind'] = this.kind;
        data['type'] = this.type;
        data['mindegree'] = this.mindegree;
        data['maxdegree'] = this.maxdegree;
        data['absent'] = this.absent;
        data['valid'] = this.valid;
        data['price'] = this.price;
        data['reprice'] = this.reprice;
        data['noh1'] = this.noh1;
        data['noh2'] = this.noh2;
        data['nonh1'] = this.nonh1;
        data['nonh2'] = this.nonh2;
        data['token'] = this.token;
        return data;
    }

    String kindName(){
      switch (this.kind) {
        case 1: return 'آزاد';
        case 2: return 'صدور و تمدید';
      }
      return "";
    }

    String typeName(){
      switch (this.type) {
        case 1: return 'حضوری';
        case 2: return 'غیرحضوری';
        case 3: return 'حضوری و غیرحضوری';
      }
      return "";
    }

    String minDegreeName(){
      switch (this.mindegree) {
        case 1: return 'زیردیپلم';
        case 2: return 'دیپلم';
        case 3: return 'دانشجو';
        case 4: return 'کاردانی';
        case 5: return 'کارشناسی';
        case 6: return 'کارشناسی ارشد';
        case 7: return 'دکتری';
        case 8: return 'فوق دکتری';
      }
      return "";
    }

    String maxDegreeName(){
      switch (this.maxdegree) {
        case 1: return 'زیردیپلم';
        case 2: return 'دیپلم';
        case 3: return 'دانشجو';
        case 4: return 'کاردانی';
        case 5: return 'کارشناسی';
        case 6: return 'کارشناسی ارشد';
        case 7: return 'دکتری';
        case 8: return 'فوق دکتری';
      }
      return "";
    }
}

class Class{
    int courseid;
    int id;
    String title;
    String begindate;
    int hozori;
    int nothozori;
    String token;
    bool edit;
    bool showdetail;
 
    Class({this.courseid,this.id=0,this.title='',this.begindate='',this.hozori=0,this.nothozori=0, this.token, this.edit=false, this.showdetail=false});
 
    Class.fromJson(Map<String, dynamic> json):
        courseid = json['courseid'],
        id = json['id'],
        title = json['title'],
        begindate = json['begindate'],
        hozori = json['hozori'],
        nothozori = json['nothozori'],
        edit=false,
        showdetail=false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['courseid'] = this.courseid;
        data['id'] = this.id;
        data['title'] = this.title;
        data['begindate'] = this.begindate;
        data['hozori'] = this.hozori;
        data['nothozori'] = this.nothozori;
        data['token'] = this.token;
        return data;
    }
}

class DClass{
    int classid;
    int id;
    String date;
    String time;
    String place;
    int kind;
    int topicid;
    String topictitle;
    int peopid;
    String peopfamily;
    String token;
    bool edit;
 
    DClass({this.classid,this.id,this.date,this.time,this.place,this.kind,this.topicid,this.topictitle,this.peopid,this.peopfamily, this.token, this.edit = false});
 
    DClass.fromJson(Map<String, dynamic> json):
        classid = json['classid'],
        id = json['id'],
        date = json['date'],
        time = json['time'],
        place = json['place'],
        kind = json['kind'],
        topicid = json['topicid'],
        topictitle = json['topictitle'],
        peopid = json['peopid'],
        peopfamily = json['peopfamily'],
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['classid'] = this.classid;
        data['id'] = this.id;
        data['date'] = this.date;
        data['time'] = this.time;
        data['place'] = this.place;
        data['kind'] = this.kind;
        data['topicid'] = this.topicid;
        data['topictitle'] = this.topictitle;
        data['peopid'] = this.peopid;
        data['peopfamily'] = this.peopfamily;
        data['token'] = this.token;
        return data;
    }

    String kindName(){
      switch (this.kind) {
        case 1: return'تدریس';
        case 2: return'آزمون';
        case 3: return'آزمون حضوری';
        case 4: return'آزمون غیرحضوری';
      }
      return "";
    }
}

class GUnit{
    int id;
    String nosazicode;
    String hozeentezami;
    String markazbehdasht;
    int zaminmasahat;
    String pelak;
    int shahrdari;
    String address;
    String token;
 
    GUnit({this.id,this.nosazicode,this.hozeentezami,this.markazbehdasht,this.zaminmasahat = 0,this.pelak,this.shahrdari = 0,this.address, this.token});
 
    GUnit.fromJson(Map<String, dynamic> json):
        id = json['id'],
        nosazicode = json['nosazicode'],
        hozeentezami = json['hozeentezami'],
        markazbehdasht = json['markazbehdasht'],
        zaminmasahat = json['zaminmasahat'],
        pelak = json['pelak'],
        shahrdari = json['shahrdari'],
        address = json['address'];
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['nosazicode'] = this.nosazicode;
        data['hozeentezami'] = this.hozeentezami;
        data['markazbehdasht'] = this.markazbehdasht;
        data['zaminmasahat'] = this.zaminmasahat;
        data['pelak'] = this.pelak;
        data['shahrdari'] = this.shahrdari;
        data['address'] = this.address;
        data['token'] = this.token;
        return data;
    }
}

class Parvane{
    int cmpid;
    int old;
    int id;
    int iranianasnaf;
    String reqdate;
    int peopid;
    String peopname;
    String nationalid;
    String mobile;
    String lastprocess;
    String lastprocessstatus;
    String failprocess;
    int gunitid;
    String nosazicode;
    String guname;
    String gubegindate;
    String gutoolsinfo;
    String guensheabat;
    bool gubimemakan;
    String gubimeshobe;
    int gukargahno;
    int guzirbana;
    int gutabaghat;
    double gurent;
    int gudaraeicode;
    String guvahedmaliati;
    int guparvandemaliat;
    int gustatus;
    String gutel;
    String gufax;
    String guesteghrarplace;
    String gusigntitle;
    String gunote;
    int kind;
    int parvandekind;
    int ecoid;
    int bank;
    String hesabno;
    int hesabkind;
    int hisic;
    int isic;
    int hoghoghikind;
    String hoghoghiname;
    String hoghoghishenasemeli;
    int hoghoghisabtno;
    String hoghoghisabtdate;
    int parvanekind;
    String datesodor;
    String datetahvil;
    int etebarlen;
    int eparvaneno;
    String note;
    int shenasesenfi;
    int accept;
    String acceptdate;
    String bankname;
    String isicname;
    bool register;
    String token;
 
    Parvane({this.cmpid = 0, this.old=0 ,this.id = 0 ,this.iranianasnaf = 0 ,this.reqdate ,this.peopid = 0, this.peopname = "" ,this.gunitid = 0, this.nosazicode = "" ,this.guname = "",this.gubegindate = "",this.gutoolsinfo = '',this.guensheabat = '' ,this.gubimemakan = false ,this.gubimeshobe = '' ,this.gukargahno = 0 ,this.guzirbana = 0 ,this.gutabaghat = 0 ,this.gurent=0,this.gudaraeicode = 0 ,this.guvahedmaliati = '',this.guparvandemaliat = 0 ,this.gustatus = 1 ,this.gutel = '',this.gufax = "",this.guesteghrarplace = '',this.gusigntitle ='',this.gunote ='',this.kind = 1 ,this.parvandekind = 1 ,this.ecoid = 0 ,this.bank = 0 ,this.hesabno="" ,this.hesabkind = 1 ,this.hisic = 0 ,this.isic = 0 ,this.hoghoghikind = 1 ,this.hoghoghiname ="",this.hoghoghishenasemeli="",this.hoghoghisabtno = 0 ,this.hoghoghisabtdate ,this.parvanekind = 1 ,this.datesodor ,this.datetahvil ,this.etebarlen = 0 ,this.eparvaneno = 0 ,this.note ,this.shenasesenfi = 0 ,this.accept = 0, this.nationalid = "", this.mobile = "", this.lastprocess = "", this.lastprocessstatus = "",this.acceptdate ,this.bankname ,this.isicname, this.token, this.register = false, this.failprocess=""});
 
    Parvane.fromJson(Map<String, dynamic> json):
        cmpid = json['cmpid'],
        old = json['id'],
        id = json['id'],
        iranianasnaf = json['iranianasnaf'],
        reqdate = json['reqdate'],
        peopid = json['peopid'],
        peopname = json['peopname'],
        nationalid = json['nationalid'],
        mobile = json['mobile'],
        lastprocess = (json['lastprocess'] as String).isNotEmpty ? json['lastprocess'] : null,
        failprocess = (json['failprocess'] as String).isNotEmpty ? json['failprocess'] : null,
        lastprocessstatus = json['lastprocessstatus'],
        gunitid = json['gunitid'],
        nosazicode = json['nosazicode'],
        guname = json['guname'],
        gubegindate = json['gubegindate'],
        gutoolsinfo = json['gutoolsinfo'],
        guensheabat = json['guensheabat'],
        gubimemakan = json['gubimemakan'] == 1,
        gubimeshobe = json['gubimeshobe'],
        gukargahno = json['gukargahno'],
        guzirbana = json['guzirbana'],
        gutabaghat = json['gutabaghat'],
        gurent = json['gurent'],
        gudaraeicode = json['gudaraeicode'],
        guvahedmaliati = json['guvahedmaliati'],
        guparvandemaliat = json['guparvandemaliat'],
        gustatus = json['gustatus'],
        gutel = json['gutel'],
        gufax = json['gufax'],
        guesteghrarplace = json['guesteghrarplace'],
        gusigntitle = json['gusigntitle'],
        gunote = json['gunote'],
        kind = json['kind'],
        parvandekind = json['parvandekind'],
        ecoid = json['ecoid'],
        bank = json['bank'],
        hesabno = json['hesabno'],
        hesabkind = json['hesabkind'],
        hisic = json['hisic'],
        isic = json['isic'],
        hoghoghikind = json['hoghoghikind'],
        hoghoghiname = json['hoghoghiname'],
        hoghoghishenasemeli = json['hoghoghishenasemeli'],
        hoghoghisabtno = json['hoghoghisabtno'],
        hoghoghisabtdate = json['hoghoghisabtdate'],
        parvanekind = json['parvanekind'],
        datesodor = json['datesodor'],
        datetahvil = json['datetahvil'],
        etebarlen = json['etebarlen'],
        eparvaneno = json['eparvaneno'],
        note = json['note'],
        shenasesenfi = json['shenasesenfi'],
        accept = json['accept'],
        acceptdate = json['acceptdate'],
        bankname = json['bankname'],
        isicname = json['isicname'],
        register = json['register'] == 1;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['cmpid'] = this.cmpid;
        data['old'] = this.old;
        data['id'] = this.id;
        data['iranianasnaf'] = this.iranianasnaf;
        data['reqdate'] = this.reqdate;
        data['peopid'] = this.peopid;
        data['gunitid'] = this.gunitid;
        data['guname'] = this.guname;
        data['gubegindate'] = this.gubegindate;
        data['gutoolsinfo'] = this.gutoolsinfo;
        data['guensheabat'] = this.guensheabat;
        data['gubimemakan'] = this.gubimemakan ? 1 : 0;
        data['gubimeshobe'] = this.gubimeshobe;
        data['gukargahno'] = this.gukargahno;
        data['guzirbana'] = this.guzirbana;
        data['gutabaghat'] = this.gutabaghat;
        data['gurent'] = this.gurent;
        data['gudaraeicode'] = this.gudaraeicode;
        data['guvahedmaliati'] = this.guvahedmaliati;
        data['guparvandemaliat'] = this.guparvandemaliat;
        data['gustatus'] = this.gustatus;
        data['gutel'] = this.gutel;
        data['gufax'] = this.gufax;
        data['guesteghrarplace'] = this.guesteghrarplace;
        data['gusigntitle'] = this.gusigntitle;
        data['gunote'] = this.gunote;
        data['kind'] = this.kind;
        data['parvandekind'] = this.parvandekind;
        data['ecoid'] = this.ecoid;
        data['bank'] = this.bank;
        data['hesabno'] = this.hesabno;
        data['hesabkind'] = this.hesabkind;
        data['hisic'] = this.hisic;
        data['isic'] = this.isic;
        data['hoghoghikind'] = this.hoghoghikind;
        data['hoghoghiname'] = this.hoghoghiname;
        data['hoghoghishenasemeli'] = this.hoghoghishenasemeli;
        data['hoghoghisabtno'] = this.hoghoghisabtno;
        data['hoghoghisabtdate'] = this.hoghoghisabtdate;
        data['parvanekind'] = this.parvanekind;
        data['datesodor'] = this.datesodor;
        data['datetahvil'] = this.datetahvil;
        data['etebarlen'] = this.etebarlen;
        data['eparvaneno'] = this.eparvaneno;
        data['note'] = this.note;
        data['shenasesenfi'] = this.shenasesenfi;
        data['accept'] = this.accept;
        data['acceptdate'] = this.acceptdate;
        data['bankname'] = this.bankname;
        data['isicname'] = this.isicname;
        data['token'] = this.token;
        return data;
    }
}

class ParvaneMobasher{
    int parvaneid;
    int id;
    int peopid;
    int cartid;
    String cartdate;
    String deliverdate;
    String note;
    String name;
    String family;
    String nationalid;
    String father;
    String ss;
    String deletedate;
    String birthdate;
    String madrakfani;
    String english;
    String token;
 
    ParvaneMobasher({this.parvaneid = 0 ,this.id = 0 ,this.peopid = 0 ,this.cartid = 0 ,this.cartdate="",this.deliverdate="",this.note ,this.name ,this.family ,this.nationalid ,this.father ,this.ss ,this.birthdate ,this.madrakfani ,this.english, this.deletedate, this.token});
 
    ParvaneMobasher.fromJson(Map<String, dynamic> json):
        parvaneid = json['parvaneid'],
        id = json['id'],
        peopid = json['peopid'],
        cartid = json['cartid'],
        cartdate = json['cartdate'] ?? '',
        deliverdate = json['deliverdate'] ?? '',
        note = json['note'],
        name = json['name'],
        family = json['family'],
        nationalid = json['nationalid'],
        father = json['father'],
        deletedate = json['deletedate'],
        ss = json['ss'],
        birthdate = json['birthdate'],
        madrakfani = json['madrakfani'],
        english = json['english'];
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['parvaneid'] = this.parvaneid;
        data['id'] = this.id;
        data['peopid'] = this.peopid;
        data['cartid'] = this.cartid;
        data['cartdate'] = this.cartdate;
        data['deliverdate'] = this.deliverdate;
        data['note'] = this.note;
        data['name'] = this.name;
        data['family'] = this.family;
        data['nationalid'] = this.nationalid;
        data['father'] = this.father;
        data['ss'] = this.ss;
        data['birthdate'] = this.birthdate;
        data['madrakfani'] = this.madrakfani;
        data['english'] = this.english;
        data['token'] = this.token;
        return data;
    }
}

class ParvanePartner{
    int parvaneid;
    int id;
    int peopid;
    String name;
    String family;
    String nationalid;
    String father;
    String ss;
    String deletedate;
    int kind;
    int perc;
    String note;
    String token;
    bool edit;
 
    ParvanePartner({this.parvaneid = 0, this.id=0 ,this.peopid = 0 ,this.name ,this.family ,this.nationalid ,this.father ,this.ss ,this.kind = 0 ,this.perc = 0 ,this.note = "", this.deletedate, this.token, this.edit=false});
 
    ParvanePartner.fromJson(Map<String, dynamic> json):
        parvaneid = json['parvaneid'],
        id = json['id'],
        peopid = json['peopid'],
        name = json['name'],
        family = json['family'],
        nationalid = json['nationalid'],
        father = json['father'],
        deletedate = json['deletedate'],
        ss = json['ss'],
        kind = json['kind'],
        perc = json['perc'],
        note = json['note'],
        edit=false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['parvaneid'] = this.parvaneid;
        data['id'] = this.id;
        data['peopid'] = this.peopid;
        data['name'] = this.name;
        data['family'] = this.family;
        data['nationalid'] = this.nationalid;
        data['father'] = this.father;
        data['ss'] = this.ss;
        data['kind'] = this.kind;
        data['perc'] = this.perc;
        data['note'] = this.note;
        data['token'] = this.token;
        return data;
    }

    String get kindName => this.kind==1 ? 'شریک' : 'سهامدار';
}

class ParvanePersonel{
    int parvaneid;
    int id;
    int peopid;
    String name;
    String family;
    String nationalid;
    String father;
    String ss;
    int kind;
    String begindate;
    String enddate;
    String note;
    String deletedate;
    bool edit;
    String token;
 
    ParvanePersonel({this.parvaneid = 0 ,this.id = 0 ,this.peopid = 0 ,this.name ,this.family ,this.nationalid ,this.father ,this.ss ,this.kind = 0 ,this.begindate ,this.enddate ,this.note = "",this.deletedate, this.token, this.edit});
 
    ParvanePersonel.fromJson(Map<String, dynamic> json):
        parvaneid = json['parvaneid'],
        id = json['id'],
        peopid = json['peopid'],
        name = json['name'],
        family = json['family'],
        nationalid = json['nationalid'],
        father = json['father'],
        ss = json['ss'],
        kind = json['kind'],
        begindate = json['begindate'],
        enddate = json['enddate'],
        note = json['note'],
        deletedate = json['deletedate'],
        edit=false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['parvaneid'] = this.parvaneid;
        data['id'] = this.id;
        data['peopid'] = this.peopid;
        data['name'] = this.name;
        data['family'] = this.family;
        data['nationalid'] = this.nationalid;
        data['father'] = this.father;
        data['ss'] = this.ss;
        data['kind'] = this.kind;
        data['begindate'] = this.begindate;
        data['enddate'] = this.enddate;
        data['note'] = this.note;
        data['deletedate'] = this.deletedate;
        data['token'] = this.token;
        return data;
    }

    String get kindname => this.kind==1 ? 'تمام وقت' : 'نیمه وقت';
}

class PPStep{
    int ppid;
    int id;
    int kind;
    bool startprevend;
    bool restart;
    bool sms;
    bool err27;
    int length;
    bool show;
    bool finish;
    String finishdate;
    String edate;
    int remainday;
    String token;
 
    PPStep({this.ppid = 0 ,this.id = 0 ,this.kind = 0 ,this.startprevend = false ,this.restart = false ,this.sms = false ,this.err27 = false ,this.length = 0 ,this.finish = false, this.edate, this.finishdate, this.token, this.show, this.remainday});
 
    PPStep.fromJson(Map<String, dynamic> json):
        ppid = json['ppid'],
        id = json['id'],
        kind = json['kind'],
        startprevend = json['startprevend'] == 1,
        restart = json['restart'] == 1,
        sms = json['sms'] == 1,
        err27 = json['err27'] == 1,
        length = json['length'],
        finish = json['finish'] == 1,
        finishdate = json['finishdate'],
        remainday = json['remainday'],
        edate = json['edate'],
        show = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['ppid'] = this.ppid;
        data['id'] = this.id;
        // data['kind'] = this.kind;
        // data['startprevend'] = this.startprevend;
        // data['restart'] = this.restart;
        // data['sms'] = this.sms;
        // data['err27'] = this.err27;
        // data['length'] = this.length;
        data['finish'] = this.finish ? 1 : 0;
        // data['finishdate'] = this.finishdate;
        data['token'] = this.token;
        return data;
    }

    String kindName(){
      switch (this.kind) {
        case 0: return 'اتمام فرآیند';
        case 1: return 'مدرک';
        case 2: return 'هیئت مدیره';
        case 3: return 'بازرسی';
        case 4: return 'حسابداری';
        case 5: return 'آموزش';
      }
      return "";
    }
}

class ParvaneProcess{
    int id;
    int parvaneid;
    int processid;
    String title;
    String euserfamily;
    int finish;
    int length;
    String startdate;
    int dayremind;
    String enddate;
    List<PPStep> steps;
    String token;
    bool showSteps;
 
    ParvaneProcess({this.id = 0 ,this.parvaneid = 0 ,this.processid = 0 ,this.title ,this.euserfamily ,this.finish = 0, this.length, this.startdate, this.dayremind, this.enddate, this.steps, this.token, this.showSteps=false});
 
    ParvaneProcess.fromJson(Map<String, dynamic> json):
        id = json['id'],
        parvaneid = json['parvaneid'],
        processid = json['processid'],
        title = json['title'],
        euserfamily = json['euserfamily'],
        finish = json['finish'],
        length = json['length'],
        startdate = json['startdate'],
        dayremind = json['dayremind'],
        enddate = json['enddate'],
        showSteps = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['parvaneid'] = this.parvaneid;
        data['processid'] = this.processid;
        data['title'] = this.title;
        data['euserfamily'] = this.euserfamily;
        data['finish'] = this.finish;
        data['token'] = this.token;
        return data;
    }

    bool get isFinished => this.finish>0;
    String get failedNote => this.finish==10 ? 'رد شده با نظر هیت مدیره' : this.finish==11 ? 'رد شده با نظر بازرسی' : '';
}

class ParvaneProcessDocument{
  int ppid;
  int ppstepid;
  int id;
  int documentid;
  String documentname;
  int kind;
  int attach;
  String attachname;
  String token;

  ParvaneProcessDocument({this.ppid, this.ppstepid, this.id = 0 ,this.documentid = 0 ,this.documentname ,this.kind = 0 ,this.attach = 0, this.attachname, this.token});

  ParvaneProcessDocument.fromJson(Map<String, dynamic> json):
      ppid = json['ppid'],
      ppstepid = json['ppstepid'],
      id = json['id'],
      documentid = json['documentid'],
      documentname = json['documentname'],
      kind = json['kind'],
      attach = json['attach'],
      attachname = json['attachname'];

  Map<String, dynamic> toJson(){
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['documentid'] = this.documentid;
      data['documentname'] = this.documentname;
      data['kind'] = this.kind;
      data['attach'] = this.attach;
      data['token'] = this.token;
      return data;
  }

  String kindName(){
    switch (this.kind) {
        case 1:
          return 'فرد صنفی';
          break;
        case 2:
          return 'پروانه کسب';
          break;
        case 3:
          return 'واحد صنفی';
          break;
        case 4:
          return 'شریک';
          break;
        case 5:
          return 'مباشر';
          break;
        case 6:
          return 'کارکنان';
          break;
    }
    return "";
  }
}

class ParvaneProcessIncome{
    int ppid;
    int ppstepid;
    int incomeid;
    String incomename;
    double price;
    String date;
    String shenase;
    String note;
    String token;
    bool edit;
 
    ParvaneProcessIncome({this.ppid = 0 ,this.ppstepid = 0 ,this.incomeid = 0 ,this.incomename ,this.price ,this.date ,this.shenase ,this.note, this.token, this.edit});
 
    ParvaneProcessIncome.fromJson(Map<String, dynamic> json):
        ppid = json['ppid'],
        ppstepid = json['ppstepid'],
        incomeid = json['incomeid'],
        incomename = json['incomename'],
        price = json['price'],
        date = json['date'],
        shenase = json['shenase'],
        note = json['note'],
        edit = false;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['ppid'] = this.ppid;
        data['ppstepid'] = this.ppstepid;
        data['incomeid'] = this.incomeid;
        data['incomename'] = this.incomename;
        data['price'] = this.price;
        data['date'] = this.date;
        data['shenase'] = this.shenase;
        data['note'] = this.note;
        data['token'] = this.token;
        return data;
    }
}

class ParvaneProcessMeeting{
    int ppid;
    int ppstepid;
    int id;
    String edate;
    String mdate;
    int res;
    int mosavabeno;
    String note;
    String token;
    bool edit;
 
    ParvaneProcessMeeting({this.ppid = 0 ,this.ppstepid = 0 ,this.id = 0,this.edate,this.mdate ,this.res = 0 ,this.mosavabeno = 0 ,this.note, this.edit=false, this.token});
 
    ParvaneProcessMeeting.fromJson(Map<String, dynamic> json):
        ppid = json['ppid'],
        ppstepid = json['ppstepid'],
        id = json['id'],
        edate = json['edate'] ?? '',
        mdate = json['mdate'] ?? '',
        res = json['res'] ?? 0,
        mosavabeno = json['mosavabeno'],
        note = json['note'],
        edit= false || (json['res'] ?? 0) == 0;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['ppid'] = this.ppid;
        data['ppstepid'] = this.ppstepid;
        data['id'] = this.id;
        data['edate'] = this.edate;
        data['mdate'] = this.mdate;
        data['res'] = this.res;
        data['mosavabeno'] = this.mosavabeno;
        data['note'] = this.note;
        data['token'] = this.token;
        return data;
    }

    String get resName => this.res==1 
      ? 'قبول'
      : this.res==2
        ? 'رد'
        : 'مشروط';
}

class ParvaneProcessInspection{
    int ppid;
    int ppstepid;
    int id;
    String edate;
    int peopid;
    String peopfamily;
    String bdate;
    int res;
    bool cashdesk;
    int degree;
    String note;
    String token;
    bool edit;
 
    ParvaneProcessInspection({this.ppid = 0 ,this.ppstepid = 0 ,this.id = 0, this.edate, this.peopid = 0 ,this.peopfamily ,this.bdate ,this.res = 0 ,this.cashdesk,this.degree = 0 ,this.note, this.token, this.edit=false});
 
    ParvaneProcessInspection.fromJson(Map<String, dynamic> json):
        ppid = json['ppid'],
        ppstepid = json['ppstepid'],
        id = json['id'],
        edate = json['edate'],
        peopid = json['peopid'],
        peopfamily = json['peopfamily'],
        bdate = json['bdate'],
        res = json['res'],
        cashdesk = json['cashdesk'] == 1,
        degree = json['degree'],
        note = json['note'],
        edit= false || (json['res'] ?? 0) == 0;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['ppid'] = this.ppid;
        data['ppstepid'] = this.ppstepid;
        data['id'] = this.id;
        data['edate'] = this.edate;
        data['peopid'] = this.peopid;
        data['peopfamily'] = this.peopfamily;
        data['bdate'] = this.bdate;
        data['res'] = this.res;
        data['cashdesk'] = this.cashdesk ? 1 : 0;
        data['degree'] = this.degree;
        data['note'] = this.note;
        data['token'] = this.token;
        return data;
    }

    String get resName => this.res==1 
      ? 'قبول'
      : this.res==2
        ? 'رد'
        : 'مشروط';

    String get degreeName => this.degree==1 
       ? 'درجه یک'
       : this.degree==2
        ? 'درجه دو'
        : this.degree==3
          ? 'درجه سه'
          : 'درجه چهار';
}



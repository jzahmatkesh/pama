import 'dart:convert';

import '../module/functions.dart';
import 'classes.dart';

class CompanyRepository{
  Future<List<Company>> loadCompanys(String token) async{
    Map<String, dynamic> _data = await postToServer(api: 'Company', body: jsonEncode({"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Company>((data) => Company.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }
  
  Future<int> saveCompany(String token, Company cmp) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company', header: {'Content-Type': 'application/json', 'token': token}, 
      body: jsonEncode(cmp.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
  Future<String> setCompanyActive(String token, Company cmp) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company/active', header: {'Content-Type': 'application/json', 'token': token}, 
      body: jsonEncode({
	 		'id': cmp.id,
	 		'active': cmp.active == 1 ? 0 : 1,
      })
    );
    if (_data['msg'] == "Success")
      return "موفقیت آمیز بود";
    throw Exception(_data['msg']);
  }

  Future<bool> saveCompanyByLaw(Company cmp) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company/bylaw', body: jsonEncode(cmp.toJson()));
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<CompanyUser>> loadCompanyUsers(String token, int cmpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Company/users', body: jsonEncode({"cmpid": cmpid,"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<CompanyUser>((data) => CompanyUser.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }
  Future<String> setCompanyUserActive(String token, int cmp, CompanyUser user) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company/users/active',
      body: jsonEncode({
      'token': token,
	 		'cmpid': cmp,
	 		'id': user.id,
	 		'active': user.active ? 0 : 1,
      })
    );
    if (_data['msg'] == "Success")
      return "موفقیت آمیز بود";
    throw Exception(_data['msg']);
  }
  Future<String> delCompanyUser(String token, int cmp, int user) async{
    Map<String, dynamic> _data = await delToServer(api: 'Company/users', 
      header: {
        'Content-Type': 'application/json',
        'token': token,
        'cmpid': cmp.toString(),
        'userid': user.toString()
      }
    );
    if (_data['msg'] == "Success")
      return "موفقیت آمیز بود";
    throw Exception(_data['msg']);
  }
  Future<List<CompanyUserGroups>> loadCompanyUsersGroup(String token, int cmpid, int user) async{
    Map<String, dynamic> _data = await postToServer(api: 'Company/users/group', body: jsonEncode({"cmpid": cmpid,"token": token, "id": user}));
    if (_data['msg'] == "Success")
      return _data['body'].map<CompanyUserGroups>((data) => CompanyUserGroups.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }
  Future<bool> setCompanyUsersGroup(String token, CompanyUserGroups usr) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company/users/group', 
      body: jsonEncode({
        "userid": usr.userid,
        "grpid": usr.id,
        "token": token, 
        "active": usr.active ? 0 : 1
      })
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
  Future<bool> setCompanyUserPassword(String token, int cmp, int user, int peopid, String pass) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company/users', 
      body: jsonEncode({
        'token': token,
        'cmpid': cmp.toString(),
        'id': user.toString(),
        'peopid': peopid.toString(),
        'password': generateMd5(pass),
      })
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<Employee>> loadEmployee(String token, int cmpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Company/Employee', body: jsonEncode({"cmpid": cmpid,"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Employee>((data) => Employee.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }
  Future<List<EmpFamily>> loadEmpFamily(String token, int cmpid, int empid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Company/EmpFamily', body: jsonEncode({"cmpid": cmpid, "empid": empid,"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<EmpFamily>((data) => EmpFamily.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<bool> saveEmployee(Employee emp) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company/Employee',
      body: jsonEncode(emp.toJson())
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
  Future<String> delEmployee(String token, int cmp, int peopid) async{
    Map<String, dynamic> _data = await delToServer(api: 'Company/Employee', 
      header: {
        'Content-Type': 'application/json',
        'token': token,
        'cmpid': cmp.toString(),
        'peopid': peopid.toString()
      }
    );
    if (_data['msg'] == "Success")
      return "موفقیت آمیز بود";
    throw Exception(_data['msg']);
  }

  Future<bool> saveEmpFamily(EmpFamily family) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company/EmpFamily',
      body: jsonEncode(family.toJson())
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
  Future<String> delEmpFamily(String token, int cmp, int empid, int peopid) async{
    Map<String, dynamic> _data = await delToServer(api: 'Company/EmpFamily', 
      header: {
        'Content-Type': 'application/json',
        'token': token,
        'cmpid': cmp.toString(),
        'empid': empid.toString(),
        'peopid': peopid.toString()
      }
    );
    if (_data['msg'] == "Success")
      return "موفقیت آمیز بود";
    throw Exception(_data['msg']);
  }

  Future<List<Director>> loadDirector(String token, int cmpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Company/Director', body: jsonEncode({"cmpid": cmpid,"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Director>((data) => Director.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }
  Future<bool> saveDirector(Director drt) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company/Director',
      body: jsonEncode(drt.toJson())
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
  Future<String> delDirector(String token, int cmp, int peopid) async{
    Map<String, dynamic> _data = await delToServer(api: 'Company/Director', 
      header: {
        'Content-Type': 'application/json',
        'token': token,
        'cmpid': cmp.toString(),
        'peopid': peopid.toString()
      }
    );
    if (_data['msg'] == "Success")
      return "موفقیت آمیز بود";
    throw Exception(_data['msg']);
  }
  Future<int> setDirectorActive(Director drt) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company/DirectorActive',
      body: jsonEncode(drt.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['active'];
    throw Exception(_data['msg']);
  }
  Future<int> setDirectorSignRight(Director drt) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company/DirectorSignRight',
      body: jsonEncode(drt.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['signright'];
    throw Exception(_data['msg']);
  }
  
  Future<List<DrtFamily>> loadDrtFamily(String token, int cmpid, int drtid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Company/DrtFamily', body: jsonEncode({"cmpid": cmpid, "drtid": drtid,"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<DrtFamily>((data) => DrtFamily.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }
  Future<bool> saveDrtFamily(DrtFamily family) async{
    Map<String, dynamic> _data = await putToServer(api: 'Company/DrtFamily',
      body: jsonEncode(family.toJson())
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
  Future<String> delDrtFamily(String token, int cmp, int drtid, int peopid) async{
    Map<String, dynamic> _data = await delToServer(api: 'Company/DrtFamily', 
      header: {
        'Content-Type': 'application/json',
        'token': token,
        'cmpid': cmp.toString(),
        'drtid': drtid.toString(),
        'peopid': peopid.toString()
      }
    );
    if (_data['msg'] == "Success")
      return "موفقیت آمیز بود";
    throw Exception(_data['msg']);
  }
}

class PeopleRepository{
  Future<List<People>> checkNationalID(String token, String nationalid, String family, String mobile) async{
    Map<String, dynamic> _data = await postToServer(api: 'People', body: jsonEncode({"token": token, "nationalid": nationalid, "family": family, "mobile": mobile}));
    if (_data['msg'] == "Success")
      return _data['body'].map<People>((data) => People.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<People> savePeople(People people) async{
     Map<String, dynamic> _data = await putToServer(api: 'People', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(people.toJson())
    );
    if (_data['msg'] == "Success")
      return People.fromJson(_data['body']);
    throw Exception(_data['msg']);
 }
}

class RasteRepository{
  Future<List<Raste>> load(String token) async{
    Map<String, dynamic> _data = await postToServer(api: 'Raste', body: jsonEncode({"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Raste>((data) => Raste.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<bool> save(Raste raste) async{
     Map<String, dynamic> _data = await putToServer(api: 'Raste', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(raste.toJson())
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
 }
 
  Future<bool> setActive(Raste raste) async{
     Map<String, dynamic> _data = await putToServer(api: 'Raste/Active', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(raste.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['active'] == 1;
    throw Exception(_data['msg']);
 }
  Future<bool> delRaste(Raste raste) async{
     Map<String, dynamic> _data = await delToServer(api: 'Raste', 
      header: {
       'Content-Type': 'application/json',
       'token': raste.token,
       'isic': raste.isic.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return _data['body']['active'] == 1;
    throw Exception(_data['msg']);
 }

  Future<List<DRaste>> loadDRaste(String token, int hisic) async{
    Map<String, dynamic> _data = await postToServer(api: 'Raste/DRaste', body: jsonEncode({"token": token, "isic": hisic}));
    if (_data['msg'] == "Success")
      return _data['body'].map<DRaste>((data) => DRaste.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }
  Future<bool> saveDRaste(DRaste draste) async{
     Map<String, dynamic> _data = await putToServer(api: 'Raste/DRaste',
      body: jsonEncode(draste.toJson())
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
  Future<bool> setDrasteActive(DRaste draste) async{
     Map<String, dynamic> _data = await putToServer(api: 'Raste/DRActive', 
      body: jsonEncode(draste.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['active'] == 1;
    throw Exception(_data['msg']);
  }
  Future<bool> delDRaste(DRaste raste) async{
     Map<String, dynamic> _data = await delToServer(api: 'Raste/DRaste', 
      header: {
       'Content-Type': 'application/json',
       'token': raste.token,
       'hisic': raste.hisic.toString(),
       'isic': raste.isic.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return _data['body']['active'] == 1;
    throw Exception(_data['msg']);
 }
}

class BankRepository{
  Future<List<Bank>> load(String token) async{
    Map<String, dynamic> _data = await postToServer(api: 'Bank', body: jsonEncode({"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Bank>((data) => Bank.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> save(Bank bank) async{
     Map<String, dynamic> _data = await putToServer(api: 'Bank', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(bank.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
 
  Future<bool> delete(Bank bank) async{
     Map<String, dynamic> _data = await delToServer(api: 'Bank', 
      header: {
       'Content-Type': 'application/json',
       'token': bank.token,
       'id': bank.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
}

class ViolationRepository{
  Future<List<Violation>> load(String token) async{
    Map<String, dynamic> _data = await postToServer(api: 'Violation', body: jsonEncode({"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Violation>((data) => Violation.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> save(Violation vio) async{
     Map<String, dynamic> _data = await putToServer(api: 'Violation', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(vio.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
 
  Future<bool> delete(Violation vio) async{
     Map<String, dynamic> _data = await delToServer(api: 'Violation', 
      header: {
       'Content-Type': 'application/json',
       'token': vio.token,
       'id': vio.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
}

class DocumentRepository{
  Future<List<Document>> load(String token) async{
    Map<String, dynamic> _data = await postToServer(api: 'Document', body: jsonEncode({"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Document>((data) => Document.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> save(Document doc) async{
     Map<String, dynamic> _data = await putToServer(api: 'Document',
      body: jsonEncode(doc.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
 
  Future<int> setExpDate(Document doc) async{
     Map<String, dynamic> _data = await putToServer(api: 'Document/ExpDate',
      body: jsonEncode(doc.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }

  Future<bool> delete(Document doc) async{
     Map<String, dynamic> _data = await delToServer(api: 'Document', 
      header: {
       'Content-Type': 'application/json',
       'token': doc.token,
       'id': doc.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
}

class GovRepository{
  Future<List<Gov>> load(String token) async{
    Map<String, dynamic> _data = await postToServer(api: 'Gov', body: jsonEncode({"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Gov>((data) => Gov.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> save(Gov gov) async{
     Map<String, dynamic> _data = await putToServer(api: 'Gov', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(gov.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
 
  Future<bool> delete(Gov gov) async{
     Map<String, dynamic> _data = await delToServer(api: 'Gov', 
      header: {
       'Content-Type': 'application/json',
       'token': gov.token,
       'id': gov.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
}

class AddInfoRepository{
  Future<List<AddInfo>> load(String token) async{
    Map<String, dynamic> _data = await postToServer(api: 'AddInfo', body: jsonEncode({"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<AddInfo>((data) => AddInfo.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> save(AddInfo addinfo) async{
     Map<String, dynamic> _data = await putToServer(api: 'AddInfo', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(addinfo.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }

  Future<int> setDublicate(AddInfo addinfo) async{
     Map<String, dynamic> _data = await putToServer(api: 'AddInfo/Dublicate', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(addinfo.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['dublicate'];
    throw Exception(_data['msg']);
  }
 
  Future<bool> delete(AddInfo addinfo) async{
     Map<String, dynamic> _data = await delToServer(api: 'AddInfo', 
      header: {
       'Content-Type': 'application/json',
       'token': addinfo.token,
       'id': addinfo.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<AddInfoNote>> loadNote(String token, int addid) async{
    Map<String, dynamic> _data = await postToServer(api: 'AddInfo/Note', body: jsonEncode({"token": token, "id": addid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<AddInfoNote>((data) => AddInfoNote.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> saveNote(AddInfoNote note) async{
     Map<String, dynamic> _data = await putToServer(api: 'AddInfo/Note', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(note.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }

  Future<bool> deleteNote(AddInfoNote note) async{
     Map<String, dynamic> _data = await delToServer(api: 'AddInfo/Note', 
      header: {
       'Content-Type': 'application/json',
       'token': note.token,
       'addid': note.addid.toString(),
       'id': note.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
}

class AddinfoDataRepository{
  Future<List<AddInfoData>> load(String token, String url, Map<String, String> header) async{
    header.putIfAbsent('Content-Type', () => 'application/json');
    Map<String, dynamic> _data = await postToServer(api: url, header: header, body: jsonEncode({"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<AddInfoData>((data) => AddInfoData.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<bool> save(AddInfoData addinfo, String url, Map<String, String> header) async{
    header.putIfAbsent('Content-Type', () => 'application/json');
    Map<String, dynamic> _data = await putToServer(api: url, header: header,  body: jsonEncode(addinfo.toJson()));
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<bool> del(String url, Map<String, String> header) async{
    header.putIfAbsent('Content-Type', () => 'application/json');
    Map<String, dynamic> _data = await delToServer(api: url, header: header);
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
}

class UserGroupRepository{
  Future<List<UserGroup>> load(String token) async{
    Map<String, dynamic> _data = await postToServer(api: 'UserGroup', body: jsonEncode({"token": token}));
    if (_data['msg'] == "Success")
      return _data['body'].map<UserGroup>((data) => UserGroup.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> save(UserGroup grp) async{
     Map<String, dynamic> _data = await putToServer(api: 'UserGroup', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(grp.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
 
  Future<bool> delete(UserGroup grp) async{
     Map<String, dynamic> _data = await delToServer(api: 'UserGroup', 
      header: {
       'Content-Type': 'application/json',
       'token': grp.token,
       'id': grp.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<GroupPermission>> loadPermission(String token, int grpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'UserGroup/Permission', body: jsonEncode({"token": token, "grpid": grpid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<GroupPermission>((data) => GroupPermission.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<bool> setGroupPermission(GroupPermission prv) async{
     Map<String, dynamic> _data = await putToServer(api: 'UserGroup/Permission', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(prv.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['valid'] == 1;
    throw Exception(_data['msg']);
  }

  Future<List<GroupUser>> loadusers(String token, int grpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'UserGroup/Users', body: jsonEncode({"token": token, "grpid": grpid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<GroupUser>((data) => GroupUser.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<List<GroupUser>> newusers(String token, int grpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'UserGroup/NewUser', body: jsonEncode({"token": token, "grpid": grpid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<GroupUser>((data) => GroupUser.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }
}

class CommitteeRepository{
  Future<List<Committee>> load(String token, int cmpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Cmp_Committee', body: jsonEncode({"token": token, "cmpid": cmpid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Committee>((data) => Committee.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> save(Committee com) async{
     Map<String, dynamic> _data = await putToServer(api: 'Cmp_Committee', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(com.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
 
  Future<bool> delete(String token, Committee com) async{
     Map<String, dynamic> _data = await delToServer(api: 'Cmp_Committee', 
      header: {
       'Content-Type': 'application/json',
       'token': token,
       'cmpid': com.cmpid.toString(),
       'id': com.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<CommitteeMember>> loadMember(String token, int cmpid, int cmtid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Cmp_Committee/Member', body: jsonEncode({"token": token, "cmpid": cmpid, "cmtid": cmtid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<CommitteeMember>((data) => CommitteeMember.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<bool> saveMember(CommitteeMember mem) async{
     Map<String, dynamic> _data = await putToServer(api: 'Cmp_Committee/Member', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(mem.toJson())
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<bool> deleteMember(String token, CommitteeMember mem) async{
     Map<String, dynamic> _data = await delToServer(api: 'Cmp_Committee/Member', 
      header: {
       'Content-Type': 'application/json',
       'token': token,
       'cmpid': mem.cmpid.toString(),
       'cmtid': mem.cmtid.toString(),
       'peopid': mem.peopid.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<CommitteeDetail>> loadDetail(String token, int cmpid, int cmtid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Cmp_Committee/Detail', body: jsonEncode({"token": token, "cmpid": cmpid, "cmtid": cmtid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<CommitteeDetail>((data) => CommitteeDetail.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> saveDetail(CommitteeDetail dtl) async{
      Map<String, dynamic> _data = await putToServer(api: 'Cmp_Committee/Detail', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(dtl.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']); 
  }

  Future<bool> deleteDetail(String token, CommitteeDetail dtl) async{
     Map<String, dynamic> _data = await delToServer(api: 'Cmp_Committee/Detail', 
      header: {
       'Content-Type': 'application/json',
       'token': token,
       'cmpid': dtl.cmpid.toString(),
       'cmtid': dtl.cmtid.toString(),
       'id': dtl.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<CommitteeDetailAbsent>> loadDetailAbsent(String token, int cmpid, int cmtid, int detailid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Cmp_Committee/Detail/Absent', body: jsonEncode({"token": token, "cmpid": cmpid, "cmtid": cmtid, "id": detailid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<CommitteeDetailAbsent>((data) => CommitteeDetailAbsent.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<bool> saveDetailAbsent(CommitteeDetailAbsent abs) async{
      Map<String, dynamic> _data = await putToServer(api: 'Cmp_Committee/Detail/Absent', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(abs.toJson())
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']); 
  }

  Future<bool> deleteDetailAbsent(String token, CommitteeDetailAbsent abs) async{
     Map<String, dynamic> _data = await delToServer(api: 'Cmp_Committee/Detail/Absent', 
      header: {
       'Content-Type': 'application/json',
       'token': token,
       'cmpid': abs.cmpid.toString(),
       'cmtid': abs.cmtid.toString(),
       'detailid': abs.detailid.toString(),
       'peopid': abs.peopid.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<CommitteeDetailMosavabat>> loadDetailMosavabat(String token, int cmpid, int cmtid, int detailid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Cmp_Committee/Detail/Mosavabat', body: jsonEncode({"token": token, "cmpid": cmpid, "cmtid": cmtid, "detailid": detailid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<CommitteeDetailMosavabat>((data) => CommitteeDetailMosavabat.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> saveDetailMosavabat(CommitteeDetailMosavabat mos) async{
      Map<String, dynamic> _data = await putToServer(api: 'Cmp_Committee/Detail/Mosavabat', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(mos.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']); 
  }

  Future<bool> deleteDetailMosavabat(String token, CommitteeDetailMosavabat mos) async{
     Map<String, dynamic> _data = await delToServer(api: 'Cmp_Committee/Detail/Mosavabat', 
      header: {
       'Content-Type': 'application/json',
       'token': token,
       'cmpid': mos.cmpid.toString(),
       'cmtid': mos.cmtid.toString(),
       'detailid': mos.detailid.toString(),
       'id': mos.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
}

class PropertyRepository{

  Future<int> setActive(Property prop) async{
     Map<String, dynamic> _data = await putToServer(api: 'Property/Active', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode({'token': prop.token, 'id': prop.id})
    );
    if (_data['msg'] == "Success")
      return _data['body']['active'];
    throw Exception(_data['msg']);
  }

  Future<int> setInternetBank(Property prop) async{
     Map<String, dynamic> _data = await putToServer(api: 'Property/InternetBank', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode({'token': prop.token, 'id': prop.id})
    );
    if (_data['msg'] == "Success")
      return _data['body']['internetbank'];
    throw Exception(_data['msg']);
  }

  Future<List<Property>> loadMobile(String token, int cmpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Property/Mobile', body: jsonEncode({"token": token, "cmpid": cmpid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Property>((data) => Property.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> saveMobile(Property prop) async{
     Map<String, dynamic> _data = await putToServer(api: 'Property/Mobile', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(prop.toMobileJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
 
  Future<bool> delMobile(String token, Property prop) async{
     Map<String, dynamic> _data = await delToServer(api: 'Property/Mobile', 
      header: {
       'Content-Type': 'application/json',
       'token': token,
       'id': prop.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<Property>> loadCar(String token, int cmpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Property/Car', body: jsonEncode({"token": token, "cmpid": cmpid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Property>((data) => Property.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> saveCar(Property prop) async{
     Map<String, dynamic> _data = await putToServer(api: 'Property/Car', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(prop.toCarJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
 
  Future<bool> delCar(String token, Property prop) async{
     Map<String, dynamic> _data = await delToServer(api: 'Property/Car', 
      header: {
       'Content-Type': 'application/json',
       'token': token,
       'id': prop.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<Property>> loadPropGHM(String token, int cmpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Property/PropGHM', body: jsonEncode({"token": token, "cmpid": cmpid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Property>((data) => Property.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> savePropGHM(Property prop) async{
     Map<String, dynamic> _data = await putToServer(api: 'Property/PropGHM', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(prop.toPropGHMJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
 
  Future<bool> delPropGHM(String token, Property prop) async{
     Map<String, dynamic> _data = await delToServer(api: 'Property/PropGHM', 
      header: {
       'Content-Type': 'application/json',
       'token': token,
       'id': prop.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<Property>> loadBankHesab(String token, int cmpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Property/BankHesab', body: jsonEncode({"token": token, "cmpid": cmpid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Property>((data) => Property.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> saveBankHesab(Property prop) async{
     Map<String, dynamic> _data = await putToServer(api: 'Property/BankHesab', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(prop.toBankHesabJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
 
  Future<bool> delBankHesab(String token, Property prop) async{
     Map<String, dynamic> _data = await delToServer(api: 'Property/BankHesab', 
      header: {
       'Content-Type': 'application/json',
       'token': token,
       'id': prop.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
}

class InspectionRepository{
  Future<List<Inspection>> loadInspection(String token, int cmpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Inspection', body: jsonEncode({"token": token, "cmpid": cmpid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Inspection>((data) => Inspection.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<bool> delInspection(Inspection insp) async{
     Map<String, dynamic> _data = await delToServer(api: 'Inspection', 
      header: {
       'Content-Type': 'application/json',
       'token': insp.token,
       'id': insp.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<int> saveInspection(Inspection insp) async{
     Map<String, dynamic> _data = await putToServer(api: 'Inspection', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(insp.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }

  Future<List<Inspectiongov>> loadInspectionGov(String token, int insid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Inspection/Gov', body: jsonEncode({"token": token, "insid": insid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Inspectiongov>((data) => Inspectiongov.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<bool> delInspectionGov(Inspectiongov gov) async{
     Map<String, dynamic> _data = await delToServer(api: 'Inspection/Gov', 
      header: {
       'Content-Type': 'application/json',
       'token': gov.token,
       'insid': gov.insid.toString(),
       'govid': gov.govid.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<bool> saveInspectionGov(Inspectiongov gov) async{
     Map<String, dynamic> _data = await putToServer(api: 'Inspection/Gov', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(gov.toJson())
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<Inspectioncompany>> loadInspectionCompany(String token, int insid) async{
    Map<String, dynamic> _data = await postToServer(api: 'Inspection/Company', body: jsonEncode({"token": token, "insid": insid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Inspectioncompany>((data) => Inspectioncompany.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<bool> delInspectionCompany(Inspectioncompany obj) async{
     Map<String, dynamic> _data = await delToServer(api: 'Inspection/Company', 
      header: {
       'Content-Type': 'application/json',
       'token': obj.token,
       'insid': obj.insid.toString(),
       'cmpid': obj.cmpid.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<bool> saveInspectionCompany(Inspectioncompany obj) async{
     Map<String, dynamic> _data = await putToServer(api: 'Inspection/Company', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(obj.toJson())
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<List<Inspectioncompanypeop>> loadInspectionCompanyPeop(String token, int insid, int cmpid, int kind) async{
    Map<String, dynamic> _data = await postToServer(api: 'Inspection/CompanyPeop', body: jsonEncode({"token": token, "insid": insid, "cmpid": cmpid, "kind": kind}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Inspectioncompanypeop>((data) => Inspectioncompanypeop.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<bool> delInspectionCompanyPeop(Inspectioncompanypeop obj) async{
     Map<String, dynamic> _data = await delToServer(api: 'Inspection/CompanyPeop', 
      header: {
       'Content-Type': 'application/json',
       'token': obj.token,
       'insid': obj.insid.toString(),
       'cmpid': obj.cmpid.toString(),
       'peopid': obj.peopid.toString(),
       'kind': obj.kind.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }

  Future<bool> saveInspectionCompanyPeop(Inspectioncompanypeop obj) async{
     Map<String, dynamic> _data = await putToServer(api: 'Inspection/CompanyPeop', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(obj.toJson())
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
}

class NoLicenseRepository{
  Future<List<Nolicense>> load(String token, int cmpid) async{
    Map<String, dynamic> _data = await postToServer(api: 'NoLicense', body: jsonEncode({"token": token, "cmpid": cmpid}));
    if (_data['msg'] == "Success")
      return _data['body'].map<Nolicense>((data) => Nolicense.fromJson(json.decode(data))).toList();
    throw Exception(_data['msg']);
  }

  Future<int> save(Nolicense lcn) async{
     Map<String, dynamic> _data = await putToServer(api: 'NoLicense', header: {'Content-Type': 'application/json'}, 
      body: jsonEncode(lcn.toJson())
    );
    if (_data['msg'] == "Success")
      return _data['body']['id'];
    throw Exception(_data['msg']);
  }
 
  Future<bool> delete(Nolicense lcn) async{
     Map<String, dynamic> _data = await delToServer(api: 'NoLicense', 
      header: {
       'Content-Type': 'application/json',
       'token': lcn.token,
       'cmpid': lcn.cmpid.toString(),
       'id': lcn.id.toString()
      }, 
    );
    if (_data['msg'] == "Success")
      return true;
    throw Exception(_data['msg']);
  }
}

--Exec Pama.PrcClassgeneration  'Pama', 'TBGUnit', 1, 'Select * From Pama.TBGUnit'



Drop procedure if Exists Pama.PrcClassgeneration
Go
Create procedure Pama.PrcClassgeneration  @Schema NVarChar(10), @TB NvarChar(100), @ExportType TinyInt, @Sql NVarChar(max)
With Encryption
As
Begin
--Select @Schema='dbo', @TB = 'TBPrcStepCourse', @ExportType = 2, @Sql='Select TakafolCount From Pama.TBPeople'

    --1=Java
    --2=Flutter

Declare @Res Table(Note NVarChar(max))
Declare @gettersetter Table(Note NVarChar(max))
Declare @fromjosn Table(id smallint identity(1,1), Note NVarChar(max))
Declare @tojosn Table(Note NVarChar(max))
Declare @FieldName NvarChar(100), @Type NVarChar(20), @Length Int, @JT NVarChar(30), @FlutterCreator NVarChar(max), @questionMark NVarChar(max), @classJavaSaveFields NVArChar(max), @idx Int, @JavaPk1 NVarChar(max), @JavaPk2 NVarChar(max)

Select @classJavaSaveFields = '', @questionMark = '', @idx = 3, @JavaPk1='', @JavaPk2='';

if @ExportType=1
Begin
    Insert Into @Res Values('package objects;');
    Insert Into @Res Values('');
    Insert Into @Res Values('');
    Insert Into @Res Values('public class '+@TB+'{');

	Declare CrsPk Cursor For
		Select b.name
		From Sys.sysindexkeys a
			inner join sys.syscolumns b on a.id = b.id and a.colid=b.colid
		Where a.id = Object_ID(@Schema+'.'+@TB)

	Open CrsPK
	Fetch Next From CrsPK Into @fieldName

	While @@FETCH_STATUS = 0
	Begin
		Set @JavaPk1 = @JavaPk1+', @HeaderParam("id") int id';
        Set @JavaPk2 = @JavaPk2+'&	 		p.setInt(4, id);';
		Fetch Next From CrsPK Into @fieldName
	End
	Close CrsPK
	DeAllocate CrsPK

End
Else
BEGIN
    Insert into @Res Values('class '+UPPER(LEFT(@TB,1))+LOWER(SUBSTRING(@TB,2,LEN(@TB)))+'{')
    Insert into @fromjosn Values('    '+UPPER(LEFT(@TB,1))+LOWER(SUBSTRING(@TB,2,LEN(@TB)))+'.fromJson(Map<String, dynamic> json):')
    Insert into @tojosn
    Values('    Map<String, dynamic> toJson(){'),
          ('        final Map<String, dynamic> data = new Map<String, dynamic>();')
END

if RTRim(LTRim(IsNull(@Sql,''))) <> ''
    Declare Crs Cursor For
        Select A.Name, B.name
        From Sys.dm_exec_describe_first_result_set(@Sql, null, 0) A
            Left Outer Join Sys.systypes B On A.system_type_id = B.xusertype
Else
    Declare Crs Cursor For
        Select A.Name, B.name--, A.length
        From Sys.syscolumns A
            Inner Join Sys.systypes B On A.xtype = B.xusertype
        Where A.id = Object_ID(@Schema+'.'+@TB)
Open Crs
Fetch Crs Into @FieldName,@Type
While @@FETCH_STATUS=0
BEGIN
    Set @idx = @idx+1;
    Set @JT = null;
    if @Type in ('int', 'smallint', 'tinyint')
    Begin
        Set @JT = 'int'
        Set @classJavaSaveFields = @classJavaSaveFields+'& p.setInt('+Cast(@idx As VarChar)+', obj.get'+UPPER(LEFT(@FieldName,1))+LOWER(SUBSTRING(@FieldName,2,LEN(@FieldName)))+'());'
    End
    Else if @Type in ('bigint', 'float', 'numeric')
    Begin
        Set @JT = 'double'
        Set @classJavaSaveFields = @classJavaSaveFields+'& p.setDouble('+Cast(@idx As VarChar)+', obj.get'+UPPER(LEFT(@FieldName,1))+LOWER(SUBSTRING(@FieldName,2,LEN(@FieldName)))+'());'
    End
    Else if @Type in ('varchar', 'nvarchar', 'nchar', 'char', 'datetime', 'uniqueidentifier')
    Begin
        Set @JT = 'String';
        Set @classJavaSaveFields = @classJavaSaveFields+'& p.setString('+Cast(@idx As VarChar)+', obj.get'+UPPER(LEFT(@FieldName,1))+LOWER(SUBSTRING(@FieldName,2,LEN(@FieldName)))+'());'
    End
    Set @questionMark = @questionMark+',?'

    if (LOWER(@FieldName) <> 'euserid' And LOWER(@FieldName) <> 'edate' And LOWER(@FieldName) <> 'ip')
        if @ExportType=1
        Begin
            Insert Into @Res 
            Values('    private '+IsNull(@JT, @Type)+' '+LOWER(@FieldName)+';')

            Insert Into @gettersetter
            Values('    public '+@JT+' get'+UPPER(LEFT(@FieldName,1))+LOWER(SUBSTRING(@FieldName,2,LEN(@FieldName)))+'(){'),
                ('        return '+LOWER(@FieldName)+';'),
                ('    }'),
                ('    public void set'+UPPER(LEFT(@FieldName,1))+LOWER(SUBSTRING(@FieldName,2,LEN(@FieldName)))+'('+@JT+' '+LOWER(@FieldName)+'){'),
                ('        this.'+LOWER(@FieldName)+' = '+LOWER(@FieldName)+';'),
                ('    }');
        End
        Else
        Begin
            Insert Into @Res 
            Values('    '+IsNull(@JT, @Type)+' '+LOWER(@FieldName)+';')
            if @FlutterCreator Is Null
                Set @FlutterCreator = 'this.'+LOWER(@FieldName)
            Else
                Set @FlutterCreator = @FlutterCreator+',this.'+LOWER(@FieldName)
            Insert Into @fromjosn
            Values('        '+LOWER(@FieldName)+' = json['''+LOWER(@FieldName)+'''],')
            Insert into @tojosn
            Values('        data['''+LOWER(@FieldName)+'''] = this.'+LOWER(@FieldName)+';');
        End

    Fetch Crs Into @FieldName,@Type
END
Close Crs
DeAllocate Crs


if @ExportType=1
Begin
    Insert Into @Res Values('    private String token;');
    Insert Into @Res Values(' ');
    Insert Into @Res Values(' ');
    Insert Into @Res
    Select *
    From @gettersetter

    Insert Into @Res 
    Values('    public String getToken() {'),
        ('        return token;'),
        ('    }'),
        ('    public void setToken(String token) {'),
        ('        this.token = token;'),
        ('    }')


    Insert Into @Res Values('}');
End
ELSE
BEGIN
    Insert Into @Res Values('    String token;');
    Insert Into @Res Values(' ');

    
    Select Top 1 @Length=ID,@FieldName = SubString(Note, 0, Len(Note))+';'
    From @fromjosn
    Order By ID DESC

    Update @fromjosn
    Set Note=@FieldName
    Where ID = @Length

    insert into @Res
    Values('    '+UPPER(LEFT(@TB,1))+LOWER(SUBSTRING(@TB,2,LEN(@TB)))+'({'+@FlutterCreator+', this.token});')
    Insert Into @Res Values(' ');

    insert into @Res
    Select Note
    From @fromjosn

    Insert Into @Res Values(' ');
    insert into @Res
    Select *
    From @tojosn
    Insert Into @Res 
    Values('        data[''token''] = this.token;'),
          ('        return data;'),
          ('    }'),
          ('}')
END


if @ExportType=1
Begin
Insert Into @Res Values('package api;');
Insert Into @Res Values('');
Insert Into @Res Values('');
Insert Into @Res Values('import java.sql.Connection;');
Insert Into @Res Values('import java.sql.PreparedStatement;');
Insert Into @Res Values('import javax.servlet.http.HttpServletRequest;');
Insert Into @Res Values('import javax.ws.rs.DELETE;');
Insert Into @Res Values('import javax.ws.rs.GET;');
Insert Into @Res Values('import javax.ws.rs.HeaderParam;');
Insert Into @Res Values('import javax.ws.rs.POST;');
Insert Into @Res Values('import javax.ws.rs.PUT;');
Insert Into @Res Values('import javax.ws.rs.Path;');
Insert Into @Res Values('import javax.ws.rs.Produces;');
Insert Into @Res Values('import javax.ws.rs.core.Context;');
Insert Into @Res Values('import javax.ws.rs.core.MediaType;');
Insert Into @Res Values('import javax.ws.rs.core.Response;');
Insert Into @Res Values('');
Insert Into @Res Values('import org.json.JSONArray;');
Insert Into @Res Values('');
Insert Into @Res Values('import objects.'+@TB+';');
Insert Into @Res Values('import objects.TBUser;');
Insert Into @Res Values('');
Insert Into @Res Values('@Path("/'+REPLACE(@TB, 'TB', '')+'")');
Insert Into @Res Values('public class '+REPLACE(@TB, 'TB', '')+' {');
Insert Into @Res Values('	private ResultSetToJson tojson = new ResultSetToJson();');
Insert Into @Res Values('	@GET');
Insert Into @Res Values('	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")');
Insert Into @Res Values('	public Response sayHello()');
Insert Into @Res Values('	{');
Insert Into @Res Values('		return Response.status(405).entity("<img src=''../img/403.png'' style=''position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;''>").build();');
Insert Into @Res Values('	}');
Insert Into @Res Values('');
Insert Into @Res Values('	@POST');
Insert Into @Res Values('	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")');
Insert Into @Res Values('	public Response loaddata(TBUser obj, @Context HttpServletRequest request)');
Insert Into @Res Values('	{');
Insert Into @Res Values('		JSONArray data = new JSONArray();');
Insert Into @Res Values('		try {');
Insert Into @Res Values('			DataBase db = new DataBase();');
Insert Into @Res Values('			Connection con = db.getConnection();');
Insert Into @Res Values('			PreparedStatement p = con.prepareStatement("Exec Pama.PrcView_'+REPLACE(@TB, 'TB', '')+' ?,?,?");');
Insert Into @Res Values('	 		p.setString(1, obj.getToken());');
Insert Into @Res Values('	 		p.setString(2, db.GetIPAddress(request));');
Insert Into @Res Values('	 		p.setString(3, db.BrowserInfo(request));');
Insert Into @Res Values('			java.sql.ResultSet rs = p.executeQuery();');
Insert Into @Res Values('			if (rs != null){');
Insert Into @Res Values('				while(rs.next())');
Insert Into @Res Values('					data.put(tojson.ResultsetToJson(rs));');
Insert Into @Res Values('			}');
Insert Into @Res Values('			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();');
Insert Into @Res Values('		}');
Insert Into @Res Values('		catch(Exception e) {');
Insert Into @Res Values('			return Response');
Insert Into @Res Values('					.status(Response.Status.UNAUTHORIZED)');
Insert Into @Res Values('					.entity(e.getMessage())');
Insert Into @Res Values('					.build();');
Insert Into @Res Values('		}');
Insert Into @Res Values('	}	');
Insert Into @Res Values('');
Insert Into @Res Values('	@PUT');
Insert Into @Res Values('	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")');
Insert Into @Res Values('	public Response savedata('+@TB+' obj, @Context HttpServletRequest request)');
Insert Into @Res Values('	{');
Insert Into @Res Values('		try {');
Insert Into @Res Values('			DataBase db = new DataBase();');
Insert Into @Res Values('			Connection con = db.getConnection();');
Insert Into @Res Values('			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSave_'+REPLACE(@TB, 'TB', '')+' ?,?,?'+@questionMark+'");');
Insert Into @Res Values('	 		p.setString(1, obj.getToken());');
Insert Into @Res Values('	 		p.setString(2, db.GetIPAddress(request));');
Insert Into @Res Values('	 		p.setString(3, db.BrowserInfo(request));');

Insert Into @Res 
Select '			'+[value]
From string_split(@classJavaSaveFields, '&')
where Trim([value]) <> ''

Insert Into @Res Values('			java.sql.ResultSet rs = p.executeQuery();');
Insert Into @Res Values('			if (rs != null && rs.next())');
Insert Into @Res Values('				return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();');
Insert Into @Res Values('			return Response');
Insert Into @Res Values('					.status(Response.Status.UNAUTHORIZED)');
Insert Into @Res Values('					.entity("جوابی از سرور دریافت نشد")');
Insert Into @Res Values('					.build();');
Insert Into @Res Values('		}');
Insert Into @Res Values('		catch(Exception e) {');
Insert Into @Res Values('			return Response');
Insert Into @Res Values('					.status(Response.Status.UNAUTHORIZED)');
Insert Into @Res Values('					.entity(e.getMessage())');
Insert Into @Res Values('					.build();');
Insert Into @Res Values('		}');
Insert Into @Res Values('	}	');
Insert Into @Res Values('');
Insert Into @Res Values('	@DELETE');
Insert Into @Res Values('	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")');
Insert Into @Res Values('	public Response delprocess(@Context HttpServletRequest request, @HeaderParam("token") String token'+@JavaPk1+')');
Insert Into @Res Values('	{');
Insert Into @Res Values('		try {');
Insert Into @Res Values('			DataBase db = new DataBase();');
Insert Into @Res Values('			Connection con = db.getConnection();');
Insert Into @Res Values('			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDel_'+REPLACE(@TB, 'TB', '')+' ?,?,?,?");');
Insert Into @Res Values('			p.setString(1, token);');
Insert Into @Res Values('	 		p.setString(2, db.GetIPAddress(request));');
Insert Into @Res Values('	 		p.setString(3, db.BrowserInfo(request));');

Insert Into @Res 
Select [value]
From string_split(@JavaPk2, '&')
where Trim([value]) <> ''

Insert Into @Res Values('			java.sql.ResultSet rs = p.executeQuery();');
Insert Into @Res Values('			if (rs != null && rs.next())');
Insert Into @Res Values('				return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();');
Insert Into @Res Values('			return Response');
Insert Into @Res Values('					.status(Response.Status.UNAUTHORIZED)');
Insert Into @Res Values('					.entity("جوابی از سرور دریافت نشد")');
Insert Into @Res Values('					.build();');
Insert Into @Res Values('		}');
Insert Into @Res Values('		catch(Exception e) {');
Insert Into @Res Values('			return Response');
Insert Into @Res Values('					.status(Response.Status.UNAUTHORIZED)');
Insert Into @Res Values('					.entity(e.getMessage())');
Insert Into @Res Values('					.build();');
Insert Into @Res Values('		}');
Insert Into @Res Values('	}	');
Insert Into @Res Values('}');
END

Select *
From @Res

END
Go
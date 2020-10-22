package api;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONArray;
import org.json.JSONObject;

import objects.TBAddInfoData;
import objects.TBCompany;
import objects.TBCompanyUserGroups;
import objects.TBDirector;
import objects.TBDrtFamily;
import objects.TBEmpFamily;
import objects.TBEmployee;
import objects.TBUser;

@Path("/Company")
public class Company {
	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}

	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response company(TBUser user, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcCompany ?,?,?");
	 		p.setString(1, user.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						data.put(tojson.ResultsetToJson(rs));
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Note"))
								.build();
					}
			}
			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}

	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveCompany(TBCompany cmp, @Context HttpServletRequest request, @HeaderParam("token") String token)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PRCSave_Company ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp.getId());
	 		p.setString(5, cmp.getName());
	 		p.setInt(6, cmp.getSabt());
	 		p.setInt(7, cmp.getSabtsazman());
	 		p.setString(8, cmp.getBdate());
	 		p.setString(9, cmp.getEdate());
	 		p.setString(10, cmp.getLastnwid());
	 		p.setString(11, cmp.getLastnwdate());
	 		p.setString(12, cmp.getSabtdate());
	 		p.setDouble(13, cmp.getEcoid());
	 		p.setString(14, cmp.getBimeshobe());
	 		p.setDouble(15, cmp.getBimeid());
	 		p.setDouble(16, cmp.getNationalid());
	 		p.setString(17, cmp.getTax());
	 		p.setInt(18, cmp.getTaxid());
	 		p.setString(19, cmp.getFax());
	 		p.setString(20, cmp.getTel());
	 		p.setInt(21, cmp.getPricekind());
	 		p.setString(22, cmp.getEmail());
	 		p.setString(23, cmp.getNote());
	 		p.setString(24, cmp.getPost());
	 		p.setString(25, cmp.getAddress());
	 		java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()) {
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("id", rs.getInt("ID"));
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.getMessage())
					.build();
		}
	}

	@Path("/active")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response active(TBCompany cmp, @Context HttpServletRequest request, @HeaderParam("token") String token)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSet_Company_Active ?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp.getId());
	 		p.setInt(5, cmp.getActive());
	 		java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", "موفقیت آمیز بود");
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.getMessage())
					.build();
		}
	}

	@Path("/bylaw")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response savebylaw(TBCompany cmp, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSavebylaw ?,?,?,?,?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, cmp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp.getId());
	 		p.setString(5, cmp.getAndate1());
	 		p.setString(6, cmp.getAndate2());
	 		p.setString(7, cmp.getAndate3());
	 		p.setString(8, cmp.getAndate4());
	 		p.setString(9, cmp.getMade1());
	 		p.setString(10, cmp.getMade2());
	 		p.setString(11, cmp.getMade4());
	 		p.setString(12, cmp.getMade5());
	 		p.setString(13, cmp.getMade6());
	 		p.setString(14, cmp.getMade7());
	 		java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()) {
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.getMessage())
					.build();
		}
	}

	@Path("/users")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response users(TBUser user, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcCompanyUsers ?,?,?,?");
	 		p.setString(1, user.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, user.getCmpid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						data.put(tojson.ResultsetToJson(rs));
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Note"))
								.build();
					}
			}
			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/users")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response putuser(TBUser user, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSet_User_Pass ?,?,?,?,?,?,?");
	 		p.setString(1, user.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, user.getCmpid());
	 		p.setInt(5, user.getId());
	 		p.setString(6, user.getPassword());
	 		p.setInt(7, user.getPeopid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						data.put(tojson.ResultsetToJson(rs));
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Note"))
								.build();
					}
			}
			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}
	
	@Path("/users/active")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response usersactive(TBUser user, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSet_User_Active ?,?,?,?,?");
	 		p.setString(1, user.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, user.getId());
	 		p.setInt(5, user.getActive());
	 		java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", "موفقیت آمیز بود");
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity(db.CheckStrFieldValue(rs, "Msg"))
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/users")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response userdelete(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmp, @HeaderParam("userid") int userid)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDel_Company_User ?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp);
	 		p.setInt(5, userid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", "حذف کاربر موفقیت آمیز بود");
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity(db.CheckStrFieldValue(rs, "Msg"))
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/users/group")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response usersgroup(TBUser user, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcUser_Groups ?,?,?,?");
	 		p.setString(1, user.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, user.getId());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						data.put(tojson.ResultsetToJson(rs));
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Note"))
								.build();
					}
			}
			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/users/group")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response usersgroupassign(TBCompanyUserGroups user, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSetUserToGroups ?,?,?,?,?");
	 		p.setString(1, user.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, user.getUserid());
	 		p.setInt(5, user.getGrpid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("msg", "موفقیت آمیز بود");
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity(db.CheckStrFieldValue(rs, "Msg"))
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/Employee")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response employee(TBEmployee emp, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcEmployee ?,?,?,?");
	 		p.setString(1, emp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, emp.getCmpid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						data.put(tojson.ResultsetToJson(rs));
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Note"))
								.build();
					}
			}
			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/Employee")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveemployee(TBEmployee emp, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSave_Employee ?,?,?,?,?,?,?,?,?,?,?,?,?,?");
			p.setString(1, emp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, emp.getCmpid());
	 		p.setInt(5, emp.getPeopid());
	 		p.setInt(6, emp.getKind());
	 		p.setInt(7, emp.getSemat());
	 		p.setInt(8, emp.getCnttype());
	 		p.setInt(9, emp.getExpyear());
	 		p.setInt(10, emp.getPermit());
	 		p.setString(11, emp.gethdate());
	 		p.setString(12, emp.getCntbdate());
	 		p.setString(13, emp.getCntedate());
	 		p.setString(14, emp.getNote());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()){
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/Employee")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delemployee(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmp, @HeaderParam("peopid") int peopid)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDel_Employee ?,?,?,?,?");
			p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp);
	 		p.setInt(5, peopid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()){
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/EmpFamily")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response empfamily(TBEmpFamily emp, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcEmp_Family ?,?,?,?,?");
	 		p.setString(1, emp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, emp.getCmpid());
	 		p.setInt(5, emp.getEmpid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						data.put(tojson.ResultsetToJson(rs));
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Note"))
								.build();
					}
			}
			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/EmpFamily")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveempfamily(TBEmpFamily emp, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSave_EmployeeFamily ?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, emp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, emp.getCmpid());
	 		p.setInt(5, emp.getEmpid());
	 		p.setInt(6, emp.getPeopid());
	 		p.setInt(7, emp.getKind());
	 		p.setString(8, emp.getJob());
	 		p.setString(9, emp.getMdate());
	 		p.setString(10, emp.getNote());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()){
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/EmpFamily")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delempfamily(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmp, @HeaderParam("empid") int empid, @HeaderParam("peopid") int peopid)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDel_EmployeeFamily ?,?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp);
	 		p.setInt(5, empid);
	 		p.setInt(6, peopid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()){
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/Director")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response director(TBDirector dir, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDirector ?,?,?,?");
	 		p.setString(1, dir.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, dir.getCmpid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						data.put(tojson.ResultsetToJson(rs));
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Note"))
								.build();
					}
			}
			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}
	
	@Path("/Director")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response savedirector(TBDirector dir, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveDirector ?,?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, dir.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, dir.getCmpid());
	 		p.setInt(5, dir.getPeopid());
	 		p.setInt(6, dir.getActive());
	 		p.setInt(7, dir.getSemat());
	 		p.setInt(8, dir.getSignright());
	 		p.setInt(9, dir.getEtebarno());
	 		p.setString(10, dir.getEtebardate());
	 		p.setString(11, dir.getBegindate());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()){
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}
	
	@Path("/Director")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deldirector(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmp, @HeaderParam("peopid") int peopid)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelDirector ?,?,?,?,?");
			p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp);
	 		p.setInt(5, peopid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()){
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}
	
	@Path("/DirectorActive")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response setdirectoractive(TBDirector dir, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSetDirectorActive ?,?,?,?,?");
	 		p.setString(1, dir.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, dir.getCmpid());
	 		p.setInt(5, dir.getPeopid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()){
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					data.put("active", rs.getInt("Active"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/DirectorSignRight")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response setdirectorsignright(TBDirector dir, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSetDirectorSignRight ?,?,?,?,?");
	 		p.setString(1, dir.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, dir.getCmpid());
	 		p.setInt(5, dir.getPeopid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()){
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					data.put("signright", rs.getInt("SignRight"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/DrtFamily")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response drtfamily(TBDrtFamily fam, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDrt_Family ?,?,?,?,?");
	 		p.setString(1, fam.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, fam.getCmpid());
	 		p.setInt(5, fam.getDrtid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						data.put(tojson.ResultsetToJson(rs));
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Note"))
								.build();
					}
			}
			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/DrtFamily")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response savedrtfamily(TBDrtFamily fam, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSave_DrtFamily ?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, fam.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, fam.getCmpid());
	 		p.setInt(5, fam.getDrtid());
	 		p.setInt(6, fam.getPeopid());
	 		p.setInt(7, fam.getKind());
	 		p.setString(8, fam.getJob());
	 		p.setString(9, fam.getMdate());
	 		p.setString(10, fam.getNote());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()){
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/DrtFamily")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deldrtfamily(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmp, @HeaderParam("drtid") int drtid, @HeaderParam("peopid") int peopid)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDel_DrtFamily ?,?,?,?,?,?");
			p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp);
	 		p.setInt(5, drtid);
	 		p.setInt(6, peopid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()){
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@Path("/AddInfo")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response companyAddInfo(TBAddInfoData addinfo, @Context HttpServletRequest request, @HeaderParam("cmpid") int cmpid) {
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcCompanyAddInfo ?,?,?,?");
	 		p.setString(1, addinfo.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmpid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						data.put(tojson.ResultsetToJson(rs));
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Note"))
								.build();
					}
			}
			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}

	@Path("/AddInfo")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response SavecompanyAddInfo(TBAddInfoData addinfo, @Context HttpServletRequest request, @HeaderParam("cmpid") int cmpid) {
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveCompanyAddInfo ?,?,?,?,?,?");
	 		p.setString(1, addinfo.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmpid);
	 		p.setInt(5, addinfo.getAddid());
	 		p.setString(6, addinfo.getNote());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						JSONObject data = new JSONObject();
						data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Note"))
								.build();
					}
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}

	@Path("/AddInfo")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delCompanyAddInfo(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmp, @HeaderParam("addid") int addid)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelCompanyAddInfo ?,?,?,?,?");
			p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp);
	 		p.setInt(5, addid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()){
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", db.CheckStrFieldValue(rs, "Msg"));
					return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
				}
				else
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(db.CheckStrFieldValue(rs, "Msg"))
							.build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity("جوابی از سرور دریافت نشد")
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}
}






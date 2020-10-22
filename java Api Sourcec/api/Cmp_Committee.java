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

import objects.TBCmpCom_Detail;
import objects.TBCmpCom_DetailMosavabat;
import objects.TBCmpCom_Member;
import objects.TBCmp_Committee;

@Path("/Cmp_Committee")
public class Cmp_Committee{
	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}
	
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response load(TBCmp_Committee com, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcCmp_Committee ?,?,?,?");
	 		p.setString(1, com.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, com.getCmpid());
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
	public Response save(TBCmp_Committee com, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveCmp_Committee ?,?,?,?,?,?,?,?");
	 		p.setString(1, com.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, com.getCmpid());
	 		p.setInt(5, com.getId());
	 		p.setInt(6, com.getKind());
	 		p.setString(7, com.getName());
	 		p.setInt(8, com.getEmpid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("id", rs.getInt("ID"));
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Msg"))
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

	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response del(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmpid, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelCmp_Committee ?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmpid);
	 		p.setInt(5, id);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("msg", "Success");
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Msg"))
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


	@Path("/Member")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadmember(TBCmpCom_Member mem, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcCmpCom_Member ?,?,?,?,?");
	 		p.setString(1, mem.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, mem.getCmpid());
	 		p.setInt(5, mem.getCmtid());
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

	@Path("/Member")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response savemem(TBCmpCom_Member mem, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveCmpCom_Member ?,?,?,?,?,?,?,?");
	 		p.setString(1, mem.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, mem.getCmpid());
	 		p.setInt(5, mem.getCmtid());
	 		p.setInt(6, mem.getOld());
	 		p.setInt(7, mem.getPeopid());
	 		p.setInt(8, mem.getSemat());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("msg", rs.getString("Msg"));
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Msg"))
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
					.entity("خطا در دریافت اطلاعات از سرور "+e.toString())
					.build();
		}
	}

	@Path("/Member")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delMember(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmpid, @HeaderParam("cmtid") int cmtid, @HeaderParam("peopid") int peopid)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelCmpCom_Member ?,?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmpid);
	 		p.setInt(5, cmtid);
	 		p.setInt(6, peopid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("msg", "Success");
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Msg"))
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

	
	@Path("/Detail")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loaddetail(TBCmpCom_Detail dtl, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcCmpCom_Detail ?,?,?,?,?");
	 		p.setString(1, dtl.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, dtl.getCmpid());
	 		p.setInt(5, dtl.getCmtid());
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

	@Path("/Detail")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response savedetail(TBCmpCom_Detail dtl, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveCmpCom_Detail ?,?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, dtl.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, dtl.getCmpid());
	 		p.setInt(5, dtl.getCmtid());
	 		p.setInt(6, dtl.getId());
	 		p.setString(7, dtl.getTitle());
	 		p.setString(8, dtl.getDate());
	 		p.setString(9, dtl.getTime());
	 		p.setInt(10, dtl.getEmpid());
	 		p.setString(11, dtl.getNote());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("id", rs.getInt("ID"));
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Msg"))
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
					.entity("خطا در دریافت اطلاعات از سرور "+e.toString())
					.build();
		}
	}

	@Path("/Detail")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deldetail(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmpid, @HeaderParam("cmtid") int cmtid, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelCmpCom_Detail ?,?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmpid);
	 		p.setInt(5, cmtid);
	 		p.setInt(6, id);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("msg", "Success");
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Msg"))
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

	
	@Path("/Detail/Absent")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loaddetailAbsent(TBCmpCom_Detail dtl, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcCmpCom_DetailAbsent ?,?,?,?,?,?");
	 		p.setString(1, dtl.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, dtl.getCmpid());
	 		p.setInt(5, dtl.getCmtid());
	 		p.setInt(6, dtl.getId());
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

	@Path("/Detail/Absent")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response savedetailAbsent(TBCmpCom_Detail dtl, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveCmpCom_DetailAbsent ?,?,?,?,?,?,?");
	 		p.setString(1, dtl.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, dtl.getCmpid());
	 		p.setInt(5, dtl.getCmtid());
	 		p.setInt(6, dtl.getId());
	 		p.setInt(7, dtl.getEmpid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("Msg", "Success");
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Msg"))
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
					.entity("خطا در دریافت اطلاعات از سرور "+e.toString())
					.build();
		}
	}

	@Path("/Detail/Absent")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deldetailAbsent(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmpid, @HeaderParam("cmtid") int cmtid, @HeaderParam("detailid") int detailid, @HeaderParam("peopid") int peopid)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelCmpCom_DetailAbsent ?,?,?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmpid);
	 		p.setInt(5, cmtid);
	 		p.setInt(6, detailid);
	 		p.setInt(7, peopid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("msg", "Success");
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Msg"))
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

	
	@Path("/Detail/Mosavabat")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loaddetailMosavabat(TBCmpCom_DetailMosavabat mos, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcCmpCom_DetailMosavabat ?,?,?,?,?,?");
	 		p.setString(1, mos.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, mos.getCmpid());
	 		p.setInt(5, mos.getCmtid());
	 		p.setInt(6, mos.getDetailid());
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

	@Path("/Detail/Mosavabat")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response savedetailMosavabat(TBCmpCom_DetailMosavabat mos, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveCmpCom_DetailMosavabat ?,?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, mos.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, mos.getCmpid());
	 		p.setInt(5, mos.getCmtid());
	 		p.setInt(6, mos.getDetailid());
	 		p.setInt(7, mos.getId());
	 		p.setString(8, mos.getTitle());
	 		p.setString(9, mos.getVahed());
	 		p.setInt(10, mos.getEmpid());
	 		p.setInt(11, mos.getMcmpid());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("id", rs.getInt("ID"));
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Msg"))
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
					.entity("خطا در دریافت اطلاعات از سرور "+e.toString())
					.build();
		}
	}

	@Path("/Detail/Mosavabat")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deldetailMosavabat(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmpid, @HeaderParam("cmtid") int cmtid, @HeaderParam("detailid") int detailid, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelCmpCom_DetailMosavabat ?,?,?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmpid);
	 		p.setInt(5, cmtid);
	 		p.setInt(6, detailid);
	 		p.setInt(7, id);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("msg", "Success");
						return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(db.CheckStrFieldValue(rs, "Msg"))
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

}

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

import objects.TBInspection;
import objects.TBInspection_Company;
import objects.TBInspection_Company_Peop;
import objects.TBInspection_Gov;

@Path("/Inspection")
public class Inspection {
	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}

	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response load(TBInspection insp, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcInspection ?,?,?,?");
	 		p.setString(1, insp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4,  insp.getCmpid());
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
	public Response save(TBInspection insp, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveInspection ?,?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, insp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, insp.getCmpid());
	 		p.setInt(5, insp.getId());
	 		p.setString(6, insp.getName());
	 		p.setString(7, insp.getTopic());
	 		p.setString(8, insp.getBdate());
	 		p.setString(9, insp.getEdate());
	 		p.setString(10, insp.getRange());
	 		p.setString(11, insp.getNote());
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

	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delete(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelInspection ?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, id);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", "Success");
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}


	@Path("/Gov")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadGov(TBInspection_Gov gov, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcInspection_Gov ?,?,?,?");
	 		p.setString(1, gov.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4,  gov.getInsid());
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

	@Path("/Gov")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveGov(TBInspection_Gov gov, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveInspection_Gov ?,?,?,?,?,?");
	 		p.setString(1, gov.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, gov.getInsid());
	 		p.setInt(5, gov.getGovid());
	 		p.setString(6, gov.getNote());
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

	@Path("/Gov")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deleteGov(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("insid") int insid, @HeaderParam("govid") int govid)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelInspection_Gov ?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, insid);
	 		p.setInt(5, govid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", "Success");
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}


	@Path("/Company")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadCompany(TBInspection_Company cmp, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcInspection_Company ?,?,?,?");
	 		p.setString(1, cmp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4,  cmp.getInsid());
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

	@Path("/Company")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveCompany(TBInspection_Company cmp, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveInspection_Company ?,?,?,?,?,?");
	 		p.setString(1, cmp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp.getInsid());
	 		p.setInt(5, cmp.getCmpid());
	 		p.setString(6, cmp.getNote());
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

	@Path("/Company")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deleteCompany(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("insid") int insid, @HeaderParam("cmpid") int cmpid)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelInspection_Company ?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, insid);
	 		p.setInt(5, cmpid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", "Success");
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}


	@Path("/CompanyPeop")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadCompanyPeop(TBInspection_Company_Peop peop, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcInspection_Company_Peop ?,?,?,?,?,?");
	 		p.setString(1, peop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4,  peop.getInsid());
	 		p.setInt(5,  peop.getCmpid());
	 		p.setInt(6,  peop.getKind());
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

	@Path("/CompanyPeop")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveCompanyPeop(TBInspection_Company_Peop peop, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveInspection_Company_People ?,?,?,?,?,?,?");
			p.setString(1, peop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, peop.getInsid());
	 		p.setInt(5, peop.getCmpid());
	 		p.setInt(6, peop.getPeopid());
	 		p.setInt(7, peop.getKind());
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

	@Path("/CompanyPeop")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deleteCompanyPeop(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("insid") int insid, @HeaderParam("cmpid") int cmpid, @HeaderParam("peopid") int peopid, @HeaderParam("kind") int kind)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelInspection_Company_Peop ?,?,?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, insid);
	 		p.setInt(5, cmpid);
	 		p.setInt(6, peopid);
	 		p.setInt(7, kind);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("msg", "Success");
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}
}

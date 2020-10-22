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

import objects.TBAddInfo;
import objects.TBAddInfo_Note;

@Path("/AddInfo")
public class AddInfo {
	
	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}
	
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loaddata(TBAddInfo addinfo, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcAddInfo ?,?,?");
	 		p.setString(1, addinfo.getToken());
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
	public Response savedata(TBAddInfo addinfo, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveAddInfo ?,?,?,?,?,?");
	 		p.setString(1, addinfo.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, addinfo.getId());
	 		p.setString(5, addinfo.getName());
	 		p.setInt(6, addinfo.getKind());
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

	@Path("/Dublicate")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response setdublicate(TBAddInfo addinfo, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSetAddInfo_Dublicate ?,?,?,?");
	 		p.setString(1, addinfo.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, addinfo.getId());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
						JSONObject data = new JSONObject();
						data.put("dublicate", rs.getInt("Dublicate"));
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
	public Response deladdinfo(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelAddInfo ?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, id);
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


	
	@Path("/Note")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadnotes(TBAddInfo addinfo, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcAddInfo_Note ?,?,?,?");
	 		p.setString(1, addinfo.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, addinfo.getId());
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

	@Path("/Note")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response savenotes(TBAddInfo_Note note, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveAddInfo_Note ?,?,?,?,?,?");
	 		p.setString(1, note.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, note.getAddid());
	 		p.setInt(5, note.getId());
	 		p.setString(6, note.getNote());
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

	@Path("/Note")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deladdinfo_Note(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("addid") int addid, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelAddInfo_Note ?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, addid);
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
}

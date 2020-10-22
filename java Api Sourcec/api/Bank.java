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

import objects.TBBank;

@Path("/Bank")
public class Bank {

	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}
	
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response bank(TBBank bank, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcBank ?,?,?");
	 		p.setString(1, bank.getToken());
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
	public Response savebank(TBBank bank, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveBank ?,?,?,?,?");
	 		p.setString(1, bank.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, bank.getId());
	 		p.setString(5, bank.getName());
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
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}

	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delbank(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelBank ?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, id);
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}
}

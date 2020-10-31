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

import objects.TBNoLicense;

@Path("/NoLicense")
public class NoLicense {
	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}

	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadData(TBNoLicense lcn, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcNoLicense ?,?,?,?");
	 		p.setString(1, lcn.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, lcn.getCmpid());
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
	public Response save(TBNoLicense lcn, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveNoLicense ?,?,?,?,?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, lcn.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, lcn.getCmpid());
	 		p.setInt(5, lcn.getId());
	 		p.setString(6, lcn.getNationalid());
	 		p.setString(7, lcn.getName());
	 		p.setString(8, lcn.getFamily());
	 		p.setInt(9, lcn.getHisic());
	 		p.setInt(10, lcn.getIsic());
	 		p.setString(11, lcn.getTel());
	 		p.setString(12, lcn.getPost());
	 		p.setString(13, lcn.getNosazicode());
	 		p.setString(14, lcn.getAddress());
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
	
	@Path("/Note")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveNote(TBNoLicense lcn, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveNoLicense_Note ?,?,?,?,?,?");
	 		p.setString(1, lcn.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, lcn.getCmpid());
	 		p.setInt(5, lcn.getId());
	 		p.setString(6, lcn.getNote());
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

	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delete(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("cmpid") int cmp, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelNoLicense ?,?,?,?,?");
	 		p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp);
	 		p.setInt(5, id);
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}
}

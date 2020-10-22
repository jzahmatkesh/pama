package api;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONArray;
import org.json.JSONObject;

import objects.TBPeople;

@Path("/People")
public class People{
	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}

	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response checknationalid(TBPeople peop, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcCheck_NationalID ?,?,?,?,?,?");
	 		p.setString(1, peop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setString(4, peop.getNationalid());
	 		p.setString(5, peop.getFamily());
	 		p.setString(6, peop.getMobile());
	 		java.sql.ResultSet rs = p.executeQuery();
	 		if (rs != null){
				while(rs.next()) {
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
			return Response
					.status(Response.Status.FORBIDDEN)
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

	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response savePeople(TBPeople peop, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSave_People ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, peop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, peop.getId());
	 		p.setInt(5, peop.getSingle());
	 		p.setInt(6, peop.getSex());
	 		p.setInt(7, peop.getMilitary());
	 		p.setInt(8, peop.getEducation());
	 		p.setInt(9, peop.getBimeno());
	 		p.setInt(10, peop.getIsargari());
	 		p.setString(11, peop.getNationalid());
	 		p.setString(12, peop.getName());
	 		p.setString(13, peop.getFamily());
	 		p.setString(14, peop.getFather());
	 		p.setString(15, peop.getSs());
	 		p.setString(16, peop.getBirth());
	 		p.setString(17, peop.getSsplace());
	 		p.setString(18, peop.getBirthdate());
	 		p.setString(19, peop.getNationality());
	 		p.setString(20, peop.getReligion());
	 		p.setString(21, peop.getMazhab());
	 		p.setString(22, peop.getReshte());
	 		p.setString(23, peop.getEnglish());
	 		p.setString(24, peop.getIsargarinesbat());
	 		p.setString(25, peop.getEmail());
	 		p.setString(26, peop.getTel());
	 		p.setString(27, peop.getMobile());
	 		p.setString(28, peop.getPost());
	 		p.setString(29, peop.getAddress());
	 		p.setString(30, peop.getPassport());
	 		java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed"))
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity(db.CheckStrFieldValue(rs, "Note"))
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

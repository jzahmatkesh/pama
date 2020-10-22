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

import objects.TBProperty;

@Path("/Property")
public class Property {
	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}

	@Path("/Mobile")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadmobile(TBProperty prop, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcMobile ?,?,?,?");
	 		p.setString(1, prop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, prop.getCmpid());
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
					.entity("خطا در دریافت اطلاعات از سرور ")
					.build();
		}
	}

	@Path("/Mobile")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response savemobile(TBProperty prop, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveMobile ?,?,?,?,?,?,?,?,?,?");
			p.setString(1, prop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, prop.getCmpid());
	 		p.setInt(5, prop.getId());
	 		p.setString(6, prop.getName());
	 		p.setInt(7, prop.getActive());
	 		p.setString(8, prop.getBuydate());
	 		p.setString(9, prop.getOwner());
	 		p.setInt(10, prop.getPeopid());
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

	@Path("/Mobile")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deletemobile(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelMobile ?,?,?,?");
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
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}


	@Path("/Car")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadCar(TBProperty prop, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcCar ?,?,?,?");
	 		p.setString(1, prop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, prop.getCmpid());
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

	@Path("/Car")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveCar(TBProperty prop, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveCar ?,?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, prop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, prop.getCmpid());
	 		p.setInt(5, prop.getId());
	 		p.setString(6, prop.getName());
	 		p.setString(7, prop.getBuydate());
	 		p.setString(8, prop.getColor());
	 		p.setString(9, prop.getStatus());
	 		p.setString(10, prop.getPelak());
	 		p.setInt(11, prop.getPeopid());
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

	@Path("/Car")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deleteCar(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelCar ?,?,?,?");
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
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}


	@Path("/PropGHM")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadPropGHM(TBProperty prop, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcPropGhM ?,?,?,?");
	 		p.setString(1, prop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, prop.getCmpid());
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

	@Path("/PropGHM")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response savePropGHM(TBProperty prop, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSavePropGhM ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, prop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, prop.getCmpid());
	 		p.setInt(5, prop.getId());
	 		p.setString(6, prop.getName());
	 		p.setInt(7, prop.getMalekiat());
	 		p.setString(8, prop.getUsage());
	 		p.setString(9, prop.getContractdate());
	 		p.setFloat(10, prop.getPrice());
	 		p.setInt(11, prop.getMetraj());
	 		p.setInt(12, prop.getAge());
	 		p.setFloat(13, prop.getCprice());
	 		p.setString(14, prop.getKarbari());
	 		p.setInt(15, prop.getTenant());
	 		p.setString(16, prop.getPelak());
	 		p.setString(17, prop.getAddress());
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

	@Path("/PropGHM")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deletePropGHM(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelPropGhM ?,?,?,?");
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
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}


	@Path("/BankHesab")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadBankHesab(TBProperty prop, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcBankHesab ?,?,?,?");
	 		p.setString(1, prop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, prop.getCmpid());
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

	@Path("/BankHesab")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveBankHesab(TBProperty prop, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveBankHesab ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?");
	 		p.setString(1, prop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, prop.getCmpid());
	 		p.setInt(5, prop.getId());
	 		p.setInt(6, prop.getAccounttype());
	 		p.setInt(7, prop.getBankid());
	 		p.setString(8, prop.getBuydate());
	 		p.setString(9, prop.getOwner());
	 		p.setString(10, prop.getBcondition());
	 		p.setString(11, prop.getHesabno());
	 		p.setString(12, prop.getShaba());
	 		p.setString(13, prop.getCardno());
	 		p.setInt(14, prop.getTafsiliid());
	 		p.setInt(15, prop.getInternetbank());
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

	@Path("/BankHesab")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deleteBankHesab(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelBankHesab ?,?,?,?");
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
					.entity("خطا در دریافت اطلاعات از سرور"+e.toString())
					.build();
		}
	}


	@Path("/Active")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response setActive(TBProperty prop, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSetPropertyActive ?,?,?,?");
			p.setString(1, prop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, prop.getId());
	 		java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()) {
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
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
					.entity("خطا در دریافت اطلاعات از سرور"+e.getMessage())
					.build();
		}
	}


	@Path("/InternetBank")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response setInternetBank(TBProperty prop, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSetPropertyInternetBank ?,?,?,?");
			p.setString(1, prop.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, prop.getId());
	 		java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()) {
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					JSONObject data = new JSONObject();
					data.put("internetbank", rs.getInt("InternetBank"));
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
}

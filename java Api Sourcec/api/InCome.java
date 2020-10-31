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

import objects.TBIncome;
import objects.TBIncomeCompany;
import objects.TBIncomeCompanyRaste;
import objects.TBIncomePriceHistory;
import objects.TBIncomeShare;

@Path("/Income")
public class InCome {
	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}

	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response load(TBIncome inc, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcIncome ?,?,?");
	 		p.setString(1, inc.getToken());
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
	public Response save(TBIncome inc, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveIncome ?,?,?,?,?,?,?,?,?,?");
			p.setString(1, inc.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, inc.getId());
	 		p.setString(5, inc.getName());
	 		p.setInt(6, inc.getActive());
	 		p.setInt(7, inc.getEpay());
	 		p.setInt(8, inc.getRefund());
	 		p.setInt(9, inc.getOff());
	 		p.setInt(10, inc.getAllcmp());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
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
					.entity("خطا در دریافت اطلاعات از سرور")
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
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelIncome ?,?,?,?");
			p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, id);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}	

	
	@Path("/Share")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadShare(TBIncomeShare shr, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcIncomeShare ?,?,?,?");
	 		p.setString(1, shr.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, shr.getIncid());
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

	@Path("/Share")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveShare(TBIncomeShare shr, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveIncomeShare ?,?,?,?,?,?,?");
			p.setString(1, shr.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, shr.getIncid());
	 		p.setInt(5, shr.getId());
	 		p.setString(6, shr.getName());
	 		p.setInt(7, shr.getPerc());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}	

	@Path("/Share")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deleteShare(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("incid") int incid, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelIncomeShare ?,?,?,?,?");
			p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, incid);
	 		p.setInt(5, id);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}	

	
	@Path("/History")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadHistory(TBIncomePriceHistory hst, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcIncomePriceHistory ?,?,?,?");
	 		p.setString(1, hst.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, hst.getIncid());
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

	@Path("/History")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveHistory(TBIncomePriceHistory hst, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveIncomePriceHistory ?,?,?,?,?,?,?");
			p.setString(1, hst.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, hst.getIncid());
	 		p.setInt(5, hst.getId());
	 		p.setString(6, hst.getDate());
	 		p.setDouble(7, hst.getPrice());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}	

	@Path("/History")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deleteHistory(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("incid") int incid, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelIncomePriceHistory ?,?,?,?,?");
			p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, incid);
	 		p.setInt(5, id);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}	

	
	@Path("/Company")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadCompany(TBIncomeCompany cmp, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcIncomeCompany ?,?,?,?");
	 		p.setString(1, cmp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp.getIncid());
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
	public Response saveCompany(TBIncomeCompany cmp, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveIncomeCompany ?,?,?,?,?,?,?");
			p.setString(1, cmp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, cmp.getIncid());
	 		p.setInt(5, cmp.getOld());
	 		p.setInt(6, cmp.getCmpid());
	 		p.setInt(7, cmp.getAllraste());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}	

	@Path("/Company")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deleteCompany(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("incid") int incid, @HeaderParam("cmpid") int cmpid)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelIncomeCompany ?,?,?,?,?");
			p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, incid);
	 		p.setInt(5, cmpid);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}	

	
	@Path("/Company/Raste")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadCompanyRaste(TBIncomeCompanyRaste rst, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcIncomeCompanyRaste ?,?,?,?,?");
			p.setString(1, rst.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, rst.getIncid());
	 		p.setInt(5, rst.getCmpid());
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

	@Path("/Company/Raste")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveCompanyRaste(TBIncomeCompanyRaste rst, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcSaveIncomeCompanyRaste ?,?,?,?,?,?,?,?,?,?,?,?");
			p.setString(1, rst.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, rst.getIncid());
	 		p.setInt(5, rst.getCmpid());
	 		p.setInt(6, rst.getId());
	 		p.setInt(7, rst.getHisic());
	 		p.setInt(8, rst.getIsic());
	 		p.setInt(9, rst.getGrade1());
	 		p.setInt(10, rst.getGrade2());
	 		p.setInt(11, rst.getGrade3());
	 		p.setInt(12, rst.getGrade4());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}	

	@Path("/Company/Raste")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response deleteCompanyRaste(@Context HttpServletRequest request, @HeaderParam("token") String token, @HeaderParam("incid") int incid, @HeaderParam("cmpid") int cmpid, @HeaderParam("id") int id)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcDelIncomeCompanyRaste ?,?,?,?,?,?");
			p.setString(1, token);
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, incid);
	 		p.setInt(5, cmpid);
	 		p.setInt(6, id);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}	
}

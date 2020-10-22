package api;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Context;

import org.json.JSONObject;

import objects.TBUser;

@Path("/User")
public class User {
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}

	@POST
	@Path("/login")
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response login(TBUser user, @Context HttpServletRequest request)
	{
		JSONObject jwtPayload = new JSONObject();
		try {
			DataBase db = new DataBase();
			if (db.ValidateUser(user.getUsername(), user.getPassword())) {
				jwtPayload.put("token", db.Token);
				jwtPayload.put("id", db.UserID.toString());
				jwtPayload.put("name", db.Name);
				jwtPayload.put("family", db.Family);
				jwtPayload.put("mobile", db.Mobile);
				jwtPayload.put("cmpid", db.CmpID.toString());
				jwtPayload.put("cmptitle", db.CmpTitle);
				jwtPayload.put("sex", db.sex.toString());
//				jwtPayload.put("pic", db.Pic.toString());
				jwtPayload.put("lastlogin", db.LastLogin);
				jwtPayload.put("admin", db.admin);
				jwtPayload.put("ip", db.GetIPAddress(request));

				return Response.ok(jwtPayload.toString(), MediaType.APPLICATION_JSON).build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity(db.LoginError)
					.build();
		}
		catch(Exception e) {
			jwtPayload.put("msg", "خطا در شناسایی کاربر");
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity(jwtPayload.toString())
					.build();
		}
	}

	@POST
	@Path("/verify")
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response verify(TBUser user, @Context HttpServletRequest request)
	{
		JSONObject jwtPayload = new JSONObject();
		try {
			DataBase db = new DataBase();
			if (db.ValidateByToken(user.getToken())) {
				jwtPayload.put("token", db.Token);
				jwtPayload.put("id", db.UserID.toString());
				jwtPayload.put("name", db.Name);
				jwtPayload.put("family", db.Family);
				jwtPayload.put("mobile", db.Mobile);
				jwtPayload.put("cmpid", db.CmpID.toString());
				jwtPayload.put("cmptitle", db.CmpTitle);
				jwtPayload.put("sex", db.sex.toString());
//				jwtPayload.put("pic", db.Pic.toString());
				jwtPayload.put("lastlogin", db.LastLogin);
				jwtPayload.put("ip", db.GetIPAddress(request));
				jwtPayload.put("admin", db.admin);
				return Response.ok(jwtPayload.toString(), MediaType.APPLICATION_JSON).build();
			}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity(db.LoginError)
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity("خطا در شناسایی وضعیت. لطفا مجددا اقدام به انجام عملیات ورود نمایید")
					.build();
		}
	}
}

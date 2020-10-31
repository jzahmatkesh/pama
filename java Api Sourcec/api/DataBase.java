package api;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.NumberFormat;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

public class DataBase {
	public String ErrorMsg;
	public String LoginError;
	public Integer UserID;
	public String Name;
	public String Family;
	public String Mobile;
	public String LastLogin;
	public String Token;
	public Integer Pic;
	public Integer CmpID;
	public String CmpTitle;
	public Integer sex;
	public Integer admin;
	public Integer ejriat;


	public java.sql.Connection DBCon;
	public Boolean sqlcon(){
		return sqlcon("", "");
	}
	public Boolean sqlcon(String usr,String pss){
		if (usr.trim().isEmpty()){
			usr = "Pama";
			pss = "S@ny@rIsTheBestB@be";
		}
		try{
			if ((DBCon == null) || DBCon.isClosed()){
				String url  = "jdbc:sqlserver://127.0.0.1;DataBaseName=Pama";
//				String url  = "jdbc:sqlserver://127.0.0.1\\sanyar;DataBaseName=Pama";
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				DBCon = java.sql.DriverManager.getConnection(url, usr, pss);
				DBCon.setAutoCommit(true);
			}
			return true;
		}catch(Exception E){
			ErrorMsg = "sqlcon: "+E.getMessage();
			System.out.println(ErrorMsg);			
			return false;
		}
	}
	
	public String GetIPAddress(HttpServletRequest request){
		if (request != null) {
		   String ipAddress = request.getHeader("X-FORWARDED-FOR");  
		   if (ipAddress == null) {  
			   return request.getRemoteAddr();  
		   }
		   else
			   return ipAddress;
		}
		else
			return "";
	}
	
	private String browserinfo(String browserDetails){
		String  userAgent       =   browserDetails;
        String  user            =   userAgent.toLowerCase();

        String os = "";
        String browser = "";
        //=================OS=======================
         if (userAgent.toLowerCase().indexOf("windows") >= 0 )
         {
             os = "Windows";
         } else if(userAgent.toLowerCase().indexOf("iphone") >= 0)
         {
             os = "iPhone";
         } else if(userAgent.toLowerCase().indexOf("mac") >= 0)
         {
             os = "Mac";
         } else if(userAgent.toLowerCase().indexOf("x11") >= 0)
         {
             os = "Unix";
         } else if(userAgent.toLowerCase().indexOf("android") >= 0)
         {
             os = "Android";
         }else{
             os = "UnKnown, More-Info: "+userAgent;
         }
         //===============Browser===========================
        if (user.contains("msie"))
        {
            String substring=userAgent.substring(userAgent.indexOf("MSIE")).split(";")[0];
            browser=substring.split(" ")[0].replace("MSIE", "IE")+"-"+substring.split(" ")[1];
        } else if(user.contains("edge"))
        {
            browser=(userAgent.substring(userAgent.indexOf("Edge")).split(" ")[0]).replace("/", "-");
    	} else if(user.contains("rv"))
        {
            browser="IE";
        } else if (user.contains("safari") && user.contains("version"))
        {
            browser=(userAgent.substring(userAgent.indexOf("Safari")).split(" ")[0]).split("/")[0]+"-"+(userAgent.substring(userAgent.indexOf("Version")).split(" ")[0]).split("/")[1];
        } else if ( user.contains("opr") || user.contains("opera"))
        {
            if(user.contains("opera"))
                browser=(userAgent.substring(userAgent.indexOf("Opera")).split(" ")[0]).split("/")[0]+"-"+(userAgent.substring(userAgent.indexOf("Version")).split(" ")[0]).split("/")[1];
            else if(user.contains("opr"))
                browser=((userAgent.substring(userAgent.indexOf("OPR")).split(" ")[0]).replace("/", "-")).replace("OPR", "Opera");
        } else if (user.contains("chrome"))
        {
            browser=(userAgent.substring(userAgent.indexOf("Chrome")).split(" ")[0]).replace("/", "-");
        } else if ((user.indexOf("mozilla/7.0") > -1) || (user.indexOf("netscape6") != -1)  || (user.indexOf("mozilla/4.7") != -1) || (user.indexOf("mozilla/4.78") != -1) || (user.indexOf("mozilla/4.08") != -1) || (user.indexOf("mozilla/3") != -1) )
        {
            //browser=(userAgent.substring(userAgent.indexOf("MSIE")).split(" ")[0]).replace("/", "-");
            browser = "Netscape-?";

        } else if (user.contains("firefox"))
        {
            browser=(userAgent.substring(userAgent.indexOf("Firefox")).split(" ")[0]).replace("/", "-");
        } else
        {
            browser = "UnKnown, More-Info: "+userAgent;
        }
        return os+" - "+browser;
	}

	public void SetSiteViewCounter(HttpServletRequest request){
	    try {
			RunQuery(request, "Exec PrcSetSiteView '"+GetIPAddress(request)+"','"+BrowserInfo(request)+"'");
		} catch (Exception e) {		
			System.out.println(e.getMessage());
		}
	}
	
	public String BrowserInfo(HttpServletRequest request){
		String browserDetails = request.getHeader("User-Agent");
		browserDetails = browserDetails.replaceAll("'", " ");
		String brinfo  = browserinfo(browserDetails).replaceAll("'", " ");
		return brinfo;
	}
	
	public void LogError(HttpServletRequest request, String Note, String Doreh, String UserID) throws SQLException{
		try {
			String browserDetails = "",
				   brinfo = "";
			if (request != null) {
				browserDetails = request.getHeader("User-Agent"); 
				browserDetails= browserDetails.replaceAll("'", " ");
				brinfo = browserinfo(browserDetails).replaceAll("'", " ");
				Note = Note.replaceAll("'", " ");
			}
			
			if (UserID.trim().isEmpty() || UserID == null)
				UserID = "0";
			if (Doreh.trim().isEmpty() || Doreh == null)
				Doreh = "0";
			String sql = "Exec PrcLogError '"+brinfo+"','"+GetIPAddress(request)+"','"+Note+"',"+UserID+","+Doreh;
			if (sqlcon()){
				java.sql.Statement s = DBCon.createStatement();					
				s.executeQuery(sql);
			}
		} catch (Exception e) {
			System.out.println("errrrr: "+e.toString());
		}
	}
	
	public boolean ValidateUser(String UsName, String UsPass){
		try{
			Connection con = getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcAuthenticate ?,?");
	 		p.setString(1, UsName);
	 		p.setString(2, UsPass);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()) {
				if (rs.getString(1).equals("Success")){
					UserID        = rs.getInt("id");
					Name   		  = rs.getString("Name");
					Family   	  = rs.getString("family");
					Mobile		  = rs.getString("Mobile");
					Token   	  = rs.getString("Token");
//					Pic           = rs.getInt("Pic");
					LastLogin     = rs.getString("LastLogin");
					sex           = rs.getInt("Sex");
					admin         = rs.getInt("Admin");
					CmpID         = rs.getInt("CmpID");
					CmpTitle      = rs.getString("CmpTitle");
					ejriat        = rs.getInt("Ejriat");
					
					LoginError	  = null;
					return true;
				}
				else{
					LoginError	  = rs.getString(1);
					return false;
				}
			}
			else{
				LoginError = "نام کاربری/رمز عبور صحیح نمی باشد";
				return false;
			}
		}
		catch(Exception E){
			ErrorMsg = "SetUserInfo: "+E.getMessage();
			LoginError = "خطا در شناسایی مشخصات کاربری. لطفا پس از بروز رسانی مجددا سعی نمایید "+E.getMessage();
			return false;
		}
	}
	public boolean ValidateByToken(String token){
		try{
			Connection con = getConnection();
			PreparedStatement p = con.prepareStatement("Exec Pama.PrcToken_Authenticate ?");
	 		p.setString(1, token);
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next()) {
				if (rs.getString(1).equals("Success")){
					UserID        = rs.getInt("id");
					Name   		  = rs.getString("Name");
					Family   	  = rs.getString("family");
					Mobile		  = rs.getString("Mobile");
					Token   	  = rs.getString("Token");
//					Pic           = rs.getInt("Pic");
					LastLogin     = rs.getString("LastLogin");
					sex           = rs.getInt("Sex");
					admin         = rs.getInt("Admin");
					CmpID         = rs.getInt("CmpID");
					CmpTitle      = rs.getString("CmpTitle");
					ejriat        = rs.getInt("Ejriat");
					LoginError	  = null;
					return true;
				}
				else{
					LoginError	  = rs.getString(1);
					return false;
				}
			}
			else{
				LoginError = "نام کاربری/رمز عبور صحیح نمی باشد";
				return false;
			}
		}
		catch(Exception E){
			ErrorMsg = "SetUserInfo: "+E.getMessage();
			LoginError = "خطا در شناسایی مشخصات کاربری. لطفا پس از بروز رسانی مجددا سعی نمایید "+E.getMessage();
			return false;
		}
	}
	
	public java.sql.ResultSet RunQuery(HttpServletRequest request, String sql) throws SQLException{
		try{
			if (sqlcon()){
//				DBCon.setAutoCommit(false);
				java.sql.Statement s = DBCon.createStatement();					
				java.sql.ResultSet rs = s.executeQuery(sql);
//				DBCon.commit();
				return rs;
			}
			else
				return null;
		}
		catch(SQLException E){
			LogError(request, E.toString()+" - "+sql, "", "");
//			DBCon.rollback();
			String msg = E.getMessage();
			if (msg.indexOf("The executeQuery method must return a result set") == -1){
				throw new RuntimeException(E.getMessage());
			}
			return null;
		}
	}
	
	public java.sql.Connection getConnection(){
		if (sqlcon())
			return DBCon;
		else
			return null;
	}
	
    public String CheckFieldValue(java.sql.ResultSet rs, Integer fldidx){
		try{
			String str = rs.getString(fldidx);
			if (rs.wasNull())
				return "";
			else 
				return str;
		}
		catch(Exception E){
			return "";
		}
	}
    
	public String CheckStrFieldValue(java.sql.ResultSet rs, String fld){
		  try{
			  String str = rs.getString(fld);
			  if (rs.wasNull())
				  return "";
			  else 
				  return str;
		  }
		  catch(Exception E){
			  return "";
		  }
	}
	
	public String CheckMoneyFieldValue(java.sql.ResultSet rs, String fld){
		  try{
			  BigDecimal d = rs.getBigDecimal(fld);
			  
			  Boolean negative = false;
			  if (rs.getFloat(fld) < 0)
				  negative = true;
			  
			  DecimalFormat f = new DecimalFormat("###,###.######");
			  if (negative) {
				  String s = "("+f.format(d)+")";
				  s = s.replace("-", "");
				  return s;
			  }
			  else
				  return f.format(d);
		  }
		  catch(Exception E){
			  return "0";
		  }
	}
	
	public String AddComma(Double bd){
		  try{
			  Boolean negative = false;
			  if (bd < 0){
				  negative = true;
				  bd = bd*-1;
			  }
			  DecimalFormat formatter = (DecimalFormat) NumberFormat.getInstance(Locale.US);
			  DecimalFormatSymbols symbols = formatter.getDecimalFormatSymbols();

			  symbols.setGroupingSeparator(',');
			  formatter.setDecimalFormatSymbols(symbols);
			  if (negative)
				  return "("+formatter.format(bd.longValue())+")";
			  else
				  return formatter.format(bd.longValue());
		  }
		  catch(Exception E){
			  return "0";
		  }
	}

	public String FormatFloat(float bd){
		  try{
			  Boolean negative = false;
			  if (bd < 0){
				  negative = true;
				  bd = bd*-1;
			  }
			  DecimalFormat formatter = (DecimalFormat) NumberFormat.getInstance(Locale.US);
			  DecimalFormatSymbols symbols = formatter.getDecimalFormatSymbols();

			  symbols.setGroupingSeparator(',');
			  formatter.setDecimalFormatSymbols(symbols);
			  if (negative)
				  return "("+formatter.format(bd)+")";
			  else
				  return formatter.format(bd);
		  }
		  catch(Exception E){
			  return "0";
		  }
	}

	public String FormatLong(long bd){
		  try{
			  Boolean negative = false;
			  if (bd < 0){
				  negative = true;
				  bd = bd*-1;
			  }
			  DecimalFormat formatter = (DecimalFormat) NumberFormat.getInstance(Locale.US);
			  DecimalFormatSymbols symbols = formatter.getDecimalFormatSymbols();

			  symbols.setGroupingSeparator(',');
			  formatter.setDecimalFormatSymbols(symbols);
			  if (negative)
				  return "("+formatter.format(bd)+")";
			  else
				  return formatter.format(bd);
		  }
		  catch(Exception E){
			  return "0";
		  }
	}

    public boolean isNumeric(String s) {  
        return s != null && s.matches("[-+]?\\d*\\.?\\d+");  
    }
    
    public String SetZeroIfEmpty(String str){
    	if (str.trim().isEmpty() || str == null || str.trim().equals("null") || str.trim().equals("undefined"))
    		return "0";
    	else
    		return str;
    }
    
}

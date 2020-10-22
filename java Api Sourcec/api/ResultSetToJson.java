package api;

import java.sql.ResultSetMetaData;

import org.json.JSONObject;

public class ResultSetToJson {

	public JSONObject PeopletoJson(java.sql.ResultSet rs) throws Exception{
		DataBase db = new DataBase();
		JSONObject data = new JSONObject();
		data.put("id", rs.getInt("id"));
		data.put("name", db.CheckStrFieldValue(rs, "name"));
		data.put("family", db.CheckStrFieldValue(rs, "family"));
		data.put("nationalID", db.CheckStrFieldValue(rs, "nationalID"));
		data.put("father", db.CheckStrFieldValue(rs, "father"));
		data.put("ss", db.CheckStrFieldValue(rs, "ss"));
		data.put("birth", db.CheckStrFieldValue(rs, "birth"));
		data.put("ssplace", db.CheckStrFieldValue(rs, "ssplace"));
		data.put("birthdate", db.CheckStrFieldValue(rs, "birthdate"));
		data.put("nationality", db.CheckStrFieldValue(rs, "nationality"));
		data.put("religion", db.CheckStrFieldValue(rs, "religion"));
		data.put("mazhab", db.CheckStrFieldValue(rs, "mazhab"));
		data.put("reshte", db.CheckStrFieldValue(rs, "reshte"));
		data.put("english", db.CheckStrFieldValue(rs, "english"));
		data.put("bimeno", db.CheckStrFieldValue(rs, "bimeno"));
		data.put("isargari", rs.getInt("isargari"));
		data.put("isargarinesbat", db.CheckStrFieldValue(rs, "Isargari_Nesbat"));
		data.put("email", db.CheckStrFieldValue(rs, "email"));
		data.put("tel", db.CheckStrFieldValue(rs, "tel"));
		data.put("mobile", db.CheckStrFieldValue(rs, "mobile"));
		data.put("post", db.CheckStrFieldValue(rs, "post"));
		data.put("address", db.CheckStrFieldValue(rs, "address"));
		data.put("passport", db.CheckStrFieldValue(rs, "passport"));
		data.put("single", db.CheckStrFieldValue(rs, "single"));
		data.put("sex", rs.getInt("sex"));
		data.put("military", rs.getInt("military"));
		data.put("education", rs.getInt("education"));
		return data;
	}
	
//	public JSONObject CompanytoJson(java.sql.ResultSet rs) throws Exception{
//		DataBase db = new DataBase();
//		JSONObject row = new JSONObject();
//		row.put("id", rs.getInt("ID"));
//		row.put("name", db.CheckStrFieldValue(rs, "Name"));
//		row.put("bdate", db.CheckStrFieldValue(rs, "BDate"));
//		row.put("edate", db.CheckStrFieldValue(rs, "EDate"));
//		row.put("lastnwdate", db.CheckStrFieldValue(rs, "LastNwDate"));
//		row.put("sabtdate", db.CheckStrFieldValue(rs, "SabtDate"));
//		row.put("bimeshobe", db.CheckStrFieldValue(rs, "BimeShobe"));
//		row.put("tax", db.CheckStrFieldValue(rs, "Tax"));
//		row.put("fax", db.CheckStrFieldValue(rs, "Fax"));
//		row.put("tel", db.CheckStrFieldValue(rs, "Tel"));
//		row.put("email", db.CheckStrFieldValue(rs, "Email"));
//		row.put("note", db.CheckStrFieldValue(rs, "Note"));
//		row.put("post", db.CheckStrFieldValue(rs, "Post"));
//		row.put("address", db.CheckStrFieldValue(rs, "Address"));
//		row.put("active", rs.getInt("Active"));
//		row.put("sabt", rs.getInt("Sabt"));
//		row.put("sabtsazman", rs.getInt("SabtSazman"));
//		row.put("lastnwid", db.CheckStrFieldValue(rs, "LastNwID"));
//		row.put("ecoid", rs.getInt("EcoID"));
//		row.put("bimeid", rs.getLong("BimeID"));
//		row.put("nationalid", rs.getInt("NationalID"));
//		row.put("taxid", rs.getInt("TaxID"));
//		row.put("Pricekind", rs.getInt("PriceKind"));
//		return row;
//	}
	public String ResultsetToJson(java.sql.ResultSet rs) throws Exception{
		DataBase db = new DataBase();
		JSONObject obj = new JSONObject();
		ResultSetMetaData rsmd = rs.getMetaData();
		for (int i=1;i<=rsmd.getColumnCount();i++) {
			String column_name = rsmd.getColumnName(i);
			if(rsmd.getColumnType(i)==java.sql.Types.ARRAY){
	         obj.put(column_name.toLowerCase(), rs.getArray(column_name));
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.BIGINT){
	         obj.put(column_name.toLowerCase(), rs.getInt(column_name));
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.BOOLEAN){
	         obj.put(column_name.toLowerCase(), rs.getBoolean(column_name));
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.BLOB){
	         obj.put(column_name.toLowerCase(), rs.getBlob(column_name));
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.DOUBLE){
	         obj.put(column_name.toLowerCase(), rs.getDouble(column_name)); 
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.FLOAT){
	         obj.put(column_name.toLowerCase(), rs.getFloat(column_name));
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.INTEGER){
	         obj.put(column_name.toLowerCase(), rs.getInt(column_name));
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.NVARCHAR){
	         obj.put(column_name.toLowerCase(), db.CheckStrFieldValue(rs, column_name));
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.VARCHAR){
	         obj.put(column_name.toLowerCase(), db.CheckStrFieldValue(rs, column_name));
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.TINYINT){
	         obj.put(column_name.toLowerCase(), rs.getInt(column_name));
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.SMALLINT){
	         obj.put(column_name.toLowerCase(), rs.getInt(column_name));
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.DATE){
	         obj.put(column_name.toLowerCase(), rs.getDate(column_name));
	        }
	        else if(rsmd.getColumnType(i)==java.sql.Types.TIMESTAMP){
	        obj.put(column_name.toLowerCase(), rs.getTimestamp(column_name));   
	        }
	        else{
	         obj.put(column_name.toLowerCase(), rs.getObject(column_name));
	        }		
		}
		return obj.toString();
	}
}

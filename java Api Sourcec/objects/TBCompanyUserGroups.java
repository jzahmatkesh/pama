package objects;

public class TBCompanyUserGroups {
	private int userid;
	private int grpid;
	private int active;
	private String grpname;
	private String token;
	
	public int getUserid() {
		return userid;
	}
	public void setUserid(int userid) {
		this.userid = userid;
	}
	public int getGrpid() {
		return grpid;
	}
	public void setGrpid(int grpid) {
		this.grpid = grpid;
	}
	public int getActive() {
		return active;
	}
	public void setActive(int active) {
		this.active = active;
	}
	public String getGrpname() {
		return grpname;
	}
	public void setGrpname(String grpname) {
		this.grpname = grpname;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
	
}

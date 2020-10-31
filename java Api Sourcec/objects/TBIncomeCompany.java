package objects;

public class TBIncomeCompany{
    private int incid;
    private int cmpid;
    private int old;
    private String cmpname;
    private int allraste;
    private String token;
 
 
    public int getIncid(){
        return incid;
    }
    public void setIncid(int incid){
        this.incid = incid;
    }
    public int getCmpid(){
        return cmpid;
    }
    public void setCmpid(int cmpid){
        this.cmpid = cmpid;
    }
    public String getCmpname(){
        return cmpname;
    }
    public void setCmpname(String cmpname){
        this.cmpname = cmpname;
    }
    public int getAllraste(){
        return allraste;
    }
    public void setAllraste(int allraste){
        this.allraste = allraste;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
	public int getOld() {
		return old;
	}
	public void setOld(int old) {
		this.old = old;
	}
}
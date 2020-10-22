package objects;

public class TBInspection_Company{
    private int insid;
    private int cmpid;
    private String note;
    private String token;
 
 
    public int getInsid(){
        return insid;
    }
    public void setInsid(int insid){
        this.insid = insid;
    }
    public int getCmpid(){
        return cmpid;
    }
    public void setCmpid(int cmpid){
        this.cmpid = cmpid;
    }
    public String getNote(){
        return note;
    }
    public void setNote(String note){
        this.note = note;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
}
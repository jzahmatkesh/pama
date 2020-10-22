package objects;

public class TBInspection_Gov{
    private int insid;
    private int govid;
    private String note;
    private String token;
 
 
    public int getInsid(){
        return insid;
    }
    public void setInsid(int insid){
        this.insid = insid;
    }
    public int getGovid(){
        return govid;
    }
    public void setGovid(int govid){
        this.govid = govid;
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
package objects;

public class TBInspection_Company_Peop{
    private int insid;
    private int cmpid;
    private int peopid;
    private int kind;
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
    public int getPeopid(){
        return peopid;
    }
    public void setPeopid(int peopid){
        this.peopid = peopid;
    }
    public int getKind(){
        return kind;
    }
    public void setKind(int kind){
        this.kind = kind;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
}
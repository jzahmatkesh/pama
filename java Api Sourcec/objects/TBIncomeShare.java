package objects;

public class TBIncomeShare{
    private int incid;
    private int id;
    private String name;
    private int perc;
    private String token;
 
 
    public int getIncid(){
        return incid;
    }
    public void setIncid(int incid){
        this.incid = incid;
    }
    public int getId(){
        return id;
    }
    public void setId(int id){
        this.id = id;
    }
    public String getName(){
        return name;
    }
    public void setName(String name){
        this.name = name;
    }
    public int getPerc(){
        return perc;
    }
    public void setPerc(int perc){
        this.perc = perc;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
}
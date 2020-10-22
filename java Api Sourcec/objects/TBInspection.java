package objects;

public class TBInspection{
    private int cmpid;
    private int id;
    private String name;
    private String topic;
    private String bdate;
    private String edate;
    private String range;
    private String note;
    private String token;
 
 
    public int getCmpid(){
        return cmpid;
    }
    public void setCmpid(int cmpid){
        this.cmpid = cmpid;
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
    public String getTopic(){
        return topic;
    }
    public void setTopic(String topic){
        this.topic = topic;
    }
    public String getBdate(){
        return bdate;
    }
    public void setBdate(String bdate){
        this.bdate = bdate;
    }
    public String getRange(){
        return range;
    }
    public void setRange(String range){
        this.range = range;
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
	public String getEdate() {
		return edate;
	}
	public void setEdate(String edate) {
		this.edate = edate;
	}
}
package objects;

public class TBIncome{
    private int id;
    private String name;
    private int active;
    private int epay;
    private int refund;
    private int off;
    private int allcmp;
    private String token;
 
 
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
    public int getActive(){
        return active;
    }
    public void setActive(int active){
        this.active = active;
    }
    public int getEpay(){
        return epay;
    }
    public void setEpay(int epay){
        this.epay = epay;
    }
    public int getRefund(){
        return refund;
    }
    public void setRefund(int refund){
        this.refund = refund;
    }
    public int getOff(){
        return off;
    }
    public void setOff(int off){
        this.off = off;
    }
    public int getAllcmp(){
        return allcmp;
    }
    public void setAllcmp(int allcmp){
        this.allcmp = allcmp;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
}
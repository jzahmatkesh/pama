package objects;

public class TBIncomePriceHistory{
    private int incid;
    private int id;
    private String date;
    private double price;
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
    public String getDate(){
        return date;
    }
    public void setDate(String date){
        this.date = date;
    }
    public double getPrice(){
        return price;
    }
    public void setPrice(double price){
        this.price = price;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
}
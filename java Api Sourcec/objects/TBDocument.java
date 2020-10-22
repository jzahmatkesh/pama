package objects;

public class TBDocument {
	private int id;
	private String name;
	private int expdate;
	private String token;

	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getexpdate() {
		return expdate;
	}
	public void setexpdate(int expdate) {
		this.expdate = expdate;
	}

}

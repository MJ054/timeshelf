package user;

public class Schedule {
	
	
	private String name_schedule;
	private String deadline;
	private Double ex_time;
	private String memo;
	private int num_schedule;
	private int improtance;
	private int overtime;
	
	public String getName_schedule() {
		return name_schedule;
	}
	public void setName_schedule(String name_schedule) {
		this.name_schedule = name_schedule;
	}
	public String getDeadline() {
		return deadline;
	}
	public void setDeadline(String deadline) {
		this.deadline = deadline;
	}
	public Double getEx_time() {
		return ex_time;
	}
	public void setEx_time(Double ex_time) {
		this.ex_time = ex_time;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public int getnum_schedule() {
		return num_schedule;
	}
	public void setnum_schedule(int num_schedule) {
		this.num_schedule = num_schedule;
	}
	
	public int getimprotance() {
		return improtance;
	}
	public void setimprotance(int improtance) {
		this.improtance = improtance;
	}
	
	public void setOvertime(int overtime) {
		this.overtime = overtime;
	}
	public int getOvertime() {
		return overtime;
	}
	
}

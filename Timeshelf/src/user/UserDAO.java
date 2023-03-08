package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Date;

public class UserDAO {
 
	public Connection conn;
	public PreparedStatement pstmt;
	public ResultSet rs;
	public boolean idCheck = false;
	
	public UserDAO() { //실제 DB에 접근해서 데이터를 가져오거나 데이터를 넣는 역할을 하는
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBSS";
			String dbID = "root";
			String dbPassword = "1234"; //비밀번호 넣는곳
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL,dbID,dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	 /** 민지 **/

	public int registerCheck(String userID) { //회원가입 체크
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM client_list WHERE userid= ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID); 
			rs = pstmt.executeQuery(); 
			if(rs.next() || userID.equals("")) {
				return 0; //이미 존재 회원
			}
			else {
				return 1; //가입가능한 회원 아이디
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs !=null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데베 오류
	}
	
	public int login(String userID,String userPassword) { //로그인
		String SQL = "SELECT pw FROM client_list WHERE userid = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID); //첫번째 물음표 값 지정
			rs = pstmt.executeQuery(); //쿼리 실행
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword)) {
					return 1; //로그인 성공
				}
				else 
					return 0 ; // 비밀번호 불일치
			}
			return -1; //아이디가 없음
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -2;
	}
	
	
	public int join(User user) {  //회원가입
		String SQL = "INSERT INTO client_list VALUES(?,?,?,?)";
		String SQL2 = "INSERT INTO mypage VALUES(?,?,?,?,?,?)";

		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserName());
			pstmt.setString(2, user.getUserID());
			pstmt.setString(3, user.getUserPassword());
			pstmt.setString(4, user.getUserEmail());
					
			pstmt.executeUpdate();
			
			pstmt = conn.prepareStatement(SQL2);			
			pstmt.setString(1, user.getUserID());
			pstmt.setDouble(2, 9);
	        pstmt.setDouble(3, 18);
	        pstmt.setDouble(4, 2);
	        pstmt.setDouble(5, 5);
	        pstmt.setString(6, " ");
			
			return pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류 , 아이디가 겹치거나(아이디는 PRI라서 같이 못들어감)
	}
	
	public int idcheck(String id) {
		String SQL = "SELECT userid FROM client_list";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				if(rs.getString("id").equals(id)) {
					return -1;
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return 0;
	}
	
	public String passwordcheck(String id) {
		String SQL = "SELECT pw FROM client_list WHERE userid=?";
		String password = null;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();			
			while(rs.next()) {
				password = rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return password;
	}
	
	public int passwordChange(String Cpassword ,String id) {
		String SQL = "UPDATE client_list SET pw = ? WHERE userid= ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, Cpassword);
			pstmt.setString(2, id);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}		
		return -1; // 오류남
	}
	
	public ArrayList<User> getList(String userID) {
		String SQL = "SELECT ClientName,email,pw FROM client_list  WHERE userid = ?";
		ArrayList<User> list = new ArrayList<User>();
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
	        rs = pstmt.executeQuery();
			while(rs.next()) {
				User user = new User();
				user.setUserName(rs.getString(1));			
				user.setUserEmail(rs.getString(2));
				user.setUserPassword(rs.getString(3));
				list.add(user);			
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	

	public int InSchedule(String NS, String Dead, int Im, Double ET, String memo, String id) { //addschedule 스케줄 저장
		String SQL = "INSERT INTO schedule VALUES(?,?,?,?,?,?,?,?,?)";
		
		try {
			pstmt = conn.prepareStatement(SQL);
			
			pstmt.setString(1, id);
			pstmt.setInt(2 , 0);
			pstmt.setString(3, NS);
			pstmt.setString(4, Dead);
			pstmt.setDouble(5, ET);
			pstmt.setDouble(6,  ET); //DT
			pstmt.setInt(7, Im);  
			pstmt.setString(8, memo);
			pstmt.setDouble(9, 0); 
				
								
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류 , 아이디가 겹치거나(아이디는 PRI라서 같이 못들어감)
	}
	
	public ArrayList<Schedule> findSchedule(String date,String id){  //month
		String SQL = "SELECT name_schedule, num_schedule FROM schedule  WHERE deadline = ? AND userid = ?";
		ArrayList<Schedule> list = new ArrayList<Schedule>();
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, date);
			pstmt.setString(2, id);
	        rs = pstmt.executeQuery();
			while(rs.next()) {		
				Schedule schedule = new Schedule();
				schedule.setName_schedule(rs.getString(1));
				schedule.setnum_schedule(rs.getInt(2));
				list.add(schedule);			
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return list;
		}
	
	public ArrayList<Schedule> findSchedule2(String num_schedule){   //month에서 스케줄 누를때 정보를 받아온다
		String SQL = "SELECT name_schedule, deadline, importance,ex_time, memo FROM schedule  WHERE num_schedule = ?";
		ArrayList<Schedule> list = new ArrayList<Schedule>();
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, num_schedule);
	        rs = pstmt.executeQuery();
			while(rs.next()) {		
				Schedule schedule = new Schedule();
				schedule.setName_schedule(rs.getString(1));
				schedule.setDeadline(rs.getString(2));
				schedule.setimprotance(rs.getInt(3));
				schedule.setEx_time(rs.getDouble(4));
				schedule.setMemo(rs.getString(5));
				list.add(schedule);			
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return list;
		}
	
	
	public ArrayList<Schedule> findToDoList(String date,String id){   //daily
		String SQL = "SELECT name_schedule, deadline, per_extime, memo,overtime FROM schedule_per_day, schedule WHERE schedule_per_day.num_schedule = schedule.num_schedule AND execute_day = ? AND schedule.userid=?";
		ArrayList<Schedule> list = new ArrayList<Schedule>();
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, date);
			pstmt.setString(2, id);
	        rs = pstmt.executeQuery();
			while(rs.next()) {			
				Schedule schedule = new Schedule();
				schedule.setName_schedule(rs.getString(1));
				schedule.setDeadline(rs.getString(2));
				schedule.setEx_time(rs.getDouble(3));
				schedule.setMemo(rs.getString(4));
				schedule.setOvertime(rs.getInt(5));
				list.add(schedule);				
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
    public int modifyschedule(String id, String name, String deadline, int importance, double ex_time, String memo, int num_schedule) { //스케줄 변경
        String SQL = "UPDATE schedule SET name_schedule=?, deadline = ?, importance = ?, ex_time = ?, memo = ? WHERE userid = ? AND num_schedule = ?";
        
        try {
           pstmt = conn.prepareStatement(SQL);
           pstmt.setString(1, name);
           pstmt.setString(2, deadline);
           pstmt.setInt(3, importance);
           pstmt.setDouble(4, ex_time);
           pstmt.setString(5, memo);
           pstmt.setString(6, id);
           pstmt.setInt(7, num_schedule);
           pstmt.executeUpdate();
           return 1;
        }catch(Exception e) {
           e.printStackTrace();
        }
        
        return -1;
     }
    
    
    
    
    /**혜원 **/
    
    
    
     public int modifytime(String id, String time_sleep, String sleep_ex) {
        String SQL = "UPDATE mypage SET time_sleep = ?, sleep_ex = ?  WHERE userid = ?";
        try {
           pstmt = conn.prepareStatement(SQL);
           pstmt.setString(1, time_sleep);
           pstmt.setString(2, sleep_ex);
           pstmt.setString(3, id);   
           pstmt.executeUpdate();
           return 1;
        }catch(Exception e) {
           e.printStackTrace();
        }
        return -1;
     }
     
     public int modifyorder(String id, String order) {
        String SQL = "UPDATE mypage SET time_order = ? WHERE userid = ?";
        try {
           pstmt = conn.prepareStatement(SQL);
           pstmt.setString(1, order);
           pstmt.setString(2, id);   
           pstmt.executeUpdate();
           return 1;
        }catch(Exception e) {
           e.printStackTrace();
        }
        return -1;
     }
     
       public int modifymaxtime(String id, String maxtime) {
            String SQL = "UPDATE mypage SET max_time = ? WHERE userid = ?";
            try {
               pstmt = conn.prepareStatement(SQL);
               pstmt.setString(1, maxtime);
               pstmt.setString(2, id);
               pstmt.executeUpdate();
               return 1;
            }catch(Exception e){
               e.printStackTrace();
            }
            return -1;
         }
         
         public int modifymintime(String id, String mintime) {
            String SQL = "UPDATE mypage SET min_time = ? WHERE userid = ?";
            try {
               pstmt = conn.prepareStatement(SQL);
               pstmt.setString(1, mintime);
               pstmt.setString(2, id);
               pstmt.executeUpdate();
               return 1;
            }catch(Exception e) {
               e.printStackTrace();
            }
            return -1;
         }
         			        
     public int delete_schedule(int num_schedule) {
        String SQL = "delete from schedule where num_schedule = ?;";
        try {
           pstmt = conn.prepareStatement(SQL);
           pstmt.setInt(1, num_schedule);
           pstmt.executeUpdate();
           return 1;
        }catch(Exception e) {
           e.printStackTrace();
        }      
        return -1; // 오류남
     }
     
     
     /** 세정 **/
    
     public int modifyemail(String id, String email) {
         String SQL = "UPDATE client_list SET email = ? WHERE userid = ?";
         try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, email);
            pstmt.setString(2, id);   
            pstmt.executeUpdate();
            return 1;
         }catch(Exception e) {
            e.printStackTrace();
         }
         return -1;
   }
   
    public String getemail(String id) {
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         String SQL = "SELECT email FROM client_list WHERE userid = ?";
         try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery(); 
            rs.next();
             return rs.getString("email");
            
            
         }catch(Exception e) {
            e.printStackTrace();
         }      
         return null; // 오류남
      }
    
    public int findScheduleByName(String id, String name) {
       String SQL = "SELECT num_schedule FROM schedule WHERE userid = ? and name_schedule = ?";
       
       try {
          pstmt = conn.prepareStatement(SQL);
          pstmt.setString(1, id);
          pstmt.setString(2, name);
          rs = pstmt.executeQuery();
          if(rs.next()) {
             return rs.getInt("num_schedule");
          }
       }catch(Exception e) {
          e.printStackTrace();
       }
       return -1;
    }
    
    public int modifymaxtime(String id, double maxtime) {
        String SQL = "UPDATE mypage SET max_time = ? WHERE userid = ?";
        try {
           pstmt = conn.prepareStatement(SQL);
           pstmt.setDouble(1, maxtime);
           pstmt.setString(2, id);
           pstmt.executeUpdate();
           return 1;
        }catch(Exception e){
           e.printStackTrace();
        }
        return -1;
     }
     
     public int modifymintime(String id, double mintime) {
        String SQL = "UPDATE mypage SET min_time = ? WHERE userid = ?";
        try {
           pstmt = conn.prepareStatement(SQL);
           pstmt.setDouble(1, mintime);
           pstmt.setString(2, id);
           pstmt.executeUpdate();
           return 1;
        }catch(Exception e) {
           e.printStackTrace();
        }
        return -1;
     }
     
     public int modifymemo(String id, String memo) {
        String SQL = "UPDATE mypage SET memo = ? WHERE userid = ?";
        try {
           pstmt = conn.prepareStatement(SQL);
           pstmt.setString(1, memo);
           pstmt.setString(2, id);
           pstmt.executeUpdate();
           return 1;
        }catch(Exception e) {
           e.printStackTrace();
        }
        return -1;
        
     }
     
     public int modifytime(String id, double start_t, double end_t) {
          String SQL = "UPDATE mypage SET start_t = ?, end_t = ?  WHERE userid = ?";
          try {
             pstmt = conn.prepareStatement(SQL);
             pstmt.setDouble(1, start_t);
             pstmt.setDouble(2, end_t);
             pstmt.setString(3, id);   
             pstmt.executeUpdate();
             return 1;
          }catch(Exception e) {
             e.printStackTrace();
          }
          return -1;
       }
	
}

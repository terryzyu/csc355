import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Scanner;
import java.util.StringTokenizer;

public class assignment6 {
	
	public static Connection connection() {
		try {
			//Loads drivers
			Class.forName("oracle.jdbc.driver.OracleDriver");

			//Connect to DePaul
			Connection conn = DriverManager.getConnection(
					"That Depaul server that's probably down by now", "USERNAME", "PASSWORD");
			
			return conn;
		} catch (Exception e) {
			System.out.println("Error in connection block:\n" + e);
			return null;
		}
	} //connection()
	
	
	public static Statement statement(Connection conn) {
		try {
			Statement state = conn.createStatement();
			return state;
		} catch (Exception e) {
			System.out.println("Error in statement block:\n" + e);
			return null;
		}
	} //statement()
	
	
	public static void createTable(Statement state) {
		String createPart = "create table part (p_partkey integer not null, p_name varchar(22) not null, p_mfgr varchar(6) not null, p_category varchar(7) not null, p_brand1 varchar(9) not null, p_color varchar(11) not null, p_type varchar(25) not null, p_size integer not null, p_container varchar(10) not null)";
		try { //create table
			state.executeUpdate(createPart);
			System.out.println("Created Part table Success");
		} catch (Exception e) {
			System.out.println("Create Part table failed:\n" + e);
		}
	}//createTable()
	
	
	public static void dropTable(Statement state) {
		String dropPart = "DROP TABLE part CASCADE CONSTRAINTS";
		try { //drop table
			state.executeUpdate(dropPart);
			System.out.println("Drop Part table Success");
		} catch (Exception e) {
			System.out.println("Drop Part table failed:\n" + e);
		}
	}//dropTable()
	
	
	public static void alterTable(Statement state) {
		String alter = "alter table part add primary key (p_partkey)";
		try { //altering table
			state.executeQuery(alter);
			System.out.println("Altered Part table success");
		} catch (Exception e) {
			System.out.println("Alter Part table failed:\n" + e);
		}
	}//alterTable()
	
	
	public static void populateTable(ArrayList<String> input, Connection conn) {
		try {
			int total = input.size();
			StringTokenizer str;
			String insertString = "INSERT INTO part VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement insertPart = conn.prepareStatement(insertString);
			
			for(int x = 0; x < total; x++) {
				str = new StringTokenizer(input.get(x), "|");
				while(str.hasMoreTokens()) {
					insertPart.setInt(1, Integer.parseInt((str.nextToken())));
					insertPart.setString(2, str.nextToken());
					insertPart.setString(3, str.nextToken());
					insertPart.setString(4, str.nextToken());
					insertPart.setString(5, str.nextToken());
					insertPart.setString(6, str.nextToken());
					insertPart.setString(7, str.nextToken());
					insertPart.setInt(8, Integer.parseInt((str.nextToken())));
					insertPart.setString(9, str.nextToken());
					insertPart.addBatch();
				}//while
			}//for
			
			insertPart.executeBatch();
			insertPart.close();
			System.out.println("Populate Table success");
			
		} catch (Exception e) {
			System.out.println("Error in populate table\n " + e);
		}
		
	} //populateTable()
	
	
	public static ArrayList<String> readInTable(){
		File file = new File("part.tbl"); //Finds tbl file. MUST BE IN ROOT PROJECT FOLDER 
		ArrayList<String> input = new ArrayList<String>(); //Stores all tbl information
		try {
			FileReader reader = new FileReader(file); 
			BufferedReader buff = new BufferedReader(reader);
			String s;
			
			while ((s = buff.readLine()) != null) //Reads in file line per line until end
				input.add(s); //Adds it to AL
			
			buff.close();
			return input;
		} catch (Exception e) {
			System.out.println("Error in readInTable: \n" + e);
			return null;
		}
	} //readInTable()
	
	
	public static void printTable(Statement state) {
		try {
			ResultSet result = state.executeQuery("SELECT * FROM Part"); 
		    while(result.next()) 
		    	System.out.println(result.getInt(1) + " " + result.getString(2) + " " + result.getString(3) + " " + result.getString(4) + " " + result.getString(5) + " " + result.getString(6) + " " + result.getString(7) + " " + result.getInt(8) + " " + result.getString(9));
		    result.close();
		}catch (Exception e) {
			System.out.println("Error in printTable: \n " + e);
		}
	} //printTable()
	
	
	public static void closeConnection(Connection conn) {
		try {
			conn.close();
		} catch (SQLException e) {
			System.out.println("Error in closeConnection: \n" + e);
		}
	} //closeConnection()
	
	
	public static void closeStatement(Statement state) {
		try {
			state.close();
		} catch (Exception e) {
			System.out.println("Error in closeStatement: \n" + e);
		}
	} //closeStatement()
	
	public static void timePopulating(Statement state, ArrayList<String> input, Connection conn) { //Question 1.A
		long startTime, endTime;
		for(int x = 0; x < 3; x++) {
			startTime = System.currentTimeMillis();
			dropTable(state);
			createTable(state);
			populateTable(input, conn);
			endTime = System.currentTimeMillis();
			System.out.println("Time elapsed in ms: " + (endTime - startTime));
		}
	} //timePopulating()
	
	
	public static void deleteRandom(Statement state) { //Question 1.B
		//This will delete unique random numbers (entries) (sounds odd right?)
		
		String countQuery = "SELECT COUNT(*) FROM part";
		int rowCount; //Stores row count
		
		try { //Gets total number of rows in table
			ResultSet result = state.executeQuery(countQuery);
			result.next();
			rowCount = result.getInt(1);
		} catch (SQLException e) {
			System.out.println("Error in getting row count in deleteRandom: \n" + e);
			return;
		}
		
		if(rowCount < 20) {
			System.out.println("There are too few rows to delete 20 i.e. less than 20 rows in table\nNot completing block");
			return;
		}
		
		ArrayList<Integer> generator = new ArrayList<Integer>(); //Generates an AL storing ints between 0-rowCount
		
		for(int x = 0; x < rowCount; x++)
			generator.add(x); //Populates the list from 0 - rowCount
		
		Collections.shuffle(generator); //Randomizes AL
		
		try { //Performs deletion
			for(int x = 0; x < 20; x++) 
				state.executeQuery("DELETE FROM PART WHERE p_partKey = '" + generator.get(x) + "'");
		} catch (SQLException e) {
			System.out.println("Error in deleting random rows in deleteRandom \n" + e);
			return;
		}
		
	} //deleteRandom()
	
	
	public static void userInput(Statement state) { //Question 1.C
		Scanner kb = new Scanner(System.in);
		System.out.println("Enter a query. Hit enter to submit");
		String query = kb.nextLine();
		kb.close();
		
		long startTime, endTime;
		ResultSet result;
		ResultSetMetaData metaData;
		
		try {
			startTime = System.currentTimeMillis();
			result = state.executeQuery(query);
			endTime = System.currentTimeMillis();
			System.out.println("Time elapsed in ms: " + (endTime - startTime));
			
			metaData = result.getMetaData();
			int columns = metaData.getColumnCount();
			
			while(result.next()) {
				for(int x = 1; x <= columns; x++) {
					if(x > 1)
						System.out.print(", ");
					System.out.print(result.getString(x) + " " + metaData.getColumnName(x));
				} //for
				System.out.println();
			} //while
		    result.close();
		} catch (SQLException e) {
			System.out.println("Error in attempting user input query in userInput: \n" + e);
		}
	} //userInput()
	
	public static void main(String args[]) {
		Connection conn = connection(); //Creates connection to DePaul's database
		Statement state = statement(conn); //Creates statement object
		ArrayList<String> input = readInTable(); //Stores all table information
		dropTable(state); //Drops table
		createTable(state); //Creates table
		populateTable(input, conn); //Populates table with ALL 200,000 ENTRIES
		//deleteRandom(state); //Deletes 20 random entries. Will only work if there's at least 20 entries otherwise no deletion will occur
		//userInput(state); //Takes a SQL query and executes it
		//timePopulating(state, input, conn); //Uncomment to time populating 200,000 entries three times
		//printTable(state); //Uncomment to print all data
		closeStatement(state);
		closeConnection(conn); //Closes connection
		
		try {//Verify connection is closed
			System.out.println("Statement is closed: " + state.isClosed());
			System.out.println("Connection is closed: " + conn.isClosed());
		} catch (SQLException e) {
			System.out.println("Failed in checking if things are closed: \n" + e);
		}
	} //main()
	
} //class
/**
 * 
 */
package TestPaket;

import java.sql.*;
import SQLite.*;;

/**
 * @author Tim
 *
 */
public class TestKlasse {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println("Hallo Welt!");


		Connection conn = null;
		SQLite.Database db = null;
		try {
			Class.forName("SQLite.JDBCDriver").newInstance();
			conn = DriverManager.getConnection("jdbc:sqlite://home/enko/test.db");
			java.lang.reflect.Method m =
				conn.getClass().getMethod("getSQLiteDatabase", null);
			db = (SQLite.Database) m.invoke(conn, null);
			System.out.println(db.dbversion());
			Statement stmt = conn.createStatement();
			ResultSet srs = stmt.executeQuery("CREATE TABLE test(foo integer);");
		} catch (java.lang.Exception e) {
			System.out.println(e.getMessage());
		}


	}

}

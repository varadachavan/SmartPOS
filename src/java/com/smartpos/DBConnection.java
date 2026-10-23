package com.smartpos;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Apne MySQL ka password yahan sahi se daal dein agar alag ho
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartpos_db", "root", "Baba@2218#");
            System.out.println("Database Connected Successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}
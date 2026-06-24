package com.fashionstore.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Database connection details determined dynamically
    private static final String dbUrl;
    private static final String dbUser;
    private static final String dbPassword;
    
    static {
        // Read environment variables for cloud deployment (e.g. Render/Railway)
        String envHost = System.getenv("MYSQLHOST");
        if (envHost == null) envHost = System.getenv("DB_HOST");
        
        String envPort = System.getenv("MYSQLPORT");
        if (envPort == null) envPort = System.getenv("DB_PORT");
        if (envPort == null) envPort = "3306";
        
        String envUser = System.getenv("MYSQLUSER");
        if (envUser == null) envUser = System.getenv("DB_USER");
        
        String envPassword = System.getenv("MYSQLPASSWORD");
        if (envPassword == null) envPassword = System.getenv("DB_PASSWORD");
        
        String envDb = System.getenv("MYSQLDATABASE");
        if (envDb == null) envDb = System.getenv("DB_NAME");
        if (envDb == null) envDb = "fashionstore";
        
        if (envHost != null && envUser != null) {
            dbUrl = "jdbc:mysql://" + envHost + ":" + envPort + "/" + envDb + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            dbUser = envUser;
            dbPassword = envPassword != null ? envPassword : "";
        } else {
            // Local fallback
            dbUrl = "jdbc:mysql://localhost:3306/fashionstore?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            dbUser = "root";
            dbPassword = "root";
        }
    }
    
    // Singleton instance
    private static DBConnection instance;
    
    private DBConnection() {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found.");
            e.printStackTrace();
        }
    }
    
    // Thread-safe Singleton
    public static DBConnection getInstance() {
        if (instance == null) {
            synchronized (DBConnection.class) {
                if (instance == null) {
                    instance = new DBConnection();
                }
            }
        }
        return instance;
    }
    
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }
}

package com.fashionstore.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {
    // Database connection datasource managed by HikariCP connection pool
    private static final HikariDataSource dataSource;
    
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
        
        String jdbcUrl;
        String username;
        String password;
        
        if (envHost != null && envUser != null) {
            boolean useSSL = envHost.endsWith(".aivencloud.com") || "true".equalsIgnoreCase(System.getenv("DB_SSL"));
            jdbcUrl = "jdbc:mysql://" + envHost + ":" + envPort + "/" + envDb + "?useSSL=" + useSSL + "&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            username = envUser;
            password = envPassword != null ? envPassword : "";
        } else {
            // Local fallback
            jdbcUrl = "jdbc:mysql://localhost:3306/fashionstore?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            username = "root";
            password = "root";
        }
        
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(username);
        config.setPassword(password);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        
        // Optimize Connection Pool Settings for Render Free Tier / Aiven
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setIdleTimeout(30000);
        config.setConnectionTimeout(20000);
        config.setMaxLifetime(1800000);
        
        dataSource = new HikariDataSource(config);
    }
    
    // Singleton instance
    private static DBConnection instance;
    
    private DBConnection() {}
    
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
        return dataSource.getConnection();
    }
}

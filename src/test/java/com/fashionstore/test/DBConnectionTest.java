package com.fashionstore.test;

import com.fashionstore.util.DBConnection;
import org.junit.jupiter.api.Test;
import java.sql.Connection;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

public class DBConnectionTest {

    @Test
    public void testDatabaseConnection() {
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            assertNotNull(conn, "Database connection should not be null");
            assertFalse(conn.isClosed(), "Database connection should be open");
            System.out.println("Successfully connected to the fashionstore database!");
        } catch (SQLException e) {
            fail("SQLException thrown during connection: " + e.getMessage());
        }
    }
}

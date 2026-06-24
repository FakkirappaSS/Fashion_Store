package com.fashionstore.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    
    /**
     * Hash a plaintext password using BCrypt.
     * @param plainTextPassword The raw password
     * @return The hashed password
     */
    public static String hashPassword(String plainTextPassword) {
        // 12 is a good balance between security and performance
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(12));
    }
    
    /**
     * Check a plaintext password against a stored hash.
     * @param plainTextPassword The raw password
     * @param hashedPassword The stored BCrypt hash
     * @return true if matches, false otherwise
     */
    public static boolean checkPassword(String plainTextPassword, String hashedPassword) {
        if (hashedPassword == null || !hashedPassword.startsWith("$2a$")) {
            return false;
        }
        return BCrypt.checkpw(plainTextPassword, hashedPassword);
    }
}

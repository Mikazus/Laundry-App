package com.laundry.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Kelas untuk mengelola koneksi ke SQL Server.
 *
 * CARA KONFIGURASI:
 * Ubah nilai DB_SERVER, DB_NAME, DB_USER, DB_PASSWORD
 * sesuai konfigurasi SQL Server lokal Anda.
 *
 * Untuk Windows Authentication (tanpa username/password):
 * Ganti URL menjadi:
 *   jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=LaundryDB;integratedSecurity=true;
 * Dan copy sqljdbc_auth.dll ke System32 (lihat README.md)
 */
public class DBConnection {

    // ─── KONFIGURASI — SESUAIKAN DI SINI ───────────────────────────
    private static final String DB_SERVER   = "localhost";
    private static final String DB_NAME     = "PAIS_LAUNDRY";
    private static final String DB_USER     = "paislaundry";
    private static final String DB_PASSWORD = "pais123";
    private static final int    DB_PORT     = 1433;
    // ────────────────────────────────────────────────────────────────

    private static final String URL =
        "jdbc:sqlserver://" + DB_SERVER + ":" + DB_PORT + ";" +
        "databaseName=" + DB_NAME + ";" +
        "encrypt=false;" +
        "trustServerCertificate=true;";

    private static Connection connection = null;

    /**
     * Mengembalikan koneksi singleton ke database.
     */
    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                connection = DriverManager.getConnection(URL, DB_USER, DB_PASSWORD);
                System.out.println("[DB] Koneksi berhasil ke " + DB_NAME);
            } catch (ClassNotFoundException e) {
                throw new SQLException("Driver JDBC SQL Server tidak ditemukan. " +
                    "Pastikan mssql-jdbc sudah ditambahkan ke pom.xml.", e);
            }
        }
        return connection;
    }

    /**
     * Menutup koneksi database.
     */
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("[DB] Koneksi ditutup.");
            }
        } catch (SQLException e) {
            System.err.println("[DB] Gagal menutup koneksi: " + e.getMessage());
        }
    }

    /**
     * Test koneksi — jalankan method ini untuk memverifikasi koneksi.
     */
    public static void testConnection() {
        try {
            Connection conn = getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("[DB] ✓ Koneksi BERHASIL ke " + DB_NAME);
            }
        } catch (SQLException e) {
            System.err.println("[DB] ✗ Koneksi GAGAL: " + e.getMessage());
            System.err.println("[DB] Periksa konfigurasi di DBConnection.java");
        }
    }
}

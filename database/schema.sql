-- ============================================================
--  LAUNDRY APP - Database Schema
--  SQL Server (SSMS)
--  Mata Kuliah: Basis Data
--  Universitas Brawijaya - Teknik Informatika
-- ============================================================

-- Buat database baru
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'LaundryDB')
BEGIN
    CREATE DATABASE LaundryDB;
END
GO

USE LaundryDB;
GO

-- ============================================================
-- TABLE: Pelanggan
-- ============================================================
IF OBJECT_ID('dbo.Pelanggan', 'U') IS NOT NULL DROP TABLE dbo.Pelanggan;
CREATE TABLE Pelanggan (
    id_pelanggan    INT IDENTITY(1,1) PRIMARY KEY,
    nama            NVARCHAR(100)   NOT NULL,
    no_telp         NVARCHAR(20)    NOT NULL,
    alamat          NVARCHAR(255),
    email           NVARCHAR(100),
    created_at      DATETIME        DEFAULT GETDATE()
);
GO

-- ============================================================
-- TABLE: Layanan
-- ============================================================
IF OBJECT_ID('dbo.Layanan', 'U') IS NOT NULL DROP TABLE dbo.Layanan;
CREATE TABLE Layanan (
    id_layanan      INT IDENTITY(1,1) PRIMARY KEY,
    nama_layanan    NVARCHAR(100)   NOT NULL,
    harga_per_kg    DECIMAL(10, 2)  NOT NULL,
    estimasi_hari   INT             NOT NULL DEFAULT 2,
    deskripsi       NVARCHAR(255)
);
GO

-- ============================================================
-- TABLE: Karyawan
-- ============================================================
IF OBJECT_ID('dbo.Karyawan', 'U') IS NOT NULL DROP TABLE dbo.Karyawan;
CREATE TABLE Karyawan (
    id_karyawan     INT IDENTITY(1,1) PRIMARY KEY,
    nama            NVARCHAR(100)   NOT NULL,
    jabatan         NVARCHAR(50)    NOT NULL,
    no_telp         NVARCHAR(20),
    username        NVARCHAR(50)    UNIQUE NOT NULL,
    password        NVARCHAR(255)   NOT NULL  -- Hash password di production
);
GO

-- ============================================================
-- TABLE: Transaksi
-- ============================================================
IF OBJECT_ID('dbo.Transaksi', 'U') IS NOT NULL DROP TABLE dbo.Transaksi;
CREATE TABLE Transaksi (
    id_transaksi    INT IDENTITY(1,1) PRIMARY KEY,
    id_pelanggan    INT             NOT NULL,
    id_karyawan     INT             NOT NULL,
    tanggal_masuk   DATETIME        DEFAULT GETDATE(),
    tanggal_selesai DATETIME,
    status          NVARCHAR(20)    DEFAULT 'Diterima'
                                    CHECK (status IN ('Diterima','Diproses','Selesai','Diambil')),
    total_bayar     DECIMAL(10, 2)  DEFAULT 0,
    catatan         NVARCHAR(255),

    CONSTRAINT FK_Transaksi_Pelanggan FOREIGN KEY (id_pelanggan)
        REFERENCES Pelanggan(id_pelanggan),
    CONSTRAINT FK_Transaksi_Karyawan  FOREIGN KEY (id_karyawan)
        REFERENCES Karyawan(id_karyawan)
);
GO

-- ============================================================
-- TABLE: Detail_Transaksi
-- ============================================================
IF OBJECT_ID('dbo.Detail_Transaksi', 'U') IS NOT NULL DROP TABLE dbo.Detail_Transaksi;
CREATE TABLE Detail_Transaksi (
    id_detail       INT IDENTITY(1,1) PRIMARY KEY,
    id_transaksi    INT             NOT NULL,
    id_layanan      INT             NOT NULL,
    berat_kg        DECIMAL(5, 2)   NOT NULL,
    subtotal        DECIMAL(10, 2)  NOT NULL,

    CONSTRAINT FK_Detail_Transaksi  FOREIGN KEY (id_transaksi)
        REFERENCES Transaksi(id_transaksi) ON DELETE CASCADE,
    CONSTRAINT FK_Detail_Layanan    FOREIGN KEY (id_layanan)
        REFERENCES Layanan(id_layanan)
);
GO

-- ============================================================
-- DATA AWAL (Seed Data)
-- ============================================================

-- Layanan
INSERT INTO Layanan (nama_layanan, harga_per_kg, estimasi_hari, deskripsi) VALUES
('Cuci Regular',    5000.00,  3, 'Cuci dan jemur biasa'),
('Cuci Express',    10000.00, 1, 'Selesai dalam 1 hari'),
('Cuci + Setrika',  8000.00,  3, 'Cuci, jemur, dan setrika'),
('Dry Cleaning',    20000.00, 4, 'Untuk pakaian khusus'),
('Setrika Saja',    3000.00,  1, 'Layanan setrika saja');
GO

-- Karyawan (password: "admin123" — ganti dengan hash di production)
INSERT INTO Karyawan (nama, jabatan, no_telp, username, password) VALUES
('Admin Utama',  'Admin',    '081234567890', 'admin',  'admin123'),
('Budi Santoso', 'Kasir',    '082345678901', 'budi',   'budi123'),
('Siti Rahayu',  'Operator', '083456789012', 'siti',   'siti123');
GO

-- Contoh Pelanggan
INSERT INTO Pelanggan (nama, no_telp, alamat, email) VALUES
('Andi Wijaya',     '08111111111', 'Jl. Mawar No. 1',  'andi@email.com'),
('Budi Hartono',    '08222222222', 'Jl. Melati No. 5', 'budi.h@email.com'),
('Citra Dewi',      '08333333333', 'Jl. Kenanga No. 3','citra@email.com');
GO

-- ============================================================
-- STORED PROCEDURES
-- ============================================================

-- SP: Hitung Total Transaksi
CREATE OR ALTER PROCEDURE sp_HitungTotal
    @id_transaksi INT
AS
BEGIN
    DECLARE @total DECIMAL(10,2);
    SELECT @total = SUM(subtotal) FROM Detail_Transaksi WHERE id_transaksi = @id_transaksi;
    UPDATE Transaksi SET total_bayar = ISNULL(@total, 0) WHERE id_transaksi = @id_transaksi;
    SELECT @total AS total_bayar;
END;
GO

-- SP: Laporan Pendapatan Per Bulan
CREATE OR ALTER PROCEDURE sp_LaporanBulanan
    @tahun INT,
    @bulan INT
AS
BEGIN
    SELECT
        COUNT(*)                    AS jumlah_transaksi,
        SUM(total_bayar)            AS total_pendapatan,
        AVG(total_bayar)            AS rata_rata_transaksi
    FROM Transaksi
    WHERE YEAR(tanggal_masuk) = @tahun
      AND MONTH(tanggal_masuk) = @bulan
      AND status = 'Diambil';
END;
GO

-- ============================================================
-- VIEWS
-- ============================================================

CREATE OR ALTER VIEW vw_Transaksi_Lengkap AS
SELECT
    t.id_transaksi,
    p.nama          AS nama_pelanggan,
    p.no_telp,
    k.nama          AS nama_karyawan,
    t.tanggal_masuk,
    t.tanggal_selesai,
    t.status,
    t.total_bayar,
    t.catatan
FROM Transaksi t
JOIN Pelanggan p ON t.id_pelanggan = p.id_pelanggan
JOIN Karyawan  k ON t.id_karyawan  = k.id_karyawan;
GO

PRINT 'Database LaundryDB berhasil dibuat!';
GO

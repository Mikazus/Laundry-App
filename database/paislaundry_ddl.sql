CREATE DATABASE PAIS_LAUNDRY;
GO

USE PAIS_LAUNDRY;
GO

CREATE TABLE Customer (
	customerId INT PRIMARY KEY IDENTITY(101, 1),
	namaCustomer VARCHAR (50) NOT NULL,
	alamat VARCHAR (200) NOT NULL
);

CREATE TABLE Transaksi (
	kodeStruk VARCHAR(50) PRIMARY KEY,
	tanggalTerima DATETIME NOT NULL,
	tanggalAmbil DATETIME NOT NULL,
	customerId INT FOREIGN KEY REFERENCES Customer(customerId),
	total INT NOT NULL,
	pembayaran VARCHAR(10) NOT NULL,
	statusBayar VARCHAR(10) NOT NULL,
	namaKasir VARCHAR(50) NOT NULL
);

CREATE TABLE Layanan (
	namaLayanan VARCHAR(50) PRIMARY KEY,
	hargaPerKg INT NOT NULL
);

CREATE TABLE detailTransaksi (
	kodeStruk VARCHAR(50) FOREIGN KEY REFERENCES Transaksi(kodeStruk),
	namaLayanan VARCHAR(50) FOREIGN KEY REFERENCES Layanan(namaLayanan),
	berat FLOAT NOT NULL
);

INSERT INTO Layanan (namaLayanan, hargaPerKg)
VALUES
	-- Cuci Kering Strika Reguler
	('CKS Reguler 1 Hari',  10000),
	('CKS Reguler 2 Hari',   8000),
	('CKS Reguler 3 Hari',   7000),
	('CKS Reguler 3 Jam',   35000),
	('CKS Reguler 6 Jam',   20000),
	-- Cuci Kering Strika Premium
	('CKS Premium 1 Hari',  12000),
	('CKS Premium 2 Hari',  10000),
	('CKS Premium 3 Hari',   8000),
	('CKS Premium 3 Jam',   38000),
	('CKS Premium 6 Jam',   23000),
	-- Cuci Kering Lipat Reguler
	('CKL Reguler 1 Hari',   8000),
	('CKL Reguler 2 Hari',   7000),
	('CKL Reguler 3 Hari',   6000),
	('CKL Reguler 3 Jam',   25000),
	('CKL Reguler 6 Jam',   15000),
	-- Cuci Kering Lipat Premium
	('CKL Premium 1 Hari',  10000),
	('CKL Premium 2 Hari',   8000),
	('CKL Premium 3 Hari',   7000),
	('CKL Premium 3 Jam',   30000),
	('CKL Premium 6 Jam',   20000),
	-- Setrika Saja
	('SS 1 Hari',  8000),
	('SS 2 Hari',  7000),
	('SS 3 Hari',  6000),
	('SS 3 Jam',  25000),
	('SS 6 Jam',  15000);
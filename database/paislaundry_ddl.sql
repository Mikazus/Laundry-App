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
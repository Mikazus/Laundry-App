# ✅ Checklist Setup — Laundry App

---
## Setup SQL Server

- [ ] SQL Server service berstatus **Running**
- [ ] TCP/IP **diaktifkan** di SQL Server Configuration Manager
- [ ] TCP Port di-set ke **1433**
- [ ] Mode authentication: **SQL Server and Windows Authentication**
- [ ] User `sa` sudah di-**Enable** dan password sudah di-set
- [ ] Script `database/schema.sql` sudah dijalankan di SSMS
- [ ] Database **LaundryDB** muncul di Object Explorer

## Setup Java / IntelliJ

- [ ] JDK 17+ terinstall dan terdeteksi IntelliJ
- [ ] Project dibuka via **File → Open** (bukan New Project)
- [ ] Maven dependencies sudah ter-download (tidak ada error merah)
- [ ] `DBConnection.java` sudah dikonfigurasi dengan data lokal
- [ ] Test koneksi berhasil: `[DB] ✓ Koneksi BERHASIL ke LaundryDB`

## Setup GitHub

- [ ] Git terinstall (`git --version` di terminal)
- [ ] Repo sudah di-clone: `git clone <url>`
- [ ] Branch sudah dibuat: `git checkout -b fitur/nama-saya`



-- TOTAL JAM MENGAJAR GURU SELAMA SEMINGGU
CREATE VIEW 
	V_TotalJamMengajar 
AS
SELECT 
	g.NamaGuru ,m.NamaMapel , SUM(m.JamPerminggu) AS TotalJamMengajar
FROM 
	GURU g  
INNER JOIN 
	MENGAJAR m  
ON 
	m.KdGuru = g.KdGuru 
GROUP BY 
	g.NamaGuru , m.NamaMapel;


-- PERLOMBAAN YANG DIIKUTI OLEH SETIAP SISWA
CREATE VIEW 
	V_PerlombaanDiikutiSiswa 
AS
SELECT 
	s.Nama, p.Nama NamaLomba, p.Tahun
FROM 
	SISWA s 
JOIN 
	MENGIKUTI_LOMBA ml ON s.Nis  = ml.NisSiswa 
JOIN 
	PERLOMBAAN p ON ml.KdLomba = p.KdLomba;


-- ORGANISASI YANG DIIKUTI OLEH SETIAP SISWA
CREATE VIEW 
	V_OrganisasiDiikutiSiswa 
AS
SELECT 
	s.Nama NamaSiswa, o.Nama NamaOrganisasi, mo.Jabatan, o.ThKepengurusan Tahun 
FROM 
	SISWA s 
JOIN 
	MENGIKUTI_ORGANISASI mo 
ON 
	s.Nis  = mo.NisSiswa 
JOIN 
	ORGANISASI o 
ON 
	mo.KdOrganisasi = o.KdOrganisasi;

-- MASIH ERROR
--SELECT s.Nama, n.NamaMapel ,n.TugasKe ,n.Nilai, n2.UlanganKe , n2.Nilai 
--FROM NILAITUGAS n 
--JOIN SISWA s ON n.NisSiswa  = s.Nis  
--JOIN NILAIULANGAN n2 ON n2.NisSiswa  = s.Nis 
--WHERE n.TugasKe = n2.UlanganKe 
--ORDER BY n.NamaMapel ,n.TugasKe,n2.UlanganKe ASC;


--siswa yang keluar sebelum lulus
CREATE VIEW 
	V_SiswaKeluar
AS
SELECT 
	s.*, sk.TanggalKeluar 
FROM 
	SISWA s 
JOIN 
	SISWA_KELUAR sk 
ON
	sk.Nis = s.Nis;


-- Jumlah Siswa dari masing-masing Minat Bakat Akademik
-- MB Akademik
CREATE 	VIEW 
	V_JumlahSiswaMbAkademik
AS
SELECT 
	k.MbAkademik , COUNT(k.MbAkademik) AS JumlahSiswa
FROM 
	KONSULTASI k 
GROUP BY 
	k.MbAkademik;

-- MB Non Akademik
CREATE VIEW 
	V_JumlahSiswaMbNonAkademik
AS
SELECT 
	k.MbNonAkademik , COUNT(k.MbNonAkademik) AS JumlahSiswa
FROM 
	KONSULTASI k 
GROUP BY 
	k.MbNonAkademik;


-- List MB akademik dari siswa secara keseluruhan 
CREATE VIEW 
	V_MbAkademik
AS
SELECT 
	s.Nama , k.MbAkademik 
FROM 
	SISWA s 
JOIN 
	KONSULTASI k 
ON 
	s.Nis  = k.NisSiswa;
-- List MB Non Akademik dari siswa secara keseluruhan 
CREATE VIEW 
	V_MbNonAkademik
AS
SELECT 
	s.Nama , k.MbNonAkademik 
FROM 
	SISWA s 
JOIN 
	KONSULTASI k 
ON 
	s.Nis  = k.NisSiswa;


-- List MB akademik dari siswa [IPS]
--SELECT 
--	s.Nama , k.MbAkademik 
--FROM 
--	SISWA s 
--INNER JOIN 
--	KONSULTASI k 
--ON 
--	s.Nis  = k.NisSiswa 
--WHERE 
--	k.MbAkademik  
--LIKE 
--	'%IPS%'
--ORDER BY 
--	k.MbAkademik ,s.Nama ASC;

-- List MB Akademik dari siswa [MIPA]
CREATE VIEW 
	V_MbMipa
AS
SELECT 
	s.Nama 
FROM 
	SISWA s 
INNER JOIN 
	KONSULTASI k 
ON 
	s.Nis  = k.NisSiswa 
WHERE 
	k.MbAkademik  LIKE '%MIPA%';

-- Jumlah Kehadiran Siswa

--SELECT s.Nama, COUNT(p.Status) AS JumlahKehadiran
--FROM SISWA s INNER JOIN PRESENSI p  ON s.Nis  = p.NisSiswa 
--WHERE p.Status NOT LIKE '%H%'
--GROUP BY s.Nama 

-- Riwayat Belajar Dari Siswa
CREATE VIEW 
	V_RiwayatBelajar
AS
SELECT 
	s.Nis, s.Nama, k.Grade ,k.NamaKelas , k.TahunAjaran 
FROM 
	SISWA s 
JOIN 
	RIWAYAT_BELAJAR rb 
ON 
	s.Nis = rb.NisSiswa 
JOIN 
	KELAS k 
ON
	rb.KdKelas  = k.KdKelas;


-- Nilai Siswa Selama Satu Semester

--SELECT 
--	s.Nama, n.NamaMapel, n.TugasKe, n.Nilai , n2.UlanganKe , n2.Nilai 
--FROM NILAITUGAS n INNER JOIN SISWA s ON n.NisSiswa = s.Nis 
--INNER JOIN NILAIULANGAN n2 ON s.Nis = n2.NisSiswa;


--list nama siswa yang sudah lulus
CREATE  VIEW V_SiswaLulus
AS
SELECT 
	s.*, sl.TanggalLulus 
FROM 
	SISWA s 
JOIN 
	SISWA_LULUS sl 
ON s.Nis=sl.Nis ;


--Nilai tiap Siswa Selama satu semester pada setiap mapel
CREATE  VIEW 
	V_NilaiSiswa
AS
SELECT 
	s.Nama,k.Grade  ,g.NamaGuru ,m.NamaMapel,s2.SemesterKe ,k.NamaKelas, SUM(nt.Nilai)/COUNT(nt.nilai) NILAI_TUGAS , SUM(nu.Nilai)/COUNT(nu.Nilai) NILAI_ULANGAN, m.NilaiUts , m.NilaiUas 
FROM
	MENGAJAR m 
JOIN
	NILAITUGAS nt
ON
	m.NisSiswa =nt.NisSiswa AND
	m.KdGuru =nt.KdGuru AND
	m.KdKelas =nt.KdKelas AND
	m.NamaMapel =nt.NamaMapel 
JOIN 
	NILAIULANGAN nu
ON
	m.NisSiswa =nu.NisSiswa AND
	m.KdGuru =nu.KdGuru AND
	m.KdKelas =nu.KdKelas AND
	m.NamaMapel =nu.NamaMapel
JOIN 
	SISWA s
ON
	s.Nis=m.NisSiswa
JOIN 
	GURU g 
ON
	g.KdGuru=m.KdGuru 
JOIN 
	SEMESTER s2 
ON 
	s2.SemesterKe  = m.Semester 
JOIN 
	KELAS k
ON
	k.KdKelas = m.KdKelas 
GROUP BY 
	s.Nama ,g.NamaGuru ,m.NamaMapel,k.NamaKelas, m.NilaiUts , m.NilaiUas,s2.SemesterKe, k.Grade  ;

SELECT * from V_NilaiSiswa;

--absensi tiap siswa selama satu semester pada suatu mata pelajaran
CREATE VIEW 
	V_TotalMasuk
AS
SELECT 
	s.Nama ,s2.SemesterKe ,k.Grade  ,g.NamaGuru ,m.NamaMapel,k.NamaKelas, COUNT(p.NisSiswa) TotalMasuk
FROM
	MENGAJAR m 
JOIN
	PRESENSI p 
ON
	m.NisSiswa =p.NisSiswa AND
	m.KdGuru =p.KdGuru AND
	m.KdKelas =p.KdKelas AND
	m.NamaMapel =p.NamaMapel
JOIN 
	SISWA s
ON
	s.Nis=m.NisSiswa
JOIN 
	GURU g 
ON
	g.KdGuru=m.KdGuru 
JOIN 
	SEMESTER s2 
ON 
	s2.SemesterKe  = m.Semester 
JOIN 
	KELAS k
ON
	k.KdKelas = m.KdKelas 
WHERE 
	p.Status = 'H'
GROUP BY 
	s.Nama ,g.NamaGuru ,m.NamaMapel,k.NamaKelas,s2.SemesterKe ,k.Grade ;


-- ClimateDB t�bla l�trehoz�sa

CREATE TABLE "ClimateDB" (
	"USAF"	VARCHAR NOT NULL,
	"WBAN"	VARCHAR NOT NULL,
	"YRMODAHRMN"	VARCHAR NOT NULL,
	"DIR"	VARCHAR,
	"SPD"	INTEGER,
	"GUS"	INTEGER,
	"CLG"	INTEGER,
	"SKC"	VARCHAR,
	"L"	INTEGER,
	"M"	INTEGER,
	"H"	INTEGER,
	"VSB"	REAL,
	"MW1"	VARCHAR,
	"MW2"	VARCHAR,
	"MW3"	VARCHAR,
	"MW4"	VARCHAR,
	"AW1"	VARCHAR,
	"AW2"	VARCHAR,
	"AW3"	VARCHAR,
	"AW4"	VARCHAR,
	"W"	INTEGER,
	"TEMP"	INTEGER,
	"DEWP"	INTEGER,
	"SLP"	REAL,
	"ALT"	REAL,
	"STP"	REAL,
	"MAX"	INTEGER,
	"MIN"	INTEGER,
	"PCP01"	VARCHAR,
	"PCP06"	VARCHAR,
	"PCP24"	VARCHAR,
	"PCPXX"	VARCHAR,
	"SD"	INTEGER,
	CONSTRAINT "CLIMATE_PK" PRIMARY KEY("USAF","YRMODAHRMN")
);

-- Stations t�bla l�trehoz�sa

CREATE TABLE "STATIONS" (
	"USAF"	VARCHAR NOT NULL,
	"WBAN"	VARCHAR,
	"STATION_NAME"	VARCHAR,
	"COUNTRY"	VARCHAR,
	"LATITUDE"	VARCHAR,
	"LONGITUDE"	VARCHAR,
	"ELEVATION"	VARCHAR,
	PRIMARY KEY("USAF")
);

-- azon �llom�sok meghat�roz�sa, amelyek �tlagon fel�li adatmennyis�ggel rendelkeznek

select USAF
from ClimateDB
group by USAF
having count(*) >=
		(select avg(meresek)
		 from
			(select count(*) as meresek
			 from ClimateDB
			 group by USAF));

-- rossz h�m�rs�klet m�r�sek kijav�t�sa

update ClimateDB
set TEMP = NULL
where temp < -38 or temp > 113;

-- rossz sz�lsebess�g m�r�sek kijav�t�sa

update ClimateDB
set SPD = NULL
where DIR is NULL 
and SPD > 0;

-- rossz l�t�t�vols�g m�r�sek kijav�t�sa

update ClimateDB
set VSB = 10
where VSB > 10;

-- Cs�kszereda �venk�nti �tlagh�m�rs�klete

select substr(YRMODAHRMN,1,4) as year,
avg(TEMP) as avg_F, (avg(TEMP)-32)/1.8 as avg_C
from 
	(select YRMODAHRMN, avg(TEMP) as temp
	from 
		(select YRMODAHRMN, avg(TEMP) as temp
		from ClimateDB
		where USAF = 
			(select USAF
			from stations
			where STATION_NAME = 'MIERCUREA CIUC')
		group by substr(YRMODAHRMN,1,8)
		having count(TEMP) > 4)
	group by substr(YRMODAHRMN,1,6)
	having count(TEMP) > 4)
group by substr(YRMODAHRMN,1,4)
order by substr(YRMODAHRMN,1,4);

-- Cs�kszereda h�naponk�nti �tlagh�m�rs�klete

select substr(YRMODAHRMN,5,2) as month,
avg(TEMP) as avg_F, (avg(TEMP)-32)/1.8 as avg_C
from 
	(select YRMODAHRMN, avg(TEMP) as temp
	from 
		(select YRMODAHRMN, avg(TEMP) as temp
		from ClimateDB
		where USAF = 
			(select USAF
			from stations
			where STATION_NAME = 'MIERCUREA CIUC')
		group by substr(YRMODAHRMN,1,8)
		having count(TEMP) > 4)
	group by substr(YRMODAHRMN,1,6)
	having count(TEMP) > 4)
group by substr(YRMODAHRMN,5,2)
order by substr(YRMODAHRMN,5,2);

-- Cs�kszereda �venk�nti �tlag sz�lsebess�ge

select substr(YRMODAHRMN,1,4) as year,
avg(SPD) as avg_M, avg(SPD)*1.609344 as avg_K
from 
	(select YRMODAHRMN, avg(SPD) as spd
	from 
		(select YRMODAHRMN, avg(SPD) as spd
		from ClimateDB
		where USAF = 
			(select USAF
			from stations
			where STATION_NAME = 'MIERCUREA CIUC')
		and DIR is not NULL
		group by substr(YRMODAHRMN,1,8)
		having count(SPD) > 4)
	group by substr(YRMODAHRMN,1,6)
	having count(SPD) > 4)
group by substr(YRMODAHRMN,1,4)
order by substr(YRMODAHRMN,1,4);

-- Cs�kszereda h�naponk�nti �tlag sz�lsebess�ge

select substr(YRMODAHRMN,5,2) as month,
avg(SPD) as avg_M, avg(spd)*1.609344 as avg_K
from 
	(select YRMODAHRMN, avg(SPD) as spd
	from 
		(select YRMODAHRMN, avg(SPD) as spd
		from ClimateDB
		where USAF = 
			(select USAF
			from stations
			where STATION_NAME = 'MIERCUREA CIUC')
		and DIR is not NULL
		group by substr(YRMODAHRMN,1,8)
		having count(SPD) > 4)
	group by substr(YRMODAHRMN,1,6)
	having count(SPD) > 4)
group by substr(YRMODAHRMN,5,2)
order by substr(YRMODAHRMN,5,2);

-- Cs�kszereda k�d�s napjai 

select substr(YRMODAHRMN,5,2) as month, sum(kod) as kod
from 
	(select YRMODAHRMN, count(*) as kod
	from 
		(select YRMODAHRMN
		from ClimateDB
		where USAF = 
			(select USAF
			from STATIONS
			where STATION_NAME = 'MIERCUREA CIUC')
		and (MW1 between 40 and 49
		or MW1 = 11
		or MW1 = 12
		or MW1 = 28
		or AW1 between 40 and 49
		or AW1 = 11
		or AW1 = 12
		or AW1 = 28
		or W = 4)
		group by substr(YRMODAHRMN,1,8))
	group by substr(YRMODAHRMN,1,6))
group by substr(YRMODAHRMN,5,2)
order by substr(YRMODAHRMN,5,2);

-- �tlag l�t�t�vols�g Cs�kszered�ban h�napokra bontva

select substr(datum,5,2) as honap, avg(avg_vsb) as avg_vsb
from 
	(select substr(YRMODAHRMN,1,8) as datum, avg(VSB) as avg_vsb
	 from ClimateDB
	 where USAF =
		 (select USAF
		  from STATIONS
		  where STATION_NAME = 'MIERCUREA CIUC')
	 group by substr(YRMODAHRMN,1,8))
group by substr(datum,5,2);

-- Cs�kszereda felh�zete h�napokra bontva

select substr(datum,5,2) as honap, SKC, count(*) as darab
from 
	(select substr(YRMODAHRMN,1,8) as datum, SKC
	 from ClimateDB
	 where USAF = 
		 	 (select USAF
			  from STATIONS
			  where STATION_NAME = 'MIERCUREA CIUC')
	 and SKC is not NULL
	 group by substr(YRMODAHRMN,1,8), SKC)
group by substr(datum,5,2), SKC;
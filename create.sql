--1. Creating Doctor Table.
CREATE TABLE Doctor(
	doctorID varchar NOT null Primary Key,
	doctorName varchar(255) NOT null,
	contact varchar(255) NOT null
);

--2. Creating Patient Table.
CREATE TABLE ALLPatient(
	patientID varchar NOT null Primary Key,
	patientName varchar(255) NOT null,
	contact varchar(255) NOT null,
	gender varchar(255) NOT null,
	emergency_contact varchar(255) Default null,
	emergency_contact_phone varchar(255) Default null,
	doctorID varchar NOT null REFERENCES Doctor(doctorID) ON DELETE CASCADE ON UPDATE CASCADE
);

--3. Creating Illness Table.
CREATE TABLE IllnessDrugPrescription(
	illnessCode varchar(255) NOT null Primary Key,
	description varchar NOT null,
	drugPrescribed varchar NOT null,
	drugManufacturer varchar NOT null
);

--4. Creating Lab Test Table.
CREATE TABLE LabTest(
	labtestID varchar NOT null Primary Key,
	testcode varchar,
	patientID varchar NOT null REFERENCES allpatient(patientid) ON DELETE CASCADE ON UPDATE CASCADE,
	testDate date
);

--5. Creating Inpatient Table.
CREATE TABLE Inpatient(
	bedID varchar NOT null Primary Key,
	patientID varchar NOT null,
	illnessCode varchar NOT null,
	admissionDate date NOT null,
	dischargeDate date,
	Foreign Key (patientID) REFERENCES allpatient(patientId) ON DELETE CASCADE ON UPDATE CASCADE,
	Foreign Key (illnesscode) REFERENCES IllnessDrugPrescription(illnesscode) ON DELETE CASCADE ON UPDATE CASCADE
);

--6. Creating Diagnostics Table.
CREATE TABLE Diagnostic(
	prescriptionID varchar NOT null Primary Key,
	patientID varchar NOT null,
	illnessCode varchar NOT null,
	Foreign Key (patientID) REFERENCES AllPatient(patientID) ON DELETE CASCADE ON UPDATE CASCADE,
	Foreign Key (illnessCode) REFERENCES IllnessDrugPrescription(illnessCode) ON DELETE CASCADE ON UPDATE CASCADE
);

--7. Creating Surgery Table.
CREATE TABLE Surgery(
	surgeryID varchar NOT null Primary Key,
	surgeryDate date,
	patientID varchar NOT null,
	Foreign Key (patientID) REFERENCES AllPatient(patientID) ON DELETE CASCADE ON UPDATE CASCADE
);

--8. Creating Account Table.
CREATE TABLE Account(
	billID varchar NOT null Primary Key,
	billingDate date,
	patientID varchar NOT null,
	amount varchar NOT null,
	status varchar NOT null,
	Foreign Key (patientID) REFERENCES AllPatient(patientID) ON DELETE CASCADE ON UPDATE CASCADE
);

--9.Creating NewPatient Table for demonstration.
CREATE TABLE NewPatient(
	patientID varchar NOT null Primary Key,
	patientName varchar(255) NOT null,
	contact varchar(255) NOT null,
	gender varchar(255) NOT null,
	emergency_contact varchar(255) Default null,
	emergency_contact_phone varchar(255) Default null,
	doctorID varchar NOT null REFERENCES Doctor(doctorID) ON DELETE CASCADE ON UPDATE CASCADE
);


	
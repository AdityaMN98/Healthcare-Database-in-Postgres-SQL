--1.Inserting values to Doctor Table.
INSERT INTO Doctor(doctorID, doctorName, contact)
(SELECT DISTINCT doctorID, doctorName, doctorcontact
FROM hospitaldata
ORDER BY doctorName);

--2.Inserting values to ALL Patients Table.
INSERT INTO AllPatient 
(SELECT DISTINCT patientid, fullname, phone, gender, emergencycontact, emergencycontactnumber, doctorID 
FROM hospitaldata
ORDER BY fullname);

--3.Inserting values to Illness Table.
INSERT INTO IllnessDrugPrescription
(SELECT DISTINCT(illnesscode), description, drugprescribed, drugmanufacturer 
FROM hospitaldata
);

--4.Inserting values to Lab Test Table.
INSERT INTO LabTest
(SELECT DISTINCT testid, testcode, patientid, testdate
FROM hospitaldata
);

--5.Inserting values to Inpatient Table.
INSERT INTO Inpatient
(SELECT DISTINCT bedid, patientid, illnesscode, admissiondate, dischargedate
FROM hospitaldata
);

--6.Inserting values to Diagnostics Table.
INSERT INTO Diagnostic
(SELECT DISTINCT prescriptionid, patientid, illnesscode
FROM hospitaldata
);

--7.Inserting values to Surgery Table.
INSERT INTO Surgery
(SELECT DISTINCT surgeryid, surgerydate, patientid
FROM hospitaldata
);

--8.Inserting values to Account Table.
INSERT INTO Account
(SELECT DISTINCT billingid, billingdate, patientid, billingamount,
 CASE
   WHEN billingstatus = '1' THEN 'PAID'
   ELSE 'NOT PAID'
 END AS status
FROM hospitaldata
);
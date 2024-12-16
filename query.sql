--1.Query to select all data from Patients table.
SELECT * FROM allpatient;

--2.Query to select Male patients name and ID.
SELECT patientid, patientname FROM allpatient WHERE gender = 'Male';

--3.Query to get the number of patients of each gender.
SELECT gender, Count(gender) FROM allpatient GROUP BY gender;

--4.Query to get the emergency contact of a patient.
SELECT emergency_contact, emergency_contact_phone
FROM allpatient
WHERE patientid = 'P-Z99793359';

--5.Query to get the number of patients of each doctor has treated.
SELECT R1.doctorid, R1.doctorname, COUNT(*) AS num_patient
FROM doctor R1
INNER JOIN allpatient R2 ON R1.doctorid = R2.doctorid
GROUP BY R1.doctorid, R1.doctorname;

--6.Query to get illness of a patient.
SELECT R1.patientid, R1.patientname, R2.illnesscode, R3.description, R3.drugprescribed
FROM allpatient R1
INNER JOIN Diagnostic R2 ON R1.patientid = R2.patientid
INNER JOIN Illnessdrugprescription R3 ON R2.illnesscode = R3.illnesscode
WHERE R1.patientid = 'P-H49908184';

--7.Query to get the dates the patient was admitted to the hospital.
SELECT R1.patientid, R1.patientname, R2.bedid, R2.admissiondate, R2.dischargedate
FROM allpatient R1
INNER JOIN inpatient R2 ON R1.patientid = R2.patientid
WHERE R1.patientid = 'P-W45841287';

--8.Query to get the surgery date of a patient.
SELECT R1.patientid, R1.patientname, R2.surgeryid, R2.surgerydate
FROM allpatient R1
FULL OUTER JOIN surgery R2 ON R1.patientid = R2.patientid
WHERE R1.patientid = 'P-W45841287';

--9.Query to get the doctor and illness of patient using patientname.
SELECT R1.patientid, R1.patientname, R1.doctorid, R2.prescriptionid, R2.illnesscode
FROM diagnostic R2
RIGHT OUTER JOIN allpatient R1 ON R2.patientid = R1.patientid
WHERE R1.patientname = 'Adolpho Clayson';

--10.Query to get top 5 billed patients name.
SELECT R1.patientid, R1.patientname, R2.amount
FROM account R2
INNER JOIN allpatient R1 ON R2.patientid = R1.patientid
ORDER BY amount DESC
LIMIT 5;

--11.Query to show Creation of Index.
EXPLAIN ANALYZE SELECT doctorid, doctorname, contact
FROM doctor
WHERE doctorname = 'Kimble';

CREATE INDEX docname_index ON doctor(doctorname);

EXPLAIN ANALYZE SELECT doctorid, doctorname, contact
FROM doctor
WHERE doctorname = 'Kimble';


--12.Creating Function to get PatientID and Patient Name when rank of bill amount is inputed.
CREATE OR REPLACE FUNCTION patient_id_name_rank_func(RANK integer)
RETURNS TABLE(patientid varchar, patientname varchar)
AS $$
BEGIN
  RETURN QUERY SELECT R1.patientid, R1.patientname
               FROM allpatient R1
               INNER JOIN (
                 SELECT R2.patientid, R2.amount AS bill_amount
                 FROM account R2
                 ORDER BY bill_amount DESC
               ) R3 ON R1.patientid = R3.patientid
               LIMIT 1 OFFSET RANK - 1;
END;
$$ LANGUAGE plpgsql;

--Running the function patient_id_name_rank.
SELECT * FROM patient_id_name_rank_func(2);


--13.Creating function to see how many patients have consulted a doctor.
CREATE OR REPLACE FUNCTION num_patient_func(doctorid varchar)
RETURNS integer AS $$
DECLARE
    num_patients integer;
BEGIN
    SELECT COUNT(R1.patientid) INTO num_patients
    FROM allpatient R1
    WHERE R1.doctorid = $1;
    RETURN num_patients;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM num_patient_func('DOC-95623472N')

--15. Creating function to get all patients with certain illness.
CREATE OR REPLACE FUNCTION all_patient_with_illness_func(code varchar)
RETURNS TABLE (patientid varchar, patientname varchar) AS
$$
BEGIN
    RETURN QUERY
        SELECT R1.patientid, R1.patientname
        FROM allpatient R1
        JOIN diagnostic R2 ON R1.patientid = R2.patientid
        WHERE R2.illnesscode = code;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM all_patient_with_illness_func('ILL-OD84877467899b');

--16.Creating Function to use in Triggers.

CREATE OR REPLACE FUNCTION add_to_allpatients()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO allpatient VALUES (NEW.*);
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE allpatient SET (patientname, gender, contact, emergency_contact, emergency_contact_phone, doctorid) = (NEW.patientname, NEW.gender, NEW.contact, NEW.emergency_contact, NEW.emergency_contact_phone, NEW.doctorid) WHERE patientid = NEW.patientid;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Creating the Trigger.
CREATE TRIGGER add_allpatient_trg
AFTER INSERT OR UPDATE ON newpatient
FOR EACH ROW
EXECUTE FUNCTION add_to_allpatients();

--17. Inserting into NewPatient.
INSERT INTO newpatient (PatientID, PatientName, Contact, Gender, Emergency_Contact, Emergency_Contact_Phone, DoctorID) 
Values ('P-A2222222227', 'Arjun', '+86 420 192 82551', 'Male', 'Shara', '676(560)304-0558', 'DOC-95623472N'),
       ('P-A111111111', 'Gregory', '+86 470 562 251', 'Male', 'June', '676(560)304-0558', 'DOC-95623472N'),
	   ('P-A5555558792', 'Alexis', '+91 524 192 82551', 'Female', 'Serena', '1234856', 'DOC-95623472N'),
	   ('P-A22222222992', 'Pablo', '+12 920 872 82551', 'Male', 'Juan', '+91 8162547747', 'DOC-95623472N'),
	   ('P-A1238524645', 'Francis', '+12 680 192 7451', 'Male', 'Claire', '+91 97420188847', 'DOC-95623472N');

--Checking New Patient Table.
SELECT * FROM newpatient;

--Checking if Trigger has worked for INSERT statement.
SELECT * FROM allpatient WHERE patientid = 'P-A5555558792';

--18.Updating the newpatient.
UPDATE newpatient
SET contact = '+91 7019211299'
WHERE patientid = 'P-A5555558792';

--Checking New Patient Table.
SELECT * FROM newpatient;

--Checking if Trigger has worked for INSERT statement.
SELECT * FROM allpatient WHERE patientid = 'P-A5555558792';


-- Question 3-09

DECLARE
  proj_id dd_project.idproj%TYPE;
  proj_name dd_project.projname%TYPE;
  pl_num dd_pledge.pledgeamt%TYPE;
  pl_avg dd_pledge.pledgeamt%TYPE;
  pl_sum dd_pledge.pledgeamt%TYPE;
BEGIN
  SELECT dd_project.idproj, dd_project.projname, count(pledgeamt), sum(pledgeamt), avg(pledgeamt)
   INTO proj_id, proj_name, pl_num, pl_sum,  pl_avg
   FROM dd_project JOIN dd_pledge
   ON dd_project.idproj = dd_pledge.idproj and dd_project.idproj = 504
   group by dd_project.idproj,projname;

      DBMS_OUTPUT.PUT_LINE('ID: ' || proj_id ||' Name: ' || proj_name);
      DBMS_OUTPUT.PUT_LINE('Number of Pledges: '|| pl_sum ||'Sum of Dollars Pledged: '|| 
      pl_sum||' Average Pledged: '|| pl_avg );
END;


-- Question 3-10

CREATE SEQUENCE dd_projid_seq
  START WITH     530
  INCREMENT BY   1
  NOCACHE
  NOCYCLE;
  
  
DECLARE 
TYPE type_project IS RECORD(
pj_name dd_project.projname%TYPE := 'HK Animal Shelter Extension',
pj_start dd_project.projstartdate%TYPE := (to_date( '01/01/2013', 'mm/dd/yyyy')),
pj_end dd_project.projenddate%TYPE := (to_date ('05/31/2013', 'mm/dd/yyyy')),
pj_funding dd_project.projfundgoal%TYPE := 65000 );
new_project type_project;
BEGIN
INSERT INTO dd_project (idproj, projname, projstartdate, projenddate, projfundgoal)
VALUES (dd_projid_seq.NEXTVAL, new_project.pj_name, new_project.pj_start, new_project.pj_end, new_project.pj_funding);
COMMIT; 
END;

SELECT * FROM dd_project;



-- Question 3-11

DECLARE 
PLED DD_PLEDGE%ROWTYPE;
START_MONTH_DATE DD_PLEDGE.PLEDGEDATE%TYPE := '01-OCT-12';
END_MONTH_DATE DD_PLEDGE.PLEDGEDATE%TYPE := '31-OCT-12';

BEGIN
FOR PLED IN
(SELECT IDPLEDGE, IDDONOR, PLEDGEAMT, 

CASE 
WHEN PAYMONTHS = 0 THEN 'Lump Sum.'
ELSE 'Monthly - ' || PAYMONTHS END AS MONTHLY_PAYMENT
FROM DD_PLEDGE
WHERE PLEDGEDATE >= START_MONTH_DATE AND PLEDGEDATE <= END_MONTH_DATE
ORDER BY PAYMONTHS)
LOOP 
DBMS_OUTPUT.PUT_LINE('ID: ' || PLED.IDPLEDGE 
|| ', Donor ID: '|| PLED.IDDONOR 
|| ', Pledge Amount: ' ||to_char(PLED.PLEDGEAMT,'$9999.99') 
|| ', Monthly Pays: ' || PLED. MONTHLY_PAYMENT);
END LOOP;
END;


-- Question 3-12

DECLARE
PLED DD_PLEDGE%ROWTYPE;
BLC DD_PLEDGE.PLEDGEAMT%TYPE;
MONTHS_TOTAL DD_PLEDGE.PAYMONTHS%TYPE:= 24;
PLEDGE_MONTHLY DD_PLEDGE.PLEDGEAMT%TYPE;
BEGIN
  SELECT * INTO PLED
  FROM DD_PLEDGE
  WHERE IDPLEDGE = 105;
  IF PLED.PAYMONTHS = 0 THEN
  BLC := 0;
  ELSE BLC := (MONTHS_TOTAL-PLED.PAYMONTHS)*(PLED.PLEDGEAMT/PLED.PAYMONTHS);
  END IF;
    DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || PLED.IDPLEDGE || ', Donor ID: ' || PLED.IDDONOR ||
    ', Pledge amount: ' || PLED.PLEDGEAMT || ' ' || ', Balance: ' || BLC);
END;




-- Question 3-13

DECLARE
  project_name dd_project.projname%TYPE;
  day_start dd_project.projstartdate%TYPE;
  fd_goal dd_project.projfundgoal%TYPE;  
  new_Fund_goal	dd_project.projfundgoal%TYPE := 150000;

  proj_id dd_project.idproj%TYPE := 502;

BEGIN
  SELECT projname, projstartdate, projfundgoal
  INTO project_name, day_start, fd_goal
  FROM DD_PROJECT
  WHERE idproj = proj_id; 

  UPDATE dd_project
  SET projfundgoal = new_Fund_goal
  WHERE idproj = proj_id;  
DBMS_OUTPUT.PUT_LINE('Project Name: ' || project_name);
DBMS_OUTPUT.PUT_LINE('Start Date: ' || day_start );
DBMS_OUTPUT.PUT_LINE('Previous Goal: ' || fd_goal);
DBMS_OUTPUT.PUT_LINE('New Goal: ' || new_Fund_goal); 
END;

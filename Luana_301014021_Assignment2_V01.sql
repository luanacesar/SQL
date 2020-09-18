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
    TYPE pledge_type IS TABLE OF dd_pledge%ROWTYPE 
        INDEX BY PLS_INTEGER; 
    table_pledge pledge_type;
    payment VARCHAR2(12);
BEGIN 
    SELECT * BULK COLLECT 
        INTO table_pledge 
        FROM dd_pledge
        WHERE idpledge IN( SELECT idpledge FROM dd_pledge
        WHERE EXTRACT(MONTH FROM TO_DATE(pledgedate, 'DD-MON-YYYY')) = '10')
        ORDER BY paymonths;
    FOR x IN 1.. table_pledge.COUNT LOOP
        IF table_pledge (x).paymonths = 0 THEN
            payment := 'Lump Sum';
        ELSE
            payment := 'Monthly - '|| table_pledge (x).paymonths;
        END IF;
        DBMS_OUTPUT.PUT_LINE(
        'Pledge Date: ' ||table_pledge (x).pledgedate || 
        ' , Pledge ID: ' || table_pledge (x).idpledge || 
        ' , Pledge Amount: ' || table_pledge (x).pledgeamt || 
        ' , PayMent ' || payment);
    END LOOP; 
END;

-- Question 3-12

DECLARE
    pled dd_pledge%ROWTYPE;
    amount dd_pledge.pledgeamt%TYPE;
    Balance dd_pledge.pledgeamt%TYPE;
    id dd_pledge.idpledge%TYPE := 104;
BEGIN
    SELECT * INTO pled FROM dd_pledge
    WHERE idpledge = id;
    SELECT sum(payamt)
    INTO amount
    FROM dd_payment
    WHERE idpledge =id;
    BALANCE := pled.pledgeamt - amount;
    DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || pled.idpledge ||' Donor ID: ' || pled.iddonor ||' Pledge amount: '|| pled.pledgeamt || 
        ' Total: ' || amount || ' Balance: ' || Balance);
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

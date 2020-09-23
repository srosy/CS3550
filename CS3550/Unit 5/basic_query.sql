-- Spencer Rosenvall

-- SELECT 
USE sample;
SELECT * FROM department;
SELECT dept_no, dept_name, location FROM department; -- specify columns


-- SELECT + WHERE
SELECT dept_no, dept_name FROM department WHERE location = 'Dallas';
SELECT emp_lname,emp_fname FROM employee WHERE emp_no > 15000;
SELECT emp_no FROM works_on WHERE project_no = 'p1' OR project_no = 'p2';
SELECT DISTINCT emp_no FROM works_on WHERE project_no = 'p1' OR project_no = 'p2';
SELECT * FROM employee WHERE dept_no <> 'd2';
SELECT * FROM employee WHERE emp_no IN (29346, 28559, 25348);
SELECT * FROM employee WHERE emp_no NOT IN (10102, 9031);

-- BETWEEN
SELECT project_name, budget FROM project WHERE budget BETWEEN 95000 AND 120000;
SELECT emp_no, project_no FROM works_on WHERE project_no = 'p2' AND job IS NULL; -- handle nulls
SELECT emp_no, project_no, job FROM works_on WHERE job IS NULL; -- use null to advantage
SELECT emp_no, project_no, job FROM works_on WHERE job = NULLSELECT emp_no, project_no, job FROM works_on WHERE job <> NULL; -- incorrect use of null

-- LIKE 
SELECT * FROM employee WHERE emp_fname LIKE '%el%';
SELECT emp_fname, emp_lname FROM employee WHERE emp_fname LIKE '_a%';

-- DISTINCT
SELECT job FROM works_on GROUP BY jobSELECT DISTINCT job FROM works_on;

-- GROUP BY
SELECT project_no, job FROM works_on GROUP BY project_no, job;
SELECT project_no FROM works_on GROUP BY project_no;

-- HAVING
SELECT * FROM works_on SELECT project_no FROM works_on GROUP BY project_no HAVING Count(*) < 4;
SELECT job FROM works_on GROUP BY job HAVING job LIKE 'M%'SELECT job, 
Count(job) FROM works_on GROUP BY job HAVING job LIKE 'M%'SELECT job,
Count(job) FROM works_on GROUP BY job HAVING job NOT LIKE 'M%';

-- ORDER BY
SELECT emp_fname, emp_lname, dept_no FROM employee WHERE emp_no < 20000 ORDER BY emp_lname, emp_fname;
SELECT emp_fname, emp_lname, dept_no FROM employee WHERE emp_no < 20000 ORDER BY emp_lname DESC, emp_fname DESC;

-- SUBQUERIES
SELECT * FROM employee WHERE dept_no =(SELECT dept_no FROM department WHERE dept_name = 'Research'); -- only works if single value is returned
SELECT * FROM project WHERE project_name = 'Apollo';
SELECT * FROM works_on;
SELECT * FROM works_on WHERE project_no IN (SELECT project_no FROM project WHERE project_name = 'Apollo');
SELECT emp_no FROM works_on WHERE project_no IN (SELECT project_no FROM project WHERE project_name = 'Apollo');
SELECT * FROM employee WHERE emp_no IN (SELECT emp_no FROM works_on WHERE project_no IN (SELECT project_no FROM project WHERE project_name = 'Apollo'));

-- IN
SELECT * FROM employee WHERE dept_no IN (SELECT dept_no FROM department WHERE location = 'Dallas'); -- expects at least one in result set

-- JOIN (INNER JOIN)
SELECT * FROM employee INNER JOIN department ON employee.dept_no = department.dept_no;
SELECT emp_lname, emp_fname,dept_name FROM employee INNER JOIN department ON employee.dept_no = department.dept_no;


SELECT * FROM employee
INNER JOIN works_on ON employee.emp_no = works_on.emp_no
INNER JOIN project ON project.project_no = works_on.project_no;

SELECT * FROM employee
INNER JOIN works_on ON employee.emp_no = works_on.emp_no
INNER JOIN project ON project.project_no = works_on.project_no
WHERE project_name = 'Gemini';

SELECT emp_lname, emp_fname FROM employee
INNER JOIN works_on ON employee.emp_no = works_on.emp_no
INNER JOIN project ON project.project_no = works_on.project_no
WHERE project_name = 'Gemini'

SELECT * FROM employee
INNER JOIN department ON employee.dept_no = department.dept_no;

SELECT * FROM employee
INNER JOIN department ON employee.dept_no = department.dept_no
WHERE location = 'Seattle';

SELECT emp_fname,emp_lname FROM employee
INNER JOIN department ON employee.dept_no = department.dept_no
WHERE location = 'Seattle';

SELECT * FROM employee
INNER JOIN works_on ON employee.emp_no = works_on.emp_no
INNER JOIN department ON department.dept_no = employee.dept_no
WHERE location = 'Seattle' AND job = 'Analyst';

SELECT emp_lname,emp_fname FROM employee
INNER JOIN works_on ON employee.emp_no = works_on.emp_no
INNER JOIN department ON department.dept_no = employee.dept_no
WHERE location = 'Seattle' AND job = 'Analyst';


-- LEFT OUTER JOIN (Take the first table then whatever matches/specified from the joined table)
SELECT * FROM employee LEFT OUTER JOIN works_on ON employee.emp_no = works_on.emp_no;
SELECT emp_fname,emp_lname,project_no FROM employee LEFT OUTER JOIN works_on ON employee.emp_no = works_on.emp_no;
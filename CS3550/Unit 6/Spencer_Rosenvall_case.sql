USE sample

SELECT emp_no,
(CASE WHEN dept_no = 'd2' THEN 'Department 2' ELSE 'Some other department' END) AS [Department],
(CASE WHEN emp_no > 10000 THEN 'Loves it' ELSE 'Hates it' END) AS [Likes Cheese],
(CASE WHEN emp_no > 10000 THEN emp_no * 1.1 / 1000 ELSE emp_no * 0.9 / 1000 END) AS [Cheese Loving Approximation on scale 1 / 10]
FROM employee;
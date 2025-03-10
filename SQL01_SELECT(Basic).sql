-- 1.
SELECT department_name "학과 명", category 계열 FROM tb_department;

-- 2.
SELECT department_name||'의 정원은 '||capacity||'명 입니다.' "학과별 정원" FROM TB_DEPARTMENT;

-- 3.
SELECT student_name FROM TB_STUDENT ts WHERE department_no = 001 AND ts.ABSENCE_YN = 'Y' AND substr(ts.STUDENT_SSN, 8,1) = 2 ;

-- 4. 
SELECT student_name FROM TB_STUDENT ts WHERE ts.STUDENT_NO IN('A513079','A513090','A513091','A513110','A513119');

-- 5. 
SELECT department_name, category FROM tb_department WHERE capacity BETWEEN 20 AND 30;

-- 6. 
SELECT professor_name FROM TB_PROFESSOR WHERE department_no IS NULL;

-- 7. 
SELECT student_name FROM TB_STUDENT ts WHERE department_no IS NULL;

-- 8. 
SELECT class_no FROM TB_CLASS WHERE PREATTENDING_CLASS_NO IS NOT null;

-- 9.
SELECT DISTINCT category FROM TB_DEPARTMENT WHERE;

-- 10.
SELECT student_no, student_name, student_ssn FROM TB_STUDENT ts WHERE (entrance_date BETWEEN '2002-01-01' AND '2002-12-31')AND(ts.STUDENT_ADDRESS LIKE '전주%')AND(ABSENCE_YN='N') ;
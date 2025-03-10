-- 1. 
SELECT student_no 학번, student_name 이름, to_char(entrance_date, 'YYYY-MM-DD') 입학년도 FROM tb_student WHERE department_no = 02 ORDER BY TB_STUDENT.ENTRANCE_DATE;	

-- 2.
SELECT professor_name, professor_ssn FROM TB_PROFESSOR tp WHERE professor_name NOT LIKE '___';

-- 3.
SELECT professor_name 교수이름, 125 - to_number(substr(professor_ssn,1,2)) 나이 FROM tb_professor ORDER BY 2;
SELECT professor_name 교수이름, FLOOR(MONTHS_BETWEEN(sysdate,TO_DATE(substr(professor_ssn,1,6),'YYMMDD')-365*100)/12) 나이 FROM tb_professor ORDER BY 2;
SELECT professor_name 교수이름, TO_DATE(substr(professor_ssn,1,6),'YYMMDD')-365*100 FROM tb_professor ORDER BY 2;

-- 4.
SELECT substr(professor_name,2) 이름 FROM tb_professor;

-- 5. 
SELECT student_no, student_name,abs(floor(MONTHS_BETWEEN(TO_DATE(substr(student_ssn,1,6),'RRMMDD'),TB_STUDENT.ENTRANCE_DATE)/12)) 나이 FROM tb_student WHERE abs(floor(MONTHS_BETWEEN(TO_DATE(substr(student_ssn,1,6),'RRMMDD'),TB_STUDENT.ENTRANCE_DATE)/12))>19 ;
SELECT student_no, student_name,to_number(substr(to_char(entrance_date, 'YYYY-MM-DD'),3,4))+100-TO_number(substr(student_ssn,1,2)) 나이 FROM tb_student;
SELECT to_char(entrance_date, 'YYYY-MM-DD') FROM tb_student;
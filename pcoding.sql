-- 부서별 입사일이 가장 빠른 사람의 사번, 이름, 부서명(null이면 소속없음), 직급명, 입사일을 조회하고 입사일이 빠른 순으로 조회
-- 단, 퇴사한 직원 제외

-- (대상)(정보)(정렬 기준)
-- 대상 : 특정 조건1 중/특정 조건2

SELECT emp_id, emp_name, nvl(dept_title,'소속없음'), job_name, hire_date
FROM EMPLOYEE main
JOIN job on(job.JOB_CODE = main.JOB_CODE)
LEFT JOIN DEPARTMENT on(dept_code = dept_id)
WHERE hire_date = (SELECT min(hire_date)
									 FROM employee sub
									 JOIN job on(main.job_code = sub.job_code)
									 LEFT JOIN department on(dept_code = dept_id)
									 WHERE ent_yn = 'N'
									 or main.dept_code IS NULL AND sub.dept_code IS NULL)
ORDER BY hire_date;

-- 직급별 나이가 가장 어린 직원의
-- 사번 이름 직급명 나이 보너스포함연봉을 조회하고
-- 나이순으로 내림차순 정렬
-- 단 연봉은 \124,800,000으로 출력

SELECT emp_id, emp_name, job_name, 
floor(MONTHS_BETWEEN(sysdate,SUBSTR(emp_no,1,6))/12) 나이,
to_char( ( ( (1+nvl(bonus,0))*salary) )*12,'L999,999,999') 연봉
FROM EMPLOYEE main
JOIN job on(main.job_code = job.job_code)
WHERE to_date(substr(emp_no,1,6)) = (SELECT max(to_date(substr(emp_no,1,6)))
														FROM employee sub 
														JOIN job on(main.job_code = sub.job_code)
														WHERE sub.job_code = main.JOB_CODE )
ORDER BY 나이 desc;

SELECT floor(MONTHS_BETWEEN(sysdate,SUBSTR(emp_no,1,6))/12)
FROM employee;

-- to_char() --> 숫자나 날짜를 문자로 형변환
-- months_between(date,date) --> date
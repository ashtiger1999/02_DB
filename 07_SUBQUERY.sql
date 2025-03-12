/*
 * SUBQUERY (서브쿼리 == 내부 쿼리)
 * 
 * - 하나의 SQL문 안에 포함된 또 다른 SQL문
 * - 메인 쿼리를 위해 보조 역할을 하는 쿼리문
 * 
 * -- 메인 쿼리가 SELECT문일때
 * -- 서브쿼리는 SELECT, FROM, WHERE, HAVING에서 사용 가능
 * 
 * */

-- 서브쿼리 예시 1.

-- 부서코드가 노옹철 사원과 같은 부서 소속의 직원의 이름, 부서코드 조회

-- 1) 노옹철 사원의 부서코드 조회(서브쿼리)
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- 'D9'

-- 2) 부서코드가 'D9'인 직원의 이름, 부서코드 조회(메인쿼리)
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 3) 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회
--> 위의 2 단계를 하나의 쿼리로 작성
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '노옹철');

-- 서브쿼리 예시 2.
-- 전 직원의 평균 급여보다 많은 급여를 받고있는 직원의 사번, 이름, 직급코드, 급여 조회

-- 1) 전 직원의 평균 급여 조회(서브쿼리)
SELECT CEIL(AVG(SALARY))
FROM EMPLOYEE; -- 3047663

-- 2) 직원 중 급여가 3047663원 이상인 사원들의 사번, 이름, 직급코드, 급여 조회(메인쿼리)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047663;

-- 3) 직원 중 급여가 전 직원의 평균 급여보다 높은 직원의 정보
--> 위의 2단계를 하나의 쿼리로 작성
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT CEIL(AVG(SALARY)) FROM EMPLOYEE);

/* 서브쿼리 유형
 * 
 * - 단일행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때
 * 
 * - 다중행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
 * 
 * - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 나열된 항목수가 여러개일 때(단일행)
 * 
 * - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때
 * 
 * - 상(호연)관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인쿼리가 비교 연산할 때
 * 						메인쿼리 테이블의 값이 변경되면 
 * 						서브쿼리의 결과값도 바뀌는 서브쿼리
 * 
 * - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
 * 
 * ** 서브쿼리 유형에 따라 서브쿼리 앞에 붙는 연산자가 다름 ** 
 * 
 * */			

-----------------------------------------------------------------------------------------

-- 1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
-- 서브쿼리의 조회 결과 값의 개수가 1개인 서브쿼리
-- 단일행 서브쿼리 앞에는 비교 연산자 사용
-- <, >, <=, >-, =, !=/<>/^=

-- 전 직원의 급여 평균보다 많은(초과) 급여를 받는 직원의 이름, 직급명, 부서명, 급여를 직급 순으로 정렬하여 조회
SELECT E.EMP_NAME 이름, J.JOB_NAME 직급명, D.DEPT_TITLE 부서명, E.SALARY 급여
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE SALARY>(SELECT AVG(SALARY) FROM EMPLOYEE)
ORDER BY JOB_CODE;
-- SELECT절에 명시되지 않은 컬럼이라도 FROM, JOIN으로 인해 테이블 상에 존재하는 컬럼이라면 ORDER BY절 사용 가능

-- 가장 적은 급여를 받는 직원의 사번, 이름, 직급명, 부서코드, 급여, 입사일
SELECT E.EMP_ID 사번, E.EMP_NAME 이름, J.JOB_NAME 직급명, E.DEPT_CODE 부서코드, E.SALARY 급여, E.HIRE_DATE 입사일
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
WHERE SALARY=(SELECT MIN(SALARY) FROM EMPLOYEE);

-- 노옹철 사원의 급여보다 많이(초과)받는 직원의 사번, 이름, 부서명, 직급명, 급여 조회
SELECT E.EMP_ID 사번, E.EMP_NAME 이름, D.DEPT_TITLE 부서명, J.JOB_NAME 직급명, E.SALARY 급여
FROM EMPLOYEE E
LEFT JOIN JOB j USING (JOB_CODE)
LEFT JOIN DEPARTMENT d  ON(E.DEPT_CODE = D.DEPT_ID )
WHERE SALARY>(SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '노옹철');

-- 부서별 (부서가 없는 사람 포함 )급여의 합계 중
-- 가장 큰 부서의 부서명, 급여 합계를 조회

-- 1) 부서별 급여 합 중 가장 큰 값 조회(서브쿼리)
SELECT MAX(SUM(SALARY)) FROM EMPLOYEE e
GROUP BY DEPT_CODE; -- 17700000 1행 1열 (단일행)

-- 2) 부서별 급여합이 17700000인 부서의 부서명과 급여합 조회
SELECT d.DEPT_TITLE , SUM(SALARY) FROM EMPLOYEE
LEFT JOIN DEPARTMENT d ON(DEPT_CODE = DEPT_ID)
GROUP BY d.DEPT_TITLE 
HAVING SUM(SALARY) = 17700000;

-- 3) 위의 두 쿼리를 합쳐 부서별 급여 합이 가장 큰 부서의 부서명, 급여합 조회
SELECT d.DEPT_TITLE , SUM(SALARY) FROM EMPLOYEE
LEFT JOIN DEPARTMENT d ON(DEPT_CODE = DEPT_ID)
GROUP BY d.DEPT_TITLE 
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY)) FROM EMPLOYEE e
GROUP BY DEPT_CODE);

-----------------------------------------------------------------------------------------

-- 2. 다중행 서브쿼리 (MULTI ROW SUBQUERY)
-- 서브쿼리의 조회 결과 값의 개수가 여러행일 때

/*
 * > 다중행 서브쿼리 앞에는 일반 비교연산자 사용 불가
 * 
 * - IN / NOT IN : 여러개의 결과 값 중에서 한개라도 일치하는 값이 있다면 / 없다면 이라는 의미
 * 
 * - > ANY, < ANY : 여러개의 결과값 중에서 한개라도 큰/작은 경우
 * --> 가장 작은 값보다 큰가?/ 가장 큰 값보다 작은가?
 * 
 * - > ALL, < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
 * --> 가장 큰 값보다 큰가? / 가장 작은 값보다 작은가?
 * 
 * - EXISTS / NOT EXISTS : 값이 존재하는가? / 존재하지 않는가?
 * 
 * */

-- 부서별 최고 급여를 받는 직원의 이름, 직급, 부서, 급여를 부서 오름차순으로 정렬하여 조회

-- 1) 부서별 최고 급여 조회 (서브쿼리)
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY EMPLOYEE.DEPT_CODE; -- 7행 1열 (다중행)

-- 메인쿼리 + 서브쿼리
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE e WHERE SALARY IN (SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY EMPLOYEE.DEPT_CODE)
ORDER BY DEPT_CODE;

-- 사수에 해당하는 직원에 대해 조회
-- 사번, 이름, 부서명, 직급명, 구분(사수/사원) 조회

-- * 사수 사번 == MANAGE_ID 컬럼에 작성된 사번

-- 1) 사수에 해당하는 사원번호에 대해 조회(서브쿼리)
SELECT DISTINCT E.MANAGER_ID
FROM EMPLOYEE e
WHERE E.MANAGER_ID IS NOT NULL;

-- 2) 직원의 사번, 이름, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, D.DEPT_TITLE, JOB_NAME
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);

-- 3) 사수에 해당되는 직원에 대한 정보 추출 / 조회(구분 '사수')
SELECT EMP_ID, EMP_NAME, D.DEPT_TITLE, JOB_NAME, '사수' 구분
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE e.EMP_ID IN(SELECT DISTINCT E.MANAGER_ID
FROM EMPLOYEE e
WHERE E.MANAGER_ID IS NOT NULL);

-- 4) 일반 직원에 해당하는 사원들 정보 조회 (구분은 '사원')
SELECT EMP_ID, EMP_NAME, D.DEPT_TITLE, JOB_NAME, '사원' 구분
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE e.EMP_ID NOT IN(SELECT DISTINCT E.MANAGER_ID
FROM EMPLOYEE e
WHERE E.MANAGER_ID IS NOT NULL);

-- 5) 3, 4의 조회 결과를 하나로 조회


-- 5-1) 집합 연산자 (UNION 합집합) 사용하기
SELECT EMP_ID, EMP_NAME, D.DEPT_TITLE, JOB_NAME, '사수' 구분
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE e.EMP_ID IN(SELECT DISTINCT E.MANAGER_ID
FROM EMPLOYEE e
WHERE E.MANAGER_ID IS NOT NULL)
UNION
SELECT EMP_ID, EMP_NAME, D.DEPT_TITLE, JOB_NAME, '사원' 구분
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE e.EMP_ID NOT IN(SELECT DISTINCT E.MANAGER_ID
FROM EMPLOYEE e
WHERE E.MANAGER_ID IS NOT NULL);

-- 5-2) 선택함수 사용
--> DECODE();
--> CASE WHEN 조건 THEN 결과 ... ELSE END
SELECT EMP_ID, EMP_NAME, D.DEPT_TITLE, JOB_NAME,
CASE WHEN EMP_ID IN(SELECT DISTINCT MANAGER_ID
										FROM EMPLOYEE
										WHERE MANAGER_ID IS NOT NULL)	
					THEN '사수'
					ELSE '사원'
			END 구분
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
ORDER BY EMP_ID;

-- 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의 사번, 이름, 직급명, 급여 조회

-- > ANY : 가장 작은 값보다 크냐

-- 1) 직급이 대리인 직원들의 사번, 이름, 직급, 급여 조회(메인쿼리)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY 
FROM EMPLOYEE 
JOIN JOB J USING (JOB_CODE) 
WHERE JOB_NAME = '대리';

-- 2) 직급이 과장인 직원들의 급여 조회(서브쿼리)
SELECT SALARY 
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE) 
WHERE JOB_NAME='과장';

-- 3) 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의 사번, 이름, 직급명, 급여 조회

-- 방법 1) ANY를 이용하기
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY 
FROM EMPLOYEE 
JOIN JOB J USING (JOB_CODE) 
WHERE JOB_NAME = '대리'
AND SALARY > ANY (SELECT SALARY 
									FROM EMPLOYEE 
									JOIN JOB USING(JOB_CODE) 
									WHERE JOB_NAME='과장');

-- > ANY : 가장 작은 값보다 큰가?
-- 과장 직급 최소 급여보다 큰 급여를 받는 대리인가?

-- < ANY : 가장 큰 값보다 작은가?
-- 과장 직급 최대 급여보다 적은 급여를 받는 대리인가?

-- 방법 2) MIN을 이용해서 단일행 서브쿼리로 만듦
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY 
FROM EMPLOYEE 
JOIN JOB J USING (JOB_CODE) 
WHERE JOB_NAME = '대리'
AND SALARY > (SELECT MIN(SALARY) 
						 FROM EMPLOYEE 
						 JOIN JOB USING(JOB_CODE) 
						 WHERE JOB_NAME='과장');

-- 차장 직급의 급여 중 가장 큰 값보다 많이 받는 과장 직급의 직원 정보(사번, 이름, 직급, 급여) 조회

-- > ALL, < ALL : 가장 큰 값보다 크냐? / 가장 작은 값보다 작냐?

-- 서브쿼리
SELECT SALARY
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장';

-- 메인 쿼리 + 서브 쿼리
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
AND SALARY > ALL (SELECT SALARY
FROM EMPLOYEE e 
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장');

-- > ALL : 가장 큰 값보다 큰가?
-- 차장 직급의 최대 급여보다 많이 받는 과장인가?

-- < ALL : 가장 작은 값보다 작은가?
-- 차장 직급의 최소 급여보다 적게 받는 과장인가?

-- 서브쿼리 중첩 사용(응용)

-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가
-- EMPLOYEE 테이블의 DEPT_CODE와 동일한 사원을 조회해라.

-- 1) LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE 조회
SELECT LOCAL_CODE 
FROM LOCATION 
WHERE NATIONAL_CODE ='KO';

-- 2) 1)의 결과가 DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID
SELECT DEPT_ID 
FROM DEPARTMENT 
WHERE LOCATION_ID = (SELECT LOCAL_CODE 
										 FROM LOCATION 
										 WHERE NATIONAL_CODE ='KO');

-- 3) 2)의 결과가 EMPLOYEE 테이블의 DEPT_CODE와 동일한 사원 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, NATIONAL_CODE
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID AND LOCATION_ID = LOCAL_CODE
AND DEPT_CODE IN (SELECT DEPT_ID 
									  FROM DEPARTMENT 
									  WHERE LOCATION_ID = (SELECT LOCAL_CODE 
																				 FROM LOCATION 
																				 WHERE NATIONAL_CODE ='KO'));


-----------------------------------------------------------------------------------------

-- 3. (단일행) 다중열 서브쿼리
-- 서브쿼리 SELECT 절에 나열된 컬럼수가 여러개일 때

-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 사원의 이름, 직급코드, 부서코드, 입사일 조회

-- 1) 퇴사한 여직원 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE e 
WHERE ENT_YN = 'Y'
AND SUBSTR(EMP_NO,8,1) = '2'; -- D8 J6 (이태림)

-- 2) 퇴사한 여직원과 같은 부서, 같은 직급 조회

-- 방법 1) 단일행 단일열 서브쿼리 2개를 사용
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE e 
WHERE DEPT_CODE = (SELECT DEPT_CODE
									 FROM EMPLOYEE e 
									 WHERE ENT_YN = 'Y'
									 AND SUBSTR(EMP_NO,8,1) = '2')
AND JOB_CODE = (SELECT JOB_CODE
								FROM EMPLOYEE e 
								WHERE ENT_YN = 'Y'
								AND SUBSTR(EMP_NO,8,1) = '2');

-- 방법 2) 다중열 서브쿼리 사용
--> WHERE절에 작성된 컬럼 순서에 맞게 서브쿼리의 조회된 컬럼과 비교하여 일치하는 행만 조회
-- 컬럼 순서 중요
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE e
WHERE(DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
														  FROM EMPLOYEE e 
														  WHERE ENT_YN = 'Y'
															AND SUBSTR(EMP_NO,8,1) = '2');




-----------------------------------------------------------------------------------------
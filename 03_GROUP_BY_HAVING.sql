/*
 * SELECT 문 해석순서
 * 
 * 5. SELECT 컬럼명 AS 별칭, 계산식, 함수
 * 1. FROM 테이블명
 * 2. WHERE 컬럼명 | 함수식 비교연산자 비교값
 * 3. GROUP BY 그룹을 묶을 컬럼명
 * 4. HAVING 그룹함수식 비교연산자 비교값
 * 6. ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식(ASC | DESC) [NULLS FRIST | LAST]
 * 
 * ** 넘버링은 컴파일러 해석 순서
 * 
 * */

----------------------------------------------------------------------------------------------------------

-- * GROUP BY 절 : 같은 값들이 여러개 기록된 컬럼을 가지고
--                같은 값들을 하나의 그룹으로 묶음

-- GROUP BY 컬럼명 | 함수식, ...

-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용함
-- 그룹으로 묶은 값에 대해서 SELECT 절에서 그룹함수를 사용함

-- 그룹함수는 단 한개의 결과값만 산출하기 때문에 그룹이 여러개일 경우 오류 발생
-- 여러개의 결과값을 산출하기 위해 그룹함수가 적용된 그룹의 기준을 ORDER BY 절에 기술하여 사용

-- EMPLOYEE 테이블에서 부서코드, 부서별 급여 합 조회
SELECT DEPT_CODE, SUM(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE ORDER BY 1;
-- DEPT_CODE 컬럼을 그룹으로 묶어, 그 그룹의 급여 합계(SUM(SALARY))를 구함

-- EMPLOYEE 테이블에서 직급코드가 같은 사람의 직급코드, 급여 평균, 인원 수를 직급코드 오름차순으로 조회
SELECT JOB_CODE, ROUND(AVG(SALARY)), COUNT(*) FROM EMPLOYEE e GROUP BY JOB_CODE ORDER BY 1;

-- EMPLOYEE 테이블에서 성별과 각 성별 별 인원수, 급여 합을 인원수 오름차순으로 조회
SELECT DECODE(SUBSTR(EMP_NO,8,1),1,'남',2,'녀') 성별,COUNT(*) 인원수, SUM(SALARY) "급여 합" FROM EMPLOYEE e GROUP BY DECODE(SUBSTR(EMP_NO,8,1),1,'남',2,'녀') ORDER BY 인원수;

----------------------------------------------------------------------------------------------------------

-- * WHERE 절 GROUP BY 절 혼합하여 사용하기 *

--> WHERE 절은 각 컬럼값에 대한 조건
--> HAVING 절은 그룹에 대한 조건

-- EMPLOYEE 테이블에서 부서코드가 D5,D6인 부서의 부서코드, 평균 급여, 인원수 조회
SELECT DEPT_CODE 부서, ROUND(AVG(SALARY)) "평균 급여", COUNT(*) FROM EMPLOYEE e WHERE DEPT_CODE IN('D5','D6') GROUP BY DEPT_CODE;

-- EMPLOYEE 테이블에서 2000년도 이후의 입사자들의 직급코드, 직급별 급여 합을 조회
SELECT JOB_CODE 직급, SUM(SALARY) "급여 합" FROM EMPLOYEE e WHERE e.HIRE_DATE >= '2000-01-01' GROUP BY JOB_CODE;
SELECT JOB_CODE 직급, SUM(SALARY) "급여 합" FROM EMPLOYEE e WHERE EXTRACT(YEAR FROM HIRE_DATE)>=2000 GROUP BY JOB_CODE;
SELECT JOB_CODE 직급, SUM(SALARY) "급여 합" FROM EMPLOYEE e WHERE TO_CHAR(HIRE_DATE,'YYYY')>=2000 GROUP BY JOB_CODE;

----------------------------------------------------------------------------------------------------------
-- 여러 컬럼을 묶어 그룹으로 지정하는 것이 가능하다 -> 그룹 내 그룹이 가능하다

-- *GROUP BY 사용시 주의사항*
-- SELECT 문에 GROUP BY절을 사용하는 경우
-- SELECT 절에 명시한 조회하려는 컬럼 중 그룹함수가 적용되지 않은 컬럼은 모두 GROUP BY 절에 작성되어있어야함

-- EMPLOYEE 테이블에서 부서별로 같은 직급인 사원의 인원수를 조회
-- 부서코드 오름차순, 직급코드 내림차순으로 정렬
-- 부서코드, 직급코드, 인원수
SELECT DEPT_CODE 부서, JOB_CODE 직급, COUNT(*) 인원수 FROM EMPLOYEE e GROUP BY e.DEPT_CODE, e.JOB_CODE ORDER BY 부서, 직급 DESC;

----------------------------------------------------------------------------------------------------------

-- * HAVING 절 : 그룹함수로 구해올 그룹에 대한 조건을 설정할 때 사용
-- HAVING 컬럼명 | 함수식 비교연산자 비교값

-- EMPLOYEE 테이블에서 부서별 평규ㄴ 급여가 300만원 이상인 부서의 부서코드, 평균 급여 조회
-- 부서코드 오름차순
SELECT DEPT_CODE 부서, ROUND(AVG(SALARY)) "평균 급여" FROM EMPLOYEE e GROUP BY e.DEPT_CODE HAVING AVG(SALARY)>=3000000 ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 직급별 인원수가 5명 이하인 직급코드, 인원수 조회
-- 직급코드 오름차순 정렬
SELECT JOB_CODE 직급, COUNT(*) "인원 수" FROM EMPLOYEE e GROUP BY e.JOB_CODE HAVING COUNT(*)<=5 ORDER BY 직급;
-- HAVING 절에는 반드시 그룹함수가 작성된다.

----------------------------------------------------------------------------------------------------------

-- 집계 함수(ROLLUP, CUBE)
-- 그룹 별 산출 결과 값의 집계를 계산하는 함수
-- (그룹별로 중간 집계 결과를 추가)
-- GROUP BY 절에만 사용할 수 있는 함수

-- ROLLUP : GROUP BY 절에서 가장 먼저 작성된 컬러므이 중간 집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE e 
GROUP BY ROLLUP(DEPT_CODE, e.JOB_CODE)
ORDER BY 1;

-- CUBE : GROUP BY 절에 작성된 모든 컬럼의 중간 집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE e 
GROUP BY CUBE(DEPT_CODE, e.JOB_CODE)
ORDER BY 1;

----------------------------------------------------------------------------------------------------------

/*
 * 집합 연산자(SET OPERATOR)
 * 
 * -- 여러 SELECT의 결과(RESULT SET)를 하나의 결과로 만드는 연산자
 * 
 * - UNION(합집합) : 두 SELECT 결과를 하나로 합침, 단 중복은 한번만 조회
 * 
 * - INTERSECT(교집합) : 두 SELECT 결과 중 중복되는 부분만 조회
 * 
 * - UNION ALL : UNION + INTERSECT 합집합에서 중복 부분 제거 X
 * 
 * - MINUS(차집합) : A에서 A,B의 교집합 부분을 제거하고 조회
 * 
 * */

-- EMPLOYEE 테이블에서
-- (1번째 SELECT문) 부서코드가 'D5'인 사원의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE e WHERE e.DEPT_CODE = 'D5'
-- UNION
-- INTERSECT
-- UNION ALL
MINUS
-- (2번째 SELECT문) 급여가 300만원 초과인 사원의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE e WHERE e.SALARY>3000000
ORDER BY EMP_ID;

-- 주의사항
-- 집합연산자를 사용하기 위한 SELECT문들은 조회하는 타입, 개수가 모두 동일해야 한다.

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE e 
WHERE DEPT_CODE = 'D5'

UNION

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE e 
WHERE SALARY>300000;
-- [조회하는 대상의 개수가 다를 때] SQL Error [1789] [42000]: ORA-01789: 질의 블록은 부정확한 수의 결과 열을 가지고 있습니다.
-- [조회하는 대상의 타입이 다를 때] SQL Error [1790] [42000]: ORA-01790: 대응하는 식과 같은 데이터 유형이어야 합니다.

-- 서로 다른 테이블도 컬럼의 타입, 개수만 일치하면 집합 연산자 사용가능

SELECT EMP_ID, EMP_NAME FROM EMPLOYEE e 
UNION
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT d;

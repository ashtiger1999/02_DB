-- SQL(Structured Query Langauge, 구조적 질의 언어)
-- 데이터베이스와 상호작용을 하기 위해 사용하는 표준 언어
-- 데이터의 조회, 삽입, 수정, 삭제 등

/*
 * SELECT (DML, DQL) : 조회
 * 
 * - 데이터를 조회(SELECT)하면 조건에 맞는 행들이 조회됨.
 * 이 때, 조회된 행들의 집합을 "RESULT SET"이라고 한다.
 * 
 * - RESULT SET은 0개 이상의 행을 포함할 수 있다.
 * 0개의 행을 포함할 수 있는 이유 : 조건에 맞는 행이 없을 수도 있어서.(NULL)
 * 
 * */

-- [작성법]
-- SELECT 컬럼명 FROM 테이블명;
--> 테이블의 특정 컬럼을 조회한다.

SELECT * FROM EMPLOYEE;
-- '*' : ALL, 전부, 모두
-- EMPLOYEE 테이블의 모든 컬럼을 조회한다.

-- EMPLOYEE 테이블에서 사번, 직원이름, 휴대전화 번호 컬럼만 조회
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE;

-----------------------------------------------------------------

-- <컬럼 값 산술연산>
-- 컬럼값 : 테이블 내 한 칸 (==한 셀)에 작성된 값(DATA)

-- EMPLOYEE TABLE에서 모든 사원의 사번, 이름, 급여, 연봉 조회
SELECT EMP_ID,EMP_NAME,SALARY,SALARY*12 FROM EMPLOYEE;

SELECT EMP_NAME + 10 FROM EMPLOYEE;
-- ORA-01722: 수치가 부적합합니다
-- 산술 연산은 숫자 타입(NUMBER 타입)만 가능

SELECT '같음' FROM DUAL WHERE 2*6 = '12';
-- '': 문자열을 의미
-- NUMBER 타입인 2*6(숫자)과 문자열인 '12'(문자)가 같다라고 인식
-- DUAL : ORACLE에서 사용하는 더미 테이블
-- 더미테이블 : 실제 데이터를 저장하는게 아닌, 임시 계산이나 테스트 목적 사용

-- 문자열 타입이어도 저장된 값이 숫자면 자동으로 형변환하여 연산 가능
SELECT EMP_ID + 10 FROM EMPLOYEE e;

-----------------------------------------------------------------

-- 날짜(DATE) 타입 조회

-- EMPLOYEE 테이블에서 이름, 입사일, 오늘 날짜 조회
SELECT EMP_NAME,HIRE_DATE,SYSDATE FROM EMPLOYEE;
-- 2025-03-07 15:48:44.000
-- SYSDATE : 시스템상의 현재 시간(날짜)를 나타내는 상수

SELECT SYSDATE FROM DUAL;
-- DUAL(DUMMY TABLE)

-- 날짜 + 산술연산(+,-)
SELECT SYSDATE-1,sysdate,sysdate+1 FROM dual;
-- 날짜에 +, - 연산시 일 단위로 계산

-----------------------------------------------------------------

-- 컬럼 별칭 지정
/*
 * 컬럼명 AS 별칭 : 별칭에 띄어쓰기 X, 특수문자 X, 문자만 가능
 * 
 * 컬럼명 AS "별칭" : 별칭에 띄어쓰기 O, 특수문자 O
 * 
 * AS 생략 가능
 * 
 * */
SELECT SYSDATE-1 "하루 전",sysdate 현재시간,sysdate+1 AS "내일" FROM dual;

-----------------------------------------------------------------

-- JAVA 리터럴 : 값 자체를 의미
-- DB 리터럴 : 임의로 지정한 값을 기존 테이블에 존재하는 값처험 사용하는 것
--> (필수) DB의 리터럴 표기법 '' 홑따옴표
SELECT emp_name, salary, '원 입니다' 문자열 FROM employee;

-----------------------------------------------------------------

-- DISTINCT : 조회 시 컬럼에 포함된 중복 값을 한번만 표기
-- 주의사항 1) DISTINCT 구문은 SELECT 마다 딱 한번씩만 작성 가능
-- 주의사항 2) DISTINCT 구문은 SELECT 제일 앞에 작성되어야한다.

SELECT DISTINCT dept_code, job_code FROM employee;

-----------------------------------------------------------------

-- SELECT 절 : SELECT 컬럼명 (3)
-- FROM 절 : FROM 테이블명 (1)
-- WHERE 절 : WHERE 컬럼명 연산자 값; (2)
-- ORDER BY 절 : ORDER BY 컬럼명 | 별칭 | 컬럼 순서 [ASC|DESC] [NULLS FIRST|LAST] (4)

-- EMPLOYEE 테이블에서 급여가 3백만원 초과인 사원의 사번,이름,급여,부서코드를 조회해라.

/*SELECT 절*/ SELECT EMP_ID,EMP_NAME,SALARY,DEPT_CODE /*FROM 절*/ FROM EMPLOYEE /*WHERE 절*/ WHERE SALARY>3000000;

-- 비교 연산자 : >,<,>=,<=,=(같다),!=,<>(같지 않다)
-- 대입 연산자 : :=

-- EMPLOYEE 테이블에서 부서코드가 D9인 사원의 사번, 이름, 부서코드, 직급코드를 조회
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE FROM EMPLOYEE WHERE DEPT_CODE = 'D9';

-- CTRL + SHIFT + 상하 방향키 : 줄이동
-- CTRL + ALT + 상하 방향키 : 줄복사

-----------------------------------------------------------------

-- 논리 연산자(AND,OR)

--EMPLOYEE 테이블에서 급여가 300만원 미만 또는 500만원 초과인 사원의 사번, 이름, 급여, 전화 번호 조회
SELECT EMP_ID,EMP_NAME,SALARY,PHONE FROM EMPLOYEE WHERE SALARY<3000000 OR SALARY>5000000;

--EMPLOYEE 테이블에서 급여가 300만원 이상 500만원 이하인 사원의 사번, 이름, 급여, 전화 번호 조회
SELECT EMP_ID,EMP_NAME,SALARY,PHONE FROM EMPLOYEE WHERE SALARY>=3000000 AND SALARY<=5000000;

-- BETWEEN A AND B : A 이상 B 이하
--EMPLOYEE 테이블에서 급여가 300만원 이상 500만원 이하인 사원의 사번, 이름, 급여, 전화 번호 조회
SELECT EMP_ID,EMP_NAME,SALARY,PHONE FROM EMPLOYEE WHERE SALARY BETWEEN 3000000 AND 5000000;

-- NOT 연산자
--EMPLOYEE 테이블에서 급여가 300만원 미만 또는 500만원 초과인 사원의 사번, 이름, 급여, 전화 번호 조회
SELECT EMP_ID,EMP_NAME,SALARY,PHONE FROM EMPLOYEE WHERE SALARY NOT BETWEEN 3000000 AND 5000000;

-- 날짜(DATE)에 BETWEEN 이용하기
-- EMPLOYEE 테이블에서 입사일이 1990-01-01~1999-12-31 사이인 직원의 이름, 입사일 조회
SELECT EMP_NAME,HIRE_DATE FROM EMPLOYEE WHERE HIRE_DATE BETWEEN'1990-01-01'AND'1999-12-31';

-----------------------------------------------------------------



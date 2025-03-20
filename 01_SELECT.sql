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

-- LIKE : 비교하려는 값이 특정한 패턴을 만족시키면 조회하는 연산자
-- [작성법]
-- WHERE 컬럼명 LIKE : '패턴이 적용된 값';

-- LIKE의 패턴을 나타내는 문자
-- '%' : 포함
-- '_' : 글자 수

-- '%' 예시
-- 'A%' : A로 시작하는 문자열
-- '%A' : A로 끝나는 문자열
-- '%A%' : A를 포함하는 문자열

-- '_' 예시
-- 'A_' (언더바 1개): A로 시작하는 두글자 문자열
-- '____A' (언더바 4개): A로 끝나는 다섯글자 문자열
-- '__A_' : A가 세번째 문자인 네글자 문자열
-- '___' (언더바 3개) : 세글자 문자열

-- EMPLOYEE 테이블에서 성이 '전'씨인 사원의 사번, 이름 조회
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE emp_name LIKE '전__';

-- EMPLOYEE 테이블에서 전화번호가 010으로 시작하지 않는 사원의 이름
SELECT emp_name,phone FROM EMPLOYEE e WHERE phone NOT LIKE '010%';

-- EMPLOYEE 테이블에서 EMAIL의 _앞 글자가 세개인 사람의 이름, 이메일 조회
SELECT emp_name, email FROM EMPLOYEE WHERE email LIKE '___^_%' ESCAPE '^';

-- ESCAPE 문자
-- ESCAPE 문자 뒤에 작성된 언더바는 일반 문자로 탈출한다는 뜻
-- #, ^
-- ESCAPE 문자는 모든 문자를 escape 문자로 선언할 수 있다
-- 하지만 가독성과 데이터 충돌 가능성 때문에 특수 문자(^, #, @ 등)를 사용하는 것이 일반적으로 추천된다.

-----------------------------------------------------------------

-- 연습문제

-- EMPLOYEE 테이블에서 
-- 이메일: '_' 앞이 4글자
-- 부서코드: 'D9' 또는 'D6' --> AND가 OR보다 우선순위가 높음
-- 입사일: 1990-01-01 ~ 2000-12-31
-- 급여: 270~
-- 사번, 이름, 이메일, 부서코드, 입사일, 급여 조회

SELECT emp_id,emp_name,email,dept_code,hire_date,salary 
FROM EMPLOYEE e 
WHERE (e.EMAIL LIKE '____^_%' ESCAPE '^')
AND(e.DEPT_CODE like 'D9' OR e.DEPT_CODE  like 'D6')
and(e.HIRE_DATE BETWEEN '1990-01-01' AND '2000-12-31')
and(salary>=2700000);

-- 연산자 우선순위

/*
 * 1. 산술 연산자 : +,-,/,*
 * 2. 연결 연산자 : ||
 * 3. 비교 연산자 : >,<,>=,<=,=,!=,<>
 * 4. is null/is not null, like/not like, in/not in
 * 5. between and/not between and
 * 6. 논리 연산자 : not
 * 7. 논리 연산자 : and
 * 8. 논리 연산자 : or
 * 
 * */

-----------------------------------------------------------------

/*
 * IN 연산자
 * 
 * 비교하려는 값과 목록에 작성된 값 중
 * 일치하는 것이 있으면 조회하는 연산자
 * 
 * [작성법]
 * WHERE 컬럼명 IN(값1, 값2, 값3, ...)
 * 
 * WHERE 컬럼명 = '값1'
 *    OR 컬럼명 = '값2'
 *    OR 컬럼명 = '값3'
 *    OR 컬럼명 = '...';
 * 
 * */

-- EMPLOYEE 테이블에서
-- 부서코드가 D1, D6, D9인 사원의
-- 사번, 이름, 부서코드 조회
SELECT emp_id,emp_name,dept_code FROM employee WHERE dept_code in('D1','D6','D9'); -- 9명(총원 23명)

SELECT emp_id,emp_name,dept_code FROM employee WHERE dept_code NOT in('D1','D6','D9') -- 12명(null 미포함)
OR dept_code IS NULL; -- 부서코드가 없는(null) 2명 포함 14명 조회

-----------------------------------------------------------------

/*
 * JAVA에서 NULL : 참조하는 객체가 없음을 의미
 * DB에서 NULL : 컬럼에 값이 없음을 의미
 * 
 * IS NULL : NULL인 경우 조회
 * IS NOT NULL : NULL이 아닌 경우 조회
 * 
 * */

-- EMPLOYEE 테이블에서 보너스가 있는 사원의 이름, 보너스 조회
SELECT emp_name,bonus
FROM employee
WHERE bonus IS NOT NULL; -- 9행

-- EMPLOYEE 테이블에서 보너스가 없는 사원의 이름, 보너스 조회
SELECT emp_name,bonus
FROM employee
WHERE bonus IS NULL; -- 14행

/*
 * ORDER BY 절
 * 
 * - SELECT 문의 조회 결과(RESULT SET)를 정렬할 때 사용하는 구문
 * 
 * ** SELECT 문 해석 시 가장 마지막에 해석된다. 
 * 
 * */

-- EMPLOYEE 테이블에서 급여오름 차순으로 사번, 이름, 급여 조회

SELECT emp_id,emp_name,salary FROM employee ORDER BY SALARY; -- ASC(오름차순)가 기본값 [ASC|DESC]
-- 컴럼명 사용

-- EMPLOYEE 테이블에서 급여가 200만원 이상인 사원의 사번, 이름, 급여조회
-- 단, 급여 내림 차순
SELECT emp_id, emp_name, salary FROM employee WHERE salary >= 2000000 ORDER BY 3 DESC; -- ORDER BY 문에 숫자를 입력하면 컬럼의 위치를 선택하여 사용하는 방법이다.

-- 입사일 순서대로 이름, 입사일 조회(별칭 사용)
SELECT emp_name 이름,hire_date 입사일 FROM EMPLOYEE e ORDER BY 입사일;

/*정렬 중첩 : 대분류 정렬 후 소분류 정렬*/
-- 부서코드 오름차순 정렬 후 급여 내림차순 정렬
SELECT emp_name, DEPT_code, salary
FROM employee ORDER BY DEPT_CODe, salary DESC;


					select emp_id,emp_name,decode(substr(emp_no,8,1),1,'남',2,'녀') 성별,salary,job_name,dept_title
					from employee
					join job using(job_code)
					left join department on(dept_id = dept_code)
					where substr(emp_no,8,1) = 2
					and salary between 3000000 and 4000000
					order by salary DESC;

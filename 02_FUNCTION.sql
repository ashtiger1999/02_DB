-- 함수 : 컬럼의 값을 읽어서 연산을 한 결과를 반환

-- 단일 행 함수 : N개의 값을 읽어서 연산 후 N개의 결과를 반환

-- 그룹 함수 : N개의 값을 읽어서 연산 후 1개의 결과를 반환(합계, 평균, 최대, 최소)

-- 함수는 SELECT 문의
-- SELECT 절, WHERE 절, ORDER BY절, GROUP BY절, HAVING 절 사용 가능

------------------------------단일 행 함수------------------------------

-- LENGTH(컬럼명 | 문자열) : 길이 반환

SELECT email, LENGTH(email) FROM employee ORDER BY 2;

SELECT LENGTH('가나다라마바사') FROM dual;

----------------------------------------------------------------------

-- INSTR(컬럼명 \ 문자열, '찾을 문자열' [,찾기 시작할 위치[, 순번]]) ;[]는 생략 가능
-- 지정한 위치부터 지정한 순번째로 검색되는 문자의 위치를 반환

-- AABAACAABBAA

-- 문자열을 앞에서부터 검색하여 첫번째 B의 위치 조회
SELECT instr('AABAACAABBAA', 'B') FROM dual; -- 3

-- 문자열을 다섯번째 문자열부터 검색하여 첫번째 B의 위치 조회
SELECT instr('AABAACAABBAA', 'B',5) from dual; -- 9

-- 문자열을 다섯번째 문자열부터 검색하여 두번째 B의 위치 조회
SELECT instr('AABAACAABBAA','B',5,2) FROM dual; -- 10

--EMPLOYEE 테이블에서 사원명, 이메일, 이메일 중'@' 위치 조회
SELECT emp_name, email, instr(email,'@') FROM employee;

----------------------------------------------------------------------

-- SUBSTR(컬럼명 | 문자열, 잘라내기 시작할 위치 [,잘라낼 길이])
-- 컬럼이나 문자열에서 지정한 위치부터 지정된 길이만큼 문자열을 잘라내서 반환
-- 잘라낼 길이 생략 시, 끝까지 잘라냄

-- EMPLOYEE 테이블에서 사원명, 이메일 중 아이디만 조회
-- sun_di@or.kr -> sun_di
SELECT emp_name 이름, SUBSTR(email, 1, INSTR(email, '@')-1) 아이디 FROM EMPLOYEE;

----------------------------------------------------------------------

-- TRIM([[옵션] 컬럼명 | 문자열 FROM] 컬럼명 | 문자열)
-- 주어진 컬럼이나 문자열의 앞, 뒤, 영쪽에 있는 지정된 문자를 제거
--> 앞쪽 공백 제거에 많이 사용함

-- 옵션 : LEADING(앞쪽), TRAILING(뒤쪽), BOTH(양쪽, 기본값)

SELECT TRIM('    H E L L O    ') FROM dual;

SELECT TRIM(trailing '#' FROM '####H#E#L#L#O####') FROM dual;

----------------------------------------------------------------------

-- 숫자 관련 함수

-- ABS(컬럼명 | 숫자) : 절대값

SELECT abs(-10), abs(10) FROM dual;

SELECT '절대값 같음' 결과 FROM dual WHERE abs(10) = abs(-10);

-- MOD(컬럼명 | 숫자, 컬럼명 | 숫자) : 나머지 값 반환
SELECT MOD(10,3) 결과 FROM dual;

-- EMPLOYEE 테이블에서 사원의 월급을 100만으로 나누었을 때의 나머지를 구해라
SELECT emp_name 이름, salary 월급, mod(salary,1000000) 나머지 FROM EMPLOYEE e ;

-- EMPLOYEE 테이블에서 사번이 짝수인 사원의 사번, 이름 조회
SELECT emp_id, emp_name FROM employee WHERE mod(emp_id,2)=0;

-- EMPLOYEE 테이블에서 사번이 홀수인 사원의 사번, 이름 조회
SELECT emp_id, emp_name FROM employee WHERE mod(emp_id,2)!=0;
SELECT emp_id, emp_name FROM employee WHERE mod(emp_id,2)<>0;
SELECT emp_id, emp_name FROM employee WHERE NOT mod(emp_id,2)=0;

-- ROUND(컬럼명 | 숫자 [,소수점 위치]) : 반올림

SELECT round(123.456) FROM dual; -- 123, 소수점 첫번째 자리에서 반올림

SELECT round(123.456, 1) FROM dual; -- 123.5, 소수점 두번째 자리에서 반올림(소수점 첫번째 자리까지 표기)

-- CEIL(컬럼명 | 숫자) : 올림
-- FLOOR(컬럼명 | 숫자) : 내림
SELECT CEIL(123.1), floor(123.9) FROM dual;

-- TRUNC(컬럼명 | 숫자 [,위치]) : 특정 위치 아래를 절삭
SELECT trunc(123.456) FROM dual; -- 123, 소수점 아래를 절삭
SELECT trunc(123.456, 1) FROM dual; -- 123.4, 소수점 아래를 절삭

----------------------------------------------------------------------

-- 날짜(DATE) 관련 함수

-- SYSDATE : 시스템에 현재 시간(년,월,일,시,분,초)을 반환 --상수
SELECT sysdate FROM dual; -- 2025-03-10 12:11:49.000

-- SYSTIMESTAMP : SYSDATE + MS 단위 추가
SELECT SYStimestamp FROM dual; -- 2025-03-10 12:12:42.163 +0900

-- MONTH_BETWEEN(날짜, 날짜): 두 날짜의 개월 수 차이 반환
SELECT abs(round(MONTHs_BETWEEN(sysdate, '2025-07-22'),3)) 남은_수강_개월 FROM dual; -- 4.371

-- EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무한 개월수 근무 년차 조회
SELECT emp_name 이름, hire_date 입사일, ceil(MONTHS_BETWEEN(sysdate, hire_date))||'개월' 근무_월, ceil(MONTHS_BETWEEN(sysdate, hire_date)/12)||'연차' 근무_연 FROM employee order BY hire_date desc;

-- || : 연결 연산자(문자열 이어쓰기)

-- ADD_MONTHS(날짜, 숫자) : 날짜에 숫자만큼의 개월 수를 더함(음수도 가능)
SELECT add_months(sysdate,4)FROM dual; -- 4개월 더함
SELECT add_months(sysdate,-1)FROM dual; -- 1개월 뺌

-- LAST_DAY(날짜) : 해당 달의 마지막 날짜를 구함
SELECT last_day(sysdate) FROM dual;

SELECT last_day('2020-02-01') FROM dual;

-- EXTRACT : 년,월,일 정보를 추출하여 리턴(반환)
-- EXTRACT(YEAR FROM 날짜) : 년도만 추출
-- EXTRACT(MONTH FROM 날짜) : 월만 추출
-- EXTRACT(DAY FROM 날짜) : 일만 추출

-- EMPLOYEE 테이블에서 각 사원의 이름, 입사일 조회(입사년도, 월, 일)
-- ex) 2000년 10월 10일
SELECT emp_name 이름, EXTRACT(YEAR FROM hire_date)||'년 '||EXTRACT(month FROM hire_date)||'월 '||EXTRACT(day FROM hire_date)||'일' 입사일 FROM EMPLOYEE ORDER BY hire_date;

----------------------------------------------------------------------

--  형변환 함수
-- 문자열(CHAR), 숫자(NUMBER), 날짜(DATE) 끼리 형변환 가능

-- 문자열로 변환
-- TO_CHAR(숫자 || 날짜 [,포멧]) : 숫자형 || 날짜형 데이터를 문자형 데이터로 변경

-- 포멧
-- 숫자 -> 문자 변환시 포멧 패턴
-- 9 : 숫자 한칸을 의미, 여러개 작성 시 오른쪽 정렬
-- 0 : 숫자 한칸을 의미, 여러개 작성 시 오른쪽 정렬 + 빈칸 0채우
-- L : 현재 DB에 설정된 나라의 화폐 기호

SELECT to_char(1234,'999999')FROM dual; -- '  1234'
SELECT to_char(1234,'000000')FROM dual; -- '001234'
SELECT to_char(1234)FROM dual; -- '1234'

SELECT to_char(1000000,'9,999,999')||' won'FROM dual; -- '1234'
SELECT to_char(1000000,'l9,999,999')FROM dual; -- '1234'

-- 날짜 -> 문자 변환시 포멧 패턴
-- YYYY : 년도 / YY : 년도(10의 자리까지)
-- MM : 월
-- DD : 일
-- AM / PM : 오전/오후 표시
-- HH : 시간 / HH24 : 24시간 표기법
-- MI : 분 / SS : 초
-- DAY : 요일(요일 전체) / DY : 요일(요일 앞글자만)

SELECT to_char(sysdate, 'YYYY/MM/DD HH:MI:SS DAY') 현재시간 FROM dual;

SELECT to_char(sysdate, 'MM/DD (DY)') FROM dual;

SELECT to_char(sysdate, 'YYYY"년" MM"월" DD"일" (DY)') FROM dual;

----------------------------------------------------------------------

-- 날짜로 변환 TO_DATE

--  TO_DATE(문자열 | 숫자열 [,포멧]) : 문자형 | 숫자형 데이터 -> 날짜형 데이터로 변환
--> 지정된 포멧으로 날짜를 인식함

SELECT to_date('2025-03-10') FROM dual; -- 2025-03-10 00:00:00.000
SELECT to_date(20250310) FROM dual; -- 2025-03-10 00:00:00.000

SELECT to_date('250310 140730','YYMMDD HH24MISS') FROM dual;
-- SQL Error [1861] [22008]: ORA-01861: 리터럴이 형식 문자열과 일치하지 않음
--> 패턴을 적용해서 작성된 문자열의 각 문자가 어떤 날짜 형식인지 인식 시킴

-- Y 패턴 : 현재 세기(21세기 == 20XX년 == 2000년대)
-- R 패턴 : 1세기를 기준으로 절반(50년) 이상인 경우, 이전세기(1900년대)
--                      절반(50년) 미만인 경우, 현재세기(2000년대)
SELECT to_date('800505','YYMMDD')FROM dual; -- 2080-05-05 00:00:00.000
SELECT to_date('800505','RRMMDD')FROM dual; -- 1980-05-05 00:00:00.000
SELECT to_date('490505','RRMMDD')FROM dual; -- 2049-05-05 00:00:00.000

-- EMPLOYEE 테이블에서 각 직원이 태어난 생년월일을 조회
SELECT emp_name 이름, emp_no 생년월일 FROM EMPLOYEE e ;
SELECT emp_name 이름, SUBSTR(emp_no, 1, instr(emp_no,'-')-1) 생년월일 FROM EMPLOYEE e ;
SELECT emp_name 이름, to_date(SUBSTR(emp_no, 1, instr(emp_no,'-')-1),'RRMMDD') 생년월일 FROM EMPLOYEE e ;
SELECT emp_name 이름, to_char(to_date(SUBSTR(emp_no, 1, instr(emp_no,'-')-1),'RRMMDD'),'YYYY"년" MM"월" DD"일"') 생년월일 FROM EMPLOYEE e ;

----------------------------------------------------------------------

-- 숫자로 형변환
-- To_NUMBER(문자데이터 [,포멧]) : 문자형 데이터를 숫자 데이터로 변경

SELECT to_number('1,000,000','9,999,999') + 500000 FROM dual; -- 1,500,000

-- NULL 처리 함수
-- NVL(컬럼명, 컬럼값이 NULL 일 때 바꿀 값) : NULL 인 컬럼값을 다름 값으로 변경
SELECT * FROM employee;

SELECT emp_name, salary, nvl(bonus,0) FROM employee;

-- NULL과 산술 연산을 진행하면 결과는 무조건 NULL
SELECT emp_name,salary,nvl(bonus,0),nvl(salary*bonus,0) FROM EMPLOYEE;

-- NVL2(컬럼명, 바꿀값1, 바꿀값2)
-- 해당 컬럼의 값이 있으면 바꿀값1, 없으면 바꿀값2로 변경
SELECT bonus,nvl2(bonus,'있음','없음') FROM EMPLOYEE e ;

-- EMPLOYEE 테이블에서 보너스를 받으면 'O', 받지 않으면 'X' 조회
SELECT emp_name 이름,nvl2(bonus,'O','X') 보너스_수령_여부 FROM employee;

----------------------------------------------------------------------

-- 선택 함수
-- 여러가지 경우에 따라 알맞은 결과를 선택할 수 있음

-- DECODE(컬럼명 | 계산식, 조건값1, 선택값1, 조건값2, 선택값2, ..., 아무것도 일치하지 않을때)
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과 값 반환

-- 직원의 성별 구하기
SELECT emp_name 이름, decode(substr(emp_no,8,1),1,'남',2,'여') 성별 FROM employee;

/*
 * 직원의 급여를 인상하려고 한다
 * 직급 코드가 J7인 직원은 20% 인상
 * 직급 코드가 J6인 직원은 15% 인상
 * 직급 코드가 J5인 직원은 10% 인상
 * 그 외 직급은 5% 인상
 * 이름, 직급 코드, 급여, 인상률, 인상된 급여 조회
 * 
 */
SELECT emp_name 이름, job_code 직급, salary 급여, decode(job_code,'J7','20%','J6','15%','J5','10%','5%') 인상률, 
salary+salary*to_number(SUBSTR(decode(job_code,'J7','20%','J6','15%','J5','10%','5%'),1,1))/100 인상 FROM employee;

SELECT emp_name 이름, job_code 직급, salary 급여, decode(job_code,'J7','20%','J6','15%','J5','10%','5%') 인상률,
decode(job_code,'J7',salary*1.2,'J6',salary*1.15,'J5',salary*1.1,salary*1.05) 인상 FROM employee;

-- CASE WHEN 조건식 THEN 결과값
-- WHEN 조건식 THEN 결과값
-- END 결과값

-- 비교하고자하는 값 또는 컬럼이 조건식과 같으면 결과값을 반환
-- 조건은 범위값 가능

/*
 * EMPLOYEE 테이블에서
 * 급여가 500만원 이상이면 '대'
 * 급여가 300만원 이상 500만원 미만이면 '중'
 * 급여가 300만원 미만이면 '소'
 * 사원 이름, 급여, 급여 받는 정도 조회
 * 
 * */

SELECT emp_name 이름, salary 급여, 
CASE WHEN salary >= 5000000 THEN '대' -- if
WHEN salary >= 3000000 AND salary < 5000000 THEN '중' -- else if
ELSE '소' -- else
END 급여수준
FROM employee;

----------------------------------------------------------------------

-- 그룹 함수
-- 하나 이상의 행을 그룹으로 묶어 연산하여 총합, 평균 등의
-- 하나의 결과 행으로 반환하는 함수

-- SUM(숫자가 기록된 컬럼명) : 합계

-- 모든 직원의 급여 합 조회
SELECT sum(salary) FROM employee; -- 70096240

-- AVG(숫자가 기록된 컬럼명) : 평균
SELECT avg(salary) FROM employee; -- 3047662.60869565217391304347826086956522
SELECT round(avg(salary)) FROM employee; -- 3047663

-- 부서 코드가 'D9'인 사원들의 급여 합, 평균
SELECT sum(salary) 총급여, round(avg(salary)) 급여평균 FROM EMPLOYEE WHERE dept_code='D9';

-- MIN(컬럼명) : 최소값
-- MAX(컬럼명) : 최대값
--> 타입 제한 없음(숫자: 대/소, 날짜: 과거/미래, 문자열: 문자 순서)

-- 급여 최소값, 가장 빠른 입사일, 알파벳 순서가 가장 빠른 이메일 조회
SELECT min(salary), min(hire_date), min(email) FROM employee;

-- 급여 최대값, 가장 최근 입사일, 알파벳 순서가 가장 느린 이메일 조회
SELECT max(salary), max(hire_date), max(email) FROM employee;

/*
 * EMPLOYEE 테이블에서
 * 급여를 가장 많이 받는 사원의
 * 이름, 급여, 직급코드를 조회
 * 
 * */
SELECT emp_name 이름, salary 급여, job_code 직급코드 FROM employee WHERE salary = (SELECT max(salary) FROM employee);

-- 서브쿼리 + 그룹함수 : 
SELECT max(salary) FROM employee;

-- COUNT() : 행 개수를 헤아려서 반환
-- COUNT(컬럼명) : NULL을 제외한 실제값이 기록된 행 개수를 리턴
-- COUNT(*) : NULL을 포함한 전체 행 개수를 리턴
-- COUNT([DISTINCT] 컬럼명) : 중복을 제거한 행 개수를 리턴

SELECT count(bonus) FROM employee;
SELECT count(*) FROM employee;
SELECT count(DISTINCT job_code) FROM employee;

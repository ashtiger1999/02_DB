/*
[JOIN 용어 정리]
오라클                                   SQL : 1999표준(ANSI)
----------------------------------------------------------------------------------------------------------------
등가 조인                                 내부 조인(INNER JOIN), JOIN USING / ON
                                        + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
----------------------------------------------------------------------------------------------------------------
포괄 조인                                 왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                        + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
----------------------------------------------------------------------------------------------------------------
자체 조인, 비등가 조인                       JOIN ON
----------------------------------------------------------------------------------------------------------------
카테시안(카티션) 곱                         교차 조인(CROSS JOIN)
CARTESIAN PRODUCT

- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/

/*
-- JOIN
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
-- 수행 결과는 하나의 Result Set으로 나옴.

-- (참고) JOIN은 서로 다른 테이블의 행을 하나씩 이어 붙이기 때문에
--       시간이 오래 걸리는 단점이 있다!
*/

/*
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.

- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
  원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서
  데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데,
  두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨.  
*/
----------------------------------------------------------------------------------------------------------------

-- 사번, 이름, 부서코드
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE e;

SELECT * FROM EMPLOYEE e;
-- 부서명은 DEPARTMENT 테이블에서 조회 가능
SELECT * FROM DEPARTMENT d;

-- EMPLOYEE 테이블의 DEPT_CODE와
-- DEPARTMENT 테이블의 DEPT_ID를 연결고리 지정
SELECT * FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 1. 내부 조인 (INNER JOIN)(== 등가 조인(EQAUL JOIN))
--> 연결되는 컬럼의 값이 일치하는 행들만 조인됨
--> 일치하는 값이 없는 행은 조인에서 제외됨

-- 작성 방법은 크게 ANSI 구문과 오라클 구문으로 나뉘고
-- ANSI에서 USING과 ON을 쓰는 방법으로 나뉜다.

-- 1) 연결에 사용할 두 컬럼명이 다른 경우

-- ANSI
-- 연결에 사용할 컬럼명이 다른 경우(ON)을 사용
SELECT * FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- ORACLE
SELECT * FROM EMPLOYEE, DEPARTMENT d T WHERE DEPT_CODE = DEPT_ID;

-- DEPARTMENT 테이블. LOCATION 테이블을 참조하여 부서명, 지역명 조회

SELECT * FROM DEPARTMENT d;
SELECT * FROM LOCATION l;

-- ANSI
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT d
JOIN LOCATION l ON(d.LOCATION_ID = l.LOCAL_CODE );

-- ORACLE
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT d, LOCATION l 
WHERE d.LOCATION_ID = l.LOCAL_CODE;


-- 2) 연결에 사용할 두 컬럼명이 같은 경우

-- EMPLOYEE, JOB 테이블 참조하여
-- 사번, 이름, 직급코드, 직급명 조회

SELECT * FROM EMPLOYEE e;
SELECT * FROM JOB j;

-- ANSI
-- 연결에 사용할 컬럼명이 같은 경우, USING(컬럼명)을 사용할 수 있다
SELECT * FROM EMPLOYEE e JOIN JOB j USING(JOB_CODE);

-- ORACLE
SELECT EMP_NAME, E.JOB_CODE FROM EMPLOYEE e, JOB j WHERE E.JOB_CODE = J.JOB_CODE;
-- 중복된 컬럼의 출처도 밝혀야 한다.

-- INNER JOIN(내부 조인)의 특징
--> 연결에 사용된 컬럼의 값이 일치하지 않으면 조회결과에 포함되지 않는다.

----------------------------------------------------------------------------------------------------------------

-- 2. 외부조인(OUTER JOIN)

-- 두 테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함시킴
-- * OUTER JOIN을 반드시 명시해야 한다.

SELECT * FROM EMPLOYEE e /*INNER*/JOIN JOB j USING(JOB_CODE);

-- 1) LEFT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의 컬럼수를 기준으로 조인
--> 왼편에 작성된 테이블의 모든 행이 결과에 포함되어있어야 한다.
-- JOIN이 안되는 행도 결과에 포함 ex)NULL

-- ANSI
SELECT EMP_NAME,DEPT_TITLE FROM EMPLOYEE e
LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID); -- 23행(DEPT_CODE가 NULL인 행도 포함)

-- ORACLE
SELECT EMP_NAME,DEPT_TITLE FROM EMPLOYEE e, DEPARTMENT d WHERE E.DEPT_CODE = d.DEPT_ID(+);
-- 반대측 테이블 컬럼에 (+)기호를 작성

-- 2) RIGHT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 오른편에 기술된 테이블의 컬럼수를 기준으로 조인

-- ANSI
SELECT EMP_NAME,DEPT_TITLE FROM EMPLOYEE e
RIGHT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID); -- 24행(DEPT_ID의 값이 DEPT_CODE에 없는 경우를 추가)

-- ORACLE
SELECT EMP_NAME,DEPT_TITLE FROM EMPLOYEE e, DEPARTMENT d WHERE E.DEPT_CODE(+) = d.DEPT_ID;
-- 반대측 테이블 컬럼에 (+)기호를 작성

-- 3) FULL [OUTER] JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함
-- ** 오라클 구문 FULL OUTER JOIN 따로 없음 **

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE e
FULL JOIN DEPARTMENT d ON(d.DEPT_ID = e.DEPT_CODE);

----------------------------------------------------------------------------------------------------------------

-- 3. 교차 조인(CROSS JOIN)
-- 조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 조회방법
--> JOIN 구문을 잘못 작성하는 경우, CROSS JOIN이 발생하는 경우가 대부분(의도적으로 사용하는 경우가 드문 방식)

----------------------------------------------------------------------------------------------------------------

-- 4. 비등가 조인(NONE EQUAL JOIN)

-- '=' 등호를 사용하지 않는 조건문
-- 지정한 컬럼값이 일치하는 경우가 아닌, 값의 범위에포함되는 행들을 연결하는 방식
SELECT * FROM SAL_GRADE sg;
SELECT EMP_NAME,SAL_LEVEL FROM EMPLOYEE e;

-- 사원의 급여에 따른 급여 등급 파악하기
SELECT EMP_NAME,SALARY,SG.SAL_LEVEL FROM EMPLOYEE e
JOIN SAL_GRADE sg ON(SALARY BETWEEN sg.MIN_SAL AND sg.MAX_SAL);

----------------------------------------------------------------------------------------------------------------

-- 5. 자체조인(SELF JOIN)
-- 같은 테이블을 조인
-- 자기 자신과 조인을 맺음
-- TIP 같은 테이블 2개 있다고 생각하고 JOIN 진행
-- 테이블마다 별칭 작성(미작성시 열의 정의가 애매하다는 오류 발생)

-- 사번, 이름, 사수의 사번, 사수 이름 조회
-- 단, 사수가 없으면 '없음', '-' 조회

-- ANSI
SELECT*FROM EMPLOYEE e;
SELECT E.EMP_ID 사번, E.EMP_NAME 이름, NVL(e.MANAGER_ID,'-') "사수의 사번", NVL(M.EMP_NAME,'-') 사수 FROM EMPLOYEE e LEFT JOIN EMPLOYEE M ON(M.EMP_ID = E.MANAGER_ID) ORDER BY 사번;

-- ORACLE
SELECT E.EMP_ID 사번, E.EMP_NAME 이름, NVL(e.MANAGER_ID,'-') "사수의 사번", NVL(M.EMP_NAME,'-') 사수 FROM EMPLOYEE e, EMPLOYEE M WHERE M.EMP_NO(+) = E.MANAGER_ID ORDER BY 사번;

----------------------------------------------------------------------------------------------------------------

-- 6. 자연조인(NATURAL JOIN)
-- 동일한 타입과 이름을 가진 컬럼이 있는 테이블간의 조인을 간단히 표현하는 방법

-- 반드시 두 테이블간의 동일한 컬럼명, 타입을 가진 컬럼이 필요

--> 없는데도 자연조인을 이용할 경우 교차조인 결과가 조회됨
SELECT JOB_CODE FROM EMPLOYEE e;
SELECT JOB_CODE FROM JOB;

SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE e
NATURAL JOIN JOB;

SELECT DEPT_CODE FROM EMPLOYEE e;
SELECT DEPT_ID FROM DEPARTMENT d;

SELECT EMP_NAME, DEPT_CODE FROM EMPLOYEE e
NATURAL JOIN DEPARTMENT d;
--> 두 바교 대상의 컬럼명이 달라서 CROSS JOIN 발생

----------------------------------------------------------------------------------------------------------------

-- 7. 다중조인
-- N개의 테이블을 조인할 때 사용(순서 중요)

-- 사원 이름, 부서명, 지역멱 조회
-- EMP_NAME(EMPLOYEE)
-- DEPARTMENT_NAMR(DEPARTMENT)
-- LOCAL_NAME(LOCATION)

SELECT * FROM EMPLOYEE e;
SELECT * FROM DEPARTMENT d;
SELECT * FROM LOCATION l;

-- ANSI
SELECT E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME FROM EMPLOYEE e 
JOIN DEPARTMENT d ON(E.DEPT_CODE = D.DEPT_ID) 
JOIN LOCATION l ON(D.LOCATION_ID = L.LOCAL_CODE);

-- ORACLE
SELECT E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME 
FROM EMPLOYEE e, DEPARTMENT d, LOCATION l
WHERE e.DEPT_CODE = d.DEPT_ID
AND d.LOCATION_ID = l.LOCAL_CODE;

-- [다중 조인 연습 문제]

-- 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
-- 사번, 이름, 직급, 부서, 근무지역, 급여

SELECT e.EMP_ID 사번, e.EMP_NAME 이름, j.JOB_NAME 직급, d.DEPT_TITLE 부서, l.LOCAL_NAME 근무지역, e.SALARY 급여
FROM EMPLOYEE e 
JOIN JOB j ON(E.JOB_CODE = J.JOB_CODE )
AND J.JOB_NAME = '대리'
JOIN DEPARTMENT d ON(E.DEPT_CODE  = D.DEPT_ID )
JOIN LOCATION l ON(D.LOCATION_ID = L.LOCAL_CODE )
AND l.LOCAL_NAME LIKE 'ASIA%';


SELECT e.EMP_ID 사번, e.EMP_NAME 이름, j.JOB_NAME 직급, d.DEPT_TITLE 부서, l.LOCAL_NAME 근무지역, e.SALARY 급여
FROM EMPLOYEE e, JOB j, DEPARTMENT d, LOCATION l
WHERE E.JOB_CODE = J.JOB_CODE
AND J.JOB_NAME = '대리'
AND E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND L.LOCAL_NAME LIKE 'ASIA%';

----------------------------------------------------------------------------------------------------------------

-- [JOIN 연습문제]
-- 1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT E.EMP_NAME 사원명, E.EMP_NO 주민번호, D.DEPT_TITLE 부서명, J.JOB_NAME 직급명
FROM EMPLOYEE e, DEPARTMENT d, JOB j
WHERE E.DEPT_CODE = D.DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND e.EMP_NO LIKE '7%'
AND E.EMP_NAME LIKE '전%';

-- 2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 직급명, 부서명을 조회하시오.
SELECT E.EMP_ID 사번, E.EMP_NAME 사원명, J.JOB_NAME 직급명, D.DEPT_TITLE 부서명
FROM EMPLOYEE e
JOIN JOB j USING(JOB_CODE)
JOIN DEPARTMENT d ON(E.DEPT_CODE = D.DEPT_ID )
WHERE E.EMP_NAME LIKE '%형%';

-- 3. 해외영업 1부, 2부에 근무하는 사원의 사원명, 직급명, 부서코드, 부서명을 조회하시오.
SELECT E.EMP_NAME 사원명, J.JOB_NAME 직급명, D.DEPT_ID 부서코드, D.DEPT_TITLE 부서명
FROM EMPLOYEE e, JOB j, DEPARTMENT d
WHERE E.JOB_CODE = J.JOB_CODE
AND E.DEPT_CODE = D.DEPT_ID
AND d.DEPT_TITLE IN('해외영업1부','해외영업2부');

-- 4. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
SELECT E.EMP_NAME 사원명, E.BONUS 보너스포인트, D.DEPT_TITLE 부서명, L.LOCAL_NAME 근무지역명
FROM EMPLOYEE e 
LEFT JOIN DEPARTMENT d ON(E.DEPT_CODE = D.DEPT_ID )
LEFT JOIN LOCATION l ON(D.LOCATION_ID = L.LOCAL_CODE )
WHERE E.BONUS IS NOT NULL
ORDER BY 근무지역명;

-- 5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT E.EMP_NAME 사원명, J.JOB_NAME 직급명, D.DEPT_TITLE 부서명, L.LOCAL_NAME 지역명
FROM EMPLOYEE e , JOB j , DEPARTMENT d , LOCATION l 
WHERE E.JOB_CODE = J.JOB_CODE
AND E.DEPT_CODE  = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND d.DEPT_ID IS NOT NULL;

-- 6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의 사원명, 직급명, 급여, 연봉(보너스포함)을 조회하시오. (연봉에 보너스포인트를 적용하시오.)
SELECT E.EMP_NAME 사원명, J.JOB_NAME 직급명, E.SALARY 급여, E.SALARY*12*(1+NVL(E.BONUS,0)) "연봉(보너스포함)"
FROM EMPLOYEE e 
JOIN JOB j USING(JOB_CODE)
JOIN SAL_GRADE sg USING(SAL_LEVEL)
WHERE E.SALARY > SG.MIN_SAL;

-- 7.한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT E.EMP_NAME 사원명, D.DEPT_TITLE 부서명, L.LOCAL_NAME 지역명, N.NATIONAL_NAME 국가명
FROM EMPLOYEE e, DEPARTMENT d, LOCATION l, NATIONAL n 
WHERE E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND N.NATIONAL_CODE IN('KO','JP')
ORDER BY E.EMP_ID;

-- 8. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.(SELF JOIN 사용)
SELECT E.EMP_NAME 사원명, E.DEPT_CODE 부서코드, P.EMP_NAME 동료이름
FROM EMPLOYEE e
JOIN EMPLOYEE P ON(E.DEPT_CODE = P.DEPT_CODE )
WHERE E.EMP_NAME <> P.EMP_NAME
ORDER BY 사원명;

-- 9. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오. (단, JOIN, IN 사용할 것)
SELECT E.EMP_NAME 사원명, J.JOB_NAME 직급명, E.SALARY 급여
FROM EMPLOYEE e 
JOIN JOB j ON(E.JOB_CODE = J.JOB_CODE )
WHERE E.BONUS IS NULL 
AND E.JOB_CODE IN('J4','J7');
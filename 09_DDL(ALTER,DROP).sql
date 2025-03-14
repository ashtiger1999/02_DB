-- DDL(Data Definition Language)
-- 객체를 만들고(CREATE), 바꾸고(ALTER), 삭제(DROP) 하는 데이터 정의 언어

/*
 * ALTER(바꾸다, 수정하다, 변조하다)
 * 
 * -- 테이블에서 수정할 수 있는 것
 * 1) 제약 조건(추가/삭제)
 * 2) 컬럼(추가/수정/삭제)
 * 3) 이름변경 (테이블명, 컬럼명..)
 * 
 * */

-- 1) 제약조건(추가/삭제)-- 

-- [작성법]
-- 1) 추가 : ALTER TABLE 테이블명
--			ADD [CONSTRAINT 제약조건명] 제약조건(지정할컬럼명)
--			[REFERENCES 테이블명[(컬럼명)]]; <-- FK 인 경우 추가

-- 2) 삭제 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

-- * 제약조건 자체를 수정하는 구문은 별도 존재하지 않음!
--> 삭제 후 추가를 해야함.

-- DEPARTMENT 테이블 복사(컬럼명, 테이터타입, 제약조건 NOT NULL 만 복사)
CREATE TABLE DEPT_COPY 
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 추가
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE);

-- DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 삭제
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DEPT_COPY_TITLE_U;

-- *** DEPT_COPY의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가 / 삭제 ***
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_NN NOT NULL(DEPT_TITLE);
--> NOT NULL 제약조건은 새로운 조건을 추가하는 것이 아닌, 컬럼 자체에 NULL 허용/비허용을 제어하는 성질 변경의 형태로 인식됨.

-- MODIFY (수정) 구문을 이용해서 NULL 제어(컬럼의 데이터 타입 수정)
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NOT NULL; -- DEPT_TITLE 컬럼에 NOT NULL 적용

ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NULL;

-----------------------------------------------------------------------------------------------------------

-- 2. 컬럼(추가/수정/삭제)

-- 컬럼 추가
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);

-- 컬럼 수정
-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입; --> 데이터 타입 변경

-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값'; --> DEFAULT 값 변경

-- 컬럼 삭제
-- ALTER TABLE 테이블명 DROP (삭제할컬럼명);
-- ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;

SELECT * FROM DEPT_COPY;

-- CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD (CNAME VARCHAR2(30));
-- 새로 추가된 컬럼에 있는 값은 NULL

-- LNAME 컬럼 추가(기본갑 '한국')
ALTER TABLE DEPT_COPY ADD (LNAME VARCHAR2(30) DEFAULT '한국');

-- D10 개발1팀 추가
INSERT INTO DEPT_COPY  VALUES ('D10','개발1팀','L1',NULL,DEFAULT); 
-- ORA-12899: "KH"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼(실제: 3, 최대값: 2)
--> DEPT_ID의 자료형 == CHAR(2) --> 두글자 이하의 (영어|숫자)문자열만 올 수 있음

ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR2(3);

-- LNAME의 기본 값을 'KOREA'로 수정
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KOREA';
-- 기본값(DEFULT)를 수정해도, 기존의 기본값에 의해 생성된 데이터는 변하지 않음
--> 이후로 생성되는 데이터만 영향을 받음

UPDATE DEPT_COPY SET LNAME = DEFAULT WHERE LNAME = '한국';

COMMIT;

-- DEPT_COPY 모든 컬럼 삭제
ALTER TABLE DEPT_COPY DROP (LNAME);
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
-- ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다

-- 컬럼 삭제 시 유의사항
-- 테이블이란? 행과 열로 이루어진 DB의 가장 기본적인 객체
--> 테이블 최소 1개 이사으이 컬럼이 존재해야하기 때문에
-- 모든 컬럼을 다 삭제할 순 없다.
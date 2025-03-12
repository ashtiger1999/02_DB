-- TCL (Transaction Control Language) : 트랜잭션 제어 언어
-- COMMIT, ROLLBACK, SAVEPOINT

-- DML : 데이터 조작언어로 데이터의 삽입/삭제/수정
--> 트랜잭션은 DML과 관련되어 있음..

/* TRANSACTION 이란?
 * - 데이터베이스의 논리적 연산 단위
 * - 데이터 변경 사항을 묶어서 하나의 트랜잭션에 담아 처리함.
 * - 트랜잭션의 대상이 되는 데이터 변경 사항 : INSERT, UPDATE, DELETE, MERGE
 *
 * INSERT 수행 ------------------------------------------------> DB 반영 (X)
 *
 * INSERT 수행 -----> 트랜잭션에 추가 ---> COMMIT -------------> DB 반영 (O)
 *
 * INSERT 10번 수행 --> 1개 트랜잭션에 10개 추가 --> ROLLBACK --> DB 반영 (X)
 *
 *
 * 1 ) COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영
 *
 * 2 ) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고
 *                마지막 COMMIT 상태로 돌아감 (DB에 변경 내용 반영 X)
 *
 * 3 ) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의하여
 *                ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌
 *                저장 지점까지만 일부 ROLLBACK
 *
 *
 * [SAVEPOINT 사용법]
 *
 * ...
 * SAVEPOINT "포인트명1";
 *
 * ...
 * SAVEPOINT "포인트명2";
 *
 * ...
 * ROLLBACK TO "포인트명1"; -- 포인트1 지점까지 데이터 변경사항 삭제
 *
 *
 * ** SAVEPOINT 지정 및 호출 시 이름에 ""(쌍따옴표) 붙여야함 !!! ***
 *	
 * */

-- 새로운 데이터 DEPARTMENT2에 INSERT

SELECT * FROM DEPARTMENT2;

INSERT INTO DEPARTMENT2 VALUES('T1','개발1팀','L2');
INSERT INTO DEPARTMENT2 VALUES('T2','개발1팀','L2');
INSERT INTO DEPARTMENT2 VALUES('T3','개발1팀','L2');
-- DB에 영구적으로 반영되지 않음.
--> 트랜젝션에 INSERT문 3개 임시 저장

ROLLBACK;
-- 트랜젝션에 임시 저장되어있는 구문 전체 삭제

COMMIT;
-- 트랜젝션에 임시 저장되어있는 전체 구문을 DB에 영구 반영
--> 이후 영구반영 취소 불가

-- SAVEPOINT 확인

INSERT INTO DEPARTMENT2 VALUES('T4','개발4팀','L2');
SAVEPOINT "SP1";

INSERT INTO DEPARTMENT2 VALUES('T5','개발5팀','L2');
SAVEPOINT "SP2";

INSERT INTO DEPARTMENT2 VALUES('T6','개발6팀','L2');
SAVEPOINT "SP3";

ROLLBACK TO "SP1";
-- 구문 수행시, SP1 이후에 실행된 SP2, SP3도 트렌젝션에서 삭제됨
ROLLBACK TO "SP2";
-- SQL Error [1086] [72000]: ORA-01086: 'SP2' 저장점이 이 세션에 설정되지 않았거나 부적합합니다.
--> 트렌젝션에 "SP2"가 남아있지 않으므로 발생하는 오류

-- 개발팀 전체 삭제해보기
DELETE FROM DEPARTMENT2
WHERE DEPT_TITLE LIKE '개발%';

-- SP2 지점까지 복구
ROLLBACK TO "SP2";
-- SP2 지점 이후로 실행한 '개발6팀' 삽입 구문만 삭제됨.

ROLLBACK TO "SP1";
-- SP1 지점 이후로 실행된 '개발5팀' 삽입 구문도 삭제됨.

ROLLBACK;
-- 마지막 커밋 시점인 '개발1,2,3팀' 삽입 구문 이후까지 복구

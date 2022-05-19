SELECT LOWER('SQL course') lowerCase, UPPER('SQL course') upperCase, INITCAP('SQL course') initcapCase FROM DUAL;

select artistid,lastname,nationality from artist where lastname = 'miro';

select artistid,lastname,nationality from artist where LOWER(lastname) = 'miro';

SELECT
   CONCAT('Hello', 'World') as CONCATResult,
   SUBSTR('HelloWorld',1,5) as SUBSTRResult,
   LENGTH('HelloWorld') as LENGTHResult,
   INSTR('HelloWorld', 'W') as INSTRResult,
   LPAD(1700000,10,'*') as LPADResult,
   RPAD(1700000,10,'*') as RPADResult,
   REPLACE('JACK and JUE','J','BL') as REPLACEResult,
   TRIM('H' FROM 'HelloWorld')as TRIMResult
FROM DUAL;

SELECT artistid, CONCAT(firstname, lastname) FULLNAME,
       firstname || lastname FULLNAME2,
       dateofbirth, LENGTH (lastname), 
       INSTR(lastname, 'a') "Contains 'a' character?"
FROM   artist
WHERE  SUBSTR(dateofbirth,1,2) = 19;


SELECT
  ROUND(45.926, 2) as RoundResult,
  TRUNC(45.926, 2) as TRUNCResult,
  MOD(1600, 300) as MOD
FROM DUAL;

SELECT salesprice, mod(salesprice, 150) FROM TRANS;

SELECT transactionid, salesprice, datesold FROM trans WHERE datesold > '14-DEC-14';

SELECT transactionid, salesprice, datesold FROM trans WHERE datesold > TO_DATE('14-DEC-14','DD-MM-YY');

SELECT SYSDATE FROM DUAL;

SELECT transactionid, salesprice, (sysdate-datesold)/7 WEEKS FROM trans WHERE customerid=1001;

SELECT 
MONTHS_BETWEEN('01-SEP-95','11-JAN-94'),
ADD_MONTHS('11-JAN-94',6),
NEXT_DAY('01-SEP-95','FRIDAY'),
LAST_DAY('01-FEB-95')
FROM DUAL;


SELECT salesprice, TO_CHAR(SALESPRICE,'L999,999.00') SALES FROM trans WHERE salesprice > 3000;

SELECT firstname, UPPER(CONCAT(SUBSTR(firstname, 1, 8), '_US'))
FROM   artist
WHERE  nationality='United States';

-- Theo dõi session theo thời gian thực
SELECT 
    COUNT(*)                              AS tong_session,
    SUM(CASE WHEN status='ACTIVE'  
             THEN 1 ELSE 0 END)          AS dang_chay,
    SUM(CASE WHEN status='INACTIVE'
             THEN 1 ELSE 0 END)          AS dang_cho
FROM v$session
WHERE username IS NOT NULL;
/
-- Xem query nào đang chạy chậm
SELECT s.sid, s.username, s.status,
       q.sql_text,
       q.elapsed_time / 1000 AS elapsed_ms
FROM   v$session s
JOIN   v$sql     q ON s.sql_id = q.sql_id
WHERE  s.status = 'ACTIVE'
ORDER  BY q.elapsed_time DESC;
/
-- Xem tài nguyên CPU và Memory đang dùng
SELECT name, value
FROM v$sysstat
WHERE name IN (
    'user calls',
    'user commits', 
    'physical reads',
    'consistent gets',
    'CPU used by this session'
);
/
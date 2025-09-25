# 导师获取自己管理的类别
explain
SELECT c.category_name,col.college_name
FROM user u
         INNER JOIN college col ON u.college_id = col.id
         INNER JOIN category c ON c.college_id = col.id
WHERE u.teacher_number= 'T2024003';
# 导师获取某专业下的所有学生的信息包括提交项(学生一对多提交节点，应该dto)
explain
SELECT u.username,u.phone,u.email,ss.weighted_score,ss.major_rank,
    COUNT(DISTINCT a.id) as application_count,
    COUNT(DISTINCT CASE WHEN a.status = 2 THEN a.id END) as approved_count,
    COUNT(DISTINCT CASE WHEN a.status IN (0,1) THEN a.id END) as pending_count
FROM user u
         LEFT JOIN student_score ss ON u.id = ss.student_id
         LEFT JOIN application a ON u.id = a.student_id
WHERE u.major_id = 'major_001'  -- 专业ID参数
  AND u.role = 0
GROUP BY u.id, u.username, u.phone, u.email, u.student_number, ss.weighted_score, ss.major_rank
ORDER BY ss.major_rank ASC;
# 导师审批
insert review
values('review_004','application_001','teacher_001',1,90.00,'无',now());
# 导师查询专业下所有学生的成绩统计信息
explain
SELECT u.id,u.student_number,u.username,ss.weighted_score,ss.major_rank,
    COUNT(DISTINCT a.id) as total_applications,
    COUNT(DISTINCT CASE WHEN a.status = 2 THEN a.id END) as approved_applications,
    COALESCE(SUM(CASE WHEN a.status = 2 THEN r.score ELSE 0 END), 0) as total_approved_score
FROM user u
         INNER JOIN student_score ss ON u.id = ss.student_id
         LEFT JOIN application a ON u.id = a.student_id
         LEFT JOIN review r ON a.id = r.application_id AND r.status = 1
WHERE u.major_id = 'major_003'
  AND u.role = 0
GROUP BY u.id, u.student_number, u.username, ss.weighted_score, ss.major_rank
ORDER BY ss.major_rank ASC;
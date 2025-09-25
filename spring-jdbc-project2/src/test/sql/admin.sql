# 学院管理员查看某专业下的所有学生信息  专业id 学院id
explain
SELECT
    u.id,u.username,u.phone,u.email,u.student_number,u.created_time,m.major_name,c.college_name,ss.weighted_score,ss.major_rank
FROM `user` u
         INNER JOIN `major` m ON u.major_id = m.id -- 防止越权
         INNER JOIN `college` c ON u.college_id = c.id
         LEFT JOIN `student_score` ss ON u.id = ss.student_id
WHERE u.role = 0
  AND u.major_id = 'major_001'
  AND u.college_id = 'college_001'
ORDER BY ss.major_rank ASC, u.student_number ASC;
# 学院管理员添加推免规则节点
explain
-- 验证学院管理员是否有权限操作该大类
SELECT c.id, c.category_name, c.college_id
FROM category c
         INNER JOIN user u ON c.college_id = u.college_id
WHERE c.id = 'college_001'  -- 要操作的学院ID
  AND u.id = '1'  -- 管理员用户ID
  AND u.role = 2  -- 管理员角色
  AND u.college_id = c.college_id;
-- 插入新节点
INSERT INTO node (id,category_id,node_name,parent_id,description,max_score,limit_count,create_time)
VALUES ('node_010','category_001','测试','node_005','描述',100,10,NOW());
-- 然后插入与父节点的所有祖先关系
explain
INSERT INTO node_closure (ancestor_id, descendant_id, level, create_time)
SELECT ancestor_id,'node_010', level + 1, NOW()
FROM node_closure
WHERE descendant_id = 'node_005';  -- 父节点ID
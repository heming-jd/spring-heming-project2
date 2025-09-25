# 查找一级指标点信息
explain
SELECT n.id AS node_id,n.node_name,n.description,n.max_score,n.limit_count,n.create_time
FROM node n
         INNER JOIN user u ON n.category_id = u.category_id
WHERE n.parent_id = ''
  AND u.id = '5'
    AND n.category_id = u.category_id;
# 学生查找指定一级指标点下的所有子节点（包括多级）
explain
SELECT n.id AS node_id,n.node_name,n.parent_id,nc.level AS depth,n.description,n.max_score,n.limit_count
FROM node n
         INNER JOIN node_closure nc ON n.id = nc.descendant_id
WHERE nc.ancestor_id = 'node_001'  -- 指定的一级指标点ID
    AND n.category_id = (
        SELECT category_id
        FROM user
        WHERE id = '5'  -- 当前学生ID
    )
ORDER BY nc.level, n.create_time;
# 学生对于指定指标点上传佐证拼接路径
explain
select
    concat_ws(
            '/',
            co.college_name,
            m.major_name,
            concat(u.username, '-', u.student_number)
    ) as path
from
    user u
        join major m on u.major_id = m.id
        join college co on m.college_id = co.id
where u.id = '5';
# 学生对于指定指标点上传佐证拼接文件名
explain
select
    concat_ws(
            '-',
            n.node_name,
            a.student_id
    ) as filename
from
    application a join node n on a.leaf_node_id = n.id
where a.student_id = '5' and a.leaf_node_id = 'node_005';
# 学生新增提交项
-- 第一步：检查是否超过限项数量
explain
SELECT n.limit_count,
    COUNT(a.id) AS current_count
FROM node n
         LEFT JOIN application a ON n.id = a.leaf_node_id
    AND a.student_id = '5'
    AND a.status IN (0, 1, 2)  -- 待审核、审核中、审核通过的状态都计入
WHERE n.id = 'node_007'
GROUP BY n.id, n.limit_count;
-- 第二步：插入申请记录（如果未超限）
INSERT INTO application
(id, student_id, leaf_node_id, project_description, status, apply_time, update_time)
VALUES ('app_004', '5', 'node_007', '我的项目描述', 0, NOW(), NOW());

# 学生查询个人的成绩统计信息
explain
SELECT u.username AS student_name,ss.weighted_score,ss.major_rank,
    -- 申请统计
    COUNT(DISTINCT a.id) AS total_applications,
    SUM(CASE WHEN a.status = 2 THEN 1 ELSE 0 END) AS approved_applications,
    SUM(CASE WHEN a.status = 3 THEN 1 ELSE 0 END) AS rejected_applications
FROM user u
         LEFT JOIN student_score ss ON u.id = ss.student_id
         LEFT JOIN major m ON u.major_id = m.id
         LEFT JOIN application a ON u.id = a.student_id
         LEFT JOIN review r ON a.id = r.application_id
         LEFT JOIN node n ON a.leaf_node_id = n.id
WHERE u.id = '5'
GROUP BY u.id, u.username, u.student_number, m.major_name, ss.weighted_score, ss.major_rank;
-- 学生详细得分明细查询
explain
SELECT n.node_name,a.project_description,r.score,n.max_score,a.apply_time,r.review_time,
    ROUND((r.score / n.max_score) * 100, 2) AS percentage,
    CASE r.status
        WHEN 1 THEN '审核通过'
        WHEN 2 THEN '审核不通过'
        ELSE '待审核'
        END AS review_status
FROM application a
         INNER JOIN node n ON a.leaf_node_id = n.id
         LEFT JOIN review r ON a.id = r.application_id
WHERE a.student_id = '5'
ORDER BY a.apply_time DESC;
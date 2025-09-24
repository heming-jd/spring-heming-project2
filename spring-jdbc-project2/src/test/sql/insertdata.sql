-- 按顺序执行以下插入语句

-- 1. 插入学院
INSERT INTO `college` (id, college_name) VALUES
('college_001', '计算机与控制工程学院');

-- 2. 插入专业大类
INSERT INTO `category` (id, category_name, college_id, score_percentage) VALUES
('category_001', '通信类', 'college_001', 35.00),
('category_002', '电子信息类', 'college_001', 25.00);

-- 3. 插入专业
INSERT INTO `major` (id, major_name, college_id, create_time) VALUES
('major_001', '计算机科学与技术', 'college_001', NOW()),
('major_002', '软件工程', 'college_001', NOW()),
('major_003', '电子信息工程', 'college_001', NOW());

-- 4. 插入用户
INSERT INTO `user` (id,username, password, phone, email, college_id, role, teacher_number, created_time) VALUES
('1','admin001', 'hashed_password_123', '13800138001', 'admin001@example.com', 'college_001', 2, 'T2024001', NOW());

INSERT INTO `user` (id,username, password, phone, email, college_id, role, teacher_number, created_time) VALUES
('3','teacher001', 'hashed_password_456', '13800138002', 'teacher001@example.com', 'college_001', 1, 'T2024002', NOW()),
('4','teacher002', 'hashed_password_789', '13800138003', 'teacher002@example.com', 'college_001', 1, 'T2024003', NOW());

INSERT INTO `user` (id,username, password, phone, email, college_id, role, student_number, category_id, major_id, created_time) VALUES
('5','student001', 'hashed_password_111', '13800138004', 'student001@example.com', 'college_001', 0, 'S2024001', 'category_001', 'major_001', NOW()),
('6','student002', 'hashed_password_222', '13800138005', 'student002@example.com', 'college_001', 0, 'S2024002', 'category_001', 'major_002', NOW()),
('7','student003', 'hashed_password_333', '13800138006', 'student003@example.com', 'college_001', 0, 'S2024003', 'category_002', 'major_003', NOW());

-- 5. 插入教师-大类关联
INSERT INTO `teacher_category` (id, category_id, teacher_id, create_time) VALUES
('tc_001', 'category_001', (SELECT id FROM `user` WHERE username = 'teacher001'), NOW()),
('tc_002', 'category_001', (SELECT id FROM `user` WHERE username = 'teacher002'), NOW()),
('tc_003', 'category_002', (SELECT id FROM `user` WHERE username = 'teacher001'), NOW());

-- 6. 插入项目节点
INSERT INTO `node` (id, category_id, node_name,parent_id, description, max_score, limit_count, create_time) VALUES
('node_001', 'category_001','学术竞赛','', '各类学术竞赛项目', 50.00, 3, NOW()),
('node_002', 'category_001', '科研项目','', '参与科研项目经历', 30.00, 2, NOW()),
('node_003', 'category_001', '社会实践','', '社会实践活动', 20.00, 0, NOW()),
('node_004', 'category_001', '作文', 'node_001','活动', 20.00, 0, NOW()),
('node_005', 'category_001', '一等奖','node_003', '活动', 20.00, 0, NOW()),
('node_006', 'category_001', '竞赛', 'node_001','活动', 20.00, 0, NOW()),
('node_007', 'category_001', '一等奖','node_005', '活动', 20.00, 0, NOW()),
('node_008', 'category_001', '四级', 'node_001','活动', 20.00, 0, NOW());


-- 7. 插入节点关系闭包
INSERT INTO `node_closure` (ancestor_id, descendant_id, level, create_time) VALUES
('node_001', 'node_004', 1, NOW()),
('node_001', 'node_005', 2, NOW()),
('node_001', 'node_006', 1, NOW()),
('node_001', 'node_007', 2, NOW()),
('node_001', 'node_008', 1, NOW()),
('node_004', 'node_005', 1, NOW()),
('node_006', 'node_007', 1, NOW());



-- 8. 插入学生成绩
INSERT INTO `student_score` (id, student_id, weighted_score, major_rank, create_time) VALUES
('score_001', (SELECT id FROM `user` WHERE username = 'student001'), 88.50, 1, NOW()),
('score_002', (SELECT id FROM `user` WHERE username = 'student002'), 85.20, 2, NOW()),
('score_003', (SELECT id FROM `user` WHERE username = 'student003'), 82.70, 1, NOW());

-- 9. 插入申请数据
INSERT INTO `application` (id, student_id, leaf_node_id, project_description, status, apply_time) VALUES
('app_001', (SELECT id FROM `user` WHERE username = 'student001'), 'node_005', '参加全国大学生程序设计竞赛获得一等奖', 2, NOW()),
('app_002', (SELECT id FROM `user` WHERE username = 'student002'), 'node_007', '参与国家级科研项目《人工智能算法研究》', 2, NOW()),
('app_003', (SELECT id FROM `user` WHERE username = 'student001'), 'node_008', '暑期社会实践：乡村教育支持活动', 2, NOW());

-- 10. 插入审核数据
INSERT INTO `review` (id, application_id, teacher_id, status, score, review_time) VALUES
('rev_001', 'app_001', (SELECT id FROM `user` WHERE username = 'teacher001'), 1, 48.50, NOW()),
('rev_002', 'app_002', (SELECT id FROM `user` WHERE username = 'teacher001'), 1, 4.50, NOW()),
('rev_003', 'app_003', (SELECT id FROM `user` WHERE username = 'teacher002'), 2, 11.00, NOW());

-- 11. 插入申请文件
INSERT INTO `application_file` (id, student_id, file_path, create_time) VALUES
('file_001', (SELECT id FROM `user` WHERE username = 'student001'), '/files/student001/competition_cert.pdf', NOW()),
('file_002', (SELECT id FROM `user` WHERE username = 'student002'), '/files/student002/research_project.doc', NOW());

-- 12. 插入系统日志
INSERT INTO `log` (id, user_id, operation_content, operation_time) VALUES
('log_001', (SELECT id FROM `user` WHERE username = 'admin001'), '系统管理员登录系统', NOW()),
('log_002', (SELECT id FROM `user` WHERE username = 'teacher001'), '教师审核了学生申请', NOW());
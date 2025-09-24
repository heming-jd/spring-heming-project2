drop table if exists `node`;
create table if not exists `user`
(
    id              bigint auto_increment primary key comment '用户id',
    username        varchar(50)  not null unique comment '账号',
    password        varchar(65) not null comment '密码',
    phone           varchar(20)  null comment '电话',
    email           varchar(100) null comment '邮箱',
    college_id      char(19)       not null comment '学院id',
    role            tinyint      not null comment '角色(0:学生,1:教师,2:管理员)',
    student_number  varchar(50)  null comment '学号(学生角色时非空)',
    teacher_number  varchar(50)  null comment '工号(教师/管理员角色时非空)',
    category_id     char(19)       null comment '学生所属大类id',
    major_id        char(19)       null comment '学生所属专业id',
    created_time    datetime     not null default current_timestamp comment '创建时间',
    updated_time    datetime     not null default current_timestamp on update current_timestamp comment '更新时间',

    index idx_college_id (college_id) comment '学院id索引',
    index idx_category_id (category_id) comment '学生大类id索引'
) comment '用户信息表';

create table if not exists `college`
(
    id            char(19) not null primary key comment '学院唯一标识',
    college_name  varchar(100) not null comment '学院名称',

    index(college_name) comment '学院名称索引'
) comment '学院信息表';

create table if not exists `category`
(
    id               char(19) not null primary key comment '大类唯一标识',
    category_name    varchar(100) not null comment '大类名称',
    college_id       char(19) not null comment '所属学院ID',
    score_percentage decimal(5,2) default 100.00 comment '推免分数占比',

    index(college_id) comment '学院ID索引'
) comment '专业大类表';

create table if not exists `major`
(
    id           char(19) not null primary key comment '专业唯一标识',
    major_name   varchar(100) not null comment '专业名称',
    college_id   char(19) not null comment '所属学院ID',
    create_time  datetime not null default current_timestamp comment '创建时间',

    index(major_name) comment '专业名称索引',
    index(college_id) comment '学院ID索引'
) comment '专业信息表';

create table if not exists `teacher_category`
(
    id          char(19) not null primary key comment '关联记录唯一标识',
    category_id char(19) not null comment '大类ID',
    teacher_id  char(19) not null comment '教师ID',
    create_time datetime not null default current_timestamp comment '创建时间',

    index(category_id) comment '大类ID索引',
    index(teacher_id) comment '教师ID索引'
) comment '教师-大类关联表';

create table if not exists `node`
(
    id           char(19) not null primary key comment '节点唯一标识',
    category_id  char(19) not null comment '所属大类ID',
    node_name    varchar(200) not null comment '项目节点名称',
    parent_id char(19) NULL COMMENT '父类别ID',
    description  text comment '项目描述',
    max_score    decimal(10,2) default 0.00 comment '节点最大分数',
    limit_count  int default 0 comment '限项个数(0表示不限项)',
    create_time  datetime not null default current_timestamp comment '创建时间',

    index(category_id) comment '大类ID索引',
    index(node_name) comment '节点名称索引',
    index(parent_id) comment '父节点索引'
) comment '项目节点表';

create table if not exists `node_closure`
(
    ancestor_id   char(19) not null comment '祖先节点ID',
    descendant_id char(19) not null comment '后代节点ID',
    level         int not null comment '层级差',
    create_time   datetime not null default current_timestamp comment '创建时间',

    primary key (ancestor_id, descendant_id) comment '主键(祖先ID, 后代ID)',
    index(ancestor_id) comment '祖先节点ID索引',
    index(descendant_id) comment '后代节点ID索引',
    index(level) comment '层级索引'
) comment '节点关系闭包表';

create table if not exists `student_score`
(
    id            char(19) not null primary key comment '成绩记录唯一标识',
    student_id    char(19) not null comment '学生ID',
    weighted_score decimal(5,2) not null comment '加权成绩',
    major_rank    int not null comment '专业排名',
    create_time   datetime not null default current_timestamp comment '创建时间',
    update_time   datetime not null default current_timestamp on update current_timestamp comment '更新时间',

    index(student_id) comment '学生ID索引',
    index(major_rank) comment '专业排名索引'
) comment '学生成绩表';

create table if not exists `application`
(
    id                  char(19) not null primary key comment '申请记录唯一标识',
    student_id          char(19) not null comment '申请学生ID',
    leaf_node_id        char(19) not null comment '项目叶子节点ID',
    project_description text comment '申请项目描述',
    status              tinyint not null default 0 comment '申请状态(0:待审核,1:审核中,2:审核通过,3:审核不通过,4:已打回)',
    apply_time          datetime not null default current_timestamp comment '申请时间',
    update_time         datetime not null default current_timestamp on update current_timestamp comment '更新时间',

    index(student_id) comment '学生ID索引',
    index(leaf_node_id) comment '叶子节点ID索引',
    index(status) comment '状态索引',
    index(apply_time) comment '申请时间索引'
) comment '申请表';

create table if not exists `review`
(
    id             char(19) not null primary key comment '审核记录唯一标识',
    application_id char(19) not null comment '申请记录ID',
    teacher_id     char(19) not null comment '审核教师ID',
    status         tinyint not null default 0 comment '审核状态(0:待审核,1:通过,2:不通过)',
    score          decimal(10,2) default 0.00 comment '审核分数',
    reject_reason  text comment '打回理由',
    review_time    datetime not null default current_timestamp comment '审核时间',

    index(application_id) comment '申请ID索引',
    index(teacher_id) comment '教师ID索引',
    index(status) comment '状态索引',
    index(review_time) comment '审核时间索引'
) comment '审核表';

create table if not exists `application_file`
(
    id           char(19) not null primary key comment '文件记录唯一标识',
    student_id   char(19) not null comment '学生ID',

    file_path    varchar(500) not null comment '文件存储路径',
    create_time  datetime not null default current_timestamp comment '创建时间',
    update_time  datetime not null default current_timestamp on update current_timestamp comment '更新时间',

    index(student_id) comment '学生ID索引'
) comment '申请文件表';

create table if not exists `log`
(
    id                char(19) not null primary key comment '日志记录唯一标识',
    user_id           char(19) not null comment '操作用户ID',
    operation_content text not null comment '操作内容',
    operation_time    datetime not null default current_timestamp comment '操作时间',

    index(user_id) comment '用户ID索引',
    index(operation_time) comment '操作时间索引'
) comment '系统日志表';
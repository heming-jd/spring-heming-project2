# 查找根节点
explain
select *
from node n
where n.category_id = 'node_009' and n.parent_id is null;
#根据节点id查找子节点
explain
SELECT n.*, nc.level
FROM node n
         INNER JOIN node_closure nc ON n.id = nc.descendant_id
WHERE nc.ancestor_id = 'node_001'  -- 父节点ID
  AND nc.level = 1        -- 直接子节点（层级差为1）
ORDER BY n.node_name;

# 查询所有子节点
explain
SELECT n.*, nc.level as depth
FROM node n
         INNER JOIN node_closure nc ON n.id = nc.descendant_id
WHERE nc.ancestor_id = 'node_001'  -- 指定节点ID
ORDER BY nc.level, n.node_name;
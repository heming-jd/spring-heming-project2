# 查找根节点
explain
SELECT ancestor_id ,level
FROM node_closure
WHERE descendant_id = 'node_007'
ORDER BY level DESC;
#根据节点id查找子节点
explain
SELECT descendant_id ,level
FROM node_closure
WHERE ancestor_id= 'node_001'
ORDER BY level DESC;

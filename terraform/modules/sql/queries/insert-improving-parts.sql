INSERT INTO improving_parts_table
SELECT
    `ImproveId`,
    `StageLevel`,
    `StageText`,
    `PartsImprovedList`
FROM Improves;
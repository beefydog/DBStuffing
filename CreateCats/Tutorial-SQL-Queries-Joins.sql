SELECT TOP (1000) [Id]
      ,[Name]
      ,[ParentId]
      ,[Active]
  FROM [TestDB].[dbo].[Category]

-- Appending name of categories in order of hierarchy
SELECT     a.Id ,  CONCAT_WS(':',i.Name,  h.Name,  g.Name,  f.Name,  e.Name,  d.Name,  c.Name,  b.Name,  a.Name)  AS Names, 
                      a.ParentId AS parentId 
FROM         Category AS a  LEFT OUTER JOIN
             Category AS b  ON a.ParentId = b.Id LEFT OUTER JOIN
             Category AS c  ON b.ParentId = c.Id LEFT OUTER JOIN
             Category AS d  ON c.ParentId = d.Id LEFT OUTER JOIN
             Category AS e  ON d.ParentId = e.Id LEFT OUTER JOIN
             Category AS f  ON e.ParentId = f.Id LEFT OUTER JOIN
             Category AS g  ON f.ParentId = g.Id LEFT OUTER JOIN
             Category AS h  ON g.ParentId = h.Id LEFT OUTER JOIN
             Category AS i  ON h.ParentId = i.Id	
ORDER BY parentId,Id



-- Appending name of categories in order of hierarchy starting from a specified branch id
DECLARE @BranchId int = 1679616;

SELECT     a.Id ,  CONCAT_WS(':',i.Name,  h.Name,  g.Name,  f.Name,  e.Name,  d.Name,  c.Name,  b.Name,  a.Name)  AS Names, 
                      a.ParentId AS parentId 
FROM         Category AS a  LEFT OUTER JOIN
                      Category AS b  ON a.ParentId = b.Id LEFT OUTER JOIN
                      Category AS c  ON b.ParentId = c.Id LEFT OUTER JOIN
                      Category AS d  ON c.ParentId = d.Id LEFT OUTER JOIN
                      Category AS e  ON d.ParentId = e.Id LEFT OUTER JOIN
                      Category AS f  ON e.ParentId = f.Id LEFT OUTER JOIN
                      Category AS g  ON f.ParentId = g.Id LEFT OUTER JOIN
                      Category AS h  ON g.ParentId = h.Id LEFT OUTER JOIN
                      Category AS i  ON h.ParentId = i.Id	
	WHERE @BranchId IN (i.Id,  h.Id,  g.Id,  f.Id,  e.Id,  d.Id,  c.Id,  b.Id,  a.Id) --including branch
	--WHERE @BranchId IN (i.Id,  h.Id,  g.Id,  f.Id,  e.Id,  d.Id,  c.Id,  b.Id) --excluding branch
ORDER BY parentId,Id


-- selecting only categories where only active cats are shown excluding active cats underneath ANY parent that is inactive
-- create a table variable with all inactive categories	
DECLARE @inactive table (Id int)
INSERT INTO @inactive SELECT Id FROM category WHERE Active=0;		
-- then do hierarchy selection
SELECT     a.Id ,CONCAT_WS(':',i.Name,  h.Name,  g.Name,  f.Name,  e.Name,  d.Name,  c.Name,  b.Name,  a.Name)  AS Names, 
             a.ParentId AS parentId
FROM         Category AS a  LEFT OUTER JOIN
                      Category AS b  ON a.ParentId = b.Id LEFT OUTER JOIN
                      Category AS c  ON b.ParentId = c.Id LEFT OUTER JOIN
                      Category AS d  ON c.ParentId = d.Id LEFT OUTER JOIN
                      Category AS e  ON d.ParentId = e.Id LEFT OUTER JOIN
                      Category AS f  ON e.ParentId = f.Id LEFT OUTER JOIN
                      Category AS g  ON f.ParentId = g.Id LEFT OUTER JOIN
                      Category AS h  ON g.ParentId = h.Id LEFT OUTER JOIN
                      Category AS i  ON h.ParentId = i.Id					
WHERE(
CASE 
	WHEN (i.Id IN (SELECT Id FROM @inactive) 
	OR h.Id IN (SELECT Id FROM @inactive) 
	OR g.Id IN (SELECT Id FROM @inactive) 
	OR f.Id IN (SELECT Id FROM @inactive) 
	OR e.Id IN (SELECT Id FROM @inactive) 
	OR d.Id IN (SELECT Id FROM @inactive) 
	OR c.Id IN (SELECT Id FROM @inactive) 
	OR b.Id IN (SELECT Id FROM @inactive) 
	OR a.Id IN (SELECT Id FROM @inactive)) THEN 1 ELSE 0 END) = 0
ORDER BY parentId,Id



-- SAME AS ABOVE with starting branch
DECLARE @BranchId int = 1679616;

-- create a table variable with all inactive categories	
DECLARE @inactive table (Id int)
INSERT INTO @inactive SELECT Id FROM category WHERE Active=0;	
	
-- then do hierarchy selection
SELECT     a.Id ,CONCAT_WS(':',i.Name,  h.Name,  g.Name,  f.Name,  e.Name,  d.Name,  c.Name,  b.Name,  a.Name)  AS Names, 
             a.ParentId AS parentId
FROM         Category AS a  LEFT OUTER JOIN
                      Category AS b  ON a.ParentId = b.Id LEFT OUTER JOIN
                      Category AS c  ON b.ParentId = c.Id LEFT OUTER JOIN
                      Category AS d  ON c.ParentId = d.Id LEFT OUTER JOIN
                      Category AS e  ON d.ParentId = e.Id LEFT OUTER JOIN
                      Category AS f  ON e.ParentId = f.Id LEFT OUTER JOIN
                      Category AS g  ON f.ParentId = g.Id LEFT OUTER JOIN
                      Category AS h  ON g.ParentId = h.Id LEFT OUTER JOIN
                      Category AS i  ON h.ParentId = i.Id					
WHERE(
CASE 
	WHEN (i.Id IN (SELECT Id FROM @inactive) 
	OR h.Id IN (SELECT Id FROM @inactive) 
	OR g.Id IN (SELECT Id FROM @inactive) 
	OR f.Id IN (SELECT Id FROM @inactive) 
	OR e.Id IN (SELECT Id FROM @inactive) 
	OR d.Id IN (SELECT Id FROM @inactive) 
	OR c.Id IN (SELECT Id FROM @inactive) 
	OR b.Id IN (SELECT Id FROM @inactive) 
	OR a.Id IN (SELECT Id FROM @inactive)) THEN 1 ELSE 0 END) = 0
	AND @BranchId IN (i.Id,  h.Id,  g.Id,  f.Id,  e.Id,  d.Id,  c.Id,  b.Id,  a.Id) --including branch
	--AND @BranchId IN (i.Id,  h.Id,  g.Id,  f.Id,  e.Id,  d.Id,  c.Id,  b.Id) --excluding branch
ORDER BY parentId,Id



-- Same as above with Depth			

DECLARE @BranchId int = 1679616;
DECLARE @inactive table (Id int)
INSERT INTO @inactive SELECT Id FROM category WHERE Active=0;		

SELECT     a.Id ,CONCAT_WS(':',i.Name,  h.Name,  g.Name,  f.Name,  e.Name,  d.Name,  c.Name,  b.Name,  a.Name)  AS Names, 
             a.ParentId AS parentId 
				,CASE WHEN b.Id IS NULL THEN 0
				WHEN c.Id IS NULL THEN 1
				WHEN d.Id IS NULL THEN 2
				WHEN e.Id IS NULL THEN 3
				WHEN f.Id IS NULL THEN 4
				WHEN g.Id IS NULL THEN 5
				WHEN h.Id IS NULL THEN 6
				WHEN i.Id IS NULL THEN 7 ELSE 8 END AS Depth
				--,8- ( IIF(i.Id IS NULL, 1,0) + IIF(h.id IS NULL,1,0)  + IIF(g.id IS NULL,1,0)  + IIF(f.id IS NULL,1,0)  + IIF(e.id IS NULL,1,0)  + IIF(d.id IS NULL,1,0)  + IIF(c.id IS NULL,1,0)  + IIF(b.id IS NULL,1,0) ) AS Depth --alternate way of getting depth
FROM         Category AS a LEFT OUTER JOIN
            Category AS b  ON a.ParentId = b.Id LEFT OUTER JOIN
            Category AS c  ON b.ParentId = c.Id LEFT OUTER JOIN
            Category AS d  ON c.ParentId = d.Id LEFT OUTER JOIN
            Category AS e  ON d.ParentId = e.Id LEFT OUTER JOIN
            Category AS f  ON e.ParentId = f.Id LEFT OUTER JOIN
            Category AS g  ON f.ParentId = g.Id LEFT OUTER JOIN
            Category AS h  ON g.ParentId = h.Id LEFT OUTER JOIN
            Category AS i  ON h.ParentId = i.Id					
WHERE (
CASE 
	WHEN (i.Id IN (SELECT Id FROM @inactive) 
	OR h.Id IN (SELECT Id FROM @inactive) 
	OR g.Id IN (SELECT Id FROM @inactive) 
	OR f.Id IN (SELECT Id FROM @inactive) 
	OR e.Id IN (SELECT Id FROM @inactive) 
	OR d.Id IN (SELECT Id FROM @inactive) 
	OR c.Id IN (SELECT Id FROM @inactive) 
	OR b.Id IN (SELECT Id FROM @inactive) 
	OR a.Id IN (SELECT Id FROM @inactive)) THEN 1 ELSE 0 END) = 0	
	AND @BranchId IN (i.Id,  h.Id,  g.Id,  f.Id,  e.Id,  d.Id,  c.Id,  b.Id,  a.Id) --including branch
	--AND @BranchId IN (i.Id,  h.Id,  g.Id,  f.Id,  e.Id,  d.Id,  c.Id,  b.Id) --excluding branch
ORDER BY parentId,Id
SELECT TOP (1000) [Id]
      ,[Name]
      ,[ParentId]
      ,[Active]
  FROM [TestDB].[dbo].[Category]

-- Appending name of categories in order of hierarchy
WITH Cats AS ( 
	SELECT Id, [Name], ParentId
	FROM Category WITH (NOLOCK) WHERE ParentId=0
	UNION ALL
	SELECT c.Id, CAST(Cats.[Name] + ':' + c.[Name] AS nvarchar(200)) AS Name, c.ParentId
	--SELECT c.Id,  CAST(CONCAT_WS(':',Cats.[Name], c.[Name]) AS nvarchar(200)) AS Name, c.ParentId
	FROM Category c
	INNER JOIN Cats  ON c.ParentId = Cats.Id
	WHERE c.ParentId>0
	)
SELECT * FROM Cats ORDER BY ParentId, Id



-- Appending name of categories in order of hierarchy starting from a specified branch id
DECLARE @BranchId int = 1679616;
WITH Cats AS ( 
	SELECT Id, [Name], ParentId
	--FROM Category WHERE ParentId=@BranchId --don't include parent
	FROM Category WHERE ParentId=@BranchId OR Id=@BranchId -- include parent
	UNION ALL
	SELECT c.Id, CAST(Cats.[Name] + ':' + c.[Name] AS nvarchar(200)) AS Name, c.ParentId
	FROM Category c
	INNER JOIN Cats  ON c.ParentId = Cats.Id
	WHERE c.ParentId>@BranchId
	)
SELECT *
FROM Cats ORDER BY ParentId, Id


-- selecting only categories where only active cats are shown excluding active cats underneath ANY parent that is inactive
WITH Cats AS ( 
	SELECT Id, [Name], ParentId, Active
	FROM Category WHERE ParentId=0 AND Active=1
	UNION ALL
	SELECT c.Id, CAST(Cats.[Name] + ':' + c.[Name] AS nvarchar(200)) AS Name, c.ParentId, c.Active	
	FROM Category c
	INNER JOIN Cats  ON c.ParentId = Cats.Id
	WHERE c.ParentId>0 AND c.Active=1
	)
SELECT *
FROM Cats ORDER BY ParentId, Id




-- SAME AS ABOVE with starting branch
DECLARE @BranchId int = 1679616;
WITH Cats AS ( 
	SELECT Id, [Name], ParentId, Active 
	--FROM Category WHERE ParentId=@BranchId AND Active=1 --don't include parent
	FROM Category WHERE ParentId=@BranchId OR Id=@BranchId AND Active=1 -- include parent
	UNION ALL
	SELECT c.Id, CAST(Cats.[Name] + ':' + c.[Name] AS nvarchar(200)) AS Name, c.ParentId, c.Active	
	FROM Category c WITH (NOLOCK)
	INNER JOIN Cats  ON c.ParentId = Cats.Id
	WHERE c.ParentId>@BranchId AND c.Active=1
	)
SELECT *
FROM Cats ORDER BY ParentId, Id




-- Same as above with Depth			
DECLARE @BranchId int = 1679616;
WITH Cats AS ( 
	SELECT Id, [Name], ParentId, Active, 0 AS Depth 
	--FROM Category WHERE ParentId=@BranchId AND Active=1 --don't include parent
	FROM Category WHERE ParentId=@BranchId OR Id=@BranchId AND Active=1 -- include parent
	UNION ALL
	SELECT c.Id, CAST(Cats.[Name] + ':' + c.[Name] AS nvarchar(200)) AS Name, c.ParentId, c.Active, Cats.Depth + 1 AS Depth
	FROM Category c WITH (NOLOCK)
	INNER JOIN Cats  ON c.ParentId = Cats.Id
	WHERE c.ParentId>@BranchId AND c.Active=1
	)
SELECT *
FROM Cats ORDER BY ParentId, Id
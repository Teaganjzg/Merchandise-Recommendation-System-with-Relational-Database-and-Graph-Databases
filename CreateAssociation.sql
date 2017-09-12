USE CSCI5559
GO

DECLARE @MyCursor CURSOR;

DECLARE @curInvoice INT;
DECLARE @description NVARCHAR(255);
DECLARE @desList TABLE (ind int, descrip NVARCHAR(255));
DECLARE @listCount INT = 0;
DECLARE @groupTable TABLE (invoice int, quantity int);
DECLARE @groupCount INT = 0;

BEGIN
    SET @MyCursor = CURSOR FOR
    select top 100 [Invoice_Number],[Description] 
	from [CSCI5559].[dbo].[Retail]
	where Invoice_Number is not null
	order by Invoice_Number

	INSERT INTO @groupTable 
	SELECT [Invoice_Number], COUNT([Description]) 
	FROM [CSCI5559].[dbo].[Retail]
	WHERE [Invoice_Number] is not NULL
	GROUP BY [Invoice_Number]
	ORDER BY [Invoice_Number]

    OPEN @MyCursor 
    FETCH NEXT FROM @MyCursor 
    INTO @curInvoice, @description

    WHILE @@FETCH_STATUS = 0
    BEGIN
		SET @groupCount = (SELECT top 1 quantity
							FROM @groupTable
							WHERE invoice = @curInvoice)

		insert into @desList values (@listCount, @description)
		SET @listCount += 1

		IF @listCount = @groupCount
		BEGIN
			DECLARE @i int = 0
			WHILE @i < @listCount - 1
			BEGIN
				DECLARE @j int = @i + 1
				WHILE @j < @listCount
				BEGIN
					DECLARE @Name1 NVARCHAR(255) = (select top 1 descrip from @desList where ind = @i);
					DECLARE @Name2 NVARCHAR(255) = (select top 1 descrip from @desList where ind = @j);
					--Make sure the Name1 and Name2 is in acending order
					if(@Name1 > @Name2)
					begin
						DECLARE @temp NVARCHAR(255) = @Name1;
						SET @Name1 = @Name2;
						SET @Name2 = @temp;
					end
					
					IF EXISTS (select 1 from [CSCI5559].[dbo].[Association] where Description1 = @Name1 and Description2 = @Name2)
					BEGIN
						update [CSCI5559].[dbo].[Association] set Association_Times += 1 where Description1 = @Name1 and Description2 = @Name2
					END
					ELSE
					BEGIN
						insert into [CSCI5559].[dbo].[Association] (Description1, Description2) values (@Name1, @Name2)
					END
					SET @j += 1
				END
				SET @i += 1
			END

			delete from @desList
			SET @listCount = 0
		END

		FETCH NEXT FROM @MyCursor 
		INTO @curInvoice, @description

    END; 

    CLOSE @MyCursor ;
    DEALLOCATE @MyCursor;
END;
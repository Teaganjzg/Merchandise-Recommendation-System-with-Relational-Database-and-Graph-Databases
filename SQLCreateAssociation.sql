USE csci5559_db;
GO

DECLARE @Invoice CURSOR;
DECLARE @Association1 CURSOR;
DECLARE @Association2 CURSOR;
DECLARE @Association_ID int;
DECLARE @Description1 nvarchar(255);
DECLARE @Description2 nvarchar(255);
DECLARE @d1 nvarchar(255);
DECLARE @d2 nvarchar(255);
DECLARE @InvoiceId int;
DECLARE @count int; -- the middle loop excution times with every element of outter loop
DECLARE @countv int; -- the number of cursor moves of @Association2 before finding associations
-- Use three loops excuting by three cursors to insert or update associations into Association table (initially empty)

SET @Invoice = CURSOR FOR
    SELECT 
    [Invoice_Number]
    FROM [csci5559_db].[dbo].[Retail] 
    WHERE Invoice_Number is not null
    GROUP BY Invoice_Number --Set cursor @Invoice for all the invoice numbers (outter loop)

OPEN @Invoice
    FETCH NEXT FROM @Invoice 
    INTO @InvoiceId

WHILE @@FETCH_STATUS = 0
 BEGIN

    SET @Association1 = CURSOR FOR
        SELECT  
        [Description]
        FROM [csci5559_db].[dbo].[Retail] 
        WHERE Invoice_Number = @InvoiceId;  --Set cursor @Association1 for all the items with same one invoice number (middle loop)
  
    OPEN @Association1 
    FETCH NEXT FROM @Association1 
    INTO @Description1;
	SET @count = 1;
    WHILE @@FETCH_STATUS = 0
    BEGIN
	  
      SET @Association2 = CURSOR FOR
          SELECT 
          [Description]
          FROM [csci5559_db].[dbo].[Retail] 
          WHERE Invoice_Number = @InvoiceId; -- @Association2 is the inner loop
	  OPEN @Association2; 
      FETCH NEXT FROM @Association2 
      INTO @Description2;
	  SET @countv=@count;
	  while @countv >0
	  BEGIN
	    FETCH NEXT FROM @Association2 
        INTO @Description2;
        SET @countv= @countv -1; -- Avoid one association with two same items by making the cursor increase by the middle loop excution times 
      END

	  WHILE @@FETCH_STATUS = 0
          BEGIN
		  IF (@Description1 > @Description2)
		    BEGIN
		    SET @d2 = @Description1;
		    SET @d1 = @Description2;
		   
		    END;
		  ELSE 
		    BEGIN 
			SET @d1=@Description1;
			SET @d2=@Description2;
			END -- Make sure @Description1 <= @Description2 to avoid repeated associations  
		  IF EXISTS (SELECT * FROM [csci5559_db].[dbo].[Association]
		             WHERE Description1 = @d1
					 AND Description2 = @d2 )
          BEGIN
			UPDATE [csci5559_db].[dbo].[Association]
			SET Association_Times +=1 
			WHERE Description1 = @d1
					 AND Description2 = @d2; -- if the association already exists in the Association table then Association_times increase by 1
          END
          ELSE
		  BEGIN
		     INSERT INTO [csci5559_db].[dbo].[Association]
			 VALUES (@d1, @d2,1) -- -- if the association doesn't exists in the Association table then add it to table and set Association_Times as 1
		  END
		  
		  FETCH NEXT FROM @Association2 
          INTO @Description2;
		  END;
      CLOSE @Association2 ;
      DEALLOCATE @Association2;
	  SET @count=@count + 1;
      FETCH NEXT FROM @Association1 
      INTO @Description1;
	   
    END; 

	CLOSE @Association1 ;
    DEALLOCATE @Association1;
	
   

 FETCH NEXT FROM @Invoice 
      INTO @InvoiceId; 
 END;
 CLOSE @Invoice ;
 DEALLOCATE @Invoice;

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
DECLARE @count int;
DECLARE @countv int;


SET @Invoice = CURSOR FOR
    SELECT --TOP 15 
      [Invoice_Number]
  FROM [csci5559_db].[dbo].[Retail] 
  WHERE Invoice_Number is not null
  GROUP BY Invoice_Number

OPEN @Invoice
    FETCH NEXT FROM @Invoice 
    INTO @InvoiceId

WHILE @@FETCH_STATUS = 0
 BEGIN

    SET @Association1 = CURSOR FOR
    SELECT  
      
      [Description]
    FROM [csci5559_db].[dbo].[Retail] 
    WHERE Invoice_Number = @InvoiceId;   

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
    WHERE Invoice_Number = @InvoiceId;
	  OPEN @Association2; 
      FETCH NEXT FROM @Association2 
      INTO @Description2;
	  set @countv=@count;
	  while @countv >0
	  Begin
	    FETCH NEXT FROM @Association2 
        INTO @Description2;
        set @countv= @countv -1;
      end

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
			set @d2=@Description2;
			END
		  IF EXISTS (SELECT * FROM [csci5559_db].[dbo].[Association]
		             WHERE Description1 = @d1
					 AND Description2 = @d2 )
          BEGIN
		    --print 'repeat'+ @d1+ ','+@d2;
			UPDATE [csci5559_db].[dbo].[Association]
			SET Association_Times +=1 
			WHERE Description1 = @d1
					 AND Description2 = @d2;
          END
          ELSE
		  BEGIN
		     --print 'new'+ @d1+ ','+@d2;
		     INSERT INTO [csci5559_db].[dbo].[Association]
			 VALUES (@d1, @d2,1)
		  END
		  
		  FETCH NEXT FROM @Association2 
          INTO @Description2;
		  END;
      CLOSE @Association2 ;
      DEALLOCATE @Association2;
	  set @count=@count + 1;
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

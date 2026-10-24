-- Actividad 3
-- ERENDIRA D. BECERRA ACOSTA

USE e_commerce;
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_CreateOrder]
    @UserId INT,
    @ProductId INT,
    @Quantity INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @Quantity <= 0
    BEGIN
        SELECT
            '0' AS code,
            'La cantidad debe ser mayor a cero' AS message;
        RETURN;
    END

    IF NOT EXISTS (
        SELECT 1
        FROM Users
        WHERE UserId = @UserId
    )
    BEGIN
        SELECT
            '0' AS code,
            'El usuario no existe' AS message;
        RETURN;
    END

    IF NOT EXISTS (
        SELECT 1
        FROM Products
        WHERE ProductId = @ProductId
          AND IsActive = 1
    )
    BEGIN
        SELECT
            '0' AS code,
            'El producto no existe o se encuentra inactivo' AS message;
        RETURN;
    END

    DECLARE @Stock INT;
    DECLARE @Price DECIMAL(18,2);
    DECLARE @TotalAmount DECIMAL(18,2);
    DECLARE @OrderId INT;

    SELECT
        @Stock = StockQuantity,
        @Price = Price
    FROM Products
    WHERE ProductId = @ProductId
      AND IsActive = 1;

    IF @Stock < @Quantity
    BEGIN
        SELECT
            '0' AS code,
            'No hay suficiente stock para realizar la orden' AS message;
        RETURN;
    END

    SET @TotalAmount = @Price * @Quantity;

    BEGIN TRY

        BEGIN TRANSACTION;

        INSERT INTO Orders
        (
            UserId,
            TotalAmount,
            Status
        )
        VALUES
        (
            @UserId,
            @TotalAmount,
            'Pending'
        );

        SET @OrderId = SCOPE_IDENTITY();

        INSERT INTO OrderDetails
        (
            OrderId,
            ProductId,
            Quantity,
            UnitPrice
        )
        VALUES
        (
            @OrderId,
            @ProductId,
            @Quantity,
            @Price
        );

        UPDATE Products
        SET StockQuantity = StockQuantity - @Quantity
        WHERE ProductId = @ProductId;

        COMMIT TRANSACTION;

        SELECT
            @OrderId AS OrderId,
            @TotalAmount AS TotalAmount,
            '1' AS code,
            'Orden creada correctamente' AS message;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT
            '0' AS code,
            ERROR_MESSAGE() AS message;

    END CATCH
END;
GO

EXEC sp_CreateOrder @UserId = 1, @ProductId = 1, @Quantity = 2;
-- Actividad 1
-- ERENDIRA D. BECERRA ACOSTA

USE e_commerce;
GO

ALTER PROCEDURE [dbo].[sp_GetAllActiveProducts]
    @method VARCHAR(100),
    @isActive BIT = NULL,
    @SKU VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @method = 'Products'
    BEGIN

        IF @isActive IS NULL
        BEGIN
            SELECT
                '0' AS code,
                'No se ha especificado el parámetro isActive' AS message;
            RETURN;
        END

        SELECT
            ProductId,
            SKU,
            Name,
            Description,
            Price,
            StockQuantity,
            '1' AS code,
            'Success' AS message
        FROM Products
        WHERE IsActive = @isActive
        ORDER BY Name ASC;

        RETURN;
    END

    IF @method = 'GetProductBySKU'
    BEGIN

        IF @SKU IS NULL OR LTRIM(RTRIM(@SKU)) = ''
        BEGIN
            SELECT
                '0' AS code,
                'No se ha especificado el parámetro SKU' AS message;
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1
            FROM Products
            WHERE SKU = @SKU
        )
        BEGIN
            SELECT
                '0' AS code,
                'El producto no existe' AS message;
            RETURN;
        END

        SELECT
            @isActive = IsActive
        FROM Products
        WHERE SKU = @SKU;

        IF @isActive = 0
        BEGIN
            SELECT
                '0' AS code,
                'El producto ya no se encuentra activo' AS message;
            RETURN;
        END

        SELECT
            ProductId,
            SKU,
            Name,
            Description,
            Price,
            StockQuantity,
            '1' AS code,
            'Success' AS message
        FROM Products
        WHERE SKU = @SKU
          AND IsActive = 1
        ORDER BY Name ASC;

        RETURN;
    END

    SELECT
        '0' AS code,
        'El método especificado no es válido' AS message;
END;
GO

EXEC sp_GetAllActiveProducts @method = 'GetProductBySKU', @SKU = 'LAP-001';
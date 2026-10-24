-- Actividad 2
-- ERENDIRA D. BECERRA ACOSTA

USE e_commerce;
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_ValidateApiKey]
    @KeyValue UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    IF @KeyValue IS NULL
    BEGIN
        SELECT
            '0' AS code,
            'No se ha especificado el valor de la API Key' AS message;
        RETURN;
    END

    IF NOT EXISTS (
        SELECT 1
        FROM ApiKeys
        WHERE KeyValue = @KeyValue
          AND IsActive = 1
    )
    BEGIN
        SELECT
            '0' AS code,
            'La API Key no es válida o se encuentra inactiva' AS message;
        RETURN;
    END

    SELECT
        KeyName,
        '1' AS code,
        'Success' AS message
    FROM ApiKeys
    WHERE KeyValue = @KeyValue
      AND IsActive = 1;
END;
GO

EXEC sp_ValidateApiKey @KeyValue = 'API-KEY-DE-PRUEBA';
-- Actividad 4
-- ERENDIRA D. BECERRA ACOSTA

USE e_commerce;
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_GetUserForLogin]
    @Username NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF @Username IS NULL OR LTRIM(RTRIM(@Username)) = ''
    BEGIN
        SELECT
            '0' AS code,
            'No se ha especificado el nombre de usuario' AS message;
        RETURN;
    END

    IF NOT EXISTS (
        SELECT 1
        FROM Users
        WHERE Username = @Username
    )
    BEGIN
        SELECT
            '0' AS code,
            'El usuario no existe' AS message;
        RETURN;
    END

    SELECT
        UserId,
        PasswordHash,
        Role,
        '1' AS code,
        'Success' AS message
    FROM Users
    WHERE Username = @Username;
END;
GO

EXEC sp_GetUserForLogin @Username = 'admin_user';
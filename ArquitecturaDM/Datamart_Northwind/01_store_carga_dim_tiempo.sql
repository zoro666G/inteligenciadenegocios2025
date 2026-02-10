USE [Datamart_Northwind]
GO

CREATE OR ALTER  PROCEDURE [dbo].[usp_Populate_DimDate]
  @StartDate  DATE,                -- fecha inicio (incluida)
  @EndDate    DATE,                -- fecha fin (incluida)
  @AddUnknown BIT          = 1,    -- 1: agrega fila 19000101 (Unknown)
  @Truncate   BIT          = 0,    -- 1: TRUNCATE antes de cargar
  @Culture    NVARCHAR(10) = N'es-MX'  -- locale para el nombre del mes (p.ej. 'es-MX', 'en-US')
AS
BEGIN
  SET NOCOUNT ON;

  -- Validaciones
  IF @StartDate IS NULL OR @EndDate IS NULL
  BEGIN
    RAISERROR('StartDate y EndDate son obligatorias.', 16, 1);
    RETURN;
  END

  IF @StartDate > @EndDate
  BEGIN
    RAISERROR('StartDate no puede ser mayor que EndDate.', 16, 1);
    RETURN;
  END

  -- Guardar y establecer DATEFIRST=1 (lunes) para detectar fin de semana de modo estable
  DECLARE @old_datefirst INT = @@DATEFIRST;
  SET DATEFIRST 1;  -- 1=lunes, entonces 6=sábado, 7=domingo

  -- Truncar si se solicita
  IF @Truncate = 1
    TRUNCATE TABLE dim_date;

  -- Fila Unknown (opcional)
  IF @AddUnknown = 1
  BEGIN
    IF NOT EXISTS (SELECT 1 FROM dim_date WHERE DateKey = 19000101)
    BEGIN
      INSERT dim_date(DateKey, [Date], [Day], [Month], MonthName, [Quarter], [Year], WeekOfYear, IsWeekend)
      VALUES (
        19000101,
        '1900-01-01',
        1,
        1,
        FORMAT(CAST('1900-01-01' AS date), N'MMMM', @Culture),  -- nombre de mes según cultura
        1,
        1900,
        DATEPART(ISO_WEEK, CAST('1900-01-01' AS date)),
        0
      );
    END
  END

  ;WITH d AS
  (
    SELECT @StartDate AS [Date]
    UNION ALL
    SELECT DATEADD(DAY, 1, [Date]) FROM d WHERE [Date] < @EndDate
  )
  INSERT dim_date (DateKey, [Date], [Day], [Month], MonthName, [Quarter], [Year], WeekOfYear, IsWeekend)
  SELECT
    CONVERT(INT, FORMAT([Date], 'yyyyMMdd')),       -- DateKey
    [Date],
    DATEPART(DAY, [Date])       AS [Day],
    DATEPART(MONTH, [Date])     AS [Month],
    UPPER(FORMAT([Date], N'MMMM', @Culture)) AS MonthName, -- nombre de mes localizable
    DATEPART(QUARTER, [Date])   AS [Quarter],
    DATEPART(YEAR, [Date])      AS [Year],
    DATEPART(ISO_WEEK, [Date])  AS WeekOfYear,
    CASE WHEN DATEPART(WEEKDAY, [Date]) IN (6, 7) THEN 1 ELSE 0 END AS IsWeekend
  FROM d
  WHERE NOT EXISTS
  (
    SELECT 1 FROM dim_date x
    WHERE x.DateKey = CONVERT(INT, FORMAT(d.[Date], 'yyyyMMdd'))
  )
  OPTION (MAXRECURSION 0);

  -- Restaurar DATEFIRST
  SET DATEFIRST @old_datefirst;

  -- Resultado informativo
  SELECT
    (SELECT COUNT(*) FROM dim_date)                 AS TotalRowsInDimDate,
    @StartDate AS LoadedFrom,
    @EndDate   AS LoadedTo;
END




EXEC usp_Populate_DimDate
  @StartDate = '1995-01-01',
  @EndDate   = '2001-12-31',
  @AddUnknown = 1,
  @Truncate   = 0,
  @Culture    = N'es-MX';

  SELECT * FROM Datamart_Northwind.dbo.dim_date
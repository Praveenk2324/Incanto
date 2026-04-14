WITH DailyPlantMetrics AS (
    SELECT 
        ProductionDate AS Date,
        Plant,
        SUM(DefectCount) AS DailyDefectCount,
       
        CAST(SUM(DefectCount) AS FLOAT) / NULLIF(SUM(TotalProductionVolume), 0) AS DailyDefectRate
    FROM 
        YourTableName
    GROUP BY 
        ProductionDate, 
        Plant
)
SELECT 
    Date,
    Plant,
    DailyDefectCount,
    DailyDefectRate,
    AVG(DailyDefectRate) OVER (
        PARTITION BY Plant 
        ORDER BY Date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW 
    ) AS Rolling_7Day_Avg_DefectRate
FROM 
    DailyPlantMetrics
ORDER BY 
    Plant, 
    Date;

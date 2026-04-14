WITH DailyPlantMetrics AS (
    SELECT 
        CAST(Timestamp AS DATE) AS Date,
        Plant,
        SUM(DefectCount) AS DailyDefectCount,
       
        CAST(SUM(DefectCount) AS FLOAT) / NULLIF(SUM(ProductionUnits), 0) AS DailyDefectRate
    FROM 
        "QUALITY & DEFECT REDUCTION"
    GROUP BY 
        CAST(Timestamp AS DATE), 
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

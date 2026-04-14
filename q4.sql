CREATE VIEW quality_hotspots_2025 AS
WITH MachineAverages AS (
    SELECT 
        Plant,
        MachineID,
        CAST(SUM(DefectCount) AS FLOAT) / NULLIF(SUM(ProductionUnits), 0) AS Avg_DefectRate,
        AVG(Temperature) AS Avg_Temperature,
        AVG(Vibration) AS Avg_Vibration,
        AVG(Pressure) AS Avg_Pressure
    FROM 
        "QUALITY & DEFECT REDUCTION"
    WHERE 
        Timestamp >= '2025-01-01' AND Timestamp < '2026-01-01'
    GROUP BY 
        Plant, 
        MachineID
),
RankedMachines AS (
    SELECT 
        *,
        PERCENT_RANK() OVER (
            PARTITION BY Plant 
            ORDER BY Avg_DefectRate DESC
        ) AS Defect_PercentRank
    FROM 
        MachineAverages
)
SELECT 
    Plant,
    MachineID,
    Avg_DefectRate,
    Avg_Temperature,
    Avg_Vibration,
    Avg_Pressure
FROM 
    RankedMachines
WHERE 
    Defect_PercentRank <= 0.10;

-- Mengambil semua baris dari tabel 'korporat investasi ke intelijen'
Select *
from [PROJECT PORTOFOLIO]..['korporat investasi ke intelijen$']

-- Mengambil semua baris dari tabel 'number-artificial-intelligence'
Select *
from [PROJECT PORTOFOLIO]..['number-artificial-intelligence-$']

-- Menggabungkan data dari kedua tabel dan menghitung rasio korporat terhadap publikasi
SELECT
    entity,
    code,
    year,
    korporat_total_investment,
    number_publications,
    CASE
        WHEN korporat_total_investment IS NOT NULL AND number_publications IS NOT NULL THEN
            CASE
                WHEN (korporat_total_investment / number_publications) = 0 THEN '0/1'
                ELSE CONCAT(CAST((korporat_total_investment / number_publications) * 100 AS DECIMAL(10, 2)), '%')
            END
        ELSE NULL
    END AS korporat_to_publication_ratio
FROM (
    -- Subquery untuk menggabungkan data dan menghitung jumlah total
    SELECT
        COALESCE(KI.[ENTITY], AI.[ENTITY]) AS entity,
        COALESCE(KI.[CODE], AI.[CODE]) AS code,
        COALESCE(KI.[YEAR], AI.[YEAR]) AS year,
        SUM(KI.[TOTAL_CORPORATE_INVESTMENT_INFLATION_ADJUSTED]) AS korporat_total_investment,
        SUM(AI.[NUMBER_AI_PUBLICATIONS_BY_COUNTRY]) AS number_publications
    FROM
        [PROJECT PORTOFOLIO]..['korporat investasi ke intelijen$'] AS KI
    FULL JOIN
        [PROJECT PORTOFOLIO]..['number-artificial-intelligence-$'] AS AI
        ON KI.[ENTITY] = AI.[ENTITY] AND KI.[CODE] = AI.[CODE] AND KI.[YEAR] = AI.[YEAR]
    GROUP BY
        COALESCE(KI.[ENTITY], AI.[ENTITY]),
        COALESCE(KI.[CODE], AI.[CODE]),
        COALESCE(KI.[YEAR], AI.[YEAR])
) AS merged_data
ORDER BY
    year, code

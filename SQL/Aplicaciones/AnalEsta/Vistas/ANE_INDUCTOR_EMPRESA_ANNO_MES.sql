CREATE OR REPLACE VIEW ANALESTA.ANE_INDUCTOR_EMPRESA_ANNO_MES AS
SELECT V.EMPRESA, V.ANNO, V.MES, V.INDUCTOR, I.INDUCTOR DESCRIPCION_INDUCTOR, SUM(V.VALOR) VALOR
FROM ANE_CONFISRR V, GNR_INDUEMPR I
WHERE V.INDUCTOR = I.CODIGO
  AND EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = V.EMPRESA)
GROUP BY  V.EMPRESA, V.ANNO, V.MES, V.INDUCTOR, I.INDUCTOR
UNION
SELECT 'GR' EMPRESA, V.ANNO, V.MES, V.INDUCTOR, I.INDUCTOR DESCRIPCION_INDUCTOR, SUM(V.VALOR) VALOR
FROM ANE_CONFISRR V, GNR_INDUEMPR I
WHERE V.INDUCTOR = I.CODIGO
  AND EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = V.EMPRESA)
GROUP BY  V.ANNO, V.MES, V.INDUCTOR, I.INDUCTOR;
CREATE OR REPLACE VIEW ANALESTA.ANE_FACTURAC_ANNO_MES_CERRADO AS
SELECT A.ANNO,A.ULTIMO_MES_CARGADO, 
       DECODE(A.ULTIMO_MES_CARGADO,NULL,NULL,
              '12',SUM(NVL(FACTDICI,0))+SUM(NVL(FACTNOVI,0))+SUM(NVL(FACTOCTU,0))+SUM(NVL(FACTSEPT,0))+SUM(NVL(FACTAGOS,0))+SUM(NVL(FACTJULI,0))+SUM(NVL(FACTJUNI,0))+SUM(NVL(FACTMAYO,0))+SUM(NVL(FACTABRI,0))+SUM(NVL(FACTMARZ,0))+SUM(NVL(FACTFEBR,0))+SUM(NVL(FACTENER,0)),
              '11',SUM(NVL(FACTNOVI,0))+SUM(NVL(FACTOCTU,0))+SUM(NVL(FACTSEPT,0))+SUM(NVL(FACTAGOS,0))+SUM(NVL(FACTJULI,0))+SUM(NVL(FACTJUNI,0))+SUM(NVL(FACTMAYO,0))+SUM(NVL(FACTABRI,0))+SUM(NVL(FACTMARZ,0))+SUM(NVL(FACTFEBR,0))+SUM(NVL(FACTENER,0)),
              '10',SUM(NVL(FACTOCTU,0))+SUM(NVL(FACTSEPT,0))+SUM(NVL(FACTAGOS,0))+SUM(NVL(FACTJULI,0))+SUM(NVL(FACTJUNI,0))+SUM(NVL(FACTMAYO,0))+SUM(NVL(FACTABRI,0))+SUM(NVL(FACTMARZ,0))+SUM(NVL(FACTFEBR,0))+SUM(NVL(FACTENER,0)),
              '09',SUM(NVL(FACTSEPT,0))+SUM(NVL(FACTAGOS,0))+SUM(NVL(FACTJULI,0))+SUM(NVL(FACTJUNI,0))+SUM(NVL(FACTMAYO,0))+SUM(NVL(FACTABRI,0))+SUM(NVL(FACTMARZ,0))+SUM(NVL(FACTFEBR,0))+SUM(NVL(FACTENER,0)),
              '08',SUM(NVL(FACTAGOS,0))+SUM(NVL(FACTJULI,0))+SUM(NVL(FACTJUNI,0))+SUM(NVL(FACTMAYO,0))+SUM(NVL(FACTABRI,0))+SUM(NVL(FACTMARZ,0))+SUM(NVL(FACTFEBR,0))+SUM(NVL(FACTENER,0)),
              '07',SUM(NVL(FACTJULI,0))+SUM(NVL(FACTJUNI,0))+SUM(NVL(FACTMAYO,0))+SUM(NVL(FACTABRI,0))+SUM(NVL(FACTMARZ,0))+SUM(NVL(FACTFEBR,0))+SUM(NVL(FACTENER,0)),
              '06',SUM(NVL(FACTJUNI,0))+SUM(NVL(FACTMAYO,0))+SUM(NVL(FACTABRI,0))+SUM(NVL(FACTMARZ,0))+SUM(NVL(FACTFEBR,0))+SUM(NVL(FACTENER,0)),
              '05',SUM(NVL(FACTMAYO,0))+SUM(NVL(FACTABRI,0))+SUM(NVL(FACTMARZ,0))+SUM(NVL(FACTFEBR,0))+SUM(NVL(FACTENER,0)),
              '04',SUM(NVL(FACTABRI,0))+SUM(NVL(FACTMARZ,0))+SUM(NVL(FACTFEBR,0))+SUM(NVL(FACTENER,0)),
              '03',SUM(NVL(FACTMARZ,0))+SUM(NVL(FACTFEBR,0))+SUM(NVL(FACTENER,0)),
              '01',SUM(NVL(FACTFEBR,0))+SUM(NVL(FACTENER,0)),
              '12',SUM(NVL(FACTENER,0))) FACTURACION_ANNO_MES_CERRADO
FROM ANALESTA.ANE_ANNO_MES_PROCESAR A, PRD_CONFFARE CF
WHERE CF.EMPRESA IN (SELECT VALOR FROM VALORES_LISTA WHERE CODIGO = 'GNR_EMPRACGR')
  AND CF.ANNO = A.ANNO
GROUP BY A.ANNO,A.ULTIMO_MES_CARGADO;
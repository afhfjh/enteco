CREATE OR REPLACE VIEW "ANALESTA"."ANE_COSTES_DIRECTOS_DEPA_SECC" AS 
SELECT C.EMPRESA, C.ANNO, C.MES, SE.DEPARTAM, D.DEPARTAM DESCRIPCION_DEPARTAM, C.SECCION, S.SECCION DESCRIPCION_SECCION, C.CONCEPTO, C.COSTE  
FROM ANE_CONFCPDR C, GNR_SPDEEMPR SE, GNR_DEPAEMPR D, GNR_SEPREMPR S
WHERE C.SECCION = SE.SECCION
  AND SE.DEPARTAM = D.CODIGO
  AND C.SECCION = S.CODIGO;
  
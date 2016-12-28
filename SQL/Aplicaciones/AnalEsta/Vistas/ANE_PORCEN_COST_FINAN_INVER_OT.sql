CREATE OR REPLACE VIEW ANALESTA.ANE_PORCEN_COST_FINAN_INVER_OT AS
SELECT A.*, IG.IMPOCUEN INGRESOS_MENOS_GASTOS, F.FACTURACION_ANNO_MES_CERRADO FACTURACION, 
       DECODE(NVL(F.FACTURACION_ANNO_MES_CERRADO,0),0,NULL,IG.IMPOCUEN/F.FACTURACION_ANNO_MES_CERRADO) PORCEN_COST_FINANC_INVER_OT_FX
       --nPOCFOTIN_R
FROM ANALESTA.ANE_ANNO_MES_PROCESAR A,
     ANALESTA.ANE_FACTURAC_ANNO_MES_CERRADO F,
     ANALESTA.ANE_ING_MENOS_GAS_ANNO_MES_CER IG
WHERE A.ANNO = F.ANNO(+)
  AND A.ANNO = IG.ANNO(+);
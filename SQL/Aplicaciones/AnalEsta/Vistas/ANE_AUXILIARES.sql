  CREATE OR REPLACE VIEW "ANALESTA"."ANE_AUXILIARES" AS 
  SELECT ANNO,ULTIMO_MES_CARGADO,PRIMER_DIA,ULTIMO_DIA,
       APLICA_A_EMPRESA_GRUPO,EMPRESA,
       DECODE(FORMULA,'ANE_COMAOTCL.sql','APLICA A TODOS LAS ESPECIALIDADES','ANE_COMAOTCL_IMPRESAS.sql','APLICA A LAS ESPECIALIDADES IMPRESAS','ANE_COMAOTCL_LAQUEADA.sql','APLICA A LAS ESPECIALIDADES LAQUEADAS','ANE_COMAOTCL_LAMINADA.sql','APLICA A LAS ESPECIALIDADES LAMINADAS') APLICA_A_TIPO_ESPECIALIDAD,
       SUM(COSTE_TOTAL_CONTRA_INDUCTOR_FX) COSTE_TOTAL_CONTRA_INDUCTOR_FX,
       MAX(ERROR_ENCONTRADO) ERROR_ENCONTRADO
FROM ANALESTA.ANE_ARTICULOS_AUXILIARES
GROUP BY ANNO,ULTIMO_MES_CARGADO,PRIMER_DIA,ULTIMO_DIA,
         APLICA_A_EMPRESA_GRUPO,EMPRESA,
         FORMULA;
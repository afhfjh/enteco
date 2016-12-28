CREATE OR REPLACE VIEW ANALESTA.ANE_EVENTOS_TIEMPOS_METROS AS 
SELECT D.EMPRESA, D.NUMEOTRE,
       D.EVENTO_MAQUINA,D.MAQUINA,D.OPERADOR,D.FECHA_INICIO_DATO_PRODUCC,D.FECHA_FINAL_DATO_PRODUCC,D.FECHA_PRODUCCION,
       D.TOTAL_EN_MINUTOS_DATO_PRODUCC,
       D.EVENDESC, D.EVENCATE, D.DESCRIPC DESCCATE, 
       D.NIVEL, 
       D.DESCNICA, D.DESCOPER,
       D.ML_AJUSTE_DATO_PRODUCC, D.ML_VENDIBLE_DATO_PRODUCC, D.ML_ERRORES_DATO_PRODUCC,
       D.ML_CONSUMIDO_DATO_PRODUCC,
       D.SECCION_MAQUINA,
       D.TOTAL_MIN_NIV_3_DATO_PRODUCC,
       D.EVENTO_FINALIZADO
FROM (
SELECT D.ID_EMPRESA EMPRESA, D.ID_ORDEN_TRABAJO NUMEOTRE, D.ID_EVENTO_MAQUINA EVENTO_MAQUINA, D.ID_MAQUINA MAQUINA,D.ID_OPERADOR OPERADOR,
             TO_CHAR(P_UTILIDAD.F_FECHA_MINUTOS(D.ID_FECHA_INICIO_DATO_PRODUCC),'DD-MM-YYYY HH24:MI') FECHA_INICIO_DATO_PRODUCC,
             TO_CHAR(P_UTILIDAD.F_FECHA_MINUTOS(D.ID_FECHA_FINAL_DATO_PRODUCC),'DD-MM-YYYY HH24:MI') FECHA_FINAL_DATO_PRODUCC,
             TO_CHAR(P_UTILIDAD.F_FECHA_MINUTOS(D.ID_FECHA_INICIO_DATO_PRODUCC),'DD-MM-YYYY') FECHA_PRODUCCION,
             D.TOTAL_EN_MINUTOS_DATO_PRODUCC,
             E.DESCRIPCION_EVENTO_MAQUINA EVENDESC, E.CATEGORIA_EVENTO_MAQUINA EVENCATE, E.DESC_CATEGORIA_EVENTO_MAQUINA DESCRIPC,
             E.NIVEL_CATEGORIA_EVENTO_MAQUINA NIVEL, 
             E.DESC_NIVEL_CATEGORIA_EVEN_MAQU DESCNICA, O.DESCRIPCION_OPERADOR DESCOPER,
             D.CANTIDAD_ML_AJUSTE_DATO_PRO ML_AJUSTE_DATO_PRODUCC,
             DECODE(M.SECCION_MAQUINA,'Secci�n Cortadoras',
                    DECODE(NVL(D.CANTIDAD_ML_CONSPASA_DATO_PRO,0),0,D.CANTIDAD_ML_PRODUCID_DATO_PRO,0),
                    D.CANTIDAD_ML_PRODUCID_DATO_PRO) ML_VENDIBLE_DATO_PRODUCC,
             DECODE(M.SECCION_MAQUINA,'Secci�n Cortadoras',
                    DECODE(NVL(D.CANTIDAD_ML_CONSPASA_DATO_PRO,0),0,0,
                    D.CANTIDAD_ML_PRODUCID_DATO_PRO),0) ML_ERRORES_DATO_PRODUCC,
             D.CANTIDAD_ML_CONSUMID_DATO_PRO ML_CONSUMIDO_DATO_PRODUCC,
             M.SECCION_MAQUINA,
             DECODE(E.NIVEL_CATEGORIA_EVENTO_MAQUINA,'3',D.TOTAL_EN_MINUTOS_DATO_PRODUCC,0) TOTAL_MIN_NIV_3_DATO_PRODUCC,
             'S' EVENTO_FINALIZADO
      FROM DM_LISTPROD.DM_LP_HE_DATOS_DE_PRODUCCION D, 
           DM_LISTPROD.DM_LP_DI_EVENTOS_DE_MAQUINAS E, 
           DM_LISTPROD.DM_LP_DI_OPERADORES O, 
           DM_LISTPROD.DM_LP_DI_MAQUINAS M
      WHERE D.ID_EVENTO_MAQUINA = E.ID_EVENTO_MAQUINA
        AND D.ID_MAQUINA = M.ID_MAQUINA
        AND D.ID_OPERADOR = O.ID_OPERADOR
UNION ALL
SELECT D.EMPRESA, D.NUMEOTRE, D.EVENCODI EVENTO_MAQUINA,D.MAQUCODI MAQUINA,D.OPERADOR,
             TO_CHAR(P_UTILIDAD.F_FECHA_MINUTOS(D.MINUINIC),'DD-MM-YYYY HH24:MI') FECHA_INICIO_DATO_PRODUCC,
             NULL FECHA_FINAL_DATO_PRODUCC,
             TO_CHAR(P_UTILIDAD.F_FECHA_MINUTOS(D.MINUINIC),'DD-MM-YYYY') FECHA_PRODUCCION,
             NULL TOTAL_EN_MINUTOS_DATO_PRODUCC,
             E.DESCRIPCION_EVENTO_MAQUINA EVENDESC, E.CATEGORIA_EVENTO_MAQUINA EVENCATE, E.DESC_CATEGORIA_EVENTO_MAQUINA DESCRIPC,
             E.NIVEL_CATEGORIA_EVENTO_MAQUINA NIVEL, 
             E.DESC_NIVEL_CATEGORIA_EVEN_MAQU DESCNICA, O.DESCRIPCION_OPERADOR DESCOPER,
             NULL ML_AJUSTE_DATO_PRODUCC,
             NULL ML_VENDIBLE_DATO_PRODUCC,
             NULL ML_ERRORES_DATO_PRODUCC,
             NULL ML_CONSUMIDO_DATO_PRODUCC,
             M.SECCION_MAQUINA,
             NULL TOTAL_MIN_NIV_3_DATO_PRODUCC,
             'N' EVENTO_FINALIZADO
      FROM PRD_PRMAEVEN D, DM_LISTPROD.DM_LP_DI_EVENTOS_DE_MAQUINAS E, DM_LISTPROD.DM_LP_DI_OPERADORES O, DM_LISTPROD.DM_LP_DI_MAQUINAS M
      WHERE D.EVENTIPO||'_'||D.EVENCODI = E.ID_EVENTO_MAQUINA
        AND D.MAQUCODI = M.ID_MAQUINA
        AND D.OPERADOR = O.ID_OPERADOR
        AND D.MINUFINA IS NULL
        AND E.CATEGORIA_EVENTO_MAQUINA IS NOT NULL
) D;
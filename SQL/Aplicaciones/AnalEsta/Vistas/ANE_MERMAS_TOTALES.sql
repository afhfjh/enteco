--------------------------------------------------------
--  DDL for View ANE_MERMAS_TOTALES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ANALESTA"."ANE_MERMAS_TOTALES"  AS 
  SELECT EMPRESA, N_CLIENTE, CLIENTE, OT, FECHA_DE_LA_OT, TIPO_PRD, ESPECIALIDAD, LINEA, LFS, N_CAPAS_TOTALES, CANTIDAD_DE_FASES, ANCHO_CLIENTE, N_DE_CORTES, N_DE_VECES, ANCHO_DE_PRODUCCION, 
       FASE_MP, SECCION_PRODUCTIVA_MP, MAQUINA_MP, 
		 SUM(ML_ENHEBRADO_MAQUINA * (ANCHO_MP/1000)) M2_ENHEBRADO_MAQUINA,
		 SUM(ML_AJ_MAQUINA_MAQUINA * (ANCHO_MP/1000)) M2_AJ_MAQUINA_MAQUINA,
		 SUM(ML_CAMBIO_BOBINA_MAQUINA * (ANCHO_MP/1000)) M2_CAMBIO_BOBINA_MAQUINA,
		 SUM(ML_MERMA_TIRADA_MQUINA * (ANCHO_MP/1000)) M2_MERMA_TIRADA_MQUINA,
		 SUM(ML_SANEAMIENTOS_MAQUINA * (ANCHO_MP/1000)) M2_SANEAMIENTOS_MAQUINA,
		 SUM(ML_MERMA_PROCESO_MQUINA * (ANCHO_MP/1000)) M2_MERMA_PROCESO_MQUINA, 
       SUM(ML_ENHEBRADO_MAQUINA * (ANCHO_MP/1000)) + SUM(ML_AJ_MAQUINA_MAQUINA * (ANCHO_MP/1000)) + SUM(ML_CAMBIO_BOBINA_MAQUINA * (ANCHO_MP/1000)) + SUM(ML_MERMA_TIRADA_MQUINA * (ANCHO_MP/1000)) + SUM(ML_SANEAMIENTOS_MAQUINA * (ANCHO_MP/1000)) + SUM(ML_MERMA_PROCESO_MQUINA * (ANCHO_MP/1000)) M2_MERMA_PRODUCCION_MQ, 
       SUM(EUROS_ML_ENHEBRADO) + SUM(EUROS_ML_AJ_MAQUINA) + SUM(EUROS_ML_CAMBIO_BOBINA) + SUM(EUROS_ML_MERMA_TIRADA) + SUM(EUROS_ML_SANEAMIENTOS) + SUM(EUROS_ML_MERMA_PROCESO) EUROS_MERMA_PRO_MAQ/*,
		 SUM(M2_MERMPLAN) M2_MERMPLAN, SUM(M2_MERMPLAN_EXESO) M2_MERMPLAN_EXESO,
		 SUM(EUR_MERMPLAN) EUR_MERMPLAN, SUM(EUR_MERMPLAN_EXESO) EUR_MERMPLAN_EXESO*/
FROM ANALESTA.ANE_M_PRO
GROUP BY EMPRESA, N_CLIENTE, CLIENTE, OT, FECHA_DE_LA_OT, TIPO_PRD, ESPECIALIDAD, LINEA, LFS, N_CAPAS_TOTALES, CANTIDAD_DE_FASES, ANCHO_CLIENTE, N_DE_CORTES, N_DE_VECES, ANCHO_DE_PRODUCCION, 
         FASE_MP, SECCION_PRODUCTIVA_MP, MAQUINA_MP;

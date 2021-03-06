--------------------------------------------------------
--  DDL for View ANE_M_PRO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ANALESTA"."ANE_M_PRO"  AS 
  SELECT EMPRESA,N_CLIENTE,CLIENTE,OT,FECHA_DE_LA_OT,FECHA_CIERRE_DE_LA_OT,TIPO_PRD,ESPECIALIDAD,LINEA,LFS,N_CAPAS_TOTALES,CANTIDAD_DE_FASES,ANCHO_CLIENTE,N_DE_CORTES,N_DE_VECES,ANCHO_DE_PRODUCCION,
       CASE WHEN TRIM(PEDIDO) IS NOT NULL THEN 'C'
            WHEN TRIM(PEDIDO_TM) IS NOT NULL THEN 'T'
            WHEN TRIM(FECHA_CIERRE_OT_SEMIELABORADO) IS NOT NULL THEN 'P'
            ELSE 'O' 
            END ORIGEN_MP,
       TIPO_MP,COD_MP,LFS_MP,ANCHO_MP,
       CASE WHEN TRIM(PEDIDO) IS NOT NULL THEN UNIDAD_COMPRADA
            WHEN TRIM(FECHA_CIERRE_OT_SEMIELABORADO) IS NOT NULL THEN P_Utilidad.F_ValoDeva('TIPOUNML')
            ELSE P_Utilidad.F_ValoDeva('TIPOUNM2')
            END UNIDAD_ORIGEN,
--P UNITARIO M.P1 ORIGEN
       --SE ADICIONAN
       PRECIO_COMPRA_CALCULADO PRECIO_UNITARIO_MP_M2_COMPRAS, 
       P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO') PRECIO_UNITARIO_MP_M2_ALGORIT, 
		 PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP)) PRECIO_UNIT_MP_M2_ALGO_COSTES,
       DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		 DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) PRECIO_UNITARIO_MP_M2,
       
       LOTE LOTE_CONSUMIDO,
		 
		 --M.PEDIDO, M.LOTE, M.FECHA_RECEPCION, M.FECHA_CIERRE_OT_SEMIELABORADO, 
		 --M.CANTIDAD_COMPRA, M.CANTIDAD_EQUIVALENTE, M.UNIDAD_COMPRADA, M.DIVISA, M.PRECIO_COMPRA,
		 
       P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'TRAZA') TRAZA_P_UNITARIO_MP_M2_ALGORIT,
		 LOG_PRECIO TRAZA_P_UNIT_MP_M2_ALGO_COSTES,
       --
       FASE_MP,
--?IDENTIFICACI�N DEL N� DE FASE 1 MP1
       SECCION_PRODUCTIVA_MP,MAQUINA_MP, 
		 --
		 /*SUM(M2_MERMPLAN) M2_MERMPLAN, 
		 SUM(M2_MERMPLAN_EXESO) M2_MERMPLAN_EXESO,
		 --
		 SUM(M2_MERMPLAN) * 
		 DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		 DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUR_MERMPLAN,
		 SUM(M2_MERMPLAN_EXESO) * 
		 DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		 DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUR_MERMPLAN_EXESO,*/
		 --
       SUM(ML_CONSUMIDOS) ML_CONSUMIDOS,
		 SUM(ML_PRODUCIDOS) ML_PRODUCIDOS,
		 --
		 /*SUM(ML_CONSUMIDOS_REALES) ML_CONSUMIDOS_REALES,
		 SUM(ML_PRODUCIDOS_REALES) ML_PRODUCIDOS_REALES,
		 --
		 SUM(ML_MERMAS_ACUMULADAS_HAS_MAQ) ML_MERMAS_ACUMULADAS_HAS_MAQ,
		 SUM(ML_MERMAS_ACUMULADAS_EN_MAQ) ML_MERMAS_ACUMULADAS_EN_MAQ,*/
		 --
		 SUM(ML_ENHEBRADO_MAQUINA) ML_ENHEBRADO_MAQUINA,SUM(ML_AJ_MAQUINA_MAQUINA) ML_AJ_MAQUINA_MAQUINA,SUM(ML_CAMBIO_BOBINA_MAQUINA) ML_CAMBIO_BOBINA_MAQUINA,SUM(ML_MERMA_TIRADA_MQUINA) ML_MERMA_TIRADA_MQUINA,SUM(ML_SANEAMIENTOS_MAQUINA) ML_SANEAMIENTOS_MAQUINA,SUM(ML_MERMA_PROCESO_MQUINA) ML_MERMA_PROCESO_MQUINA,
       SUM(ML_CONSUMIDOS) * (ANCHO_MP/1000) M2_CONSUMIDOS,
		 SUM(ML_PRODUCIDOS) * (ANCHO_MP/1000) M2_PRODUCIDOS,
		 --
		 SUM(ML_PRODUCIDOS_REALES) * (ANCHO_MP/1000) M2_PRODUCIDOS_REALES,
		 SUM(ML_CONSUMIDOS_REALES) * (ANCHO_MP/1000) M2_CONSUMIDOS_REALES,
		 --
		 SUM(ML_MERMAS_ACUMULADAS_HAS_MAQ) * (ANCHO_MP/1000) M2_MERMAS_ACUMULADAS_HAS_MAQ,
		 SUM(ML_MERMAS_ACUMULADAS_EN_MAQ) * (ANCHO_MP/1000) M2_MERMAS_ACUMULADAS_EN_MAQ,
		 --
		 SUM(ML_ENHEBRADO_MAQUINA) * (ANCHO_MP/1000) M2_ENHEBRADO_MAQUINA,SUM(ML_AJ_MAQUINA_MAQUINA) * (ANCHO_MP/1000) M2_AJ_MAQUINA_MAQUINA,SUM(ML_CAMBIO_BOBINA_MAQUINA) * (ANCHO_MP/1000) M2_CAMBIO_BOBINA_MAQUINA,SUM(ML_MERMA_TIRADA_MQUINA) * (ANCHO_MP/1000) M2_MERMA_TIRADA_MQUINA,SUM(ML_SANEAMIENTOS_MAQUINA) * (ANCHO_MP/1000) M2_SANEAMIENTOS_MAQUINA,SUM(ML_MERMA_PROCESO_MQUINA) * (ANCHO_MP/1000) M2_MERMA_PROCESO_MQUINA,
       /*
		 SUM(ML_CONSUMIDOS) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) PRECIO_ML_CONSUMIDOS,
       SUM(ML_PRODUCIDOS) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) PRECIO_ML_PRODUCIDOS,
       SUM(ML_ENHEBRADO_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) PRECIO_ML_ENHEBRADO,
       SUM(ML_AJ_MAQUINA_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) PRECIO_ML_AJ_MAQUINA,
       SUM(ML_CAMBIO_BOBINA_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) PRECIO_ML_CAMBIO_BOBINA,
       SUM(ML_MERMA_TIRADA_MQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) PRECIO_ML_MERMA_TIRADA,
       SUM(ML_SANEAMIENTOS_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) PRECIO_ML_SANEAMIENTOS,
       SUM(ML_MERMA_PROCESO_MQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) PRECIO_ML_MERMA_PROCESO,
       --
       SUM(ML_ENHEBRADO_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) +
       SUM(ML_AJ_MAQUINA_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) +
       SUM(ML_CAMBIO_BOBINA_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) +
       SUM(ML_MERMA_TIRADA_MQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) +
       SUM(ML_SANEAMIENTOS_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) +
       SUM(ML_MERMA_PROCESO_MQUINA) * (ANCHO_MP/1000) * DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO) EUROS_MERMA_TOTAL_MAQUINA
		 */
		 SUM(ML_CONSUMIDOS) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                        DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUROS_ML_CONSUMIDOS,
       SUM(ML_PRODUCIDOS) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                        DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUROS_ML_PRODUCIDOS,
       SUM(ML_CONSUMIDOS_REALES) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                        DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUROS_ML_CONSUMIDOS_REALES,
       SUM(ML_PRODUCIDOS_REALES) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                        DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUROS_ML_PRODUCIDOS_REALES,
															 
		 SUM(ML_MERMAS_ACUMULADAS_HAS_MAQ) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                        DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUR_MERMAS_ACUMULADAS_HAS_MAQ,
		 SUM(ML_MERMAS_ACUMULADAS_EN_MAQ) * (ANCHO_MP/1000) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                        DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUR_MERMAS_ACUMULADAS_EN_MAQ,												 
															 
		 SUM(ML_ENHEBRADO_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                               DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUROS_ML_ENHEBRADO,
       SUM(ML_AJ_MAQUINA_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                                DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUROS_ML_AJ_MAQUINA,
       SUM(ML_CAMBIO_BOBINA_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                                   DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUROS_ML_CAMBIO_BOBINA,
       SUM(ML_MERMA_TIRADA_MQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                                 DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUROS_ML_MERMA_TIRADA,
       SUM(ML_SANEAMIENTOS_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                                  DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUROS_ML_SANEAMIENTOS,
       SUM(ML_MERMA_PROCESO_MQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                                  DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUROS_ML_MERMA_PROCESO,
       --
       SUM(ML_ENHEBRADO_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                               DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) +
       SUM(ML_AJ_MAQUINA_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                                DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) +
       SUM(ML_CAMBIO_BOBINA_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                                   DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) +
       SUM(ML_MERMA_TIRADA_MQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                                 DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) +
       SUM(ML_SANEAMIENTOS_MAQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                                  DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) +
       SUM(ML_MERMA_PROCESO_MQUINA) * (ANCHO_MP/1000) * DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		                                                  DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) EUROS_MERMA_TOTAL_MAQUINA,
       FECHA_FACTURA, UNIDAD_CIERRE, CANTIDAD_ML Q_CERRADA_ML, CANTIDAD_M2 Q_CERRADA_M2, CANTIDAD_KG Q_CERRADA_KG, CANTIDAD_UN Q_CERRADA_UN, FUENTE_DEL_CIERRE,
		 --
		 /*SUM(M2_MERMPLAN) + SUM(M2_MERMPLAN_EXESO) TOTAL_M2_MERMPLAN,
		 --
		 SUM(M2_MERMPLAN) * 
		 DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		 DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) +
		 SUM(M2_MERMPLAN_EXESO) * 
		 DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		 DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))) TOTAL_EUROS_MERMPLAN,*/
		 SUM(ML_CONSUMIDOS_REALES) - SUM(ML_PRODUCIDOS_REALES) ML_MERMA_TOTAL,
		 (SUM(ML_CONSUMIDOS_REALES) - SUM(ML_PRODUCIDOS_REALES)) * (ANCHO_MP/1000) M2_MERMA_TOTAL
FROM(
SELECT M.EMPRESA,
       A.CLIENASOC N_CLIENTE,
       C.RAZON_SOC CLIENTE,
       M.NUMEOTRE OT,
       O.FEC_MODI FECHA_DE_LA_OT,
		 DECODE(O.SITUACIO,'C',O.FEC_MODI,NULL)FECHA_CIERRE_DE_LA_OT,
       O.TIP_ARTI TIPO_PRD,
       O.COD_ARTI ESPECIALIDAD,
       SUBSTR(A.COD_LFS,1,2) LINEA,
       A.COD_LFS LFS,
       (SELECT COUNT(DISTINCT LFS.COD_LFS) FROM FIC_LINEOTRE LO, ARTICULO A, LFS 
			 WHERE LO.EMPRESA = A.EMPRESA 
			   AND LO.TIP_ARES = A.TIP_ARTI
				AND LO.COD_ARES = A.COD_ARTI
				AND A.EMPRESA = LFS.EMPRESA
				AND A.COD_LFS = LFS.COD_LFS
			   AND LO.EMPRESA = O.EMPRESA 
            AND LO.ANNO = O.ANNO
				AND LO.NUMERO = O.NUMERO) N_CAPAS_TOTALES,
       (SELECT COUNT(*) FROM FIC_LINEOTRE LO 
			 WHERE LO.EMPRESA = O.EMPRESA 
            AND LO.ANNO = O.ANNO
				AND LO.NUMERO = O.NUMERO
            AND (INSTR(LO.COD_ARES,'IMPRESORA') != 0 OR INSTR(LO.COD_ARES,'LAMINADORA') != 0 OR INSTR(LO.COD_ARES,'LAQUEADORA') != 0 OR INSTR(LO.COD_ARES,'CORTADORA') != 0)) CANTIDAD_DE_FASES,
       DECODE(O.TIP_ARTI,P_UTILIDAD.F_VALODEVA('TIARPROI'),(SELECT PI.ANCHO FROM FIC_HPIGESTI PI WHERE PI.EMPRESA = O.EMPRESA AND PI.NUMEPEDI = O.NUMEPEDI),A.ANCHO) ANCHO_CLIENTE,
       --SE ADICIONA
		 ANALESTA.P_ANE_MERMLAMI_PRAG.F_Cortes_Material(O.EMPRESA, O.NUMERO, (SELECT MAX(LO.FASE) FROM FIC_LINEOTRE LO
																							   WHERE LO.EMPRESA = O.EMPRESA 
																								  AND LO.NUMERO = O.NUMERO
																								  AND ((INSTR(LO.COD_ARES,'IMPRESORA') != 0) OR
																								       (INSTR(LO.COD_ARES,'CORTADORA') != 0) OR
																										 (INSTR(LO.COD_ARES,'LAMINADORA') != 0) OR
																										 (INSTR(LO.COD_ARES,'LAQUEADORA') != 0)))) N_DE_CORTES,
       --                                                                        
		 ANALESTA.P_ANE_MERMLAMI_PRAG.F_Cortes_Material_Exp_OT(O.EMPRESA, O.NUMERO, (SELECT MAX(LO.FASE) FROM FIC_LINEOTRE LO
																							   WHERE LO.EMPRESA = O.EMPRESA 
																								  AND LO.NUMERO = O.NUMERO
																								  AND ((INSTR(LO.COD_ARES,'IMPRESORA') != 0) OR
																								       (INSTR(LO.COD_ARES,'CORTADORA') != 0) OR
																										 (INSTR(LO.COD_ARES,'LAMINADORA') != 0) OR
																										 (INSTR(LO.COD_ARES,'LAQUEADORA') != 0)))) N_DE_VECES,
		 CASE WHEN MP.FASE IS NULL THEN ANALESTA.P_ANE_MERMLAMI_PRAG.F_Cortes_Material_Exp_OT(M.EMPRESA, M.NUMEOTRE, (SELECT MAX(LO.FASE) FROM FIC_LINEOTRE LO
																							   WHERE LO.EMPRESA = M.EMPRESA 
																								  AND LO.NUMERO = M.NUMEOTRE
																								  AND ((INSTR(LO.COD_ARES,'IMPRESORA') != 0) OR
																								       (INSTR(LO.COD_ARES,'CORTADORA') != 0) OR
																										 (INSTR(LO.COD_ARES,'LAMINADORA') != 0) OR
																										 (INSTR(LO.COD_ARES,'LAQUEADORA') != 0)))) * DECODE(O.TIP_ARTI,P_UTILIDAD.F_VALODEVA('TIARPROI'),(SELECT PI.ANCHO FROM FIC_HPIGESTI PI WHERE PI.EMPRESA = O.EMPRESA AND PI.NUMEPEDI = O.NUMEPEDI),A.ANCHO)--A.ANCHO
            ELSE ANALESTA.P_ANE_MERMLAMI_PRAG.F_Cortes_Material_Exp_OT(M.EMPRESA, M.NUMEOTRE, MP.FASE) * DECODE(O.TIP_ARTI,P_UTILIDAD.F_VALODEVA('TIARPROI'),(SELECT PI.ANCHO FROM FIC_HPIGESTI PI WHERE PI.EMPRESA = O.EMPRESA AND PI.NUMEPEDI = O.NUMEPEDI),A.ANCHO)--A.ANCHO
            END ANCHO_DE_PRODUCCION,
(SELECT C.PCNROP FROM FV_ASCOAL02 C WHERE C.EMCODI = M.EMPRESA AND C.VATCOD = M.TIP_ARTI AND C.ARCARF = M.COD_ARTI AND C.ASLOTE = P_UTILIDAD.F_VALOCAMPO(M.LOTE,'LOTE') AND ROWNUM = 1) PEDIDO,
(SELECT C.NUMEPECO FROM FIC_ENMAMATE C WHERE C.EMPRESA = M.EMPRESA AND C.TIP_ARTI = M.TIP_ARTI AND C.COD_ARTI = M.COD_ARTI AND C.LOTE = P_UTILIDAD.F_VALOCAMPO(M.LOTE,'LOTE') AND ROWNUM = 1) PEDIDO_TM,
DECODE(M.TIP_ARTI,P_UTILIDAD.F_VALODEVA('TIARSEF4'),(SELECT OS.FEC_MODI FROM FIC_CABEOTRE OS WHERE OS.EMPRESA = M.EMPRESA AND TO_CHAR(OS.NUMERO) = P_UTILIDAD.F_VALOCAMPO(M.LOTE,'LOTE') AND OS.TIP_ARTI = M.TIP_ARTI AND OS.COD_ARTI = M.COD_ARTI AND OS.SITUACIO = 'C')) FECHA_CIERRE_OT_SEMIELABORADO,
(
         SELECT DECODE(C.ALUNST,P_Utilidad.F_ValoDeva('TIPOUNM2'),DECODE(NVL(C.ALUPRE,0),0,DECODE(NVL(C.ALCANT,0), 0, 0,((C.ALPREU * D.CAMBIO) * C.ALCAEQ) / C.ALCANT),
                                                                  DECODE(NVL(C.ALCANT,0), 0, 0,(((C.ALPREU * D.CAMBIO) * C.ALCAEQ) / C.ALCANT) / C.ALUPRE) 
                      ))ALPREU  
         FROM FV_ASCOAL02 C, GNR_DICOTIZA D, FV_ASCOAL01 CA
            WHERE CA.EMCODI = C.EMCODI
              AND CA.DICODI = C.DICODI
              AND CA.ACANYA = C.ACANYA
              AND CA.ACNROA = C.ACNROA
              AND CA.TIPDOC IS NULL
              AND C.DIVISA = D.DIVISA
              AND D.DIVISAMA = P_UTILIDAD.F_VALODEVA('DIVIEURO')
              AND TRUNC(C.ACFENT) BETWEEN TRUNC(DESDFECH) AND TRUNC(HASTFECH)
              AND (C.VATCOD != P_UTILIDAD.F_VALODEVA('TIARMPF4') OR (C.VATCOD = P_UTILIDAD.F_VALODEVA('TIARMPF4') AND C.VNACOD IN ('1','43','16','46')))
              AND C.EMCODI = M.EMPRESA
              AND C.VATCOD = M.TIP_ARTI
              AND C.ARCARF = M.COD_ARTI
              AND C.ASLOTE = P_UTILIDAD.F_VALOCAMPO(M.LOTE,'LOTE')
              AND ROWNUM = 1) PRECIO_COMPRA_CALCULADO,
O.FEC_MODI, 
P_UTILIDAD.F_VALOCAMPO(M.LOTE,'LOTE') LOTE,
       M.TIP_ARTI TIPO_MP,
       M.COD_ARTI COD_MP,
       AM.COD_LFS LFS_MP,
       --AM.ANCHO ANCHO_MP,
      
DECODE(AM.ANCHO,NULL
      /*,(SELECT DC.ANCHO 
      FROM PRD_LIBOCORT C,
           (SELECT M.EMPRESA, M.NUMEOTRE, M.FASESEQU, M.CONTADOR FROM PRD_MAQURUTA M
            WHERE NOT EXISTS (SELECT 'X' FROM PRD_HCABEOTR O WHERE O.EMPRESA = M.EMPRESA AND O.NUMEOTRE = M.NUMEOTRE)
            UNION
            SELECT M.EMPRESA, M.NUMEOTRE, M.FASESEQU, M.CONTADOR FROM PRD_HMAQURUT M) MA, 
           FIC_LIPCORTR DC 
            WHERE MA.EMPRESA = DC.EMPRESA
              AND MA.NUMEOTRE = DC.NUMERO
              AND SUBSTR(MA.NUMEOTRE,1,4) = DC.ANNO
              AND MA.FASESEQU = (DC.FASE * 100) + DC.SECUENCI
              AND MA.EMPRESA = C.EMPRESA
              AND MA.NUMEOTRE = C.NUMEOTRE
              AND MA.CONTADOR = C.CONTADOR
              AND DC.NUM_CORTE = C.NUMECORT
              --|:10|:2013000002|:1|:2|LOTE:2013000002
              --P_UTILIDAD.F_VALOCAMPO(M.LOTE,'LOTE')
              AND MA.EMPRESA = P_UTILIDAD.F_VALOCAMPO(M.LOTE,'EMPRBOBI')
              AND MA.NUMEOTRE = P_UTILIDAD.F_VALOCAMPO(M.LOTE,'NUOTBOBI')
              AND C.CONTADOR = P_UTILIDAD.F_VALOCAMPO(M.LOTE,'CONTBOBI')
              AND C.CONTBOBI = P_UTILIDAD.F_VALOCAMPO(M.LOTE,'COBOBOBI'))*/
		,M.ANCHO
		,AM.ANCHO) ANCHO_MP,
      
(SELECT C.ALUNCO FROM FV_ASCOAL02 C WHERE C.EMCODI = M.EMPRESA AND C.VATCOD = M.TIP_ARTI AND C.ARCARF = M.COD_ARTI AND C.ASLOTE = P_UTILIDAD.F_VALOCAMPO(M.LOTE,'LOTE') AND ROWNUM = 1) UNIDAD_COMPRADA,
--UNIDAD M.P1 ORIGEN
--P UNITARIO M.P1 ORIGEN
       MP.CONTADOR FASE_MP,
--IDENTIFICACI�N DEL N� DE FASE 1 MP1
       DECODE(INSTR(MP.MAQUCODI,'CORTADORA'),1,'Secci�n Cortadoras',DECODE(INSTR(MP.MAQUCODI,'IMPRESORA'),1,'Secci�n Impresoras',DECODE(INSTR(MP.MAQUCODI,'LAMINADORA'),1,'Secci�n Laminadoras',DECODE(INSTR(MP.MAQUCODI,'LAQUEADORA'),1,'Secci�n Laqueadoras')))) SECCION_PRODUCTIVA_MP,
       MP.MAQUCODI MAQUINA_MP,
       --SE ADICIONAN
       NVL(M.CANTCONS,0) ML_CONSUMIDOS,
       NVL(M.CANTPROD,0) ML_PRODUCIDOS,
		 --
		 NVL(M.CANTCORE,0) ML_CONSUMIDOS_REALES,
		 NVL(M.CANTPRRE,0) ML_PRODUCIDOS_REALES,
		 --
		 NVL(M.MEACSAFI,0) ML_MERMAS_ACUMULADAS_HAS_MAQ,
		 NVL(M.MEACSFMA,0) ML_MERMAS_ACUMULADAS_EN_MAQ,
       --
       NVL(M.MERMENHE,0) ML_ENHEBRADO_MAQUINA,
       NVL(M.MERMAJUS,0) ML_AJ_MAQUINA_MAQUINA,
       NVL(M.MERMCABO,0) ML_CAMBIO_BOBINA_MAQUINA,
       NVL(M.MERMTIRA,0) ML_MERMA_TIRADA_MQUINA,
       NVL(M.MERMSANE,0) ML_SANEAMIENTOS_MAQUINA,
       NVL(M.CANTCORE,0) - NVL(M.CANTPRRE,0) - NVL(M.MERMENHE,0) - NVL(M.MERMAJUS,0) - NVL(M.MERMCABO,0) - NVL(M.MERMTIRA,0) - NVL(M.MERMSANE,0) ML_MERMA_PROCESO_MQUINA,
		 M.PRECIO_ML, M.LOG_PRECIO, 
		 --
		 NVL(M.CANTCONS,0)*(NVL(M.MM_MERMPLAN,0)/1000) M2_MERMPLAN, 
		 NVL(M.CANTCONS,0)*(NVL(M.MM_MERMPLAN_EXESO,0)/1000) M2_MERMPLAN_EXESO,
       --
		 --M.MM_MERMPLAN,
		 --M.MM_MERMPLAN_EXESO
		 FA.CFFALT FECHA_FACTURA,
		 --
         DECODE(NVL(ALB.LPCANT,0),0,O.UNIDAD,ALB.VUCVEN) UNIDAD_CIERRE,
			--
			DECODE(DECODE(NVL(ALB.LPCANT,0),0,O.UNIDAD,ALB.VUCVEN),P_Utilidad.F_ValoDeva('TIPOUNML'),1,
			                                                       DECODE(NVL(F.ANCHO,0),0,0,DECODE(DECODE(NVL(ALB.LPCANT,0),0,O.UNIDAD,ALB.VUCVEN),P_Utilidad.F_ValoDeva('TIPOUNKG'),F.FCKG * (1000 / F.ANCHO),
																					 P_Utilidad.F_ValoDeva('TIPOUNM2'),(1000 / F.ANCHO),
																				    P_Utilidad.F_ValoDeva('TIPOUNUN'),(1000 / F.ANCHO) * ((F.ANCHO * F.LARGO) / 1000000)))) 
																				  * DECODE(NVL(ALB.LPCANT,0),0,O.CANTCERR,ALB.LPCANT) CANTIDAD_ML,
         --
			DECODE(DECODE(NVL(ALB.LPCANT,0),0,O.UNIDAD,ALB.VUCVEN),P_Utilidad.F_ValoDeva('TIPOUNM2'),1,
			                                                       P_Utilidad.F_ValoDeva('TIPOUNKG'),F.FCKG,
																					 P_Utilidad.F_ValoDeva('TIPOUNML'),(F.ANCHO / 1000),
																					 P_Utilidad.F_ValoDeva('TIPOUNUN'),(F.ANCHO * F.LARGO) / 1000000) 
																				  * DECODE(NVL(ALB.LPCANT,0),0,O.CANTCERR,ALB.LPCANT) CANTIDAD_M2,
         --
			DECODE(DECODE(NVL(ALB.LPCANT,0),0,O.UNIDAD,ALB.VUCVEN),P_Utilidad.F_ValoDeva('TIPOUNKG'),1,DECODE(NVL(F.FCKG,0),0,0,DECODE(DECODE(NVL(ALB.LPCANT,0),0,O.UNIDAD,ALB.VUCVEN),P_Utilidad.F_ValoDeva('TIPOUNML'),(1 / F.FCKG) * (F.ANCHO / 1000),
                                                                                                        P_Utilidad.F_ValoDeva('TIPOUNM2'),1 / F.FCKG,
                                                                                                        P_Utilidad.F_ValoDeva('TIPOUNUN'),(1 / F.FCKG) * ((F.ANCHO * F.LARGO) / 1000000)))) * DECODE(NVL(ALB.LPCANT,0),0,O.CANTCERR,ALB.LPCANT) CANTIDAD_KG,
			DECODE(DECODE(NVL(ALB.LPCANT,0),0,O.UNIDAD,ALB.VUCVEN),P_Utilidad.F_ValoDeva('TIPOUNUN'),1,P_Utilidad.F_ValoDeva('TIPOUNML'),DECODE(NVL(F.ANCHO,0)*NVL(F.LARGO,0),0,0,(1 / ((1000 / F.ANCHO) * ((F.ANCHO * F.LARGO) / 1000000)))),
                                                                              P_Utilidad.F_ValoDeva('TIPOUNM2'),DECODE(NVL(F.ANCHO,0)*NVL(F.LARGO,0),0,0,(1000000 / (F.ANCHO * F.LARGO))),
                                                                              P_Utilidad.F_ValoDeva('TIPOUNKG'),DECODE(NVL(F.ANCHO,0)*NVL(F.LARGO,0)*NVL(F.FCKG,0),0,0,(1 / ((1 / F.FCKG) * ((F.ANCHO * F.LARGO) / 1000000))))) * DECODE(NVL(ALB.LPCANT,0),0,O.CANTCERR,ALB.LPCANT) CANTIDAD_UN,
DECODE(NVL(ALB.LPCANT,0),0,'CIERRE DE OT','EXPEDICION') FUENTE_DEL_CIERRE
FROM ANALESTA.ANE_MER_MATERIAL_OT M, FIC_CABEOTRE O, ARTICULO A, ARTICULO AM, CLIENTES C,
     (SELECT MA.EMPRESA, MA.NUMEOTRE, MA.CONTADOR, DECODE(INSTR(MA.MAQUCODI,'CORTADORA'),0,NULL,L.FASE) FASE, L.FASE FASEBUMP, MA.MAQUCODI--, MIN(MP.IZQUIERD) IZQUIERD, MIN(MP.DERECHA) DERECHA 
      FROM --PRD_MAQUMPLA MP, 
           (SELECT MR.EMPRESA, MR.NUMEOTRE, MR.CONTADOR, MR.FASESEQU, MR.MAQUTIPO, MR.MAQUCODI, MR.ESTADO FROM PRD_MAQURUTA MR
            WHERE NOT EXISTS (SELECT 'X' FROM PRD_HCABEOTR OTC WHERE OTC.EMPRESA = MR.EMPRESA AND OTC.NUMEOTRE = MR.NUMEOTRE)
            UNION
            SELECT MR.EMPRESA, MR.NUMEOTRE, MR.CONTADOR, MR.FASESEQU, MR.MAQUTIPO, MR.MAQUCODI, MR.ESTADO FROM PRD_HMAQURUT MR) MA, 
           FIC_LINEOTRE L
         WHERE /*MP.EMPRESA = MA.EMPRESA
           AND MP.MAQUTIPO = MA.MAQUTIPO
           AND MP.MAQUCODI = MA.MAQUCODI
           AND */L.EMPRESA = MA.EMPRESA
           AND L.NUMERO = MA.NUMEOTRE
           AND L.TIP_ARES = P_UTILIDAD.F_VALODEVA('TIPORECU')
           AND (L.COD_ARES NOT LIKE 'CORTADORA%' OR --Si es diferente de Cortadora 
                (                                   --o
                 L.COD_ARES LIKE 'CORTADORA%' AND NOT EXISTS (SELECT 'X'
                                                              FROM VALORES_LISTA V
                                                              WHERE V.CODIGO = 'FIC_TIPIRECU'
                                                                AND INSTR(L.COD_ARES,P_UTILIDAD.F_VALOCAMPO(V.VALOR,'RECURSO')) != 0
                                                                AND P_UTILIDAD.F_VALOCAMPO(V.VALOR,'CODIGO') = L.TIPIRECU
                                                                AND P_UTILIDAD.F_VALOCAMPO(V.VALOR,'PRE-CORTE') = 'S')--L.FASE = L.FASESIGU --Si es cortadora pero no es pre-corte
                )
               )
           AND MA.FASESEQU = (L.FASE * 100) + L.SECUENCI
           --AND TIPO = 'E'
      --GROUP BY MA.EMPRESA, MA.NUMEOTRE, MA.CONTADOR, DECODE(INSTR(MA.MAQUCODI,'CORTADORA'),0,NULL,L.FASE)
      ) MP,
     (SELECT LO.EMCODI, LO.ASLOTE, LO.CFNDEF, FA.CFFALT
      FROM FV_ASVELO01 LO, FV_ASVEFA01 FA
      WHERE LO.EMCODI = FA.EMCODI
        AND LO.CFNDEF = FA.CFNDEF) FA,
     (SELECT O.EMPRESA, O.NUMERO, A.VUCVEN, SUM(A.LACANT) LPCANT --Unidad y Cantidad de Expedici�n de Albaranes
            FROM FV_ASVEALH02 A, 
                 FIC_CABEOTRE O,
                 (SELECT DISTINCT EMCODI, CPNROP, ASLOTE, ALNROP, VATCOD, ARCARF, CFNROF FROM FV_ASVELO01 WHERE PROCED = 'F') L
            WHERE A.EMCODI = O.EMPRESA
              AND A.VATCOD = O.TIP_ARTI
              AND A.ARCARF = O.COD_ARTI
              AND A.DICODI = '01'
              AND A.ASCANA = 1
              AND A.CPNROP = O.NUMEPEDI
              AND L.EMCODI = A.EMCODI
              AND L.ALNROP = A.ALNROP
              AND L.VATCOD = A.VATCOD
              AND L.ARCARF = A.ARCARF
              AND L.CPNROP = A.CPNROP
              AND L.EMCODI = O.EMPRESA
              AND L.ASLOTE = TO_CHAR(O.NUMERO)
              AND L.CPNROP = O.NUMEPEDI
              AND NVL(L.CFNROF,0) != 0
              AND EXISTS (SELECT 'X' FROM FV_ASVEFA02 F
                         WHERE F.EMCODI = O.EMPRESA
                           AND F.DICODI = '01'
                           AND F.ASCANA = 1
                           AND F.CPNROP = O.NUMEPEDI
                           AND F.VATCOD = O.TIP_ARTI
                           AND F.ARCARF = O.COD_ARTI)--Este Facturada la OT
              /*AND NOT EXISTS (SELECT 'X' FROM FIC_LINEPEDI P
                              WHERE P.EMPRESA = O.EMPRESA
                                AND P.NUMEPEDI = O.NUMEPEDI
                                AND P.TIP_ARTI = O.TIP_ARTI
                                AND P.COD_ARTI = O.COD_ARTI)--No quede Pendiente nada por Generar Albaran*/
              AND O.TIP_ARTI = P_UTILIDAD.F_VALODEVA('TIARFIF4')
         GROUP BY O.EMPRESA, O.NUMERO, A.VUCVEN) ALB,
	(SELECT F.EMPRESA, F.TIP_ARTI, F.PRODUCTO, F.MODI, F.REVI, F.ANCHO, F.LARGO, LFS.FCKG FROM HFICTEC F, LFS
	 WHERE F.EMPRESA = LFS.EMPRESA
		AND F.MATBASE = LFS.COD_LFS
    UNION
	 SELECT F.EMPRESA, F.TIP_ARTI, F.PRODUCTO, 0 MODI, 0 REVI, F.ANCHO, F.LARGO, LFS.FCKG FROM FIC_SEGESTI F, LFS
	 WHERE F.EMPRESA = LFS.EMPRESA
		AND F.MATBASE = LFS.COD_LFS
	 UNION
	 SELECT F.EMPRESA, P_UTILIDAD.F_VALODEVA('TIARPROI') TIP_ARTI, TO_CHAR(F.NUMEPEDI) PRODUCTO, 0 MODI, 0 REVI, F.ANCHO, NULL LARGO, LFS.FCKG FROM FIC_HPIGESTI F, LFS
	 WHERE F.EMPRESA = LFS.EMPRESA
		AND F.MATBASE = LFS.COD_LFS) F
WHERE 
      --(M.TIP_ARTI IN (P_UTILIDAD.F_VALODEVA('TIARMPF4'),P_UTILIDAD.F_VALODEVA('TIARSEF4'),P_UTILIDAD.F_VALODEVA('TIARFIF4')) OR (M.TIP_ARTI = P_UTILIDAD.F_VALODEVA('TIARCOSC') AND M.NUMEOTRE != P_UTILIDAD.F_VALOCAMPO(M.LOTE,'LOTE') AND P_UTILIDAD.F_VALOCAMPO(M.LOTE,'LOTE') IS NOT NULL))
  --AND 
      M.EMPRESA = O.EMPRESA
  AND M.NUMEOTRE = O.NUMERO
  AND O.EMPRESA = A.EMPRESA
  AND O.TIP_ARTI = A.TIP_ARTI
  AND O.COD_ARTI = A.COD_ARTI
  AND M.EMPRESA = AM.EMPRESA(+)
  AND M.TIP_ARTI = AM.TIP_ARTI(+)
  AND M.COD_ARTI = AM.COD_ARTI(+)
  AND A.EMPRESA = C.EMPRESA(+)
  AND A.CLIENASOC = C.CLIENTE_ID(+)
  AND M.EMPRESA = MP.EMPRESA(+)
  AND M.NUMEOTRE = MP.NUMEOTRE(+)
  AND M.CONTADOR = MP.CONTADOR(+)
  --
  AND O.EMPRESA = FA.EMCODI(+)
  AND O.NUMERO = FA.ASLOTE(+)
  --
  AND O.EMPRESA = ALB.EMPRESA(+)
  AND O.NUMERO = ALB.NUMERO(+)
  --
  /*AND O.EMPRESA = F.EMPRESA(+)
  AND O.TIP_ARTI = F.TIP_ARTI(+)
  AND O.COD_ARTI = F.PRODUCTO(+)
  AND NVL(O.MODI,0) = F.MODI(+)
  AND NVL(O.REVI,0) = F.REVI(+)*/
  AND O.EMPRESA = F.EMPRESA
  AND (
       (O.TIP_ARTI = P_UTILIDAD.F_VALODEVA('TIARFIF4') AND O.TIP_ARTI = F.TIP_ARTI AND O.COD_ARTI = F.PRODUCTO AND O.MODI = F.MODI AND O.REVI = F.REVI)
	 OR (O.TIP_ARTI = P_UTILIDAD.F_VALODEVA('TIARSEF4')  AND O.TIP_ARTI = F.TIP_ARTI AND O.COD_ARTI = F.PRODUCTO)
	 OR (O.TIP_ARTI = P_UTILIDAD.F_VALODEVA('TIARPROI')  AND TO_CHAR(O.NUMEPEDI) = F.PRODUCTO)
	   )
  --
  AND NVL(M.CANTCONS,0) != 0 --Filtra Materiales en 0
  --AND M.EMPRESA = '10' AND TRUNC(O.FEC_MODI) = TO_DATE('03-10-2016')
  )
  GROUP BY EMPRESA,N_CLIENTE,CLIENTE,OT,FECHA_DE_LA_OT,FECHA_CIERRE_DE_LA_OT,TIPO_PRD,ESPECIALIDAD,LINEA,LFS,N_CAPAS_TOTALES,CANTIDAD_DE_FASES,ANCHO_CLIENTE,N_DE_CORTES,N_DE_VECES,ANCHO_DE_PRODUCCION,
           TIPO_MP,COD_MP,LFS_MP,ANCHO_MP,
           CASE WHEN TRIM(PEDIDO) IS NOT NULL THEN 'C'
                WHEN TRIM(PEDIDO_TM) IS NOT NULL THEN 'T'
                WHEN TRIM(FECHA_CIERRE_OT_SEMIELABORADO) IS NOT NULL THEN 'P'
                ELSE 'O' 
                END,
           TIPO_MP,COD_MP,LFS_MP,ANCHO_MP,
           CASE WHEN TRIM(PEDIDO) IS NOT NULL THEN UNIDAD_COMPRADA
                WHEN TRIM(FECHA_CIERRE_OT_SEMIELABORADO) IS NOT NULL THEN P_Utilidad.F_ValoDeva('TIPOUNML')
                ELSE P_Utilidad.F_ValoDeva('TIPOUNM2')
                END,
           PRECIO_COMPRA_CALCULADO, 
           P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'), 
			  PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP)),
           DECODE(NVL((PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),0),0,--Prevalece el precio de costes
		     DECODE(NVL(PRECIO_COMPRA_CALCULADO,0),0,P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'PRECIO'),PRECIO_COMPRA_CALCULADO),PRECIO_ML * DECODE(NVL(ANCHO_MP,0),0,0,(1000/ANCHO_MP))),
           LOTE,
			  P_UTILIDAD.F_VALOCAMPO(ANALESTA.P_ANE_MERMLAMI_PRAG.F_PRECIO(EMPRESA,TIPO_MP,COD_MP,FEC_MODI),'TRAZA'),
			  LOG_PRECIO,
           FASE_MP,
           SECCION_PRODUCTIVA_MP,MAQUINA_MP,
			  FECHA_FACTURA, UNIDAD_CIERRE, CANTIDAD_ML, CANTIDAD_M2, CANTIDAD_KG, CANTIDAD_UN, FUENTE_DEL_CIERRE;

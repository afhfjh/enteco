  CREATE OR REPLACE FORCE VIEW "ANALESTA"."ANE_COS_SECC_PROD_ANNO_MES_CER" AS 
  SELECT A.ANNO, A.ULTIMO_MES_CARGADO,
       COSE.SECCION, COSE.DESCRIPCION_SECCION,
       SUM(COSE.COSTE_SECCION_PRODUCTIVA) COSTE_SECCION_PRODUCTIVA, 
       DECODE(COSE.DESCRIPCION_SECCION,'MONTAJE',
              NULL,
              SUM(COSE.HORAS_SECCION_PRODUCTIVA)) HORAS_SECCION_PRODUCTIVA,
       DECODE(COSE.DESCRIPCION_SECCION,'MONTAJE',
              ANALESTA.P_ANE_MERMLAMI_PRAG.F_Total_InduRepa(A.ANNO,P_Utilidad.F_ValoDeva('INDUREOI')),
              NULL) NUMERO_OTS_IMPRESAS,
       DECODE(COSE.DESCRIPCION_SECCION,'MONTAJE',
              DECODE(NVL(ANALESTA.P_ANE_MERMLAMI_PRAG.F_Total_InduRepa(A.ANNO,P_Utilidad.F_ValoDeva('INDUREOI')),0),0,NULL,SUM(COSE.COSTE_SECCION_PRODUCTIVA) / ANALESTA.P_ANE_MERMLAMI_PRAG.F_Total_InduRepa(A.ANNO,P_Utilidad.F_ValoDeva('INDUREOI'))),
              DECODE(NVL(SUM(COSE.HORAS_SECCION_PRODUCTIVA),0),0,NULL,SUM(COSE.COSTE_SECCION_PRODUCTIVA) / SUM(COSE.HORAS_SECCION_PRODUCTIVA))
             )COSTE_HORA_FX
FROM ANALESTA.ANE_ANNO_MES_PROCESAR A, 
     (SELECT S.ANNO, S.MES, NULL SECCION, S.TIPOMAQU DESCRIPCION_SECCION, SUM(S.COSTREAL) + SUM(S.COINREAL) + SUM(S.COSRREAL) COSTE_SECCION_PRODUCTIVA, SUM(S.HOREEFCO) + SUM(S.UNGRREAL) HORAS_SECCION_PRODUCTIVA
         FROM PRD_SECCANCO S, PRD_ANNOANCO C
            WHERE S.EMPRESA = C.EMPRESA
              AND S.ANNO = C.ANNO
              AND EXISTS (SELECT 'X' FROM GNR_GRSAEMPR SA, GNR_EMPRGRUP G 
                          WHERE SA.GRUPO = G.GRUPO 
                            AND (
                                 (S.TIPOMAQU = 'IMPRESORA' AND SA.SECCAUXI = P_Utilidad.F_ValoDeva('COSAIMPR')) OR
                                 (S.TIPOMAQU = 'CORTADORA' AND SA.SECCAUXI = P_Utilidad.F_ValoDeva('COSACORT')) OR
                                 (S.TIPOMAQU = 'LAMINADORA' AND SA.SECCAUXI = P_Utilidad.F_ValoDeva('COSALAMI')) OR
                                 (S.TIPOMAQU = 'LAQUEADORA' AND SA.SECCAUXI = P_Utilidad.F_ValoDeva('COSALAQU')) OR
                                 (S.TIPOMAQU = 'MONTAJE' AND SA.SECCAUXI = P_Utilidad.F_ValoDeva('COSAMONT'))
                                )
                            AND SA.EMPRESA = S.EMPRESA 
                            AND G.EMPRESA = S.EMPRESA)
          GROUP BY S.ANNO, S.MES, S.TIPOMAQU
      UNION
      SELECT S.ANNO, S.MES, S.SECCION, SE.SECCION DESCRIPCION_SECCION, SUM(S.COSTREAL) + SUM(S.COINREAL) + SUM(S.COSRREAL) COSTE_SECCION_PRODUCTIVA, SUM(S.HOREEFCO) + SUM(S.UNGRREAL) HORAS_SECCION_PRODUCTIVA
         FROM ANE_CODEANMS S, PRD_ANNOANCO C, GNR_SEPREMPR SE
            WHERE S.EMPRESA = C.EMPRESA
              AND S.ANNO = C.ANNO
              AND S.SECCION = SE.CODIGO
              AND S.SECCION NOT IN (P_UTILIDAD.F_VALODEVA('COSEIMPR'),P_UTILIDAD.F_VALODEVA('COSELAMI'),P_UTILIDAD.F_VALODEVA('COSELAQU'),P_UTILIDAD.F_VALODEVA('COSECORT'))
              AND EXISTS (SELECT 'X' FROM GNR_GRSAEMPR SA, GNR_EMPRGRUP G, GNR_SASPEMPR SAS
                          WHERE SA.GRUPO = G.GRUPO 
                            AND SAS.SECCION = S.SECCION
                            AND SAS.SECCAUXI = SA.SECCAUXI
                            AND SA.EMPRESA = S.EMPRESA 
                            AND G.EMPRESA = S.EMPRESA)
          GROUP BY S.ANNO, S.MES, S.SECCION, SE.SECCION) COSE
WHERE A.ANNO = COSE.ANNO(+)
  AND TO_NUMBER(DECODE(A.ULTIMO_MES_CARGADO,NULL,NULL,'01')) <= TO_NUMBER(DECODE(COSE.MES(+),'ENERO','01',
                                                                                             'FEBRERO','02',
                                                                                             'MARZO','03',
                                                                                             'ABRIL','04',
                                                                                             'MAYO','05',
                                                                                             'JUNIO','06',
                                                                                             'JULIO','07',
                                                                                             'AGOSTO','08',
                                                                                             'SEPTIEMBRE','09',
                                                                                             'OCTUBRE','10',
                                                                                             'NOVIEMBRE','11',
                                                                                             'DICIEMBRE','12')) 
                         AND TO_NUMBER(A.ULTIMO_MES_CARGADO) >= TO_NUMBER(DECODE(COSE.MES(+),'ENERO','01',
                                                                                             'FEBRERO','02',
                                                                                             'MARZO','03',
                                                                                             'ABRIL','04',
                                                                                             'MAYO','05',
                                                                                             'JUNIO','06',
                                                                                             'JULIO','07',
                                                                                             'AGOSTO','08',
                                                                                             'SEPTIEMBRE','09',
                                                                                             'OCTUBRE','10',
                                                                                             'NOVIEMBRE','11',
                                                                                             'DICIEMBRE','12'))

GROUP BY A.ANNO,
         A.ULTIMO_MES_CARGADO,
         COSE.SECCION, COSE.DESCRIPCION_SECCION;
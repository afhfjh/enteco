CREATE OR REPLACE FORCE VIEW "ANALESTA"."ANE_ANAL_COSTE_HORA_PREIMPRESI" AS 
  SELECT A.ANNO, A.ULTIMO_MES_CARGADO
       , SUM(IT.HORAS_SECCION_PRODUCTIVA) HORAS_SECCION_PRODUCTIVA
       , SUM(IT.COSTE_DIRECTO) COSTE_DIRECTO
       , SUM(IT.COSTE_INDIRECTO) COSTE_INDIRECTO
       , DECODE(NVL(SUM(IT.HORAS_SECCION_PRODUCTIVA),0),0,NULL,(SUM(IT.COSTE_DIRECTO)+SUM(IT.COSTE_INDIRECTO))/SUM(IT.HORAS_SECCION_PRODUCTIVA)) COSTE_HORA_PREIMPRESION_FX
     FROM ANALESTA.ANE_ANNO_MES_PROCESAR A,
     (SELECT I.ANNO, I.MES, I.COSTE COSTE_DIRECTO, I2.COSTE COSTE_INDIRECTO, COSE.HORAS_SECCION_PRODUCTIVA FROM 
     (SELECT ANNO, MES, SUM(COSTE) COSTE FROM 
     (SELECT C.EMPRESA, C.ANNO, C.MES, SE.DEPARTAM, D.DEPARTAM DESCRIPCION_DEPARTAM, C.SECCION, S.SECCION DESCRIPCION_SECCION, C.CONCEPTO, C.COSTE  
      FROM ANE_CONFCPDR C, GNR_SPDEEMPR SE, GNR_DEPAEMPR D, GNR_SEPREMPR S
      WHERE C.SECCION = SE.SECCION
        AND SE.DEPARTAM = D.CODIGO
        AND C.SECCION = S.CODIGO
        AND SE.DEPARTAM = P_UTILIDAD.F_VALODEVA('CODEPREI')
        AND EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = C.EMPRESA)
      UNION
      SELECT C.EMPRESA, C.ANNO, C.MES, SE.DEPARTAM, D.DEPARTAM DESCRIPCION_DEPARTAM, C.SECCION, S.SECCION DESCRIPCION_SECCION, C.CONCEPTO, C.COSTE  
      FROM ANE_CONFRCDR C, GNR_SPDEEMPR SE, GNR_DEPAEMPR D, GNR_SEPREMPR S
      WHERE C.SECCION = SE.SECCION
        AND SE.DEPARTAM = D.CODIGO
        AND C.SECCION = S.CODIGO
        AND SE.DEPARTAM = P_UTILIDAD.F_VALODEVA('CODEPREI')
        AND EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = C.EMPRESA)) 
      GROUP BY ANNO, MES)I,
     (SELECT ANNO, MES, SUM(COSTE) COSTE FROM
     (SELECT C.ANNO, C.MES, C.COSTINDU_FX * P.NUMEPERS COSTE
      FROM
      (SELECT ANNO, MES, SUM(COSTINDU_FX) COSTINDU_FX
       FROM ANALESTA.ANE_COSTES_INDI_ASOC_INDUCTORE  
       WHERE INDUCTOR != P_UTILIDAD.F_VALODEVA('INDUPEUN')
       GROUP BY  ANNO, MES) C,
      (SELECT ANNO, MES, SUM(NUMEPERS) NUMEPERS
       FROM ANALESTA.ANE_PERSONAL_DEPA_SECC
       WHERE DEPARTAM = P_UTILIDAD.F_VALODEVA('CODEPREI')
       GROUP BY  ANNO, MES)P
      WHERE C.ANNO = P.ANNO
        AND C.MES = P.MES
      UNION ALL
      SELECT C.ANNO, C.MES, C.COSTINDU_FX * P.NUMEPEUN COSTE
      FROM
      (SELECT ANNO, MES, SUM(COSTINDU_FX) COSTINDU_FX
       FROM ANALESTA.ANE_COSTES_INDI_ASOC_INDUCTORE  
       WHERE INDUCTOR = P_UTILIDAD.F_VALODEVA('INDUPEUN')
       GROUP BY  ANNO, MES) C,
      (SELECT ANNO, MES, SUM(NUMEPEUN) NUMEPEUN
       FROM ANALESTA.ANE_PERSONAL_DEPA_SECC
       WHERE DEPARTAM = P_UTILIDAD.F_VALODEVA('CODEPREI')
       GROUP BY  ANNO, MES)P
      WHERE C.ANNO = P.ANNO
        AND C.MES = P.MES)
      GROUP BY ANNO, MES) I2,
     (SELECT S.ANNO, S.MES, SUM(S.HOREEFCO) + SUM(S.UNGRREAL) HORAS_SECCION_PRODUCTIVA
         FROM ANE_CODEANMS S, PRD_ANNOANCO C, GNR_SEPREMPR SE
            WHERE S.EMPRESA = C.EMPRESA
              AND S.ANNO = C.ANNO
              AND S.SECCION = SE.CODIGO
              AND S.SECCION = P_UTILIDAD.F_VALODEVA('SEPRPREI')
              AND S.SECCION NOT IN (P_UTILIDAD.F_VALODEVA('COSEIMPR'),P_UTILIDAD.F_VALODEVA('COSELAMI'),P_UTILIDAD.F_VALODEVA('COSELAQU'),P_UTILIDAD.F_VALODEVA('COSECORT'))
              AND EXISTS (SELECT 'X' FROM GNR_GRSAEMPR SA, GNR_EMPRGRUP G, GNR_SASPEMPR SAS
                          WHERE SA.GRUPO = G.GRUPO 
                            AND SAS.SECCION = S.SECCION
                            AND SAS.SECCAUXI = SA.SECCAUXI
                            AND SA.EMPRESA = S.EMPRESA 
                            AND G.EMPRESA = S.EMPRESA)
          GROUP BY S.ANNO, S.MES) COSE
      WHERE I.ANNO = I2.ANNO
        AND I.MES = I2.MES
        AND I.ANNO = COSE.ANNO
        AND I.MES = COSE.MES) IT
WHERE A.ANNO = IT.ANNO(+) 
  AND TO_NUMBER(DECODE(A.ULTIMO_MES_CARGADO,NULL,NULL,'01')) <= TO_NUMBER(DECODE(IT.MES(+),'ENERO','01',
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
                         AND TO_NUMBER(A.ULTIMO_MES_CARGADO) >= TO_NUMBER(DECODE(IT.MES(+),'ENERO','01',
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
         A.ULTIMO_MES_CARGADO;

/*
SELECT ANNO, COSTE FROM ANALESTA.ANE_COSTES_DEPARTAMENTO
WHERE ANNO = '2015'
  AND DEPARTAM = P_UTILIDAD.F_VALODEVA('CODEPREI');
SELECT ANNO, COSTE_FX FROM ANALESTA.ANE_COSTES_INDI_ASOC_INDU_PREI
WHERE ANNO = '2015';

SELECT ANNO, HORAS_SECCION_PRODUCTIVA FROM ANALESTA.ANE_COS_SECC_PROD_ANNO_MES_CER
WHERE ANNO = '2015'
  AND SECCION = P_UTILIDAD.F_VALODEVA('SEPRPREI');*/
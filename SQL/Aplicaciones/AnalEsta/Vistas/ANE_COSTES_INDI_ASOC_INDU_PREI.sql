CREATE OR REPLACE VIEW "ANALESTA"."ANE_COSTES_INDI_ASOC_INDU_PREI"  AS 
  SELECT A.ANNO, A.ULTIMO_MES_CARGADO,
         SUM(I.COSTE) COSTE_FX
     FROM ANALESTA.ANE_ANNO_MES_PROCESAR A, 
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
        AND C.MES = P.MES) I
WHERE A.ANNO = I.ANNO(+) 
  AND TO_NUMBER(DECODE(A.ULTIMO_MES_CARGADO,NULL,NULL,'01')) <= TO_NUMBER(DECODE(I.MES(+),'ENERO','01',
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
                         AND TO_NUMBER(A.ULTIMO_MES_CARGADO) >= TO_NUMBER(DECODE(I.MES(+),'ENERO','01',
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

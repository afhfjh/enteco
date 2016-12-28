CREATE OR REPLACE VIEW ANALESTA.ANE_INDU_REPA_TOT_ANNO_MES_CER AS
SELECT A.ANNO, A.ULTIMO_MES_CARGADO,
       I.INDUCTOR, I.DESCRIPCION_INDUCTOR, SUM(I.TOTAL) TOTAL
     FROM ANALESTA.ANE_ANNO_MES_PROCESAR A, 
     (SELECT V.ANNO, V.MES, V.INDUREPA INDUCTOR, I.INDUREPA DESCRIPCION_INDUCTOR, V.TOTAL
      FROM ANE_VAINRECO V, GNR_INRECOCO I
      WHERE V.INDUREPA = I.CODIGO
        AND V.TIPO = 'R') I
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
         A.ULTIMO_MES_CARGADO,
         I.INDUCTOR, I.DESCRIPCION_INDUCTOR;
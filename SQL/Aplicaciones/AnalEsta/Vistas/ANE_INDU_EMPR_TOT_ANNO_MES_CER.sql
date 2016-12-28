CREATE OR REPLACE VIEW ANALESTA.ANE_INDU_EMPR_TOT_ANNO_MES_CER AS
SELECT A.ANNO, A.ULTIMO_MES_CARGADO,
       I.EMPRESA, I.INDUCTOR, I.DESCRIPCION_INDUCTOR, SUM(I.VALOR) VALOR
     FROM ANALESTA.ANE_ANNO_MES_PROCESAR A, 
     (SELECT V.EMPRESA, V.ANNO, V.MES, V.INDUCTOR, I.INDUCTOR DESCRIPCION_INDUCTOR, SUM(V.VALOR) VALOR
      FROM ANE_CONFISRR V, GNR_INDUEMPR I
      WHERE V.INDUCTOR = I.CODIGO
        AND EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = V.EMPRESA)
      GROUP BY  V.EMPRESA, V.ANNO, V.MES, V.INDUCTOR, I.INDUCTOR
      UNION
      SELECT 'GR' EMPRESA, V.ANNO, V.MES, V.INDUCTOR, I.INDUCTOR DESCRIPCION_INDUCTOR, SUM(V.VALOR) VALOR
      FROM ANE_CONFISRR V, GNR_INDUEMPR I
      WHERE V.INDUCTOR = I.CODIGO
        AND EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = V.EMPRESA)
      GROUP BY  V.ANNO, V.MES, V.INDUCTOR, I.INDUCTOR) I
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
         I.EMPRESA, I.INDUCTOR, I.DESCRIPCION_INDUCTOR;
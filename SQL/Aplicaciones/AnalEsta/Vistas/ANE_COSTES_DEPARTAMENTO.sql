  CREATE OR REPLACE FORCE VIEW "ANALESTA"."ANE_COSTES_DEPARTAMENTO" AS 
  SELECT A.ANNO, A.ULTIMO_MES_CARGADO,
         I.DEPARTAM, I.DESCRIPCION_DEPARTAM, SUM(I.COSTE) COSTE
     FROM ANALESTA.ANE_ANNO_MES_PROCESAR A, 
     (SELECT C.EMPRESA, C.ANNO, C.MES, SE.DEPARTAM, D.DEPARTAM DESCRIPCION_DEPARTAM, C.SECCION, S.SECCION DESCRIPCION_SECCION, C.CONCEPTO, C.COSTE  
      FROM ANE_CONFCPDR C, GNR_SPDEEMPR SE, GNR_DEPAEMPR D, GNR_SEPREMPR S
      WHERE C.SECCION = SE.SECCION
        AND SE.DEPARTAM = D.CODIGO
        AND C.SECCION = S.CODIGO
        AND EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = C.EMPRESA)
      UNION
      SELECT C.EMPRESA, C.ANNO, C.MES, SE.DEPARTAM, D.DEPARTAM DESCRIPCION_DEPARTAM, C.SECCION, S.SECCION DESCRIPCION_SECCION, C.CONCEPTO, C.COSTE  
      FROM ANE_CONFRCDR C, GNR_SPDEEMPR SE, GNR_DEPAEMPR D, GNR_SEPREMPR S
      WHERE C.SECCION = SE.SECCION
        AND SE.DEPARTAM = D.CODIGO
        AND C.SECCION = S.CODIGO
        AND EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = C.EMPRESA)) I
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
         I.DEPARTAM, I.DESCRIPCION_DEPARTAM;

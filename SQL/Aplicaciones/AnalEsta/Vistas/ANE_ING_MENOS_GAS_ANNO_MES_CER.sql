
  CREATE OR REPLACE VIEW "ANALESTA"."ANE_ING_MENOS_GAS_ANNO_MES_CER" AS 
  SELECT A.ANNO,A.ULTIMO_MES_CARGADO,SUM(DECODE(C.GTO_INGRES,'I',-CE.IMPOCUEN,'G',CE.IMPOCUEN)) IMPOCUEN
         FROM ANALESTA.ANE_ANNO_MES_PROCESAR A, ANE_CODEREAN CE, FV_ASCGCO01 C, GNR_ESCCEMPR E
         WHERE CE.ANNO = A.ANNO
           AND CE.EMPRESA = C.EMCODI
           AND TRIM(CE.CUENCONT) = TRIM(C.CTCCTA)
           AND CE.EMPRESA = E.EMPRESA
           AND TRIM(CE.CUENCONT) = TRIM(E.CUENCONT)
           AND E.TIPOCOST = P_UTILIDAD.F_VALODEVA('TICOFINA')
           AND CE.EMPRESA IN (SELECT VALOR FROM VALORES_LISTA WHERE CODIGO = 'GNR_EMPRACGR')
           AND TO_NUMBER(DECODE(A.ULTIMO_MES_CARGADO,NULL,NULL,'01')) <= TO_NUMBER(DECODE(CE.MES,'ENERO','01',
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
           AND TO_NUMBER(A.ULTIMO_MES_CARGADO) >= TO_NUMBER(DECODE(CE.MES,'ENERO','01',
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
          GROUP BY A.ANNO,A.ULTIMO_MES_CARGADO;
  
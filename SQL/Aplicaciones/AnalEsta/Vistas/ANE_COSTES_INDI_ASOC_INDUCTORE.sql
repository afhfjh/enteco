  CREATE OR REPLACE FORCE VIEW "ANALESTA"."ANE_COSTES_INDI_ASOC_INDUCTORE" AS 
SELECT C.EMPRESA, C.ANNO, C.MES, C.CONCEPTO, C.COSTE, I.INDUCTOR, I.NUMEPERS, DECODE(NVL(I.NUMEPERS,0),0, NULL, C.COSTE/I.NUMEPERS) COSTINDU_FX
FROM PRD_CONFCOIR C, VALORES_LISTA L, PRD_CONFINRE I
 WHERE C.CONCEPTO = P_UTILIDAD.F_VALOCAMPO(L.VALOR,'CONCEPTO')
   AND C.EMPRESA = I.EMPRESA
   AND C.ANNO = I.ANNO
   AND C.MES = I.MES
   AND P_UTILIDAD.F_VALOCAMPO(L.VALOR,'INDUCTOR') = I.INDUCTOR
   AND L.CODIGO = 'PRD_COPRASIN'
   --AND I.INDUCTOR != P_UTILIDAD.F_VALODEVA('INDUPEUN') --PERSONAL UNIFORMADO
   AND NVL(I.NUMEPERS,0) != 0
   AND EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = C.EMPRESA);
CREATE OR REPLACE VIEW "ANALESTA"."ANE_MER_CONSU_MAT_AJUS_MERM_OT" AS 
         SELECT M.EMPRESA,M.MAQUTIPO,M.NUMEOTRE,M.MAQUCODI,M.EVENCODI,M.CAMPNU01,M.ORVAREAL,
                CAMPVA02 TIP_ARTI, CAMPVA03 COD_ARTI, CAMPVA04 LOTE,
                CAMPVA05 EMPRBOBI, CAMPVA06 CONTBOBI, CAMPVA07 COBOBOBI, CAMPVA08 NUOTBOBI,
                CAM2VA02 TIP_ARTI2, CAM2VA03 COD_ARTI2, CAM2VA04 LOTE2,
                CAM2VA05 EMPRBOBI2, CAM2VA06 CONTBOBI2, CAM2VA07 COBOBOBI2, CAM2VA08 NUOTBOBI2,
                SUM(NVL(M.CAMPNU09,0)) MERMA_M1, SUM(NVL(M.CAM2NU09,0)) MERMA_M2 
         FROM PRD_MEFAEVEN M
         GROUP BY M.EMPRESA,M.MAQUTIPO,M.NUMEOTRE,M.MAQUCODI,M.EVENCODI,M.CAMPNU01,M.ORVAREAL,
                  CAMPVA02, CAMPVA03, CAMPVA04,
                  CAMPVA05, CAMPVA06, CAMPVA07, CAMPVA08,
                  CAM2VA02, CAM2VA03, CAM2VA04,
                  CAM2VA05, CAM2VA06, CAM2VA07, CAM2VA08;
--AJUSTEMAQU
--COLORES
--ERROPRRE
--TIRADA
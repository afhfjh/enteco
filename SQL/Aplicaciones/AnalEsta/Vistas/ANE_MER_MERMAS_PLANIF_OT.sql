CREATE OR REPLACE VIEW "ANALESTA"."ANE_MER_MERMAS_PLANIF_OT" AS 
   SELECT MA.EMPRESA, MA.NUMEOTRE, MAX(MP.IZQUIERD + MP.DERECHA) MERMA 
            FROM PRD_MAQUMPLA MP, 
                 (SELECT MR.EMPRESA, MR.NUMEOTRE, MR.FASESEQU, MR.MAQUTIPO, MR.MAQUCODI, MR.ESTADO FROM PRD_MAQURUTA MR
                  WHERE NOT EXISTS (SELECT 'X' FROM PRD_HCABEOTR OTC WHERE OTC.EMPRESA = MR.EMPRESA AND OTC.NUMEOTRE = MR.NUMEOTRE)
                  UNION
                  SELECT MR.EMPRESA, MR.NUMEOTRE, MR.FASESEQU, MR.MAQUTIPO, MR.MAQUCODI, MR.ESTADO FROM PRD_HMAQURUT MR) MA, 
                 FIC_LINEOTRE L
               WHERE MP.EMPRESA = MA.EMPRESA
                 AND MP.MAQUTIPO = MA.MAQUTIPO
                 AND MP.MAQUCODI = MA.MAQUCODI
                 AND L.EMPRESA = MA.EMPRESA
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
                 AND TIPO = 'E'
   GROUP BY MA.EMPRESA, MA.NUMEOTRE;
CREATE OR REPLACE VIEW ANALESTA.ANE_FACTURAS AS
         SELECT L.EMCODI EMPRESA, L.ASLOTE NUMELOTE, O.NUMEPEDI, F.ALNROP NUMEALBA, F.CFNROF NUMEFACT, F.VATCOD TIPO_ARTICULO, F.ARCARF ARTICULO, SUM(F.LFIMPO) IMPORTE, SUM(F.LFIMPO * (NVL(F.LFPIVA,0)/100)) IVA
            FROM FV_ASVEFA02 F, 
                 (SELECT DISTINCT EMCODI, DICODI, ASCANA, CFNROF, CPNROP, ASLOTE FROM FV_ASVELO01 WHERE PROCED = 'F') L, 
                 FIC_CABEOTRE O
            WHERE F.EMCODI = L.EMCODI
              AND F.DICODI = L.DICODI
              AND F.ASCANA = L.ASCANA
              AND F.CFNROF = L.CFNROF
              AND F.CPNROP = L.CPNROP
              AND L.EMCODI = O.EMPRESA
              AND L.ASLOTE = TO_CHAR(O.NUMERO)
              AND L.CPNROP = O.NUMEPEDI
              AND (F.VATCOD = P_Utilidad.F_ValoDeva('TIARFIF4') OR 
                   (F.VATCOD = P_Utilidad.F_ValoDeva('TIARGCF4') AND 
                    EXISTS (SELECT 'X' FROM VALORES_LISTA LH --Articulos tipo C de Horas
                            WHERE LH.CODIGO = 'GNR_ARTIHORA'
                              AND P_UTILIDAD.F_VALOCAMPO(LH.VALOR,'EMPRESA') = F.EMCODI 
                              AND P_UTILIDAD.F_VALOCAMPO(LH.VALOR,'TIP_ARTI') = F.VATCOD 
                              AND P_UTILIDAD.F_VALOCAMPO(LH.VALOR,'COD_ARTI') = F.ARCARF
                           )
                   )
                  )
              AND NVL(L.CFNROF,0) != 0
              AND NOT EXISTS (SELECT 'X' FROM ANE_OBCOTRAZ T WHERE T.EMPRESA = L.EMCODI AND TO_CHAR(T.NUMERO_OT) = L.ASLOTE)
              AND F.PPTIPO NOT IN ('A','X','B','L','O') --A Abono Nacional, X Abono Exportacion, B Abono Mostrador, L Abono atipico Exp, O Abonos atipicos
         GROUP BY L.EMCODI, L.ASLOTE, O.NUMEPEDI, F.ALNROP, F.CFNROF , F.VATCOD, F.ARCARF
         HAVING SUM(F.LFIMPO) > 0;
         
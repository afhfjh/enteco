CREATE OR REPLACE
PROCEDURE ANALESTA.P_ANE_PROCTRIM IS
   CURSOR cOTS IS
      SELECT OT.* 
      FROM FIC_CABEOTRE OT, PRD_ANNOANCO CMOP_OT, ANE_CODEANNO DEPA_OT,
           (SELECT CMOP.EMPRESA, MAX(CMOP.ANNO) ANNO, 
                   MAX(DECODE(CMOP.COMPDICI,'S',DECODE(DEPA.COMPDICI,'S',12),
                       DECODE(CMOP.COMPNOVI,'S',DECODE(DEPA.COMPNOVI,'S',11),
                       DECODE(CMOP.COMPOCTU,'S',DECODE(DEPA.COMPOCTU,'S',10),
                       DECODE(CMOP.COMPSEPT,'S',DECODE(DEPA.COMPSEPT,'S',9),
                       DECODE(CMOP.COMPAGOS,'S',DECODE(DEPA.COMPAGOS,'S',8),
                       DECODE(CMOP.COMPJULI,'S',DECODE(DEPA.COMPJULI,'S',7),
                       DECODE(CMOP.COMPJUNI,'S',DECODE(DEPA.COMPJUNI,'S',6),
                       DECODE(CMOP.COMPMAYO,'S',DECODE(DEPA.COMPMAYO,'S',5),
                       DECODE(CMOP.COMPABRI,'S',DECODE(DEPA.COMPABRI,'S',4),
                       DECODE(CMOP.COMPMARZ,'S',DECODE(DEPA.COMPMARZ,'S',3),
                       DECODE(CMOP.COMPFEBR,'S',DECODE(DEPA.COMPFEBR,'S',2),
                       DECODE(CMOP.COMPENER,'S',DECODE(DEPA.COMPENER,'S',1),0))))))))))))) MES
            FROM PRD_ANNOANCO CMOP, ANE_CODEANNO DEPA
            WHERE CMOP.EMPRESA = DEPA.EMPRESA
              AND CMOP.ANNO = DEPA.ANNO
              AND CMOP.ANNOCOMP = 'S'
              AND DEPA.ANNOCOMP = 'S'
            GROUP BY CMOP.EMPRESA) MEFI
      WHERE OT.EMPRESA = MEFI.EMPRESA
        AND OT.SITUACIO = 'C'
        AND OT.EMPRESA = CMOP_OT.EMPRESA
        AND (
             (MEFI.MES > 1 AND CMOP_OT.ANNO = MEFI.ANNO) OR --Si ya se han cerrado mas de 1 Mes se procesa el año en curso
             (MEFI.MES = 1 AND CMOP_OT.ANNO = MEFI.ANNO - 1)--Si el primer mes del año esta cerrado se procesa el año anterior
            )
        AND TO_CHAR(OT.FEC_MODI,'YYYY') = CMOP_OT.ANNO 
        AND CMOP_OT.ANNOCOMP = 'S'
        AND OT.EMPRESA = DEPA_OT.EMPRESA
        AND (
             (MEFI.MES > 1 AND DEPA_OT.ANNO = MEFI.ANNO) OR --Si ya se han cerrado mas de 1 Mes se procesa el año en curso
             (MEFI.MES = 1 AND DEPA_OT.ANNO = MEFI.ANNO - 1)--Si el primer mes del año esta cerrado se procesa el año anterior
            )
        AND TO_CHAR(OT.FEC_MODI,'YYYY') = DEPA_OT.ANNO
        AND DEPA_OT.ANNOCOMP = 'S'
        AND (
             (TO_CHAR(OT.FEC_MODI,'MM') = '01' AND CMOP_OT.COMPENER = 'S' AND DEPA_OT.COMPENER = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '02' AND CMOP_OT.COMPFEBR = 'S' AND DEPA_OT.COMPFEBR = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '03' AND CMOP_OT.COMPMARZ = 'S' AND DEPA_OT.COMPMARZ = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '04' AND CMOP_OT.COMPABRI = 'S' AND DEPA_OT.COMPABRI = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '05' AND CMOP_OT.COMPMAYO = 'S' AND DEPA_OT.COMPMAYO = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '06' AND CMOP_OT.COMPJUNI = 'S' AND DEPA_OT.COMPJUNI = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '07' AND CMOP_OT.COMPJULI = 'S' AND DEPA_OT.COMPJULI = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '08' AND CMOP_OT.COMPAGOS = 'S' AND DEPA_OT.COMPAGOS = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '09' AND CMOP_OT.COMPSEPT = 'S' AND DEPA_OT.COMPSEPT = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '10' AND CMOP_OT.COMPOCTU = 'S' AND DEPA_OT.COMPOCTU = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '11' AND CMOP_OT.COMPNOVI = 'S' AND DEPA_OT.COMPNOVI = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '12' AND CMOP_OT.COMPDICI = 'S' AND DEPA_OT.COMPDICI = 'S') 
            );
BEGIN
   FOR rOTS IN cOTS LOOP
      BEGIN
         P_ANE_OBJECOST(rOTS.EMPRESA, rOTS.NUMERO, rOTS.ANNO);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END LOOP;
END;
/
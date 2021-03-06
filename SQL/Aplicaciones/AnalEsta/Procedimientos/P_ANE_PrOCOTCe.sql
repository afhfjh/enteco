CREATE OR REPLACE
PROCEDURE ANALESTA.P_ANE_PROCOTCE IS
   CURSOR cOTS IS
      SELECT OT.* FROM FIC_CABEOTRE OT, PRD_ANNOANCO CMOP, ANE_CODEANNO DEPA
      WHERE OT.SITUACIO = 'C'
        AND OT.EMPRESA = CMOP.EMPRESA
        AND TO_CHAR(OT.FEC_MODI,'YYYY') = CMOP.ANNO
        AND CMOP.ANNOCOMP = 'S'
        AND OT.EMPRESA = DEPA.EMPRESA
        AND TO_CHAR(OT.FEC_MODI,'YYYY') = DEPA.ANNO
        AND DEPA.ANNOCOMP = 'S'
        AND (
             (TO_CHAR(OT.FEC_MODI,'MM') = '01' AND CMOP.COMPENER = 'S' AND DEPA.COMPENER = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '02' AND CMOP.COMPFEBR = 'S' AND DEPA.COMPFEBR = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '03' AND CMOP.COMPMARZ = 'S' AND DEPA.COMPMARZ = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '04' AND CMOP.COMPABRI = 'S' AND DEPA.COMPABRI = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '05' AND CMOP.COMPMAYO = 'S' AND DEPA.COMPMAYO = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '06' AND CMOP.COMPJUNI = 'S' AND DEPA.COMPJUNI = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '07' AND CMOP.COMPJULI = 'S' AND DEPA.COMPJULI = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '08' AND CMOP.COMPAGOS = 'S' AND DEPA.COMPAGOS = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '09' AND CMOP.COMPSEPT = 'S' AND DEPA.COMPSEPT = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '10' AND CMOP.COMPOCTU = 'S' AND DEPA.COMPOCTU = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '11' AND CMOP.COMPNOVI = 'S' AND DEPA.COMPNOVI = 'S') OR
             (TO_CHAR(OT.FEC_MODI,'MM') = '12' AND CMOP.COMPDICI = 'S' AND DEPA.COMPDICI = 'S') 
            )
        AND NOT EXISTS (SELECT 'X' FROM ANE_OBJECOST OC WHERE OC.EMPRESA = OT.EMPRESA AND OC.NUMERO_OT = OT.NUMERO);
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
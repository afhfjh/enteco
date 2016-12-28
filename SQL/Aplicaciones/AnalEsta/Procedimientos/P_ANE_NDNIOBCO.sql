CREATE OR REPLACE
PROCEDURE ANALESTA.P_ANE_NDNIOBCO AS
   --Fecha de comprobacion del mes anterior
   dFechComp DATE := TO_DATE('01-'||TO_CHAR(SYSDATE,'MM-YYYY'),'DD-MM-YYYY') - 1;
   --
   CURSOR cANE_CODEANNO IS
      SELECT A.EMPRESA,ED.DESCRIPCION,A.ANNOCOMP,A.COMPENER,A.COMPFEBR,A.COMPMARZ,A.COMPABRI,A.COMPMAYO,A.COMPJUNI,A.COMPJULI,A.COMPAGOS,A.COMPSEPT,A.COMPOCTU,A.COMPNOVI,A.COMPDICI
      FROM ANE_CODEANNO A, VALORES_LISTA E, EMPRESA ED
      WHERE E.CODIGO = 'GNR_EMPRACGR'
        AND A.EMPRESA = E.VALOR
        AND A.EMPRESA = ED.EMPRESA
        AND A.ANNO = TO_CHAR(dFechComp,'YYYY');
   --
   bFaltFINA BOOLEAN := FALSE;
   --
   CURSOR cPRD_ANNOANCO IS
      SELECT A.EMPRESA,ED.DESCRIPCION,A.ANNOCOMP,A.COMPENER,A.COMPFEBR,A.COMPMARZ,A.COMPABRI,A.COMPMAYO,A.COMPJUNI,A.COMPJULI,A.COMPAGOS,A.COMPSEPT,A.COMPOCTU,A.COMPNOVI,A.COMPDICI
      FROM PRD_ANNOANCO A, VALORES_LISTA E, EMPRESA ED
      WHERE E.CODIGO = 'GNR_EMPRACGR'
        AND A.EMPRESA = E.VALOR
        AND A.EMPRESA = ED.EMPRESA
        AND A.ANNO = TO_CHAR(dFechComp,'YYYY');
   --
   bFaltRRHH BOOLEAN := FALSE;
   --La tarea es la que controla si se ejecuta la comprobación
   CURSOR cTAREREAL IS
      SELECT 'X' FROM TAREREAL
         WHERE CODITARE = 'ANE_NDNIOBCO'
           AND TO_CHAR(FECHEJEC,'YYYYMM') < TO_CHAR(SYSDATE,'YYYYMM');--Se verifica si ya se ejecuto en el mes actual
   --
   vTAREREAL VARCHAR2(1);
   --
   vMailSopo VARIABLES.VALOR%TYPE := p_Utilidad.F_ValoDeva('CUENCOSO');
   vEsquSopo VARIABLES.VALOR%TYPE := p_Utilidad.F_ValoDeva('ESQUSOPO');
   --
   vAsunto MAILAPLI.ASUNTO%TYPE;
   vTexto MAILAPLI.TEXTO%TYPE;
   --
   CURSOR cMail(vUsuario USUARIOS.USUARIO%TYPE) IS
      SELECT USUARIO
           , DESCRIPCION
           , MAIL
     FROM USUARIOS
    WHERE USUARIO = vUsuario;
   --
   rMail cMail%ROWTYPE;
   --
   CURSOR cMails IS
      SELECT VALOR FROM VALORES_LISTA
         WHERE CODIGO = 'ANE_LNDNOBCO';
BEGIN
   --Verifica si la tarea se ha ejecutado en el mes actual
   OPEN cTAREREAL;
   FETCH cTAREREAL INTO vTAREREAL;
   CLOSE cTAREREAL;
   --
   IF vTAREREAL IS NOT NULL THEN--Si no se ha ejecutado
      --Se verifica que la fecha maxima de introducción de datos este superada. Nos apoyamos en el calendario de Pharma. El parametro NUDMIDOC indica los dias de verificación
      IF TRUNC(P_GNR_DIASFEST.F_Fecha_Fin(P_UTILIDAD.F_VALODEVA('EMPRPHAR'),TO_DATE('01-'||TO_CHAR(SYSDATE,'MM-YYYY'),'DD-MM-YYYY'),P_UTILIDAD.F_VALODEVA('NUDMIDOC'))) < TRUNC(SYSDATE) THEN
         --Revision de la introducción de datos de Financiero
         FOR rANE_CODEANNO IN cANE_CODEANNO LOOP
            IF rANE_CODEANNO.ANNOCOMP = 'N' OR
               (NVL(rANE_CODEANNO.COMPENER,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '01') OR (NVL(rANE_CODEANNO.COMPFEBR,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '02') OR (NVL(rANE_CODEANNO.COMPMARZ,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '03') OR 
               (NVL(rANE_CODEANNO.COMPABRI,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '04') OR (NVL(rANE_CODEANNO.COMPMAYO,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '05') OR (NVL(rANE_CODEANNO.COMPJUNI,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '06') OR 
               (NVL(rANE_CODEANNO.COMPJULI,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '07') OR (NVL(rANE_CODEANNO.COMPAGOS,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '08') OR (NVL(rANE_CODEANNO.COMPSEPT,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '09') OR 
               (NVL(rANE_CODEANNO.COMPOCTU,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '10') OR (NVL(rANE_CODEANNO.COMPNOVI,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '11') OR (NVL(rANE_CODEANNO.COMPDICI,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '12') THEN
               --
               IF NOT (bFaltFINA) THEN
                  bFaltFINA := TRUE;
                  --622 Datos no introducidos en Objetivo de Costes en @1 para las Empresas @2
                  vTexto := p_Alertas_Generales.F_AlerPara (622,'Financiero|'||CHR(10)||rANE_CODEANNO.EMPRESA||'-'||rANE_CODEANNO.DESCRIPCION,2);
               ELSE
                  vTexto := vTexto||CHR(10)||rANE_CODEANNO.EMPRESA||'-'||rANE_CODEANNO.DESCRIPCION;
               END IF;
            END IF;
         END LOOP;
         --Revision de la introducción de datos de RRHH
         FOR rPRD_ANNOANCO IN cPRD_ANNOANCO LOOP
            IF rPRD_ANNOANCO.ANNOCOMP = 'N' OR
               (NVL(rPRD_ANNOANCO.COMPENER,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '01') OR (NVL(rPRD_ANNOANCO.COMPFEBR,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '02') OR (NVL(rPRD_ANNOANCO.COMPMARZ,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '03') OR 
               (NVL(rPRD_ANNOANCO.COMPABRI,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '04') OR (NVL(rPRD_ANNOANCO.COMPMAYO,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '05') OR (NVL(rPRD_ANNOANCO.COMPJUNI,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '06') OR 
               (NVL(rPRD_ANNOANCO.COMPJULI,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '07') OR (NVL(rPRD_ANNOANCO.COMPAGOS,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '08') OR (NVL(rPRD_ANNOANCO.COMPSEPT,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '09') OR 
               (NVL(rPRD_ANNOANCO.COMPOCTU,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '10') OR (NVL(rPRD_ANNOANCO.COMPNOVI,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '11') OR (NVL(rPRD_ANNOANCO.COMPDICI,'N') = 'N' AND TO_CHAR(dFechComp,'MM') = '12') THEN
               --
               IF NOT (bFaltRRHH) THEN
                  bFaltRRHH := TRUE;
                  --
                  IF NOT (bFaltFINA) THEN
                     --622 Datos no introducidos en Objetivo de Costes en @1 para las Empresas @2
                     vTexto := p_Alertas_Generales.F_AlerPara (622,'RRHH|'||CHR(10)||rPRD_ANNOANCO.EMPRESA||'-'||rPRD_ANNOANCO.DESCRIPCION,2);
                  ELSE
                     --622 Datos no introducidos en Objetivo de Costes en @1 para las Empresas @2
                     vTexto := vTexto||CHR(10)||CHR(10)||p_Alertas_Generales.F_AlerPara (622,'RRHH|'||CHR(10)||rPRD_ANNOANCO.EMPRESA||'-'||rPRD_ANNOANCO.DESCRIPCION,2);
                  END IF;
               ELSE
                  vTexto := vTexto||CHR(10)||rPRD_ANNOANCO.EMPRESA||'-'||rPRD_ANNOANCO.DESCRIPCION;
               END IF;
            END IF;
         END LOOP;
         --
         IF bFaltFINA OR bFaltRRHH THEN
            --621 Datos no introducidos en Objetivo de Costes para el mes @1
            vAsunto := SUBSTR(p_Alertas_Generales.F_AlerPara (621,TO_CHAR(dFechComp,'MM-YYYY'),2),1,80);
            --
            FOR rMails IN cMails LOOP
               --Envio del Mail
               rMail.MAIL := NULL;
               --
               OPEN cMail(rMails.VALOR);
               FETCH cMail INTO rMail;
               CLOSE cMail;
               --
               IF rMail.MAIL IS NOT NULL THEN
                  INSERT INTO MAILAPLI (USUARIO, MAILORIG, USUADEST, MAILUSDE, ASUNTO, TEXTO, PROCESO, ENVIADO)
                  VALUES (vEsquSopo,vMailSopo,rMail.Usuario,rMail.Descripcion||' <'||rMail.Mail||'>',vAsunto,vTexto,'P_ANE_NDNIOBCO','N');
                  --
                  COMMIT;
               END IF;
            END LOOP;
            --Se actualiza la proxima ejecución del mail
            UPDATE TAREREAL
               SET FECHEJEC = SYSDATE, FECHPREJ = LAST_DAY(SYSDATE) + 1
            WHERE CODITARE = 'ANE_NDNIOBCO';
            COMMIT;
         END IF;
      END IF;
   END IF;
END;
/

/*
DECLARE
   vEmpresa ARTICULO.EMPRESA%TYPE := '05';--@EMPRESA:V;
   vTip_Arti ARTICULO.TIP_ARTI%TYPE := 'M';--@TIPO_ARTICULO:V;
   vCod_Arti ARTICULO.COD_ARTI%TYPE := '07LN03006301';--@ARTICULO:V;
   dFechCier DATE := TO_DATE('05-10-2009','DD-MM-YYYY');--@FECHA_CIERRE_OT:D;
BEGIN
ANALESTA.P_PRECMPFC(vEmpresa, vTip_Arti, vCod_Arti, dFechCier);
END;
*/
CREATE OR REPLACE 
PROCEDURE ANALESTA.P_PRECMPFC(vEmpresa ARTICULO.EMPRESA%TYPE, vTip_Arti ARTICULO.TIP_ARTI%TYPE, vCod_Arti ARTICULO.COD_ARTI%TYPE, dFechCier DATE) IS
   nPrecMere NUMBER;
   nCantPrme NUMBER;
   nPrecPrme NUMBER;
   CURSOR cASMAAR01(vVatCod FV_ENTMAAR01.VATCOD%TYPE, vArcarf FV_ENTMAAR01.ARCARF%TYPE) IS
      SELECT *
        FROM FV_ASMAAR01
       WHERE EMCODI = vEmpresa
         AND VATCOD = vVatCod
         AND ARCARF = vArcarf;
   --
   rASMAAR01   cASMAAR01%ROWTYPE;
   --Precio Real 
   CURSOR cExisPeri(vTip_Arti ARTICULO.TIP_ARTI%TYPE,vCod_Arti ARTICULO.COD_ARTI%TYPE) IS
      SELECT ASLOTE, SUM(DECODE(AHTIMO,'E',AHCANT,-AHCANT)) AHCANT FROM FV_ASALHI01 
         WHERE EMCODI = vEmpresa
           AND VATCOD = vTip_Arti
           AND ARCARF = vCod_Arti
           AND TRIM(ASLOTE) IS NOT NULL
           AND TRUNC(AHFMOV) <= TRUNC(LAST_DAY(dFechCier))
      GROUP BY ASLOTE
      HAVING SUM(DECODE(AHTIMO,'E',AHCANT,-AHCANT)) > 0;
   --
   CURSOR cCompras(vTip_Arti ARTICULO.TIP_ARTI%TYPE,vCod_Arti ARTICULO.COD_ARTI%TYPE,vLote FV_ASCOAL02.ASLOTE%TYPE) IS
      SELECT DECODE(C.ALCANT, 0, 0,((C.ALPREU * D.CAMBIO) * C.ALCAEQ) / C.ALCANT) ALPREU FROM FV_ASCOAL02 C, GNR_DICOTIZA D
            WHERE C.DIVISA = D.DIVISA
              AND D.DIVISAMA = P_Utilidad.F_ValoDeva ('DIVIEURO')
              AND TRUNC(C.ACFENT) BETWEEN TRUNC(DESDFECH) AND TRUNC(HASTFECH)
              AND C.EMCODI = vEmpresa
              AND C.VATCOD = vTip_Arti
              AND C.ARCARF = vCod_Arti
              AND C.ASLOTE = vLote;
   --
   nPrecComp FV_ASCOAL02.ALPREU%TYPE;
   --
   CURSOR cUltiCompr(vTip_Arti ARTICULO.TIP_ARTI%TYPE,vCod_Arti ARTICULO.COD_ARTI%TYPE) IS
      SELECT C.ALCAEQ, (C.ALPREU * D.CAMBIO) ALPREU, C.ALCANT, C.ALUNST, C.ALUNCO 
         FROM FV_ASCOAL02 C, GNR_DICOTIZA D
            WHERE C.DIVISA = D.DIVISA
              AND D.DIVISAMA = P_Utilidad.F_ValoDeva ('DIVIEURO')
              AND TRUNC(C.ACFENT) BETWEEN TRUNC(DESDFECH) AND TRUNC(HASTFECH)
              AND C.EMCODI = vEmpresa
              AND C.VATCOD = vTip_Arti
              AND C.ARCARF = vCod_Arti
         ORDER BY C.ACFENT DESC;
   --
   rUltiCompr cUltiCompr%ROWTYPE;
   --
   CURSOR cUltiEntr(vTip_Arti ARTICULO.TIP_ARTI%TYPE,vCod_Arti ARTICULO.COD_ARTI%TYPE) IS
      SELECT AHPREU 
      FROM FV_ASALHI01
         WHERE EMCODI = vEmpresa
           AND VATCOD = vTip_Arti
           AND ARCARF = vCod_Arti
           AND AHTIMO = 'E'
      ORDER BY AHFMOV DESC;
   --
   rUltiEntr cUltiEntr%ROWTYPE;
   --
   vMailSopo           VARIABLES.VALOR%TYPE  := p_Utilidad.F_ValoDeva('CUENCOSO');
   vEsquSopo           VARIABLES.VALOR%TYPE  := p_Utilidad.F_ValoDeva('ESQUSOPO');
   --
   CURSOR cMail IS
      SELECT USUARIO
           , DESCRIPCION
           , MAIL
     FROM USUARIOS
    WHERE USUARIO = 'CONTROLLER';
   --
   rMail cMail%ROWTYPE;
   vMensaje MAILAPLI.TEXTO%TYPE;
BEGIN   
   --Calculo de Unidad de Logistica para los materiales
   OPEN cASMAAR01(vTip_Arti, vCod_Arti);
   FETCH cASMAAR01 INTO rASMAAR01;
   CLOSE cASMAAR01;
   --Precios Reales de Materias Primas
   nPrecMere := NULL;
   nCantPrme := 0;
   nPrecPrme := 0;
   --
   FOR rExisPeri IN cExisPeri(vTip_Arti, vCod_Arti) LOOP
      nPrecComp := NULL;
      --Se busca la compra para el preci
      OPEN cCompras(vTip_Arti, vCod_Arti, rExisPeri.ASLOTE);
      FETCH cCompras INTO nPrecComp;
      CLOSE cCompras;
      --
      IF NVL(nPrecComp,0) != 0 THEN
         nCantPrme := nCantPrme + rExisPeri.AHCANT; --Acumula la cantidad
         nPrecPrme := nPrecPrme + (rExisPeri.AHCANT * nPrecComp); --Acumula el Precio
      END IF;
   END LOOP;
   --
   IF nCantPrme != 0 THEN
      nPrecMere := nPrecPrme / nCantPrme;
   ELSE
      nPrecMere := 0;
   END IF;   
   --
   IF nPrecMere = 0 THEN
      rUltiCompr.ALCANT := NULL;
      --
      OPEN cUltiCompr(vTip_Arti, vCod_Arti);
      FETCH cUltiCompr INTO rUltiCompr;--PRECIO MEDIO REAL
      CLOSE cUltiCompr;
      --(ALCAEQ * ALPREU) / ALCANT, ALUNST, ALUNCO
      IF NVL(rUltiCompr.ALCANT,0) != 0 THEN
         IF rUltiCompr.ALUNST = rASMAAR01.VUCCOD THEN
            nPrecMere := (rUltiCompr.ALCAEQ * rUltiCompr.ALPREU) / rUltiCompr.ALCANT;
         ELSE
            nPrecMere := 0;
            --dbms_output.put_line('17.1- No se puede establecer el precio para la MP: '||vTip_Arti||'-'||vCod_Arti);
            --vMensaje := '17.1- No se puede establecer el precio para la MP: '||vTip_Arti||'-'||vCod_Arti;
         END IF;
      ELSE
         nPrecMere := 0;
         --dbms_output.put_line('17.2- No se puede establecer el precio para la MP: '||vTip_Arti||'-'||vCod_Arti);
         --vMensaje := '17.2- No se puede establecer el precio para la MP: '||vTip_Arti||'-'||vCod_Arti;
      END IF;
   END IF;
   --Se busca por la ultima entrada en movimientos 
   IF nPrecMere = 0 THEN
      rUltiEntr.AHPREU := NULL;
      --
      OPEN cUltiEntr(vTip_Arti, vCod_Arti);
      FETCH cUltiEntr INTO rUltiEntr;
      CLOSE cUltiEntr;
      --
      IF NVL(rUltiEntr.AHPREU,0) != 0 THEN
         nPrecMere := rUltiEntr.AHPREU;
      ELSE
         nPrecMere := 0;
         --dbms_output.put_line('17.1- No se puede establecer el precio para la MP: '||vTip_Arti||'-'||vCod_Arti);
         vMensaje := '17.1- No se puede establecer el precio para la MP: '||vTip_Arti||'-'||vCod_Arti;
      END IF;
   END IF;
   --
   --dbms_output.put_line('Precio: '||nPrecMere);
   vMensaje := 'Precio: '||nPrecMere;
   --Envio del Mail
   rMail.MAIL := NULL;
   --
   OPEN cMail;
   FETCH cMail INTO rMail;
   CLOSE cMail;
   --
   IF rMail.MAIL IS NOT NULL THEN
      BEGIN
         INSERT INTO MAILAPLI
               (USUARIO
              , MAILORIG
              , USUADEST
              , MAILUSDE
              , ASUNTO
              , TEXTO
              , PROCESO
              , ENVIADO
              , UBICDOCU
              , DOCUADJU)
         VALUES(vEsquSopo
              , vMailSopo
              , rMail.Usuario
              , rMail.Descripcion||' <'||rMail.Mail||'>'
              , 'Precio del Articulo '||vEmpresa||'-'||vTip_Arti||'-'||vCod_Arti||' con fecha de cierre '||TO_CHAR(dFechCier, 'DD-MM-YYYY')
              , vMensaje
              , 'P_ANE_OBJECOST.P_ANE_PROCOTCE'
              , 'N'
              , NULL
              , NULL);
         --
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      --
      COMMIT;
   END IF;
END;
/
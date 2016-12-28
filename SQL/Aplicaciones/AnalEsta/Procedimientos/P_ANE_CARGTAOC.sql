CREATE OR REPLACE PROCEDURE "ANALESTA"."P_ANE_CARGTAOC" IS
   CURSOR cFIC_CABEOTRE IS
      SELECT EMPRESA, NUMERO FROM FIC_CABEOTRE WHERE NUMERO >= 2015000014;
   --
	PROCEDURE P_CARGA_TINTAS(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, nNumero FIC_CABEOTRE.NUMERO%TYPE) IS
		CURSOR cTintas(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, nNumero FIC_CABEOTRE.NUMERO%TYPE) IS
			SELECT * FROM ANE_TINTAS
				WHERE EMPRESA = vEmpresa
				  AND OT = nNumero;
		--
		CURSOR cNUME_COMPFORM(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vMateCode PRD_HIREOTRF.MATECODE%TYPE) IS
				SELECT COUNT(*)
				FROM PRI_COMPFORM CF, PRI_EQCOTINT C
				WHERE CF.EMPRESA = C.EMPRESA
				  AND CF.IM_COMPO = C.IM_IDENT
				  AND CF.EMPRESA = vEmpresa
				  AND TO_CHAR(CF.IM_FORMU) = vMateCode;
		--
		CURSOR cCOMPFORM(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vMateCode PRD_HIREOTRF.MATECODE%TYPE) IS
				SELECT CF.EMPRESA, CF.IM_FORMU, CF.IM_COMPO, C.IM_DESCR, CF.IM_CANTI, TIP_ARTI TIP_ARTI_COM, COD_ARTI COD_ARTI_COM
				FROM PRI_COMPFORM CF, PRI_EQCOTINT C
				WHERE CF.EMPRESA = C.EMPRESA
				  AND CF.IM_COMPO = C.IM_IDENT
				  AND CF.EMPRESA = vEmpresa
				  AND TO_CHAR(CF.IM_FORMU) = vMateCode;
		--
		nNumeComp NUMBER;
		----------------------------------------------------------------------------------------------------------------------------
		nConsTeKG_OT NUMBER;
		--
		CURSOR cPesoEspe(vTinta VARCHAR2, vTipoImpre VARCHAR2) IS
			SELECT VALOR 
				FROM ANALESTA.ANE_PESO_ESPECIFICO_TINTA 
					WHERE TINTA = vTinta AND TIPO_IMPRESION = vTipoImpre;
		--
		nRestFlex NUMBER;
		nRestHuec NUMBER;
		nBlanFlex NUMBER;
		nBlanHuec NUMBER;
		nPesoEspe NUMBER;
		--
		vTIARPROI VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('TIARPROI');
		--
		CURSOR cANCHO_PI(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, nNumePedi FIC_CABEOTRE.NUMEPEDI%TYPE) IS
			SELECT PI.ANCHO FROM FIC_HPIGESTI PI 
				WHERE PI.EMPRESA = vEmpresa AND PI.NUMEPEDI = nNumePedi;
		--
		nAncho ARTICULO.ANCHO%TYPE;
		--
		nPropComp NUMBER;
		--
		vTraza VARCHAR2(2000);
		--
		vP_TIARMPF4 VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('TIARMPF4');
		vDIVIEURO VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('DIVIEURO');
		--
		CURSOR cArticulo(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vVatCod ARTICULO.TIP_ARTI%TYPE, vArcarf ARTICULO.COD_ARTI%TYPE) IS
			SELECT UNIDSTOC, PCMPCOMP, ANCHO
			  FROM ARTICULO
			 WHERE EMPRESA = vEmpresa
				AND TIP_ARTI = vVatCod
				AND COD_ARTI = vArcarf;
		--
		rArticulo cArticulo%ROWTYPE;
		--
		CURSOR cVariables(vVariable VARIABLES.VARIABLE%TYPE) IS
			SELECT VALOR FROM VARIABLES
			WHERE VARIABLE = vVariable;
		--
		CURSOR cSumaCantComp(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vMateCode VARCHAR2, vIm_Formu VARCHAR2) IS--PRI_COMPFORM.IM_FORMU%TYPE, vIm_Formu PRI_COMPFORM.IM_FORMU%TYPE) IS
			SELECT SUM(CF.IM_CANTI) IM_CANTI
				FROM PRI_COMPFORM CF, PRI_EQCOTINT C
					WHERE CF.EMPRESA = C.EMPRESA
					  AND CF.IM_COMPO = C.IM_IDENT
					  AND CF.EMPRESA = vEmpresa
					  AND TO_CHAR(CF.IM_FORMU) = vMATECODE
					  AND TO_CHAR(CF.IM_FORMU) = vIM_FORMU;
		--
		nSumaCantComp NUMBER;
		--Precio Real 
		CURSOR cExisPeri(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vTip_Arti ARTICULO.TIP_ARTI%TYPE,vCod_Arti ARTICULO.COD_ARTI%TYPE,
							  dFecha_Cierre DATE) IS
			SELECT ASLOTE, SUM(DECODE(AHTIMO,'E',AHCANT,-AHCANT)) AHCANT FROM FV_ASALHI01 
				WHERE EMCODI = vEmpresa
				  AND VATCOD = vTip_Arti
				  AND ARCARF = vCod_Arti
				  AND TRIM(ASLOTE) IS NOT NULL
				  AND TRUNC(AHFMOV) <= TRUNC(LAST_DAY(dFecha_Cierre))
			GROUP BY ASLOTE
			HAVING SUM(DECODE(AHTIMO,'E',AHCANT,-AHCANT)) > 0;
		--
		CURSOR cCompras(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vTip_Arti ARTICULO.TIP_ARTI%TYPE,vCod_Arti ARTICULO.COD_ARTI%TYPE,vLote FV_ASCOAL02.ASLOTE%TYPE) IS
			SELECT DECODE(C.ALUPRE,0,DECODE(C.ALCANT, 0, 0,((C.ALPREU * D.CAMBIO) * C.ALCAEQ) / C.ALCANT),
											 DECODE(C.ALCANT, 0, 0,(((C.ALPREU * D.CAMBIO) * C.ALCAEQ) / C.ALCANT) / C.ALUPRE) 
							 ) ALPREU  
			FROM FV_ASCOAL02 C, GNR_DICOTIZA D, FV_ASCOAL01 CA
				WHERE CA.EMCODI = C.EMCODI
				  AND CA.DICODI = C.DICODI
				  AND CA.ACANYA = C.ACANYA
				  AND CA.ACNROA = C.ACNROA
				  AND CA.TIPDOC IS NULL
				  AND C.DIVISA = D.DIVISA
				  AND D.DIVISAMA = vDIVIEURO
				  AND TRUNC(C.ACFENT) BETWEEN TRUNC(DESDFECH) AND TRUNC(HASTFECH)
				  AND (C.VATCOD != vP_TIARMPF4 OR (C.VATCOD = vP_TIARMPF4 AND C.VNACOD IN ('1','43','16','46')))
				  AND C.EMCODI = vEmpresa
				  AND C.VATCOD = vTip_Arti
				  AND C.ARCARF = vCod_Arti
				  AND C.ASLOTE = vLote;
		--
		nPrecComp FV_ASCOAL02.ALPREU%TYPE;
		--
		CURSOR cUltiCompr(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vTip_Arti ARTICULO.TIP_ARTI%TYPE,vCod_Arti ARTICULO.COD_ARTI%TYPE) IS
			SELECT C.ALUPRE, C.ALCAEQ, (C.ALPREU * D.CAMBIO) ALPREU, C.ALCANT, C.ALUNST, C.ALUNCO 
			FROM FV_ASCOAL02 C, GNR_DICOTIZA D, FV_ASCOAL01 CA
				WHERE CA.EMCODI = C.EMCODI
				  AND CA.DICODI = C.DICODI
				  AND CA.ACANYA = C.ACANYA
				  AND CA.ACNROA = C.ACNROA
				  AND CA.TIPDOC IS NULL
				  AND C.DIVISA = D.DIVISA
				  AND D.DIVISAMA = vDIVIEURO
				  AND TRUNC(C.ACFENT) BETWEEN TRUNC(DESDFECH) AND TRUNC(HASTFECH)
				  AND (C.VATCOD != vP_TIARMPF4 OR (C.VATCOD = vP_TIARMPF4 AND C.VNACOD IN ('1','43','16','46')))
				  AND C.EMCODI = vEmpresa
				  AND C.VATCOD = vTip_Arti
				  AND C.ARCARF = vCod_Arti
			ORDER BY C.ACFENT DESC;
		--
		rUltiCompr cUltiCompr%ROWTYPE;
		--
		CURSOR cUltiEntr(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vTip_Arti ARTICULO.TIP_ARTI%TYPE,vCod_Arti ARTICULO.COD_ARTI%TYPE) IS
			SELECT AHPREU 
			FROM FV_ASALHI01
				WHERE EMCODI = vEmpresa
				  AND VATCOD = vTip_Arti
				  AND ARCARF = vCod_Arti
				  AND AHTIMO = 'E'
				  AND AHPREU != 0
			ORDER BY AHFMOV DESC;
		--
		rUltiEntr cUltiEntr%ROWTYPE;
		--
		nCantPrme NUMBER := 0;
		nPrecPrme NUMBER := 0;
		nPrecMere NUMBER := 0;
		--
		nCP_PRECMERE NUMBER;
		--
		nCP_COTEKGCO_CF NUMBER := 0;--CONSUMO TEORICO REAL
		nCP_COTODIRE_CS NUMBER := 0;
		nCP_COERCONS NUMBER := 0;--COSTE EN € DEL CONSUMO REAL
	BEGIN
		DELETE ANALESTA.ANE_TINTAS_C WHERE EMPRESA = vEmpresa AND OT = nNumero;
		DELETE ANALESTA.ANE_TINTAS_COMPONENTE_C WHERE EMPRESA = vEmpresa AND OT = nNumero;
		--
		nRestFlex := 0;
		nRestHuec := 0;
		nBlanFlex := 0;
		nBlanHuec := 0;
		nPesoEspe := 0;
		--
		OPEN cPesoEspe('RESTO', 'FLEXO');
		FETCH cPesoEspe INTO nRestFlex;
		CLOSE cPesoEspe;
		--
		OPEN cPesoEspe('RESTO', 'HUECO');
		FETCH cPesoEspe INTO nRestHuec;
		CLOSE cPesoEspe;
		--
		OPEN cPesoEspe('BLANCO', 'FLEXO');
		FETCH cPesoEspe INTO nBlanFlex;
		CLOSE cPesoEspe;
		--
		OPEN cPesoEspe('BLANCO', 'HUECO');
		FETCH cPesoEspe INTO nBlanHuec;
		CLOSE cPesoEspe;
		--
		FOR rTintas IN cTintas(vEmpresa, nNumero) LOOP
			INSERT INTO ANALESTA.ANE_TINTAS_C(EMPRESA,N_CLIENTE,CLIENTE,OT,FECHA_DE_LA_OT,FECHA_CIERRE_DE_LA_OT,N_PEDIDO,TIPO_PRD,ESPECIALIDAD,LINEA,LFS,N_TINTEROS,ML_PASADOS_MAQUINA,ANCHO_CLIENTE,N_DE_CORTES,
														 ANCHO_DE_PRODUCCION,M2_PASADOS_MAQUINA,CONTADOR,RECUCODI,MATECODE,COLOR,PANTONE,TIPO_IMPRE,ANILOX,SUPEARIM,SUP_M2_MAQ_TINTA,POSICION,FLEXO_HUECO,ANILOX_APOCM3M2,
														 ANILOX_PORCAPOR,APOCM3M2_TIN,VOLUMCM3_TIN,PEESTINT_TIN,CONSTEKG_TIN,PRECIO_UNITARIO_KG_TINTA,COSTE_EUR_TINTA)
			VALUES (rTintas.EMPRESA, rTintas.N_CLIENTE, rTintas.CLIENTE, rTintas.OT, rTintas.FECHA_DE_LA_OT, rTintas.FECHA_CIERRE_DE_LA_OT, rTintas.N_PEDIDO, rTintas.TIPO_PRD, rTintas.ESPECIALIDAD, rTintas.LINEA, rTintas.LFS, rTintas.N_TINTEROS, rTintas.ML_PASADOS_MAQUINA, rTintas.ANCHO_CLIENTE, rTintas.N_DE_CORTES, 
					  rTintas.ANCHO_DE_PRODUCCION, rTintas.M2_PASADOS_MAQUINA, rTintas.CONTADOR, rTintas.RECUCODI, rTintas.MATECODE, rTintas.COLOR, rTintas.PANTONE, rTintas.TIPO_IMPRE, rTintas.ANILOX, rTintas.SUPEARIM, rTintas.SUP_M2_MAQ_TINTA, rTintas.POSICION, rTintas.FLEXO_HUECO, rTintas.ANILOX_APOCM3M2,
					  rTintas.ANILOX_PORCAPOR, rTintas.APOCM3M2_TIN, rTintas.VOLUMCM3_TIN, rTintas.PEESTINT_TIN, rTintas.CONSTEKG_TIN, rTintas.PRECIO_UNITARIO_KG_TINTA, rTintas.COSTE_EUR_TINTA);
			--
			nNumeComp := 0;
			--
			OPEN cNUME_COMPFORM(vEmpresa, rTintas.MATECODE);
			FETCH cNUME_COMPFORM INTO nNumeComp;
			CLOSE cNUME_COMPFORM;
			--
			IF INSTR(rTintas.COLOR,'BLANCO') = 0 THEN
				IF rTintas.FLEXO_HUECO = 'FLEXO' THEN
					nPesoEspe := nRestFlex;
				ELSIF rTintas.FLEXO_HUECO = 'HUECO' THEN
					nPesoEspe := nRestHuec;
				END IF;
			ELSE
				IF rTintas.FLEXO_HUECO = 'FLEXO' THEN
					nPesoEspe := nBlanFlex;
				ELSIF rTintas.FLEXO_HUECO = 'HUECO' THEN
					nPesoEspe := nBlanHuec;
				END IF;
			END IF;
			--
			nAncho := NULL;
			--
			IF rTintas.TIPO_PRD = vTIARPROI THEN
				OPEN cANCHO_PI(vEmpresa, rTintas.N_PEDIDO);
				FETCH cANCHO_PI INTO nAncho;
				CLOSE cANCHO_PI;
			ELSE
				--Calculo de Unidad de Logistica para los materiales
				rArticulo.ANCHO := NULL;
				--
				OPEN cArticulo(vEmpresa, rTintas.TIPO_PRD, rTintas.ESPECIALIDAD);
				FETCH cArticulo INTO rArticulo;
				CLOSE cArticulo;
				--
				nAncho := rArticulo.ANCHO;
			END IF;
			--
			nConsTeKG_OT := (nPesoEspe * ((rTintas.ML_PASADOS_MAQUINA * (nAncho/1000) * NVL(rTintas.SUPEARIM,0)) / 100) * ((rTintas.ANILOX_APOCM3M2 * NVL(rTintas.ANILOX_PORCAPOR,0)) / 100)) / 1000 ;
	--dbms_output.put_line('nConsTeKG_OT:'||nConsTeKG_OT);
			--
			FOR rCOMPFORM IN cCOMPFORM(vEmpresa, rTintas.MATECODE) LOOP
				--
				nCP_COTEKGCO_CF := 0;--CONSUMO TEORICO REAL
				nCP_COERCONS := 0;--COSTE EN € DEL CONSUMO REAL
				--
				------------------------------------------------------------------------------------------
				nSumaCantComp := NULL;
				--function CF_PORCCOMPFormula return Number is
				OPEN cSumaCantComp(vEmpresa, rTintas.MateCode, rCOMPFORM.Im_Formu);
				FETCH cSumaCantComp INTO nSumaCantComp;
				CLOSE cSumaCantComp;                 
				--
				nSumaCantComp := NVL(nSumaCantComp,0);
				--Para evitar error circular ESTE TRATAMIENTO YA SE ENCUENTRA EN CF_SUPEAIM2Formula, Esto es lo que se ha modificado
				IF NVL(nSumaCantComp,0) != 0 THEN
					nCP_COTEKGCO_CF := nConsTeKG_OT * (rCOMPFORM.IM_CANTI / nSumaCantComp); --CONSUMO TEORICO REAL
					--
					nPropComp := rCOMPFORM.IM_CANTI / nSumaCantComp;
				ELSE
					nCP_COTEKGCO_CF := 0;
					--
					nPropComp := 0;
				END IF;
				--Calculo del Precio Medio
				nCP_PRECMERE := NULL;
				--
				nCantPrme := 0; 
				nPrecPrme := 0; 
				--
				vTraza := 'Se verifican las existencias hasta la fecha de comprobación ('||TO_CHAR(rTintas.FECHA_CIERRE_DE_LA_OT,'DD-MM-YYYY')||'), lote a lote para crear un precio medio';
				--
				FOR rExisPeri IN cExisPeri(vEmpresa, rCOMPFORM.TIP_ARTI_COM, rCOMPFORM.COD_ARTI_COM, rTintas.FECHA_CIERRE_DE_LA_OT) LOOP
					IF NVL(LENGTH(vTraza),0) < 1900 THEN
						vTraza := vTraza ||CHR(10)||'  Lote Encontrado: '||rExisPeri.ASLOTE;
					END IF;
					--
					nPrecComp := NULL;
					--Se busca la compra para el preci
					OPEN cCompras(vEmpresa, rCOMPFORM.TIP_ARTI_COM, rCOMPFORM.COD_ARTI_COM, rExisPeri.ASLOTE);
					FETCH cCompras INTO nPrecComp;
					CLOSE cCompras;
					--
					IF NVL(LENGTH(vTraza),0) < 1900 THEN
						vTraza := vTraza ||CHR(10)||'  Precio: '||TO_CHAR(nPrecComp);
					END IF;
					--
					IF NVL(nPrecComp,0) != 0 THEN
						nCantPrme := nCantPrme + rExisPeri.AHCANT; --Acumula la cantidad
						nPrecPrme := nPrecPrme + (rExisPeri.AHCANT * nPrecComp); --Acumula el Precio
						--
						IF NVL(LENGTH(vTraza),0) < 1900 THEN
							vTraza := vTraza ||CHR(10)||'  Precio Encontrado. Entonces se acumula Cantidad ('||TO_CHAR(nCantPrme)||') y Precio de Lote ('||TO_CHAR(nPrecPrme)||')';
						END IF;
					END IF;
				END LOOP;
				--
				IF nCantPrme != 0 THEN
					nCP_PRECMERE := nPrecPrme / nCantPrme;
					--
					IF NVL(LENGTH(vTraza),0) < 1900 THEN
						vTraza := vTraza ||CHR(10)||'  Finalización de busqueda de lotes, se calcula Precio Medio '||TO_CHAR(nPrecPrme)||' / '||TO_CHAR(nCantPrme)||'='||nCP_PRECMERE;
					END IF;
				ELSE
					nCP_PRECMERE := 0;
				END IF;   
				--
				IF nCP_PRECMERE = 0 THEN
					IF NVL(LENGTH(vTraza),0) < 1900 THEN
						vTraza := vTraza ||CHR(10)||'No se encuentra precio con anterior tratamiento. Se busca por ultima compra';
					END IF;
					--
					rUltiCompr.ALCANT := NULL;
					--
					OPEN cUltiCompr(vEmpresa, rCOMPFORM.TIP_ARTI_COM, rCOMPFORM.COD_ARTI_COM);
					FETCH cUltiCompr INTO rUltiCompr;--:CP_PRECMERE; --PRECIO MEDIO REAL
					CLOSE cUltiCompr;
					--(ALCAEQ * ALPREU) / ALCANT, ALUNST, ALUNCO
					IF NVL(rUltiCompr.ALCANT,0) != 0 THEN
						--Calculo de Unidad de Logistica para los materiales
						rArticulo.UNIDSTOC := NULL;
						--
						OPEN cArticulo(vEmpresa, rCOMPFORM.TIP_ARTI_COM, rCOMPFORM.COD_ARTI_COM);
						FETCH cArticulo INTO rArticulo;
						CLOSE cArticulo;
						--
						IF rUltiCompr.ALUNST = rArticulo.UNIDSTOC THEN
							IF rUltiCompr.ALUPRE = 0 THEN
								nCP_PRECMERE := (rUltiCompr.ALCAEQ * rUltiCompr.ALPREU) / rUltiCompr.ALCANT;
								--
								IF NVL(LENGTH(vTraza),0) < 1900 THEN
									vTraza := vTraza ||CHR(10)||'   Calculo de precio por ultima compra ('||TO_CHAR(rUltiCompr.ALCAEQ)||' * '||TO_CHAR(rUltiCompr.ALPREU)||') / '||TO_CHAR(rUltiCompr.ALCANT)||' = '||TO_CHAR(nCP_PRECMERE);
								END IF;
							ELSE
								nCP_PRECMERE := ((rUltiCompr.ALCAEQ * rUltiCompr.ALPREU) / rUltiCompr.ALCANT) /rUltiCompr.ALUPRE;
								--
								IF NVL(LENGTH(vTraza),0) < 1900 THEN
									vTraza := vTraza ||CHR(10)||'   Calculo de precio por ultima compra (('||TO_CHAR(rUltiCompr.ALCAEQ)||' * '||TO_CHAR(rUltiCompr.ALPREU)||') / '||TO_CHAR(rUltiCompr.ALCANT)||') / '||TO_CHAR(rUltiCompr.ALUPRE)||' = '||TO_CHAR(nCP_PRECMERE);
								END IF;
							END IF;
						ELSE
							nCP_PRECMERE := 0;
							--
							--IF  R_COMPFORM.TIP_ARTI_COM != 'X' AND R_COMPFORM.COD_ARTI_COM != 'XXX' THEN
								--P_ERRORES('44.1- No se ha podido establecer el precio para la materia prima de tintas :'||R_COMPFORM.TIP_ARTI_COM||'-'||R_COMPFORM.COD_ARTI_COM);
							--END IF;
						END IF;
					ELSE
						nCP_PRECMERE := 0;
						--
						--IF  R_COMPFORM.TIP_ARTI_COM != 'X' AND R_COMPFORM.COD_ARTI_COM != 'XXX' THEN
							--P_ERRORES('44.2- No se ha podido establecer el precio para la materia prima de tintas :'||R_COMPFORM.TIP_ARTI_COM||'-'||R_COMPFORM.COD_ARTI_COM);
						--END IF;
					END IF;
				END IF;
				--Se busca por la ultima entrada en movimientos 
				IF nCP_PRECMERE = 0 THEN
					IF NVL(LENGTH(vTraza),0) < 1900 THEN
						vTraza := vTraza ||CHR(10)||'No se encuentra precio con anterior tratamiento. Se busca por ultima entrada ';
					END IF;
					--
					rUltiEntr.AHPREU := NULL;
					--
					OPEN cUltiEntr(vEmpresa, rCOMPFORM.TIP_ARTI_COM, rCOMPFORM.COD_ARTI_COM);
					FETCH cUltiEntr INTO rUltiEntr;
					CLOSE cUltiEntr;
					--
					IF NVL(rUltiEntr.AHPREU,0) != 0 THEN
						nCP_PRECMERE := rUltiEntr.AHPREU;
						--
						IF NVL(LENGTH(vTraza),0) < 1900 THEN
							vTraza := vTraza ||CHR(10)||'   Precio encontrado en Ultima Entrada '||TO_CHAR(nCP_PRECMERE);
						END IF;
					ELSE
						nCP_PRECMERE := 0;
						--
						--IF  R_COMPFORM.TIP_ARTI_COM != 'X' AND R_COMPFORM.COD_ARTI_COM != 'XXX' THEN
							 --P_ERRORES('44.1- No se ha podido establecer el precio para la materia prima de tintas :'||R_COMPFORM.TIP_ARTI_COM||'-'||R_COMPFORM.COD_ARTI_COM);
							 --No se puede establecer el precio para la MP: @1-@2. [Contador @3]	
							 --Posiblemente no existen movimientos de entrada para este material valoradas a un precio	
							 --Realizar un movimiento Manual de Entrada valorado con precio y realizar un movimiento de Salida por la misma cantidad
							 --P_ERRORES('602',R_COMPFORM.TIP_ARTI_COM||'|'||R_COMPFORM.COD_ARTI_COM||'|5','R','E');
						--END IF;
					END IF;
				END IF;
				--
				IF NVL(LENGTH(vTraza),0) < 1900 THEN
					vTraza := vTraza ||CHR(10)||'--';
					vTraza := vTraza ||CHR(10)||'PRECIO ENCONTRADO: '||TO_CHAR(nCP_PRECMERE);
				END IF;
				--
				--nCP_COERCONS := NVL(nCP_COTEKGCO_CF,0) * NVL(nCP_PRECMERE,0); --COSTE EN € DEL CONSUMO REAL
				--nCP_COTODIRE_CS := NVL(nCP_COTODIRE_CS,0) + NVL(nCP_COERCONS,0);--:CP_COTODIRE,0);	
				------------------------------------------------------------------------------------------				
				INSERT INTO ANALESTA.ANE_TINTAS_COMPONENTE_C(EMPRESA,N_CLIENTE,CLIENTE,OT,FECHA_DE_LA_OT,FECHA_CIERRE_DE_LA_OT,N_PEDIDO,TIPO_PRD,ESPECIALIDAD,LINEA,LFS,N_TINTEROS,ML_PASADOS_MAQUINA,ANCHO_CLIENTE,N_DE_CORTES,
																			ANCHO_DE_PRODUCCION,M2_PASADOS_MAQUINA,CONTADOR,RECUCODI,MATECODE,COLOR,PANTONE,TIPO_IMPRE,ANILOX,SUPEARIM,SUP_M2_MAQ_TINTA,POSICION,FLEXO_HUECO,ANILOX_APOCM3M2,
																			ANILOX_PORCAPOR,APOCM3M2_TIN,VOLUMCM3_TIN,PEESTINT_TIN,CONSTEKG_TIN,PRECIO_UNITARIO_KG_TINTA,COSTE_EUR_TINTA,
																			N_COMPONENTES,COMPONENTE,PRECIO_KG_COMPONENTE, PROPORCION_COMPONENTE, TRAZA_DEL_PRECIO, CONS_TEORICO_COMPO, EUROS_COMPONENTE)
				VALUES (rTintas.EMPRESA, rTintas.N_CLIENTE, rTintas.CLIENTE, rTintas.OT, rTintas.FECHA_DE_LA_OT, rTintas.FECHA_CIERRE_DE_LA_OT, rTintas.N_PEDIDO, rTintas.TIPO_PRD, rTintas.ESPECIALIDAD, rTintas.LINEA, rTintas.LFS, rTintas.N_TINTEROS, rTintas.ML_PASADOS_MAQUINA, rTintas.ANCHO_CLIENTE, rTintas.N_DE_CORTES, 
						  rTintas.ANCHO_DE_PRODUCCION, rTintas.M2_PASADOS_MAQUINA, rTintas.CONTADOR, rTintas.RECUCODI, rTintas.MATECODE, rTintas.COLOR, rTintas.PANTONE, rTintas.TIPO_IMPRE, rTintas.ANILOX, rTintas.SUPEARIM, rTintas.SUP_M2_MAQ_TINTA, rTintas.POSICION, rTintas.FLEXO_HUECO, rTintas.ANILOX_APOCM3M2,
						  rTintas.ANILOX_PORCAPOR, rTintas.APOCM3M2_TIN, rTintas.VOLUMCM3_TIN, rTintas.PEESTINT_TIN, rTintas.CONSTEKG_TIN, rTintas.PRECIO_UNITARIO_KG_TINTA, rTintas.COSTE_EUR_TINTA,
						  nNumeComp, rCOMPFORM.IM_DESCR, nCP_PRECMERE, nPropComp, vTraza, nCP_COTEKGCO_CF, NVL(nCP_COTEKGCO_CF,0) * NVL(nCP_PRECMERE,0));
				
			END LOOP;
		END LOOP;
	END;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_ATIPICAS_C REUSE STORAGE';
   INSERT INTO ANE_ATIPICAS_C 
   SELECT * FROM ANE_ATIPICAS
   WHERE TRUNC(FECHA_FACTURA) >= TO_DATE('2016-01-01','YYYY-MM-DD');
   COMMIT;
   --
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_COMISIONES_C REUSE STORAGE';
   INSERT INTO ANE_COMISIONES_C
   SELECT * FROM ANE_COMISIONES
   WHERE NUMEPEDI >= 2016000001;
   COMMIT;
   --
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_DISTRIB_C REUSE STORAGE';
   INSERT INTO ANE_DISTRIB_C
   SELECT * FROM ANE_DISTRIB
   WHERE N_OT >= 2015000014;
   COMMIT;
   --
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_FACT_C REUSE STORAGE';
   INSERT INTO ANE_FACT_C
   SELECT * FROM  ANE_FACT
   WHERE NUMELOTE >= 2015000014;
   COMMIT;
   --
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_LAMINA_C REUSE STORAGE';
   INSERT INTO ANE_LAMINA_C
   SELECT * FROM ANE_LAMINA
   WHERE OT>= 2015000014;
   COMMIT;
   --
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_MERMA_PLANIFICACION_C REUSE STORAGE';
   INSERT INTO ANE_MERMA_PLANIFICACION_C
   SELECT * FROM ANE_MERMA_PLANIFICACION
   WHERE OT >= 2015000014;
   COMMIT;
   --
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_MC_OT_C REUSE STORAGE';
   INSERT INTO ANE_MC_OT_C
   SELECT * FROM ANE_MC_OT
   WHERE NUMERO >= 2015000014;
   COMMIT;
   --
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_EMBALAJE_C REUSE STORAGE';
   INSERT INTO ANE_EMBALAJE_C
   SELECT * FROM ANE_EMBALAJE
   WHERE OT>= 2015000014;
   COMMIT;
   --
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_ABONOS_C REUSE STORAGE';
   INSERT INTO ANE_ABONOS_C
   SELECT * FROM ANE_ABONOS
   WHERE NUMELOTE>= 2015000014;
   COMMIT;
   --
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_MOP_C REUSE STORAGE';
   INSERT INTO ANE_MOP_C
   SELECT * FROM ANE_MOP
   WHERE OT>= 2015000014;
   COMMIT;
   --
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_ENERGIA_C REUSE STORAGE';
   INSERT INTO ANE_ENERGIA_C
   SELECT * FROM ANE_ENERGIA
   WHERE OT>= 2015000014;
   COMMIT;
   --
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ANALESTA.ANE_M_PRO_C REUSE STORAGE';
	--
   FOR rFIC_CABEOTRE IN cFIC_CABEOTRE LOOP
      INSERT INTO ANALESTA.ANE_M_PRO_C SELECT * FROM ANALESTA.ANE_M_PRO WHERE EMPRESA = rFIC_CABEOTRE.EMPRESA AND OT = rFIC_CABEOTRE.NUMERO;
      --
      COMMIT;
   END LOOP;
	--
   FOR rFIC_CABEOTRE IN cFIC_CABEOTRE LOOP
      P_CARGA_TINTAS(rFIC_CABEOTRE.EMPRESA,rFIC_CABEOTRE.NUMERO);
      --
      COMMIT;
   END LOOP;
END;

/

--------------------------------------------------------
--  DDL for View ANE_FACT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ANALESTA"."ANE_FACT" ("EMPRESA", "CLIENTE", "NOMBRE_CLIENTE", "PAIS", "NOMBRE_PAIS", "VENDEDOR", "NOMBRE_VENDEDOR", "NUMEPEDI", "NUMELOTE", "NUMEALBA", "NUMEFACT", "FEC_ALTA_PEDIDO", "FEC_CIERRE", "FECHA_ALBARAN", "FECHA_FACTURA", "FECHA_VENCIMIENTO", "PLAZO_COBRO_DIAS", "TIPO_ARTICULO", "ARTICULO", "LINEA", "LFS", "AGRUPACION_ESTATEGICA", "MERCADO", "UNIDAD_VENTA", "CANTIDAD_ML", "CANTIDAD_M2", "CANTIDAD_KG", "CANTIDAD_UN", "PRECIO", "IMPORTE", "IVA") AS 
  SELECT L.EMCODI EMPRESA, FI.CLIENTE_ID CLIENTE, C.RAZON_SOC NOMBRE_CLIENTE,
         C.PAIS, C.NOMBRE NOMBRE_PAIS,
         V.VENDEDOR, V.NOMBRE_VENDEDOR, 
         O.NUMEPEDI, L.ASLOTE NUMELOTE, F.ALNROP NUMEALBA, L.CFNDEF NUMEFACT, 
         P.FEC_ALTA FEC_ALTA_PEDIDO,
         DECODE(O.SITUACIO,'C',O.FEC_MODI) FEC_CIERRE, AL.ALFALT FECHA_ALBARAN, 
			FA.CFFALT FECHA_FACTURA, FV.VENCIMI1 + FA.CFFALT FECHA_VENCIMIENTO, FV.VENCIMI1 PLAZO_COBRO_DIAS, 
         F.VATCOD TIPO_ARTICULO, F.ARCARF ARTICULO, SUBSTR(FI.MATBASE,1,2) LINEA, FI.MATBASE LFS, 
         P_GNR_AGRUESTR.F_ASIGNA_AGRUESTR(L.EMCODI, SUBSTR(F.ARCARF ,4,4), F.VATCOD, F.ARCARF) AGRUPACION_ESTATEGICA, C.MERCADO,
         F.VUCVEN UNIDAD_VENTA, 
         DECODE(F.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNML'),1,DECODE(NVL(FI.ANCHO,0),0,0,DECODE(F.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNKG'),FI.FCKG * (1000 / FI.ANCHO),
                                                                                                        P_Utilidad.F_ValoDeva('TIPOUNM2'),(1000 / FI.ANCHO),
                                                                                                        P_Utilidad.F_ValoDeva('TIPOUNUN'),(1000 / FI.ANCHO) * ((FI.ANCHO * FI.LARGO) / 1000000)))) * F.LFCANT CANTIDAD_ML,
         DECODE(F.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNM2'),1,P_Utilidad.F_ValoDeva('TIPOUNKG'),FI.FCKG,
                                                             P_Utilidad.F_ValoDeva('TIPOUNML'),(FI.ANCHO / 1000),
                                                             P_Utilidad.F_ValoDeva('TIPOUNUN'),(FI.ANCHO * FI.LARGO) / 1000000) * F.LFCANT CANTIDAD_M2,
         DECODE(F.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNKG'),1,DECODE(NVL(FI.FCKG,0),0,0,DECODE(F.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNML'),(1 / FI.FCKG) * (FI.ANCHO / 1000),
                                                                                                        P_Utilidad.F_ValoDeva('TIPOUNM2'),1 / FI.FCKG,
                                                                                                        P_Utilidad.F_ValoDeva('TIPOUNUN'),(1 / FI.FCKG) * ((FI.ANCHO * FI.LARGO) / 1000000)))) * F.LFCANT CANTIDAD_KG,
			DECODE(F.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNUN'),1,P_Utilidad.F_ValoDeva('TIPOUNML'),DECODE(NVL(FI.ANCHO,0)*NVL(FI.LARGO,0),0,0,(1 / ((1000 / FI.ANCHO) * ((FI.ANCHO * FI.LARGO) / 1000000)))),
                                                                              P_Utilidad.F_ValoDeva('TIPOUNM2'),DECODE(NVL(FI.ANCHO,0)*NVL(FI.LARGO,0),0,0,(1000000 / (FI.ANCHO * FI.LARGO))),
                                                                              P_Utilidad.F_ValoDeva('TIPOUNKG'),DECODE(NVL(FI.ANCHO,0)*NVL(FI.LARGO,0)*NVL(FI.FCKG,0),0,0,(1 / ((1 / FI.FCKG) * ((FI.ANCHO * FI.LARGO) / 1000000))))) * F.LFCANT CANTIDAD_UN,
			F.LFPREU PRECIO, SUM(F.LFIMPO) IMPORTE, SUM(F.LFIMPO * (NVL(F.LFPIVA,0)/100)) IVA
            FROM FV_ASVEFA02 F, FV_ASVEFA01 FA,
                 (SELECT DISTINCT EMCODI, DICODI, ASCANA, CFNROF, CFNDEF, CPNROP, ASLOTE, ALNROP FROM FV_ASVELO01 WHERE PROCED = 'F') L, 
                 FIC_CABEOTRE O, FIC_HCABEPED P,
                 (SELECT HA.EMCODI, HA.ALNROP, HA.ALFALT FROM FV_ASVEALH01 HA
                  UNION
                  SELECT AL.EMCODI, AL.ALNROP, AL.ALFALT FROM FV_ASVEAL01 AL WHERE NOT EXISTS (SELECT 'X' FROM FV_ASVEALH01 HA WHERE HA.EMCODI = AL.EMCODI AND HA.DICODI = AL.DICODI AND HA.ASCANA = AL.ASCANA AND HA.PPTIPO = AL.PPTIPO AND HA.ALNROP = AL.ALNROP)) AL,
                 (SELECT F.EMPRESA, F.TIP_ARTI, F.PRODUCTO, F.MODI, F.REVI, F.ANCHO, F.LARGO, F.MATBASE, L.FCKG, L.DESCRIPCION, F.CLIENTE_ID FROM HFICTEC F, LFS L
                  WHERE F.EMPRESA = L.EMPRESA
                    AND F.MATBASE = L.COD_LFS
                  UNION
                  SELECT F.EMPRESA, F.TIP_ARTI, F.PRODUCTO, F.MODI, F.REVI, F.ANCHO, F.LARGO, F.MATBASE, L.FCKG, L.DESCRIPCION, F.CLIENTE_ID FROM FIC_SEGESTI F, LFS L
                  WHERE F.EMPRESA = L.EMPRESA
                    AND F.MATBASE = L.COD_LFS
                 ) FI,
                 (SELECT C.EMPRESA, C.CLIENTE_ID, C.RAZON_SOC, C.PAIS, P.NOMBRE, M.CLDESC MERCADO FROM CLIENTES C, GNR_PAISES P, FV_ASMATA20 M WHERE C.PAIS = P.PAIS AND C.TIPOPCLI = M.CLCLAS) C,
                 (SELECT CV.EMPRESA,CV. CLIENTE_ID, CV.VENDEDOR, V.NOMBRE NOMBRE_VENDEDOR FROM GNR_CLVENDED CV, GNR_VENDEDOR V WHERE CV.TIPO = V.TIPO AND CV.VENDEDOR = V.VENDEDOR AND CV.ACTIVA = 'S') V,
					  (SELECT FC.EMPRESA, FC.CLIENTE_ID, FC.VENCIMI1 FROM GNR_CLFCOBRO FC, CLIENTES C
						WHERE FC.EMPRESA = C.EMPRESA
						  AND FC.CLIENTE_ID = C.CLIENTE_ID 
						  AND FC.LINEA = C.ACFCOBRO) FV
            WHERE F.EMCODI = FA.EMCODI
              AND F.DICODI = FA.DICODI
              AND F.ASCANA = FA.ASCANA
              AND F.PPTIPO = FA.PPTIPO
              AND F.CFNROF = FA.CFNROF
              AND F.EMCODI = L.EMCODI
              AND F.DICODI = L.DICODI
              AND F.ASCANA = L.ASCANA
              AND F.CFNROF = L.CFNROF
              AND F.CPNROP = L.CPNROP
              AND F.ALNROP = L.ALNROP
              AND L.EMCODI = O.EMPRESA
              AND L.ASLOTE = TO_CHAR(O.NUMERO)
              AND L.CPNROP = O.NUMEPEDI
              AND FI.EMPRESA = C.EMPRESA
              AND FI.CLIENTE_ID = C.CLIENTE_ID
              AND FI.EMPRESA = V.EMPRESA(+)
              AND FI.CLIENTE_ID = V.CLIENTE_ID(+)
				  AND FI.EMPRESA = FV.EMPRESA(+)
              AND FI.CLIENTE_ID = FV.CLIENTE_ID(+)
              AND O.EMPRESA = P.EMPRESA
              AND O.NUMEPEDI = P.NUMEPEDI
              AND P.TIPOACCI = 'I'
              AND L.EMCODI = AL.EMCODI(+)
              AND L.ALNROP = AL.ALNROP(+)
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
              --AND NOT EXISTS (SELECT 'X' FROM ANE_OBCOTRAZ T WHERE T.EMPRESA = L.EMCODI AND TO_CHAR(T.NUMERO_OT) = L.ASLOTE)
              AND F.PPTIPO NOT IN ('A','X','B','L','O') --A Abono Nacional, X Abono Exportacion, B Abono Mostrador, L Abono atipico Exp, O Abonos atipicos
              AND O.EMPRESA = FI.EMPRESA(+)
              AND O.TIP_ARTI = FI.TIP_ARTI(+)
              AND O.COD_ARTI = FI.PRODUCTO(+)
              AND NVL(O.MODI,0) = NVL(FI.MODI(+),0)
              AND NVL(O.REVI,0) = NVL(FI.REVI(+),0)
         GROUP BY L.EMCODI, FI.CLIENTE_ID, C.RAZON_SOC,
                  C.PAIS, C.NOMBRE,
                  V.VENDEDOR, V.NOMBRE_VENDEDOR, L.ASLOTE, O.NUMEPEDI, F.ALNROP, L.CFNDEF, 
                  P.FEC_ALTA,
                  DECODE(O.SITUACIO,'C',O.FEC_MODI), AL.ALFALT, FA.CFFALT, FV.VENCIMI1, C.MERCADO, 
                  F.VATCOD, F.ARCARF, FI.MATBASE, F.VUCVEN, F.LFCANT, F.LFPREU, FI.ANCHO, FI.FCKG, FI.LARGO
         HAVING SUM(F.LFIMPO) > 0;

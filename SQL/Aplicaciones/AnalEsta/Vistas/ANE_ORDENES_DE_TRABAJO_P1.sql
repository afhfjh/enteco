  CREATE OR REPLACE VIEW "ANALESTA"."ANE_ORDENES_DE_TRABAJO_P1" AS 
  SELECT O.EMPRESA, O.NUMERO NUMERO_OT, O.ANNO ANNO_OT, O.SITUACIO, O.FEC_MODI FECHA_MODIFICACION_OT, TO_CHAR(O.FEC_MODI,'YYYY') ANNO_MODIFICACION_OT, TO_CHAR(O.FEC_MODI,'MM') MES_MODIFICACION_OT,
                CL.CLIENTE_ID, CL.RAZON_SOC, CL.VENDEDOR, CL.TIPO_VENDEDOR, CL.DESCRIPCION_VENEDEDOR, CL.VENCIMIENTO_FX,
                O.TIP_ARTI TIP_ARTI_OT, O.COD_ARTI COD_ARTI_OT, A.DESCRIPCION DESCRIPCION_ARTICULO_OT, O.MODI MODIFICACION, O.REVI REVISION, DECODE(O.TIP_ARTI,P_Utilidad.F_ValoDeva('TIARFIF4'), DECODE(SUBSTR(O.COD_ARTI,3,1), P_Utilidad.F_ValoDeva('TIPOPROY'), 'ANONIMO', 'IMPRESO')) TIPO_ARTICULO,
                P_GNR_AGRUESTR.F_ASIGNA_AGRUESTR(O.EMPRESA, SUBSTR(O.COD_ARTI,4,4),O.TIP_ARTI, O.COD_ARTI) AGRUPACION_ESTRATEGICA,
                O.NUMEPEDI PEDIDO_OT, O.LINEPEDI LINEA_PEDIDO_OT, NVL(LP.TIPOPEDI,'NE') TIPO_DE_PEDIDO, P.REFEENPM REFERENCIA_PEDIDO_MATRIZ_OT, 
                P.DIREENVI CODIGO_DIRECCION_ENVIO, P.PAIS CODIGO_PAIS_DIREC_ENVIO_PEDIDO, P.NOMBRE PAIS_DIREC_ENVIO_PEDIDO, CL.PAIS CODIGO_PAIS_CLIENTE, CL.DESCRIPCION_PAIS PAIS_CLIENTE, 
                DECODE(P.PAIS, NULL,CL.PAIS,P.PAIS) CODIGO_PAIS_ENTREGA, DECODE(P.NOMBRE, NULL,CL.DESCRIPCION_PAIS,P.NOMBRE) PAIS_ENTREGA, DECODE(DECODE(P.PAIS, NULL,CL.PAIS,P.PAIS),NULL,'N',P_Utilidad.F_ValoDeva('PAISESPA'),'N','E') TIPO_PEDIDO,
                O.CANTCERR CANTIDAD_CERRADA_OT, O.UNIDAD UNIDAD_CERRADA_OT, 
                DECODE(O.UNIDAD,P_Utilidad.F_ValoDeva('TIPOUNML'),1,DECODE(NVL(FI.ANCHO,0),0,0,DECODE(O.UNIDAD,P_Utilidad.F_ValoDeva('TIPOUNKG'),FI.FCKG * (1000 / FI.ANCHO),
                                                                                                               P_Utilidad.F_ValoDeva('TIPOUNM2'),(1000 / FI.ANCHO),
                                                                                                               P_Utilidad.F_ValoDeva('TIPOUNUN'),(1000 / FI.ANCHO) * ((FI.ANCHO * FI.LARGO) / 1000000)))) FACTOR_ML_CIERRE_OT_FX, 
                O.CANTCERR * 
                DECODE(O.UNIDAD,P_Utilidad.F_ValoDeva('TIPOUNML'),1,DECODE(NVL(FI.ANCHO,0),0,0,DECODE(O.UNIDAD,P_Utilidad.F_ValoDeva('TIPOUNKG'),FI.FCKG * (1000 / FI.ANCHO),
                                                                                                               P_Utilidad.F_ValoDeva('TIPOUNM2'),(1000 / FI.ANCHO),
                                                                                                               P_Utilidad.F_ValoDeva('TIPOUNUN'),(1000 / FI.ANCHO) * ((FI.ANCHO * FI.LARGO) / 1000000))))
                CANTIDAD_CERRADA_OT_ML,
                DECODE(O.UNIDAD,P_Utilidad.F_ValoDeva('TIPOUNM2'),1,P_Utilidad.F_ValoDeva('TIPOUNKG'),FI.FCKG,
                                                                     P_Utilidad.F_ValoDeva('TIPOUNML'),(FI.ANCHO / 1000),
                                                                     P_Utilidad.F_ValoDeva('TIPOUNUN'),(FI.ANCHO * FI.LARGO) / 1000000) FACTOR_M2_CIERRE_OT_FX,
                O.CANTCERR *
                DECODE(O.UNIDAD,P_Utilidad.F_ValoDeva('TIPOUNM2'),1,P_Utilidad.F_ValoDeva('TIPOUNKG'),FI.FCKG,
                                                                     P_Utilidad.F_ValoDeva('TIPOUNML'),(FI.ANCHO / 1000),
                                                                     P_Utilidad.F_ValoDeva('TIPOUNUN'),(FI.ANCHO * FI.LARGO) / 1000000)
                CANTIDAD_CERRADA_OT_M2,
                O.NUMEOTTE NUMERO_OTT, O.ANNOOTTE ANNO_OTT,
                NVL(MPC.VALOR,'N') MATERIAL_PROPIEDAD_CLIENTE,
                FI.ANCHO, FI.LARGO, FI.MATBASE, FI.DESCRIPCION DESCRIPCION_MATBASE, SUBSTR(FI.MATBASE,1,2) LINEA, LIN.DESCRIPCION DESCRIPCION_LINEA,
                EX.VUCVEN UNIDAD_CIERRE_ALBARAN, EX.LPCANT CANTIDAD_CIERRE_ALBARAN,
                DECODE(EX.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNML'),1,DECODE(NVL(FI.ANCHO,0),0,0,DECODE(EX.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNKG'),FI.FCKG * (1000 / FI.ANCHO),
                                                                                                                 P_Utilidad.F_ValoDeva('TIPOUNM2'),(1000 / FI.ANCHO),
                                                                                                                 P_Utilidad.F_ValoDeva('TIPOUNUN'),(1000 / FI.ANCHO) * ((FI.ANCHO * FI.LARGO) / 1000000)))) FACTOR_ML_CANT_CIERRE_ALBA_FX, 
                EX.LPCANT * 
                DECODE(EX.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNML'),1,DECODE(NVL(FI.ANCHO,0),0,0,DECODE(EX.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNKG'),FI.FCKG * (1000 / FI.ANCHO),
                                                                                                                 P_Utilidad.F_ValoDeva('TIPOUNM2'),(1000 / FI.ANCHO),
                                                                                                                 P_Utilidad.F_ValoDeva('TIPOUNUN'),(1000 / FI.ANCHO) * ((FI.ANCHO * FI.LARGO) / 1000000))))
                CANTIDAD_CIERRE_ALBARAN_ML,
                DECODE(EX.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNM2'),1,P_Utilidad.F_ValoDeva('TIPOUNKG'),FI.FCKG,
                                                                     P_Utilidad.F_ValoDeva('TIPOUNML'),(FI.ANCHO / 1000),
                                                                     P_Utilidad.F_ValoDeva('TIPOUNUN'),(FI.ANCHO * FI.LARGO) / 1000000) FACTOR_M2_CANT_CIERRE_ALBA_FX,
                EX.LPCANT *
                DECODE(EX.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNM2'),1,P_Utilidad.F_ValoDeva('TIPOUNKG'),FI.FCKG,
                                                                     P_Utilidad.F_ValoDeva('TIPOUNML'),(FI.ANCHO / 1000),
                                                                     P_Utilidad.F_ValoDeva('TIPOUNUN'),(FI.ANCHO * FI.LARGO) / 1000000)
                CANTIDAD_CIERRE_ALBARAN_M2,
                DECODE(EX.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNKG'),1,DECODE(NVL(FI.FCKG,0),0,0,DECODE(EX.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNML'),(1 / FI.FCKG) * (FI.ANCHO / 1000),
                                                                                                                P_Utilidad.F_ValoDeva('TIPOUNM2'),1 / FI.FCKG,
                                                                                                                P_Utilidad.F_ValoDeva('TIPOUNUN'),(1 / FI.FCKG) * ((FI.ANCHO * FI.LARGO) / 1000000)))) FACTOR_KG_CANT_CIERRE_ALBA_FX,
                EX.LPCANT *
                DECODE(EX.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNKG'),1,DECODE(NVL(FI.FCKG,0),0,0,DECODE(EX.VUCVEN,P_Utilidad.F_ValoDeva('TIPOUNML'),(1 / FI.FCKG) * (FI.ANCHO / 1000),
                                                                                                                P_Utilidad.F_ValoDeva('TIPOUNM2'),1 / FI.FCKG,
                                                                                                                P_Utilidad.F_ValoDeva('TIPOUNUN'),(1 / FI.FCKG) * ((FI.ANCHO * FI.LARGO) / 1000000))))
                CANTIDAD_CIERRE_ALBARAN_KG,
                ABO.IMPOABON IMPORTE_ABONO, ABO.IMPONUFA IMPO_ABONO_NUEVA_FACTURA, ABO.IMPORTE IMPO_ABONO_NETO_FX,
                OABO.IMPOABON IMPORTE_OTROS_ABONO, OABO.IMPONUFA IMPO_OTROS_ABONO_NUEVA_FACTURA, OABO.IMPORTE IMPO_OTROS_ABONO_NETO_FX,
                PRE.IMPORTE IMPORTE_VENTA, PRE.IVA IVA_VENTA, NVL(PRE.IMPORTE,0) - NVL(ABO.IMPORTE,0) INGRESOS_NETOS_FX,
                --1. OPERACIONES DE INVERSION
                DECODE(DECODE(P.PAIS, NULL,CL.PAIS,P.PAIS),NULL,NULL,
                (NVL(PRE.IMPORTE,0) - NVL(ABO.IMPORTE,0)) * --INGRESOS_NETOS_FX
                PCFI.PORCEN_COST_FINANC_INVER_OT_FX) OPERACIONES_DE_INVERSION_1_FX,
                --2. OPERACIONES DE CIRCULANTE
                DECODE(DECODE(P.PAIS, NULL,CL.PAIS,P.PAIS),NULL,NULL,
                OPCI.PORCENTA) PORCENTA_OPERACIONES_CIRCULANT,
                --nVaOpCirc_R := ((nCP_PRECIO_FAC + nCP_IVA_FAC) * (NVL(nOperCirc_R,0) / 100)) * (nVencimiento / 360);
                DECODE(DECODE(P.PAIS, NULL,CL.PAIS,P.PAIS),NULL,NULL,
                ((NVL(PRE.IMPORTE,0) + NVL(PRE.IVA,0)) * (NVL(OPCI.PORCENTA,0) / 100)) * (CL.VENCIMIENTO_FX / 360)) OPERACIONES_DE_CIRCULANTE_2_FX,
                --'COSTES FINANCIEROS','EUROS REAL'
                --Coste de Seguro de Credito  + 1. + 2.
         	      --nCP_COFIREAL := (nVaOpInve_R + nVaOpCirc_R);
                --OPERACIONES_DE_INVERSION_1_FX
                DECODE(DECODE(P.PAIS, NULL,CL.PAIS,P.PAIS),NULL,NULL,
                ((NVL(PRE.IMPORTE,0) - NVL(ABO.IMPORTE,0)) * PCFI.PORCEN_COST_FINANC_INVER_OT_FX) +  
                --OPERACIONES_DE_CIRCULANTE_2_FX
                (((NVL(PRE.IMPORTE,0) + NVL(PRE.IVA,0)) * (NVL(OPCI.PORCENTA,0) / 100)) * (CL.VENCIMIENTO_FX / 360))) COSTE_SEGURO_CREDITO_1_2_FX
         FROM FIC_CABEOTRE O, ARTICULO A, ANALESTA.ANE_CLIENTES CL, GNR_LINEAS LIN,
              ANALESTA.ANE_PORCEN_COST_FINAN_INVER_OT PCFI,  
              ANALESTA.ANE_OPERACIONES_CIRCULANTE OPCI,
              (SELECT L.EMCODI, L.ASLOTE, SUM(F.LFIMPO) IMPORTE, SUM(F.LFIMPO * (NVL(F.LFPIVA,0)/100)) IVA
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
              GROUP BY L.EMCODI, L.ASLOTE
              HAVING SUM(F.LFIMPO) > 0
              ) PRE,
              (SELECT R.EMPRESA, R.NUMELOTE, SUM(NVL(A.IMPOABON,0)) IMPOABON, SUM(NVL(A.IMPONUFA,0)) IMPONUFA, SUM(NVL(A.IMPOABON,0) - NVL(A.IMPONUFA,0)) IMPORTE 
               FROM RCL_RECLCLIE R, RCL_ACCIONES A, RCL_ACCICOMP AC
               WHERE R.EMPRESA = A.EMPRESA
                 AND R.NUMERCL = A.NUMERCL
                 AND R.ANNO = A.ANNO
                 AND A.EMPRESA = AC.EMPRESA
                 AND A.NUMERCL = AC.NUMERCL
                 AND A.ANNO = AC.ANNO
                 AND A.NUMEORDE = AC.NUMEORDE
                 AND A.TIPOACCI = 'ABONO' AND A.APROCONT = 'S' 
                 AND EXISTS (SELECT 'X' FROM RCL_INOCABON I
                             WHERE AC.TIPOABON = I.TIPIFICA
                               AND I.TIPOIMPU = 'AFECTA A OT')
               GROUP BY R.EMPRESA, R.NUMELOTE
              ) ABO,
              (SELECT R.EMPRESA, R.NUMELOTE, SUM(NVL(A.IMPOABON,0)) IMPOABON, SUM(NVL(A.IMPONUFA,0)) IMPONUFA, SUM(NVL(A.IMPOABON, 0) - NVL(A.IMPONUFA, 0)) IMPORTE 
               FROM RCL_RECLCLIE R, RCL_ACCIONES A, RCL_ACCICOMP AC
               WHERE R.EMPRESA = A.EMPRESA
                 AND R.NUMERCL = A.NUMERCL
                 AND R.ANNO = A.ANNO
                 AND A.EMPRESA = AC.EMPRESA
                 AND A.NUMERCL = AC.NUMERCL
                 AND A.ANNO = AC.ANNO
                 AND A.NUMEORDE = AC.NUMEORDE
                 AND A.TIPOACCI = 'ABONO' AND A.APROCONT = 'S' 
                 AND EXISTS (SELECT 'X' FROM RCL_INOCABON I
                             WHERE AC.TIPOABON = I.TIPIFICA
                               AND I.TIPOIMPU IN ('AFECTA A CLIENTE','AFECTA A LFS','AFECTA A LINEA','AFECTA A TIPO ARTICULO'))
                 AND NOT EXISTS (SELECT 'X' FROM RCL_INOCABON I
                                 WHERE AC.TIPOABON = I.TIPIFICA
                                   AND I.TIPOIMPU = 'AFECTA A OT')
               GROUP BY R.EMPRESA, R.NUMELOTE
              ) OABO,
              (
               SELECT F.EMPRESA, F.TIP_ARTI, F.PRODUCTO, F.MODI, F.REVI, F.ANCHO, F.LARGO, F.MATBASE, L.FCKG, L.DESCRIPCION FROM HFICTEC F, LFS L
               WHERE F.EMPRESA = L.EMPRESA
                 AND F.MATBASE = L.COD_LFS
               UNION
               SELECT F.EMPRESA, F.TIP_ARTI, F.PRODUCTO, F.MODI, F.REVI, F.ANCHO, F.LARGO, F.MATBASE, L.FCKG, L.DESCRIPCION FROM FIC_SEGESTI F, LFS L
               WHERE F.EMPRESA = L.EMPRESA
                 AND F.MATBASE = L.COD_LFS
              ) FI,
              (SELECT CP.EMPRESA, CP.NUMEPEDI, NULL REFEENPM, CP.DIREENVI, DE.PAIS, DE.NOMBRE
               FROM FIC_CABEPEDI CP, 
                    (SELECT DE.EMPRESA, DE.CLIENTE_ID, DE.LINEA, DE.PAIS, PA.NOMBRE FROM GNR_CLDIRENV DE, GNR_PAISES PA
                     WHERE DE.PAIS = PA.PAIS(+)) DE
               WHERE CP.EMPRESA = DE.EMPRESA(+)
                 AND CP.CLIENTE_ID = DE.CLIENTE_ID(+)
                 AND CP.DIREENVI = DE.LINEA(+)
               UNION
               SELECT CP.EMPRESA, CP.NUMEPEDI, NULL REFEENPM, CP.DIREENVI, DE.PAIS, DE.NOMBRE
               FROM FIC_HICAPEVE CP, 
                    (SELECT DE.EMPRESA, DE.CLIENTE_ID, DE.LINEA, DE.PAIS, PA.NOMBRE FROM GNR_CLDIRENV DE, GNR_PAISES PA
                     WHERE DE.PAIS = PA.PAIS(+)) DE
               WHERE CP.EMPRESA = DE.EMPRESA(+)
                 AND CP.CLIENTE_ID = DE.CLIENTE_ID(+)
                 AND CP.DIREENVI = DE.LINEA(+)
               UNION
               SELECT CP.EMPRESA, CP.NUMEPEDI, CP.REFEENPM, NULL DIREENVI, NULL PAIS, NULL NOMBRE FROM FIC_CABEPEMA CP) P,
              (SELECT EMPRESA, NUMERO, ANNO, VALOR FROM FIC_LICHOBOT
               WHERE CODIGO = P_Utilidad.F_ValoDeva('COOTPEPC')) MPC,
              (SELECT EMPRESA, NUMEPEDI, LINEPEDI, TIPOPEDI FROM FIC_LINEPEDI
               UNION 
               SELECT EMPRESA, NUMEPEDI, LINEPEDI, TIPOPEDI FROM FIC_HILIPEVE
               UNION
               SELECT EMPRESA, NUMEPEDI, LINEPEDI, TIPOPEDI FROM FIC_LINEPEMA) LP,
              (SELECT O.EMPRESA,O.NUMERO, A.VUCVEN, SUM(A.LACANT) LPCANT --Unidad y Cantidad de Expedición de Albaranes
                FROM FV_ASVEALH02 A, 
                     FIC_CABEOTRE O,
                     (SELECT DISTINCT EMCODI, CPNROP, ASLOTE, ALNROP, VATCOD, ARCARF, CFNROF FROM FV_ASVELO01 WHERE PROCED = 'F') L
                      WHERE A.EMCODI = O.EMPRESA
                        AND A.VATCOD = O.TIP_ARTI
                        AND A.ARCARF = O.COD_ARTI
                        AND A.DICODI = '01'
                        AND A.ASCANA = 1
                        AND A.CPNROP = O.NUMEPEDI
                        AND L.EMCODI = A.EMCODI
                        AND L.ALNROP = A.ALNROP
                        AND L.VATCOD = A.VATCOD
                        AND L.ARCARF = A.ARCARF
                        AND L.CPNROP = A.CPNROP
                        AND L.EMCODI = O.EMPRESA
                        AND L.ASLOTE = TO_CHAR(O.NUMERO)
                        AND L.CPNROP = O.NUMEPEDI
                        AND NVL(L.CFNROF,0) != 0
                        AND EXISTS (SELECT 'X' FROM FV_ASVEFA02 F
                                   WHERE F.EMCODI = O.EMPRESA
                                     AND F.DICODI = '01'
                                     AND F.ASCANA = 1
                                     AND F.CPNROP = O.NUMEPEDI
                                     AND F.VATCOD = O.TIP_ARTI
                                     AND F.ARCARF = O.COD_ARTI)--Este Facturada la OT
                        AND NOT EXISTS (SELECT 'X' FROM FIC_LINEPEDI P
                                        WHERE P.EMPRESA = O.EMPRESA
                                          AND P.NUMEPEDI = O.NUMEPEDI
                                          AND P.TIP_ARTI = O.TIP_ARTI
                                          AND P.COD_ARTI = O.COD_ARTI)--No quede Pendiente nada por Generar Albaran
                        AND O.TIP_ARTI = P_Utilidad.F_ValoDeva('TIARFIF4')
                   GROUP BY O.EMPRESA,O.NUMERO, A.VUCVEN
                   HAVING SUM(A.LACANT) > 0) EX
         WHERE O.EMPRESA = A.EMPRESA
           AND O.TIP_ARTI = A.TIP_ARTI
           AND O.COD_ARTI = A.COD_ARTI
           AND O.EMPRESA = P.EMPRESA(+)
           AND O.NUMEPEDI = P.NUMEPEDI(+)
           AND O.EMPRESA = MPC.EMPRESA(+)
           AND O.NUMERO = MPC.NUMERO(+)
           AND O.ANNO = MPC.ANNO(+)
           AND O.EMPRESA = LP.EMPRESA(+)
           AND O.NUMEPEDI = LP.NUMEPEDI(+)
           AND O.LINEPEDI = LP.LINEPEDI(+)
           AND A.EMPRESA = CL.EMPRESA(+)
           AND A.CLIENASOC = CL.CLIENTE_ID(+)
           AND O.EMPRESA = FI.EMPRESA(+)
           AND O.TIP_ARTI = FI.TIP_ARTI(+)
           AND O.COD_ARTI = FI.PRODUCTO(+)
           AND NVL(O.MODI,0) = NVL(FI.MODI(+),0)
           AND NVL(O.REVI,0) = NVL(FI.REVI(+),0)
           AND O.EMPRESA = EX.EMPRESA(+)
           AND O.NUMERO = EX.NUMERO(+)
           AND SUBSTR(FI.MATBASE,1,2) = LIN.LINEA
           AND O.EMPRESA = ABO.EMPRESA(+)
           AND O.NUMERO = ABO.NUMELOTE(+)
           AND O.EMPRESA = OABO.EMPRESA(+)
           AND O.NUMERO = OABO.NUMELOTE(+)
           AND O.EMPRESA = PRE.EMCODI(+)
           AND TO_CHAR(O.NUMERO) = PRE.ASLOTE(+)
           AND TO_CHAR(O.FEC_MODI,'YYYY') = PCFI.ANNO(+)
           AND TO_CHAR(O.FEC_MODI,'YYYY') = OPCI.ANNO(+)
           AND TO_CHAR(O.FEC_MODI,'MM') = OPCI.MES_NUMERO(+);
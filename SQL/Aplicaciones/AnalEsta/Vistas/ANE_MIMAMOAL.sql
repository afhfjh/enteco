CREATE OR REPLACE VIEW ANALESTA.ANE_MIMAMOAL AS      
SELECT L.EMCODI EMPRESA, L.VNACOD ALMACEN, A.DESCRIPC DESCALMA, L.VATCOD TIPO_PRODUCTO, L.ARCARF PRODUCTO, AR.GESTSTOC GESTION_STOCK, AR.ANCHO, SUBSTR(L.ARCARF, LENGTH(L.ARCARF)) DIGITO, AR.DESCRIPCION DESCARTI, SUBSTR(AR.COD_LFS,1,2) LINEA, AR.COD_LFS LFS, LFS.FCKG FACTOR_KG, L.MPCPRO PROVEEDOR, P.LETRAS LETRAS_PROVEEDOR, P.DESCRIPCION DESCPROV,
       L.ASLOTE LOTE, PC.NUMEPECO PEDIDO_COMPRAS, TO_CHAR(PC.FECHPECO,'DD-MM-YYYY') FECHA_PEDIDO_COMPRAS, PC.NUMEALBA ALBARAN, TO_CHAR(PC.FECHALBA,'DD-MM-YYYY') FECHA_ALBARAN, DECODE(ROUND((SYSDATE - PC.FECHALBA) / 30,2),NULL,ROUND((SYSDATE - M.FEMIMOVI) / 30,2),ROUND((SYSDATE - PC.FECHALBA) / 30,2)) MESES_PERMANENCIA, PC.PRECUNST, AR.PCMPCOMP PRECMEDI, L.ASKEXI STOCK, AR.UNIDSTOC UNIDAD_STOCK, TO_CHAR(M.FECHMOVI,'DD-MM-YYYY') FECHA_MOVIMIENTO, ROUND((SYSDATE - M.FECHMOVI) / 30,2) MESES_PERMANENCIA_MOVIMIENTO, M.ULTICANT ULTIMA_CANTIDAD_MOVIMIENTO, M.MOVIMIOT ULTIMA_OT_MOVIMIENTO,
       PC.CANTRECE CANTIDAD_RECEPCION, PC.UNIDRECE UNIDAD_RECEPCION, PC.CANTEQPR CANTIDAD_PROVEEDOR, PC.UNIDEQPR UNIDAD_PROVEEDOR, M.CANTINIC CANTIDAD_INICIAL_MOVIMIENTO
FROM ADMFASIV.ASALSL01 L, 
     GENERAL.GNR_ALMACEN A, 
	  GENERAL.ARTICULO AR, 
	  GENERAL.LFS, 
	  GENERAL.PROVEE P,
     (SELECT L.EMCODI, L.DICODI, L.ASLOTE, L.VATCOD, L.ARCARF, C.ACREFE NUMEPECO, LC.PCFALT FECHPECO, L.ACNROA NUMEALBA, L.ACFENT FECHALBA, (L.ALPREU*L.ALCAEQ)/L.ALCANT PRECUNST,
             L.ALCANT CANTRECE, L.ALUNST UNIDRECE, L.ALCAEQ CANTEQPR, L.ALUNCO UNIDEQPR
      FROM ADMFASIV.ASCOAL02 L, ADMFASIV.ASCOAL01 C, 
           (SELECT LC.EMCODI, LC.DICODI, LC.VATCOD, LC.ARCARF, LC.PCNROP, MAX(CC.PCFALT) PCFALT
            FROM ADMFASIV.ASCOPE02 LC, ADMFASIV.ASCOPE01 CC 
            WHERE LC.EMCODI = CC.EMCODI
              AND LC.PCANYP = CC.PCANYP
              AND LC.PCNROP = CC.PCNROP
            GROUP BY LC.EMCODI, LC.DICODI, LC.VATCOD, LC.ARCARF, LC.PCNROP) LC
      WHERE L.EMCODI = C.EMCODI
        AND L.ACANYA = C.ACANYA
        AND L.ACNROA = C.ACNROA
        AND L.EMCODI = LC.EMCODI
        AND L.DICODI = LC.DICODI
        AND L.VATCOD = LC.VATCOD
        AND L.ARCARF = LC.ARCARF
        AND L.PCNROP = LC.PCNROP
        AND TRIM(L.ASLOTE) IS NOT NULL) PC,
     (SELECT EMCODI, DICODI, VATCOD, ARCARF, ASLOTE, 
             MIN(AHFMOV) FEMIMOVI, 
             MAX(AHFMOV) FECHMOVI, 
             MAX(TO_CHAR(AHFMOV,'YYYYMMDD')||' '||LPAD(TRUNC(AHCANT),10,'0')) ULTICANT, 
             MAX(DECODE(VATCOD,'M',TO_CHAR(AHFMOV,'YYYYMMDD')||' '||LPAD(AHNROD,10,'0'),'S',TO_CHAR(AHFMOV,'YYYYMMDD')||' '||LPAD(AHNROD,10,'0'),NULL)) MOVIMIOT,
             MIN(TO_CHAR(AHFMOV,'YYYYMMDD')||' '||LPAD(TRUNC(AHCANT),10,'0')) CANTINIC
      FROM ADMFASIV.ASALHI01
      WHERE TRIM(ASLOTE) IS NOT NULL
      GROUP BY EMCODI, DICODI, VATCOD, ARCARF, ASLOTE) M
WHERE L.EMCODI = A.EMPRESA
  AND L.VNACOD = A.CODIALMA
  
  AND L.EMCODI = AR.EMPRESA
  AND L.VATCOD = AR.TIP_ARTI
  AND L.ARCARF = AR.COD_ARTI
  
  AND L.VATCOD != 'N'
  
  AND AR.EMPRESA = LFS.EMPRESA
  AND AR.COD_LFS = LFS.COD_LFS
  
  AND L.EMCODI = P.EMPRESA(+)
  AND L.MPCPRO = P.COD_PROV(+)
  
  AND L.EMCODI = PC.EMCODI(+)
  AND L.DICODI = PC.DICODI(+)
  AND L.ASLOTE = PC.ASLOTE(+)
  AND L.VATCOD = PC.VATCOD(+)
  AND L.ARCARF = PC.ARCARF(+)
  
  AND L.EMCODI = M.EMCODI(+)
  AND L.DICODI = M.DICODI (+)
  AND L.VATCOD = M.VATCOD(+)
  AND L.ARCARF = M.ARCARF(+) 
  AND L.ASLOTE = M.ASLOTE(+)
  
  AND L.EMCODI IN ('10','01','05','35')
  AND L.ASKEXI > 1;
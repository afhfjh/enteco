CREATE OR REPLACE VIEW "ANALESTA"."ANE_ESTRUCTURA_CUENTAS" AS 
SELECT E.EMPRESA, E.CUENCONT, C.MCTITU DESCRIPCION_CUENCONT, 
       D.DEPARTAM, D.DEPARTAM DESCRIPCION_DEPARTAM, 
       E.SECCION, S.SECCION DESCRIPCION_SECCION, 
       E.SECCAUXI, SA.SECCAUXI DESCRIPCION_SECCAUXI, 
       E.TIPOCOST, T.TIPOCOST DESCRIPCION_TIPOCOST,
       E.TIPOCATE, TC.TIPOCATE DESCRIPCION_TIPOCATE,
       E.TIIMCOST, TI.TIIMCOST DESCRIPCION_TIIMCOST,
       E.INDUCTOR, I.INDUCTOR DESCRIPCION_INDUCTOR,
       E.INDUCOMU, IC.INDUCTOR DESCRIPCION_INDUCOMU,
       E.TIPOORIG, TOR.TIPOORIG DESCRIPCION_TIPOORIG,
       E.INDUREPA, IR.INDUREPA DESCRIPCION_INDUREPA
FROM GENERAL.GNR_ESCCEMPR E,
     ADMFASIV.ASCGCO01 C,
     GENERAL.GNR_DEPAEMPR D,
     GENERAL.GNR_SEPREMPR S,
     GENERAL.GNR_SEAUEMPR SA,
     GENERAL.GNR_TICOEMPR T,
     GENERAL.GNR_CACOEMPR TC,
     GENERAL.GNR_TIICEMPR TI,
     GENERAL.GNR_INDUEMPR I,
     GENERAL.GNR_INDUEMPR IC,
     GENERAL.GNR_TIOREMPR TOR,
     GENERAL.GNR_INRECOCO IR
WHERE C.EMCODI = E.EMPRESA
  AND C.MCTCTA = 'S'
  AND TRIM(C.CTCCTA) = TRIM(E.CUENCONT)
  AND D.CODIGO(+) = E.DEPARTAM
  AND S.CODIGO(+) = E.SECCION
  AND SA.CODIGO(+) = E.SECCAUXI
  AND T.CODIGO(+) = E.TIPOCOST
  AND TC.CODIGO(+) = E.TIPOCATE
  AND TI.CODIGO(+) = E.TIIMCOST
  AND I.CODIGO(+) = E.INDUCTOR
  AND IC.CODIGO(+) = E.INDUCOMU
  AND TOR.CODIGO(+) = E.TIPOORIG
  AND IR.CODIGO(+) = E.INDUREPA;



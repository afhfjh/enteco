CREATE OR REPLACE VIEW ANALESTA.ANE_ABONOS AS
SELECT R.EMPRESA, R.NUMELOTE, AC.TIPOABON TIPO_ABONO, I.DESCRIPC DESCRIPCION_TIPO_ABONO, SUM(NVL(A.IMPOABON,0)) IMPORTE_ABONO, SUM(NVL(A.IMPONUFA,0)) IMPO_ABONO_NUEVA_FACTURA, SUM(NVL(A.IMPOABON,0) - NVL(A.IMPONUFA,0)) IMPO_ABONO_NETO_FX 
FROM RCL_RECLCLIE R, RCL_ACCIONES A, RCL_ACCICOMP AC, RCL_TIPIABON I
WHERE R.EMPRESA = A.EMPRESA
  AND R.NUMERCL = A.NUMERCL
  AND R.ANNO = A.ANNO
  AND A.EMPRESA = AC.EMPRESA
  AND A.NUMERCL = AC.NUMERCL
  AND A.ANNO = AC.ANNO
  AND A.NUMEORDE = AC.NUMEORDE
  AND A.TIPOACCI = 'ABONO' AND A.APROCONT = 'S' 
  AND AC.TIPOABON = I.TIPIFICA(+)
GROUP BY R.EMPRESA, R.NUMELOTE, AC.TIPOABON, I.DESCRIPC;
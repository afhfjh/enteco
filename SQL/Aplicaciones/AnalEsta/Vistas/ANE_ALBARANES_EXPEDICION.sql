CREATE OR REPLACE VIEW ANALESTA.ANE_ALBARANES_EXPEDICION AS
SELECT O.EMPRESA,O.NUMERO NUMELOTE, L.ALNROP ALBARAN, L.CPNROP NUMEPEDI, L.VATCOD TIPO_ARTICULO, L.ARCARF ARTICULO, A.VUCVEN UNIDAD_VENTA, SUM(A.LACANT) CANTIDAD_EXPEDICION 
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
GROUP BY O.EMPRESA,O.NUMERO, L.ALNROP, L.CPNROP, L.VATCOD,  L.ARCARF, A.VUCVEN
HAVING SUM(A.LACANT) > 0
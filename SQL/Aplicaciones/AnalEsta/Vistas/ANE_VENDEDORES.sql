CREATE OR REPLACE VIEW ANALESTA.ANE_VENDEDORES AS
SELECT V.EMPRESA, V.TIPO, V.VENDEDOR, V.NOMBRE 
FROM GNR_VENDEDOR V
WHERE EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = V.EMPRESA);
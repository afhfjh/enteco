CREATE OR REPLACE VIEW ANALESTA.ANE_CLIENTES AS
         SELECT C.EMPRESA, C.CLIENTE_ID, C.RAZON_SOC, C.PAIS, P.NOMBRE DESCRIPCION_PAIS, CV.VENDEDOR, CV.TIPO TIPO_VENDEDOR, CV.NOMBRE DESCRIPCION_VENEDEDOR, CV.NUMERO NUMERO_DE_VENDEDORES_DEFINIDO,
                FC.PLAZOS, FC.VENCIMI1, FC.VENCIMI2, DECODE(FC.PLAZOS,NULL,0,DECODE(FC.PLAZOS,1,NVL(FC.VENCIMI1,0),NVL(FC.VENCIMI1,0)+((NVL(FC.PLAZOS,0)-1)*NVL(FC.VENCIMI2,0)))) VENCIMIENTO_FX
         FROM CLIENTES C, GNR_PAISES P, GNR_CLFCOBRO FC,
              (SELECT CV.EMPRESA, CV.CLIENTE_ID, CV.VENDEDOR, CV.TIPO, V.NOMBRE, CO.NUMERO 
               FROM GNR_CLVENDED CV, GNR_VENDEDOR V,
                    (SELECT CO.EMPRESA, CO.CLIENTE_ID, COUNT(*) NUMERO FROM GNR_CLVENDED CO
                     GROUP BY CO.EMPRESA, CO.CLIENTE_ID) CO,
                    (SELECT CM.EMPRESA, CM.CLIENTE_ID, MAX(CM.TIPO||'|'||CM.VENDEDOR) IDENTIFI FROM GNR_CLVENDED CM
                     GROUP BY CM.EMPRESA, CM.CLIENTE_ID) CM
               WHERE CV.TIPO = V.TIPO
                 AND CV.VENDEDOR = V.VENDEDOR
                 AND CV.EMPRESA = CO.EMPRESA 
                 AND CV.CLIENTE_ID = CO.CLIENTE_ID
                 AND CV.EMPRESA = CM.EMPRESA 
                 AND CV.CLIENTE_ID = CM.CLIENTE_ID
                 AND CV.TIPO||'|'||CV.VENDEDOR = CM.IDENTIFI) CV
            WHERE C.PAIS = P.PAIS
              AND C.EMPRESA = CV.EMPRESA(+)
              AND C.CLIENTE_ID = CV.CLIENTE_ID(+)
              AND C.EMPRESA = FC.EMPRESA(+)
              AND C.CLIENTE_ID = FC.CLIENTE_ID(+)
              AND C.ACFCOBRO = FC.LINEA(+)
              AND EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = C.EMPRESA);
 /
 
 /*
              IF rVencimiento.PLAZOS IS NOT NULL THEN
         	      IF rVencimiento.PLAZOS = 1 THEN
         	         nVencimiento := NVL(rVencimiento.VENCIMI1,0);
         	      ELSE
         	         nVencimiento := NVL(rVencimiento.VENCIMI1,0) + ((NVL(rVencimiento.PLAZOS,0) - 1) * NVL(rVencimiento.VENCIMI2,0));
         	      END IF;            
         	   ELSE
         	      nVencimiento := 0;
         	   END IF; 
*/
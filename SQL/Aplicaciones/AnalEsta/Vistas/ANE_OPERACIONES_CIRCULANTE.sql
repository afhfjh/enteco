CREATE OR REPLACE VIEW ANALESTA.ANE_OPERACIONES_CIRCULANTE AS
         SELECT ANNO, MES, 
                DECODE(MES,'ENERO','01',
                           'FEBRERO','02',
                           'MARZO','03',
                           'ABRIL','04',
                           'MAYO','05',
                           'JUNIO','06',
                           'JULIO','07',
                           'AGOSTO','08',
                           'SEPTIEMBRE','09',
                           'OCTUBRE','10',
                           'NOVIEMBRE','11',
                           'DICIEMBRE','12') MES_NUMERO,
                SUM(PORCENTA) PORCENTA 
         FROM ANE_DATOOPCI
            WHERE TIPO = 'R'
          GROUP BY ANNO, MES;
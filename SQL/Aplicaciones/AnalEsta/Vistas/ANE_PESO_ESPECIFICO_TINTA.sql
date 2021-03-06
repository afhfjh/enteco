CREATE OR REPLACE VIEW ANALESTA.ANE_PESO_ESPECIFICO_TINTA AS
         SELECT 'BLANCO' TINTA, 'FLEXO' TIPO_IMPRESION, P_UTILIDAD.F_ValoCampo (VALOR,'FLEXO') VALOR FROM VALORES_LISTA
            WHERE CODIGO = 'PRI_PEESTINT'
              AND P_UTILIDAD.F_ValoCampo (VALOR,'TINTA') = 'BLANCO'
         UNION
         SELECT 'RESTO' TINTA, 'FLEXO' TIPO_IMPRESION, P_UTILIDAD.F_ValoCampo (VALOR,'FLEXO') VALOR FROM VALORES_LISTA
            WHERE CODIGO = 'PRI_PEESTINT'
              AND P_UTILIDAD.F_ValoCampo (VALOR,'TINTA') = 'RESTO'
         UNION
         SELECT 'BLANCO' TINTA, 'HUECO' TIPO_IMPRESION, P_UTILIDAD.F_ValoCampo (VALOR,'HUECO') VALOR FROM VALORES_LISTA
            WHERE CODIGO = 'PRI_PEESTINT'
              AND P_UTILIDAD.F_ValoCampo (VALOR,'TINTA') = 'BLANCO'
         UNION
         SELECT 'RESTO' TINTA, 'HUECO' TIPO_IMPRESION, P_UTILIDAD.F_ValoCampo (VALOR,'HUECO') VALOR FROM VALORES_LISTA
            WHERE CODIGO = 'PRI_PEESTINT'
              AND P_UTILIDAD.F_ValoCampo (VALOR,'TINTA') = 'RESTO';
              
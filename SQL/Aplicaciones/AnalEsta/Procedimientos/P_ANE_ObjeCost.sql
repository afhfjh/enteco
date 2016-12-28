CREATE OR REPLACE
PROCEDURE ANALESTA.P_ANE_OBJECOST(vEmpresa_OT FIC_CABEOTRE.EMPRESA%TYPE, nNumero_OT FIC_CABEOTRE.NUMERO%TYPE, nAnno_OT FIC_CABEOTRE.ANNO%TYPE) IS
   nContInco NUMBER := 0;--Contador de Insercion de Conceptos
   bExisCabe BOOLEAN;
   --BEFORE
   vP_IRPIPTCS VARIABLES.VALOR%TYPE := P_Utilidad.F_ValoDeva('IRPIPTCS');
   --
   vP_IRSIPTCS VARIABLES.VALOR%TYPE := P_Utilidad.F_ValoDeva('IRSIPTCS');
	--
   vP_EMPRPHAR VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('EMPRPHAR');
   vP_EMPRMANV VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('EMPRMANV');
   vP_EMPRGEST VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('EMPRMANV');
   --
   vP_INDUPEUN VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('INDUPEUN');
   --
   vP_INDUKGTI VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('INDUKGTI');
   --
   vP_TIARFIF4 VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('TIARFIF4');
   vP_TIARSEF4 VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('TIARSEF4');
   vP_TIARMPF4 VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('TIARMPF4');
   --
   vP_TIPOUNML VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('TIPOUNML');
   vP_TIPOUNKG VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('TIPOUNKG');
   vP_TIPOUNM2 VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('TIPOUNM2');
   --Depto Produccion
   vP_CODEPROD VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('CODEPROD');
   --Depto Preimpresion
   vP_CODEPREI VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('CODEPREI');
   --Depto Tintas
   vP_CODETINT VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('CODETINT');
   --Secciones auxiliares de Impresion
   vP_SEAUIMPR VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('SEAUIMPR');
   --Secciones auxiliares de Laminación
   vP_SEAULAMI VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('SEAULAMI');
   --Secciones auxiliares de Laqueadoras
   vP_SEAULAQU VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('SEAULAQU');
   --Secciones auxiliares de Cortadoras
   vP_SEAUCORT VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('SEAUCORT');
   --
   vP_TIARPROI VARIABLES.VALOR%TYPE := p_Utilidad.F_ValoDeva('TIARPROI');
   vP_TIARTIF4 VARIABLES.VALOR%TYPE := p_Utilidad.F_ValoDeva('TIARTIF4');
   --
   vP_TICOFINA VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('TICOFINA');
   --Pais España para saber si es Nacional / Exportacion
   vP_PAISESPA VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('PAISESPA');
   --Secc. Aux. Nacional
   vP_COSACONA VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('COSACONA');
   --Secc. Aux. Exportacion
   vP_COSACOEX VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('COSACOEX');
   --Departamento Comunes
   vP_CODECOMU VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('CODECOMU');
   vP_INDUSIIN VARIABLES.VALOR%TYPE := P_UTILIDAD.F_VALODEVA('INDUSIIN');
   --
   CURSOR cPeesTint(vTinta VALORES_LISTA.VALOR%TYPE, vTipoImpr VALORES_LISTA.VALOR%TYPE) IS
      SELECT P_UTILIDAD.F_ValoCampo (VALOR,vTipoImpr) FROM VALORES_LISTA
         WHERE CODIGO = 'PRI_PEESTINT'
           AND P_UTILIDAD.F_ValoCampo (VALOR,'TINTA') = vTinta;
	--
	vP_PesoBlFl VALORES_LISTA.VALOR%TYPE;
   vP_PesoReFl VALORES_LISTA.VALOR%TYPE;
   vP_PesoBlHu VALORES_LISTA.VALOR%TYPE;
   vP_PesoReHu VALORES_LISTA.VALOR%TYPE;
   --
   CURSOR cGNR_INDUEMPR IS
      SELECT INDUCTOR FROM GNR_INDUEMPR
         WHERE CODIGO = vP_IRPIPTCS;
	--
	vP_DESC_IRPIPTCS GNR_INDUEMPR.INDUCTOR%TYPE;
   --FIN BEFORE
   --INICIO VARIABLES PLACEHOLDERS
   nCP_ANCHO_MM HFTGESTI.ANCHO%TYPE := 0;
   nCP_Ancho_MM_PROD HFTGESTI.ANCHO%TYPE := 0;
   nCP_CantCerr_ML_PROD NUMBER := 0;
   nCP_COLAESTA NUMBER := 0;
   nCP_COLAREAL NUMBER := 0;
   nCP_N_Veces  NUMBER := 0;
   nCP_CantCerr_ML NUMBER := 0;
   nCP_MALACRML NUMBER := 0;
   nCP_MALAMRML NUMBER := 0;
   nCP_COMTREAL NUMBER := 0;
   --
   nCP_MALACRM2 NUMBER := 0;
   nCP_MALAMRM2 NUMBER := 0;
   nCP_MALACRKG NUMBER := 0;
   nCP_MALAMRKG NUMBER := 0;
   nCP_MALACEML NUMBER := 0;
   nCP_MALAFAML NUMBER := 0;
   nCP_MALACEM2 NUMBER := 0;
   nCP_MALAFAM2 NUMBER := 0;
   nCP_MALACEKG NUMBER := 0;
   nCP_MALAFAKG NUMBER := 0;
   nCP_MALAMEML NUMBER := 0;
   nCP_COMTESTA NUMBER := 0;
   --
   vCP_PEDINUMO VARCHAR2(2);
   vCP_TIPOPEDI VARCHAR2(1);
   --
   nCP_M2ML NUMBER;
   --
   vCP_CLIENTE_ID CLIENTES.CLIENTE_ID%TYPE;
   vCP_RAZON_SOC CLIENTES.RAZON_SOC%TYPE;
   --
   nCP_PRECIO_FAC NUMBER := 0;
   --
   nCP_COCOESTA NUMBER := 0;
   nCP_COCOREAL NUMBER := 0;
   nCP_ABONESTA NUMBER := 0;
   nCP_ABONREAL NUMBER := 0;
   nCP_INNEESTA NUMBER := 0;
   nCP_INNEREAL NUMBER := 0;
   nCP_COFIESTA NUMBER := 0;
   nCP_COFIREAL NUMBER := 0;
   --
   nCP_MALAMEKG NUMBER := 0;
   nCP_MALAMEM2 NUMBER := 0;
   nCP_POMTESUN_CS NUMBER := 0;
   nCP_POMTESEU_EU NUMBER := 0;
   nCP_POMTREUN_CS NUMBER := 0;
   nCP_POMTREEU_EU NUMBER := 0;
   --DE TINTAS
   nCP_POCTESTA_CS NUMBER := 0;
   nCP_POCTREAL_CS NUMBER := 0;
   nCP_COTODIES_CS NUMBER := 0;
   nCP_COTODIRE_CS NUMBER := 0;
   nCP_COTOINES_CS NUMBER := 0;
   nCP_COTOINRE_CS NUMBER := 0;
   nCP_DIFECOTI_CS NUMBER := 0;
   nCP_DIPOCOTI_CS NUMBER := 0;
   nCP_TOTACOES_CS NUMBER := 0;
   nCP_TOTACORE_CS NUMBER := 0;
   nCP_POTOCOES_CS NUMBER := 0;
   nCP_POTOCORE_CS NUMBER := 0;
   nCP_DIFETOCO_CS NUMBER := 0;
   nCP_DIPOTOCO_CS NUMBER := 0;
   nCP_COPRVEES_CS NUMBER := 0;
   nCP_COPRVERE_CS NUMBER := 0;
   nCP_POCOPVES_CS NUMBER := 0;
   nCP_POCOPVRE_CS NUMBER := 0;
   nCP_DICOPRVE_CS NUMBER := 0;
   nCP_DPCOPRVE_CS NUMBER := 0;
   nCP_MAMAESTA_CS NUMBER := 0;
   nCP_MAMAREAL_CS NUMBER := 0;
   nCP_POMAMAES_CS NUMBER := 0;
   nCP_POMAMARE_CS NUMBER := 0;
   nCP_DIFEMAMA_CS NUMBER := 0;
   nCP_DIPOMAMA_CS NUMBER := 0;
   nCP_MARGPRES_CS NUMBER := 0;
   nCP_MARGPRRE_CS NUMBER := 0;
   nCP_DIFEMAPR_CS NUMBER := 0;
   nCP_DIPOMAPR_CS NUMBER := 0;
   nCP_POMAPRES_CS NUMBER := 0;
   nCP_POMAPRRE_CS NUMBER := 0;
   nCP_TOCOSPES_CS NUMBER := 0;
   nCP_TOCOSPRE_CS NUMBER := 0;
   nCP_MAINESTA_CS NUMBER := 0;
   nCP_MAINREAL_CS NUMBER := 0;
   nCP_POMAINES_CS NUMBER := 0;
   nCP_POMAINRE_CS NUMBER := 0;
   nCP_DIFEMAIN_CS NUMBER := 0;
   nCP_DIPOMAIN_CS NUMBER := 0;
   nCP_MACOESTA_CS NUMBER := 0;
   nCP_MACOREAL_CS NUMBER := 0;
   nCP_DIFEMACO_CS NUMBER := 0;
   nCP_DIPOMACO_CS NUMBER := 0;
   nCP_POMACOES_CS NUMBER := 0;
   nCP_POMACORE_CS NUMBER := 0;
   nCP_MARCESTA_CS NUMBER := 0;
   nCP_MARCREAL_CS NUMBER := 0;
   nCP_DIFEMARC_CS NUMBER := 0;
   nCP_DIPOMARC_CS NUMBER := 0;
   nCP_POMARCES_CS NUMBER := 0;
   nCP_POMARCRE_CS NUMBER := 0;
   nCP_MAEBESTA_CS NUMBER := 0;
   nCP_MAEBREAL_CS NUMBER := 0;
   nCP_POMAEBES_CS NUMBER := 0;
   nCP_POMAEBRE_CS NUMBER := 0;
   nCP_DIFEMAEB_CS NUMBER := 0;
   nCP_DIPOMAEB_CS NUMBER := 0;
   nCP_CFOPESTA_CS NUMBER := 0;
   nCP_CFOPREAL_CS NUMBER := 0;
   nCP_POCFOPES_CS NUMBER := 0;
   nCP_POCFOPRE_CS NUMBER := 0;
   nCP_DIFECFOP_CS NUMBER := 0;
   nCP_DIPOCFOP_CS NUMBER := 0;
   nCP_MAGRESTA_CS NUMBER := 0;
   nCP_CFMGESTA_CS NUMBER := 0;
   nCP_CFMGREAL_CS NUMBER := 0;
   nCP_DIFECFMG_CS NUMBER := 0;
   nCP_DIPOCFMG_CS NUMBER := 0;
   nCP_POCFMGES_CS NUMBER := 0;
   nCP_POCFMGRE_CS NUMBER := 0;
   --
   nCS_CP_TOCODIRE NUMBER := 0;
   nCS_CP_TOCODIES NUMBER := 0;
   nCS_CP_INNEESTA NUMBER := 0;
   nCS_CP_INNEREAL NUMBER := 0;
   nCS_CP_COLAESTA NUMBER := 0;
   nCS_CP_COLAREAL NUMBER := 0;
   nCS_CP_COMTESTA NUMBER := 0;
   nCS_CP_COMTREAL NUMBER := 0;
   nCS_CF_COSTE_TOTAL_ESTANDAR NUMBER := 0;
   nCS_CF_COSTE_TOTAL_REAL NUMBER := 0;
   nCS_CP_COFIESTA NUMBER := 0;
   nCS_CP_COFIREAL NUMBER := 0;
   nCS_CP_PRECIO_FAC NUMBER := 0;
   nCS_CP_ABONESTA NUMBER := 0;
   nCS_CP_ABONREAL NUMBER := 0;
   nCP_DIMLCOKG_CS NUMBER := 0;
   nCP_DIMLCOM2_CS NUMBER := 0;
   nCP_DIMLCOML_CS NUMBER := 0;
   nCS_CP_MALACEKG NUMBER := 0;
   nCS_CP_MALACEM2 NUMBER := 0;
   nCS_CP_MALACEML NUMBER := 0;
   nCP_DIFECOEU_CS NUMBER := 0;
   nCS_CP_COCOESTA NUMBER := 0;
   nCS_CP_MALACRKG NUMBER := 0;
   nCS_CP_MALACRM2 NUMBER := 0;
   nCS_CP_MALACRML NUMBER := 0;
   nCP_DPMLCOKG_CS NUMBER := 0;
   nCP_DPMLCOM2_CS NUMBER := 0;
   nCP_DPMLCOML_CS NUMBER := 0;
   nCS_CP_COCOREAL NUMBER := 0;
   nCP_DIPOCOEU_CS NUMBER := 0;
   nCS_CP_MALAMEKG NUMBER := 0;
   nCS_CP_MALAMEM2 NUMBER := 0;
   nCS_CP_MALAMEML NUMBER := 0;
   nCP_DIFEFAEU_CS NUMBER := 0;
   nCP_DIPOFAEU_CS NUMBER := 0;
   nCP_DIMLMTKG_CS NUMBER := 0;
   nCP_DIMLMTM2_CS NUMBER := 0;
   nCP_DIMLMTML_CS NUMBER := 0;
   nCS_CP_MALAMRKG NUMBER := 0;
   nCS_CP_MALAMRM2 NUMBER := 0;
   nCS_CP_MALAMRML NUMBER := 0;
   nCP_DPMLMTKG_CS NUMBER := 0;
   nCP_DPMLMTM2_CS NUMBER := 0;
   nCP_DPMLMTML_CS NUMBER := 0;
   nCP_DIFEMTEU_CS NUMBER := 0;
   nCP_DIPOMTEU_CS NUMBER := 0;
   nCP_DPMTESUN_CS NUMBER := 0;
   nCP_DIPOMETO_CS NUMBER := 0;
   nCP_DIFEABON_CS NUMBER := 0;
   nCP_DIPOABON_CS NUMBER := 0;
   nCP_DIFEINNE_CS NUMBER := 0;
   nCP_DIPOINNE_CS NUMBER := 0;
   nCP_POCLESTA_CS NUMBER := 0;
   nCP_POCLREAL_CS NUMBER := 0;
   nCP_POMEPRES_CS NUMBER := 0;
   nCP_POMEPRRE_CS NUMBER := 0;
   nCP_POCMOPES_CS NUMBER := 0;
   nCP_POCMOPRE_CS NUMBER := 0;
   nCP_DIFECMOP_CS NUMBER := 0;
   nCP_DIPOCMOP_CS NUMBER := 0;
   nCP_POOTCPES_CS NUMBER := 0;
   nCP_POOTCPRE_CS NUMBER := 0;
   nCP_DIFEOTCP_CS NUMBER := 0;
   nCP_DIPOOTCP_CS NUMBER := 0;
   nCP_POCALIES_CS NUMBER := 0;
   nCP_POCALIRE_CS NUMBER := 0;
   nCP_POLOINES_CS NUMBER := 0;
   nCP_POLOINRE_CS NUMBER := 0;
   nCP_POALMAES_CS NUMBER := 0;
   nCP_POALMARE_CS NUMBER := 0;
   nCP_DIFECALI_CS NUMBER := 0;
   nCP_DIPOCALI_CS NUMBER := 0;
   nCP_DIFELOIN_CS NUMBER := 0;
   nCP_DIPOLOIN_CS NUMBER := 0;
   nCP_DIFEALMA_CS NUMBER := 0;
   nCP_DIPOALMA_CS NUMBER := 0;
   nCP_POTCSPES_CS NUMBER := 0;
   nCP_POTCSPRE_CS NUMBER := 0;
   nCP_DIFETCSP_CS NUMBER := 0;
   nCP_DIPOTCSP_CS NUMBER := 0;
   nCP_POCOCOES_CS NUMBER := 0;
   nCP_POCOCORE_CS NUMBER := 0;
   nCP_DIFECOCO_CS NUMBER := 0;
   nCP_DIPOCOCO_CS NUMBER := 0;
   nCP_POCODIES_CS NUMBER := 0;
   nCP_POCODIRE_CS NUMBER := 0;
   nCP_DIFECODI_CS NUMBER := 0;
   nCP_DIPOCODI_CS NUMBER := 0;
   nCP_POCOADES_CS NUMBER := 0;
   nCP_POCOADRE_CS NUMBER := 0;
   nCP_DIFECOAD_CS NUMBER := 0;
   nCP_DIPOCOAD_CS NUMBER := 0;
   nCP_POCOFIES_CS NUMBER := 0;
   nCP_POCOFIRE_CS NUMBER := 0;
   nCP_DIFECOFI_CS NUMBER := 0;
   nCP_DIPOCOFI_CS NUMBER := 0;
   nCP_POMAGRES_CS NUMBER := 0;
   nCP_POMAGRRE_CS NUMBER := 0;
   nCP_DIFEMAGR_CS NUMBER := 0;
   nCP_DIPOMAGR_CS NUMBER := 0;
   nCS_CP_TOCODIES_CS NUMBER := 0;
   nCS_CP_TOCODIRE_CS NUMBER := 0;
   --SUM DEPARTAM
   nCP_SUM_OTROCOST_R NUMBER := 0;
   nCP_SUM_COSTCOME_R NUMBER := 0;
   nCP_SUM_COSTDIST_R NUMBER := 0;
   nCP_SUM_COSTADMI_R NUMBER := 0;
   nCP_SUM_LOGIINTE_R NUMBER := 0;
   nCP_SUM_ALMACEN_R NUMBER := 0;
   nCP_SUM_CALIDAD_R NUMBER := 0;
   nCP_SUM_OTROCOST_E NUMBER := 0;
   nCP_SUM_COSTCOME_E NUMBER := 0;
   nCP_SUM_COSTDIST_E NUMBER := 0;
   nCP_SUM_COSTADMI_E NUMBER := 0;
   nCP_SUM_LOGIINTE_E NUMBER := 0;
   nCP_SUM_ALMACEN_E NUMBER := 0;
   nCP_SUM_CALIDAD_E NUMBER := 0;
   --
   nCS_CP_RESUPREI NUMBER := 0;
   --FIN VARIABLES PLACEHOLDERS
   --Cabecera del Analis de Objetivo de Costes
   rANE_OBJECOST ANE_OBJECOST%ROWTYPE;
   --
   CURSOR cOT (vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, nNumero FIC_CABEOTRE.NUMERO%TYPE, nAnno FIC_CABEOTRE.ANNO%TYPE) IS
      SELECT O.EMPRESA, O.NUMERO, O.ANNO, O.TIP_ARTI, O.COD_ARTI, A.DESCRIPCION, O.FEC_MODI FECHA_CIERRE , O.MODI, O.REVI, O.NUMEPEDI, O.LINEPEDI, O.CANTCERR, O.UNIDAD, O.NUMEOTTE, O.ANNOOTTE, OC.ROWID ROWID_OC
      FROM FIC_CABEOTRE O, ARTICULO A, ANE_OBJECOST OC
      WHERE O.EMPRESA = A.EMPRESA
        AND O.TIP_ARTI = A.TIP_ARTI
        AND O.COD_ARTI = A.COD_ARTI  
        AND O.EMPRESA = OC.EMPRESA(+)
        AND O.NUMERO = OC.NUMERO_OT(+)
        AND O.SITUACIO = 'C'
        AND O.EMPRESA = vEmpresa
        AND O.NUMERO = nNumero
        AND O.ANNO = nAnno;
   --
   vValoRegr VARCHAR2(5000);
   --
   CURSOR cPediNumo(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, nNumePedi FIC_LINEPEDI.NUMEPEDI%TYPE, nLinePedi FIC_LINEPEDI.LINEPEDI%TYPE) IS
      SELECT TIPOPEDI FROM FIC_LINEPEDI
         WHERE EMPRESA = vEmpresa
           AND NUMEPEDI = nNumePedi
           AND LINEPEDI = nLinePedi
           AND nNumePedi IS NOT NULL
           AND nLinePedi IS NOT NULL
      UNION 
      SELECT TIPOPEDI FROM FIC_HILIPEVE
         WHERE EMPRESA = vEmpresa
           AND NUMEPEDI = nNumePedi
           AND LINEPEDI = nLinePedi
           AND nNumePedi IS NOT NULL
           AND nLinePedi IS NOT NULL;
   --
   CURSOR cFIC_INFOPROD(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, nNumero FIC_CABEOTRE.NUMERO%TYPE, nAnno FIC_CABEOTRE.ANNO%TYPE) IS
      SELECT I.* FROM FIC_INFOPROD I
         WHERE I.EMPRESA = vEmpresa
           AND I.NUMERO = nNumero
           AND I.ANNO = nAnno
           AND I.TIPOMAQU = 'IMPRESORA';
   --
   rFIC_INFOPROD cFIC_INFOPROD%ROWTYPE;
   --
   CURSOR cHFTGESTI(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vTip_Arti HFTGESTI.TIP_ARTI%TYPE, vProducto HFTGESTI.PRODUCTO%TYPE,
                    nModi HFTGESTI.MODI%TYPE, nRevi HFTGESTI.REVI%TYPE)  IS
      SELECT ANCHO, LARGO, MATBASE FROM HFICTEC
         WHERE EMPRESA = vEmpresa
           AND TIP_ARTI = vTip_Arti
           AND PRODUCTO = vProducto
           AND MODI = nModi
           AND REVI = nRevi;
   --
   CURSOR cFIC_SEGESTI(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vTip_Arti HFTGESTI.TIP_ARTI%TYPE, vProducto HFTGESTI.PRODUCTO%TYPE) IS
      SELECT ANCHO, LARGO, MATBASE FROM FIC_SEGESTI
         WHERE EMPRESA = vEmpresa
           AND TIP_ARTI = vTip_Arti
           AND PRODUCTO = vProducto;
   --
   nLargo HFICTEC.LARGO%TYPE; 
   vMatBase HFICTEC.MATBASE%TYPE;
   --
   nFactor NUMBER;
   nFactorM2 NUMBER;
   nFactorUP NUMBER;
   nFactorULMP NUMBER;
   --
   CURSOR cPrecio(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, nNumero FIC_CABEOTRE.NUMERO%TYPE) IS
      SELECT SUM(F.LFIMPO) IMPORTE
         FROM FV_ASVEFA02 F, FV_ASVELO01 L
         WHERE F.EMCODI = L.EMCODI
           AND F.DICODI = L.DICODI
           AND F.ASCANA = L.ASCANA
           AND F.CFNROF = L.CFNROF
           --AND F.LFLINF = L.LFLINF
           AND F.CPNROP = L.CPNROP
           AND L.EMCODI = vEmpresa 
           AND L.ASLOTE = TO_CHAR(nNumero); 
   --
   rPrecio cPrecio%ROWTYPE;    
   --Precios Estandar de Materias Primas
   CURSOR cANE_PRECMAPR (vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vTip_Arti ANE_PRECMAPR.TIP_ARTI%TYPE,vCod_Arti ANE_PRECMAPR.COD_ARTI%TYPE,
                         dFecha_Cierre DATE) IS
      SELECT * FROM ANE_PRECMAPR
         WHERE EMPRESA = vEmpresa
           AND TIP_ARTI = vTip_Arti
           AND COD_ARTI = vCod_Arti
           AND ANNO = TO_CHAR(dFecha_Cierre,'YYYY')
           AND MES = DECODE(TO_CHAR(dFecha_Cierre,'MM'),'01','ENERO',
                                                        '02','FEBRERO',
                                                        '03','MARZO',
                                                        '04','ABRIL',
                                                        '05','MAYO',
                                                        '06','JUNIO',
                                                        '07','JULIO',
                                                        '08','AGOSTO',
                                                        '09','SEPTIEMBRE',
                                                        '10','OCTUBRE',
                                                        '11','NOVIEMBRE',
                                                        '12','DICIEMBRE');
   --
   rANE_PRECMAPR cANE_PRECMAPR%ROWTYPE;
   --Precio Real 
   CURSOR cExisPeri(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vTip_Arti ANE_PRECMAPR.TIP_ARTI%TYPE,vCod_Arti ANE_PRECMAPR.COD_ARTI%TYPE,
                    dFecha_Cierre DATE) IS
      SELECT ASLOTE, SUM(DECODE(AHTIMO,'E',AHCANT,-AHCANT)) AHCANT FROM FV_ASALHI01 
         WHERE EMCODI = vEmpresa
           AND VATCOD = vTip_Arti
           AND ARCARF = vCod_Arti
           AND TRIM(ASLOTE) IS NOT NULL
           AND TRUNC(AHFMOV) <= TRUNC(LAST_DAY(dFecha_Cierre))
      GROUP BY ASLOTE
      HAVING SUM(DECODE(AHTIMO,'E',AHCANT,-AHCANT)) > 0;
   --
   CURSOR cCompras(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vTip_Arti ANE_PRECMAPR.TIP_ARTI%TYPE,vCod_Arti ANE_PRECMAPR.COD_ARTI%TYPE,vLote FV_ASCOAL02.ASLOTE%TYPE) IS
      SELECT DECODE(ALCANT, 0, 0,(ALPREU * ALCAEQ) / ALCANT) ALPREU FROM FV_ASCOAL02
         WHERE EMCODI = vEmpresa
           AND VATCOD = vTip_Arti
           AND ARCARF = vCod_Arti
           AND ASLOTE = vLote;
   --
   nPrecComp FV_ASCOAL02.ALPREU%TYPE;
   --
   CURSOR cUltiCompr(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vTip_Arti ANE_PRECMAPR.TIP_ARTI%TYPE,vCod_Arti ANE_PRECMAPR.COD_ARTI%TYPE) IS
      SELECT ALCAEQ, ALPREU, ALCANT, ALUNST, ALUNCO --ALPREU 
      FROM FV_ASCOAL02
         WHERE EMCODI = vEmpresa
           AND VATCOD = vTip_Arti
           AND ARCARF = vCod_Arti
      ORDER BY ACFENT DESC;
   --
   rUltiCompr cUltiCompr%ROWTYPE;
   --
   nCantPrme NUMBER := 0;
   nPrecPrme NUMBER := 0;
   nPrecMere NUMBER := 0;
   --
   CURSOR cMetrCons(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, nNumero FIC_CABEOTRE.NUMERO%TYPE, nFase NUMBER) IS
      SELECT M.MAQUCODI, SUM(DECODE(PA.CONTMATE,1,PA.CANTCONS,0)) CANTCON1, SUM(DECODE(PA.CONTMATE,2,PA.CANTCONS,0)) CANTCON2 
      FROM PRD_MAPAMAQU PA,
           (SELECT M.EMPRESA, M.NUMEOTRE, M.CONTADOR, M.MAQUCODI, M.FASESEQU FROM PRD_MAQURUTA M
            UNION
            SELECT M.EMPRESA, M.NUMEOTRE, M.CONTADOR, M.MAQUCODI, M.FASESEQU FROM PRD_HMAQURUT M) M
      WHERE PA.EMPRESA = M.EMPRESA
        AND PA.NUMEOTRE = M.NUMEOTRE
        AND PA.CONTADOR = M.CONTADOR
        AND M.EMPRESA = vEmpresa
        AND M.NUMEOTRE = nNumero
        AND M.FASESEQU BETWEEN nFase * 100 AND ((nFase + 1) * 100) - 1 --Apaño ya que los materiales no tienen la misma secuencia que las maquinas
                                                                       --Se entiende que no existiran 2 maquinas en la misma fase
        AND PA.MARCPASA = 'N'
      GROUP BY M.MAQUCODI;
   --
   rMetrCons cMetrCons%ROWTYPE;
   /*--LOGICA REAL DE METROS POR MATERIAL NO SE USA POR QUE NO SE VAN A CONSIDERAR DEBARBES
   CURSOR cENTMAAR01(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vVatCod FV_ENTMAAR01.VATCOD%TYPE, vArcarf FV_ENTMAAR01.ARCARF%TYPE) IS
      SELECT *
        FROM FV_ENTMAAR01
       WHERE EMCODI = vEmpresa
         AND VATCOD = vVatCod
         AND ARCARF = vArcarf;
   --
   rENTMAAR01   cENTMAAR01%ROWTYPE;*/
   --
   CURSOR cASMAAR01(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vVatCod FV_ENTMAAR01.VATCOD%TYPE, vArcarf FV_ENTMAAR01.ARCARF%TYPE) IS
      SELECT *
        FROM FV_ASMAAR01
       WHERE EMCODI = vEmpresa
         AND VATCOD = vVatCod
         AND ARCARF = vArcarf;
   --
   rASMAAR01 cASMAAR01%ROWTYPE;
   --Abonos de la OT
   CURSOR cAbonos(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, nNumero FIC_CABEOTRE.NUMERO%TYPE, nAnno FIC_CABEOTRE.ANNO%TYPE) IS
      SELECT SUM(IMPORTE) IMPORTE FROM
         (SELECT
               DECODE(RCL.TIPO_IMPRE, 'FLEXO', DECODE(RCL.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') TECNOLOGIA,
               SUM(F.LFIMPO) IMPORTE
          FROM FV_ASVEFA02 F, FV_ASVEFA01 CF,
               (SELECT DISTINCT R.EMPRESA, A.NUMEABON, TEC.TIPO_IMPRE, TEC.FILMAR
                FROM RCL_RECLCLIE R, RCL_ACCIONES A, HFICTEC HFT, FIC_CABEOTRE O,
                     (SELECT LSC.EMPRESA, LSC.NUMETRAB, LSC.TIPO_IMPRE, LSC.FILMAR FROM PRI_LISELCOL LSC
                      WHERE (LSC.EMPRESA, LSC.NUMETRAB, LSC.CONTADOR||LSC.POSICION) IN 
                            (SELECT LSCM.EMPRESA, LSCM.NUMETRAB, MAX(LSCM.CONTADOR||LSCM.POSICION) FROM PRI_LISELCOL LSCM
                             WHERE LSCM.EMPRESA = LSC.EMPRESA 
                               AND LSCM.NUMETRAB = LSC.NUMETRAB
                             GROUP BY LSCM.EMPRESA, LSCM.NUMETRAB)) TEC 
                WHERE A.EMPRESA = R.EMPRESA
                  AND A.NUMERCL = R.NUMERCL
                  AND A.ANNO = R.ANNO
                  AND HFT.EMPRESA = R.EMPRESA
                  AND HFT.NUMEPEDI = R.NUMEPEDI
                  AND HFT.EMPRESA = TEC.EMPRESA
                  AND HFT.NUMETRAB = TEC.NUMETRAB
                  AND O.EMPRESA = HFT.EMPRESA
                  AND O.TIP_ARTI = HFT.TIP_ARTI
                  AND O.COD_ARTI = HFT.PRODUCTO
                  AND O.MODI = HFT.MODI
                  AND O.REVI = HFT.REVI
                  AND A.NUMEABON IS NOT NULL
                  AND R.NUMEPEDI IS NOT NULL
                  AND HFT.NUMEPEDI IS NOT NULL
                  AND A.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                  AND A.TIPOACCI = P_UTILIDAD.F_VALODEVA('TIACABCA')
                  AND R.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                  AND O.EMPRESA = vEmpresa
                  AND O.NUMERO = nNumero
           			AND O.ANNO = nAnno
               ) RCL
          WHERE F.EMCODI = CF.EMCODI
             AND F.DICODI = CF.DICODI
             AND F.ASCANA = CF.ASCANA
             AND F.CFNROF = CF.CFNROF
             AND CF.EMCODI = RCL.EMPRESA
             AND CF.CFNDEF = RCL.NUMEABON
             AND F.VATCOD = P_UTILIDAD.F_VALODEVA('TIARGCF4')
             AND F.EMCODI = vEmpresa
             AND F.PPTIPO IN ('A','X')
          GROUP BY DECODE(RCL.TIPO_IMPRE, 'FLEXO', DECODE(RCL.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO')
         );
   --Pais del Cliente
   CURSOR cPais(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vClclie FV_ASMACL01.CLCLIE%TYPE) IS
      SELECT VPACOD FROM FV_ASMACL01
         WHERE EMCODI = vEmpresa
           AND CLCLIE = vClclie;
   --
   vVPacod FV_ASMACL01.VPACOD%TYPE;       
   --Tasa Seguro de Credito y Transporte
   CURSOR cANE_TASECRPA(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, vPais ANE_TASECRPA.PAIS%TYPE,
                        dFecha_Cierre DATE) IS
      SELECT TAANSCES FROM ANE_TASECRPA
         WHERE EMPRESA = vEmpresa
           AND ANNO = TO_CHAR(dFecha_Cierre,'YYYY')
           AND PAIS = vPais;
   --
   nTAANSCES ANE_TASECRPA.TAANSCES%TYPE;
   --% Reparto Costes Matriz
   CURSOR cANE_PORECOMA(vTipo ANE_PORECOMA.TIPO%TYPE,
                        dFecha_Cierre DATE) IS
      SELECT SUM(PORCSUR1) PORECMPH, SUM(PORCSUR2) PORECMMA
         FROM ANE_PORECOMA
            WHERE TIPO = vTipo
              AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                        'DICIEMBRE','12')) 
              AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                        'DICIEMBRE','12'));   
   --
   rANE_PORECOMA cANE_PORECOMA%ROWTYPE;
   --
   nReFiGest_E NUMBER;
   --Ingresos - Gastos ESTANDAR
   CURSOR cIngrGast_Estandar(vEmpresa ANE_CODEESAN.EMPRESA%TYPE,
                             dFecha_Cierre DATE) IS
      SELECT SUM(DECODE(C.GTO_INGRES,'I',-CE.ENERIMCU,'G',CE.ENERIMCU)) ENERIMCU,
             SUM(DECODE(C.GTO_INGRES,'I',-CE.FEBRIMCU,'G',CE.FEBRIMCU)) FEBRIMCU,
             SUM(DECODE(C.GTO_INGRES,'I',-CE.MARZIMCU,'G',CE.MARZIMCU)) MARZIMCU,
             SUM(DECODE(C.GTO_INGRES,'I',-CE.ABRIIMCU,'G',CE.ABRIIMCU)) ABRIIMCU,
             SUM(DECODE(C.GTO_INGRES,'I',-CE.MAYOIMCU,'G',CE.MAYOIMCU)) MAYOIMCU,
             SUM(DECODE(C.GTO_INGRES,'I',-CE.JUNIIMCU,'G',CE.JUNIIMCU)) JUNIIMCU,
             SUM(DECODE(C.GTO_INGRES,'I',-CE.JULIIMCU,'G',CE.JULIIMCU)) JULIIMCU,
             SUM(DECODE(C.GTO_INGRES,'I',-CE.AGOSIMCU,'G',CE.AGOSIMCU)) AGOSIMCU,
             SUM(DECODE(C.GTO_INGRES,'I',-CE.SEPTIMCU,'G',CE.SEPTIMCU)) SEPTIMCU,
             SUM(DECODE(C.GTO_INGRES,'I',-CE.OCTUIMCU,'G',CE.OCTUIMCU)) OCTUIMCU,
             SUM(DECODE(C.GTO_INGRES,'I',-CE.NOVIIMCU,'G',CE.NOVIIMCU)) NOVIIMCU,
             SUM(DECODE(C.GTO_INGRES,'I',-CE.DICIIMCU,'G',CE.DICIIMCU)) DICIIMCU
      FROM ANE_CODEESAN CE, FV_ASCGCO01 C, GNR_ESCCEMPR E
      WHERE CE.EMPRESA = C.EMCODI
        AND TRIM(CE.CUENCONT) = TRIM(C.CTCCTA)
        AND CE.EMPRESA = E.EMPRESA
        AND TRIM(CE.CUENCONT) = TRIM(E.CUENCONT)
        AND E.TIPOCOST = vP_TICOFINA
        AND CE.EMPRESA = vEmpresa
        AND CE.ANNO = TO_CHAR(dFecha_Cierre,'YYYY');   
   --
   rIngrGast_Estandar cIngrGast_Estandar%ROWTYPE;
   --
   nResuFina_E NUMBER;
   --
   nReFiGest_R NUMBER;
   --Ingresos - Gastos REAL
   CURSOR cIngrGast_Real(vEmpresa ANE_CODEREAN.EMPRESA%TYPE,
                         dFecha_Cierre DATE) IS
      SELECT SUM(DECODE(C.GTO_INGRES,'I',-CE.IMPOCUEN,'G',CE.IMPOCUEN)) IMPOCUEN
      FROM ANE_CODEREAN CE, FV_ASCGCO01 C, GNR_ESCCEMPR E
      WHERE CE.EMPRESA = C.EMCODI
        AND TRIM(CE.CUENCONT) = TRIM(C.CTCCTA)
        AND CE.EMPRESA = E.EMPRESA
        AND TRIM(CE.CUENCONT) = TRIM(E.CUENCONT)
        AND E.TIPOCOST = vP_TICOFINA
        AND CE.EMPRESA = vEmpresa
        AND CE.ANNO = TO_CHAR(dFecha_Cierre,'YYYY')
        AND CE.MES = DECODE(TO_CHAR(dFecha_Cierre,'MM'),'01','ENERO',
                                                        '02','FEBRERO',
                                                        '03','MARZO',
                                                        '04','ABRIL',
                                                        '05','MAYO',
                                                        '06','JUNIO',
                                                        '07','JULIO',
                                                        '08','AGOSTO',
                                                        '09','SEPTIEMBRE',
                                                        '10','OCTUBRE',
                                                        '11','NOVIEMBRE',
                                                        '12','DICIEMBRE');   
   --
   rIngrGast_Real cIngrGast_Real%ROWTYPE;
   --
   nResuFina_R NUMBER;
   --Facturacion Estandar
   CURSOR cPRD_CONFFAES(vEmpresa ANE_CODEREAN.EMPRESA%TYPE, dFecha_Cierre DATE) IS
      SELECT FACTENER,FACTFEBR,FACTMARZ,FACTABRI,FACTMAYO,FACTJUNI,FACTJULI,FACTAGOS,FACTSEPT,FACTOCTU,FACTNOVI,FACTDICI,FACTANUA 
      FROM PRD_CONFFAES
      WHERE EMPRESA = vEmpresa
        AND ANNO = TO_CHAR(dFecha_Cierre,'YYYY');   
   --
   rPRD_CONFFAES cPRD_CONFFAES%ROWTYPE;
   --Facturacion Real
   CURSOR cPRD_CONFFARE(vEmpresa ANE_CODEREAN.EMPRESA%TYPE, dFecha_Cierre DATE) IS
      SELECT FACTENER,FACTFEBR,FACTMARZ,FACTABRI,FACTMAYO,FACTJUNI,FACTJULI,FACTAGOS,FACTSEPT,FACTOCTU,FACTNOVI,FACTDICI,FACTANUA 
      FROM PRD_CONFFARE
      WHERE EMPRESA = vEmpresa
        AND ANNO = TO_CHAR(dFecha_Cierre,'YYYY');   
   --
   rPRD_CONFFARE cPRD_CONFFARE%ROWTYPE;
   --
   nFacturacion_E NUMBER;
   nFacturacion_R NUMBER;
   nPOCFOTIN_E NUMBER;
   nPOCFOTIN_R NUMBER;
   nVaOpInve_E NUMBER;
   nVaOpInve_R NUMBER;
   --Vencimiento del Cliente
   CURSOR cVencimiento(vEmpresa ANE_CODEREAN.EMPRESA%TYPE, vClclie FV_ASMACL01.CLCLIE%TYPE) IS
      SELECT FC.MCPLAZ, FC.MCPVTO, FC.MCLVTO
      FROM FV_ASMACL05 FC, FV_ASMACL01 C
      WHERE C.EMCODI = FC.EMCODI
        AND C.CLCLIE = FC.CLCLIE
        AND C.MCGCOD = FC.MCGCOD
        --AND FC.MCFODI IN ('D','I')--Dias y Dias de Fin de Mes (SE ASUME QUE SIEMPRE ES DIAS AQUI EN ENTECO
        AND C.EMCODI = vEmpresa 
        AND C.CLCLIE = vClclie;
   --
   rVencimiento cVencimiento%ROWTYPE;
   --
   nVencimiento NUMBER;
   --
   nVaOpCirc_E NUMBER;
   nVaOpCirc_R NUMBER;
   --Datos para Operaciones de Circulante
   CURSOR cOperCirc(vTipo ANE_DATOOPCI.TIPO%TYPE,
                    dFecha_Cierre DATE) IS
      SELECT SUM(PORCENTA) PORCENTA FROM ANE_DATOOPCI
         WHERE ANNO = TO_CHAR(dFecha_Cierre,'YYYY')
           AND MES = DECODE(TO_CHAR(dFecha_Cierre,'MM'),'01','ENERO',
                                                        '02','FEBRERO',
                                                        '03','MARZO',
                                                        '04','ABRIL',
                                                        '05','MAYO',
                                                        '06','JUNIO',
                                                        '07','JULIO',
                                                        '08','AGOSTO',
                                                        '09','SEPTIEMBRE',
                                                        '10','OCTUBRE',
                                                        '11','NOVIEMBRE',
                                                        '12','DICIEMBRE')
           AND TIPO = vTipo;  
   --
   nOperCirc_E NUMBER;
   nOperCirc_R NUMBER;
   --Estructura de Materiales de la OT
   --
   nNivel NUMBER := 1;
   bError BOOLEAN := FALSE;
   nNumeMate NUMBER := 0;
   nFaseSecu NUMBER;
   nFaSeUlti NUMBER;
   nNumeMaFS NUMBER := 0;
   nCantCeMP NUMBER;
   nPrecReFS NUMBER := 0;--Acumula el Precio Real de la Fase Secuencia
   --
   nCF_TINTAS NUMBER;
   nCF_SUM_DEPARTAM NUMBER;
   nCF_SUM_DEPARTAM_E NUMBER;
   nCF_GRABADOS NUMBER;
   nCF_CALCULOS NUMBER;
   --
   vCF_MINUTOS_REAL_HORAS_TI VARCHAR2(10) := '00';
   vCP_MINUTOS_REAL_MINUTOS_TI VARCHAR2(10) := '00';
   nCF_CANTIPROD_TI NUMBER := 0;
   nCF_VELOCIDAD_ESTANDAR_TI NUMBER := 0;
   nCF_MINUTOS_ESTANDAR_TI NUMBER := 0;
   nCP_MINUTOS_ESTANDAR_HORAS_TI NUMBER := '00';
   nCP_MIN_ESTANDAR_MINUTOS_TI NUMBER := '00';
   nCF_DESVIACION_TIE_TI NUMBER := 0;
   vCP_DESVIACION_TIE_HORAS_TI VARCHAR2(10) := '00';
   vCP_DESVIACION_TIE_MINUTOS_TI VARCHAR2(10) := '00';
   nNumeOtua NUMBER := 0;
   nCostOtim NUMBER := 0;
   nCP_COSTTOTA_TI NUMBER := 0;
   nCP_HORATOTA_TI NUMBER := 0;
   nCP_COSTHORA_TI NUMBER := 0;
   nCP_COSTTORE_TI NUMBER := 0;
   nCP_HORATORE_TI NUMBER := 0;
   nCP_COSTHORE_TI NUMBER := 0;
   nCF_COSTE_TOTAL_ESTANDAR_TI NUMBER := 0;
   nCF_COSTE_TOTAL_REAL_TI NUMBER := 0;
   nCF_DESVIACION_COSTE_TOTAL_TI NUMBER := 0;
   nCF_DESGLOSE_COSTE_HORA_TI NUMBER := 0;
   nCF_DESGLOSE_VELOCIDAD_TI NUMBER := 0;
   nCP_COSTHORA_SEC_TI NUMBER := 0;
   nCP_COSTHORE_SEC_TI NUMBER := 0;
--VAR TIEMPOS--
   nCS_MINUTOS_REAL_OT NUMBER := 0;
   nCS_MINUTOS_ESTANDAR_OT NUMBER := 0;
   nCS_CP_COSTHORA_OT NUMBER := 0;
   nCS_CP_COSTHORE_OT NUMBER := 0;
   nCS_CF_COSTE_TOTAL_ESTANDAR_TI NUMBER := 0;
   nCS_CF_COSTE_TOTAL_REAL_TI NUMBER := 0;
   nCS_CF_DESV_COSTE_TOTAL_T NUMBER := 0;
   nCS_CF_DESGLOSE_COSTE_HORA_TI NUMBER := 0;
   nCS_CF_DESGLOSE_VELOCIDAD_TI NUMBER := 0;
   --
   vCF_MINUTOS_REAL_HORAS_OT VARCHAR2(10) := '00';
   vCP_MINUTOS_REAL_MINUTOS_OT VARCHAR2(10) := '00';
   vCP_MINUTOS_ESTANDAR_HORAS_OT VARCHAR2(10) := '00';
   vCP_MIN_ESTANDAR_MINUTOS_OT VARCHAR2(10) := '00';
   nCS_DESVIACION_TIE_OT NUMBER := 0;
   vCP_DESVIACION_TIE_HORAS_OT VARCHAR2(10) := '00';
   vCP_DESVIACION_TIE_MINUTOS_OT VARCHAR2(10) := '00';
   --
   CURSOR cTiempos(vEmpresa  FIC_CABEOTRE.EMPRESA%TYPE,  nNumero FIC_CABEOTRE.NUMERO%TYPE) IS
      --Solo Niveles 2 y 3 Preparación y Producción
      SELECT F.EMPRESA ID_EMPRESA_TI, TO_NUMBER(F.NUMEOTRE) ID_ORDEN_TRABAJO_TI,TRIM(SUBSTR(F.MAQUCODI,1,INSTR(F.MAQUCODI,' '))) ID_MAQUINA_TI, SUM(F.MINUFINA-F.MINUINIC) MINUTOS_REAL_TI
            FROM PRD_PRMAEVEN F, PRD_EVENTOS E
            WHERE F.EMPRESA = E.EMPRESA
              AND F.EVENTIPO = E.EVENTIPO
              AND F.EVENCODI = E.EVENCODI
              AND INSTR(E.EVENCATE,'.') != 0
              AND SUBSTR(E.EVENCATE,1,INSTR(E.EVENCATE,'.') -1) IN ('2','3')
              AND F.MINUFINA IS NOT NULL
              AND F.EMPRESA = vEmpresa
              AND F.NUMEOTRE = nNumero
      GROUP BY F.EMPRESA, F.NUMEOTRE,TRIM(SUBSTR(F.MAQUCODI,1,INSTR(F.MAQUCODI,' ')))
      UNION 
      SELECT vEmpresa ID_EMPRESA_TI, TO_NUMBER(nNumero) ID_ORDEN_TRABAJO_TI,'MONTAJE' ID_MAQUINA_TI, 0 MINUTOS_REAL_TI
            FROM DUAL F
            WHERE EXISTS (SELECT 'X' FROM PRD_PRMAEVEN E WHERE E.EMPRESA = vEmpresa AND E.NUMEOTRE = nNumero AND TRIM(SUBSTR(E.MAQUCODI,1,INSTR(E.MAQUCODI,' '))) = 'IMPRESORA');
   --
   nCF_VELOCIDAD_REAL_ML NUMBER := 0;
   nCF_VELOCIDAD_ESTANDAR_ML NUMBER := 0;
   nCF_DESVIACION_VEL_ML NUMBER := 0;
   --Calculo de Tiempo Nivel 3 para Vel. de Tirada
   CURSOR cEventos(vEmpresa  FIC_CABEOTRE.EMPRESA%TYPE,  nNumero FIC_CABEOTRE.NUMERO%TYPE, vMaquCodi PRD_PRMAEVEN.MAQUCODI%TYPE) IS
      SELECT SUM(F.MINUFINA-F.MINUINIC) MINUTOS
      FROM PRD_PRMAEVEN F, PRD_EVENTOS E
         WHERE F.EMPRESA = E.EMPRESA
           AND F.EVENTIPO = E.EVENTIPO
           AND F.EVENCODI = E.EVENCODI
           AND INSTR(E.EVENCATE,'.') != 0
           AND SUBSTR(E.EVENCATE,1,INSTR(E.EVENCATE,'.') -1) = '3'
           AND F.MINUFINA IS NOT NULL
           AND F.EMPRESA = vEmpresa
           AND F.NUMEOTRE = nNumero
           AND TRIM(SUBSTR(F.MAQUCODI,1,INSTR(F.MAQUCODI,' '))) = vMaquCodi;
   --
   nEventos NUMBER;
   --
   CURSOR cPRD_CAVAESAR(vEmpresa  FIC_CABEOTRE.EMPRESA%TYPE, vTip_Arti PRD_CAVAESAR.TIP_ARTI%TYPE, vCod_Arti PRD_CAVAESAR.COD_ARTI%TYPE, vMaquCodi PRD_PRMAEVEN.MAQUCODI%TYPE) IS
      SELECT VEPRESDE FROM PRD_CAVAESAR
         WHERE EMPRESA = vEmpresa
           AND TIP_ARTI = vTip_Arti
           AND COD_ARTI = vCod_Arti
           AND TIPOMAQU = vMaquCodi;
   --
   nPRD_CAVAESAR NUMBER;
   --
   CURSOR cVelocidad(vEmpresa  FIC_CABEOTRE.EMPRESA%TYPE,  nNumero FIC_CABEOTRE.NUMERO%TYPE) IS
      SELECT P.EMPRESA ID_EMPRESA_ML, P.NUMEOTRE ID_ORDEN_TRABAJO_ML , TRIM(SUBSTR(P.MAQUCODI,1,INSTR(P.MAQUCODI,' ')))  ID_MAQUINA_ML, 
             DECODE(TRIM(SUBSTR(P.MAQUCODI,1,INSTR(P.MAQUCODI,' '))),'CORTADORA',SUM(DECODE(MARCPASA,'S',0,P.CANTPROD)),SUM(P.CANTPROD)) CANTPROD_ML
         FROM PRD_PASAMAQU P
         WHERE P.EMPRESA = vEmpresa
           AND P.NUMEOTRE = nNumero
         GROUP BY P.EMPRESA, P.NUMEOTRE, SUBSTR(P.MAQUCODI,1,INSTR(P.MAQUCODI,' '))
         ORDER BY TO_NUMBER(DECODE(TRIM(SUBSTR(P.MAQUCODI,1,INSTR(P.MAQUCODI,' '))),'IMPRESORA','1','LAMINADORA','2','LAQUEADORA','3','CORTADORA','4','MONTAJE','5','6'));
   --
   CURSOR cPasadas(vEmpresa PRD_PASAMAQU.EMPRESA%TYPE, nNumeOtre PRD_PASAMAQU.NUMEOTRE%TYPE, vMaquCodi PRD_PASAMAQU.MAQUCODI%TYPE) IS
      SELECT SUM(P.CANTPROD) CANTPROD
      FROM PRD_PASAMAQU P
         WHERE P.EMPRESA = vEmpresa
           AND P.NUMEOTRE = nNumeOTre
           AND TRIM(SUBSTR(P.MAQUCODI,1,INSTR(P.MAQUCODI,' '))) = vMaquCodi;
   --
   nCS_COSTDIRE_HORAPROD NUMBER := 0;
   nCS_COSTINDI_HORAPROD NUMBER := 0;
   nCS_NUMEHORA_HORAPROD NUMBER := 0;
   nCF_TOTACOPE_HORAPROD NUMBER := 0;
   nCP_COSTHORA_HORAPROD NUMBER := 0;
   --
   CURSOR Q_ANNOS_HORAPROD (dFecha_Cierre DATE) IS
      SELECT DISTINCT A.ANNO FROM ANE_CODEANNO A
         WHERE EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = A.EMPRESA)
           AND A.ANNO =   TO_CHAR(dFecha_Cierre,'YYYY')
         ORDER BY A.ANNO;
   --
   CURSOR Q_COSTDIRE_HORAPROD(vEmpresa ANE_CODEREAN.EMPRESA%TYPE, dFecha_Cierre DATE, nAnno ANE_CONFCPDR.ANNO%TYPE) IS
      SELECT ANNO, SUM(COSTE) COSTE FROM (
      --------------Costes Directos
      SELECT CP.ANNO, SUM(CP.COSTE) COSTE 
      FROM ANE_CONFCPDR CP, GNR_SPDEEMPR SPDE
      WHERE CP.SECCION = SPDE.SECCION
        AND CP.EMPRESA = vEmpresa
        AND CP.ANNO = nAnno
        AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(nAnno||DECODE(CP.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12')) 
        AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(nAnno||DECODE(CP.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12'))
        AND SPDE.DEPARTAM = vP_CODEPREI
      GROUP BY CP.ANNO
      --------------Restos de Costes Directos
      UNION ALL
      SELECT CP.ANNO, SUM(CP.COSTE) COSTE 
      FROM ANE_CONFRCDR CP, GNR_SPDEEMPR SPDE
      WHERE CP.SECCION = SPDE.SECCION
        AND CP.EMPRESA = vEmpresa
        AND CP.ANNO = nAnno
        AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(nAnno||DECODE(CP.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12')) 
        AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(nAnno||DECODE(CP.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12'))
        AND SPDE.DEPARTAM = vP_CODEPREI
      GROUP BY CP.ANNO
      )
      GROUP BY ANNO;
   --
   CURSOR Q_COSTINDI_HORAPROD(vEmpresa ANE_CODEREAN.EMPRESA%TYPE, dFecha_Cierre DATE, nAnno ANE_CONFCPDR.ANNO%TYPE) IS
      SELECT ANNO, SUM(COSTE) COSTE FROM (
      SELECT PER.ANNO, IND.COSTINDI * PER.NUMEPERS COSTE
      FROM
            (SELECT C.EMPRESA, C.ANNO, SUM(C.COSTE / I.NUMEPERS) COSTINDI 
               FROM PRD_CONFCOIR C, VALORES_LISTA L, PRD_CONFINRE I
            WHERE C.CONCEPTO = P_UTILIDAD.F_VALOCAMPO(L.VALOR,'CONCEPTO')
              AND C.EMPRESA = I.EMPRESA
              AND C.ANNO = I.ANNO
              AND C.MES = I.MES
              AND P_UTILIDAD.F_VALOCAMPO(L.VALOR,'INDUCTOR') = I.INDUCTOR
              AND L.CODIGO = 'PRD_COPRASIN'
              AND I.INDUCTOR != vP_INDUPEUN --PERSONAL UNIFORMADO
              AND NVL(I.NUMEPERS,0) != 0
              AND C.EMPRESA = vEmpresa
              AND C.ANNO = nAnno
              AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(nAnno||DECODE(C.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12')) 
              AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(nAnno||DECODE(C.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12'))
            GROUP BY C.EMPRESA, C.ANNO) IND,
            (SELECT PL.EMPRESA, PL.ANNO, PL.NUMEPERS
             FROM ANE_CONFPMSR PL, GNR_SPDEEMPR SPDE
             WHERE PL.SECCION = SPDE.SECCION
               AND SPDE.DEPARTAM = vP_CODEPREI
               AND PL.EMPRESA = vEmpresa
               AND PL.ANNO = nAnno
               AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(nAnno||DECODE(PL.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12')) 
              AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(nAnno||DECODE(PL.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12'))) PER
      WHERE PER.EMPRESA = IND.EMPRESA
        AND PER.ANNO = IND.ANNO
      --------------Costes Indirectos Departamentales Inductor igual a Personal Uniformado
      UNION ALL
      SELECT PER.ANNO, IND.COSTINDI * PER.NUMEPEUN COSTE
      FROM
            (SELECT C.EMPRESA, C.ANNO, SUM(C.COSTE / I.NUMEPERS) COSTINDI 
               FROM PRD_CONFCOIR C, VALORES_LISTA L, PRD_CONFINRE I
            WHERE C.CONCEPTO = P_UTILIDAD.F_VALOCAMPO(L.VALOR,'CONCEPTO')
              AND C.EMPRESA = I.EMPRESA
              AND C.ANNO = I.ANNO
              AND C.MES = I.MES
              AND P_UTILIDAD.F_VALOCAMPO(L.VALOR,'INDUCTOR') = I.INDUCTOR
              AND L.CODIGO = 'PRD_COPRASIN'
              AND I.INDUCTOR = vP_INDUPEUN --PERSONAL UNIFORMADO
              AND NVL(I.NUMEPERS,0) != 0
              AND C.EMPRESA = vEmpresa
              AND C.ANNO = nAnno
              AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(nAnno||DECODE(C.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12')) 
              AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(nAnno||DECODE(C.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12'))
            GROUP BY C.EMPRESA, C.ANNO) IND,
            (SELECT PL.EMPRESA, PL.ANNO, PL.NUMEPEUN
             FROM ANE_CONFPMSR PL, GNR_SPDEEMPR SPDE
             WHERE PL.SECCION = SPDE.SECCION
               AND SPDE.DEPARTAM = vP_CODEPREI
               AND PL.EMPRESA = vEmpresa
               AND PL.ANNO = nAnno
               AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(nAnno||DECODE(PL.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12')) 
               AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(nAnno||DECODE(PL.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12'))) PER
      WHERE PER.EMPRESA = IND.EMPRESA
        AND PER.ANNO = IND.ANNO
      )
      GROUP BY ANNO;
   --
   CURSOR Q_NUMEHORA_HORAPROD(vEmpresa ANE_CODEREAN.EMPRESA%TYPE, dFecha_Cierre DATE) IS
      SELECT SUM(HOREEFCO+UNGRREAL) NUMEHORA, SUM(HORECONV) HORECONV
      FROM ANE_CODEANMS
      WHERE EMPRESA = vEmpresa
        AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01', 
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
                                                                             'DICIEMBRE','12')) 
        AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                             'DICIEMBRE','12'));
   --
   PROCEDURE P_ERRORES(vMensaje VARCHAR2) IS
   BEGIN
      IF rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS IS NULL OR (rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS IS NOT NULL AND LENGTH(rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS) < 1900) THEN
         IF rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS IS NULL THEN
            rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS := 'ERRORES ENCONTRADOS:'||CHR(10)||CHR(10)||vMensaje;
         ELSE                     
            rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS := rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS||CHR(10)||vMensaje;
         END IF;
      ELSE
         rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS := 'FALLO';
      END IF;
   END;
   --
   PROCEDURE P_Materiales(vEmpresa  FIC_CABEOTRE.EMPRESA%TYPE,  nNumero FIC_CABEOTRE.NUMERO%TYPE,   
                          nNumeOtte FIC_CABEOTRE.NUMEOTTE%TYPE, nAnnoOtte FIC_CABEOTRE.ANNOOTTE%TYPE,
                          vTip_Arti FIC_CABEOTRE.TIP_ARTI%TYPE, vCod_Arti FIC_CABEOTRE.COD_ARTI%TYPE,
                          dFecha_Cierre DATE) IS
      CURSOR cEstructura IS --Nivel 1
         SELECT LE.TIP_ARES, LE.COD_ARES, LE.FASE, LE.SECUENCI
         FROM FIC_CABEEOTT CE, FIC_LINEEOTT LE
            WHERE CE.EMPRESA = LE.EMPRESA
              AND CE.NUMERO = LE.NUMERO
              AND CE.ANNO = LE.ANNO
              AND CE.TIP_ARTI = LE.TIP_ARTI
              AND CE.COD_ARTI = LE.COD_ARTI
              AND CE.NUMEESTR = LE.NUMEESTR
              AND CE.EMPRESA = vEmpresa  
              AND CE.NUMERO = nNumeOtte
              AND CE.ANNO = nAnnoOtte
              AND CE.TIP_ARTI = vTip_Arti 
              AND CE.COD_ARTI = vCod_Arti
              AND CE.ESTRDEFI = 'S'
              AND LE.TIPO = 'M'
         UNION
         SELECT LE.TIP_ARES, LE.COD_ARES, LE.FASE, LE.SECUENCI
         FROM FIC_CAESEOTT CE, FIC_LIESEOTT LE
            WHERE CE.EMPRESA = LE.EMPRESA
              AND CE.NUMERO = LE.NUMERO
              AND CE.ANNO = LE.ANNO
              AND CE.TIP_ARTI = LE.TIP_ARTI
              AND CE.COD_ARTI = LE.COD_ARTI
              AND CE.NUMEESTR = LE.NUMEESTR
              AND CE.EMPRESA = vEmpresa  
              AND CE.NUMERO = nNumeOtte
              AND CE.ANNO = nAnnoOtte
              AND CE.TIP_ARTI = vTip_Arti 
              AND CE.COD_ARTI = vCod_Arti
              AND CE.ESTRDEFI = 'S'
              AND LE.TIPO = 'M'
        ORDER BY FASE, SECUENCI;
      --
      PROCEDURE P_RECURSIVO_MATERIALES(vTip_Arti FIC_LINEEOTT.TIP_ARES%TYPE, vCod_Arti FIC_LINEEOTT.COD_ARES%TYPE) IS
         CURSOR cEstructura_Niv IS --Niveles
            SELECT LE.TIP_ARES, LE.COD_ARES, LE.FASE , LE.SECUENCI
            FROM FIC_CABEEOTT CE, FIC_LINEEOTT LE
               WHERE CE.EMPRESA = LE.EMPRESA
                 AND CE.NUMERO = LE.NUMERO
                 AND CE.ANNO = LE.ANNO
                 AND CE.TIP_ARTI = LE.TIP_ARTI
                 AND CE.COD_ARTI = LE.COD_ARTI
                 AND CE.NUMEESTR = LE.NUMEESTR
                 AND CE.EMPRESA = vEmpresa  
                 AND CE.NUMERO = nNumeOtte
                 AND CE.ANNO = nAnnoOtte
                 AND CE.TIP_ARTI = vTip_Arti 
                 AND CE.COD_ARTI = vCod_Arti
                 AND CE.ESTRDEFI = 'S'
            UNION
            SELECT LE.TIP_ARES, LE.COD_ARES, LE.FASE , LE.SECUENCI
            FROM FIC_CAESEOTT CE, FIC_LIESEOTT LE
               WHERE CE.EMPRESA = LE.EMPRESA
                 AND CE.NUMERO = LE.NUMERO
                 AND CE.ANNO = LE.ANNO
                 AND CE.TIP_ARTI = LE.TIP_ARTI
                 AND CE.COD_ARTI = LE.COD_ARTI
                 AND CE.NUMEESTR = LE.NUMEESTR
                 AND CE.EMPRESA = vEmpresa  
                 AND CE.NUMERO = nNumeOtte
                 AND CE.ANNO = nAnnoOtte
                 AND CE.TIP_ARTI = vTip_Arti 
                 AND CE.COD_ARTI = vCod_Arti
                 AND CE.ESTRDEFI = 'S'
           ORDER BY FASE, SECUENCI;
      BEGIN
         FOR rEstructura_Niv IN cEstructura_Niv LOOP
            --Busqueda del Precio de la MP de la Estructura
            IF rEstructura_Niv.Tip_Ares = vP_TiarMPF4 THEN
               --Se acumulan valores
               --Contador de Numero de Materiales
               nNumeMate := nNumeMate + 1;
               --Contador de Numero de Materiales en Fase Secuencia
               nNumeMaFS := nNumeMaFS + 1;
               --Calculo de Unidad de Logistica para los materiales
               OPEN cASMAAR01(vEmpresa, rEstructura_Niv.Tip_Ares, rEstructura_Niv.Cod_Ares);
               FETCH cASMAAR01 INTO rASMAAR01;
               CLOSE cASMAAR01;
               /*--LOGICA REAL DE METROS POR MATERIAL NO SE USA POR QUE NO SE VAN A CONSIDERAR DEBARBES
               OPEN cENTMAAR01(rEstructura_Niv.Tip_Ares, rEstructura_Niv.Cod_Ares);
               FETCH cENTMAAR01 INTO rENTMAAR01;
               CLOSE cENTMAAR01;  
               */
               --Se calcula el factor de logistica de produccion para la MP
               nFactorULMP := 0;
               --
               BEGIN
                  --Se pasa las Unidades Cerradas a la unidad del Precio
                  nFactorULMP := P_Articulo.F_Factor (vEmpresa,vMatBase,
                                                      nCP_Ancho_MM, NULL,
                                                      vP_TipoUnML,rASMAAR01.VUCCOD);
               EXCEPTION 
                  WHEN OTHERS THEN
                     nFactorULMP := 0;
                     bError := TRUE;
                     P_ERRORES('1- No se puede calcular FC de '||vP_TipoUnML||'->'||rASMAAR01.VUCCOD||' para la MP: '||rEstructura_Niv.Tip_Ares||'-'||rEstructura_Niv.Cod_Ares);
               END;
               --
               IF NVL(nFactorULMP,0) != 0 THEN
                  --Cantidad Cerrada de MP en Unidades de Logistica
                  nCantCeMP := NVL(nCP_CantCerr_ML_PROD,0) * (1 / nFactorULMP);
               ELSE
                  nCantCeMP := 0;
                  P_ERRORES('2- (No existe FC) No se puede calcular Cantidad Cerrada de MP en Unidades de Logistica para la MP: '||rEstructura_Niv.Tip_Ares||'-'||rEstructura_Niv.Cod_Ares);
               END IF;
               --Precios Estandar de Materias Primas
               rANE_PRECMAPR.UNIDAD := NULL;
               --
               OPEN cANE_PRECMAPR(vEmpresa, rEstructura_Niv.Tip_Ares, rEstructura_Niv.Cod_Ares,dFecha_Cierre);
               FETCH cANE_PRECMAPR INTO rANE_PRECMAPR;
               CLOSE cANE_PRECMAPR;
               --
               IF rANE_PRECMAPR.UNIDAD IS NOT NULL THEN
                  nFactorUP := 0;
                  --
                  BEGIN
                     --Se pasa las Unidades Cerradas a la unidad del Precio
                     nFactorUP := P_Articulo.F_Factor (vEmpresa,vMatBase,
                                                       nCP_Ancho_MM, NULL,
                                                       rASMAAR01.VUCCOD,rANE_PRECMAPR.UNIDAD);
                  EXCEPTION 
                     WHEN OTHERS THEN
                        nFactorUP := 0;
                        bError := TRUE;
                        P_ERRORES('3- No se puede calcular FC de '||rASMAAR01.VUCCOD||'->'||rANE_PRECMAPR.UNIDAD||' para la MP: '||rEstructura_Niv.Tip_Ares||'-'||rEstructura_Niv.Cod_Ares);
                  END;
                  --
                  IF NVL(nFactorUP,0) != 0 THEN
                     IF NVL(rANE_PRECMAPR.CANTIDAD,0) != 0 THEN
                         --Ingreso Neto Estandar de Consumo de Lamina (Cantidad cerrada en Unidad de Precios Estandar *  Precio Medio)
                         nCP_COLAESTA := NVL(nCP_COLAESTA,0) + ((NVL(nCantCeMP,0) * (1 / nFactorUP)) * (rANE_PRECMAPR.PRECIO / rANE_PRECMAPR.CANTIDAD));
                     ELSE
                        P_ERRORES('4- (No existe Cantidad) No se puede calcular Ingreso Neto Estandar de Consumo de Lamina para la MP: '||rEstructura_Niv.Tip_Ares||'-'||rEstructura_Niv.Cod_Ares);
                     END IF;
                  ELSE
                     P_ERRORES('5- (No existe FC) No se puede calcular Ingreso Neto Estandar de Consumo de Lamina para la MP: '||rEstructura_Niv.Tip_Ares||'-'||rEstructura_Niv.Cod_Ares
                     ||CHR(10)||
                     'LFS :'||vMatBase||', Ancho :'||nCP_Ancho_MM||', Unidadades :'||rASMAAR01.VUCCOD||'->'||rANE_PRECMAPR.UNIDAD);
                  END IF;
               ELSE
                  P_ERRORES('6- No existen Precios de MP para: '||rEstructura_Niv.Tip_Ares||'-'||rEstructura_Niv.Cod_Ares);
               END IF;
               --Precios Reales de Materias Primas
               nPrecMere := NULL;
               nCantPrme := 0;
               nPrecPrme := 0;
               --
               FOR rExisPeri IN cExisPeri(vEmpresa, rEstructura_Niv.Tip_Ares, rEstructura_Niv.Cod_Ares,
                                          dFecha_Cierre) LOOP
                  nPrecComp := NULL;
                  --Se busca la compra para el preci
                  OPEN cCompras(vEmpresa, rEstructura_Niv.Tip_Ares, rEstructura_Niv.Cod_Ares, rExisPeri.ASLOTE);
                  FETCH cCompras INTO nPrecComp;
                  CLOSE cCompras;
                  --
                  IF NVL(nPrecComp,0) != 0 THEN
                     nCantPrme := nCantPrme + rExisPeri.AHCANT; --Acumula la cantidad
                     nPrecPrme := nPrecPrme + (rExisPeri.AHCANT * nPrecComp); --Acumula el Precio
                  END IF;
               END LOOP;
               --
               IF nCantPrme != 0 THEN
                  nPrecMere := nPrecPrme / nCantPrme;
               ELSE
                  nPrecMere := 0;
               END IF;   
               --
               IF nPrecMere = 0 THEN
                  rUltiCompr.ALCANT := NULL;
                  --
                  OPEN cUltiCompr(vEmpresa, rEstructura_Niv.Tip_Ares, rEstructura_Niv.Cod_Ares);
                  FETCH cUltiCompr INTO rUltiCompr;--PRECIO MEDIO REAL
                  CLOSE cUltiCompr;
                  --(ALCAEQ * ALPREU) / ALCANT, ALUNST, ALUNCO
                  IF NVL(rUltiCompr.ALCANT,0) != 0 THEN
                     IF rUltiCompr.ALUNST = rASMAAR01.VUCCOD THEN
                        nPrecMere := (rUltiCompr.ALCAEQ * rUltiCompr.ALPREU) / rUltiCompr.ALCANT;
                     ELSE
                        nPrecMere := 0;
                        P_ERRORES('7.1- No se puede establecer el precio para la MP: '||rEstructura_Niv.Tip_Ares||'-'||rEstructura_Niv.Cod_Ares);
                     END IF;
                  ELSE
                     nPrecMere := 0;
                     P_ERRORES('7.2- No se puede establecer el precio para la MP: '||rEstructura_Niv.Tip_Ares||'-'||rEstructura_Niv.Cod_Ares);
                  END IF;
               END IF;
               --Acumula el Precio Real de la Fase Secuencia
               nPrecReFS := nPrecReFS + NVL(nPrecMere,0);
               --
               IF nPrecMere != 0 THEN
                  --Ingreso Neto Real de Consumo de Lamina (Cantidad cerrada *  Precio Medio)
                  nCP_COLAREAL := NVL(nCP_COLAREAL,0) + (NVL(nCantCeMP,0) * nPrecMere);
               ELSE
                  nCP_COLAREAL := 0;
                  P_ERRORES('8- (No existe precio para la MP) No se puede calcular Ingreso Neto Real de Consumo de Lamina para la MP: '||rEstructura_Niv.Tip_Ares||'-'||rEstructura_Niv.Cod_Ares);
               END IF;
            ELSE
               P_RECURSIVO_MATERIALES(rEstructura_Niv.Tip_Ares, rEstructura_Niv.Cod_Ares);
            END IF;
         END LOOP;
      END;
   BEGIN
      nNumeMate := 0;
      --
      nNumeMaFS := 0;
      nPrecReFS := 0;
      --
      FOR rEstructura IN cEstructura LOOP --Se recorren los niveles 1
         --Si ya ha ejecutado un bucle por lo menos  y tambien verifica un cambio de Fase
         IF nFaSeUlti IS NOT NULL AND nFaSeUlti != rEstructura.Fase THEN
            rMetrCons.MAQUCODI := NULL;
            --Se busca la cantidad consumida en la Fase Secuencia
            OPEN cMetrCons(vEmpresa, nNumero, nFaSeUlti);
            FETCH cMetrCons INTO rMetrCons;
            CLOSE cMetrCons;
            --
            IF rMetrCons.MAQUCODI IS NOT NULL THEN
                 --Calculo de la Merma de Material
               IF INSTR(rMetrCons.MAQUCODI,'LAMINADORA') != 0 OR INSTR(rMetrCons.MAQUCODI,'LAQUEADORA') != 0 THEN
                   IF nNumeMaFS = 1 THEN --Esto es cuando se lamina con un material de otra fase
                      nCP_MALACRML := NVL(nCP_MALACRML,0) + (rMetrCons.CANTCON1 * nCP_N_Veces);
                      nCP_MALAMRML := NVL(nCP_MALAMRML,0) + ((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML);
                      IF NVL(nFactorM2,0) != 0 THEN
                         nCP_COMTREAL := NVL(nCP_COMTREAL,0) + ((((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) / nFactorM2) * nPrecReFS);
                      ELSE
                        P_ERRORES('9- (No existe FC) No se puede acumular Merma Total Real para la MP en la Fase: '||nFaSeUlti);
                      END IF;
                   ELSIF MOD(nNumeMaFS,2) = 0 THEN --Si el numero de materiales es par se reparten por iguales en los consumos
                     nCP_MALACRML := NVL(nCP_MALACRML,0) + ((rMetrCons.CANTCON1 * nCP_N_Veces) * (nNumeMaFS / 2)) + ((rMetrCons.CANTCON2 * nCP_N_Veces) * (nNumeMaFS / 2));
                     nCP_MALAMRML := NVL(nCP_MALAMRML,0) + (((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS / 2)) + (((rMetrCons.CANTCON2 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS / 2));
                     IF NVL(nFactorM2,0) != 0 THEN
                        nCP_COMTREAL := NVL(nCP_COMTREAL,0) + 
                                        (
                                         (
                                          (
                                           ((((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS / 2)) 
                                           + 
                                           (((rMetrCons.CANTCON2 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS / 2))
                                           ) / nFactorM2
                                          ) * nPrecReFS
                                         ) / nNumeMaFS
                                        );
                     ELSE
                        P_ERRORES('10- (No existe FC) No se puede acumular Merma Total Real para la MP en la Fase: '||nFaSeUlti);
                     END IF;
                  ELSIF MOD(nNumeMaFS,2) != 0 THEN--Si el numero de materiales es impar se reparten de forma desigual en los consumos
                     nCP_MALACRML := NVL(nCP_MALACRML,0) + ((rMetrCons.CANTCON1 * nCP_N_Veces) * TRUNC(nNumeMaFS / 2)) + ((rMetrCons.CANTCON2 * nCP_N_Veces) * (nNumeMaFS - TRUNC(nNumeMaFS / 2)));
                     nCP_MALAMRML := NVL(nCP_MALAMRML,0) + (((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * TRUNC(nNumeMaFS / 2)) + (((rMetrCons.CANTCON2 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS - TRUNC(nNumeMaFS / 2)));
                     --
                     IF NVL(nFactorM2,0) != 0 THEN
                        nCP_COMTREAL := NVL(nCP_COMTREAL,0) + 
                                        (
                                         (
                                          (
                                           ((((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * TRUNC(nNumeMaFS / 2)) 
                                           +(((rMetrCons.CANTCON2 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS - TRUNC(nNumeMaFS / 2)))
                                           ) / nFactorM2
                                          ) * nPrecReFS
                                         ) / nNumeMaFS
                                        ); 
                     ELSE
                        P_ERRORES('11- (No existe FC) No se puede acumular Merma Total Real para la MP en la Fase: '||nFaSeUlti);
                     END IF;
                  END IF;
               ELSE
                  nCP_MALACRML := NVL(nCP_MALACRML,0) + ((rMetrCons.CANTCON1 * nCP_N_Veces) * nNumeMaFS);
                  nCP_MALAMRML := NVL(nCP_MALAMRML,0) + (((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * nNumeMaFS);
                  --
                  IF NVL(nFactorM2,0) != 0 THEN
                     nCP_COMTREAL := NVL(nCP_COMTREAL,0) + ((((((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * nNumeMaFS) / nFactorM2) * nPrecReFS) / nNumeMaFS);
                  ELSE
                     P_ERRORES('12- (No existe FC) No se puede acumular Merma Total Real para la MP en la Fase: '||nFaSeUlti);
                  END IF;
               END IF;
            END IF;
            --
            nNumeMaFS := 0;
            nPrecReFS := 0;
         END IF;
         --
         --Busqueda del Precio de la MP de la Estructura
         IF rEstructura.Tip_Ares = vP_TiarMPF4 THEN
            --Se acumulan valores
            --Contador de Numero de Materiales
            nNumeMate := nNumeMate + 1;
            --Contador de Numero de Materiales en Fase Secuencia
            nNumeMaFS := nNumeMaFS + 1;
            --Calculo de Unidad de Logistica para los materiales
            OPEN cASMAAR01(vEmpresa, rEstructura.Tip_Ares, rEstructura.Cod_Ares);
            FETCH cASMAAR01 INTO rASMAAR01;
            CLOSE cASMAAR01;
            /*--LOGICA REAL DE METROS POR MATERIAL NO SE USA POR QUE NO SE VAN A CONSIDERAR DEBARBES
            OPEN cENTMAAR01(vEmpresa, rEstructura.Tip_Ares, rEstructura.Cod_Ares);
            FETCH cENTMAAR01 INTO rENTMAAR01;
            CLOSE cENTMAAR01;  
            */
            --Se calcula el factor de logistica de produccion para la MP
            nFactorULMP := 0;
            --
            BEGIN
               --Se pasa las Unidades Cerradas a la unidad del Precio
               nFactorULMP := P_Articulo.F_Factor (vEmpresa,vMatBase,
                                                   nCP_Ancho_MM, NULL,
                                                   vP_TipoUnML,rASMAAR01.VUCCOD);
            EXCEPTION 
               WHEN OTHERS THEN
                  nFactorULMP := 0;
                  bError := TRUE;
                  P_ERRORES('13- No se puede calcular FC de '||vP_TipoUnML||'->'||rASMAAR01.VUCCOD||' para la MP: '||rEstructura.Tip_Ares||'-'||rEstructura.Cod_Ares);
            END;
            --
            IF NVL(nFactorULMP,0) != 0 THEN
               --Cantidad Cerrada de MP en Unidades de Logistica
               nCantCeMP := NVL(nCP_CantCerr_ML_PROD,0) * (1 / nFactorULMP);
            ELSE
               nCantCeMP := 0;
               P_ERRORES('14- (No existe FC) No se puede calcular Cantidad Cerrada de MP en Unidades de Logistica para la MP: '||rEstructura.Tip_Ares||'-'||rEstructura.Cod_Ares);
            END IF;
            --Precios Estandar de Materias Primas
            rANE_PRECMAPR.UNIDAD := NULL;
            --
            OPEN cANE_PRECMAPR(vEmpresa, rEstructura.Tip_Ares, rEstructura.Cod_Ares,dFecha_Cierre);
            FETCH cANE_PRECMAPR INTO rANE_PRECMAPR;
            CLOSE cANE_PRECMAPR;
            --
            IF rANE_PRECMAPR.UNIDAD IS NOT NULL THEN
               nFactorUP := 0;
               --
               BEGIN
                  --Se pasa las Unidades Cerradas a la unidad del Precio
                  nFactorUP := P_Articulo.F_Factor (vEmpresa,vMatBase,
                                                    nCP_Ancho_MM, NULL,
                                                    rASMAAR01.VUCCOD,rANE_PRECMAPR.UNIDAD);
               EXCEPTION 
                  WHEN OTHERS THEN
                     nFactorUP := 0;
                     bError := TRUE;
                     P_ERRORES('15- No se puede calcular FC de '||rASMAAR01.VUCCOD||'->'||rANE_PRECMAPR.UNIDAD||' para la MP: '||rEstructura.Tip_Ares||'-'||rEstructura.Cod_Ares);
               END;
               --
               IF NVL(nFactorUP,0) != 0 THEN
                  IF NVL(rANE_PRECMAPR.CANTIDAD,0) != 0 THEN
                      --Ingreso Neto Estandar de Consumo de Lamina (Cantidad cerrada en Unidad de Precios Estandar *  Precio Medio)
                      nCP_COLAESTA := NVL(nCP_COLAESTA,0) + ((NVL(nCantCeMP,0) * (1 / nFactorUP)) * (rANE_PRECMAPR.PRECIO / rANE_PRECMAPR.CANTIDAD));
                  END IF;
               END IF;
            ELSE
               P_ERRORES('16- No existen Precios de MP para: '||rEstructura.Tip_Ares||'-'||rEstructura.Cod_Ares);
            END IF;
            --Precios Reales de Materias Primas
            nPrecMere := NULL;
            nCantPrme := 0;
            nPrecPrme := 0;
            --
            FOR rExisPeri IN cExisPeri(vEmpresa, rEstructura.Tip_Ares, rEstructura.Cod_Ares,
                                       dFecha_Cierre) LOOP
               nPrecComp := NULL;
               --Se busca la compra para el preci
               OPEN cCompras(vEmpresa, rEstructura.Tip_Ares, rEstructura.Cod_Ares, rExisPeri.ASLOTE);
               FETCH cCompras INTO nPrecComp;
               CLOSE cCompras;
               --
               IF NVL(nPrecComp,0) != 0 THEN
                  nCantPrme := nCantPrme + rExisPeri.AHCANT; --Acumula la cantidad
                  nPrecPrme := nPrecPrme + (rExisPeri.AHCANT * nPrecComp); --Acumula el Precio
               END IF;
            END LOOP;
            --
            IF nCantPrme != 0 THEN
               nPrecMere := nPrecPrme / nCantPrme;
            ELSE
               nPrecMere := 0;
            END IF;   
            --
            IF nPrecMere = 0 THEN
               rUltiCompr.ALCANT := NULL;
               --
               OPEN cUltiCompr(vEmpresa, rEstructura.Tip_Ares, rEstructura.Cod_Ares);
               FETCH cUltiCompr INTO rUltiCompr;--PRECIO MEDIO REAL
               CLOSE cUltiCompr;
               --(ALCAEQ * ALPREU) / ALCANT, ALUNST, ALUNCO
               IF NVL(rUltiCompr.ALCANT,0) != 0 THEN
                  IF rUltiCompr.ALUNST = rASMAAR01.VUCCOD THEN
                     nPrecMere := (rUltiCompr.ALCAEQ * rUltiCompr.ALPREU) / rUltiCompr.ALCANT;
                  ELSE
                     nPrecMere := 0;
                     P_ERRORES('17.1- No se puede establecer el precio para la MP: '||rEstructura.Tip_Ares||'-'||rEstructura.Cod_Ares);
                  END IF;
               ELSE
                  nPrecMere := 0;
                  P_ERRORES('17.2- No se puede establecer el precio para la MP: '||rEstructura.Tip_Ares||'-'||rEstructura.Cod_Ares);
               END IF;
            END IF;
            --Acumula el Precio Real de la Fase Secuencia
            nPrecReFS := nPrecReFS + NVL(nPrecMere,0);
            --
            IF nPrecMere != 0 THEN
               --Ingreso Neto Real de Consumo de Lamina (Cantidad cerrada *  Precio Medio)
               nCP_COLAREAL := NVL(nCP_COLAREAL,0) + (NVL(nCantCeMP,0) * nPrecMere);
            ELSE
               nCP_COLAREAL := 0;
               P_ERRORES('18- (No existe precio para la MP) No se puede calcular Ingreso Neto Real de Consumo de Lamina para la MP: '||rEstructura.Tip_Ares||'-'||rEstructura.Cod_Ares);
            END IF;
         ELSE
            P_RECURSIVO_MATERIALES(rEstructura.Tip_Ares, rEstructura.Cod_Ares);
         END IF;
         --Se guarda la Ultima Fase
         nFaSeUlti := rEstructura.Fase;
      END LOOP;
   END;
--------------------CS_CP_SUM_COSTUNOT_E--------------
   FUNCTION CS_CP_SUM_COSTUNOT_E(vEmpresa  FIC_CABEOTRE.EMPRESA%TYPE,   
                                 dFecha_Cierre DATE) 
   RETURN NUMBER IS
      --Calculo de CS_CP_SUM_COSTUNOT Y CS_CP_SUM_COSTUNOT_E
      nCP_COSTRESE_TINT_E NUMBER;
      nF_CALCMEAN NUMBER;
      vCF_TIPOCOST_TINT VARCHAR2(250);
      nCS_CP_SUM_COSTUNOT_E NUMBER;
      nCF_COSTREPR_TINT_E NUMBER;
      --
      CURSOR cG_TIPOCOST IS
         SELECT EC.TIPOCOST TIPOCOST_TINT, TC.TIPOCOST DESCTICO_TINT
         FROM GNR_ESCCEMPR EC, GNR_TICOEMPR TC
         WHERE NOT EXISTS (SELECT 'X' FROM VALORES_LISTA EX WHERE EX.CODIGO = 'ANE_ESTREXCR' AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'ESTRUCTURA') = EC.ESTRUCTU)
              AND EC.TIPOCOST = TC.CODIGO(+)         
              AND EC.DEPARTAM = vP_CODECOMU
              AND EC.INDUCOMU != vP_INDUSIIN
         GROUP BY EC.TIPOCOST, TC.TIPOCOST
         UNION
         SELECT NULL TIPOCOST,  P_UTILIDAD.F_ValoCampo(EX.VALOR,'DESCRIPCION') DESCTICO
         FROM VALORES_LISTA EX, GNR_DEPAEMPR DE,GNR_SPDEEMPR SD, GNR_SEPREMPR SP, VALORES_LISTA SAU, GNR_SEAUEMPR SA
         WHERE EX.CODIGO = 'ANE_ESTREXCR'
           AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'LISTADOS') = 'S'
           AND DE.CODIGO  = vP_CODECOMU
           AND DE.CODIGO = SD.DEPARTAM
           AND SD.SECCION = SP.CODIGO
           AND SAU.CODIGO = 'GNR_RESPAURH'
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCION')= SD.SECCION
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCAUXI') = SA.CODIGO(+)
         UNION
         SELECT EC.TIPOCOST, TC.TIPOCOST DESCTICO
         FROM GNR_ESCCEMPR EC, GNR_TICOEMPR TC
         WHERE NOT EXISTS (SELECT 'X' FROM VALORES_LISTA EX WHERE EX.CODIGO = 'ANE_ESTREXCR' AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'ESTRUCTURA') = EC.ESTRUCTU)
              AND EC.TIPOCOST = TC.CODIGO(+)
              AND EC.DEPARTAM = vP_CODETINT
         GROUP BY EC.TIPOCOST, TC.TIPOCOST
         UNION
         SELECT NULL TIPOCOST,  P_UTILIDAD.F_ValoCampo(EX.VALOR,'DESCRIPCION') DESCTICO
         FROM VALORES_LISTA EX, GNR_DEPAEMPR DE,GNR_SPDEEMPR SD, GNR_SEPREMPR SP, VALORES_LISTA SAU, GNR_SEAUEMPR SA
         WHERE EX.CODIGO = 'ANE_ESTREXCR'
           AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'LISTADOS') = 'S'
           AND DE.CODIGO  = vP_CODETINT
           AND DE.CODIGO = SD.DEPARTAM
           AND SD.SECCION = SP.CODIGO
           AND SAU.CODIGO = 'GNR_RESPAURH'
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCION')= SD.SECCION
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCAUXI') = SA.CODIGO(+);
      --
      CURSOR cG_SECCAUXI IS
         SELECT S.DEPARTAM DEPARTAM_TINT, D.DEPARTAM DESCDEPA_TINT, S.SECCION SECCION_TINT, SD.SECCION DESCSECC_TINT, SA.SECCAUXI SECCAUXI_TINT, SAD.SECCAUXI DESCSEAU_TINT, D.INDUREPR INDUREPR_TINT, SAD.REPAABSO REPAABSO_TINT, D.INDURESE INDURESE_TINT, ROWNUM ROWNUM_TINT, INDP.CALCPRSU CALCPRSU_REPR_TINT, INDS.CALCPRSU CALCPRSU_RESE_TINT, D.CAVAISDE CAVAISDE_TINT, SAD.INREOBCO INREOBCO_TINT, INDP.INDUCTOR DEINREPR_TINT
         FROM GNR_SPDEEMPR S, GNR_SASPEMPR SA, GNR_SEAUEMPR SAD, GNR_DEPAEMPR D, GNR_SEPREMPR SD, GNR_INDUEMPR INDP, GNR_INDUEMPR INDS
            WHERE S.SECCION = SA.SECCION
              AND S.SECCION = SD.CODIGO
              AND SA.SECCAUXI = SAD.CODIGO
              AND S.DEPARTAM = D.CODIGO
              AND D.INDUREPR = INDP.CODIGO(+)
              AND D.INDURESE = INDS.CODIGO(+)
              AND S.DEPARTAM = vP_CODETINT
         ORDER BY SAD.REPAABSO DESC, S.DEPARTAM, S.SECCION, SA.SECCAUXI;
      --
      FUNCTION F_CALCMEAN_TINT_E (vAnno NUMBER) RETURN NUMBER IS
         nRetorno NUMBER;
      BEGIN
          IF TO_CHAR(dFecha_Cierre,'YYYY') <= TO_CHAR(dFecha_Cierre,'YYYY') THEN 
             IF vAnno = TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno = TO_CHAR(dFecha_Cierre,'YYYY') THEN
                nRetorno := (TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM'))) + 1;
             ELSIF vAnno = TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno != TO_CHAR(dFecha_Cierre,'YYYY') THEN                                      
                nRetorno := (TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||'12') - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM'))) + 1;
             ELSIF vAnno != TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno = TO_CHAR(dFecha_Cierre,'YYYY') THEN      
                 nRetorno := TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||'00');
             ELSIF vAnno != TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno != TO_CHAR(dFecha_Cierre,'YYYY') THEN
                nRetorno := 12;
             ELSE
                nRetorno := 0;
             END IF;
          ELSE
             nRetorno := 0;
          END IF;
         --
         RETURN nRetorno;
      END;
      --
      FUNCTION CF_COSTSRDI_TINT_E(vDEPARTAM_TINT GNR_SPDEEMPR.DEPARTAM%TYPE) return Number is
         rANE_INDECO_Rec_Dep P_ANE_INDECO.St_ANE_INDECO_AM;
      BEGIN
         rANE_INDECO_Rec_Dep := P_ANE_INDECO.F_ObtieneCosteSubrepDepto_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_TINT, vCF_TIPOCOST_TINT);
         --
         RETURN(rANE_INDECO_Rec_Dep.nCoste);
      END;
      --
      FUNCTION CF_COSTRESA_TINT_E(vDEPARTAM_TINT GNR_SPDEEMPR.DEPARTAM%TYPE, vSECCION_TINT GNR_SPDEEMPR.SECCION%TYPE, vSECCAUXI_TINT GNR_SASPEMPR.SECCAUXI%TYPE) return Number is
         rANE_INTCRE_Rec_Sea P_ANE_INTCRE.St_ANE_INTCRE_AM;
         nRetorno NUMBER;
      BEGIN
         rANE_INTCRE_Rec_Sea := P_ANE_INTCRE.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_TINT, vSECCION_TINT, vSECCAUXI_TINT, vCF_TIPOCOST_TINT);
         --
         IF vEmpresa = vP_EMPRPHAR THEN
            nRetorno := NVL(rANE_INTCRE_Rec_Sea.nCOTOPHAR,0);
         ELSIF vEmpresa = vP_EMPRMANV THEN
            nRetorno := NVL(rANE_INTCRE_Rec_Sea.nCOTOMANV,0);
         ELSE
            nRetorno := 0;
         END IF;
         --
         RETURN(nRetorno);
      END;
      --
      FUNCTION CF_TOTAINPR_TINT_E(vINDUREPR_TINT GNR_DEPAEMPR.INDUREPR%TYPE, vCALCPRSU_REPR_TINT GNR_INDUEMPR.CALCPRSU%TYPE) return Number is
         CURSOR cInductor_Tot IS
            SELECT ANNO, 
                SUM(ENERO) ENERO, SUM(FEBRERO) FEBRERO, SUM(MARZO) MARZO, SUM(ABRIL) ABRIL,
                SUM(MAYO) MAYO, SUM(JUNIO) JUNIO, SUM(JULIO) JULIO, SUM(AGOSTO) AGOSTO,
                SUM(SEPTIEMBRE) SEPTIEMBRE, SUM(OCTUBRE) OCTUBRE, SUM(NOVIEMBRE) NOVIEMBRE, SUM(DICIEMBRE) DICIEMBRE         
               FROM ANE_COISSSES
                  WHERE EMPRESA = vEmpresa
                    AND INDUCTOR = vINDUREPR_TINT
                    AND ANNO BETWEEN TO_CHAR(dFecha_Cierre,'YYYY') AND TO_CHAR(dFecha_Cierre,'YYYY')
            GROUP BY ANNO;
         --
         nInductor_Tot NUMBER;
         nMeseAnno_Tot NUMBER := 0;
      BEGIN
          IF vINDUREPR_TINT IS NOT NULL THEN
            nInductor_Tot := 0;
            nMeseAnno_Tot := 0;
            --
            FOR rInductor_Tot IN cInductor_Tot LOOP
               IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'01') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.ENERO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'02') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.FEBRERO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'03') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.MARZO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'04') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.ABRIL;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'05') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.MAYO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'06') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.JUNIO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'07') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.JULIO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'08') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.AGOSTO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'09') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.SEPTIEMBRE;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'10') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.OCTUBRE;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'11') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.NOVIEMBRE;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'12') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.DICIEMBRE;
                   END IF;
                   --
                   IF vCALCPRSU_REPR_TINT = 'P' THEN
                      nMeseAnno_Tot := nMeseAnno_Tot + F_CALCMEAN_TINT_E(rInductor_Tot.Anno);
                   END IF;
            END LOOP;
            --
              IF vCALCPRSU_REPR_TINT = 'P' THEN
                  IF nMeseAnno_Tot != 0 THEN
                     nInductor_Tot := nInductor_Tot / nMeseAnno_Tot;
                  ELSE
                     nInductor_Tot := 0;
                  END IF;
               END IF;
          END IF;
         --
         RETURN(nInductor_Tot);     
      END;
      --
      FUNCTION CF_TOTAINSE_TINT_E(vINDURESE_TINT GNR_DEPAEMPR.INDURESE%TYPE, vCALCPRSU_RESE_TINT GNR_INDUEMPR.CALCPRSU%TYPE) return Number is
         CURSOR cInductor_Tot IS
            SELECT ANNO, 
                SUM(ENERO) ENERO, SUM(FEBRERO) FEBRERO, SUM(MARZO) MARZO, SUM(ABRIL) ABRIL,
                SUM(MAYO) MAYO, SUM(JUNIO) JUNIO, SUM(JULIO) JULIO, SUM(AGOSTO) AGOSTO,
                SUM(SEPTIEMBRE) SEPTIEMBRE, SUM(OCTUBRE) OCTUBRE, SUM(NOVIEMBRE) NOVIEMBRE, SUM(DICIEMBRE) DICIEMBRE         
               FROM ANE_COISSSES
                  WHERE EMPRESA = vEmpresa
                    AND INDUCTOR = vINDURESE_TINT
                    AND ANNO BETWEEN TO_CHAR(dFecha_Cierre,'YYYY') AND TO_CHAR(dFecha_Cierre,'YYYY')
            GROUP BY ANNO;
         --
         nInductor_Tot NUMBER;
         nMeseAnno_Tot NUMBER := 0;
      begin
          IF vINDURESE_TINT IS NOT NULL THEN
            nInductor_Tot := 0;
            nMeseAnno_Tot := 0;
            --
            FOR rInductor_Tot IN cInductor_Tot LOOP
              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'01') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.ENERO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'02') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.FEBRERO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'03') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.MARZO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'04') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.ABRIL;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'05') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.MAYO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'06') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.JUNIO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'07') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.JULIO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'08') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.AGOSTO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'09') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.SEPTIEMBRE;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'10') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.OCTUBRE;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'11') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.NOVIEMBRE;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'12') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.DICIEMBRE;
                  END IF;
                  --
                  IF vCALCPRSU_RESE_TINT = 'P' THEN
                     nMeseAnno_Tot := nMeseAnno_Tot + F_CALCMEAN_TINT_E(rInductor_Tot.Anno);
                  END IF;
            END LOOP;
            --
              IF vCALCPRSU_RESE_TINT = 'P' THEN
                  IF nMeseAnno_Tot != 0 THEN
                     nInductor_Tot := nInductor_Tot / nMeseAnno_Tot;
                  ELSE
                     nInductor_Tot := 0;
                  END IF;
               END IF;
         END IF;   	
         --
         RETURN(nInductor_Tot);     
      END;
      --
      FUNCTION CF_COSTREPR_TINT_E(vDEPARTAM_TINT GNR_SPDEEMPR.DEPARTAM%TYPE, vSECCION_TINT GNR_SPDEEMPR.SECCION%TYPE, vSECCAUXI_TINT GNR_SASPEMPR.SECCAUXI%TYPE, 
                                  vTIPOCOST_TINT GNR_ESCCEMPR.TIPOCOST%TYPE, vDESCTICO_TINT GNR_TICOEMPR.TIPOCOST%TYPE,
                                  vREPAABSO_TINT GNR_SEAUEMPR.REPAABSO%TYPE,
                                  vINDUREPR_TINT GNR_DEPAEMPR.INDUREPR%TYPE, vCALCPRSU_REPR_TINT GNR_INDUEMPR.CALCPRSU%TYPE,
                                  vCAVAISDE_TINT GNR_DEPAEMPR.CAVAISDE%TYPE,
                                  vINDURESE_TINT GNR_DEPAEMPR.INDURESE%TYPE, vCALCPRSU_RESE_TINT GNR_INDUEMPR.CALCPRSU%TYPE) return Number is
         rANE_INTCRE_Rec_Sea P_ANE_INTCRE.St_ANE_INTCRE_AM;
         --
         nRetorno NUMBER := 0;
         --
         CURSOR cSeccAuxi_Repa IS
         SELECT S.SECCION, SA.SECCAUXI 
            FROM GNR_SPDEEMPR S, GNR_SASPEMPR SA, GNR_SEAUEMPR SAD, GNR_DEPAEMPR D
            WHERE S.SECCION = SA.SECCION
              AND SA.SECCAUXI = SAD.CODIGO
              AND S.DEPARTAM = D.CODIGO
              AND S.DEPARTAM = vDEPARTAM_TINT
              AND SAD.REPAABSO = 'R';
         --
         CURSOR cInductor(vDepartam ANE_COISSSES.DEPARTAM%TYPE, vSeccion ANE_COISSSES.SECCION%TYPE, vSeccAuxi ANE_COISSSES.SECCAUXI%TYPE, vInductor ANE_COISSSES.INDUCTOR%TYPE) IS
            SELECT ANNO, 
                SUM(ENERO) ENERO, SUM(FEBRERO) FEBRERO, SUM(MARZO) MARZO, SUM(ABRIL) ABRIL,
                SUM(MAYO) MAYO, SUM(JUNIO) JUNIO, SUM(JULIO) JULIO, SUM(AGOSTO) AGOSTO,
                SUM(SEPTIEMBRE) SEPTIEMBRE, SUM(OCTUBRE) OCTUBRE, SUM(NOVIEMBRE) NOVIEMBRE, SUM(DICIEMBRE) DICIEMBRE         
               FROM ANE_COISSSES
                  WHERE EMPRESA = vEmpresa
                    AND DEPARTAM = vDepartam
                    AND SECCION = vSeccion
                    AND SECCAUXI = vSeccAuxi
                    AND INDUCTOR = vInductor
                    AND ANNO BETWEEN TO_CHAR(dFecha_Cierre,'YYYY') AND TO_CHAR(dFecha_Cierre,'YYYY')
            GROUP BY ANNO;
         --
         nInductor NUMBER := 0;
         nMeseAnno NUMBER := 0;
         --
         nCostRepa NUMBER;
         --
         CURSOR cGNR_TCEXRSDE IS
         SELECT 'X' FROM GNR_TCEXRSDE EX, GNR_TICOEMPR TC
            WHERE EX.TIPOCOST = TC.CODIGO
              AND DEPARTAM = vDEPARTAM_TINT
              AND (
                   (vTIPOCOST_TINT IS NOT NULL AND EX.TIPOCOST = vTIPOCOST_TINT) OR
                   (vTIPOCOST_TINT IS NULL AND EX.TIPOCOST||' '||TC.TIPOCOST = vDESCTICO_TINT)
                  );
      --
      vExisExcl VARCHAR2(1);           
      nCP_COSTUNOT_TINT_E NUMBER;
      nCF_TOTAINPR_TINT_E NUMBER := CF_TOTAINPR_TINT_E(vINDUREPR_TINT, vCALCPRSU_REPR_TINT);
      nCF_COSTRESA_TINT_E NUMBER := CF_COSTRESA_TINT_E(vDEPARTAM_TINT, vSECCION_TINT, vSECCAUXI_TINT);
      nCF_COSTSRDI_TINT_E NUMBER := CF_COSTSRDI_TINT_E(vDEPARTAM_TINT);
      nCF_TOTAINSE_TINT_E NUMBER := CF_TOTAINSE_TINT_E(vINDURESE_TINT, vCALCPRSU_RESE_TINT);
   BEGIN
         vExisExcl := NULL;
         --
         OPEN cGNR_TCEXRSDE;
         FETCH cGNR_TCEXRSDE INTO vExisExcl;
         CLOSE cGNR_TCEXRSDE;
         --	
          IF vREPAABSO_TINT = 'R' THEN
            rANE_INTCRE_Rec_Sea := P_ANE_INTCRE.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_TINT, vSECCION_TINT, vSECCAUXI_TINT, vCF_TIPOCOST_TINT);
            --
            IF vExisExcl IS NULL THEN
               IF vEmpresa = vP_EMPRPHAR THEN
                  nRetorno := NVL(rANE_INTCRE_Rec_Sea.nCOTOPHAR,0);
               ELSIF vEmpresa = vP_EMPRMANV THEN
                  nRetorno := NVL(rANE_INTCRE_Rec_Sea.nCOTOMANV,0);
               ELSE
                  nRetorno := 0;
               END IF;        
            ELSE
               nRetorno := 0;
            END IF;
            --
            nCP_COSTRESE_TINT_E := NULL;
            --
            nCP_COSTUNOT_TINT_E := NULL;
         ELSE
            IF vINDUREPR_TINT IS NOT NULL THEN
                 nInductor := 0;
                 nMeseAnno := 0;
               --
                FOR rInductor IN cInductor(vDEPARTAM_TINT, vSECCION_TINT, vSECCAUXI_TINT, vINDUREPR_TINT) LOOP
                     IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'01') THEN
                         nInductor := nInductor + rInductor.ENERO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'02') THEN
                         nInductor := nInductor + rInductor.FEBRERO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'03') THEN
                         nInductor := nInductor + rInductor.MARZO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'04') THEN
                         nInductor := nInductor + rInductor.ABRIL;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'05') THEN
                         nInductor := nInductor + rInductor.MAYO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'06') THEN
                         nInductor := nInductor + rInductor.JUNIO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'07') THEN
                         nInductor := nInductor + rInductor.JULIO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'08') THEN
                         nInductor := nInductor + rInductor.AGOSTO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'09') THEN
                         nInductor := nInductor + rInductor.SEPTIEMBRE;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'10') THEN
                         nInductor := nInductor + rInductor.OCTUBRE;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'11') THEN
                         nInductor := nInductor + rInductor.NOVIEMBRE;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'12') THEN
                         nInductor := nInductor + rInductor.DICIEMBRE;
                      END IF;
                      --
                      IF vCALCPRSU_REPR_TINT = 'P' THEN
                         nMeseAnno := nMeseAnno + F_CALCMEAN_TINT_E(rInductor.Anno);
                      END IF;
                  END LOOP;
                  --
                   IF vCALCPRSU_REPR_TINT = 'P' THEN
                      IF nMeseAnno != 0 THEN
                         nInductor := nInductor / nMeseAnno;
                      ELSE
                         nInductor := 0;
                      END IF;
                   END IF;         
               --
               IF NVL(nCF_TOTAINPR_TINT_E,0) != 0 AND NVL(nInductor,0) != 0 THEN
                   nCostRepa := nCF_COSTSRDI_TINT_E;
                   --
                  FOR rSeccAuxi_Repa IN cSeccAuxi_Repa LOOP
                     rANE_INTCRE_Rec_Sea := P_ANE_INTCRE.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_TINT, rSeccAuxi_Repa.SECCION, rSeccAuxi_Repa.SECCAUXI, vCF_TIPOCOST_TINT);
                     --
                     IF vEmpresa = vP_EMPRPHAR THEN
                        nCostRepa := nCostRepa + NVL(rANE_INTCRE_Rec_Sea.nCOTOPHAR,0);
                     ELSIF vEmpresa = vP_EMPRMANV THEN
                        nCostRepa := nCostRepa + NVL(rANE_INTCRE_Rec_Sea.nCOTOMANV,0);
                     END IF;   
                  END LOOP;
                  --
                  IF nCostRepa != 0 THEN
                     nRetorno := ((nCostRepa / nCF_TOTAINPR_TINT_E) * nInductor);
                  END IF;
               END IF;
            ELSE
               nRetorno := nCF_COSTSRDI_TINT_E;
            END IF;
            --
            IF vExisExcl IS NULL THEN
               nCP_COSTRESE_TINT_E := nRetorno + nCF_COSTRESA_TINT_E;
            ELSE
               nCP_COSTRESE_TINT_E := nRetorno;
            END IF;
            --
            IF vINDURESE_TINT IS NOT NULL THEN
               IF vCAVAISDE_TINT = 'S' THEN
                  nInductor := 0;
                  nMeseAnno := 0;
                  --
                  FOR rInductor IN cInductor(vDEPARTAM_TINT, vSECCION_TINT, vSECCAUXI_TINT, vINDURESE_TINT) LOOP
                          IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'01') THEN
                              nInductor := nInductor + rInductor.ENERO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'02') THEN
                              nInductor := nInductor + rInductor.FEBRERO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'03') THEN
                              nInductor := nInductor + rInductor.MARZO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'04') THEN
                              nInductor := nInductor + rInductor.ABRIL;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'05') THEN
                              nInductor := nInductor + rInductor.MAYO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'06') THEN
                              nInductor := nInductor + rInductor.JUNIO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'07') THEN
                              nInductor := nInductor + rInductor.JULIO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'08') THEN
                              nInductor := nInductor + rInductor.AGOSTO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'09') THEN
                              nInductor := nInductor + rInductor.SEPTIEMBRE;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'10') THEN
                              nInductor := nInductor + rInductor.OCTUBRE;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'11') THEN
                              nInductor := nInductor + rInductor.NOVIEMBRE;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'12') THEN
                              nInductor := nInductor + rInductor.DICIEMBRE;
                           END IF;
                           --
                           IF vCALCPRSU_RESE_TINT = 'P' THEN
                              nMeseAnno := nMeseAnno + F_CALCMEAN_TINT_E(rInductor.Anno);
                           END IF;
                       END LOOP;
                       --
                        IF vCALCPRSU_RESE_TINT = 'P' THEN
                           IF nMeseAnno != 0 THEN
                              nInductor := nInductor / nMeseAnno;
                           ELSE
                              nInductor := 0;
                           END IF;
                        END IF;         
                  --
                  IF NVL(nInductor,0) != 0 THEN
                     nCP_COSTUNOT_TINT_E := nCP_COSTRESE_TINT_E / nInductor;
                  ELSE
                     nCP_COSTUNOT_TINT_E := 0;
                  END IF;
               ELSE
                  IF NVL(nCF_TOTAINSE_TINT_E,0) != 0 THEN
                     nCP_COSTUNOT_TINT_E := nCP_COSTRESE_TINT_E / nCF_TOTAINSE_TINT_E;
                  ELSE
                     nCP_COSTUNOT_TINT_E := 0;
                  END IF;
               END IF;
               -------------------------------------------------------------------
               nCS_CP_SUM_COSTUNOT_E := NVL(nCS_CP_SUM_COSTUNOT_E,0) + NVL(nCP_COSTUNOT_TINT_E,0);
            ELSE
              nCP_COSTUNOT_TINT_E := NULL; 	
            END IF;
         END IF;
         --
         RETURN(nRetorno);
      END;
   begin
   --
      IF NOT (P_ANE_INTCRE.F_Obtiene_AM_ALM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'))) THEN
         P_ANE_INTCRE.P_BorraTabla;
         --
         P_ANE_INTCRE.P_Costes_Repartidos(NULL, NULL, NULL, NULL,
                                          TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
         --
         P_ANE_INTCRE.P_Adiciona_Tabla_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
      END IF;
      --
      IF NOT (P_ANE_INDECO.F_Obtiene_AM_ALM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'))) THEN
         P_ANE_INDECO.P_BorraTabla;
         --
         P_ANE_INDECO.P_Departamento_Comun(vEmpresa,
                                           NULL, NULL, NULL, NULL,
                                           TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));	
         --
         P_ANE_INDECO.P_Adiciona_Tabla_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
      END IF;
      --
      FOR rG_TIPOCOST IN cG_TIPOCOST LOOP
         IF rG_TIPOCOST.TIPOCOST_TINT IS NOT NULL THEN
            vCF_TIPOCOST_TINT := rG_TIPOCOST.TIPOCOST_TINT||' '||rG_TIPOCOST.DESCTICO_TINT;
         ELSE
            vCF_TIPOCOST_TINT := rG_TIPOCOST.DESCTICO_TINT;
         END IF;
         --
         FOR rG_SECCAUXI IN cG_SECCAUXI LOOP
            nCF_COSTREPR_TINT_E := CF_COSTREPR_TINT_E(rG_SECCAUXI.DEPARTAM_TINT, rG_SECCAUXI.SECCION_TINT, rG_SECCAUXI.SECCAUXI_TINT, 
                                                      rG_TIPOCOST.TIPOCOST_TINT, rG_TIPOCOST.DESCTICO_TINT,
                                                      rG_SECCAUXI.REPAABSO_TINT,
                                                      rG_SECCAUXI.INDUREPR_TINT, rG_SECCAUXI.CALCPRSU_REPR_TINT,
                                                      rG_SECCAUXI.CAVAISDE_TINT,
                                                      rG_SECCAUXI.INDURESE_TINT, rG_SECCAUXI.CALCPRSU_RESE_TINT);
         END LOOP;
      END LOOP;
      --
      RETURN(nCS_CP_SUM_COSTUNOT_E);
   end;
--------------------CS_CP_SUM_COSTUNOT_R--------------
   FUNCTION CS_CP_SUM_COSTUNOT(vEmpresa  FIC_CABEOTRE.EMPRESA%TYPE,   
                               dFecha_Cierre DATE) 
   RETURN NUMBER IS
      --Calculo de CS_CP_SUM_COSTUNOT Y CS_CP_SUM_COSTUNOT_E
      nCP_COSTRESE_TINT NUMBER;
      nF_CALCMEAN NUMBER;
      vCF_TIPOCOST_TINT VARCHAR2(250);
      nCS_CP_SUM_COSTUNOT NUMBER;
      nCF_COSTREPR_TINT NUMBER;
      --
      CURSOR cG_TIPOCOST IS
         SELECT EC.TIPOCOST TIPOCOST_TINT, TC.TIPOCOST DESCTICO_TINT
         FROM GNR_ESCCEMPR EC, GNR_TICOEMPR TC
         WHERE NOT EXISTS (SELECT 'X' FROM VALORES_LISTA EX WHERE EX.CODIGO = 'ANE_ESTREXCR' AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'ESTRUCTURA') = EC.ESTRUCTU)
              AND EC.TIPOCOST = TC.CODIGO(+)         
              AND EC.DEPARTAM = vP_CODECOMU
              AND EC.INDUCOMU != vP_INDUSIIN
         GROUP BY EC.TIPOCOST, TC.TIPOCOST
         UNION
         SELECT NULL TIPOCOST,  P_UTILIDAD.F_ValoCampo(EX.VALOR,'DESCRIPCION') DESCTICO
         FROM VALORES_LISTA EX, GNR_DEPAEMPR DE,GNR_SPDEEMPR SD, GNR_SEPREMPR SP, VALORES_LISTA SAU, GNR_SEAUEMPR SA
         WHERE EX.CODIGO = 'ANE_ESTREXCR'
           AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'LISTADOS') = 'S'
           AND DE.CODIGO  = vP_CODECOMU
           AND DE.CODIGO = SD.DEPARTAM
           AND SD.SECCION = SP.CODIGO
           AND SAU.CODIGO = 'GNR_RESPAURH'
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCION')= SD.SECCION
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCAUXI') = SA.CODIGO(+)
         UNION
         SELECT EC.TIPOCOST, TC.TIPOCOST DESCTICO
         FROM GNR_ESCCEMPR EC, GNR_TICOEMPR TC
         WHERE NOT EXISTS (SELECT 'X' FROM VALORES_LISTA EX WHERE EX.CODIGO = 'ANE_ESTREXCR' AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'ESTRUCTURA') = EC.ESTRUCTU)
              AND EC.TIPOCOST = TC.CODIGO(+)
              AND EC.DEPARTAM = vP_CODETINT
         GROUP BY EC.TIPOCOST, TC.TIPOCOST
         UNION
         SELECT NULL TIPOCOST,  P_UTILIDAD.F_ValoCampo(EX.VALOR,'DESCRIPCION') DESCTICO
         FROM VALORES_LISTA EX, GNR_DEPAEMPR DE,GNR_SPDEEMPR SD, GNR_SEPREMPR SP, VALORES_LISTA SAU, GNR_SEAUEMPR SA
         WHERE EX.CODIGO = 'ANE_ESTREXCR'
           AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'LISTADOS') = 'S'
           AND DE.CODIGO  = vP_CODETINT
           AND DE.CODIGO = SD.DEPARTAM
           AND SD.SECCION = SP.CODIGO
           AND SAU.CODIGO = 'GNR_RESPAURH'
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCION')= SD.SECCION
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCAUXI') = SA.CODIGO(+);
      --
      CURSOR cG_SECCAUXI IS
         SELECT S.DEPARTAM DEPARTAM_TINT, D.DEPARTAM DESCDEPA_TINT, S.SECCION SECCION_TINT, SD.SECCION DESCSECC_TINT, SA.SECCAUXI SECCAUXI_TINT, SAD.SECCAUXI DESCSEAU_TINT, D.INDUREPR INDUREPR_TINT, SAD.REPAABSO REPAABSO_TINT, D.INDURESE INDURESE_TINT, ROWNUM ROWNUM_TINT, INDP.CALCPRSU CALCPRSU_REPR_TINT, INDS.CALCPRSU CALCPRSU_RESE_TINT, D.CAVAISDE CAVAISDE_TINT, SAD.INREOBCO INREOBCO_TINT, INDP.INDUCTOR DEINREPR_TINT
         FROM GNR_SPDEEMPR S, GNR_SASPEMPR SA, GNR_SEAUEMPR SAD, GNR_DEPAEMPR D, GNR_SEPREMPR SD, GNR_INDUEMPR INDP, GNR_INDUEMPR INDS
            WHERE S.SECCION = SA.SECCION
              AND S.SECCION = SD.CODIGO
              AND SA.SECCAUXI = SAD.CODIGO
              AND S.DEPARTAM = D.CODIGO
              AND D.INDUREPR = INDP.CODIGO(+)
              AND D.INDURESE = INDS.CODIGO(+)
              AND S.DEPARTAM = vP_CODETINT
         ORDER BY SAD.REPAABSO DESC, S.DEPARTAM, S.SECCION, SA.SECCAUXI;
      --
      FUNCTION F_CALCMEAN RETURN NUMBER IS
         nRetorno NUMBER := 0;
      begin
          IF TO_CHAR(dFecha_Cierre,'YYYY') <= TO_CHAR(dFecha_Cierre,'YYYY') THEN 
              FOR vAnno IN TO_CHAR(dFecha_Cierre,'YYYY')..TO_CHAR(dFecha_Cierre,'YYYY') LOOP
                IF vAnno = TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno = TO_CHAR(dFecha_Cierre,'YYYY') THEN
                    nRetorno := nRetorno + ((TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM'))) + 1);
                ELSIF vAnno = TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno != TO_CHAR(dFecha_Cierre,'YYYY') THEN                                      
                   nRetorno := nRetorno + ((TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||'12') - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM'))) + 1);
                ELSIF vAnno != TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno = TO_CHAR(dFecha_Cierre,'YYYY') THEN      
                   nRetorno := nRetorno + (TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||'00'));
                ELSIF vAnno != TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno != TO_CHAR(dFecha_Cierre,'YYYY') THEN
                   nRetorno := nRetorno + 12;
                ELSE
                   nRetorno := nRetorno + 0;
                END IF;
             END LOOP;
          END IF;
         --
         RETURN nRetorno;
      END;
      --
      FUNCTION CF_COSTSRDI_TINT(vDEPARTAM_TINT GNR_SPDEEMPR.DEPARTAM%TYPE) return Number is
         rANE_INDRCO_Rec_Dep P_ANE_INDRCO.St_ANE_INDRCO_AM;
      begin
         rANE_INDRCO_Rec_Dep := P_ANE_INDRCO.F_ObtieneCosteSubrepDepto_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_TINT, vCF_TIPOCOST_TINT);
         --
         RETURN(rANE_INDRCO_Rec_Dep.nCoste);
      END;
      --
      FUNCTION CF_COSTRESA_TINT(vDEPARTAM_TINT GNR_SPDEEMPR.DEPARTAM%TYPE, vSECCION_TINT GNR_SPDEEMPR.SECCION%TYPE, vSECCAUXI_TINT GNR_SASPEMPR.SECCAUXI%TYPE) return Number is
         rANE_INRETC_Rec_Sea P_ANE_INRETC.St_ANE_INRETC_AM;
         nRetorno NUMBER;
      BEGIN
         rANE_INRETC_Rec_Sea := P_ANE_INRETC.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_TINT, vSECCION_TINT, vSECCAUXI_TINT, vCF_TIPOCOST_TINT);
         --
         IF vEmpresa = vP_EMPRPHAR THEN
            nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOPHAR,0);
         ELSIF vEmpresa = vP_EMPRMANV THEN
            nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOMANV,0);
         ELSE           
            nRetorno := 0;
         END IF;
         --
        RETURN(nRetorno);
      END;
      --
      FUNCTION CF_TOTAINPR_TINT(vINDUREPR_TINT GNR_DEPAEMPR.INDUREPR%TYPE, vCALCPRSU_REPR_TINT GNR_INDUEMPR.CALCPRSU%TYPE) return Number is
         CURSOR cInductor_Tot IS
            SELECT SUM(VALOR) SUMA
               FROM ANE_COISSSRE
                  WHERE EMPRESA = vEmpresa
                    AND INDUCTOR = vINDUREPR_TINT
                    AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
                  AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'));
         --
         nInductor_Tot NUMBER := 0;
      begin
          IF vINDUREPR_TINT IS NOT NULL THEN
            nInductor_Tot := 0;
            --
            OPEN cInductor_Tot;
            FETCH cInductor_Tot INTO nInductor_Tot;
            CLOSE cInductor_Tot;
            --
            nInductor_Tot := NVL(nInductor_Tot,0);
            --
             IF vCALCPRSU_REPR_TINT = 'P' THEN
                 IF nF_CALCMEAN != 0 THEN
                   nInductor_Tot := nInductor_Tot / nF_CALCMEAN;
                 ELSE
                    nInductor_Tot := 0;
                 END IF;
             END IF;   
          END IF;
          --
         RETURN(nInductor_Tot);     
      end;
      --
      FUNCTION CF_TOTAINSE_TINT(vINDURESE_TINT GNR_DEPAEMPR.INDURESE%TYPE, vCALCPRSU_RESE_TINT GNR_INDUEMPR.CALCPRSU%TYPE) return Number is
         CURSOR cInductor_Tot IS
            SELECT SUM(VALOR) SUMA
               FROM ANE_COISSSRE
                  WHERE EMPRESA = vEmpresa
                    AND INDUCTOR = vINDURESE_TINT
                    AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
                  AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'));
         --
         nInductor_Tot NUMBER := 0;
      begin
          IF vINDURESE_TINT IS NOT NULL THEN
            nInductor_Tot := 0;
            --
            OPEN cInductor_Tot;
            FETCH cInductor_Tot INTO nInductor_Tot;
            CLOSE cInductor_Tot;
            --
            nInductor_Tot := NVL(nInductor_Tot,0);
            --
             IF vCALCPRSU_RESE_TINT = 'P' THEN
                 IF nF_CALCMEAN != 0 THEN
                   nInductor_Tot := nInductor_Tot / nF_CALCMEAN;
                 ELSE
                    nInductor_Tot := 0;
                 END IF;
             END IF;   
         END IF;   	
         --
         RETURN(nInductor_Tot);     
      END;
      --
      FUNCTION CF_COSTREPR_TINT(vDEPARTAM_TINT GNR_SPDEEMPR.DEPARTAM%TYPE, vSECCION_TINT GNR_SPDEEMPR.SECCION%TYPE, vSECCAUXI_TINT GNR_SASPEMPR.SECCAUXI%TYPE, 
                                vTIPOCOST_TINT GNR_ESCCEMPR.TIPOCOST%TYPE, vDESCTICO_TINT GNR_TICOEMPR.TIPOCOST%TYPE,
                                vREPAABSO_TINT GNR_SEAUEMPR.REPAABSO%TYPE,
                                vINDUREPR_TINT GNR_DEPAEMPR.INDUREPR%TYPE, vCALCPRSU_REPR_TINT GNR_INDUEMPR.CALCPRSU%TYPE,
                                vCAVAISDE_TINT GNR_DEPAEMPR.CAVAISDE%TYPE,
                                vINDURESE_TINT GNR_DEPAEMPR.INDURESE%TYPE, vCALCPRSU_RESE_TINT GNR_INDUEMPR.CALCPRSU%TYPE) return Number is
         rANE_INRETC_Rec_Sea P_ANE_INRETC.St_ANE_INRETC_AM;
         --
         nRetorno NUMBER := 0;
         --
         CURSOR cSeccAuxi_Repa IS
            SELECT S.SECCION, SA.SECCAUXI 
               FROM GNR_SPDEEMPR S, GNR_SASPEMPR SA, GNR_SEAUEMPR SAD, GNR_DEPAEMPR D
               WHERE S.SECCION = SA.SECCION
                 AND SA.SECCAUXI = SAD.CODIGO
                 AND S.DEPARTAM = D.CODIGO
                 AND S.DEPARTAM = vP_CODETINT
                 AND SAD.REPAABSO = 'R';
         --
         CURSOR cInductor(vDepartam ANE_COISSSRE.DEPARTAM%TYPE, vSeccion ANE_COISSSRE.SECCION%TYPE, vSeccAuxi ANE_COISSSRE.SECCAUXI%TYPE, vInductor ANE_COISSSRE.INDUCTOR%TYPE) IS
            SELECT SUM(VALOR) SUMA
               FROM ANE_COISSSRE
                  WHERE EMPRESA = vEmpresa
                    AND DEPARTAM = vDepartam
                    AND SECCION = vSeccion
                    AND SECCAUXI = vSeccAuxi
                    AND INDUCTOR = vInductor
                    AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
                  AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'));
         --
         nInductor NUMBER := 0;
         --
         nCostRepa NUMBER;
         --
         CURSOR cGNR_TCEXRSDE IS
            SELECT 'X' FROM GNR_TCEXRSDE EX, GNR_TICOEMPR TC
               WHERE EX.TIPOCOST = TC.CODIGO
                 AND DEPARTAM = vDEPARTAM_TINT
                 AND (
                      (vTIPOCOST_TINT IS NOT NULL AND EX.TIPOCOST = vTIPOCOST_TINT) OR
                      (vTIPOCOST_TINT IS NULL AND EX.TIPOCOST||' '||TC.TIPOCOST = vDESCTICO_TINT)
                     );
         --
         vExisExcl VARCHAR2(1); 
         nCP_COSTUNOT_TINT NUMBER;
         nCF_TOTAINPR_TINT NUMBER := CF_TOTAINPR_TINT(vINDUREPR_TINT, vCALCPRSU_REPR_TINT);
         nCF_COSTRESA_TINT NUMBER := CF_COSTRESA_TINT(vDEPARTAM_TINT, vSECCION_TINT, vSECCAUXI_TINT);
         nCF_COSTSRDI_TINT NUMBER := CF_COSTSRDI_TINT(vDEPARTAM_TINT);
         nCF_TOTAINSE_TINT NUMBER := CF_TOTAINSE_TINT(vINDURESE_TINT, vCALCPRSU_RESE_TINT);
      BEGIN
         vExisExcl := NULL;
         --
         OPEN cGNR_TCEXRSDE;
         FETCH cGNR_TCEXRSDE INTO vExisExcl;
         CLOSE cGNR_TCEXRSDE;
         --	
          IF vREPAABSO_TINT = 'R' THEN
             rANE_INRETC_Rec_Sea := P_ANE_INRETC.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_TINT, vSECCION_TINT, vSECCAUXI_TINT, vCF_TIPOCOST_TINT);
            --
            IF vExisExcl IS NULL THEN
               IF vEmpresa = vP_EMPRPHAR THEN
                  nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOPHAR,0);
               ELSIF vEmpresa = vP_EMPRMANV THEN
                  nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOMANV,0);
               ELSE
                  nRetorno := 0;
               END IF;        
            ELSE
               nRetorno := 0;
            END IF;
            --
            nCP_COSTRESE_TINT := NULL;
            --
            nCP_COSTUNOT_TINT := NULL;
         ELSE
              IF vINDUREPR_TINT IS NOT NULL THEN
                 nInductor := 0;
               --
               OPEN cInductor(vDEPARTAM_TINT, vSECCION_TINT, vSECCAUXI_TINT, vINDUREPR_TINT);
               FETCH cInductor INTO nInductor;
               CLOSE cInductor;
               --
               nInductor := NVL(nInductor,0);
               --
                IF vCALCPRSU_REPR_TINT = 'P' THEN
                    IF nF_CALCMEAN != 0 THEN
                      nInductor := nInductor / nF_CALCMEAN;
                    ELSE
                        nInductor := 0;
                    END IF;
                END IF; 
               --
               IF NVL(nCF_TOTAINPR_TINT,0) != 0 AND NVL(nInductor,0) != 0 THEN
                   nCostRepa := nCF_COSTSRDI_TINT;
                   --
                  FOR rSeccAuxi_Repa IN cSeccAuxi_Repa LOOP
                     rANE_INRETC_Rec_Sea := P_ANE_INRETC.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_TINT, rSeccAuxi_Repa.SECCION, rSeccAuxi_Repa.SECCAUXI, vCF_TIPOCOST_TINT);
                     --
                     IF vEmpresa = vP_EMPRPHAR THEN
                        nCostRepa := nCostRepa + NVL(rANE_INRETC_Rec_Sea.nCOTOPHAR,0);
                     ELSIF vEmpresa = vP_EMPRMANV THEN
                        nCostRepa := nCostRepa + NVL(rANE_INRETC_Rec_Sea.nCOTOMANV,0);
                     END IF;   
                  END LOOP;
                  --
                  IF nCostRepa != 0 THEN
                     nRetorno := ((nCostRepa / nCF_TOTAINPR_TINT) * nInductor);
                  END IF;
               END IF;
            ELSE
               nRetorno := nCF_COSTSRDI_TINT;
            END IF;
            --
            IF vExisExcl IS NULL THEN
               nCP_COSTRESE_TINT := nRetorno + nCF_COSTRESA_TINT;
            ELSE
               nCP_COSTRESE_TINT := nRetorno;
            END IF;
            --
            IF vINDURESE_TINT IS NOT NULL THEN
               IF vCAVAISDE_TINT = 'S' THEN
                  nInductor := 0;
                  --
                  OPEN cInductor(vDEPARTAM_TINT, vSECCION_TINT, vSECCAUXI_TINT, vINDURESE_TINT);
                  FETCH cInductor INTO nInductor;
                  CLOSE cInductor;
                  --
                  nInductor := NVL(nInductor,0);
                  --
                        IF vCALCPRSU_RESE_TINT = 'P' THEN
                            IF nF_CALCMEAN != 0 THEN
                              nInductor := nInductor / nF_CALCMEAN;
                           ELSE
                              nInductor := 0;
                           END IF;
                        END IF; 
                  --
                  IF NVL(nInductor,0) != 0 THEN
                     nCP_COSTUNOT_TINT := nCP_COSTRESE_TINT / nInductor;
                  ELSE
                     nCP_COSTUNOT_TINT := 0;
                  END IF;
               ELSE
                  IF NVL(nCF_TOTAINSE_TINT,0) != 0 THEN
                     nCP_COSTUNOT_TINT := nCP_COSTRESE_TINT / nCF_TOTAINSE_TINT;
                  ELSE
                     nCP_COSTUNOT_TINT := 0;
                  END IF;
               END IF;
               -----------------------------------------------------------------------------
               nCS_CP_SUM_COSTUNOT := NVL(nCS_CP_SUM_COSTUNOT,0) + NVL(nCP_COSTUNOT_TINT,0);
            ELSE
              nCP_COSTUNOT_TINT := NULL; 	
            END IF;
         END IF;
         --
         RETURN(nRetorno);
      END;   
   begin
      nF_CALCMEAN := F_CALCMEAN;
      --
      IF NOT (P_ANE_INRETC.F_Obtiene_AM_ALM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'))) THEN
         P_ANE_INRETC.P_BorraTabla;
         --
         P_ANE_INRETC.P_Costes_Repartidos(NULL, NULL, NULL, NULL,
                                          TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
         --
         P_ANE_INRETC.P_Adiciona_Tabla_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
      END IF;
      --
      IF NOT (P_ANE_INDRCO.F_Obtiene_AM_ALM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'))) THEN
         P_ANE_INDRCO.P_BorraTabla;
         --
         P_ANE_INDRCO.P_Departamento_Comun(vEmpresa,
                                           NULL, NULL, NULL, NULL,
                                           TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
         --
         P_ANE_INDRCO.P_Adiciona_Tabla_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
      END IF;
      --
       FOR rG_TIPOCOST IN cG_TIPOCOST LOOP
         IF rG_TIPOCOST.TIPOCOST_TINT IS NOT NULL THEN
            vCF_TIPOCOST_TINT := rG_TIPOCOST.TIPOCOST_TINT||' '||rG_TIPOCOST.DESCTICO_TINT;
         ELSE
            vCF_TIPOCOST_TINT := rG_TIPOCOST.DESCTICO_TINT;
         END IF;
           --
          FOR rG_SECCAUXI IN cG_SECCAUXI LOOP
             nCF_COSTREPR_TINT := CF_COSTREPR_TINT(rG_SECCAUXI.DEPARTAM_TINT, rG_SECCAUXI.SECCION_TINT, rG_SECCAUXI.SECCAUXI_TINT, 
                                                  rG_TIPOCOST.TIPOCOST_TINT, rG_TIPOCOST.DESCTICO_TINT,
                                                  rG_SECCAUXI.REPAABSO_TINT,
                                                  rG_SECCAUXI.INDUREPR_TINT, rG_SECCAUXI.CALCPRSU_REPR_TINT,
                                                  rG_SECCAUXI.CAVAISDE_TINT,
                                                  rG_SECCAUXI.INDURESE_TINT, rG_SECCAUXI.CALCPRSU_RESE_TINT);
          END LOOP;
       END LOOP;
       ---
      RETURN(nCS_CP_SUM_COSTUNOT);
   end;
--------------------CF_SUM_DEPARTAM-----------------
   FUNCTION CF_SUM_DEPARTAM(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, nNumero FIC_CABEOTRE.NUMERO%TYPE,
                            dFecha_Cierre DATE)
   RETURN NUMBER IS
      CURSOR cComisiones IS
         SELECT SUM((NVL(C.PORCOM,0) * NVL(F.LFIMPO,0))/100) COMISION
            FROM FV_ASVEFA02 F, FV_ASVELO01 L, FV_ASVEFA05 C
            WHERE F.EMCODI = L.EMCODI
              AND F.DICODI = L.DICODI
              AND F.ASCANA = L.ASCANA
              AND F.CFNROF = L.CFNROF
              AND C.EMCODI = L.EMCODI
              AND C.DICODI = L.DICODI
              AND C.ASCANA = L.ASCANA
              AND C.CFNROF = L.CFNROF
              AND F.CPNROP = L.CPNROP
              AND L.EMCODI = vEmpresa 
              AND L.ASLOTE = TO_CHAR(nNumero);
      --
      nComisiones NUMBER;
      --Coste Seguro de Transporte
      CURSOR cANE_CODEANNO IS
         SELECT TAANSTES FROM ANE_CODEANNO
            WHERE EMPRESA = vEmpresa
              AND ANNO = TO_CHAR(dFecha_Cierre,'YYYY');
      --
      nTAANSTES ANE_CODEANNO.TAANSTES%TYPE;
      --
      CURSOR cQ_DEPARTAM_IMPUTA IS
         SELECT DISTINCT P_UTILIDAD.f_ValoCampo(VALOR,'DEPARTAM') DEPARTAM_IMPUTA
            FROM VALORES_LISTA 
               WHERE CODIGO = 'ANE_COCDOBCO';
      --
      --Calculo de CS_CP_SUM_COSTUNOT Y CS_CP_SUM_COSTUNOT_E
      nCP_COSTRESE_DEPA NUMBER;
      nF_CALCMEAN NUMBER;
      vCF_TIPOCOST_DEPA VARCHAR2(250);
      nCF_COSTREPR_DEPA NUMBER;
      vCP_ExisTCSR_DEPA VARCHAR2(20);
      --
      CURSOR cG_TIPOCOST(vDepartam_Imputa GNR_DEPAEMPR.CODIGO%TYPE) IS
         SELECT EC.TIPOCOST TIPOCOST_DEPA, TC.TIPOCOST DESCTICO_DEPA
         FROM GNR_ESCCEMPR EC, GNR_TICOEMPR TC
         WHERE NOT EXISTS (SELECT 'X' FROM VALORES_LISTA EX WHERE EX.CODIGO = 'ANE_ESTREXCR' AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'ESTRUCTURA') = EC.ESTRUCTU)
              AND EC.TIPOCOST = TC.CODIGO(+)         
              AND EC.DEPARTAM = vP_CODECOMU
              AND EC.INDUCOMU != vP_INDUSIIN
         GROUP BY EC.TIPOCOST, TC.TIPOCOST
         UNION
         SELECT NULL TIPOCOST,  P_UTILIDAD.F_ValoCampo(EX.VALOR,'DESCRIPCION') DESCTICO
         FROM VALORES_LISTA EX, GNR_DEPAEMPR DE,GNR_SPDEEMPR SD, GNR_SEPREMPR SP, VALORES_LISTA SAU, GNR_SEAUEMPR SA
         WHERE EX.CODIGO = 'ANE_ESTREXCR'
           AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'LISTADOS') = 'S'
           AND DE.CODIGO  = vP_CODECOMU
           AND DE.CODIGO = SD.DEPARTAM
           AND SD.SECCION = SP.CODIGO
           AND SAU.CODIGO = 'GNR_RESPAURH'
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCION')= SD.SECCION
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCAUXI') = SA.CODIGO(+)
           AND vDepartam_Imputa != vP_CODEPROD
         UNION
         SELECT EC.TIPOCOST, TC.TIPOCOST DESCTICO
         FROM GNR_ESCCEMPR EC, GNR_TICOEMPR TC
         WHERE NOT EXISTS (SELECT 'X' FROM VALORES_LISTA EX WHERE EX.CODIGO = 'ANE_ESTREXCR' AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'ESTRUCTURA') = EC.ESTRUCTU)
              AND EC.TIPOCOST = TC.CODIGO(+)
              AND EC.DEPARTAM = vDepartam_Imputa
         GROUP BY EC.TIPOCOST, TC.TIPOCOST
         UNION
         SELECT NULL TIPOCOST,  P_UTILIDAD.F_ValoCampo(EX.VALOR,'DESCRIPCION') DESCTICO
         FROM VALORES_LISTA EX, GNR_DEPAEMPR DE,GNR_SPDEEMPR SD, GNR_SEPREMPR SP, VALORES_LISTA SAU, GNR_SEAUEMPR SA
         WHERE EX.CODIGO = 'ANE_ESTREXCR'
           AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'LISTADOS') = 'S'
           AND DE.CODIGO  = vDepartam_Imputa
           AND DE.CODIGO = SD.DEPARTAM
           AND SD.SECCION = SP.CODIGO
           AND SAU.CODIGO = 'GNR_RESPAURH'
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCION')= SD.SECCION
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCAUXI') = SA.CODIGO(+)
           AND vDepartam_Imputa != vP_CODEPROD;
      --
      CURSOR cG_SECCAUXI(vDepartam_Imputa GNR_SPDEEMPR.DEPARTAM%TYPE) IS
         SELECT S.DEPARTAM DEPARTAM_DEPA, D.DEPARTAM DESCDEPA_DEPA, S.SECCION SECCION_DEPA, SD.SECCION DESCSECC_DEPA, SA.SECCAUXI SECCAUXI_DEPA, SAD.SECCAUXI DESCSEAU_DEPA, D.INDUREPR INDUREPR_DEPA, SAD.REPAABSO REPAABSO_DEPA, D.INDURESE INDURESE_DEPA, ROWNUM ROWNUM_DEPA, INDP.CALCPRSU CALCPRSU_REPR_DEPA, INDS.CALCPRSU CALCPRSU_RESE_DEPA, D.CAVAISDE CAVAISDE_DEPA, SAD.INREOBCO INREOBCO_DEPA, INDP.INDUCTOR DEINREPR_DEPA
         FROM GNR_SPDEEMPR S, GNR_SASPEMPR SA, GNR_SEAUEMPR SAD, GNR_DEPAEMPR D, GNR_SEPREMPR SD, GNR_INDUEMPR INDP, GNR_INDUEMPR INDS
            WHERE S.SECCION = SA.SECCION
              AND S.SECCION = SD.CODIGO
              AND SA.SECCAUXI = SAD.CODIGO
              AND S.DEPARTAM = D.CODIGO
              AND D.INDUREPR = INDP.CODIGO(+)
              AND D.INDURESE = INDS.CODIGO(+)
              AND S.DEPARTAM = vDepartam_Imputa
         ORDER BY SAD.REPAABSO DESC, S.DEPARTAM, S.SECCION, SA.SECCAUXI;
      --
      FUNCTION F_CALCMEAN RETURN NUMBER IS
         nRetorno NUMBER := 0;
      begin
          IF TO_CHAR(dFecha_Cierre,'YYYY') <= TO_CHAR(dFecha_Cierre,'YYYY') THEN 
              FOR vAnno IN TO_CHAR(dFecha_Cierre,'YYYY')..TO_CHAR(dFecha_Cierre,'YYYY') LOOP
                IF vAnno = TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno = TO_CHAR(dFecha_Cierre,'YYYY') THEN
                    nRetorno := nRetorno + ((TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM'))) + 1);
                ELSIF vAnno = TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno != TO_CHAR(dFecha_Cierre,'YYYY') THEN                                      
                   nRetorno := nRetorno + ((TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||'12') - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM'))) + 1);
                ELSIF vAnno != TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno = TO_CHAR(dFecha_Cierre,'YYYY') THEN      
                   nRetorno := nRetorno + (TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||'00'));
                ELSIF vAnno != TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno != TO_CHAR(dFecha_Cierre,'YYYY') THEN
                   nRetorno := nRetorno + 12;
                ELSE
                   nRetorno := nRetorno + 0;
                END IF;
             END LOOP;
          END IF;
         --
         RETURN nRetorno;
      END;
      --
      FUNCTION CF_COSTSRDI_DEPA(vDEPARTAM_DEPA GNR_SPDEEMPR.DEPARTAM%TYPE) return Number is
         rANE_INDRCO_Rec_Dep P_ANE_INDRCO.St_ANE_INDRCO_AM;
      begin
         rANE_INDRCO_Rec_Dep := P_ANE_INDRCO.F_ObtieneCosteSubrepDepto_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, vCF_TIPOCOST_DEPA);
         --
         RETURN(rANE_INDRCO_Rec_Dep.nCoste);
      END;
      --
      FUNCTION CF_COSTRESA_DEPA(vDEPARTAM_DEPA GNR_SPDEEMPR.DEPARTAM%TYPE, vSECCION_DEPA GNR_SPDEEMPR.SECCION%TYPE, vSECCAUXI_DEPA GNR_SASPEMPR.SECCAUXI%TYPE) return Number is
         rANE_INRETC_Rec_Sea P_ANE_INRETC.St_ANE_INRETC_AM;
         nRetorno NUMBER;
      BEGIN
         rANE_INRETC_Rec_Sea := P_ANE_INRETC.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vCF_TIPOCOST_DEPA);
         --
         IF vEmpresa = vP_EMPRPHAR THEN
            nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOPHAR,0);
         ELSIF vEmpresa = vP_EMPRMANV THEN
            nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOMANV,0);
         ELSE           
            nRetorno := 0;
         END IF;
         --
        RETURN(nRetorno);
      END;
      --
      FUNCTION CF_TOTAINPR_DEPA(vINDUREPR_DEPA GNR_DEPAEMPR.INDUREPR%TYPE, vCALCPRSU_REPR_DEPA GNR_INDUEMPR.CALCPRSU%TYPE,
                                vTIPOCOST_DEPA GNR_TICOEMPR.TIPOCOST%TYPE,
                                vDEPARTAM_DEPA GNR_SPDEEMPR.DEPARTAM%TYPE) return Number is
         CURSOR cInductor_Tot IS
            SELECT SUM(VALOR) SUMA
               FROM ANE_COISSSRE
                  WHERE EMPRESA = vEmpresa
                    AND INDUCTOR = vINDUREPR_DEPA
                    AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
                  AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'));
         --
         nInductor_Tot NUMBER := 0;
   -->Solo para Departamento de Produccion
         CURSOR cInductor_Tot_Pro(vInductor GNR_INDUEMPR.CODIGO%TYPE) IS
               SELECT SUM(VALOR) SUMA
                  FROM ANE_COISSSRE
                     WHERE EMPRESA = vEmpresa
                       AND INDUCTOR = vInductor
                       AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12')) 
                     AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12'));
         --
         vInductor_Pro GNR_INDUEMPR.CODIGO%TYPE;
         --Tipos de Coste Subrepartidos con el Inductor Auxiliar Primario (Solo para listado de Depto. Produccion)
         CURSOR cANE_TICOSRIA_Pro IS
            SELECT 'X' FROM VALORES_LISTA 
               WHERE CODIGO = 'ANE_TICOSRIA'
                 AND VALOR = vTIPOCOST_DEPA;
         --
         vExisTCSR_IndAux_Pro VARCHAR2(1);       
      begin
         --Listado de Departamentales normal
         IF vDEPARTAM_DEPA != vP_CODEPROD THEN
            IF vINDUREPR_DEPA IS NOT NULL THEN
               nInductor_Tot := 0;
               --
               OPEN cInductor_Tot;
               FETCH cInductor_Tot INTO nInductor_Tot;
               CLOSE cInductor_Tot;
               --
               nInductor_Tot := NVL(nInductor_Tot,0);
               --
               IF vCALCPRSU_REPR_DEPA = 'P' THEN
                  IF nF_CALCMEAN != 0 THEN
                     nInductor_Tot := nInductor_Tot / nF_CALCMEAN;
                  ELSE
                     nInductor_Tot := 0;
                  END IF;
               END IF;   
            END IF;
         ELSE
            OPEN cANE_TICOSRIA_Pro;
            FETCH cANE_TICOSRIA_Pro INTO vExisTCSR_IndAux_Pro;
            CLOSE cANE_TICOSRIA_Pro;
            --
            vCP_ExisTCSR_DEPA := vExisTCSR_IndAux_Pro;
            --
            IF vExisTCSR_IndAux_Pro IS NULL THEN	
               vInductor_Pro := vINDUREPR_DEPA;
            ELSE                      
               vInductor_Pro := vP_IRPIPTCS;
            END IF;
            --
            IF vInductor_Pro IS NOT NULL THEN
               nInductor_Tot := 0;
               --
               OPEN cInductor_Tot_Pro(vInductor_Pro);
               FETCH cInductor_Tot_Pro INTO nInductor_Tot;
               CLOSE cInductor_Tot_Pro;
               --
               nInductor_Tot := NVL(nInductor_Tot,0);
               --
               IF vCALCPRSU_REPR_DEPA = 'P' THEN
                  IF nF_CALCMEAN != 0 THEN
                     nInductor_Tot := nInductor_Tot / nF_CALCMEAN;
                  ELSE
                     nInductor_Tot := 0;
                  END IF;
               END IF;   
            END IF;	 
         END IF;
         --
         RETURN(nInductor_Tot);     
      end;
      --
      FUNCTION CF_TOTAINSE_DEPA(vINDURESE_DEPA GNR_DEPAEMPR.INDURESE%TYPE, vCALCPRSU_RESE_DEPA GNR_INDUEMPR.CALCPRSU%TYPE) return Number is
         CURSOR cInductor_Tot IS
            SELECT SUM(VALOR) SUMA
               FROM ANE_COISSSRE
                  WHERE EMPRESA = vEmpresa
                    AND INDUCTOR = vINDURESE_DEPA
                    AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
                  AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'));
         --
         nInductor_Tot NUMBER := 0;
      begin
          IF vINDURESE_DEPA IS NOT NULL THEN
            nInductor_Tot := 0;
            --
            OPEN cInductor_Tot;
            FETCH cInductor_Tot INTO nInductor_Tot;
            CLOSE cInductor_Tot;
            --
            nInductor_Tot := NVL(nInductor_Tot,0);
            --
             IF vCALCPRSU_RESE_DEPA = 'P' THEN
                 IF nF_CALCMEAN != 0 THEN
                   nInductor_Tot := nInductor_Tot / nF_CALCMEAN;
                 ELSE
                    nInductor_Tot := 0;
                 END IF;
             END IF;   
         END IF;   	
         --
         RETURN(nInductor_Tot);     
      END;
      --
      FUNCTION CF_COSTREPR_DEPA(vDEPARTAM_DEPA GNR_SPDEEMPR.DEPARTAM%TYPE, vSECCION_DEPA GNR_SPDEEMPR.SECCION%TYPE, vSECCAUXI_DEPA GNR_SASPEMPR.SECCAUXI%TYPE, 
                                vTIPOCOST_DEPA GNR_ESCCEMPR.TIPOCOST%TYPE, vDESCTICO_DEPA GNR_TICOEMPR.TIPOCOST%TYPE,
                                vREPAABSO_DEPA GNR_SEAUEMPR.REPAABSO%TYPE,
                                vINDUREPR_DEPA GNR_DEPAEMPR.INDUREPR%TYPE, vCALCPRSU_REPR_DEPA GNR_INDUEMPR.CALCPRSU%TYPE,
                                vCAVAISDE_DEPA GNR_DEPAEMPR.CAVAISDE%TYPE,
                                vINDURESE_DEPA GNR_DEPAEMPR.INDURESE%TYPE, vCALCPRSU_RESE_DEPA GNR_INDUEMPR.CALCPRSU%TYPE,
                                vINREOBCO_DEPA GNR_SEAUEMPR.INREOBCO%TYPE) return Number is
         rANE_INRETC_Rec_Sea P_ANE_INRETC.St_ANE_INRETC_AM;
         --
         nRetorno NUMBER := 0;
         --
         CURSOR cSeccAuxi_Repa IS
            SELECT S.SECCION, SA.SECCAUXI 
               FROM GNR_SPDEEMPR S, GNR_SASPEMPR SA, GNR_SEAUEMPR SAD, GNR_DEPAEMPR D
               WHERE S.SECCION = SA.SECCION
                 AND SA.SECCAUXI = SAD.CODIGO
                 AND S.DEPARTAM = D.CODIGO
                 AND S.DEPARTAM = vDEPARTAM_DEPA
                 AND SAD.REPAABSO = 'R';
         --
         CURSOR cInductor(vDepartam ANE_COISSSRE.DEPARTAM%TYPE, vSeccion ANE_COISSSRE.SECCION%TYPE, vSeccAuxi ANE_COISSSRE.SECCAUXI%TYPE, vInductor ANE_COISSSRE.INDUCTOR%TYPE) IS
            SELECT SUM(VALOR) SUMA
               FROM ANE_COISSSRE
                  WHERE EMPRESA = vEmpresa
                    AND DEPARTAM = vDepartam
                    AND SECCION = vSeccion
                    AND SECCAUXI = vSeccAuxi
                    AND INDUCTOR = vInductor
                    AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
                  AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'));
         --
         nInductor NUMBER := 0;
         --
         nCostRepa NUMBER;
         --
         CURSOR cGNR_TCEXRSDE IS
            SELECT 'X' FROM GNR_TCEXRSDE EX, GNR_TICOEMPR TC
               WHERE EX.TIPOCOST = TC.CODIGO
                 AND DEPARTAM = vDEPARTAM_DEPA
                 AND (
                      (vTIPOCOST_DEPA IS NOT NULL AND EX.TIPOCOST = vTIPOCOST_DEPA) OR
                      (vTIPOCOST_DEPA IS NULL AND EX.TIPOCOST||' '||TC.TIPOCOST = vDESCTICO_DEPA)
                     );
         --
         vExisExcl VARCHAR2(1);
         --Cursor de Imputaciones
         CURSOR cImputa IS
            SELECT P_UTILIDAD.f_ValoCampo(VALOR,'IMPUTA') IMPUTA
               FROM VALORES_LISTA 
                  WHERE CODIGO = 'ANE_COCDOBCO'
                    AND P_UTILIDAD.f_ValoCampo(VALOR,'DEPARTAM') = vDEPARTAM_DEPA
                    AND P_UTILIDAD.f_ValoCampo(VALOR,'SECCION') = vSECCION_DEPA
                    AND P_UTILIDAD.f_ValoCampo(VALOR,'SECCAUXI') = vSECCAUXI_DEPA;
         --
         vImputa VALORES_LISTA.VALOR%TYPE;
         --Busca las maquinas de la OT para imputar costes sobre producción
         CURSOR cMaquina(vMaquina VARCHAR2) IS
            SELECT 'X'
               FROM FIC_LINEOTRE O
               WHERE O.EMPRESA = vEmpresa
                 AND O.NUMERO = nNumero
                 AND O.ANNO = SUBSTR(nNumero,1,4)
                 AND O.COD_ARES LIKE vMaquina||'%';
         --
         vExisMaqu VARCHAR2(1);          
   -->Departamento de Produccion
         --
         nInductor_INAXREPR NUMBER := 0;
         vInductor_INAXREPR GNR_INDUEMPR.INDUCTOR%TYPE;
         --
         CURSOR cInductor_Pro(vDepartam ANE_COISSSRE.DEPARTAM%TYPE, vSeccion ANE_COISSSRE.SECCION%TYPE, vSeccAuxi ANE_COISSSRE.SECCAUXI%TYPE, vInductor ANE_COISSSRE.INDUCTOR%TYPE) IS
               SELECT IND.CALCPRSU, IND.INDUCTOR, SUM(V.VALOR) SUMA
                  FROM ANE_COISSSRE V, GNR_INDUEMPR IND
                     WHERE V.INDUCTOR = IND.CODIGO(+)
                       AND V.EMPRESA = vEmpresa
                       AND V.DEPARTAM = vDepartam
                       AND V.SECCION = vSeccion
                       AND V.SECCAUXI = vSeccAuxi
                       AND V.INDUCTOR = vInductor
                       AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(V.ANNO||DECODE(V.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12')) 
                       AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(V.ANNO||DECODE(V.MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12'))
               GROUP BY IND.CALCPRSU, IND.INDUCTOR;
         --
         vCALCPRSU GNR_INDUEMPR.CALCPRSU%TYPE;
         vINDUCTOR GNR_INDUEMPR.INDUCTOR%TYPE;
         --
         CURSOR cInductor_Rep_OC_Man IS
               SELECT IND.CALCPRSU, SUM(V.VALOR) SUMA
                  FROM ANE_COISSSRE V, GNR_INDUEMPR IND
                     WHERE V.INDUCTOR = IND.CODIGO(+)
                       AND V.EMPRESA = vEmpresa
                       AND V.INDUCTOR = vINREOBCO_DEPA
                       AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12')) 
                       AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                              'DICIEMBRE','12'))
               GROUP BY IND.CALCPRSU;
         --
         nInductor_Rep_OC_Man NUMBER := 0;
         vCALCPRSU_Rep_OC_Man GNR_INDUEMPR.CALCPRSU%TYPE;
         -- 
         nCP_COSTUNOT_DEPA NUMBER;
         nCF_TOTAINPR_DEPA NUMBER := NVL(CF_TOTAINPR_DEPA(vINDUREPR_DEPA, vCALCPRSU_REPR_DEPA, vTIPOCOST_DEPA, vDEPARTAM_DEPA),0);
         nCF_COSTRESA_DEPA NUMBER := NVL(CF_COSTRESA_DEPA(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA),0);
         nCF_COSTSRDI_DEPA NUMBER := NVL(CF_COSTSRDI_DEPA(vDEPARTAM_DEPA),0);
         nCF_TOTAINSE_DEPA NUMBER := NVL(CF_TOTAINSE_DEPA(vINDURESE_DEPA, vCALCPRSU_RESE_DEPA),0);
         nCP_INDUPRIN_DEPA NUMBER;
      BEGIN
         --Listado de Departamentales normal
         IF vDEPARTAM_DEPA != vP_CODEPROD THEN
            vExisExcl := NULL;
            --
            OPEN cGNR_TCEXRSDE;
            FETCH cGNR_TCEXRSDE INTO vExisExcl;
            CLOSE cGNR_TCEXRSDE;
            --	
             IF vREPAABSO_DEPA = 'R' THEN
                rANE_INRETC_Rec_Sea := P_ANE_INRETC.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vCF_TIPOCOST_DEPA);
               --
               IF vExisExcl IS NULL THEN
                  IF vEmpresa = vP_EMPRPHAR THEN
                     nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOPHAR,0);
                  ELSIF vEmpresa = vP_EMPRMANV THEN
                     nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOMANV,0);
                  ELSE
                     nRetorno := 0;
                  END IF;        
               ELSE
                  nRetorno := 0;
               END IF;
               --
               nCP_COSTRESE_DEPA := NULL;
               --
               nCP_COSTUNOT_DEPA := NULL;
            ELSE
                 IF vINDUREPR_DEPA IS NOT NULL THEN
                    nInductor := 0;
                  --
                  OPEN cInductor(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vINDUREPR_DEPA);
                  FETCH cInductor INTO nInductor;
                  CLOSE cInductor;
                  --
                  nInductor := NVL(nInductor,0);
                  --
                   IF vCALCPRSU_REPR_DEPA = 'P' THEN
                       IF nF_CALCMEAN != 0 THEN
                         nInductor := nInductor / nF_CALCMEAN;
                       ELSE
                           nInductor := 0;
                       END IF;
                   END IF; 
                  --
                  IF NVL(nCF_TOTAINPR_DEPA,0) != 0 AND NVL(nInductor,0) != 0 THEN
                      nCostRepa := nCF_COSTSRDI_DEPA;
                      --
                     FOR rSeccAuxi_Repa IN cSeccAuxi_Repa LOOP
                        rANE_INRETC_Rec_Sea := P_ANE_INRETC.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, rSeccAuxi_Repa.SECCION, rSeccAuxi_Repa.SECCAUXI, vCF_TIPOCOST_DEPA);
                        --
                        IF vEmpresa = vP_EMPRPHAR THEN
                           nCostRepa := nCostRepa + NVL(rANE_INRETC_Rec_Sea.nCOTOPHAR,0);
                        ELSIF vEmpresa = vP_EMPRMANV THEN
                           nCostRepa := nCostRepa + NVL(rANE_INRETC_Rec_Sea.nCOTOMANV,0);
                        END IF;   
                     END LOOP;
                     --
                     IF nCostRepa != 0 THEN
                        nRetorno := ((nCostRepa / nCF_TOTAINPR_DEPA) * nInductor);
                     END IF;
                  END IF;
               ELSE
                  nRetorno := nCF_COSTSRDI_DEPA;
               END IF;
               --
               IF vExisExcl IS NULL THEN
                  nCP_COSTRESE_DEPA := nRetorno + nCF_COSTRESA_DEPA;
               ELSE
                  nCP_COSTRESE_DEPA := nRetorno;
               END IF;
               --
               IF vINDURESE_DEPA IS NOT NULL THEN
                  IF vCAVAISDE_DEPA = 'S' THEN
                     nInductor := 0;
                     --
                     OPEN cInductor(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vINDURESE_DEPA);
                     FETCH cInductor INTO nInductor;
                     CLOSE cInductor;
                     --
                     nInductor := NVL(nInductor,0);
                     --
                           IF vCALCPRSU_RESE_DEPA = 'P' THEN
                               IF nF_CALCMEAN != 0 THEN
                                 nInductor := nInductor / nF_CALCMEAN;
                              ELSE
                                 nInductor := 0;
                              END IF;
                           END IF; 
                     --
                     IF NVL(nInductor,0) != 0 THEN
                        nCP_COSTUNOT_DEPA := nCP_COSTRESE_DEPA / nInductor;
                     ELSE
                        nCP_COSTUNOT_DEPA := 0;
                     END IF;
                  ELSE
                     IF NVL(nCF_TOTAINSE_DEPA,0) != 0 THEN
                        nCP_COSTUNOT_DEPA := nCP_COSTRESE_DEPA / nCF_TOTAINSE_DEPA;
                     ELSE
                        nCP_COSTUNOT_DEPA := 0;
                     END IF;
                  END IF;
                  -----------------------------------------------------------------------------
                  OPEN cImputa;
                  FETCH cImputa INTO vImputa;
                  CLOSE cImputa;
                  --
                  IF vImputa = 'COSTES ADMINISTRATIVOS' THEN           
                     nCP_SUM_COSTADMI_R := NVL(nCP_SUM_COSTADMI_R,0) +NVL(nCP_COSTUNOT_DEPA,0);
                  ELSIF vImputa = 'COSTES DE COMERCIALIZACIÓN' THEN
                     --Si es Nacional ó Exportacion
                     IF (vSECCAUXI_DEPA = vP_COSACONA AND vCP_TIPOPEDI = 'N') OR (vSECCAUXI_DEPA = vP_COSACOEX AND vCP_TIPOPEDI = 'E') THEN
                        nCP_SUM_COSTCOME_R := NVL(nCP_SUM_COSTCOME_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                     END IF;
                     --
                     --:CP_SUM_COSTCOME_R := NVL(:CP_SUM_COSTCOME_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                  ELSIF vImputa = 'COSTES DE DISTRIBUCIÓN' THEN
                     nCP_SUM_COSTDIST_R := NVL(nCP_SUM_COSTDIST_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                  ELSIF vImputa = 'LOGÍSTICA INTERNA' THEN
                     nCP_SUM_LOGIINTE_R := NVL(nCP_SUM_LOGIINTE_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                  ELSIF vImputa = 'ALMACÉN' THEN
                     nCP_SUM_ALMACEN_R := NVL(nCP_SUM_ALMACEN_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                  ELSIF vImputa = 'OTROS COSTES DE PRODUCCIÓN' THEN
                     nCP_SUM_OTROCOST_R := NVL(nCP_SUM_OTROCOST_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                  ELSIF vImputa = 'CALIDAD' THEN
                     nCP_SUM_CALIDAD_R := NVL(nCP_SUM_CALIDAD_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                  END IF;
               ELSE
                 nCP_COSTUNOT_DEPA := NULL; 	
               END IF;
            END IF;
   --Departamento de Produccion
         ELSE
            vExisExcl := NULL;
            --
            OPEN cGNR_TCEXRSDE;
            FETCH cGNR_TCEXRSDE INTO vExisExcl;
            CLOSE cGNR_TCEXRSDE;
            --	
            IF vREPAABSO_DEPA = 'R' THEN
               rANE_INRETC_Rec_Sea := P_ANE_INRETC.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vCF_TIPOCOST_DEPA);
               --
               IF vExisExcl IS NULL THEN
                  IF vEmpresa = vP_EMPRPHAR THEN
                     nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOPHAR,0);
                  ELSIF vEmpresa = vP_EMPRMANV THEN
                     nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOMANV,0);
                  ELSE
                     nRetorno := 0;
                  END IF;        
               ELSE
                  nRetorno := 0;
               END IF;
               --
               nCP_COSTRESE_DEPA := NULL;
               --
               nCP_INDUPRIN_DEPA := NULL;
               --
               nCP_COSTUNOT_DEPA := NULL;
            ELSE
               IF vINDUREPR_DEPA IS NOT NULL THEN
                  nInductor := 0;
                  vCALCPRSU := NULL;
                  vINDUCTOR := NULL;
                  --
                  OPEN cInductor_Pro(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vINDUREPR_DEPA);
                  FETCH cInductor_Pro INTO vCALCPRSU,vINDUCTOR, nInductor;
                  CLOSE cInductor_Pro;
                  --
                  nInductor := NVL(nInductor,0);
                  --
                  IF vCALCPRSU_REPR_DEPA = 'P' THEN
                     IF nF_CALCMEAN != 0 THEN
                        nInductor := nInductor / nF_CALCMEAN;
                     ELSE
                        nInductor := 0;
                     END IF;
                  END IF;
                  --
                  IF vP_IRPIPTCS IS NOT NULL THEN
                     nInductor_INAXREPR := 0;
                     vInductor_INAXREPR := NULL;
                     --
                     vCALCPRSU := NULL;
                     --
                     OPEN cInductor_Pro(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vP_IRPIPTCS);
                     FETCH cInductor_Pro INTO vCALCPRSU, vInductor_INAXREPR, nInductor_INAXREPR;
                     CLOSE cInductor_Pro;
                     --
                     nInductor_INAXREPR := NVL(nInductor_INAXREPR,0);
                     --
                     IF vCALCPRSU = 'P' THEN
                        IF nF_CALCMEAN != 0 THEN
                           nInductor_INAXREPR := nInductor_INAXREPR / nF_CALCMEAN;
                        ELSE
                           nInductor_INAXREPR := 0;
                        END IF;
                     END IF;
                  END IF;
                  --
                  IF vCP_ExisTCSR_DEPA IS NULL THEN
                     nCP_INDUPRIN_DEPA := nInductor;
                  ELSE 
                     nCP_INDUPRIN_DEPA := nInductor_INAXREPR;
                  END IF;
                  --
                  IF NVL(nCF_TOTAINPR_DEPA,0) != 0 AND NVL(nCP_INDUPRIN_DEPA,0) != 0 THEN	
                     nCostRepa := nCF_COSTSRDI_DEPA;
                     --
                     FOR rSeccAuxi_Repa IN cSeccAuxi_Repa LOOP
                        rANE_INRETC_Rec_Sea := P_ANE_INRETC.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, rSeccAuxi_Repa.SECCION, rSeccAuxi_Repa.SECCAUXI, vCF_TIPOCOST_DEPA);
                        --
                        IF vEmpresa = vP_EMPRPHAR THEN
                           nCostRepa := nCostRepa + NVL(rANE_INRETC_Rec_Sea.nCOTOPHAR,0);
                        ELSIF vEmpresa = vP_EMPRMANV THEN
                           nCostRepa := nCostRepa + NVL(rANE_INRETC_Rec_Sea.nCOTOMANV,0);
                        END IF;   
                     END LOOP;
                     --
                     IF nCostRepa != 0 THEN
                        nRetorno := ((nCostRepa / nCF_TOTAINPR_DEPA) * nCP_INDUPRIN_DEPA);
                     END IF;
                  END IF;
               ELSE
                  nRetorno := nCF_COSTSRDI_DEPA;
                  --
                  nCP_INDUPRIN_DEPA := NULL;
               END IF;
               --
               IF vExisExcl IS NULL THEN
                  nCP_COSTRESE_DEPA := nRetorno + nCF_COSTRESA_DEPA;
               ELSE
                  nCP_COSTRESE_DEPA := nRetorno;
               END IF;
               --
               IF vINDURESE_DEPA IS NOT NULL THEN
                  IF vCAVAISDE_DEPA = 'S' THEN
                     IF vINREOBCO_DEPA IS NULL THEN
                        nInductor := 0;
                        vCALCPRSU := NULL;
                        vINDUCTOR := NULL;
                        --
                        OPEN cInductor_Pro(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vINDURESE_DEPA);
                        FETCH cInductor_Pro INTO vCALCPRSU, vINDUCTOR, nInductor;
                        CLOSE cInductor_Pro;
                        --
                        nInductor := NVL(nInductor,0);
                        --
                        IF vCALCPRSU_RESE_DEPA = 'P' THEN
                           IF nF_CALCMEAN != 0 THEN
                              nInductor := nInductor / nF_CALCMEAN;
                           ELSE
                              nInductor := 0;
                           END IF;
                        END IF;
                        --
                        IF NVL(nInductor,0) != 0 THEN
                           nCP_COSTUNOT_DEPA := nCP_COSTRESE_DEPA / nInductor;
                        ELSE
                           nCP_COSTUNOT_DEPA := 0;
                        END IF;
                     ELSE --Inductor de Reparto al Objetivo de Coste Definido Manualmente
                        nInductor_Rep_OC_Man := 0;
                        vCALCPRSU_Rep_OC_Man := NULL;
                        --
                        OPEN cInductor_Rep_OC_Man;
                        FETCH cInductor_Rep_OC_Man INTO vCALCPRSU_Rep_OC_Man, nInductor_Rep_OC_Man;
                        CLOSE cInductor_Rep_OC_Man;
                        --
                        nInductor_Rep_OC_Man := NVL(nInductor_Rep_OC_Man,0);
                        --
                        IF vCALCPRSU_Rep_OC_Man = 'P' THEN
                           IF nF_CALCMEAN != 0 THEN
                              nInductor_Rep_OC_Man := nInductor_Rep_OC_Man / nF_CALCMEAN;
                           ELSE
                              nInductor_Rep_OC_Man := 0;
                           END IF;
                        END IF;
                        --
                        IF NVL(nInductor_Rep_OC_Man,0) != 0 THEN
                           nCP_COSTUNOT_DEPA := nCP_COSTRESE_DEPA / nInductor_Rep_OC_Man;
                        ELSE
                           nCP_COSTUNOT_DEPA := 0;
                        END IF;
                     END IF;   	
                  ELSE
                     IF NVL(nCF_TOTAINSE_DEPA,0) != 0 THEN
                        nCP_COSTUNOT_DEPA := nCP_COSTRESE_DEPA / nCF_TOTAINSE_DEPA;
                     ELSE
                        nCP_COSTUNOT_DEPA := 0;
                     END IF;
                  END IF;
                  --
                  OPEN cImputa;
                  FETCH cImputa INTO vImputa;
                  CLOSE cImputa;
                  --
                  IF INSTR(vP_SEAUIMPR,'['||vSECCAUXI_DEPA||']') != 0 THEN
                     OPEN cMaquina('IMPRESORA');
                     FETCH cMaquina INTO vExisMaqu;
                     CLOSE cMaquina;
                  ELSIF INSTR(vP_SEAULAMI,'['||vSECCAUXI_DEPA||']') != 0 THEN
                     OPEN cMaquina('LAMINADORA');
                     FETCH cMaquina INTO vExisMaqu;
                     CLOSE cMaquina;
                  ELSIF INSTR(vP_SEAULAQU,'['||vSECCAUXI_DEPA||']') != 0 THEN
                     OPEN cMaquina('LAQUEADORA');
                     FETCH cMaquina INTO vExisMaqu;
                     CLOSE cMaquina;
                  ELSIF INSTR(vP_SEAUCORT,'['||vSECCAUXI_DEPA||']') != 0 THEN
                     OPEN cMaquina('CORTADORA');
                     FETCH cMaquina INTO vExisMaqu;
                     CLOSE cMaquina;
                  END IF;
                  --
                  IF vExisMaqu IS NOT NULL THEN
                     IF vImputa = 'COSTES ADMINISTRATIVOS' THEN           
                        nCP_SUM_COSTADMI_R := NVL(nCP_SUM_COSTADMI_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                     ELSIF vImputa = 'COSTES DE COMERCIALIZACIÓN' THEN
                        --Si es Nacional ó Exportacion
                        IF (vSECCAUXI_DEPA = vP_COSACONA AND vCP_TIPOPEDI = 'N') OR (vSECCAUXI_DEPA = vP_COSACOEX AND vCP_TIPOPEDI = 'E') THEN
                           nCP_SUM_COSTCOME_R := NVL(nCP_SUM_COSTCOME_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                        END IF;
                        --
                        --:CP_SUM_COSTCOME_R := NVL(:CP_SUM_COSTCOME_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                     ELSIF vImputa = 'COSTES DE DISTRIBUCIÓN' THEN
                        nCP_SUM_COSTDIST_R := NVL(nCP_SUM_COSTDIST_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                     ELSIF vImputa = 'LOGÍSTICA INTERNA' THEN
                        nCP_SUM_LOGIINTE_R := NVL(nCP_SUM_LOGIINTE_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                     ELSIF vImputa = 'ALMACÉN' THEN
                        nCP_SUM_ALMACEN_R := NVL(nCP_SUM_ALMACEN_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                     ELSIF vImputa = 'OTROS COSTES DE PRODUCCIÓN' THEN
                        nCP_SUM_OTROCOST_R := NVL(nCP_SUM_OTROCOST_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                     ELSIF vImputa = 'CALIDAD' THEN
                        nCP_SUM_CALIDAD_R := NVL(nCP_SUM_CALIDAD_R,0) + NVL(nCP_COSTUNOT_DEPA,0);
                     END IF;
                  END IF;
               ELSE
                  nCP_COSTUNOT_DEPA := NULL; 	
               END IF;
            END IF;
         END IF;
         --
         RETURN(nRetorno);
      END;   
   begin
      --Se inician los costes de comercialización con las comisiones.
      OPEN cComisiones;
      FETCH cComisiones INTO nComisiones;
      CLOSE cComisiones;
      --
      nCP_SUM_COSTCOME_R := NVL(nCP_SUM_COSTCOME_R,0) + nComisiones;
       --Coste de Distribucion y Transporte
      OPEN cANE_CODEANNO;
      FETCH cANE_CODEANNO INTO nTAANSTES;
      CLOSE cANE_CODEANNO;
      --
      nCP_SUM_COSTDIST_R := NVL(nCP_SUM_COSTDIST_R,0) + (NVL(nCP_PRECIO_FAC,0) * NVL(nTAANSTES,0));
      --
      nF_CALCMEAN := F_CALCMEAN;
      --
      IF NOT (P_ANE_INRETC.F_Obtiene_AM_ALM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'))) THEN
         P_ANE_INRETC.P_BorraTabla;
         --
         P_ANE_INRETC.P_Costes_Repartidos(NULL, NULL, NULL, NULL,
                                          TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
         --
         P_ANE_INRETC.P_Adiciona_Tabla_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
      END IF;
      --
      IF NOT (P_ANE_INDRCO.F_Obtiene_AM_ALM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'))) THEN
         P_ANE_INDRCO.P_BorraTabla;
         --
         P_ANE_INDRCO.P_Departamento_Comun(vEmpresa,
                                           NULL, NULL, NULL, NULL,
                                           TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
         --
         P_ANE_INDRCO.P_Adiciona_Tabla_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
      END IF;
      --
      FOR rQ_DEPARTAM_IMPUTA IN cQ_DEPARTAM_IMPUTA LOOP
        FOR rG_TIPOCOST IN cG_TIPOCOST(rQ_DEPARTAM_IMPUTA.DEPARTAM_IMPUTA) LOOP
            IF rG_TIPOCOST.TIPOCOST_DEPA IS NOT NULL THEN
               vCF_TIPOCOST_DEPA := rG_TIPOCOST.TIPOCOST_DEPA||' '||rG_TIPOCOST.DESCTICO_DEPA;
            ELSE
               vCF_TIPOCOST_DEPA := rG_TIPOCOST.DESCTICO_DEPA;
            END IF;
             --
            FOR rG_SECCAUXI IN cG_SECCAUXI(rQ_DEPARTAM_IMPUTA.DEPARTAM_IMPUTA) LOOP
               nCF_COSTREPR_DEPA := CF_COSTREPR_DEPA(rG_SECCAUXI.DEPARTAM_DEPA, rG_SECCAUXI.SECCION_DEPA, rG_SECCAUXI.SECCAUXI_DEPA, 
                                                     rG_TIPOCOST.TIPOCOST_DEPA, rG_TIPOCOST.DESCTICO_DEPA,
                                                     rG_SECCAUXI.REPAABSO_DEPA,
                                                     rG_SECCAUXI.INDUREPR_DEPA, rG_SECCAUXI.CALCPRSU_REPR_DEPA,
                                                     rG_SECCAUXI.CAVAISDE_DEPA,
                                                     rG_SECCAUXI.INDURESE_DEPA, rG_SECCAUXI.CALCPRSU_RESE_DEPA,
                                                     rG_SECCAUXI.INREOBCO_DEPA);
            END LOOP;
         END LOOP;
      END LOOP;
      --
      RETURN(NULL);
   END;
--------------------CF_SUM_DEPARTAM_E
   FUNCTION CF_SUM_DEPARTAM_E(vEmpresa FIC_CABEOTRE.EMPRESA%TYPE, nNumero FIC_CABEOTRE.NUMERO%TYPE,
                              dFecha_Cierre DATE)
   RETURN NUMBER IS
      CURSOR cComisiones IS
         SELECT SUM((NVL(C.PORCOM,0) * NVL(F.LFIMPO,0))/100) COMISION
            FROM FV_ASVEFA02 F, FV_ASVELO01 L, FV_ASVEFA05 C
            WHERE F.EMCODI = L.EMCODI
              AND F.DICODI = L.DICODI
              AND F.ASCANA = L.ASCANA
              AND F.CFNROF = L.CFNROF
              AND C.EMCODI = L.EMCODI
              AND C.DICODI = L.DICODI
              AND C.ASCANA = L.ASCANA
              AND C.CFNROF = L.CFNROF
              AND F.CPNROP = L.CPNROP
              AND L.EMCODI = vEmpresa 
              AND L.ASLOTE = TO_CHAR(nNumero);
      --
      nComisiones NUMBER;
      --Coste Seguro de Transporte
      CURSOR cANE_CODEANNO IS
         SELECT TAANSTES FROM ANE_CODEANNO
            WHERE EMPRESA = vEmpresa
              AND ANNO = TO_CHAR(dFecha_Cierre,'YYYY');
      --
      nTAANSTES ANE_CODEANNO.TAANSTES%TYPE;
      --
      CURSOR cQ_DEPARTAM_IMPUTA IS
         SELECT DISTINCT P_UTILIDAD.f_ValoCampo(VALOR,'DEPARTAM') DEPARTAM_IMPUTA
            FROM VALORES_LISTA 
               WHERE CODIGO = 'ANE_COCDOBCO';
      --
      --Calculo de CS_CP_SUM_COSTUNOT Y CS_CP_SUM_COSTUNOT_E
      nCP_COSTRESE_DEPA_E NUMBER;
      nF_CALCMEAN NUMBER;
      vCF_TIPOCOST_DEPA_E VARCHAR2(250);
      nCF_COSTREPR_DEPA_E NUMBER;
      vCP_ExisTCSR_DEPA_E VARCHAR2(20);
      --
      CURSOR cG_TIPOCOST(vDepartam_Imputa GNR_DEPAEMPR.CODIGO%TYPE) IS
         SELECT EC.TIPOCOST TIPOCOST_DEPA, TC.TIPOCOST DESCTICO_DEPA
         FROM GNR_ESCCEMPR EC, GNR_TICOEMPR TC
         WHERE NOT EXISTS (SELECT 'X' FROM VALORES_LISTA EX WHERE EX.CODIGO = 'ANE_ESTREXCR' AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'ESTRUCTURA') = EC.ESTRUCTU)
              AND EC.TIPOCOST = TC.CODIGO(+)         
              AND EC.DEPARTAM = vP_CODECOMU
              AND EC.INDUCOMU != vP_INDUSIIN
         GROUP BY EC.TIPOCOST, TC.TIPOCOST
         UNION
         SELECT NULL TIPOCOST,  P_UTILIDAD.F_ValoCampo(EX.VALOR,'DESCRIPCION') DESCTICO
         FROM VALORES_LISTA EX, GNR_DEPAEMPR DE,GNR_SPDEEMPR SD, GNR_SEPREMPR SP, VALORES_LISTA SAU, GNR_SEAUEMPR SA
         WHERE EX.CODIGO = 'ANE_ESTREXCR'
           AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'LISTADOS') = 'S'
           AND DE.CODIGO  = vP_CODECOMU
           AND DE.CODIGO = SD.DEPARTAM
           AND SD.SECCION = SP.CODIGO
           AND SAU.CODIGO = 'GNR_RESPAURH'
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCION')= SD.SECCION
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCAUXI') = SA.CODIGO(+)
           AND vDepartam_Imputa != vP_CODEPROD
         UNION
         SELECT EC.TIPOCOST, TC.TIPOCOST DESCTICO
         FROM GNR_ESCCEMPR EC, GNR_TICOEMPR TC
         WHERE NOT EXISTS (SELECT 'X' FROM VALORES_LISTA EX WHERE EX.CODIGO = 'ANE_ESTREXCR' AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'ESTRUCTURA') = EC.ESTRUCTU)
              AND EC.TIPOCOST = TC.CODIGO(+)
              AND EC.DEPARTAM = vDepartam_Imputa
         GROUP BY EC.TIPOCOST, TC.TIPOCOST
         UNION
         SELECT NULL TIPOCOST,  P_UTILIDAD.F_ValoCampo(EX.VALOR,'DESCRIPCION') DESCTICO
         FROM VALORES_LISTA EX, GNR_DEPAEMPR DE,GNR_SPDEEMPR SD, GNR_SEPREMPR SP, VALORES_LISTA SAU, GNR_SEAUEMPR SA
         WHERE EX.CODIGO = 'ANE_ESTREXCR'
           AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'LISTADOS') = 'S'
           AND DE.CODIGO  = vDepartam_Imputa
           AND DE.CODIGO = SD.DEPARTAM
           AND SD.SECCION = SP.CODIGO
           AND SAU.CODIGO = 'GNR_RESPAURH'
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCION')= SD.SECCION
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCAUXI') = SA.CODIGO(+)
           AND vDepartam_Imputa != vP_CODEPROD;
      --
      CURSOR cG_SECCAUXI(vDepartam_Imputa GNR_SPDEEMPR.DEPARTAM%TYPE) IS
         SELECT S.DEPARTAM DEPARTAM_DEPA, D.DEPARTAM DESCDEPA_DEPA, S.SECCION SECCION_DEPA, SD.SECCION DESCSECC_DEPA, SA.SECCAUXI SECCAUXI_DEPA, SAD.SECCAUXI DESCSEAU_DEPA, D.INDUREPR INDUREPR_DEPA, SAD.REPAABSO REPAABSO_DEPA, D.INDURESE INDURESE_DEPA, ROWNUM ROWNUM_DEPA, INDP.CALCPRSU CALCPRSU_REPR_DEPA, INDS.CALCPRSU CALCPRSU_RESE_DEPA, D.CAVAISDE CAVAISDE_DEPA, SAD.INREOBCO INREOBCO_DEPA, INDP.INDUCTOR DEINREPR_DEPA
         FROM GNR_SPDEEMPR S, GNR_SASPEMPR SA, GNR_SEAUEMPR SAD, GNR_DEPAEMPR D, GNR_SEPREMPR SD, GNR_INDUEMPR INDP, GNR_INDUEMPR INDS
            WHERE S.SECCION = SA.SECCION
              AND S.SECCION = SD.CODIGO
              AND SA.SECCAUXI = SAD.CODIGO
              AND S.DEPARTAM = D.CODIGO
              AND D.INDUREPR = INDP.CODIGO(+)
              AND D.INDURESE = INDS.CODIGO(+)
              AND S.DEPARTAM = vDepartam_Imputa
         ORDER BY SAD.REPAABSO DESC, S.DEPARTAM, S.SECCION, SA.SECCAUXI;
      --
      FUNCTION F_CALCMEAN_DEPA_E (vAnno NUMBER) RETURN NUMBER IS
         nRetorno NUMBER;
      BEGIN
          IF TO_CHAR(dFecha_Cierre,'YYYY') <= TO_CHAR(dFecha_Cierre,'YYYY') THEN 
             IF vAnno = TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno = TO_CHAR(dFecha_Cierre,'YYYY') THEN
                nRetorno := (TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM'))) + 1;
             ELSIF vAnno = TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno != TO_CHAR(dFecha_Cierre,'YYYY') THEN                                      
                nRetorno := (TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||'12') - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM'))) + 1;
             ELSIF vAnno != TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno = TO_CHAR(dFecha_Cierre,'YYYY') THEN      
                 nRetorno := TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||'00');
             ELSIF vAnno != TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno != TO_CHAR(dFecha_Cierre,'YYYY') THEN
                nRetorno := 12;
             ELSE
                nRetorno := 0;
             END IF;
          ELSE
             nRetorno := 0;
          END IF;
         --
         RETURN nRetorno;
      END;
      --
      FUNCTION CF_COSTSRDI_DEPA_E(vDEPARTAM_DEPA GNR_SPDEEMPR.DEPARTAM%TYPE) return Number is
         rANE_INDECO_Rec_Dep P_ANE_INDECO.St_ANE_INDECO_AM;
      BEGIN
         rANE_INDECO_Rec_Dep := P_ANE_INDECO.F_ObtieneCosteSubrepDepto_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, vCF_TIPOCOST_DEPA_E);
         --
         RETURN(rANE_INDECO_Rec_Dep.nCoste);
      END;
      --
      FUNCTION CF_COSTRESA_DEPA_E(vDEPARTAM_DEPA GNR_SPDEEMPR.DEPARTAM%TYPE, vSECCION_DEPA GNR_SPDEEMPR.SECCION%TYPE, vSECCAUXI_DEPA GNR_SASPEMPR.SECCAUXI%TYPE) return Number is
         rANE_INTCRE_Rec_Sea P_ANE_INTCRE.St_ANE_INTCRE_AM;
         nRetorno NUMBER;
      BEGIN
         rANE_INTCRE_Rec_Sea := P_ANE_INTCRE.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vCF_TIPOCOST_DEPA_E);
         --
         IF vEmpresa = vP_EMPRPHAR THEN
            nRetorno := NVL(rANE_INTCRE_Rec_Sea.nCOTOPHAR,0);
         ELSIF vEmpresa = vP_EMPRMANV THEN
            nRetorno := NVL(rANE_INTCRE_Rec_Sea.nCOTOMANV,0);
         ELSE
            nRetorno := 0;
         END IF;
         --
         RETURN(nRetorno);
      END;
      --
      FUNCTION CF_TOTAINPR_DEPA_E(vINDUREPR_DEPA GNR_DEPAEMPR.INDUREPR%TYPE, vCALCPRSU_REPR_DEPA GNR_INDUEMPR.CALCPRSU%TYPE,
                                vTIPOCOST_DEPA GNR_TICOEMPR.TIPOCOST%TYPE,
                                vDEPARTAM_DEPA GNR_SPDEEMPR.DEPARTAM%TYPE) return Number is
         CURSOR cInductor_Tot IS
            SELECT ANNO, 
                SUM(ENERO) ENERO, SUM(FEBRERO) FEBRERO, SUM(MARZO) MARZO, SUM(ABRIL) ABRIL,
                SUM(MAYO) MAYO, SUM(JUNIO) JUNIO, SUM(JULIO) JULIO, SUM(AGOSTO) AGOSTO,
                SUM(SEPTIEMBRE) SEPTIEMBRE, SUM(OCTUBRE) OCTUBRE, SUM(NOVIEMBRE) NOVIEMBRE, SUM(DICIEMBRE) DICIEMBRE         
               FROM ANE_COISSSES
                  WHERE EMPRESA = vEmpresa
                    AND INDUCTOR = vINDUREPR_DEPA
                    AND ANNO BETWEEN TO_CHAR(dFecha_Cierre,'YYYY') AND TO_CHAR(dFecha_Cierre,'YYYY')
            GROUP BY ANNO;
         --
         nInductor_Tot NUMBER;
         nMeseAnno_Tot NUMBER := 0;
   -->Solo para Departamento de Produccion
      CURSOR cInductor_Tot_Pro(vInductor GNR_INDUEMPR.CODIGO%TYPE) IS
            SELECT V.ANNO,
                SUM(V.ENERO) ENERO, SUM(V.FEBRERO) FEBRERO, SUM(V.MARZO) MARZO, SUM(V.ABRIL) ABRIL,
                SUM(V.MAYO) MAYO, SUM(V.JUNIO) JUNIO, SUM(V.JULIO) JULIO, SUM(V.AGOSTO) AGOSTO,
                SUM(V.SEPTIEMBRE) SEPTIEMBRE, SUM(V.OCTUBRE) OCTUBRE, SUM(V.NOVIEMBRE) NOVIEMBRE, SUM(V.DICIEMBRE) DICIEMBRE         
               FROM ANE_COISSSES V
                  WHERE V.EMPRESA = vEmpresa
                    AND V.INDUCTOR = vInductor
                    AND V.ANNO BETWEEN TO_CHAR(dFecha_Cierre,'YYYY') AND TO_CHAR(dFecha_Cierre,'YYYY')
            GROUP BY V.ANNO;
      --
      vInductor GNR_INDUEMPR.CODIGO%TYPE;
      --Tipos de Coste Subrepartidos con el Inductor Auxiliar Primario (Solo para listado de Depto. Produccion)
      CURSOR cANE_TICOSRIA IS
         SELECT 'X' FROM VALORES_LISTA 
            WHERE CODIGO = 'ANE_TICOSRIA'
              AND VALOR = vTIPOCOST_DEPA;
      --
      vExisTCSR_IndAux VARCHAR2(1);             
      BEGIN
         --Listado de Departamentales normal
         IF vDEPARTAM_DEPA != vP_CODEPROD THEN
            IF vINDUREPR_DEPA IS NOT NULL THEN
               nInductor_Tot := 0;
               nMeseAnno_Tot := 0;
               --
               FOR rInductor_Tot IN cInductor_Tot LOOP
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'01') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.ENERO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'02') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.FEBRERO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'03') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.MARZO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'04') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.ABRIL;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'05') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.MAYO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'06') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.JUNIO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'07') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.JULIO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'08') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.AGOSTO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'09') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.SEPTIEMBRE;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'10') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.OCTUBRE;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'11') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.NOVIEMBRE;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'12') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.DICIEMBRE;
                   END IF;
                   --
                   IF vCALCPRSU_REPR_DEPA = 'P' THEN
                      nMeseAnno_Tot := nMeseAnno_Tot + F_CALCMEAN_DEPA_E(rInductor_Tot.Anno);
                   END IF;
               END LOOP;
               --
               IF vCALCPRSU_REPR_DEPA = 'P' THEN
                  IF nMeseAnno_Tot != 0 THEN
                     nInductor_Tot := nInductor_Tot / nMeseAnno_Tot;
                  ELSE
                     nInductor_Tot := 0;
                  END IF;
               END IF;
            END IF;
         -->Solo para Departamento de Produccion
         ELSE
            OPEN cANE_TICOSRIA;
            FETCH cANE_TICOSRIA INTO vExisTCSR_IndAux;
            CLOSE cANE_TICOSRIA;
            --
            vCP_ExisTCSR_DEPA_E := vExisTCSR_IndAux;
            --
            IF vExisTCSR_IndAux IS NULL THEN	
               vInductor := vINDUREPR_DEPA;
            ELSE                      
               vInductor := vP_IRPIPTCS;
            END IF;
            --
            IF vInductor IS NOT NULL THEN
               nInductor_Tot := 0;
               nMeseAnno_Tot := 0;
               --
               FOR rInductor_Tot IN cInductor_Tot_Pro(vInductor) LOOP
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'01') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.ENERO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'02') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.FEBRERO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'03') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.MARZO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'04') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.ABRIL;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'05') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.MAYO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'06') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.JUNIO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'07') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.JULIO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'08') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.AGOSTO;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'09') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.SEPTIEMBRE;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'10') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.OCTUBRE;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'11') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.NOVIEMBRE;
                   END IF;
                   --
                   IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'12') THEN
                      nInductor_Tot := nInductor_Tot + rInductor_Tot.DICIEMBRE;
                   END IF;
                   --
                   IF vCALCPRSU_REPR_DEPA = 'P' THEN
                      nMeseAnno_Tot := nMeseAnno_Tot + F_CALCMEAN_DEPA_E(rInductor_Tot.Anno);
                   END IF;
               END LOOP;
               --
               IF vCALCPRSU_REPR_DEPA = 'P' THEN
                  IF nMeseAnno_Tot != 0 THEN
                     nInductor_Tot := nInductor_Tot / nMeseAnno_Tot;
                  ELSE
                     nInductor_Tot := 0;
                  END IF;
               END IF;
            END IF;
         END IF;
         --
         RETURN(nInductor_Tot);     
      END;
      --
      FUNCTION CF_TOTAINSE_DEPA_E(vINDURESE_DEPA GNR_DEPAEMPR.INDURESE%TYPE, vCALCPRSU_RESE_DEPA GNR_INDUEMPR.CALCPRSU%TYPE) return Number is
         CURSOR cInductor_Tot IS
            SELECT ANNO, 
                SUM(ENERO) ENERO, SUM(FEBRERO) FEBRERO, SUM(MARZO) MARZO, SUM(ABRIL) ABRIL,
                SUM(MAYO) MAYO, SUM(JUNIO) JUNIO, SUM(JULIO) JULIO, SUM(AGOSTO) AGOSTO,
                SUM(SEPTIEMBRE) SEPTIEMBRE, SUM(OCTUBRE) OCTUBRE, SUM(NOVIEMBRE) NOVIEMBRE, SUM(DICIEMBRE) DICIEMBRE         
               FROM ANE_COISSSES
                  WHERE EMPRESA = vEmpresa
                    AND INDUCTOR = vINDURESE_DEPA
                    AND ANNO BETWEEN TO_CHAR(dFecha_Cierre,'YYYY') AND TO_CHAR(dFecha_Cierre,'YYYY')
            GROUP BY ANNO;
         --
         nInductor_Tot NUMBER;
         nMeseAnno_Tot NUMBER := 0;
      begin
          IF vINDURESE_DEPA IS NOT NULL THEN
            nInductor_Tot := 0;
            nMeseAnno_Tot := 0;
            --
            FOR rInductor_Tot IN cInductor_Tot LOOP
              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'01') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.ENERO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'02') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.FEBRERO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'03') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.MARZO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'04') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.ABRIL;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'05') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.MAYO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'06') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.JUNIO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'07') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.JULIO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'08') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.AGOSTO;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'09') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.SEPTIEMBRE;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'10') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.OCTUBRE;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'11') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.NOVIEMBRE;
                  END IF;
                  --
                  IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'12') THEN
                     nInductor_Tot := nInductor_Tot + rInductor_Tot.DICIEMBRE;
                  END IF;
                  --
                  IF vCALCPRSU_RESE_DEPA = 'P' THEN
                     nMeseAnno_Tot := nMeseAnno_Tot + F_CALCMEAN_DEPA_E(rInductor_Tot.Anno);
                  END IF;
            END LOOP;
            --
              IF vCALCPRSU_RESE_DEPA = 'P' THEN
                  IF nMeseAnno_Tot != 0 THEN
                     nInductor_Tot := nInductor_Tot / nMeseAnno_Tot;
                  ELSE
                     nInductor_Tot := 0;
                  END IF;
               END IF;
         END IF;   	
         --
         RETURN(nInductor_Tot);     
      END;
      --
      FUNCTION CF_COSTREPR_DEPA_E(vDEPARTAM_DEPA GNR_SPDEEMPR.DEPARTAM%TYPE, vSECCION_DEPA GNR_SPDEEMPR.SECCION%TYPE, vSECCAUXI_DEPA GNR_SASPEMPR.SECCAUXI%TYPE, 
                                  vTIPOCOST_DEPA GNR_ESCCEMPR.TIPOCOST%TYPE, vDESCTICO_DEPA GNR_TICOEMPR.TIPOCOST%TYPE,
                                  vREPAABSO_DEPA GNR_SEAUEMPR.REPAABSO%TYPE,
                                  vINDUREPR_DEPA GNR_DEPAEMPR.INDUREPR%TYPE, vCALCPRSU_REPR_DEPA GNR_INDUEMPR.CALCPRSU%TYPE,
                                  vCAVAISDE_DEPA GNR_DEPAEMPR.CAVAISDE%TYPE,
                                  vINDURESE_DEPA GNR_DEPAEMPR.INDURESE%TYPE, vCALCPRSU_RESE_DEPA GNR_INDUEMPR.CALCPRSU%TYPE,
                                  vINREOBCO_DEPA GNR_SEAUEMPR.INREOBCO%TYPE) return Number is
         rANE_INTCRE_Rec_Sea P_ANE_INTCRE.St_ANE_INTCRE_AM;
         --
         nRetorno NUMBER := 0;
         --
         CURSOR cSeccAuxi_Repa IS
         SELECT S.SECCION, SA.SECCAUXI 
            FROM GNR_SPDEEMPR S, GNR_SASPEMPR SA, GNR_SEAUEMPR SAD, GNR_DEPAEMPR D
            WHERE S.SECCION = SA.SECCION
              AND SA.SECCAUXI = SAD.CODIGO
              AND S.DEPARTAM = D.CODIGO
              AND S.DEPARTAM = vDEPARTAM_DEPA
              AND SAD.REPAABSO = 'R';
         --
         CURSOR cInductor(vDepartam ANE_COISSSES.DEPARTAM%TYPE, vSeccion ANE_COISSSES.SECCION%TYPE, vSeccAuxi ANE_COISSSES.SECCAUXI%TYPE, vInductor ANE_COISSSES.INDUCTOR%TYPE) IS
            SELECT ANNO, 
                SUM(ENERO) ENERO, SUM(FEBRERO) FEBRERO, SUM(MARZO) MARZO, SUM(ABRIL) ABRIL,
                SUM(MAYO) MAYO, SUM(JUNIO) JUNIO, SUM(JULIO) JULIO, SUM(AGOSTO) AGOSTO,
                SUM(SEPTIEMBRE) SEPTIEMBRE, SUM(OCTUBRE) OCTUBRE, SUM(NOVIEMBRE) NOVIEMBRE, SUM(DICIEMBRE) DICIEMBRE         
               FROM ANE_COISSSES
                  WHERE EMPRESA = vEmpresa
                    AND DEPARTAM = vDepartam
                    AND SECCION = vSeccion
                    AND SECCAUXI = vSeccAuxi
                    AND INDUCTOR = vInductor
                    AND ANNO BETWEEN TO_CHAR(dFecha_Cierre,'YYYY') AND TO_CHAR(dFecha_Cierre,'YYYY')
            GROUP BY ANNO;
         --
         nInductor NUMBER := 0;
         nMeseAnno NUMBER := 0;
         --
         nCostRepa NUMBER;
         --
         CURSOR cGNR_TCEXRSDE IS
         SELECT 'X' FROM GNR_TCEXRSDE EX, GNR_TICOEMPR TC
            WHERE EX.TIPOCOST = TC.CODIGO
              AND DEPARTAM = vDEPARTAM_DEPA
              AND (
                   (vTIPOCOST_DEPA IS NOT NULL AND EX.TIPOCOST = vTIPOCOST_DEPA) OR
                   (vTIPOCOST_DEPA IS NULL AND EX.TIPOCOST||' '||TC.TIPOCOST = vDESCTICO_DEPA)
                  );
      --
      vExisExcl VARCHAR2(1);           
      --Cursor de Imputaciones
         CURSOR cImputa IS
            SELECT P_UTILIDAD.f_ValoCampo(VALOR,'IMPUTA') IMPUTA
               FROM VALORES_LISTA 
                  WHERE CODIGO = 'ANE_COCDOBCO'
                    AND P_UTILIDAD.f_ValoCampo(VALOR,'DEPARTAM') = vDEPARTAM_DEPA
                    AND P_UTILIDAD.f_ValoCampo(VALOR,'SECCION') = vSECCION_DEPA
                    AND P_UTILIDAD.f_ValoCampo(VALOR,'SECCAUXI') = vSECCAUXI_DEPA;
         --
         vImputa VALORES_LISTA.VALOR%TYPE;
         --Busca las maquinas de la OT para imputar costes sobre producción
         CURSOR cMaquina(vMaquina VARCHAR2) IS
            SELECT 'X'
               FROM FIC_LINEOTRE O
               WHERE O.EMPRESA = vEmpresa
                 AND O.NUMERO = nNumero
                 AND O.ANNO = SUBSTR(nNumero,1,4)
                 AND O.COD_ARES LIKE vMaquina||'%';
         --
         vExisMaqu VARCHAR2(1);          
   -->Departamento de Produccion
      --
      nInductor_INAXREPR NUMBER := 0;
      nMeseAnno_INAXREPR NUMBER := 0;
      vInductor_INAXREPR GNR_INDUEMPR.INDUCTOR%TYPE;
      --   
      CURSOR cInductor_Pro(vDepartam ANE_COISSSES.DEPARTAM%TYPE, vSeccion ANE_COISSSES.SECCION%TYPE, vSeccAuxi ANE_COISSSES.SECCAUXI%TYPE, vInductor ANE_COISSSES.INDUCTOR%TYPE) IS
            SELECT V.ANNO, IND.CALCPRSU, IND.INDUCTOR,
                SUM(V.ENERO) ENERO, SUM(V.FEBRERO) FEBRERO, SUM(V.MARZO) MARZO, SUM(V.ABRIL) ABRIL,
                SUM(V.MAYO) MAYO, SUM(V.JUNIO) JUNIO, SUM(V.JULIO) JULIO, SUM(V.AGOSTO) AGOSTO,
                SUM(V.SEPTIEMBRE) SEPTIEMBRE, SUM(V.OCTUBRE) OCTUBRE, SUM(V.NOVIEMBRE) NOVIEMBRE, SUM(V.DICIEMBRE) DICIEMBRE         
               FROM ANE_COISSSES V, GNR_INDUEMPR IND
                  WHERE V.INDUCTOR = IND.CODIGO(+)
                    AND V.EMPRESA = vEmpresa
                    AND V.DEPARTAM = vDepartam
                    AND V.SECCION = vSeccion
                    AND V.SECCAUXI = vSeccAuxi
                    AND V.INDUCTOR = vInductor
                    AND V.ANNO BETWEEN TO_CHAR(dFecha_Cierre,'YYYY') AND TO_CHAR(dFecha_Cierre,'YYYY')
            GROUP BY V.ANNO, IND.CALCPRSU, IND.INDUCTOR;
      --
      CURSOR cInductor_Rep_OC_Man IS
            SELECT V.ANNO, IND.CALCPRSU,
                SUM(V.ENERO) ENERO, SUM(V.FEBRERO) FEBRERO, SUM(V.MARZO) MARZO, SUM(V.ABRIL) ABRIL,
                SUM(V.MAYO) MAYO, SUM(V.JUNIO) JUNIO, SUM(V.JULIO) JULIO, SUM(V.AGOSTO) AGOSTO,
                SUM(V.SEPTIEMBRE) SEPTIEMBRE, SUM(V.OCTUBRE) OCTUBRE, SUM(V.NOVIEMBRE) NOVIEMBRE, SUM(V.DICIEMBRE) DICIEMBRE         
               FROM ANE_COISSSES V, GNR_INDUEMPR IND
                  WHERE V.INDUCTOR = IND.CODIGO(+)
                    AND V.EMPRESA = vEmpresa
                    AND V.INDUCTOR = vINREOBCO_DEPA
                    AND V.ANNO BETWEEN TO_CHAR(dFecha_Cierre,'YYYY') AND TO_CHAR(dFecha_Cierre,'YYYY')
            GROUP BY V.ANNO, IND.CALCPRSU;
      --
      nInductor_Rep_OC_Man NUMBER := 0;
      nMeseAnno_Rep_OC_Man NUMBER := 0;           
      --
      bCalcPrsu BOOLEAN;         
      nCP_COSTUNOT_DEPA_E NUMBER;
      nCF_TOTAINPR_DEPA_E NUMBER := NVL(CF_TOTAINPR_DEPA_E(vINDUREPR_DEPA, vCALCPRSU_REPR_DEPA, vTIPOCOST_DEPA, vDEPARTAM_DEPA),0);
      nCF_COSTRESA_DEPA_E NUMBER := NVL(CF_COSTRESA_DEPA_E(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA),0);
      nCF_COSTSRDI_DEPA_E NUMBER := NVL(CF_COSTSRDI_DEPA_E(vDEPARTAM_DEPA),0);
      nCF_TOTAINSE_DEPA_E NUMBER := NVL(CF_TOTAINSE_DEPA_E(vINDURESE_DEPA, vCALCPRSU_RESE_DEPA),0);
      nCP_INDUPRIN_DEPA_E NUMBER;
   BEGIN
      --Listado de Departamentales normal
      IF vDEPARTAM_DEPA != vP_CODEPROD THEN
         vExisExcl := NULL;
         --
         OPEN cGNR_TCEXRSDE;
         FETCH cGNR_TCEXRSDE INTO vExisExcl;
         CLOSE cGNR_TCEXRSDE;
         --	
          IF vREPAABSO_DEPA = 'R' THEN
            rANE_INTCRE_Rec_Sea := P_ANE_INTCRE.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vCF_TIPOCOST_DEPA_E);
            --
            IF vExisExcl IS NULL THEN
               IF vEmpresa = vP_EMPRPHAR THEN
                  nRetorno := NVL(rANE_INTCRE_Rec_Sea.nCOTOPHAR,0);
               ELSIF vEmpresa = vP_EMPRMANV THEN
                  nRetorno := NVL(rANE_INTCRE_Rec_Sea.nCOTOMANV,0);
               ELSE
                  nRetorno := 0;
               END IF;        
            ELSE
               nRetorno := 0;
            END IF;
            --
            nCP_COSTRESE_DEPA_E := NULL;
            --
            nCP_COSTUNOT_DEPA_E := NULL;
         ELSE
            IF vINDUREPR_DEPA IS NOT NULL THEN
                 nInductor := 0;
                 nMeseAnno := 0;
               --
                FOR rInductor IN cInductor(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vINDUREPR_DEPA) LOOP
                     IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'01') THEN
                         nInductor := nInductor + rInductor.ENERO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'02') THEN
                         nInductor := nInductor + rInductor.FEBRERO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'03') THEN
                         nInductor := nInductor + rInductor.MARZO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'04') THEN
                         nInductor := nInductor + rInductor.ABRIL;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'05') THEN
                         nInductor := nInductor + rInductor.MAYO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'06') THEN
                         nInductor := nInductor + rInductor.JUNIO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'07') THEN
                         nInductor := nInductor + rInductor.JULIO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'08') THEN
                         nInductor := nInductor + rInductor.AGOSTO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'09') THEN
                         nInductor := nInductor + rInductor.SEPTIEMBRE;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'10') THEN
                         nInductor := nInductor + rInductor.OCTUBRE;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'11') THEN
                         nInductor := nInductor + rInductor.NOVIEMBRE;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'12') THEN
                         nInductor := nInductor + rInductor.DICIEMBRE;
                      END IF;
                      --
                      IF vCALCPRSU_REPR_DEPA = 'P' THEN
                         nMeseAnno := nMeseAnno + F_CALCMEAN_DEPA_E(rInductor.Anno);
                      END IF;
                  END LOOP;
                  --
                   IF vCALCPRSU_REPR_DEPA = 'P' THEN
                      IF nMeseAnno != 0 THEN
                         nInductor := nInductor / nMeseAnno;
                      ELSE
                         nInductor := 0;
                      END IF;
                   END IF;         
               --
               IF NVL(nCF_TOTAINPR_DEPA_E,0) != 0 AND NVL(nInductor,0) != 0 THEN
                   nCostRepa := nCF_COSTSRDI_DEPA_E;
                   --
                  FOR rSeccAuxi_Repa IN cSeccAuxi_Repa LOOP
                     rANE_INTCRE_Rec_Sea := P_ANE_INTCRE.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, rSeccAuxi_Repa.SECCION, rSeccAuxi_Repa.SECCAUXI, vCF_TIPOCOST_DEPA_E);
                     --
                     IF vEmpresa = vP_EMPRPHAR THEN
                        nCostRepa := nCostRepa + NVL(rANE_INTCRE_Rec_Sea.nCOTOPHAR,0);
                     ELSIF vEmpresa = vP_EMPRMANV THEN
                        nCostRepa := nCostRepa + NVL(rANE_INTCRE_Rec_Sea.nCOTOMANV,0);
                     END IF;   
                  END LOOP;
                  --
                  IF nCostRepa != 0 THEN
                     nRetorno := ((nCostRepa / nCF_TOTAINPR_DEPA_E) * nInductor);
                  END IF;
               END IF;
            ELSE
               nRetorno := nCF_COSTSRDI_DEPA_E;
            END IF;
            --
            IF vExisExcl IS NULL THEN
               nCP_COSTRESE_DEPA_E := nRetorno + nCF_COSTRESA_DEPA_E;
            ELSE
               nCP_COSTRESE_DEPA_E := nRetorno;
            END IF;
            --
            IF vINDURESE_DEPA IS NOT NULL THEN
               IF vCAVAISDE_DEPA = 'S' THEN
                  nInductor := 0;
                  nMeseAnno := 0;
                  --
                  FOR rInductor IN cInductor(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vINDURESE_DEPA) LOOP
                          IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'01') THEN
                              nInductor := nInductor + rInductor.ENERO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'02') THEN
                              nInductor := nInductor + rInductor.FEBRERO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'03') THEN
                              nInductor := nInductor + rInductor.MARZO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'04') THEN
                              nInductor := nInductor + rInductor.ABRIL;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'05') THEN
                              nInductor := nInductor + rInductor.MAYO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'06') THEN
                              nInductor := nInductor + rInductor.JUNIO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'07') THEN
                              nInductor := nInductor + rInductor.JULIO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'08') THEN
                              nInductor := nInductor + rInductor.AGOSTO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'09') THEN
                              nInductor := nInductor + rInductor.SEPTIEMBRE;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'10') THEN
                              nInductor := nInductor + rInductor.OCTUBRE;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'11') THEN
                              nInductor := nInductor + rInductor.NOVIEMBRE;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'12') THEN
                              nInductor := nInductor + rInductor.DICIEMBRE;
                           END IF;
                           --
                           IF vCALCPRSU_RESE_DEPA = 'P' THEN
                              nMeseAnno := nMeseAnno + F_CALCMEAN_DEPA_E(rInductor.Anno);
                           END IF;
                       END LOOP;
                       --
                        IF vCALCPRSU_RESE_DEPA = 'P' THEN
                           IF nMeseAnno != 0 THEN
                              nInductor := nInductor / nMeseAnno;
                           ELSE
                              nInductor := 0;
                           END IF;
                        END IF;         
                  --
                  IF NVL(nInductor,0) != 0 THEN
                     nCP_COSTUNOT_DEPA_E := nCP_COSTRESE_DEPA_E / nInductor;
                  ELSE
                     nCP_COSTUNOT_DEPA_E := 0;
                  END IF;
               ELSE
                  IF NVL(nCF_TOTAINSE_DEPA_E,0) != 0 THEN
                     nCP_COSTUNOT_DEPA_E := nCP_COSTRESE_DEPA_E / nCF_TOTAINSE_DEPA_E;
                  ELSE
                     nCP_COSTUNOT_DEPA_E := 0;
                  END IF;
               END IF;
               -------------------------------------------------------------------
               OPEN cImputa;
               FETCH cImputa INTO vImputa;
               CLOSE cImputa;
               --
               IF vImputa = 'COSTES ADMINISTRATIVOS' THEN           
                  nCP_SUM_COSTADMI_E := NVL(nCP_SUM_COSTADMI_E,0) +NVL(nCP_COSTUNOT_DEPA_E,0);
               ELSIF vImputa = 'COSTES DE COMERCIALIZACIÓN' THEN    
                   --Si es Nacional ó Exportacion
                  IF (vSECCAUXI_DEPA = vP_COSACONA AND vCP_TIPOPEDI = 'N') OR (vSECCAUXI_DEPA = vP_COSACOEX AND vCP_TIPOPEDI = 'E') THEN
                     nCP_SUM_COSTCOME_E := NVL(nCP_SUM_COSTCOME_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
                  END IF;
                  --
                  --:CP_SUM_COSTCOME_E := NVL(:CP_SUM_COSTCOME_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
               ELSIF vImputa = 'COSTES DE DISTRIBUCIÓN' THEN
                  nCP_SUM_COSTDIST_E := NVL(nCP_SUM_COSTDIST_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
               ELSIF vImputa = 'LOGÍSTICA INTERNA' THEN
                  nCP_SUM_LOGIINTE_E := NVL(nCP_SUM_LOGIINTE_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
               ELSIF vImputa = 'ALMACÉN' THEN
                  nCP_SUM_ALMACEN_E := NVL(nCP_SUM_ALMACEN_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
               ELSIF vImputa = 'OTROS COSTES DE PRODUCCIÓN' THEN
                  nCP_SUM_OTROCOST_E := NVL(nCP_SUM_OTROCOST_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
               ELSIF vImputa = 'CALIDAD' THEN
                  nCP_SUM_CALIDAD_E := NVL(nCP_SUM_CALIDAD_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
               END IF;
            ELSE
              nCP_COSTUNOT_DEPA_E := NULL; 	
            END IF;
         END IF;
   --Departamento de Produccion
      ELSE
         vExisExcl := NULL;
         --
         OPEN cGNR_TCEXRSDE;
         FETCH cGNR_TCEXRSDE INTO vExisExcl;
         CLOSE cGNR_TCEXRSDE;
         --	
         IF vREPAABSO_DEPA = 'R' THEN
            rANE_INTCRE_Rec_Sea := P_ANE_INTCRE.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vCF_TIPOCOST_DEPA_E);
            --
            IF vExisExcl IS NULL THEN
               IF vEmpresa = vP_EMPRPHAR THEN
                  nRetorno := NVL(rANE_INTCRE_Rec_Sea.nCOTOPHAR,0);
               ELSIF vEmpresa = vP_EMPRMANV THEN
                  nRetorno := NVL(rANE_INTCRE_Rec_Sea.nCOTOMANV,0);
               ELSE
                  nRetorno := 0;
               END IF;        
            ELSE
               nRetorno := 0;
            END IF;
            --
            nCP_COSTRESE_DEPA_E := NULL;
            --
            nCP_INDUPRIN_DEPA_E := NULL;
            --
            nCP_COSTUNOT_DEPA_E := NULL;
         ELSE
            IF vINDUREPR_DEPA IS NOT NULL THEN
               nInductor := 0;
               nMeseAnno := 0;
               --
               FOR rInductor IN cInductor_Pro(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vINDUREPR_DEPA) LOOP
                     IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'01') THEN
                         nInductor := nInductor + rInductor.ENERO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'02') THEN
                         nInductor := nInductor + rInductor.FEBRERO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'03') THEN
                         nInductor := nInductor + rInductor.MARZO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'04') THEN
                         nInductor := nInductor + rInductor.ABRIL;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'05') THEN
                         nInductor := nInductor + rInductor.MAYO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'06') THEN
                         nInductor := nInductor + rInductor.JUNIO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'07') THEN
                         nInductor := nInductor + rInductor.JULIO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'08') THEN
                         nInductor := nInductor + rInductor.AGOSTO;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'09') THEN
                         nInductor := nInductor + rInductor.SEPTIEMBRE;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'10') THEN
                         nInductor := nInductor + rInductor.OCTUBRE;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'11') THEN
                         nInductor := nInductor + rInductor.NOVIEMBRE;
                      END IF;
                      --
                      IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'12') THEN
                         nInductor := nInductor + rInductor.DICIEMBRE;
                      END IF;
                      --
                      IF vCALCPRSU_REPR_DEPA = 'P' THEN
                         nMeseAnno := nMeseAnno + F_CALCMEAN_DEPA_E(rInductor.Anno);
                      END IF;
               END LOOP;
               --
               IF vCALCPRSU_REPR_DEPA = 'P' THEN
                  IF nMeseAnno != 0 THEN
                     nInductor := nInductor / nMeseAnno;
                  ELSE
                     nInductor := 0;
                  END IF;
               END IF;         
               --
               IF vP_IRPIPTCS IS NOT NULL THEN
                    nInductor_INAXREPR := 0;
                    nMeseAnno_INAXREPR := 0;
                    vInductor_INAXREPR := NULL;
                    --
                    bCalcPrsu := FALSE;
                    --
                    FOR rInductor IN cInductor_Pro(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vP_IRPIPTCS) LOOP
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'01') THEN
                              nInductor_INAXREPR := nInductor_INAXREPR + rInductor.ENERO;
                           END IF;
                           --  
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'02') THEN
                              nInductor_INAXREPR := nInductor_INAXREPR + rInductor.FEBRERO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'03') THEN
                               nInductor_INAXREPR := nInductor_INAXREPR + rInductor.MARZO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'04') THEN
                              nInductor_INAXREPR := nInductor_INAXREPR + rInductor.ABRIL;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'05') THEN
                              nInductor_INAXREPR := nInductor_INAXREPR + rInductor.MAYO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'06') THEN
                               nInductor_INAXREPR := nInductor_INAXREPR + rInductor.JUNIO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'07') THEN
                               nInductor_INAXREPR := nInductor_INAXREPR + rInductor.JULIO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'08') THEN
                              nInductor_INAXREPR := nInductor_INAXREPR + rInductor.AGOSTO;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'09') THEN
                              nInductor_INAXREPR := nInductor_INAXREPR + rInductor.SEPTIEMBRE;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'10') THEN
                              nInductor_INAXREPR := nInductor_INAXREPR + rInductor.OCTUBRE;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'11') THEN
                              nInductor_INAXREPR := nInductor_INAXREPR + rInductor.NOVIEMBRE;
                           END IF;
                           --
                           IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'12') THEN
                              nInductor_INAXREPR := nInductor_INAXREPR + rInductor.DICIEMBRE;
                           END IF;
                           --
                           IF rInductor.CalcPrsu = 'P' THEN
                              nMeseAnno_INAXREPR := nMeseAnno_INAXREPR + F_CALCMEAN_DEPA_E(rInductor.Anno);
                              --
                              IF NOT (bCalcPrsu) THEN
                                 bCalcPrsu := TRUE;
                              END IF;
                           END IF;
                           --
                           IF vInductor_INAXREPR IS NULL THEN
                              vInductor_INAXREPR := rInductor.INDUCTOR;
                           END IF;
                    END LOOP;
                    --
                    IF (bCalcPrsu) THEN
                       IF nMeseAnno_INAXREPR != 0 THEN
                          nInductor_INAXREPR := nInductor_INAXREPR / nMeseAnno_INAXREPR;
                       ELSE
                          nInductor_INAXREPR := 0;
                       END IF;
                    END IF;         
               END IF;
               --
               IF vCP_ExisTCSR_DEPA_E IS NULL THEN
                  nCP_INDUPRIN_DEPA_E := nInductor;
               ELSE
                  nCP_INDUPRIN_DEPA_E := nInductor_INAXREPR;
               END IF;
               --
               IF NVL(nCF_TOTAINPR_DEPA_E,0) != 0 AND NVL(nCP_INDUPRIN_DEPA_E,0) != 0 THEN	
                  nCostRepa := nCF_COSTSRDI_DEPA_E;
                  --
                  FOR rSeccAuxi_Repa IN cSeccAuxi_Repa LOOP
                     rANE_INTCRE_Rec_Sea := P_ANE_INTCRE.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_DEPA, rSeccAuxi_Repa.SECCION, rSeccAuxi_Repa.SECCAUXI, vCF_TIPOCOST_DEPA_E);
                     --
                     IF vEmpresa = vP_EMPRPHAR THEN
                        nCostRepa := nCostRepa + NVL(rANE_INTCRE_Rec_Sea.nCOTOPHAR,0);
                     ELSIF vEmpresa = vP_EMPRMANV THEN
                        nCostRepa := nCostRepa + NVL(rANE_INTCRE_Rec_Sea.nCOTOMANV,0);
                     END IF;   
                  END LOOP;
                  --
                  IF nCostRepa != 0 THEN
                     nRetorno := ((nCostRepa / nCF_TOTAINPR_DEPA_E) * nCP_INDUPRIN_DEPA_E);
                  END IF;
               END IF;
            ELSE
               nRetorno := nCF_COSTSRDI_DEPA_E;
               --
               nCP_INDUPRIN_DEPA_E := NULL;
            END IF;
            --
            IF vExisExcl IS NULL THEN
               nCP_COSTRESE_DEPA_E := nRetorno + nCF_COSTRESA_DEPA_E;
            ELSE
               nCP_COSTRESE_DEPA_E := nRetorno;
            END IF;
            --
            IF vINDURESE_DEPA IS NOT NULL THEN
               IF vCAVAISDE_DEPA = 'S' THEN
                    IF vINREOBCO_DEPA IS NULL THEN
                     nInductor := 0;
                     nMeseAnno := 0;
                     --
                     FOR rInductor IN cInductor_Pro(vDEPARTAM_DEPA, vSECCION_DEPA, vSECCAUXI_DEPA, vINDURESE_DEPA) LOOP
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'01') THEN
                                 nInductor := nInductor + rInductor.ENERO;
                              END IF;
                              --
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'02') THEN
                                 nInductor := nInductor + rInductor.FEBRERO;
                              END IF;
                              --
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'03') THEN
                                 nInductor := nInductor + rInductor.MARZO;
                              END IF;
                              --
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'04') THEN
                                 nInductor := nInductor + rInductor.ABRIL;
                              END IF;
                              --
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'05') THEN
                                 nInductor := nInductor + rInductor.MAYO;
                              END IF;
                              --
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'06') THEN
                                 nInductor := nInductor + rInductor.JUNIO;
                              END IF;
                              --
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'07') THEN
                                 nInductor := nInductor + rInductor.JULIO;
                              END IF;
                              --
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'08') THEN
                                 nInductor := nInductor + rInductor.AGOSTO;
                              END IF;
                              --
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'09') THEN
                                 nInductor := nInductor + rInductor.SEPTIEMBRE;
                              END IF;
                              --
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'10') THEN
                                 nInductor := nInductor + rInductor.OCTUBRE;
                              END IF;
                              --
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'11') THEN
                                 nInductor := nInductor + rInductor.NOVIEMBRE;
                              END IF;
                              --
                              IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor.Anno||'12') THEN
                                 nInductor := nInductor + rInductor.DICIEMBRE;
                              END IF;
                              --
                              IF vCALCPRSU_RESE_DEPA = 'P' THEN
                                  nMeseAnno := nMeseAnno + F_CALCMEAN_DEPA_E(rInductor.Anno);
                              END IF;
                     END LOOP;
                     --
                     IF vCALCPRSU_RESE_DEPA = 'P' THEN
                              IF nMeseAnno != 0 THEN
                                 nInductor := nInductor / nMeseAnno;
                              ELSE
                                 nInductor := 0;
                              END IF;
                     END IF;         
                     --
                     IF NVL(nInductor,0) != 0 THEN
                        nCP_COSTUNOT_DEPA_E := nCP_COSTRESE_DEPA_E / nInductor;
                     ELSE
                        nCP_COSTUNOT_DEPA_E := 0;
                     END IF;
                  ELSE --Inductor de Reparto al Objetivo de Coste Definido Manualmente
                         nInductor_Rep_OC_Man := 0;
                         nMeseAnno_Rep_OC_Man := 0;
                         --
                         bCalcPrsu := FALSE;
                         --
                         FOR rInductor_Tot IN cInductor_Rep_OC_Man LOOP
                            IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'01') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'01') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.ENERO;
                                END IF;
                                --
                                IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'02') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'02') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.FEBRERO;
                                END IF;
                                --
                                IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'03') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'03') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.MARZO;
                                END IF;
                                --
                                IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'04') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'04') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.ABRIL;
                                END IF;
                                --
                                IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'05') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'05') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.MAYO;
                                END IF;
                                --
                                IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'06') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'06') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.JUNIO;
                                END IF;
                                --
                                IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'07') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'07') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.JULIO;
                                END IF;
                                --
                                IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'08') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'08') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.AGOSTO;
                                END IF;
                                --
                                IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'09') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'09') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.SEPTIEMBRE;
                                END IF;
                                --
                                IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'10') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'10') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.OCTUBRE;
                                END IF;
                                --
                                IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'11') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'11') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.NOVIEMBRE;
                                END IF;
                                --
                                IF TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(rInductor_Tot.Anno||'12') AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(rInductor_Tot.Anno||'12') THEN
                                   nInductor_Rep_OC_Man := nInductor_Rep_OC_Man + rInductor_Tot.DICIEMBRE;
                                END IF;
                                --
                                IF rInductor_Tot.CalcPrsu = 'P' THEN
                                   nMeseAnno_Rep_OC_Man := nMeseAnno_Rep_OC_Man + F_CALCMEAN_DEPA_E(rInductor_Tot.Anno);
                                   --
                                   IF NOT (bCalcPrsu) THEN
                                      bCalcPrsu := TRUE;
                                   END IF;
                                END IF;
                         END LOOP;
                         --
                           IF (bCalcPrsu) THEN
                               IF nMeseAnno_Rep_OC_Man != 0 THEN
                                  nInductor_Rep_OC_Man := nInductor_Rep_OC_Man / nMeseAnno_Rep_OC_Man;
                               ELSE
                                  nInductor_Rep_OC_Man := 0;
                               END IF;
                           END IF;
                           --
                     IF NVL(nInductor_Rep_OC_Man,0) != 0 THEN
                        nCP_COSTUNOT_DEPA_E := nCP_COSTRESE_DEPA_E / nInductor_Rep_OC_Man;
                     ELSE
                        nCP_COSTUNOT_DEPA_E := 0;
                     END IF;
                  END IF;   	
               ELSE
                  IF NVL(nCF_TOTAINSE_DEPA_E,0) != 0 THEN
                     nCP_COSTUNOT_DEPA_E := nCP_COSTRESE_DEPA_E / nCF_TOTAINSE_DEPA_E;
                  ELSE
                     nCP_COSTUNOT_DEPA_E := 0;
                  END IF;
               END IF;
               --
               OPEN cImputa;
               FETCH cImputa INTO vImputa;
               CLOSE cImputa;
               --
               IF INSTR(vP_SEAUIMPR,'['||vSECCAUXI_DEPA||']') != 0 THEN
                   OPEN cMaquina('IMPRESORA');
                   FETCH cMaquina INTO vExisMaqu;
                   CLOSE cMaquina;
               ELSIF INSTR(vP_SEAULAMI,'['||vSECCAUXI_DEPA||']') != 0 THEN
                   OPEN cMaquina('LAMINADORA');
                   FETCH cMaquina INTO vExisMaqu;
                   CLOSE cMaquina;
               ELSIF INSTR(vP_SEAULAQU,'['||vSECCAUXI_DEPA||']') != 0 THEN
                   OPEN cMaquina('LAQUEADORA');
                   FETCH cMaquina INTO vExisMaqu;
                   CLOSE cMaquina;
               ELSIF INSTR(vP_SEAUCORT,'['||vSECCAUXI_DEPA||']') != 0 THEN
                   OPEN cMaquina('CORTADORA');
                   FETCH cMaquina INTO vExisMaqu;
                   CLOSE cMaquina;
               END IF;
               --
               IF vExisMaqu IS NOT NULL THEN
                  IF vImputa = 'COSTES ADMINISTRATIVOS' THEN
                     nCP_SUM_COSTADMI_E := NVL(nCP_SUM_COSTADMI_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
                  ELSIF vImputa = 'COSTES DE COMERCIALIZACIÓN' THEN
                     --Si es Nacional ó Exportacion
                     IF (vSECCAUXI_DEPA = vP_COSACONA AND vCP_TIPOPEDI = 'N') OR (vSECCAUXI_DEPA = vP_COSACOEX AND vCP_TIPOPEDI = 'E') THEN
                        nCP_SUM_COSTCOME_E := NVL(nCP_SUM_COSTCOME_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
                     END IF;
                     --
                     --:CP_SUM_COSTCOME_E := NVL(:CP_SUM_COSTCOME_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
                  ELSIF vImputa = 'COSTES DE DISTRIBUCIÓN' THEN
                     nCP_SUM_COSTDIST_E := NVL(nCP_SUM_COSTDIST_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
                  ELSIF vImputa = 'LOGÍSTICA INTERNA' THEN
                     nCP_SUM_LOGIINTE_E := NVL(nCP_SUM_LOGIINTE_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
                  ELSIF vImputa = 'ALMACÉN' THEN
                     nCP_SUM_ALMACEN_E := NVL(nCP_SUM_ALMACEN_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
                  ELSIF vImputa = 'OTROS COSTES DE PRODUCCIÓN' THEN
                     nCP_SUM_OTROCOST_E := NVL(nCP_SUM_OTROCOST_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
                  ELSIF vImputa = 'CALIDAD' THEN
                     nCP_SUM_CALIDAD_E := NVL(nCP_SUM_CALIDAD_E,0) + NVL(nCP_COSTUNOT_DEPA_E,0);
                  END IF;
               END IF;
            ELSE
               nCP_COSTUNOT_DEPA_E := NULL; 	
            END IF;
         END IF;
      END IF;
      --
      RETURN(nRetorno);
   END;
   begin
      OPEN cComisiones;
      FETCH cComisiones INTO nComisiones;
      CLOSE cComisiones;
      --
      nCP_SUM_COSTCOME_E := NVL(nCP_SUM_COSTCOME_E,0) + nComisiones;
       --Coste de Distribucion y Transporte
      OPEN cANE_CODEANNO;
      FETCH cANE_CODEANNO INTO nTAANSTES;
      CLOSE cANE_CODEANNO;
      --
      nCP_SUM_COSTDIST_E := NVL(nCP_SUM_COSTDIST_E,0) + (NVL(nCP_PRECIO_FAC,0) * NVL(nTAANSTES,0));
      --
      IF NOT (P_ANE_INTCRE.F_Obtiene_AM_ALM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'))) THEN
         P_ANE_INTCRE.P_BorraTabla;
         --
         P_ANE_INTCRE.P_Costes_Repartidos(NULL, NULL, NULL, NULL,
                                          TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
         --
         P_ANE_INTCRE.P_Adiciona_Tabla_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
      END IF;
      --
      IF NOT (P_ANE_INDECO.F_Obtiene_AM_ALM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'))) THEN
         P_ANE_INDECO.P_BorraTabla;
         --
         P_ANE_INDECO.P_Departamento_Comun(vEmpresa,
                                           NULL, NULL, NULL, NULL,
                                           TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));	
         --
         P_ANE_INDECO.P_Adiciona_Tabla_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
      END IF;
      --
      FOR rQ_DEPARTAM_IMPUTA IN cQ_DEPARTAM_IMPUTA LOOP
         FOR rG_TIPOCOST IN cG_TIPOCOST(rQ_DEPARTAM_IMPUTA.DEPARTAM_IMPUTA) LOOP
            IF rG_TIPOCOST.TIPOCOST_DEPA IS NOT NULL THEN
               vCF_TIPOCOST_DEPA_E := rG_TIPOCOST.TIPOCOST_DEPA||' '||rG_TIPOCOST.DESCTICO_DEPA;
            ELSE
               vCF_TIPOCOST_DEPA_E := rG_TIPOCOST.DESCTICO_DEPA;
            END IF;
            --
            FOR rG_SECCAUXI IN cG_SECCAUXI(rQ_DEPARTAM_IMPUTA.DEPARTAM_IMPUTA) LOOP
               nCF_COSTREPR_DEPA_E := CF_COSTREPR_DEPA_E(rG_SECCAUXI.DEPARTAM_DEPA, rG_SECCAUXI.SECCION_DEPA, rG_SECCAUXI.SECCAUXI_DEPA, 
                                                         rG_TIPOCOST.TIPOCOST_DEPA, rG_TIPOCOST.DESCTICO_DEPA,
                                                         rG_SECCAUXI.REPAABSO_DEPA,
                                                         rG_SECCAUXI.INDUREPR_DEPA, rG_SECCAUXI.CALCPRSU_REPR_DEPA,
                                                         rG_SECCAUXI.CAVAISDE_DEPA,
                                                         rG_SECCAUXI.INDURESE_DEPA, rG_SECCAUXI.CALCPRSU_RESE_DEPA,
                                                         rG_SECCAUXI.INREOBCO_DEPA);
            END LOOP;
         END LOOP;
      END LOOP;
      --
      RETURN(NULL);
   end;
--------------------TINTAS--------------------------
   FUNCTION CF_TINTAS(vEmpresa  FIC_CABEOTRE.EMPRESA%TYPE,  nNumero FIC_CABEOTRE.NUMERO%TYPE,
                      vTip_Arti FIC_CABEOTRE.TIP_ARTI%TYPE, vCod_Arti FIC_CABEOTRE.COD_ARTI%TYPE,
                      nModi FIC_CABEOTRE.MODI%TYPE, nRevi FIC_CABEOTRE.REVI%TYPE,
                      dFecha_Cierre DATE) 
   RETURN NUMBER IS
      CURSOR Q_MAQUINA IS
         SELECT DISTINCT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR
         FROM PRD_RECUUTIL RU
         WHERE RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RECUTIPO = 'J'
         UNION
         SELECT DISTINCT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR
         FROM PRD_HRECUUTI RU
         WHERE RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RECUTIPO = 'J'
         --PARA FORZAR LA EJECUCION DE ESTOS QUERIES YA QUE MUCHOS TOTALES SE CALCULAN EN FORMULAS DE ESTOS
         UNION
         SELECT vEmpresa EMPRESA, TO_NUMBER(nNumero) NUMEOTRE, 9999999999 CONTADOR FROM DUAL
         WHERE NOT EXISTS (
          SELECT DISTINCT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR
         FROM PRD_RECUUTIL RU
         WHERE RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RECUTIPO = 'J'
         UNION
         SELECT DISTINCT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR
         FROM PRD_HRECUUTI RU
         WHERE RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RECUTIPO = 'J');
      --
      CURSOR Q_TINTERO(nContador PRD_HRECUUTI.CONTADOR%TYPE) IS
         SELECT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR, RU.RECUCODI, RU.MATECODE, HC.COLOR, HC.PANTONE, HC.TIPO_IMPRE, HC.ANILOX, HC.SUPEARIM, HC.POSICION
         FROM PRD_RECUUTIL RU, 
              HFCOLORE HC
         WHERE RU.EMPRESA = HC.EMPRESA
           AND HC.TIP_ARTI = vTip_Arti
           AND HC.PRODUCTO = vCod_Arti
           AND HC.MODI = nModi
           AND HC.REVI = nRevi
           AND RU.RECUCODI = HC.POSICION||'-'||HC.COLOR
           AND RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RU.CONTADOR = nContador
           AND RU.RECUTIPO = 'J'
         UNION
         SELECT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR, RU.RECUCODI, RU.MATECODE, HC.COLOR, HC.PANTONE, HC.TIPO_IMPRE, HC.ANILOX, HC.SUPEARIM, HC.POSICION
         FROM PRD_HRECUUTI RU, 
              HFCOLORE HC
         WHERE RU.EMPRESA = HC.EMPRESA
           AND HC.TIP_ARTI = vTip_Arti
           AND HC.PRODUCTO = vCod_Arti
           AND HC.MODI = nModi
           AND HC.REVI = nRevi
           AND RU.RECUCODI = HC.POSICION||'-'||HC.COLOR
           AND RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RU.CONTADOR = nContador
           AND RU.RECUTIPO = 'J'
         --PARA FORZAR LA EJECUCION DE ESTOS QUERIES YA QUE MUCHOS TOTALES SE CALCULAN EN FORMULAS DE ESTOS
         UNION
         SELECT vEmpresa EMPRESA, TO_NUMBER(nNumero) NUMEOTRE, 9999999999 CONTADOR, 'XXX' RECUCODI, 'XXX' MATECODE, 'XXX' COLOR, 'XXX' PANTONE, 'XXX' TIPO_IMPRE, 'XXX' ANILOX, 0 SUPEARIM, 99 POSICION 
         FROM DUAL
         WHERE NOT EXISTS (
         SELECT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR, RU.RECUCODI, RU.MATECODE, HC.COLOR, HC.PANTONE, HC.TIPO_IMPRE, HC.ANILOX, HC.SUPEARIM, HC.POSICION
         FROM PRD_RECUUTIL RU, 
              HFCOLORE HC
         WHERE RU.EMPRESA = HC.EMPRESA
           AND HC.TIP_ARTI = vTip_Arti
           AND HC.PRODUCTO = vCod_Arti
           AND HC.MODI = nModi
           AND HC.REVI = nRevi
           AND RU.RECUCODI = HC.POSICION||'-'||HC.COLOR
           AND RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RU.CONTADOR = nContador
           AND RU.RECUTIPO = 'J'
         UNION
         SELECT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR, RU.RECUCODI, RU.MATECODE, HC.COLOR, HC.PANTONE, HC.TIPO_IMPRE, HC.ANILOX, HC.SUPEARIM, HC.POSICION
         FROM PRD_HRECUUTI RU, 
              HFCOLORE HC
         WHERE RU.EMPRESA = HC.EMPRESA
           AND HC.TIP_ARTI = vTip_Arti
           AND HC.PRODUCTO = vCod_Arti
           AND HC.MODI = nModi
           AND HC.REVI = nRevi
           AND RU.RECUCODI = HC.POSICION||'-'||HC.COLOR
           AND RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RU.CONTADOR = nContador
           AND RU.RECUTIPO = 'J')
         ORDER BY POSICION;
      --
      CURSOR Q_COMPFORM(vMateCode PRD_HRECUUTI.MATECODE%TYPE) IS
         SELECT CF.EMPRESA, CF.IM_FORMU, CF.IM_COMPO, C.IM_DESCR, CF.IM_CANTI, TIP_ARTI TIP_ARTI_COM, COD_ARTI COD_ARTI_COM
         FROM PRI_COMPFORM CF, PRI_EQCOTINT C
         WHERE CF.EMPRESA = C.EMPRESA
           AND CF.IM_COMPO = C.IM_IDENT
           AND CF.EMPRESA = vEmpresa
           AND TO_CHAR(CF.IM_FORMU) = vMateCode
         --PARA FORZAR LA EJECUCION DE ESTOS QUERIES YA QUE MUCHOS TOTALES SE CALCULAN EN FORMULAS DE ESTOS
         UNION
         SELECT vEmpresa EMPRESA, 999 IM_FORMU, 999 IM_COMPO, 'XXX' IM_DESCR, 0 IM_CANTI, 'X' TIP_ARTI_COM, 'XXX' COD_ARTI_COM
         FROM DUAL
         WHERE NOT EXISTS (
         SELECT CF.EMPRESA, CF.IM_FORMU, CF.IM_COMPO, C.IM_DESCR, CF.IM_CANTI, TIP_ARTI TIP_ARTI_COM, COD_ARTI COD_ARTI_COM
         FROM PRI_COMPFORM CF, PRI_EQCOTINT C
         WHERE CF.EMPRESA = C.EMPRESA
           AND CF.IM_COMPO = C.IM_IDENT
           AND CF.EMPRESA = vEmpresa
           AND TO_CHAR(CF.IM_FORMU) = vMateCode);
      --FORMULA CF_PORCCOMP
      nRetorno_CF_PORCCOMP NUMBER;
      --Cursor de Precio Medio Estandar
      CURSOR cPrmeEsta(vIM_COMPO ANE_PRMECOTI.IM_COMPO%TYPE) IS
         SELECT DECODE(NVL(CANTIDAD,0),0,0, NVL(PRECIO,0) / CANTIDAD) FROM ANE_PRMECOTI
            WHERE EMPRESA = vEmpresa
              AND IM_COMPO = vIM_COMPO
              AND ANNO = TO_CHAR(dFecha_Cierre,'YYYY')
              AND MES = DECODE(TO_CHAR(dFecha_Cierre,'MM'),'01','ENERO',
                                                           '02','FEBRERO',
                                                           '03','MARZO',
                                                           '04','ABRIL',
                                                           '05','MAYO',
                                                           '06','JUNIO',
                                                           '07','JULIO',
                                                           '08','AGOSTO',
                                                           '09','SEPTIEMBRE',
                                                           '10','OCTUBRE',
                                                           '11','NOVIEMBRE',
                                                           '12','DICIEMBRE')
              AND TIPO = 'E';
      --
      --Consumo Real del Componente
      nConsReco NUMBER;
      --Cursor para calcular el Consumo Real del Componente
      CURSOR cConsReco(vTIP_ARTI_COM FV_ASALHI01.VATCOD%TYPE, vCOD_ARTI_COM FV_ASALHI01.ARCARF%TYPE) IS
         SELECT SUM(AHCANT) CantCons 
            FROM FV_ASALHI01
               WHERE EMCODI = vEmpresa
                 AND VATCOD = vTIP_ARTI_COM
                 AND ARCARF = vCOD_ARTI_COM
                 AND AHTIMO = 'S'
                 AND TRUNC(AHFMOV) BETWEEN TO_DATE('01-'||TO_CHAR(dFecha_Cierre,'MM-YYYY'),'DD-MM-YYYY') AND TRUNC(LAST_DAY(dFecha_Cierre));
      --Cursor para buscar todas las OT's del periodo que poseen el componente
      -- |
      -- V TODO LO QUE SIGUE ES DEL TRATAMIENTO DE TODAS LAS OT's
      --
      CURSOR cOTsComp(vTIP_ARTI_COM FV_ASALHI01.VATCOD%TYPE, vCOD_ARTI_COM FV_ASALHI01.ARCARF%TYPE) IS
         SELECT O.* FROM FIC_CABEOTRE O
         WHERE O.SITUACIO = 'C' --Cerradas
           AND O.EMPRESA = vEmpresa
           AND TRUNC(O.FEC_MODI) BETWEEN TO_DATE('01-'||TO_CHAR(dFecha_Cierre,'MM-YYYY'),'DD-MM-YYYY') AND TRUNC(LAST_DAY(dFecha_Cierre)) --En el periodo
           AND EXISTS (SELECT 'X'
                 FROM PRD_RECUUTIL RU
                 WHERE RU.EMPRESA = O.EMPRESA
                   AND RU.NUMEOTRE = O.NUMERO
                   AND RU.RECUTIPO = 'J' --Que sean tintas
                   AND EXISTS (SELECT 'X'
                               FROM PRI_COMPFORM CF, PRI_EQCOTINT C
                               WHERE CF.EMPRESA = C.EMPRESA
                                 AND CF.IM_COMPO = C.IM_IDENT
                                 AND CF.EMPRESA = RU.EMPRESA
                                 AND TO_CHAR(CF.IM_FORMU) = RU.MATECODE
                                 AND C.TIP_ARTI = vTIP_ARTI_COM --Que contengan el componente
                                 AND C.COD_ARTI = vCOD_ARTI_COM)--Que contengan el componente
                 UNION
                 SELECT 'X'
                 FROM PRD_HRECUUTI RU
                 WHERE RU.EMPRESA = O.EMPRESA
                   AND RU.NUMEOTRE = O.NUMERO
                   AND RU.RECUTIPO = 'J'
                   AND EXISTS (SELECT 'X'
                               FROM PRI_COMPFORM CF, PRI_EQCOTINT C
                               WHERE CF.EMPRESA = C.EMPRESA
                                 AND CF.IM_COMPO = C.IM_IDENT
                                 AND CF.EMPRESA = RU.EMPRESA
                                 AND TO_CHAR(CF.IM_FORMU) = RU.MATECODE
                                 AND C.TIP_ARTI = vTIP_ARTI_COM
                                 AND C.COD_ARTI = vCOD_ARTI_COM));              
      --
      nCp_Ancho_Mm_Prod_TIN FIC_INFOPROD.TOTAL%TYPE;
      nCp_N_Veces FIC_INFOPROD.N_VECES%TYPE;
      --Maquinas Impresoras para la OT
      CURSOR cMaquinas(nNumero FIC_CABEOTRE.NUMERO%TYPE, vTIP_ARTI_COM FV_ASALHI01.VATCOD%TYPE, vCOD_ARTI_COM FV_ASALHI01.ARCARF%TYPE) IS
         SELECT DISTINCT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR
         FROM PRD_RECUUTIL RU
         WHERE RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RECUTIPO = 'J'
                   AND EXISTS (SELECT 'X'
                               FROM PRI_COMPFORM CF, PRI_EQCOTINT C
                               WHERE CF.EMPRESA = C.EMPRESA
                                 AND CF.IM_COMPO = C.IM_IDENT
                                 AND CF.EMPRESA = RU.EMPRESA
                                 AND TO_CHAR(CF.IM_FORMU) = RU.MATECODE
                                 AND C.TIP_ARTI = vTIP_ARTI_COM --Que contengan el componente
                                 AND C.COD_ARTI = vCOD_ARTI_COM)--Que contengan el componente
         UNION
         SELECT DISTINCT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR
         FROM PRD_HRECUUTI RU
         WHERE RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RECUTIPO = 'J'
                   AND EXISTS (SELECT 'X'
                               FROM PRI_COMPFORM CF, PRI_EQCOTINT C
                               WHERE CF.EMPRESA = C.EMPRESA
                                 AND CF.IM_COMPO = C.IM_IDENT
                                 AND CF.EMPRESA = RU.EMPRESA
                                 AND TO_CHAR(CF.IM_FORMU) = RU.MATECODE
                                 AND C.TIP_ARTI = vTIP_ARTI_COM --Que contengan el componente
                                 AND C.COD_ARTI = vCOD_ARTI_COM);--Que contengan el componente
      --
      CURSOR cPasadas(nNumero PRD_PASAMAQU.NUMEOTRE%TYPE, nContador PRD_PASAMAQU.CONTADOR%TYPE) IS
         SELECT SUM(PA.CANTPROD) FROM PRD_PASAMAQU PA
         WHERE PA.EMPRESA = vEmpresa
           AND PA.NUMEOTRE = nNumero
           AND PA.CONTADOR = nContador
           AND PA.MARCPASA = 'N';
      --
      nPasadas NUMBER;
      nCp_M2_Impresora NUMBER;
      --
      CURSOR cTinteros(nNumero PRD_PASAMAQU.NUMEOTRE%TYPE, nContador PRD_PASAMAQU.CONTADOR%TYPE,
                       vTip_Arti HFCOLORE.TIP_ARTI%TYPE, vCod_Arti HFCOLORE.PRODUCTO%TYPE,
                       nModi HFCOLORE.MODI%TYPE, nRevi HFCOLORE.REVI%TYPE,
                       vMateCode PRD_RECUUTIL.MATECODE%TYPE) IS 
         SELECT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR, RU.RECUCODI, RU.MATECODE, HC.COLOR, HC.PANTONE, HC.TIPO_IMPRE, HC.ANILOX, HC.SUPEARIM, HC.POSICION
         FROM PRD_RECUUTIL RU, 
              HFCOLORE HC
         WHERE RU.EMPRESA = HC.EMPRESA
           AND HC.TIP_ARTI = vTip_Arti
           AND HC.PRODUCTO = vCod_Arti
           AND HC.MODI = nModi
           AND HC.REVI = nRevi
           AND RU.RECUCODI = HC.POSICION||'-'||HC.COLOR
           AND RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RU.CONTADOR = nContador
           AND RU.RECUTIPO = 'J'
               AND RU.MATECODE = vMateCode
         UNION
         SELECT RU.EMPRESA, RU.NUMEOTRE, RU.CONTADOR, RU.RECUCODI, RU.MATECODE, HC.COLOR, HC.PANTONE, HC.TIPO_IMPRE, HC.ANILOX, HC.SUPEARIM, HC.POSICION
         FROM PRD_HRECUUTI RU, 
              HFCOLORE HC
         WHERE RU.EMPRESA = HC.EMPRESA
           AND HC.TIP_ARTI = vTip_Arti
           AND HC.PRODUCTO = vCod_Arti
           AND HC.MODI = nModi
           AND HC.REVI = nRevi
           AND RU.RECUCODI = HC.POSICION||'-'||HC.COLOR
           AND RU.EMPRESA = vEmpresa
           AND RU.NUMEOTRE = nNumero
           AND RU.CONTADOR = nContador
           AND RU.RECUTIPO = 'J'
               AND RU.MATECODE = vMateCode;
      --
      CURSOR cPRI_DEFIANIL(vTipo_Impre HFCOLORE.TIPO_IMPRE%TYPE, vAnilox PRI_DEFIANIL.CODIGO%TYPE) IS
         SELECT DA.* FROM PRI_DEFIANIL DA, VALORES_LISTA VL
            WHERE VL.CODIGO = 'FIC_TIPOIMPR'
              AND P_UTILIDAD.F_ValoCampo (VL.VALOR,'VALOR') = vTipo_Impre
              AND DA.TIPOIMPR = P_UTILIDAD.F_ValoCampo (VALOR,'TIPOIMPR')
              AND DA.CODIGO = vAnilox;
      --
      rPRI_DEFIANIL cPRI_DEFIANIL%ROWTYPE;
      --
      nPeesTint NUMBER;
      --
      nTotaGram NUMBER := 0;
      --
      nCp_ApoCm3M2 NUMBER;
      nCp_VoluMcM3 NUMBER;
      nCp_PeesTint NUMBER;
      nCp_ConsTeKG NUMBER;
      nCf_SupeAIM2 NUMBER;
      --Componentes de la Formula
      CURSOR cCompoForm(vMateCode PRI_COMPFORM.IM_FORMU%TYPE) IS
         SELECT CF.EMPRESA, CF.IM_FORMU, CF.IM_COMPO, C.IM_DESCR, CF.IM_CANTI, TIP_ARTI TIP_ARTI_COM, COD_ARTI COD_ARTI_COM
         FROM PRI_COMPFORM CF, PRI_EQCOTINT C
         WHERE CF.EMPRESA = C.EMPRESA
           AND CF.IM_COMPO = C.IM_IDENT
           AND CF.EMPRESA = vEmpresa
           AND CF.IM_FORMU = vMateCode;
      --
      nCs_Im_Canti NUMBER;
      nCp_CoteKgCo NUMBER;
      nCs_CoteKgCo NUMBER := 0;
      -- 
      nCp_ApoCm3M2_OT NUMBER;
      nCp_VoluMcM3_OT NUMBER;
      nCp_PeesTint_OT NUMBER;
      nCp_ConsTeKG_OT NUMBER;
      --Para evitar error circular ESTE TRATAMIENTO YA SE ENCUENTRA EN CF_SUPEAIM2Formula
      --
      CURSOR cSumaCantComp(vMateCode VARCHAR2, vIm_Formu VARCHAR2) IS--PRI_COMPFORM.IM_FORMU%TYPE, vIm_Formu PRI_COMPFORM.IM_FORMU%TYPE) IS
         SELECT SUM(CF.IM_CANTI) IM_CANTI
            FROM PRI_COMPFORM CF, PRI_EQCOTINT C
               WHERE CF.EMPRESA = C.EMPRESA
                 AND CF.IM_COMPO = C.IM_IDENT
                 AND CF.EMPRESA = vEmpresa
                 AND TO_CHAR(CF.IM_FORMU) = vMATECODE
                 AND TO_CHAR(CF.IM_FORMU) = vIM_FORMU;
      --
      nSumaCantComp NUMBER;              
      --FIN FORMULA CF_PORCCOMP
      --FORMULA CF_SUPEAIM2
      nRetorno_CF_SUPEAIM2 NUMBER;
      --
      nPeesTint_AIM2 NUMBER;
      --
      nTotaGram NUMBER := 0;
      --Componenes Disolventes / Tintas compradas a proveedores / Tintas Fabricadas Estandar
      CURSOR cConsImpuVariOTs_Estandar(vTipoComp ANE_COINVAOT.TIPOCOMP%TYPE) IS
         SELECT SUM(PRECIO) PRECIO, SUM(CANTIDAD) CANTIDAD, SUM(CONSUMO) CONSUMO FROM ANE_COINVAOT
            WHERE EMPRESA = vEmpresa
              AND ANNO = TO_CHAR(dFecha_Cierre,'YYYY')
              AND MES = DECODE(TO_CHAR(dFecha_Cierre,'MM'),'01','ENERO',
                                                           '02','FEBRERO',
                                                           '03','MARZO',
                                                           '04','ABRIL',
                                                           '05','MAYO',
                                                           '06','JUNIO',
                                                           '07','JULIO',
                                                           '08','AGOSTO',
                                                           '09','SEPTIEMBRE',
                                                           '10','OCTUBRE',
                                                           '11','NOVIEMBRE',
                                                           '12','DICIEMBRE')
              AND TIPO = 'E' 
              AND TIPOCOMP = vTipoComp;
      --
      rConsImpuVariOTs_Estandar cConsImpuVariOTs_Estandar%ROWTYPE;
      --
      nPRECMEDI_AIM2 NUMBER := 0;
      nCOSTCONS_AIM2 NUMBER := 0;
      nCOUNKGTO_AIM2 NUMBER := 0;
      --
      CURSOR cInductorKGTinta_Estandar IS
         SELECT ENERO,FEBRERO,MARZO,ABRIL,MAYO,JUNIO,JULIO,AGOSTO,SEPTIEMBRE,OCTUBRE,NOVIEMBRE,DICIEMBRE
            FROM ANE_CONFISRE
               WHERE EMPRESA = vEmpresa
                 AND ANNO = TO_CHAR(dFecha_Cierre,'YYYY')
                 AND DEPARTAM = vP_CODETINT
                 AND INDUCTOR = vP_INDUKGTI;
      --
      rInductorKGTinta_Estandar cInductorKGTinta_Estandar%ROWTYPE;
      --
      nKILOTINT_AIM2 NUMBER := 0;
      --
      --Componenes Disolventes / Tintas compradas a proveedores / Tintas Fabricadas Real
      CURSOR cConsImpuVariOTs_Real(vTipoComp ANE_COINVAOT.TIPOCOMP%TYPE) IS
         SELECT H.VATCOD, H.ARCARF, SUM(DECODE(AHTIMO,'E',AHCANT,0)) CANTIDAD, SUM(DECODE(AHTIMO,'S',AHCANT,0)) CONSUMO
         FROM FV_ASALHI01 H, PRI_CODEVALO VL 
            WHERE H.EMCODI = VL.EMPRESA
              AND H.VATCOD = P_UTILIDAD.F_ValoCampo (VL.DESCRIPC,'TIP_ARTI')
              AND H.ARCARF = P_UTILIDAD.F_ValoCampo (VL.DESCRIPC,'COD_ARTI')
              AND VL.EMPRESA = vEmpresa
              AND VL.CODIMAES = 'COMPUTRE'
              AND P_UTILIDAD.F_ValoCampo (VL.DESCRIPC,'TIPOCOMP') = vTipoComp
              AND TRUNC(H.AHFMOV) BETWEEN TO_DATE('01-'||TO_CHAR(dFecha_Cierre,'MM-YYYY'),'DD-MM-YYYY') AND TRUNC(LAST_DAY(dFecha_Cierre))
         GROUP BY H.VATCOD, H.ARCARF;
      --
      nPrecComp_AIM2 FV_ASCOAL02.ALPREU%TYPE;
      --
      nCantPrme_AIM2 NUMBER := 0;
      nPrecPrme_AIM2 NUMBER := 0;
      --
      CURSOR cInductorKGTinta_Real IS
         SELECT VALOR
            FROM ANE_CONFISRR
               WHERE EMPRESA = vEmpresa
                 AND ANNO = TO_CHAR(dFecha_Cierre,'YYYY')
                 AND MES = DECODE(TO_CHAR(dFecha_Cierre,'MM'),'01','ENERO',
                                                           '02','FEBRERO',
                                                           '03','MARZO',
                                                           '04','ABRIL',
                                                           '05','MAYO',
                                                           '06','JUNIO',
                                                           '07','JULIO',
                                                           '08','AGOSTO',
                                                           '09','SEPTIEMBRE',
                                                           '10','OCTUBRE',
                                                           '11','NOVIEMBRE',
                                                           '12','DICIEMBRE')
                 AND DEPARTAM = vP_CODETINT
                 AND INDUCTOR = vP_INDUKGTI;
      --
      rInductorKGTinta_Real cInductorKGTinta_Real%ROWTYPE;    
      --FIN FORMULA CF_SUPEAIM2
      nRetorno_CF_IMPRESORA NUMBER;
      --CONSTANTES COMPFORM
      nCP_COTEKGCO_CF NUMBER := 0;--CONSUMO TEORICO REAL
      nCP_COREKGCO NUMBER := 0;--CONSUMO RECLASIFICADO REAL
      nCP_COTOKGCO NUMBER := 0;--CONSUMO TOTAL REAL
      nCP_PRECMERE NUMBER := 0;--PRECIO MEDIO REAL
      nCP_COERCONS NUMBER := 0;--COSTE EN € DEL CONSUMO REAL
      nCP_PRECMEES NUMBER := 0;--PRECIO MEDIO ESTANDAR
      nCP_COEECONS NUMBER := 0;--COSTE EN € DEL CONSUMO ESTANDAR
      nCP_CORECOCA NUMBER := 0;--COMPARATIVO REAL - ESTANDAR / CONSUMO / CANTIDAD
      nCP_CORECOPO NUMBER := 0;--COMPARATIVO REAL - ESTANDAR / CONSUMO / %
      nCP_COREPMPR NUMBER := 0;--COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ PRECIO
      nCP_COREPMPO NUMBER := 0;--COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ %
      nCP_CORECOCO NUMBER := 0;--COMPARATIVO REAL - ESTANDAR / COSTE/ COSTE
      nCP_CORECOPJ NUMBER := 0;--COMPARATIVO REAL - ESTANDAR / COSTE/ %
      --FIN CONSTANTES COMPFORM
      --CONSTANTES TINTERO
      nCS_CP_SUM_COSTUNOT NUMBER := 0;--F(X)
      nCS_CP_SUM_COSTUNOT_E NUMBER := 0;--F(X)
      nCS_CF_PORCCOMP NUMBER := 0; --SUMA % (SUM)
      nCP_CP_COTEKGCO NUMBER := 0; --SUMA CONSUMO TEORICO REAL
      nCP_CP_PRECMEES NUMBER := 0; --SUMA PRECIO MEDIO ESTANDAR
      nCP_CP_COEECONS NUMBER := 0; --SUMA COSTE EN € DEL CONSUMO ESTANDAR
      nCP_CP_COREKGCO NUMBER := 0; --SUMA CONSUMO RECLASIFICADO REAL
      nCP_CP_COTOKGCO NUMBER := 0; --SUMA CONSUMO TOTAL REAL
      nCP_CP_PRECMERE NUMBER := 0; --SUMA PRECIO MEDIO REAL
      nCP_CP_COERCONS NUMBER := 0; --SUMA COSTE EN € DEL CONSUMO REAL
      nCP_CP_CORECOCA NUMBER := 0; --SUMA COMPARATIVO REAL - ESTANDAR / CONSUMO / CANTIDAD
      nCP_CP_CORECOPO NUMBER := 0; --SUMA COMPARATIVO REAL - ESTANDAR / CONSUMO / %
      nCP_CP_COREPMPR NUMBER := 0; --SUMA COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ PRECIO
      nCP_CP_COREPMPO NUMBER := 0; --SUMA COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ %
      nCP_CP_CORECOCO NUMBER := 0; --SUMA COMPARATIVO REAL - ESTANDAR / COSTE/ COSTE
      nCP_CP_CORECOPJ NUMBER := 0; --SUMA COMPARATIVO REAL - ESTANDAR / COSTE/ %
      nCP_APOCM3M2_TIN NUMBER := 0; --(CAM _TIN)
      nCP_VOLUMCM3_TIN NUMBER := 0; --(CAM _TIN)
      nCP_PEESTINT_TIN NUMBER := 0; --(CAM _TIN)
      nCP_CONSTEKG_TIN NUMBER := 0; --(CAM _TIN)
      nCS_IM_CANTI_TIN NUMBER := 0; --(CAM _TIN) (SUM)
      nCP_COSTCTKT NUMBER := 0; --COSTE  POR  CONSUMO TEORICO DE KG DE TINTA
      nCP_COSTCRKT NUMBER := 0; --COSTE  POR  CONSUMO REAL DE KG DE TINTA
      nCP_DIFECOKT NUMBER := 0; --DIFERENCIA REAL - ESTANDAR POR COSTE DE CONSUMO TEORICO DE KG DE TINTA
      nCP_PORCCOKT NUMBER := 0; --DIFERENCIA REAL - ESTANDAR POR COSTE DE CONSUMO TEORICO DE KG DE TINTA %
      nCP_COKGTCDI NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / ESTANDAR / POR DISOLVENTES
      nCP_COKGTCTB NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / ESTANDAR / POR TINTAS BASE
      nCP_COKGTCCT NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / ESTANDAR / COSTE TOTAL
      nCP_COKGTCDR NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL/ POR DISOLVENTES
      nCP_COKGTCTR NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL/ POR TINTAS BASE
      nCP_COKGTCCR NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL/ COSTE TOTAL
      nCP_DICKTCDI NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / DIFERENCIA/ POR DISOLVENTES
      nCP_POCKTCDI NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE/ POR DISOLVENTES
      nCP_DICKTCTB NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / DIFERENCIA/ POR TINTAS BASE
      nCP_POCKTCTB NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE/ POR TINTAS BASE
      nCP_DICKTCCT NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / DIFERENCIA/ COSTE TOTAL
      nCP_POCKTCCT NUMBER := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE/ COSTE TOTAL
      nCP_COTODIES NUMBER := 0; --COSTE TOTAL DIRECTO ESTANDAR
      nCP_COTOINES NUMBER := 0; --COSTE TOTAL INDIRECTO ESTANDAR
      nCP_TOCODIES NUMBER := 0; --TOTAL COSTE ESTANDAR
      nCP_COTODIRE NUMBER := 0; --COSTE TOTAL DIRECTO REAL
      nCP_COTOINRE NUMBER := 0; --COSTE TOTAL INDIRECTO REAL
      nCP_TOCODIRE NUMBER := 0; --TOTAL COSTE REAL
      nCP_DICTDIRE NUMBER := 0; --DIFERENCIA COSTE TOTAL DIRECTO
      nCP_POCTDIRE NUMBER := 0; --PORCENTAJE DIFERENCIA COSTE TOTAL DIRECTO
      nCP_DICTINDI NUMBER := 0; --DIFERENCIA COSTE TOTAL INDIRECTO
      nCP_POCTINDI NUMBER := 0; --PORCENTAJE DIFERENCIA COSTE TOTAL INDIRECTO
      nCP_DICTTOCO NUMBER := 0; --DIFERENCIA COSTE TOTAL
      nCP_POCTTOCO NUMBER := 0; --PORCENTAJE DIFERENCIA COSTE TOTAL
      --FIN CONSTANTES TINTERO
      --CONSTANTES MAQUINA
      nCP_CP_POSICION NUMBER; --(OJO)
      nCP_CP_NUMERO NUMBER; --(OJO)
      nCP_M2_IMPRESORA_MAQ NUMBER := 0; --(CAM _MAQ)
      nCS_SUPEARIM NUMBER := 0; --(SUM)
      nCS_CF_SUPEAIM2 NUMBER := 0; --(SUM)
      nCS_CP_VOLUMCM3 NUMBER := 0; --(SUM)
      nCS_CP_CONSTEKG NUMBER := 0; --(SUM)
      nCS_CP_COSTCTKT NUMBER := 0; --(SUM)
      nCP_CP_COSTCTKT NUMBER := 0; 
      nCS_CP_COSTCRKT NUMBER := 0; --(SUM)
      nCP_CP_COSTCRKT NUMBER := 0; 
      nCS_CP_DIFECOKT NUMBER := 0; --(SUM)
      nCP_CP_PORCCOKT NUMBER := 0; 
      nCS_CP_COKGTCDI NUMBER := 0; --(SUM)
      nCP_CP_COKGTCDI NUMBER := 0; 
      nCS_CP_COKGTCTB NUMBER := 0; --(SUM)
      nCP_CP_COKGTCTB NUMBER := 0; 
      nCS_CP_COKGTCCT NUMBER := 0; --(SUM)
      nCP_CP_COKGTCCT NUMBER := 0; 
      nCS_CP_COKGTCDR NUMBER := 0; --(SUM)
      nCP_CP_COKGTCDR NUMBER := 0; 
      nCS_CP_COKGTCTR NUMBER := 0; --(SUM)
      nCP_CP_COKGTCTR NUMBER := 0; 
      nCS_CP_COKGTCCR NUMBER := 0; --(SUM)
      nCP_CP_COKGTCCR NUMBER := 0;
      nCS_CP_DICKTCDI NUMBER := 0; --(SUM)
      nCP_CP_POCKTCDI NUMBER := 0;
      nCS_CP_DICKTCTB NUMBER := 0; --(SUM)
      nCP_CP_POCKTCTB NUMBER := 0;
      nCS_CP_DICKTCCT NUMBER := 0; --(SUM)
      nCP_CP_POCKTCCT NUMBER := 0;
      nCS_CP_COTODIES NUMBER := 0; --(SUM)
      nCP_CP_COTODIES NUMBER := 0;
      nCS_CP_COTOINES NUMBER := 0; --(SUM)
      nCP_CP_COTOINES NUMBER := 0;
      --nCS_CP_TOCODIES NUMBER := 0; --(SUM)
      nCP_CP_TOCODIES NUMBER := 0;
      nCS_CP_COTODIRE NUMBER := 0; --(SUM)
      nCP_CP_COTODIRE NUMBER := 0;
      nCS_CP_COTOINRE NUMBER := 0; --(SUM)
      nCP_CP_COTOINRE NUMBER := 0;
      --nCS_CP_TOCODIRE NUMBER := 0; --(SUM)
      nCP_CP_TOCODIRE NUMBER := 0;
      nCS_CP_DICTDIRE NUMBER := 0; --(SUM)
      nCP_CP_POCTDIRE NUMBER := 0;
      nCS_CP_DICTINDI NUMBER := 0; --(SUM)
      nCP_CP_POCTINDI NUMBER := 0;
      nCS_CP_DICTTOCO NUMBER := 0; --(SUM)
      nCP_CP_POCTTOCO NUMBER := 0;
      --FIN CONSTANTES MAQUINA
   BEGIN
      nCS_CP_TOCODIRE := 0;
      --
      nCS_CP_TOCODIES := 0;
      --
      FOR R_MAQUINA IN Q_MAQUINA LOOP
         OPEN cPasadas(R_MAQUINA.NUMEOTRE,R_MAQUINA.CONTADOR);
         FETCH cPasadas INTO nRetorno_CF_IMPRESORA;
         CLOSE cPasadas;
         --
         nRetorno_CF_IMPRESORA := NVL(nRetorno_CF_IMPRESORA,0);
         --
         nCP_M2_IMPRESORA_MAQ := nRetorno_CF_IMPRESORA * (NVL(nCP_ANCHO_MM_PROD,0) / 1000);
         -->
         nCS_CP_SUM_COSTUNOT := 0;--F(X)
         nCS_CP_SUM_COSTUNOT_E := 0;--F(X)
         nCS_CF_PORCCOMP := 0; --SUMA % (SUM)
         nCP_CP_COTEKGCO := 0; --SUMA CONSUMO TEORICO REAL
         nCP_CP_PRECMEES := 0; --SUMA PRECIO MEDIO ESTANDAR
         nCP_CP_COEECONS := 0; --SUMA COSTE EN € DEL CONSUMO ESTANDAR
         nCP_CP_COREKGCO := 0; --SUMA CONSUMO RECLASIFICADO REAL
         nCP_CP_COTOKGCO := 0; --SUMA CONSUMO TOTAL REAL
         nCP_CP_PRECMERE := 0; --SUMA PRECIO MEDIO REAL
         nCP_CP_COERCONS := 0; --SUMA COSTE EN € DEL CONSUMO REAL
         nCP_CP_CORECOCA := 0; --SUMA COMPARATIVO REAL - ESTANDAR / CONSUMO / CANTIDAD
         nCP_CP_CORECOPO := 0; --SUMA COMPARATIVO REAL - ESTANDAR / CONSUMO / %
         nCP_CP_COREPMPR := 0; --SUMA COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ PRECIO
         nCP_CP_COREPMPO := 0; --SUMA COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ %
         nCP_CP_CORECOCO := 0; --SUMA COMPARATIVO REAL - ESTANDAR / COSTE/ COSTE
         nCP_CP_CORECOPJ := 0; --SUMA COMPARATIVO REAL - ESTANDAR / COSTE/ %
         nCP_APOCM3M2_TIN := 0; --(CAM _TIN)
         nCP_VOLUMCM3_TIN := 0; --(CAM _TIN)
         nCP_PEESTINT_TIN := 0; --(CAM _TIN)
         nCP_CONSTEKG_TIN := 0; --(CAM _TIN)
         nCS_IM_CANTI_TIN := 0; --(CAM _TIN) (SUM)
         nCP_COSTCTKT := 0; --COSTE  POR  CONSUMO TEORICO DE KG DE TINTA
         nCP_COSTCRKT := 0; --COSTE  POR  CONSUMO REAL DE KG DE TINTA
         nCP_DIFECOKT := 0; --DIFERENCIA REAL - ESTANDAR POR COSTE DE CONSUMO TEORICO DE KG DE TINTA
         nCP_PORCCOKT := 0; --DIFERENCIA REAL - ESTANDAR POR COSTE DE CONSUMO TEORICO DE KG DE TINTA %
         nCP_COKGTCDI := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / ESTANDAR / POR DISOLVENTES
         nCP_COKGTCTB := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / ESTANDAR / POR TINTAS BASE
         nCP_COKGTCCT := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / ESTANDAR / COSTE TOTAL
         nCP_COKGTCDR := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL/ POR DISOLVENTES
         nCP_COKGTCTR := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL/ POR TINTAS BASE
         nCP_COKGTCCR := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL/ COSTE TOTAL
         nCP_DICKTCDI := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / DIFERENCIA/ POR DISOLVENTES
         nCP_POCKTCDI := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE/ POR DISOLVENTES
         nCP_DICKTCTB := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / DIFERENCIA/ POR TINTAS BASE
         nCP_POCKTCTB := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE/ POR TINTAS BASE
         nCP_DICKTCCT := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / DIFERENCIA/ COSTE TOTAL
         nCP_POCKTCCT := 0; --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE/ COSTE TOTAL
         nCP_COTODIES := 0; --COSTE TOTAL DIRECTO ESTANDAR
         nCP_COTOINES := 0; --COSTE TOTAL INDIRECTO ESTANDAR
         nCP_TOCODIES := 0; --TOTAL COSTE ESTANDAR
         nCP_COTODIRE := 0; --COSTE TOTAL DIRECTO REAL
         nCP_COTOINRE := 0; --COSTE TOTAL INDIRECTO REAL
         nCP_TOCODIRE := 0; --TOTAL COSTE REAL
         nCP_DICTDIRE := 0; --DIFERENCIA COSTE TOTAL DIRECTO
         nCP_POCTDIRE := 0; --PORCENTAJE DIFERENCIA COSTE TOTAL DIRECTO
         nCP_DICTINDI := 0; --DIFERENCIA COSTE TOTAL INDIRECTO
         nCP_POCTINDI := 0; --PORCENTAJE DIFERENCIA COSTE TOTAL INDIRECTO
         nCP_DICTTOCO := 0; --DIFERENCIA COSTE TOTAL
         nCP_POCTTOCO := 0; --PORCENTAJE DIFERENCIA COSTE TOTAL
         --
         FOR R_TINTERO IN Q_TINTERO(R_MAQUINA.CONTADOR) LOOP
            -->
            --F(X)
            nCS_CP_SUM_COSTUNOT := CS_CP_SUM_COSTUNOT(vEmpresa, dFecha_Cierre);
            --F(X)
            nCS_CP_SUM_COSTUNOT_E := CS_CP_SUM_COSTUNOT_E(vEmpresa, dFecha_Cierre);
            --
            nCS_SUPEARIM := nCS_SUPEARIM + NVL(R_TINTERO.SUPEARIM,0);--(SUM)
            --
            OPEN cPRI_DEFIANIL(R_TINTERO.TIPO_IMPRE, R_TINTERO.ANILOX);
            FETCH cPRI_DEFIANIL INTO rPRI_DEFIANIL;
            CLOSE cPRI_DEFIANIL;
            --
            rPRI_DEFIANIL.APOCM3M2 := NVL(rPRI_DEFIANIL.APOCM3M2,0);
            --
            IF rPRI_DEFIANIL.APOCM3M2 != 0 THEN
               --APORTACION CM3/M2
               nCP_APOCM3M2_TIN := ((rPRI_DEFIANIL.APOCM3M2 * rPRI_DEFIANIL.PORCAPOR) / 100);
               --SUPERCIFICE EN M2 POR COLOR	-> ((nCP_M2_IMPRESORA_MAQ * R_TINTERO.SUPEARIM) / 100)
               --nCP_APOCM3M2_TIN -> APORTACION CM3/M2
               nCP_VOLUMCM3_TIN := ((nCP_M2_IMPRESORA_MAQ * R_TINTERO.SUPEARIM) / 100) * nCP_APOCM3M2_TIN;
               --
               IF INSTR(R_TINTERO.COLOR,'BLANCO') != 0  THEN
                  IF rPRI_DEFIANIL.TIPOIMPR = 'FLEXO' THEN
                     nCP_PEESTINT_TIN := vP_PesoBlFl;
                  ELSIF rPRI_DEFIANIL.TIPOIMPR = 'HUECO' THEN
                     nCP_PEESTINT_TIN := vP_PesoBlHu;
                  ELSE
                     nCP_PEESTINT_TIN := 0;
                  END IF;   
               ELSE
                  IF rPRI_DEFIANIL.TIPOIMPR = 'FLEXO' THEN
                     nCP_PEESTINT_TIN := vP_PesoReFl;
                  ELSIF rPRI_DEFIANIL.TIPOIMPR = 'HUECO' THEN
                     nCP_PEESTINT_TIN := vP_PesoReHu;
                  ELSE
                     nCP_PEESTINT_TIN := 0;
                  END IF;
               END IF;
               --PESO ESPECIFICO DE TINTA EN GR/CM3
               nCP_PEESTINT_TIN := NVL(nCP_PEESTINT_TIN ,0);
               --CONSUMO TEORICO DE KG DE TINTA    
               --nCP_VOLUMCM3_TIN -> VOLUMEN EN CM3	
               --nCP_PEESTINT_TIN -> PESO ESPECIFICO DE TINTA EN GR/CM3
               nCP_CONSTEKG_TIN := (nCP_PEESTINT_TIN * nCP_VOLUMCM3_TIN) / 1000;
            ELSE
               --APORTACION CM3/M2
               nCP_APOCM3M2_TIN := NULL;
               --VOLUMEN EN CM3	
               nCP_VOLUMCM3_TIN := NULL;
               --PESO ESPECIFICO DE TINTA EN GR/CM3
               nCP_PEESTINT_TIN := NULL;
               --CONSUMO TEORICO DE KG DE TINTA    
               nCP_CONSTEKG_TIN := NULL;
            END IF;
            --
            nCS_CP_CONSTEKG := nCS_CP_CONSTEKG + NVL(nCP_CONSTEKG_TIN,0);
            --
            nCS_CP_VOLUMCM3 := nCS_CP_VOLUMCM3 + NVL(nCP_VOLUMCM3_TIN,0); --(SUM)
            --COSTE  POR  CONSUMO TEORICO DE KG DE TINTA
            nCP_COSTCTKT := nCP_CONSTEKG_TIN * nCS_CP_SUM_COSTUNOT_E;
            --
            nCS_CP_COSTCTKT := nCS_CP_COSTCTKT + NVL(nCP_COSTCTKT,0); --(SUM)
            --TOTAL
            nCP_CP_COSTCTKT := NVL(nCP_CP_COSTCTKT,0) + nCP_COSTCTKT;
            --COSTE  POR  CONSUMO REAL DE KG DE TINTA
            --->         
            nCP_COSTCRKT := nCP_CONSTEKG_TIN * nCS_CP_SUM_COSTUNOT;
            --
            nCS_CP_COSTCRKT := nCS_CP_COSTCRKT + NVL(nCP_COSTCRKT,0); --(SUM)
            --TOTAL
            nCP_CP_COSTCRKT := NVL(nCP_CP_COSTCRKT,0) + nCP_COSTCRKT;
            --DIFERENCIA REAL - ESTANDAR POR COSTE DE CONSUMO TEORICO DE KG DE TINTA
            nCP_DIFECOKT := nCP_COSTCRKT - nCP_COSTCTKT;
            --
            nCS_CP_DIFECOKT := nCS_CP_DIFECOKT + NVL(nCP_DIFECOKT,0); --(SUM)
            --DIFERENCIA REAL - ESTANDAR POR COSTE DE CONSUMO TEORICO DE KG DE TINTA %
            IF NVL(nCP_COSTCTKT,0) != 0 THEN
               nCP_PORCCOKT := ((nCP_COSTCRKT - nCP_COSTCTKT) / nCP_COSTCTKT) * 100;
            ELSE
               nCP_PORCCOKT := 0;
            END IF;
            --KG de Tinta Estandar
            OPEN cInductorKGTinta_Estandar;
            FETCH cInductorKGTinta_Estandar INTO rInductorKGTinta_Estandar;
            CLOSE cInductorKGTinta_Estandar;
            --
            IF TO_CHAR(dFecha_Cierre,'MM') = '01' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.ENERO,0);
            ELSIF TO_CHAR(dFecha_Cierre,'MM') = '02' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.FEBRERO,0);
            ELSIF TO_CHAR(dFecha_Cierre,'MM') = '03' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.MARZO,0);
            ELSIF TO_CHAR(dFecha_Cierre,'MM') = '04' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.ABRIL,0);
            ELSIF TO_CHAR(dFecha_Cierre,'MM') = '05' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.MAYO,0);
            ELSIF TO_CHAR(dFecha_Cierre,'MM') = '06' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.JUNIO,0);
            ELSIF TO_CHAR(dFecha_Cierre,'MM') = '07' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.JULIO,0);
            ELSIF TO_CHAR(dFecha_Cierre,'MM') = '08' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.AGOSTO,0);
            ELSIF TO_CHAR(dFecha_Cierre,'MM') = '09' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.SEPTIEMBRE,0);
            ELSIF TO_CHAR(dFecha_Cierre,'MM') = '10' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.OCTUBRE,0);
            ELSIF TO_CHAR(dFecha_Cierre,'MM') = '11' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.NOVIEMBRE,0);
            ELSIF TO_CHAR(dFecha_Cierre,'MM') = '12' THEN
               nKILOTINT_AIM2 := NVL(rInductorKGTinta_Estandar.DICIEMBRE,0);
            END IF;   
            --Disolventes Estandar
            OPEN cConsImpuVariOTs_Estandar('D');
            FETCH cConsImpuVariOTs_Estandar INTO rConsImpuVariOTs_Estandar;
            CLOSE cConsImpuVariOTs_Estandar;
            --PRECIO MEDIO = PRECIO / CANTIDAD
            --COSTE CONSUMO = PRECMEDI * CONSUMO
            IF NVL(rConsImpuVariOTs_Estandar.CANTIDAD,0) != 0 THEN
               nPRECMEDI_AIM2 := rConsImpuVariOTs_Estandar.PRECIO / rConsImpuVariOTs_Estandar.CANTIDAD;
               nCOSTCONS_AIM2 := nPRECMEDI_AIM2 * NVL(rConsImpuVariOTs_Estandar.CONSUMO,0);
               --
               IF NVL(nKILOTINT_AIM2,0) != 0 THEN
                  nCOUNKGTO_AIM2 := nCOSTCONS_AIM2 / nKILOTINT_AIM2;
               ELSE
                  nCOUNKGTO_AIM2 := 0;
               END IF;
            ELSE
               nPRECMEDI_AIM2 := 0;
               nCOSTCONS_AIM2 := 0;
               nCOUNKGTO_AIM2 := 0;
            END IF;
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / ESTANDAR / POR DISOLVENTES
            nCP_COKGTCDI := nCP_CONSTEKG_TIN * nCOUNKGTO_AIM2;
            --
            nCS_CP_COKGTCDI := nCS_CP_COKGTCDI + NVL(nCP_COKGTCDI,0); --(SUM)
            --TOTAL
            nCP_CP_COKGTCDI := NVL(nCP_CP_COKGTCDI,0) + nCP_COKGTCDI;
            --Tintas Base Estandar
            --Caculos para Tintas Base Compradas a Proveedores
            rConsImpuVariOTs_Estandar.CANTIDAD := NULL;
            --	 
            OPEN cConsImpuVariOTs_Estandar('TC');
            FETCH cConsImpuVariOTs_Estandar INTO rConsImpuVariOTs_Estandar;
            CLOSE cConsImpuVariOTs_Estandar;
            --PRECIO MEDIO = PRECIO / CANTIDAD
            --COSTE CONSUMO = PRECMEDI * CONSUMO
            IF NVL(rConsImpuVariOTs_Estandar.CANTIDAD,0) != 0 THEN
               nPRECMEDI_AIM2 := rConsImpuVariOTs_Estandar.PRECIO / rConsImpuVariOTs_Estandar.CANTIDAD;
               nCOSTCONS_AIM2 := nPRECMEDI_AIM2 * NVL(rConsImpuVariOTs_Estandar.CONSUMO,0);
               --
               IF NVL(nKILOTINT_AIM2,0) != 0 THEN
                  nCOUNKGTO_AIM2 := nCOSTCONS_AIM2 / nKILOTINT_AIM2;
               ELSE
                  nCOUNKGTO_AIM2 := 0;
               END IF;
            ELSE
               nPRECMEDI_AIM2 := 0;
               nCOSTCONS_AIM2 := 0;
               nCOUNKGTO_AIM2 := 0;
            END IF;
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / ESTANDAR / POR TINTAS BASE COMPRADAS A PROVEEDORES
            nCP_COKGTCTB := nCP_CONSTEKG_TIN * nCOUNKGTO_AIM2; --1er Calculo
            --
            rConsImpuVariOTs_Estandar.CANTIDAD := NULL;
            --Caculos para Tintas Base Fabricadas
            OPEN cConsImpuVariOTs_Estandar('TF');
            FETCH cConsImpuVariOTs_Estandar INTO rConsImpuVariOTs_Estandar;
            CLOSE cConsImpuVariOTs_Estandar;
            --PRECIO MEDIO = PRECIO / CANTIDAD
            --COSTE CONSUMO = PRECMEDI * CONSUMO
            IF NVL(rConsImpuVariOTs_Estandar.CANTIDAD,0) != 0 THEN
               nPRECMEDI_AIM2 := rConsImpuVariOTs_Estandar.PRECIO / rConsImpuVariOTs_Estandar.CANTIDAD;
               nCOSTCONS_AIM2 := nPRECMEDI_AIM2 * (NVL(rConsImpuVariOTs_Estandar.CONSUMO,0) - NVL(rConsImpuVariOTs_Estandar.CANTIDAD,0));
               --
               IF NVL(nKILOTINT_AIM2,0) != 0 THEN
                  nCOUNKGTO_AIM2 := nCOSTCONS_AIM2 / nKILOTINT_AIM2;
               ELSE
                  nCOUNKGTO_AIM2 := 0;
               END IF;
            ELSE
               nPRECMEDI_AIM2 := 0;
               nCOSTCONS_AIM2 := 0;
               nCOUNKGTO_AIM2 := 0;
            END IF;
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / ESTANDAR / POR TINTAS BASE 
            nCP_COKGTCTB := nCP_COKGTCTB + (nCP_CONSTEKG_TIN * nCOUNKGTO_AIM2); --2do Calculo
            --
            nCS_CP_COKGTCTB := nCS_CP_COKGTCTB + NVL(nCP_COKGTCTB,0); --(SUM)
            --TOTAL
            nCP_CP_COKGTCTB := NVL(nCP_CP_COKGTCTB,0) + nCP_COKGTCTB;
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / ESTANDAR / COSTE TOTAL
            nCP_COKGTCCT := nCP_COKGTCDI + nCP_COKGTCTB;
            --
            nCS_CP_COKGTCCT := nCS_CP_COKGTCCT + NVL(nCP_COKGTCCT,0); --(SUM)
            --TOTAL
            nCP_CP_COKGTCCT := NVL(nCP_CP_COKGTCCT,0) + nCP_COKGTCCT;
            --KG de Tinta Real
            nKILOTINT_AIM2 := NULL;
            --
            OPEN cInductorKGTinta_Real;
            FETCH cInductorKGTinta_Real INTO nKILOTINT_AIM2;
            CLOSE cInductorKGTinta_Real;
            --
            nKILOTINT_AIM2 := NVL(nKILOTINT_AIM2,0);
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL / POR DISOLVENTES
            nCP_COKGTCDR := 0;
            --
            FOR rConsImpuVariOTs_Real IN cConsImpuVariOTs_Real('D') LOOP
               IF NVL(rConsImpuVariOTs_Real.CONSUMO,0) != 0 THEN
                  nCantPrme_AIM2 := 0;
                  nPrecPrme_AIM2 := 0;
                  --Calculo del Precio Medio
                  FOR rExisPeri IN cExisPeri(vEmpresa,rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF,dFecha_Cierre) LOOP
                     nPrecComp_AIM2 := NULL;
                     --Se busca la compra para el preci
                     OPEN cCompras(vEmpresa, rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF, rExisPeri.ASLOTE);
                     FETCH cCompras INTO nPrecComp_AIM2;
                     CLOSE cCompras;
                     --
                     IF NVL(nPrecComp_AIM2,0) != 0 THEN
                        nCantPrme_AIM2 := nCantPrme_AIM2 + rExisPeri.AHCANT; --Acumula la cantidad
                        nPrecPrme_AIM2 := nPrecPrme_AIM2 + (rExisPeri.AHCANT * nPrecComp_AIM2); --Acumula el Precio
                     END IF;
                  END LOOP;
                  --
                  IF nCantPrme_AIM2 != 0 THEN
                     nPRECMEDI_AIM2 := nPrecPrme_AIM2 / nCantPrme_AIM2;
                  ELSE
                     nPRECMEDI_AIM2 := 0;
                  END IF;   
                  --
                  IF nPRECMEDI_AIM2 = 0 THEN
                     rUltiCompr.ALCANT := NULL;
                     --
                     OPEN cUltiCompr(vEmpresa, rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF);
                     FETCH cUltiCompr INTO rUltiCompr;--nPRECMEDI_AIM2; --PRECIO MEDIO REAL
                     CLOSE cUltiCompr;
                     --(ALCAEQ * ALPREU) / ALCANT, ALUNST, ALUNCO
                     IF NVL(rUltiCompr.ALCANT,0) != 0 THEN
                        rASMAAR01.VUCCOD := NULL;
                        --
                        --Calculo de Unidad de Logistica para los materiales
                        OPEN cASMAAR01(vEmpresa, rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF);
                        FETCH cASMAAR01 INTO rASMAAR01;
                        CLOSE cASMAAR01;
                        --
                        IF rUltiCompr.ALUNST = rASMAAR01.VUCCOD THEN
                           nPRECMEDI_AIM2 := (rUltiCompr.ALCAEQ * rUltiCompr.ALPREU) / rUltiCompr.ALCANT;
                        ELSE
                           nPRECMEDI_AIM2 := 0;
                           P_ERRORES('37.1- No se ha podido establecer el precio para la materia prima de tintas :'||rConsImpuVariOTs_Real.VATCOD||'-'||rConsImpuVariOTs_Real.ARCARF);
                        END IF;
                     ELSE
                        nPRECMEDI_AIM2 := 0;
                        P_ERRORES('37.2- No se ha podido establecer el precio para la materia prima de tintas :'||rConsImpuVariOTs_Real.VATCOD||'-'||rConsImpuVariOTs_Real.ARCARF);
                     END IF;
                  END IF;
                  --
                  nCOSTCONS_AIM2 := nPRECMEDI_AIM2 * NVL(rConsImpuVariOTs_Real.CONSUMO,0);
                  --
                  IF NVL(nKILOTINT_AIM2,0) != 0 THEN
                     nCOUNKGTO_AIM2 := nCOSTCONS_AIM2 / nKILOTINT_AIM2;
                  ELSE
                     nCOUNKGTO_AIM2 := 0;
                     P_ERRORES('38- No existe el valor de indutor de KG de tinta');
                  END IF;
                  --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL / POR DISOLVENTES
                  nCP_COKGTCDR := nCP_COKGTCDR + (nCP_CONSTEKG_TIN * nCOUNKGTO_AIM2);
               END IF;
            END LOOP;
            --
            nCS_CP_COKGTCDR := nCS_CP_COKGTCDR + NVL(nCP_COKGTCDR,0); --(SUM)
            --TOTAL
            nCP_CP_COKGTCDR := NVL(nCP_CP_COKGTCDR,0) + nCP_COKGTCDR;
            --Tintas Base Real
            --Calculos para Tintas Base Compradas a Proveedores
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL / POR TINTAS BASE COMPRADAS A PROVEEDORES
            nCP_COKGTCTR := 0;
            --
            FOR rConsImpuVariOTs_Real IN cConsImpuVariOTs_Real('TC') LOOP
               IF NVL(rConsImpuVariOTs_Real.CONSUMO,0) != 0 THEN
                  nCantPrme_AIM2 := 0;
                  nPrecPrme_AIM2 := 0;
                  --Calculo del Precio Medio
                  FOR rExisPeri IN cExisPeri(vEmpresa, rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF, dFecha_Cierre) LOOP
                     nPrecComp_AIM2 := NULL;
                     --Se busca la compra para el preci
                     OPEN cCompras(vEmpresa, rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF, rExisPeri.ASLOTE);
                     FETCH cCompras INTO nPrecComp_AIM2;
                     CLOSE cCompras;
                     --
                     IF NVL(nPrecComp_AIM2,0) != 0 THEN
                        nCantPrme_AIM2 := nCantPrme_AIM2 + rExisPeri.AHCANT; --Acumula la cantidad
                        nPrecPrme_AIM2 := nPrecPrme_AIM2 + (rExisPeri.AHCANT * nPrecComp_AIM2); --Acumula el Precio
                     END IF;
                  END LOOP;
                  --
                  IF nCantPrme_AIM2 != 0 THEN
                     nPRECMEDI_AIM2 := nPrecPrme_AIM2 / nCantPrme_AIM2;
                  ELSE
                     nPRECMEDI_AIM2 := 0;
                  END IF;   
                  --
                  IF nPRECMEDI_AIM2 = 0 THEN
                     rUltiCompr.ALCANT := NULL;
                     --
                     OPEN cUltiCompr(vEmpresa, rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF);
                     FETCH cUltiCompr INTO rUltiCompr;--nPRECMEDI_AIM2; --PRECIO MEDIO REAL
                     CLOSE cUltiCompr;
                     --(ALCAEQ * ALPREU) / ALCANT, ALUNST, ALUNCO
                     IF NVL(rUltiCompr.ALCANT,0) != 0 THEN
                        rASMAAR01.VUCCOD := NULL;
                        --
                        --Calculo de Unidad de Logistica para los materiales
                        OPEN cASMAAR01(vEmpresa, rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF);
                        FETCH cASMAAR01 INTO rASMAAR01;
                        CLOSE cASMAAR01;
                        --
                        IF rUltiCompr.ALUNST = rASMAAR01.VUCCOD THEN
                           nPRECMEDI_AIM2 := (rUltiCompr.ALCAEQ * rUltiCompr.ALPREU) / rUltiCompr.ALCANT;
                        ELSE
                           nPRECMEDI_AIM2 := 0;
                           P_ERRORES('39.1- No se ha podido establecer el precio para la materia prima de tintas :'||rConsImpuVariOTs_Real.VATCOD||'-'||rConsImpuVariOTs_Real.ARCARF);
                        END IF;
                     ELSE
                        nPRECMEDI_AIM2 := 0;
                        P_ERRORES('39.2- No se ha podido establecer el precio para la materia prima de tintas :'||rConsImpuVariOTs_Real.VATCOD||'-'||rConsImpuVariOTs_Real.ARCARF);
                     END IF;
                  END IF;
                  --
                  nCOSTCONS_AIM2 := nPRECMEDI_AIM2 * NVL(rConsImpuVariOTs_Real.CONSUMO,0);
                  --
                  IF NVL(nKILOTINT_AIM2,0) != 0 THEN
                     nCOUNKGTO_AIM2 := nCOSTCONS_AIM2 / nKILOTINT_AIM2;
                  ELSE
                     nCOUNKGTO_AIM2 := 0;
                     P_ERRORES('40- No existe el valor de indutor de KG de tinta');
                  END IF;
                  --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL / POR TINTAS BASE COMPRADAS A PROVEEDORES
                  nCP_COKGTCTR := nCP_COKGTCTR + (nCP_CONSTEKG_TIN * nCOUNKGTO_AIM2);
               END IF;
            END LOOP;
            --Calculos para Tintas Base Compradas a Proveedores
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL / POR TINTAS BASE FABRICADAS
            --
            FOR rConsImpuVariOTs_Real IN cConsImpuVariOTs_Real('TF') LOOP
               IF NVL(rConsImpuVariOTs_Real.CONSUMO,0) - NVL(rConsImpuVariOTs_Real.CANTIDAD,0) != 0 THEN
                  nCantPrme_AIM2 := 0;
                  nPrecPrme_AIM2 := 0;
                  --Calculo del Precio Medio
                  FOR rExisPeri IN cExisPeri(vEmpresa, rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF, dFecha_Cierre) LOOP
                     nPrecComp_AIM2 := NULL;
                     --Se busca la compra para el preci
                     OPEN cCompras(vEmpresa, rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF, rExisPeri.ASLOTE);
                     FETCH cCompras INTO nPrecComp_AIM2;
                     CLOSE cCompras;
                     --
                     IF NVL(nPrecComp_AIM2,0) != 0 THEN
                        nCantPrme_AIM2 := nCantPrme_AIM2 + rExisPeri.AHCANT; --Acumula la cantidad
                        nPrecPrme_AIM2 := nPrecPrme_AIM2 + (rExisPeri.AHCANT * nPrecComp_AIM2); --Acumula el Precio
                     END IF;
                  END LOOP;
                  --
                  IF nCantPrme_AIM2 != 0 THEN
                     nPRECMEDI_AIM2 := nPrecPrme_AIM2 / nCantPrme_AIM2;
                  ELSE
                     nPRECMEDI_AIM2 := 0;
                  END IF;   
                  --
                  IF nPRECMEDI_AIM2 = 0 THEN
                     rUltiCompr.ALCANT := NULL;
                      --
                     OPEN cUltiCompr(vEmpresa, rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF);
                     FETCH cUltiCompr INTO rUltiCompr;--nPRECMEDI_AIM2; --PRECIO MEDIO REAL
                     CLOSE cUltiCompr;
                     --(ALCAEQ * ALPREU) / ALCANT, ALUNST, ALUNCO
                     IF NVL(rUltiCompr.ALCANT,0) != 0 THEN
                        rASMAAR01.VUCCOD := NULL;
                        --
                        --Calculo de Unidad de Logistica para los materiales
                        OPEN cASMAAR01(vEmpresa, rConsImpuVariOTs_Real.VATCOD, rConsImpuVariOTs_Real.ARCARF);
                        FETCH cASMAAR01 INTO rASMAAR01;
                        CLOSE cASMAAR01;
                        --
                        IF rUltiCompr.ALUNST = rASMAAR01.VUCCOD THEN
                           nPRECMEDI_AIM2 := (rUltiCompr.ALCAEQ * rUltiCompr.ALPREU) / rUltiCompr.ALCANT;
                        ELSE
                           nPRECMEDI_AIM2 := 0;
                           P_ERRORES('41.1- No se ha podido establecer el precio para la materia prima de tintas :'||rConsImpuVariOTs_Real.VATCOD||'-'||rConsImpuVariOTs_Real.ARCARF);
                        END IF;
                     ELSE
                        nPRECMEDI_AIM2 := 0;
                        P_ERRORES('41.2- No se ha podido establecer el precio para la materia prima de tintas :'||rConsImpuVariOTs_Real.VATCOD||'-'||rConsImpuVariOTs_Real.ARCARF);
                     END IF;
                  END IF;
                  --
                  nCOSTCONS_AIM2 := nPRECMEDI_AIM2 * (NVL(rConsImpuVariOTs_Real.CONSUMO,0) - NVL(rConsImpuVariOTs_Real.CANTIDAD,0));
                  --
                  IF NVL(nKILOTINT_AIM2,0) != 0 THEN
                     nCOUNKGTO_AIM2 := nCOSTCONS_AIM2 / nKILOTINT_AIM2;
                  ELSE
                     nCOUNKGTO_AIM2 := 0;
                     P_ERRORES('42- No existe el valor de indutor de KG de tinta');
                  END IF;
                  --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL / POR TINTAS BASE FABRICADAS
                  nCP_COKGTCTR := nCP_COKGTCTR + (nCP_CONSTEKG_TIN * nCOUNKGTO_AIM2);
               END IF;
            END LOOP;
            --
            nCS_CP_COKGTCTR := nCS_CP_COKGTCTR + NVL(nCP_COKGTCTR,0); --(SUM)
            --TOTAL
            nCP_CP_COKGTCTR := NVL(nCP_CP_COKGTCTR,0) + nCP_COKGTCTR;
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / REAL / COSTE TOTAL
            nCP_COKGTCCR := nCP_COKGTCDR + nCP_COKGTCTR;
            --
            nCS_CP_COKGTCCR := nCS_CP_COKGTCCR + NVL(nCP_COKGTCCR,0); --(SUM)
            --TOTAL
            nCP_CP_COKGTCCR := NVL(nCP_CP_COKGTCCR,0) + nCP_COKGTCCR;
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / DIFERENCIA / POR DISOLVENTES
            nCP_DICKTCDI := nCP_COKGTCDR - nCP_COKGTCDI;
            --
            nCS_CP_DICKTCDI := nCS_CP_DICKTCDI + NVL(nCP_DICKTCDI,0); --(SUM)
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / DIFERENICA / POR TINTAS BASE
            nCP_DICKTCTB := nCP_COKGTCTR - nCP_COKGTCTB;
            --
            nCS_CP_DICKTCTB := nCS_CP_DICKTCTB + NVL(nCP_DICKTCTB,0); --(SUM)
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / DIFERENCIA / COSTE TOTAL
            nCP_DICKTCCT := nCP_COKGTCCR - nCP_COKGTCCT;
            --
            nCS_CP_DICKTCCT := nCS_CP_DICKTCCT + NVL(nCP_DICKTCCT,0); --(SUM)
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE / POR DISOLVENTES
            IF NVL(nCP_COKGTCDI,0) != 0 THEN
               nCP_POCKTCDI := ((nCP_COKGTCDR - nCP_COKGTCDI) / nCP_COKGTCDI) * 100;
            ELSE
               nCP_POCKTCDI := 0;
            END IF;
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE / POR TINTAS BASE
            IF NVL(nCP_COKGTCTB,0) != 0 THEN
               nCP_POCKTCTB := ((nCP_COKGTCTR - nCP_COKGTCTB) / nCP_COKGTCTB) * 100;
            ELSE
               nCP_POCKTCTB := 0;
            END IF;
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE / COSTE TOTAL
            IF NVL(nCP_COKGTCCT,0) != 0 THEN
               nCP_POCKTCCT := ((nCP_COKGTCCR - nCP_COKGTCCT) / nCP_COKGTCCT) * 100;
            ELSE
               nCP_POCKTCCT := 0;
            END IF;
            --COSTE TOTAL INDIRECTO ESTANDAR
            nCP_COTOINES := nCP_COSTCTKT + nCP_COKGTCCT;
            --
            nCS_CP_COTOINES := nCS_CP_COTOINES + NVL(nCP_COTOINES,0); --(SUM)
            --
            nCP_COTOINES_CS := NVL(nCP_COTOINES_CS,0) + NVL(nCP_COTOINES,0);	 	 
            --TOTAL
            nCP_CP_COTOINES := NVL(nCP_CP_COTOINES,0) + nCP_COTOINES;
            --COSTE TOTAL INDIRECTO REAL
            nCP_COTOINRE := nCP_COSTCRKT + nCP_COKGTCCR;
            --
            nCS_CP_COTOINRE := nCS_CP_COTOINRE + NVL(nCP_COTOINRE,0); --(SUM)
            --
            nCP_COTOINRE_CS := NVL(nCP_COTOINRE_CS,0) + NVL(nCP_COTOINRE,0);	 	 
            --TOTAL
            nCP_CP_COTOINRE := NVL(nCP_CP_COTOINRE,0) + nCP_COTOINRE;
            --TOTAL DIFERENCIA REAL - ESTANDAR POR COSTE DE CONSUMO TEORICO DE KG DE TINTA %
            IF NVL(nCP_CP_COSTCTKT,0) != 0 THEN
               nCP_CP_PORCCOKT := ((nCP_CP_COSTCRKT - nCP_CP_COSTCTKT) / nCP_CP_COSTCTKT) * 100;
            ELSE
               nCP_CP_PORCCOKT := 0;
            END IF;
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE / POR DISOLVENTES
            IF NVL(nCP_CP_COKGTCDI,0) != 0 THEN
               nCP_CP_POCKTCDI := ((nCP_CP_COKGTCDR - nCP_CP_COKGTCDI) / nCP_CP_COKGTCDI) * 100;
            ELSE
               nCP_CP_POCKTCDI := 0;
            END IF;
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE / POR TINTAS BASE
            IF NVL(nCP_CP_COKGTCTB,0) != 0 THEN
               nCP_CP_POCKTCTB := ((nCP_CP_COKGTCTR - nCP_CP_COKGTCTB) / nCP_CP_COKGTCTB) * 100;
            ELSE
               nCP_CP_POCKTCTB := 0;
            END IF;
            --COSTE POR OT POR KG DE TINTA TEORICO CONSUMIDO.  / PORCENTAJE / COSTE TOTAL
            IF NVL(nCP_CP_COKGTCCT,0) != 0 THEN
               nCP_CP_POCKTCCT := ((nCP_CP_COKGTCCR - nCP_CP_COKGTCCT) / nCP_CP_COKGTCCT) * 100;
            ELSE
               nCP_CP_POCKTCCT := 0;
            END IF;
            --PORCENTAJE DIFERENCIA COSTE TOTAL INDIRECTO
            IF NVL(nCP_CP_COTOINES,0) != 0 THEN
               nCP_CP_POCTINDI := ((nCP_CP_COTOINRE - nCP_CP_COTOINES) / nCP_CP_COTOINES) * 100;
            ELSE
               nCP_CP_POCTINDI := 0;
            END IF;
            --
            nRetorno_CF_SUPEAIM2 := (nCP_M2_IMPRESORA_MAQ * R_TINTERO.SUPEARIM) / 100;
            -->     
            nCP_COTEKGCO_CF := 0;--CONSUMO TEORICO REAL
            nCP_COREKGCO := 0;--CONSUMO RECLASIFICADO REAL
            nCP_COTOKGCO := 0;--CONSUMO TOTAL REAL
            nCP_PRECMERE := 0;--PRECIO MEDIO REAL
            nCP_COERCONS := 0;--COSTE EN € DEL CONSUMO REAL
            nCP_PRECMEES := 0;--PRECIO MEDIO ESTANDAR
            nCP_COEECONS := 0;--COSTE EN € DEL CONSUMO ESTANDAR
            nCP_CORECOCA := 0;--COMPARATIVO REAL - ESTANDAR / CONSUMO / CANTIDAD
            nCP_CORECOPO := 0;--COMPARATIVO REAL - ESTANDAR / CONSUMO / %
            nCP_COREPMPR := 0;--COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ PRECIO
            nCP_COREPMPO := 0;--COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ %
            nCP_CORECOCO := 0;--COMPARATIVO REAL - ESTANDAR / COSTE/ COSTE
            nCP_CORECOPJ := 0;--COMPARATIVO REAL - ESTANDAR / COSTE/ %          	 
            --
--1--            
            FOR R_COMPFORM IN Q_COMPFORM(R_TINTERO.MATECODE) LOOP
               nCS_IM_CANTI_TIN := nCS_IM_CANTI_TIN + NVL(R_COMPFORM.IM_CANTI,0); --(SUM)
               --function CF_PORCCOMPFormula return Number is
               OPEN cSumaCantComp(R_TINTERO.MateCode, R_COMPFORM.Im_Formu);
               FETCH cSumaCantComp INTO nSumaCantComp;
               CLOSE cSumaCantComp;                 
               --
               nSumaCantComp := NVL(nSumaCantComp,0);
               --
               rPRI_DEFIANIL.APOCM3M2 := NULL;
               --Para evitar error circular ESTE TRATAMIENTO YA SE ENCUENTRA EN CF_SUPEAIM2Formula
               OPEN cPRI_DEFIANIL(R_TINTERO.TIPO_IMPRE, R_TINTERO.Anilox);
               FETCH cPRI_DEFIANIL INTO rPRI_DEFIANIL;
               CLOSE cPRI_DEFIANIL;
               --
               rPRI_DEFIANIL.APOCM3M2 := NVL(rPRI_DEFIANIL.APOCM3M2,0);
               --
               IF rPRI_DEFIANIL.APOCM3M2 != 0 THEN
                  --APORTACION CM3/M2
                  nCp_ApoCm3M2_OT := ((rPRI_DEFIANIL.APOCM3M2 * rPRI_DEFIANIL.PORCAPOR) / 100);
                  --SUPERCIFICE EN M2 POR COLOR	-> ((nCP_M2_IMPRESORA_MAQ * R_TINTERO.SUPEARIM) / 100)
                  --nCP_APOCM3M2_TIN -> APORTACION CM3/M2
                  nCp_VoluMcM3_OT := ((nCP_M2_IMPRESORA_MAQ * R_TINTERO.SUPEARIM) / 100) * nCp_ApoCm3M2_OT;
                  --
                  IF INSTR(R_TINTERO.COLOR,'BLANCO') != 0  THEN
                     IF rPRI_DEFIANIL.TIPOIMPR = 'FLEXO' THEN
                        nCp_PeesTint_OT := vP_PesoBlFl;
                     ELSIF rPRI_DEFIANIL.TIPOIMPR = 'HUECO' THEN
                        nCp_PeesTint_OT := vP_PesoBlHu;
                     ELSE
                        nCp_PeesTint_OT := 0;
                     END IF;   
                  ELSE
                     IF rPRI_DEFIANIL.TIPOIMPR = 'FLEXO' THEN
                        nCp_PeesTint_OT := vP_PesoReFl;
                     ELSIF rPRI_DEFIANIL.TIPOIMPR = 'HUECO' THEN
                        nCp_PeesTint_OT := vP_PesoReHu;
                     ELSE
                        nCp_PeesTint_OT := 0;
                     END IF;
                  END IF;
                  --PESO ESPECIFICO DE TINTA EN GR/CM3
                  nCp_PeesTint_OT := NVL(nCp_PeesTint_OT ,0);
                  --CONSUMO TEORICO DE KG DE TINTA    
                  --nCP_VOLUMCM3_TIN -> VOLUMEN EN CM3	
                  --nCP_PEESTINT_TIN -> PESO ESPECIFICO DE TINTA EN GR/CM3
                  nCp_ConsTeKG_OT := (nCp_PeesTint_OT * nCp_VoluMcM3_OT) / 1000;
               ELSE
                  --APORTACION CM3/M2
                  nCp_ApoCm3M2_OT := NULL;
                  --VOLUMEN EN CM3	
                  nCp_VoluMcM3_OT := NULL;
                  --PESO ESPECIFICO DE TINTA EN GR/CM3
                  nCp_PeesTint_OT := NULL;
                  --CONSUMO TEORICO DE KG DE TINTA    
                  nCp_ConsTeKG_OT := NULL;
                  --
                  P_ERRORES('43- Aporte de CM3 de M2 del Anilox :'||R_TINTERO.ANILOX||' para el tipo de impresión '||R_TINTERO.TIPO_IMPRE||' no existe');
               END IF;
               --Para evitar error circular ESTE TRATAMIENTO YA SE ENCUENTRA EN CF_SUPEAIM2Formula, Esto es lo que se ha modificado
               IF NVL(nSumaCantComp,0) != 0 THEN
                  nCP_COTEKGCO_CF := nCp_ConsTeKG_OT * (R_COMPFORM.IM_CANTI / nSumaCantComp); --CONSUMO TEORICO REAL
               ELSE
                  nCP_COTEKGCO_CF := 0;
               END IF;
               --
               IF nCP_CP_POSICION IS NULL OR nCP_CP_POSICION != R_TINTERO.POSICION OR nCP_CP_NUMERO IS NULL OR nCP_CP_NUMERO != nNumero THEN
                  nCP_CP_COTEKGCO := 0;
                  nCP_CP_COREKGCO := 0;
                  nCP_CP_COTOKGCO := 0;
                  nCP_CP_COERCONS := 0;
                  nCP_CP_COEECONS := 0;
                  nCP_CP_CORECOCA := 0;
                  nCP_CP_COTODIES := 0;
                  nCP_CP_TOCODIES := 0;
                  nCP_CP_COTODIRE := 0;
                  nCP_CP_TOCODIRE := 0;
                  --
                  nCP_CP_POSICION := R_TINTERO.POSICION;
                  nCP_CP_NUMERO := nNumero;
               END IF;
               --SUMA DE :CP_COTEKGCO
               nCP_CP_COTEKGCO := NVL(nCP_CP_COTEKGCO,0) + nCP_COTEKGCO;
               --Para evitar error circular ESTE TRATAMIENTO YA SE ENCUENTRA EN CF_SUPEAIM2Formula
               --CONSUMO TEORICO REAL     
               --nCP_CONSTEKG_TIN -> CONSUMO TEORICO DE KG DE TINTA    
               --Para evitar error circular ESTE TRATAMIENTO YA SE ENCUENTRA EN CF_SUPEAIM2Formula
               --Calculo del Precio Medio
               nCP_PRECMERE := NULL;
               --
               nCantPrme := 0; 
               nPrecPrme := 0; 
               --
               FOR rExisPeri IN cExisPeri(vEmpresa, R_COMPFORM.TIP_ARTI_COM, R_COMPFORM.COD_ARTI_COM, dFecha_Cierre) LOOP
                  nPrecComp := NULL;
                  --Se busca la compra para el preci
                  OPEN cCompras(vEmpresa, R_COMPFORM.TIP_ARTI_COM, R_COMPFORM.COD_ARTI_COM, rExisPeri.ASLOTE);
                  FETCH cCompras INTO nPrecComp;
                  CLOSE cCompras;
                  --
                  IF NVL(nPrecComp,0) != 0 THEN
                     nCantPrme := nCantPrme + rExisPeri.AHCANT; --Acumula la cantidad
                     nPrecPrme := nPrecPrme + (rExisPeri.AHCANT * nPrecComp); --Acumula el Precio
                  END IF;
               END LOOP;
               --
               IF nCantPrme != 0 THEN
                  nCP_PRECMERE := nPrecPrme / nCantPrme;
               ELSE
                  nCP_PRECMERE := 0;
               END IF;   
               --
               IF nCP_PRECMERE = 0 THEN
                  rUltiCompr.ALCANT := NULL;
                  --
                  OPEN cUltiCompr(vEmpresa, R_COMPFORM.TIP_ARTI_COM, R_COMPFORM.COD_ARTI_COM);
                  FETCH cUltiCompr INTO rUltiCompr;--:CP_PRECMERE; --PRECIO MEDIO REAL
                  CLOSE cUltiCompr;
                  --(ALCAEQ * ALPREU) / ALCANT, ALUNST, ALUNCO
                  IF NVL(rUltiCompr.ALCANT,0) != 0 THEN
                     --Calculo de Unidad de Logistica para los materiales
                     OPEN cASMAAR01(vEmpresa, R_COMPFORM.TIP_ARTI_COM, R_COMPFORM.COD_ARTI_COM);
                     FETCH cASMAAR01 INTO rASMAAR01;
                     CLOSE cASMAAR01;
                     --
                     IF rUltiCompr.ALUNST = rASMAAR01.VUCCOD THEN
                        nCP_PRECMERE := (rUltiCompr.ALCAEQ * rUltiCompr.ALPREU) / rUltiCompr.ALCANT;
                     ELSE
                        nCP_PRECMERE := 0;
                        --
                        IF  R_COMPFORM.TIP_ARTI_COM != 'X' AND R_COMPFORM.COD_ARTI_COM != 'XXX' THEN
                           P_ERRORES('44.1- No se ha podido establecer el precio para la materia prima de tintas :'||R_COMPFORM.TIP_ARTI_COM||'-'||R_COMPFORM.COD_ARTI_COM);
                        END IF;
                     END IF;
                  ELSE
                     nCP_PRECMERE := 0;
                     --
                     IF  R_COMPFORM.TIP_ARTI_COM != 'X' AND R_COMPFORM.COD_ARTI_COM != 'XXX' THEN
                        P_ERRORES('44.2- No se ha podido establecer el precio para la materia prima de tintas :'||R_COMPFORM.TIP_ARTI_COM||'-'||R_COMPFORM.COD_ARTI_COM);
                     END IF;
                  END IF;
               END IF;
               --
               nCP_PRECMEES := NULL;
               --Precio medio Estandar
               OPEN cPrmeEsta(R_COMPFORM.IM_COMPO);
               FETCH cPrmeEsta INTO nCP_PRECMEES; --PRECIO MEDIO ESTANDAR
               CLOSE cPrmeEsta;
               --Consumo Real del Componente de todas las OT's
               OPEN cConsReco(R_COMPFORM.TIP_ARTI_COM, R_COMPFORM.COD_ARTI_COM);
               FETCH cConsReco INTO nConsReco;
               CLOSE cConsReco;
               --Consumo Teorico del Componente de todas las OT's
               FOR rOTsComp IN cOTsComp(R_COMPFORM.TIP_ARTI_COM, R_COMPFORM.COD_ARTI_COM) LOOP
                  rFIC_INFOPROD.TOTAL := NULL;
                  rFIC_INFOPROD.N_VECES := NULL;
                  --
                  OPEN cFIC_INFOPROD(vEmpresa, rOTsComp.Numero, rOTsComp.Anno);
                  FETCH cFIC_INFOPROD INTO rFIC_INFOPROD;
                  CLOSE cFIC_INFOPROD;
                  --
                  nCp_Ancho_Mm_Prod_TIN := rFIC_INFOPROD.TOTAL;
                  --
                  nCp_N_Veces := rFIC_INFOPROD.N_VECES;
                  --
                  FOR rMaquinas IN cMaquinas(rOTsComp.Numero, R_COMPFORM.TIP_ARTI_COM, R_COMPFORM.COD_ARTI_COM) LOOP
                      nPasadas := NULL;
                      --
                     OPEN cPasadas(rMaquinas.NUMEOTRE,rMaquinas.CONTADOR);
                     FETCH cPasadas INTO nPasadas;
                     CLOSE cPasadas;
                     --
                     nPasadas := NVL(nPasadas,0);
                     --
                     nCp_M2_Impresora := nPasadas * (NVL(nCp_Ancho_Mm_Prod_TIN,0) / 1000);
                     --
                     FOR rTinteros IN cTinteros(rMaquinas.NUMEOTRE,rMaquinas.CONTADOR,
                                                rOTsComp.TIP_ARTI, rOTsComp.COD_ARTI,
                                                rOTsComp.MODI, rOTsComp.REVI,
                                                R_TINTERO.MateCode) LOOP
                        rPRI_DEFIANIL.APOCM3M2 := NULL;
                        rPRI_DEFIANIL.PORCAPOR := NULL;
                        --
                        OPEN cPRI_DEFIANIL(rTinteros.TIPO_IMPRE, rTinteros.ANILOX);
                        FETCH cPRI_DEFIANIL INTO rPRI_DEFIANIL;
                        CLOSE cPRI_DEFIANIL;
                        --
                        rPRI_DEFIANIL.APOCM3M2 := NVL(rPRI_DEFIANIL.APOCM3M2,0);
                        --
                        IF rPRI_DEFIANIL.APOCM3M2 != 0 THEN
                           nCp_ApoCm3M2 := ((rPRI_DEFIANIL.APOCM3M2 * rPRI_DEFIANIL.PORCAPOR) / 100);
                           --
                           nCp_VoluMcM3 := ((nCp_M2_Impresora * rTinteros.SUPEARIM) / 100) * nCp_ApoCm3M2;
                           --
                           IF INSTR(rTinteros.COLOR,'BLANCO') != 0  THEN
                              IF rPRI_DEFIANIL.TIPOIMPR = 'FLEXO' THEN
                                 nCp_PeesTint := vP_PesoBlFl;
                              ELSIF rPRI_DEFIANIL.TIPOIMPR = 'HUECO' THEN
                                 nCp_PeesTint := vP_PesoBlHu;
                              ELSE
                                 nCp_PeesTint := 0;
                              END IF;   
                           ELSE
                              IF rPRI_DEFIANIL.TIPOIMPR = 'FLEXO' THEN
                                 nCp_PeesTint := vP_PesoReFl;
                              ELSIF rPRI_DEFIANIL.TIPOIMPR = 'HUECO' THEN
                                 nCp_PeesTint := vP_PesoReHu;
                              ELSE
                                 nCp_PeesTint := 0;
                              END IF;
                           END IF;
                           --
                           nCp_PeesTint := NVL(nCp_PeesTint ,0);
                           --
                           nCp_ConsTeKG := (nCp_PeesTint * nCp_VoluMcM3) /1000;
                        ELSE
                           nCp_ApoCm3M2 := 0;
                           nCp_VoluMcM3 := 0;
                           nCp_PeesTint := 0;
                           nCp_ConsTeKG := 0;
                           --
                           P_ERRORES('36- Aporte de CM3 de M2 del Anilox :'||rTinteros.ANILOX||' para el tipo de impresión '||rTinteros.TIPO_IMPRE||' no existe');
                        END IF;
                        --
                        nCf_SupeAIM2 := (nCp_M2_Impresora * rTinteros.SUPEARIM) / 100;
                        --
                        nCS_CF_SUPEAIM2 := nCS_CF_SUPEAIM2 + nCf_SupeAIM2;
                        --
                        nCs_Im_Canti := 0;
                        --
                        FOR rCompoForm IN cCompoForm(rTinteros.MATECODE) LOOP
                           nCs_Im_Canti := nCs_Im_Canti + rCompoForm.IM_CANTI;
                        END LOOP;
                        --
                        nCs_CoteKgCo := 0;
                        --
                        FOR rCompoForm IN cCompoForm(rTinteros.MATECODE) LOOP
                           IF rCompoForm.TIP_ARTI_COM = R_COMPFORM.TIP_ARTI_COM AND rCompoForm.COD_ARTI_COM = R_COMPFORM.COD_ARTI_COM THEN
                              IF NVL(nCs_Im_Canti,0) != 0 THEN
                                 nCp_CoteKgCo := nCp_ConsTeKG * (rCompoForm.IM_CANTI / nCs_Im_Canti);
                              ELSE
                                 nCp_CoteKgCo := 0;
                              END IF;
                              --
                              nCs_CoteKgCo := nCs_CoteKgCo + nCp_CoteKgCo;
                           END IF;
                        END LOOP;
                     END LOOP;
                  END LOOP;
               END LOOP;
               --                              
               IF NVL(nCs_CoteKgCo,0) != 0 THEN
                  nCP_COREKGCO := (nCP_COTEKGCO_CF / nCs_CoteKgCo) * (nConsReco - nCs_CoteKgCo); --CONSUMO RECLASIFICADO REAL
               ELSE
                  nCP_COREKGCO := 0;
               END IF;
               --TOTAL
               nCP_CP_COREKGCO := NVL(nCP_CP_COREKGCO,0) + NVL(nCP_COREKGCO,0);
               --
               nCP_COTOKGCO := NVL(nCP_COTEKGCO,0) + NVL(nCP_COREKGCO,0); --CONSUMO TOTAL REAL
               --TOTAL
               nCP_CP_COTOKGCO := NVL(nCP_CP_COTOKGCO,0) + NVL(nCP_COTOKGCO,0);
               --
               nCP_COERCONS := NVL(nCP_COTOKGCO,0) * NVL(nCP_PRECMERE,0); --COSTE EN € DEL CONSUMO REAL
               --TOTAL
               nCP_CP_COERCONS := NVL(nCP_CP_COERCONS,0) + NVL(nCP_COERCONS,0);
               --
               nCP_COEECONS := NVL(nCP_COTEKGCO,0) * NVL(nCP_PRECMEES,0); --COSTE EN € DEL CONSUMO ESTANDAR
               --Total de :CP_COEECONS
               nCP_CP_COEECONS := NVL(nCP_CP_COEECONS,0) + NVL(nCP_COEECONS,0);
               --
               nCP_CORECOCA := NVL(nCP_COTOKGCO,0) - NVL(nCP_COTEKGCO,0); --COMPARATIVO REAL - ESTANDAR / CONSUMO / CANTIDAD
               --TOTAL
               nCP_CP_CORECOCA := NVL(nCP_CP_CORECOCA,0) + NVL(nCP_CORECOCA,0);
               --
               IF NVL(nCP_COTEKGCO,0) != 0 THEN
                  nCP_CORECOPO := ((nCP_COTOKGCO - nCP_COTEKGCO) / nCP_COTEKGCO) * 100; --COMPARATIVO REAL - ESTANDAR / CONSUMO / %
               ELSE
                  nCP_CORECOPO := 0;
               END IF;
               --
               nCP_COREPMPR := NVL(nCP_PRECMERE,0) - NVL(nCP_PRECMEES,0); --COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ PRECIO
               --
               IF NVL(nCP_PRECMEES,0) != 0 THEN
                  nCP_COREPMPO := ((nCP_PRECMERE - nCP_PRECMEES) / nCP_PRECMEES) * 100; --COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ %
               ELSE
                  nCP_COREPMPO := 0;
               END IF;
               --
               nCP_CORECOCO := NVL(nCP_COERCONS,0) - NVL(nCP_COEECONS,0); --COMPARATIVO REAL - ESTANDAR / COSTE/ COSTE
               --
               IF NVL(nCP_COEECONS,0) != 0 THEN
                  nCP_CORECOPJ := ((nCP_COERCONS - nCP_COEECONS) / nCP_COEECONS) * 100; --COMPARATIVO REAL - ESTANDAR / COSTE/ %
               ELSE
                  nCP_CORECOPJ := 0;
               END IF;
               --
               IF NVL(nSumaCantComp,0) != 0 THEN
                  nRetorno_CF_PORCCOMP := (R_COMPFORM.IM_CANTI / nSumaCantComp) * 100;
               ELSE           
                   nRetorno_CF_PORCCOMP := 0;
               END IF;
               --(CS)
               nCS_CF_PORCCOMP := nCS_CF_PORCCOMP + nRetorno_CF_PORCCOMP;
               --SUMA PRECIO MEDIO ESTANDAR         
               IF NVL(nCP_CP_COTEKGCO,0) != 0 THEN
                  nCP_CP_PRECMEES := nCP_CP_COEECONS / nCP_CP_COTEKGCO;
               ELSE
                  nCP_CP_PRECMEES := 0;
               END IF;	 
               --SUMA PRECIO MEDIO REAL
               IF NVL(nCP_CP_COTOKGCO,0) != 0 THEN
                  nCP_CP_PRECMERE := nCP_CP_COERCONS / nCP_CP_COTOKGCO;
               ELSE
                  nCP_CP_PRECMERE := 0;
               END IF;
               --SUMA COMPARATIVO REAL - ESTANDAR / CONSUMO / %
               IF NVL(nCP_CP_COTEKGCO,0) != 0 THEN
                  nCP_CP_CORECOPO := ((nCP_CP_COTOKGCO - nCP_CP_COTEKGCO) / nCP_CP_COTEKGCO) * 100; --COMPARATIVO REAL - ESTANDAR / CONSUMO / %
               ELSE
                  nCP_CP_CORECOPO := 0;
               END IF;
               --SUMA COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ PRECIO
               nCP_CP_COREPMPR := nCP_CP_PRECMERE - nCP_CP_PRECMEES;
               --SUMA COMPARATIVO REAL - ESTANDAR / PRECIO MEDIO/ %
               IF NVL(nCP_CP_PRECMEES,0) != 0 THEN
                  nCP_CP_COREPMPO := ((nCP_CP_PRECMERE - nCP_CP_PRECMEES) / nCP_CP_PRECMEES) * 100;
               ELSE
                  nCP_CP_COREPMPO := 0;
               END IF;
               --SUMA COMPARATIVO REAL - ESTANDAR / COSTE/ COSTE
               nCP_CP_CORECOCO := nCP_CP_COERCONS - nCP_CP_COEECONS; --COMPARATIVO REAL - ESTANDAR / COSTE/ COSTE 
               --SUMA COMPARATIVO REAL - ESTANDAR / COSTE/ %
               IF NVL(nCP_CP_COEECONS,0) != 0 THEN
                  nCP_CP_CORECOPJ := ((nCP_CP_COERCONS - nCP_CP_COEECONS) / nCP_CP_COEECONS) * 100; 
               ELSE
                  nCP_CP_CORECOPJ := 0;
               END IF;
               --COSTE TOTAL DIRECTO ESTANDAR
               nCP_COTODIES := nCP_CP_COEECONS;
               --
               nCS_CP_COTODIES := nCS_CP_COTODIES + NVL(nCP_COTODIES,0); --(SUM)
               --
               nCP_CP_COTODIES := NVL(nCP_CP_COTODIES,0) + NVL(nCP_COTODIES,0);
               --
               nCP_COTODIES_CS := NVL(nCP_COTODIES_CS,0) + NVL(nCP_COEECONS,0);--:CP_COTODIES,0);	 
               --TOTAL COSTE ESTANDAR
               nCP_TOCODIES := NVL(nCP_COTODIES,0) + NVL(nCP_COTOINES,0);
               --TOTAL
               nCP_CP_TOCODIES := NVL(nCP_CP_TOCODIES,0) + NVL(nCP_TOCODIES,0);
               --COSTE TOTAL DIRECTO REAL
               nCP_COTODIRE := nCP_CP_COERCONS;
               --
               nCS_CP_COTODIRE := nCS_CP_COTODIRE + NVL(nCP_COTODIRE,0); --(SUM) 
               --TOTAL
               nCP_CP_COTODIRE := NVL(nCP_CP_COTODIRE,0) + NVL(nCP_COTODIRE,0);
               --TOTAL COSTE REAL
               nCP_TOCODIRE := NVL(nCP_COTODIRE,0) + NVL(nCP_COTOINRE,0);
               --TOTAL
               nCP_CP_TOCODIRE := NVL(nCP_CP_TOCODIRE,0) + NVL(nCP_TOCODIRE,0);
                --
               nCP_COTODIRE_CS := NVL(nCP_COTODIRE_CS,0) + NVL(nCP_COERCONS,0);--:CP_COTODIRE,0);	 
               -->
               --DIFERENCIA COSTE TOTAL DIRECTO
               nCP_DICTDIRE := NVL(nCP_COTODIRE,0) - NVL(nCP_COTODIES,0);
               --
               nCS_CP_DICTDIRE := nCS_CP_DICTDIRE + NVL(nCP_DICTDIRE,0); --(SUM)
               --PORCENTAJE DIFERENCIA COSTE TOTAL DIRECTO
               IF NVL(nCP_COTODIES,0) != 0 THEN
                  nCP_POCTDIRE := ((nCP_COTODIRE - nCP_COTODIES) / nCP_COTODIES) * 100;
               ELSE
                  nCP_POCTDIRE := 0;
               END IF;
               --DIFERENCIA COSTE TOTAL INDIRECTO
               nCP_DICTINDI := NVL(nCP_COTOINRE,0) - NVL(nCP_COTOINES,0);
               --
               nCS_CP_DICTINDI := nCS_CP_DICTINDI + NVL(nCP_DICTINDI,0);--(SUM)
               --PORCENTAJE DIFERENCIA COSTE TOTAL INDIRECTO
               IF NVL(nCP_COTOINES,0) != 0 THEN
                  nCP_POCTINDI := ((nCP_COTOINRE - nCP_COTOINES) / nCP_COTOINES) * 100;
               ELSE
                  nCP_POCTINDI := 0;
               END IF;
               --DIFERENCIA TOTAL COSTE
               nCP_DICTTOCO := NVL(nCP_TOCODIRE,0) - NVL(nCP_TOCODIES,0);
               --
               nCS_CP_DICTTOCO := nCS_CP_DICTTOCO + NVL(nCP_DICTTOCO,0); --(SUM)
               --PORCENTAJE DIFERENCIA COSTE TOTAL
               IF NVL(nCP_TOCODIES,0) != 0 THEN
                  nCP_POCTTOCO := ((nCP_TOCODIRE - nCP_TOCODIES) / nCP_TOCODIES) * 100;
               ELSE
                  nCP_POCTTOCO := 0;
               END IF;	 
               --PORCENTAJE DIFERENCIA COSTE TOTAL DIRECTO
               IF NVL(nCP_CP_COTODIES,0) != 0 THEN
                  nCP_CP_POCTDIRE := ((nCP_CP_COTODIRE - nCP_CP_COTODIES) / nCP_CP_COTODIES) * 100;
               ELSE
                  nCP_CP_POCTDIRE := 0;
               END IF;
               --PORCENTAJE DIFERENCIA COSTE TOTAL
               IF NVL(nCP_CP_TOCODIES,0) != 0 THEN
                  nCP_CP_POCTTOCO := ((nCP_CP_TOCODIRE - nCP_CP_TOCODIES) / nCP_CP_TOCODIES) * 100;
               ELSE
                  nCP_CP_POCTTOCO := 0;
               END IF;
               --Consumos de Tintas     
               IF nCS_CP_INNEESTA != 0 THEN
                  nCP_POCTESTA_CS := ((NVL(nCP_COTODIES_CS,0) + NVL(nCP_COTOINES_CS,0)) / nCS_CP_INNEESTA) * 100;
               ELSE
                  nCP_POCTESTA_CS := 0;
               END IF;	 
               --
               IF nCS_CP_INNEREAL != 0 THEN
                  nCP_POCTREAL_CS := ((NVL(nCP_COTODIRE_CS,0) + NVL(nCP_COTOINRE_CS,0)) / nCS_CP_INNEREAL) * 100;
               ELSE
                  nCP_POCTREAL_CS := 0;
               END IF;
               --
               nCP_DIFECOTI_CS := (NVL(nCP_COTODIRE_CS,0) + NVL(nCP_COTOINRE_CS,0)) - (NVL(nCP_COTODIES_CS,0) + NVL(nCP_COTOINES_CS,0));
               --
               IF (NVL(nCP_COTODIES_CS,0) + NVL(nCP_COTOINES_CS,0)) != 0 THEN
                  nCP_DIPOCOTI_CS := (nCP_DIFECOTI_CS / (NVL(nCP_COTODIES_CS,0) + NVL(nCP_COTOINES_CS,0))) * 100;
               ELSE
                  nCP_DIPOCOTI_CS := 0;
               END IF;
               --Total Consumos
               nCP_TOTACOES_CS := NVL(nCS_CP_COLAESTA,0) + (NVL(nCP_COTODIES_CS,0) + NVL(nCP_COTOINES_CS,0));
               --
               IF nCS_CP_INNEESTA != 0 THEN
                  nCP_POTOCOES_CS := (nCP_TOTACOES_CS / nCS_CP_INNEESTA) * 100;
               ELSE
                  nCP_POTOCOES_CS := 0;
               END IF;
               --
               nCP_TOTACORE_CS := NVL(nCS_CP_COLAREAL,0) + (NVL(nCP_COTODIRE_CS,0) + NVL(nCP_COTOINRE_CS,0));
               --
               IF nCS_CP_INNEREAL != 0 THEN
                  nCP_POTOCORE_CS := (nCP_TOTACORE_CS / nCS_CP_INNEREAL) * 100;
               ELSE
                  nCP_POTOCORE_CS := 0;
               END IF;
               --
               nCP_DIFETOCO_CS := nCP_TOTACORE_CS - nCP_TOTACOES_CS;
               --
               IF nCP_TOTACOES_CS != 0 THEN
                  nCP_DIPOTOCO_CS := (nCP_DIFETOCO_CS / nCP_TOTACOES_CS) * 100;
               ELSE               
                  nCP_DIPOTOCO_CS := 0;
               END IF;   
               --Coste Productos Vendidos
               nCP_COPRVEES_CS := nCP_TOTACOES_CS + nCS_CP_COMTESTA;
               --
               IF nCS_CP_INNEESTA != 0 THEN
                  nCP_POCOPVES_CS := (nCP_COPRVEES_CS / nCS_CP_INNEESTA) * 100;
               ELSE
                  nCP_POCOPVES_CS := 0;
               END IF;
               --
               nCP_COPRVERE_CS := nCP_TOTACORE_CS + nCS_CP_COMTREAL;
               --
               IF nCS_CP_INNEREAL != 0 THEN
                  nCP_POCOPVRE_CS := (nCP_COPRVERE_CS / nCS_CP_INNEREAL) * 100;
               ELSE
                  nCP_POCOPVRE_CS := 0;
               END IF;
               --
               nCP_DICOPRVE_CS := nCP_COPRVERE_CS - nCP_COPRVEES_CS;
               --
               IF nCP_COPRVEES_CS != 0 THEN
                  nCP_DPCOPRVE_CS := (nCP_DICOPRVE_CS / nCP_COPRVEES_CS) * 100;
               ELSE
                  nCP_DPCOPRVE_CS := 0;
               END IF;   
               --Margen sobre Materiales
               nCP_MAMAESTA_CS := nCS_CP_INNEESTA - nCP_COPRVEES_CS;
               --
               IF nCS_CP_INNEESTA != 0 THEN
                  nCP_POMAMAES_CS := (nCP_MAMAESTA_CS / nCS_CP_INNEESTA) * 100;
               ELSE
                  nCP_POMAMAES_CS := 0;
               END IF;
               --
               nCP_MAMAREAL_CS := nCS_CP_INNEREAL - nCP_COPRVERE_CS;
               --
               IF nCS_CP_INNEREAL != 0 THEN
                  nCP_POMAMARE_CS := (nCP_MAMAREAL_CS / nCS_CP_INNEREAL) * 100;
               ELSE
                  nCP_POMAMARE_CS := 0;
               END IF;
               --
               nCP_DIFEMAMA_CS := nCP_MAMAREAL_CS - nCP_MAMAESTA_CS;
               --
               IF nCP_MAMAESTA_CS != 0 THEN
                  nCP_DIPOMAMA_CS := (nCP_DIFEMAMA_CS / nCP_MAMAESTA_CS) * 100;
               ELSE
                  nCP_DIPOMAMA_CS := 0;
               END IF;
               --Margen de Produccion
               nCP_MARGPRES_CS := nCP_MAMAESTA_CS - NVL(nCS_CF_COSTE_TOTAL_ESTANDAR,0) - NVL(nCP_SUM_OTROCOST_E,0);
               --
               IF nCS_CP_INNEESTA != 0 THEN
                  nCP_POMAPRES_CS := (nCP_MARGPRES_CS / nCS_CP_INNEESTA ) * 100;
               ELSE
                  nCP_POMAPRES_CS := 0;
               END IF;
               --
               nCP_MARGPRRE_CS := nCP_MAMAREAL_CS - NVL(nCS_CF_COSTE_TOTAL_REAL,0) - NVL(nCP_SUM_OTROCOST_R,0);
               --
               IF nCS_CP_INNEREAL != 0 THEN
                  nCP_POMAPRRE_CS := (nCP_MARGPRRE_CS / nCS_CP_INNEREAL ) * 100;
               ELSE
                  nCP_POMAPRRE_CS := 0;
               END IF;
               --
               nCP_DIFEMAPR_CS := nCP_MARGPRRE_CS - nCP_MARGPRES_CS ;
               --
               IF nCP_MARGPRES_CS != 0 THEN
                  nCP_DIPOMAPR_CS := (nCP_DIFEMAPR_CS / nCP_MARGPRES_CS) * 100;
               ELSE
                  nCP_DIPOMAPR_CS := 0;
               END IF;
               --Margen Industrial
               nCP_MAINESTA_CS := nCP_MARGPRES_CS - nCP_TOCOSPES_CS;
               --
               IF nCS_CP_INNEESTA != 0 THEN
                  nCP_POMAINES_CS := (nCP_MAINESTA_CS / nCS_CP_INNEESTA) * 100;
               ELSE
                  nCP_POMAINES_CS := 0;
               END IF;
               --                                          
               nCP_MAINREAL_CS := nCP_MARGPRRE_CS - nCP_TOCOSPRE_CS;
               --
               IF nCS_CP_INNEREAL != 0 THEN
                  nCP_POMAINRE_CS := (nCP_MAINREAL_CS / nCS_CP_INNEREAL) * 100;
               ELSE
                  nCP_POMAINRE_CS := 0;
               END IF;
               --
               nCP_DIFEMAIN_CS := nCP_MAINREAL_CS - nCP_MAINESTA_CS;
               --
               IF nCP_MAINESTA_CS != 0 THEN
                  nCP_DIPOMAIN_CS := (nCP_DIFEMAIN_CS / nCP_MAINESTA_CS) * 100;
               ELSE
                  nCP_DIPOMAIN_CS := 0;
               END IF;
               --Margen Comercial
               nCP_MACOESTA_CS := nCP_MAINESTA_CS - nCP_SUM_COSTCOME_E;
               --
               IF nCS_CP_INNEESTA != 0 THEN
                  nCP_POMACOES_CS := (nCP_MACOESTA_CS / nCS_CP_INNEESTA) * 100;
               ELSE
                  nCP_POMACOES_CS := 0;
               END IF;
               --                                          
               nCP_MACOREAL_CS := nCP_MAINREAL_CS - nCP_SUM_COSTCOME_R;
               --
               IF nCS_CP_INNEREAL != 0 THEN
                  nCP_POMACORE_CS := (nCP_MACOREAL_CS / nCS_CP_INNEREAL) * 100;
               ELSE
                  nCP_POMACORE_CS := 0;
               END IF;
               --
               nCP_DIFEMACO_CS := nCP_MACOREAL_CS - nCP_MACOESTA_CS;
               --
               IF nCP_MACOESTA_CS != 0 THEN
                  nCP_DIPOMACO_CS := (nCP_DIFEMACO_CS / nCP_MACOESTA_CS) * 100;
               ELSE
                  nCP_DIPOMACO_CS := 0;
               END IF;
               --Margen de Contribucion
               nCP_MARCESTA_CS := nCP_MACOESTA_CS - nCP_SUM_COSTDIST_E;
               --
               IF nCS_CP_INNEESTA != 0 THEN
                  nCP_POMARCES_CS := (nCP_MARCESTA_CS / nCS_CP_INNEESTA) * 100;
               ELSE
                  nCP_POMARCES_CS := 0;
               END IF;
               --                                          
               nCP_MARCREAL_CS := nCP_MACOREAL_CS - nCP_SUM_COSTDIST_R;
               --
               IF nCS_CP_INNEREAL != 0 THEN
                  nCP_POMARCRE_CS := (nCP_MARCREAL_CS / nCS_CP_INNEREAL) * 100;
               ELSE
                  nCP_POMARCRE_CS := 0;
               END IF;
               --
               nCP_DIFEMARC_CS := nCP_MARCREAL_CS - nCP_MARCESTA_CS;
               --
               IF nCP_MARCESTA_CS != 0 THEN
                  nCP_DIPOMARC_CS := (nCP_DIFEMARC_CS / nCP_MARCESTA_CS) * 100;
               ELSE
                  nCP_DIPOMARC_CS := 0;
               END IF;
               --EBITDA
               nCP_MAEBESTA_CS := nCP_MARCESTA_CS - nCP_SUM_COSTADMI_E;
               --
               IF nCS_CP_INNEESTA != 0 THEN
                  nCP_POMAEBES_CS := (nCP_MAEBESTA_CS / nCS_CP_INNEESTA) * 100;
               ELSE
                  nCP_POMAEBES_CS := 0;
               END IF;
               --                                          
               nCP_MAEBREAL_CS := nCP_MARCREAL_CS - nCP_SUM_COSTADMI_R;
               --
               IF nCS_CP_INNEREAL != 0 THEN
                  nCP_POMAEBRE_CS := (nCP_MAEBREAL_CS / nCS_CP_INNEREAL) * 100;
               ELSE
                  nCP_POMAEBRE_CS := 0;
               END IF;
               --
               nCP_DIFEMAEB_CS := nCP_MAEBREAL_CS - nCP_MAEBESTA_CS;
               --
               IF nCP_MAEBESTA_CS != 0 THEN
                  nCP_DIPOMAEB_CS := (nCP_DIFEMAEB_CS / nCP_MAEBESTA_CS) * 100;
               ELSE
                  nCP_DIPOMAEB_CS := 0;
               END IF;
               --CASH FLOW OPERATIVO
               nCP_CFOPESTA_CS := nCP_MAEBESTA_CS - nCS_CP_COFIESTA;
               --
               IF nCS_CP_INNEESTA != 0 THEN
                  nCP_POCFOPES_CS := (nCP_CFOPESTA_CS / nCS_CP_INNEESTA) * 100;
               ELSE
                  nCP_POCFOPES_CS := 0;
               END IF;
               --                                          
               nCP_CFOPREAL_CS := nCP_MAEBREAL_CS - nCS_CP_COFIREAL;
               --
               IF nCS_CP_INNEREAL != 0 THEN
                  nCP_POCFOPRE_CS := (nCP_CFOPREAL_CS / nCS_CP_INNEREAL) * 100;
               ELSE
                  nCP_POCFOPRE_CS := 0;
               END IF;
               --
               nCP_DIFECFOP_CS := nCP_CFOPREAL_CS - nCP_CFOPESTA_CS;
               --
               IF nCP_CFOPESTA_CS != 0 THEN
                  nCP_DIPOCFOP_CS := (nCP_DIFECFOP_CS / nCP_CFOPESTA_CS) * 100;
               ELSE
                  nCP_DIPOCFOP_CS := 0;
               END IF;
               --CASH FLOW OPERATIVO + MARGEN DE GRABADOS
               nCP_CFMGESTA_CS := nCP_CFOPESTA_CS + NVL(nCP_MAGRESTA_CS,0);
               --
               IF nCS_CP_INNEESTA != 0 THEN
                  nCP_POCFMGES_CS := (nCP_CFMGESTA_CS / nCS_CP_INNEESTA) * 100;
               ELSE
                  nCP_POCFMGES_CS := 0;
               END IF;
               --                                          
               nCP_CFMGREAL_CS := nCP_CFOPREAL_CS + NVL(nCS_CP_RESUPREI,0);
               --
               IF nCS_CP_INNEREAL != 0 THEN
                  nCP_POCFMGRE_CS := (nCP_CFMGREAL_CS / nCS_CP_INNEREAL) * 100;
               ELSE
                  nCP_POCFMGRE_CS := 0;
               END IF;
               --
               nCP_DIFECFMG_CS := nCP_CFMGREAL_CS - nCP_CFMGESTA_CS;
               --
               IF nCP_CFMGESTA_CS != 0 THEN
                  nCP_DIPOCFMG_CS := (nCP_DIFECFMG_CS / nCP_CFMGESTA_CS) * 100;
               ELSE
                  nCP_DIPOCFMG_CS := 0;
               END IF;
            END LOOP;
--2--            
            --
            nCS_CP_TOCODIRE := nCS_CP_TOCODIRE + NVL(nCP_TOCODIRE,0); --(SUM)
            --
            nCS_CP_TOCODIES := nCS_CP_TOCODIES + NVL(nCP_TOCODIES,0); --(SUM)
         END LOOP;
      END LOOP;
      --
      RETURN NULL;
   end;
--------------------FIN TINTAS----------------------------
--------------------F_CEROIZQU----------------------------
   FUNCTION F_CeroIzqu (vValor VARCHAR2) RETURN VARCHAR2 IS
      vRetorno VARCHAR2(100);
   BEGIN
      IF LENGTH(vValor) < 2 THEN
          vRetorno := LPAD(vValor,2,'0');
      ELSE
         vRetorno := vValor;
      END IF;
      --
      RETURN (vRetorno);
   END;
--------------------FIN F_CEROIZQU------------------------
--------------------CS_SUM_COSTUNOT-----------------------
   FUNCTION CS_SUM_COSTUNOT(vEmpresa  FIC_CABEOTRE.EMPRESA%TYPE,  
                            dFecha_Cierre DATE) 
   RETURN NUMBER IS
      --Calculo de CS_CP_SUM_COSTUNOT Y CS_CP_SUM_COSTUNOT_E
      nCP_COSTRESE_PREI NUMBER;
      nF_CALCMEAN NUMBER;
      vCF_TIPOCOST_PREI VARCHAR2(250);
      nCS_CP_SUM_COSTUNOT NUMBER;
      nCF_COSTREPR_PREI NUMBER;
      --
      CURSOR cG_TIPOCOST IS
         SELECT EC.TIPOCOST TIPOCOST_PREI, TC.TIPOCOST DESCTICO_PREI
         FROM GNR_ESCCEMPR EC, GNR_TICOEMPR TC
         WHERE NOT EXISTS (SELECT 'X' FROM VALORES_LISTA EX WHERE EX.CODIGO = 'ANE_ESTREXCR' AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'ESTRUCTURA') = EC.ESTRUCTU)
              AND EC.TIPOCOST = TC.CODIGO(+)         
              AND EC.DEPARTAM = vP_CODECOMU
              AND EC.INDUCOMU != vP_INDUSIIN
         GROUP BY EC.TIPOCOST, TC.TIPOCOST
         UNION
         SELECT NULL TIPOCOST,  P_UTILIDAD.F_ValoCampo(EX.VALOR,'DESCRIPCION') DESCTICO
         FROM VALORES_LISTA EX, GNR_DEPAEMPR DE,GNR_SPDEEMPR SD, GNR_SEPREMPR SP, VALORES_LISTA SAU, GNR_SEAUEMPR SA
         WHERE EX.CODIGO = 'ANE_ESTREXCR'
           AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'LISTADOS') = 'S'
           AND DE.CODIGO  = vP_CODECOMU
           AND DE.CODIGO = SD.DEPARTAM
           AND SD.SECCION = SP.CODIGO
           AND SAU.CODIGO = 'GNR_RESPAURH'
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCION')= SD.SECCION
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCAUXI') = SA.CODIGO(+)
         UNION
         SELECT EC.TIPOCOST, TC.TIPOCOST DESCTICO
         FROM GNR_ESCCEMPR EC, GNR_TICOEMPR TC
         WHERE NOT EXISTS (SELECT 'X' FROM VALORES_LISTA EX WHERE EX.CODIGO = 'ANE_ESTREXCR' AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'ESTRUCTURA') = EC.ESTRUCTU)
              AND EC.TIPOCOST = TC.CODIGO(+)
              AND EC.DEPARTAM = vP_CODEPREI
         GROUP BY EC.TIPOCOST, TC.TIPOCOST
         UNION
         SELECT NULL TIPOCOST,  P_UTILIDAD.F_ValoCampo(EX.VALOR,'DESCRIPCION') DESCTICO
         FROM VALORES_LISTA EX, GNR_DEPAEMPR DE,GNR_SPDEEMPR SD, GNR_SEPREMPR SP, VALORES_LISTA SAU, GNR_SEAUEMPR SA
         WHERE EX.CODIGO = 'ANE_ESTREXCR'
           AND P_UTILIDAD.F_ValoCampo(EX.VALOR,'LISTADOS') = 'S'
           AND DE.CODIGO  = vP_CODEPREI
           AND DE.CODIGO = SD.DEPARTAM
           AND SD.SECCION = SP.CODIGO
           AND SAU.CODIGO = 'GNR_RESPAURH'
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCION')= SD.SECCION
           AND P_UTILIDAD.f_ValoCampo(SAU.VALOR,'SECCAUXI') = SA.CODIGO(+);
      --
      CURSOR cG_SECCAUXI IS
         SELECT S.DEPARTAM DEPARTAM_PREI, D.DEPARTAM DESCDEPA_PREI, S.SECCION SECCION_PREI, SD.SECCION DESCSECC_PREI, SA.SECCAUXI SECCAUXI_PREI, SAD.SECCAUXI DESCSEAU_PREI, D.INDUREPR INDUREPR_PREI, SAD.REPAABSO REPAABSO_PREI, D.INDURESE INDURESE_PREI, ROWNUM ROWNUM_PREI, INDP.CALCPRSU CALCPRSU_REPR_PREI, INDS.CALCPRSU CALCPRSU_RESE_PREI, D.CAVAISDE CAVAISDE_PREI, SAD.INREOBCO INREOBCO_PREI, INDP.INDUCTOR DEINREPR_PREI
         FROM GNR_SPDEEMPR S, GNR_SASPEMPR SA, GNR_SEAUEMPR SAD, GNR_DEPAEMPR D, GNR_SEPREMPR SD, GNR_INDUEMPR INDP, GNR_INDUEMPR INDS
            WHERE S.SECCION = SA.SECCION
              AND S.SECCION = SD.CODIGO
              AND SA.SECCAUXI = SAD.CODIGO
              AND S.DEPARTAM = D.CODIGO
              AND D.INDUREPR = INDP.CODIGO(+)
              AND D.INDURESE = INDS.CODIGO(+)
              AND S.DEPARTAM = vP_CODEPREI
         ORDER BY SAD.REPAABSO DESC, S.DEPARTAM, S.SECCION, SA.SECCAUXI;
      --
      FUNCTION F_CALCMEAN RETURN NUMBER IS
         nRetorno NUMBER := 0;
      begin
          IF TO_CHAR(dFecha_Cierre,'YYYY') <= TO_CHAR(dFecha_Cierre,'YYYY') THEN 
              FOR vAnno IN TO_CHAR(dFecha_Cierre,'YYYY')..TO_CHAR(dFecha_Cierre,'YYYY') LOOP
                IF vAnno = TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno = TO_CHAR(dFecha_Cierre,'YYYY') THEN
                    nRetorno := nRetorno + ((TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM'))) + 1);
                ELSIF vAnno = TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno != TO_CHAR(dFecha_Cierre,'YYYY') THEN                                      
                   nRetorno := nRetorno + ((TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||'12') - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM'))) + 1);
                ELSIF vAnno != TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno = TO_CHAR(dFecha_Cierre,'YYYY') THEN      
                   nRetorno := nRetorno + (TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) - TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||'00'));
                ELSIF vAnno != TO_CHAR(dFecha_Cierre,'YYYY') AND vAnno != TO_CHAR(dFecha_Cierre,'YYYY') THEN
                   nRetorno := nRetorno + 12;
                ELSE
                   nRetorno := nRetorno + 0;
                END IF;
             END LOOP;
          END IF;
         --
         RETURN nRetorno;
      END;
      --
      FUNCTION CF_COSTSRDI_PREI(vDEPARTAM_PREI GNR_SPDEEMPR.DEPARTAM%TYPE) return Number is
         rANE_INDRCO_Rec_Dep P_ANE_INDRCO.St_ANE_INDRCO_AM;
      begin
         rANE_INDRCO_Rec_Dep := P_ANE_INDRCO.F_ObtieneCosteSubrepDepto_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_PREI, vCF_TIPOCOST_PREI);
         --
         RETURN(rANE_INDRCO_Rec_Dep.nCoste);
      END;
      --
      FUNCTION CF_COSTRESA_PREI(vDEPARTAM_PREI GNR_SPDEEMPR.DEPARTAM%TYPE, vSECCION_PREI GNR_SPDEEMPR.SECCION%TYPE, vSECCAUXI_PREI GNR_SASPEMPR.SECCAUXI%TYPE) return Number is
         rANE_INRETC_Rec_Sea P_ANE_INRETC.St_ANE_INRETC_AM;
         nRetorno NUMBER;
      BEGIN
         rANE_INRETC_Rec_Sea := P_ANE_INRETC.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_PREI, vSECCION_PREI, vSECCAUXI_PREI, vCF_TIPOCOST_PREI);
         --
         IF vEmpresa = vP_EMPRPHAR THEN
            nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOPHAR,0);
         ELSIF vEmpresa = vP_EMPRMANV THEN
            nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOMANV,0);
         ELSE           
            nRetorno := 0;
         END IF;
         --
        RETURN(nRetorno);
      END;
      --
      FUNCTION CF_TOTAINPR_PREI(vINDUREPR_PREI GNR_DEPAEMPR.INDUREPR%TYPE, vCALCPRSU_REPR_PREI GNR_INDUEMPR.CALCPRSU%TYPE) return Number is
         CURSOR cInductor_Tot IS
            SELECT SUM(VALOR) SUMA
               FROM ANE_COISSSRE
                  WHERE EMPRESA = vEmpresa
                    AND INDUCTOR = vINDUREPR_PREI
                    AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
                  AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'));
         --
         nInductor_Tot NUMBER := 0;
      begin
          IF vINDUREPR_PREI IS NOT NULL THEN
            nInductor_Tot := 0;
            --
            OPEN cInductor_Tot;
            FETCH cInductor_Tot INTO nInductor_Tot;
            CLOSE cInductor_Tot;
            --
            nInductor_Tot := NVL(nInductor_Tot,0);
            --
             IF vCALCPRSU_REPR_PREI = 'P' THEN
                 IF nF_CALCMEAN != 0 THEN
                   nInductor_Tot := nInductor_Tot / nF_CALCMEAN;
                 ELSE
                    nInductor_Tot := 0;
                 END IF;
             END IF;   
          END IF;
          --
         RETURN(nInductor_Tot);     
      end;
      --
      FUNCTION CF_TOTAINSE_PREI(vINDURESE_PREI GNR_DEPAEMPR.INDURESE%TYPE, vCALCPRSU_RESE_PREI GNR_INDUEMPR.CALCPRSU%TYPE) return Number is
         CURSOR cInductor_Tot IS
            SELECT SUM(VALOR) SUMA
               FROM ANE_COISSSRE
                  WHERE EMPRESA = vEmpresa
                    AND INDUCTOR = vINDURESE_PREI
                    AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
                  AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'));
         --
         nInductor_Tot NUMBER := 0;
      begin
          IF vINDURESE_PREI IS NOT NULL THEN
            nInductor_Tot := 0;
            --
            OPEN cInductor_Tot;
            FETCH cInductor_Tot INTO nInductor_Tot;
            CLOSE cInductor_Tot;
            --
            nInductor_Tot := NVL(nInductor_Tot,0);
            --
             IF vCALCPRSU_RESE_PREI = 'P' THEN
                 IF nF_CALCMEAN != 0 THEN
                   nInductor_Tot := nInductor_Tot / nF_CALCMEAN;
                 ELSE
                    nInductor_Tot := 0;
                 END IF;
             END IF;   
         END IF;   	
         --
         RETURN(nInductor_Tot);     
      END;
      --
      FUNCTION CF_COSTREPR_PREI(vDEPARTAM_PREI GNR_SPDEEMPR.DEPARTAM%TYPE, vSECCION_PREI GNR_SPDEEMPR.SECCION%TYPE, vSECCAUXI_PREI GNR_SASPEMPR.SECCAUXI%TYPE, 
                                vTIPOCOST_PREI GNR_ESCCEMPR.TIPOCOST%TYPE, vDESCTICO_PREI GNR_TICOEMPR.TIPOCOST%TYPE,
                                vREPAABSO_PREI GNR_SEAUEMPR.REPAABSO%TYPE,
                                vINDUREPR_PREI GNR_DEPAEMPR.INDUREPR%TYPE, vCALCPRSU_REPR_PREI GNR_INDUEMPR.CALCPRSU%TYPE,
                                vCAVAISDE_PREI GNR_DEPAEMPR.CAVAISDE%TYPE,
                                vINDURESE_PREI GNR_DEPAEMPR.INDURESE%TYPE, vCALCPRSU_RESE_PREI GNR_INDUEMPR.CALCPRSU%TYPE) return Number is
         rANE_INRETC_Rec_Sea P_ANE_INRETC.St_ANE_INRETC_AM;
         --
         nRetorno NUMBER := 0;
         --
         CURSOR cSeccAuxi_Repa IS
            SELECT S.SECCION, SA.SECCAUXI 
               FROM GNR_SPDEEMPR S, GNR_SASPEMPR SA, GNR_SEAUEMPR SAD, GNR_DEPAEMPR D
               WHERE S.SECCION = SA.SECCION
                 AND SA.SECCAUXI = SAD.CODIGO
                 AND S.DEPARTAM = D.CODIGO
                 AND S.DEPARTAM = vP_CODEPREI
                 AND SAD.REPAABSO = 'R';
         --
         CURSOR cInductor(vDepartam ANE_COISSSRE.DEPARTAM%TYPE, vSeccion ANE_COISSSRE.SECCION%TYPE, vSeccAuxi ANE_COISSSRE.SECCAUXI%TYPE, vInductor ANE_COISSSRE.INDUCTOR%TYPE) IS
            SELECT SUM(VALOR) SUMA
               FROM ANE_COISSSRE
                  WHERE EMPRESA = vEmpresa
                    AND DEPARTAM = vDepartam
                    AND SECCION = vSeccion
                    AND SECCAUXI = vSeccAuxi
                    AND INDUCTOR = vInductor
                    AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
                  AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYY')||TO_CHAR(dFecha_Cierre,'MM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'));
         --
         nInductor NUMBER := 0;
         --
         nCostRepa NUMBER;
         --
         CURSOR cGNR_TCEXRSDE IS
            SELECT 'X' FROM GNR_TCEXRSDE EX, GNR_TICOEMPR TC
               WHERE EX.TIPOCOST = TC.CODIGO
                 AND DEPARTAM = vDEPARTAM_PREI
                 AND (
                      (vTIPOCOST_PREI IS NOT NULL AND EX.TIPOCOST = vTIPOCOST_PREI) OR
                      (vTIPOCOST_PREI IS NULL AND EX.TIPOCOST||' '||TC.TIPOCOST = vDESCTICO_PREI)
                     );
         --
         vExisExcl VARCHAR2(1); 
         nCP_COSTUNOT_PREI NUMBER;
         nCF_TOTAINPR_PREI NUMBER := CF_TOTAINPR_PREI(vINDUREPR_PREI, vCALCPRSU_REPR_PREI);
         nCF_COSTRESA_PREI NUMBER := CF_COSTRESA_PREI(vDEPARTAM_PREI, vSECCION_PREI, vSECCAUXI_PREI);
         nCF_COSTSRDI_PREI NUMBER := CF_COSTSRDI_PREI(vDEPARTAM_PREI);
         nCF_TOTAINSE_PREI NUMBER := CF_TOTAINSE_PREI(vINDURESE_PREI, vCALCPRSU_RESE_PREI);
      BEGIN
         vExisExcl := NULL;
         --
         OPEN cGNR_TCEXRSDE;
         FETCH cGNR_TCEXRSDE INTO vExisExcl;
         CLOSE cGNR_TCEXRSDE;
         --	
          IF vREPAABSO_PREI = 'R' THEN
             rANE_INRETC_Rec_Sea := P_ANE_INRETC.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_PREI, vSECCION_PREI, vSECCAUXI_PREI, vCF_TIPOCOST_PREI);
            --
            IF vExisExcl IS NULL THEN
               IF vEmpresa = vP_EMPRPHAR THEN
                  nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOPHAR,0);
               ELSIF vEmpresa = vP_EMPRMANV THEN
                  nRetorno := NVL(rANE_INRETC_Rec_Sea.nCOTOMANV,0);
               ELSE
                  nRetorno := 0;
               END IF;        
            ELSE
               nRetorno := 0;
            END IF;
            --
            nCP_COSTRESE_PREI := NULL;
            --
            nCP_COSTUNOT_PREI := NULL;
         ELSE
              IF vINDUREPR_PREI IS NOT NULL THEN
                 nInductor := 0;
               --
               OPEN cInductor(vDEPARTAM_PREI, vSECCION_PREI, vSECCAUXI_PREI, vINDUREPR_PREI);
               FETCH cInductor INTO nInductor;
               CLOSE cInductor;
               --
               nInductor := NVL(nInductor,0);
               --
                IF vCALCPRSU_REPR_PREI = 'P' THEN
                    IF nF_CALCMEAN != 0 THEN
                      nInductor := nInductor / nF_CALCMEAN;
                    ELSE
                        nInductor := 0;
                    END IF;
                END IF; 
               --
               IF NVL(nCF_TOTAINPR_PREI,0) != 0 AND NVL(nInductor,0) != 0 THEN
                   nCostRepa := nCF_COSTSRDI_PREI;
                   --
                  FOR rSeccAuxi_Repa IN cSeccAuxi_Repa LOOP
                     rANE_INRETC_Rec_Sea := P_ANE_INRETC.F_ObtieneSeccAuxi_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), vDEPARTAM_PREI, rSeccAuxi_Repa.SECCION, rSeccAuxi_Repa.SECCAUXI, vCF_TIPOCOST_PREI);
                     --
                     IF vEmpresa = vP_EMPRPHAR THEN
                        nCostRepa := nCostRepa + NVL(rANE_INRETC_Rec_Sea.nCOTOPHAR,0);
                     ELSIF vEmpresa = vP_EMPRMANV THEN
                        nCostRepa := nCostRepa + NVL(rANE_INRETC_Rec_Sea.nCOTOMANV,0);
                     END IF;   
                  END LOOP;
                  --
                  IF nCostRepa != 0 THEN
                     nRetorno := ((nCostRepa / nCF_TOTAINPR_PREI) * nInductor);
                  END IF;
               END IF;
            ELSE
               nRetorno := nCF_COSTSRDI_PREI;
            END IF;
            --
            IF vExisExcl IS NULL THEN
               nCP_COSTRESE_PREI := nRetorno + nCF_COSTRESA_PREI;
            ELSE
               nCP_COSTRESE_PREI := nRetorno;
            END IF;
            --
            IF vINDURESE_PREI IS NOT NULL THEN
               IF vCAVAISDE_PREI = 'S' THEN
                  nInductor := 0;
                  --
                  OPEN cInductor(vDEPARTAM_PREI, vSECCION_PREI, vSECCAUXI_PREI, vINDURESE_PREI);
                  FETCH cInductor INTO nInductor;
                  CLOSE cInductor;
                  --
                  nInductor := NVL(nInductor,0);
                  --
                        IF vCALCPRSU_RESE_PREI = 'P' THEN
                            IF nF_CALCMEAN != 0 THEN
                              nInductor := nInductor / nF_CALCMEAN;
                           ELSE
                              nInductor := 0;
                           END IF;
                        END IF; 
                  --
                  IF NVL(nInductor,0) != 0 THEN
                     nCP_COSTUNOT_PREI := nCP_COSTRESE_PREI / nInductor;
                  ELSE
                     nCP_COSTUNOT_PREI := 0;
                  END IF;
               ELSE
                  IF NVL(nCF_TOTAINSE_PREI,0) != 0 THEN
                     nCP_COSTUNOT_PREI := nCP_COSTRESE_PREI / nCF_TOTAINSE_PREI;
                  ELSE
                     nCP_COSTUNOT_PREI := 0;
                  END IF;
               END IF;
               -----------------------------------------------------------------------------
               nCS_CP_SUM_COSTUNOT := NVL(nCS_CP_SUM_COSTUNOT,0) + NVL(nCP_COSTUNOT_PREI,0);
            ELSE
              nCP_COSTUNOT_PREI := NULL; 	
            END IF;
         END IF;
         --
         RETURN(nRetorno);
      END;   
   begin
      nF_CALCMEAN := F_CALCMEAN;
      --
      IF NOT (P_ANE_INRETC.F_Obtiene_AM_ALM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'))) THEN
         P_ANE_INRETC.P_BorraTabla;
         --
         P_ANE_INRETC.P_Costes_Repartidos(NULL, NULL, NULL, NULL,
                                          TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
         --
         P_ANE_INRETC.P_Adiciona_Tabla_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
      END IF;
      --
      IF NOT (P_ANE_INDRCO.F_Obtiene_AM_ALM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'))) THEN
           P_ANE_INDRCO.P_BorraTabla;
           --
         P_ANE_INDRCO.P_Departamento_Comun(vEmpresa,
                                           NULL, NULL, NULL, NULL,
                                           TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'), TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
         --
         P_ANE_INDRCO.P_Adiciona_Tabla_AM(TO_CHAR(dFecha_Cierre,'YYYY'), TO_CHAR(dFecha_Cierre,'MM'));
      END IF;
      --
       FOR rG_TIPOCOST IN cG_TIPOCOST LOOP
         IF rG_TIPOCOST.TIPOCOST_PREI IS NOT NULL THEN
              vCF_TIPOCOST_PREI := rG_TIPOCOST.TIPOCOST_PREI||' '||rG_TIPOCOST.DESCTICO_PREI;
         ELSE
            vCF_TIPOCOST_PREI := rG_TIPOCOST.DESCTICO_PREI;
         END IF;
           --
          FOR rG_SECCAUXI IN cG_SECCAUXI LOOP
             nCF_COSTREPR_PREI := CF_COSTREPR_PREI(rG_SECCAUXI.DEPARTAM_PREI, rG_SECCAUXI.SECCION_PREI, rG_SECCAUXI.SECCAUXI_PREI, 
                                                  rG_TIPOCOST.TIPOCOST_PREI, rG_TIPOCOST.DESCTICO_PREI,
                                                  rG_SECCAUXI.REPAABSO_PREI,
                                                  rG_SECCAUXI.INDUREPR_PREI, rG_SECCAUXI.CALCPRSU_REPR_PREI,
                                                  rG_SECCAUXI.CAVAISDE_PREI,
                                                  rG_SECCAUXI.INDURESE_PREI, rG_SECCAUXI.CALCPRSU_RESE_PREI);
          END LOOP;
       END LOOP;
       ---
      RETURN(nCS_CP_SUM_COSTUNOT);
   END;
--------------------FIN CS_SUM_COSTUNOT-------------------
--------------------GRABADOS------------------------------
   FUNCTION CF_GRABADOS(vEmpresa  FIC_CABEOTRE.EMPRESA%TYPE,  nNumero FIC_CABEOTRE.NUMERO%TYPE, nAnno FIC_CABEOTRE.ANNO%TYPE,
                        dFecha_Cierre DATE) 
   RETURN NUMBER IS
      nCF_INNEPECG NUMBER := 0;
      nCP_INGRVEGR NUMBER := 0;
      nCP_MARGBRCO NUMBER := 0;
      nCP_RESUPREI NUMBER := 0;
      nCP_TotaMinu NUMBER := 0;
      nCF_TOTAHORA NUMBER := 0;
      --
      CURSOR Q_TECNOLOGIA IS
         SELECT O.EMPRESA, O.NUMERO, O.ANNO, DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') TECNOLOGIA
         FROM FIC_CABEOTRE O, HFICTEC HFT, 
         (SELECT LSC.EMPRESA, LSC.NUMETRAB, LSC.TIPO_IMPRE, LSC.FILMAR FROM PRI_LISELCOL LSC
          WHERE (LSC.EMPRESA, LSC.NUMETRAB, LSC.CONTADOR||LSC.POSICION) IN 
               (SELECT LSCM.EMPRESA, LSCM.NUMETRAB, MAX(LSCM.CONTADOR||LSCM.POSICION) FROM PRI_LISELCOL LSCM
                WHERE LSCM.EMPRESA = LSC.EMPRESA 
                  AND LSCM.NUMETRAB = LSC.NUMETRAB
                GROUP BY LSCM.EMPRESA, LSCM.NUMETRAB)) TEC 
         WHERE O.EMPRESA = HFT.EMPRESA
           AND O.TIP_ARTI = HFT.TIP_ARTI
           AND O.COD_ARTI = HFT.PRODUCTO
           AND O.MODI = HFT.MODI
           AND O.REVI = HFT.REVI
           AND HFT.EMPRESA = TEC.EMPRESA
           AND HFT.NUMETRAB = TEC.NUMETRAB
           AND HFT.NUMEPEDI IS NOT NULL 
           AND HFT.REVI = 0
           AND vCP_PEDINUMO IN ('N','M')
           AND O.EMPRESA = vEmpresa
           AND O.NUMERO = nNumero 
           AND O.ANNO = nAnno;
      --
      nCP_INGRINPC NUMBER := 0;--ES SIEMPRE 0
      nCS_NUMEGRRE NUMBER := 0;
      nCS_SUM_COSTUNOT NUMBER := 0;
      nCF_OTCODEPA NUMBER := 0;
      nCS_COTRPREG NUMBER := 0;
      nCS_OTCODEPA NUMBER := 0;
      nCF_COSTPRPR NUMBER := 0;
      --
      CURSOR Q_NUMEGRRE(vTecnologia VARCHAR2) IS
         SELECT 
          DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') TECNOLOGIA,
          COUNT(*) NUMEGRAB
         FROM PRI_TRABAJOS TRA, 
           (SELECT LSC.EMPRESA, LSC.NUMETRAB, LSC.TIPO_IMPRE, LSC.FILMAR FROM PRI_LISELCOL LSC
            WHERE (LSC.EMPRESA, LSC.NUMETRAB, LSC.CONTADOR||LSC.POSICION) IN 
                  (SELECT LSCM.EMPRESA, LSCM.NUMETRAB, MAX(LSCM.CONTADOR||LSCM.POSICION) FROM PRI_LISELCOL LSCM
                   WHERE LSCM.EMPRESA = LSC.EMPRESA 
                     AND LSCM.NUMETRAB = LSC.NUMETRAB
                   GROUP BY LSCM.EMPRESA, LSCM.NUMETRAB)) TEC 
         WHERE TRA.EMPRESA = TEC.EMPRESA
           AND TRA.NUMETRAB = TEC.NUMETRAB
           AND TRA.TIPOTRAB IN ('PRI_FTOK','PRI_PSP')
           AND TRA.EMPRESA = vEmpresa
           AND DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') = vTecnologia
           AND (
                (TRA.TIPOTRAB = 'PRI_FTOK' AND EXISTS (SELECT 'X' FROM HFICTEC HFT, FIC_CABEOTRE O
                                                                                    WHERE O.EMPRESA = HFT.EMPRESA
                                                                                          AND O.TIP_ARTI = HFT.TIP_ARTI
                                                                                          AND O.COD_ARTI = HFT.PRODUCTO
                                                                                          AND O.MODI = HFT.MODI
                                                                                          AND O.REVI = HFT.REVI
                                                                                          AND HFT.EMPRESA = TRA.EMPRESA AND HFT.NUMETRAB = TRA.NUMETRAB AND HFT.NUMEPEDI IS NOT NULL AND HFT.REVI = 0
                                                                                          AND O.EMPRESA = vEmpresa
                                                                                          AND O.NUMERO = nNumero
                                                                                          AND O.ANNO = SUBSTR(nNumero,1,4)
                                                                               AND EXISTS (SELECT F.EMCODI, F.CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F
                                                                                           WHERE F.EMCODI = HFT.EMPRESA
                                                                                             AND F.CPNROP = HFT.NUMEPEDI
                                                                                             AND F.CPNROP IS NOT NULL
                                                                                           GROUP BY F.EMCODI, F.CPNROP
                                                                                           /*--SE INACTIVAN LAS RECLAMACIONES POR AHORA NO SE TRATAN
                                                                                           UNION
                                                                                           SELECT F.EMCODI, R.NUMEPEDI CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F, FV_ASVEFA01 CF, RCL_RECLCLIE R, RCL_ACCIONES A
                                                                                           WHERE F.EMCODI = CF.EMCODI
                                                                                             AND F.DICODI = CF.DICODI
                                                                                             AND F.ASCANA = CF.ASCANA
                                                                                             AND F.CFNROF = CF.CFNROF
                                                                                             AND CF.EMCODI = A.EMPRESA
                                                                                             AND CF.CFNDEF = A.NUMEFACT
                                                                                             AND A.EMPRESA = R.EMPRESA
                                                                                             AND A.NUMERCL = R.NUMERCL
                                                                                             AND A.ANNO = R.ANNO
                                                                                             AND R.EMPRESA = HFT.EMPRESA
                                                                                             AND R.NUMEPEDI = HFT.NUMEPEDI
                                                                                             AND A.NUMEFACT IS NOT NULL
                                                                                             AND A.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                             AND A.TIPOACCI = P_UTILIDAD.F_VALODEVA('TIACABCA')
                                                                                             AND R.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                             AND R.NUMEPEDI IS NOT NULL
                                                                                             AND F.CPNROP IS NULL
                                                                                           GROUP BY F.EMCODI, R.NUMEPEDI
                                                                                           --SE INACTIVAN LAS RECLAMACIONES POR AHORA NO SE TRATAN*/
                                                                                          )
                                                )
                )OR
                (TRA.TIPOTRAB = 'PRI_PSP' AND EXISTS (SELECT 'X' FROM PRI_PSP PSP WHERE PSP.EMPRESA = TRA.EMPRESA AND PSP.NUMETRAB = TRA.NUMETRAB
                                                                              AND EXISTS (SELECT 'X' FROM HFICTEC HFT, FIC_CABEOTRE O
                                                                                          WHERE O.EMPRESA = HFT.EMPRESA
                                                                                                AND O.TIP_ARTI = HFT.TIP_ARTI
                                                                                                AND O.COD_ARTI = HFT.PRODUCTO
                                                                                                AND O.MODI = HFT.MODI
                                                                                                AND O.REVI = HFT.REVI
                                                                                                AND HFT.EMPRESA = PSP.EMPRESA AND HFT.NUMEPSP = PSP.NUMEPSP AND HFT.ANNOPSP = PSP.ANNOPSP AND HFT.NUMEPEDI IS NOT NULL AND HFT.REVI = 0
                                                                                                AND O.EMPRESA = vEmpresa
                                                                                                AND O.NUMERO = nNumero
                                                                                                AND O.ANNO = SUBSTR(nNumero,1,4)
                                                                                            AND EXISTS (SELECT F.EMCODI, F.CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F
                                                                                                        WHERE F.EMCODI = HFT.EMPRESA
                                                                                                          AND F.CPNROP = HFT.NUMEPEDI
                                                                                                          AND F.CPNROP IS NOT NULL
                                                                                                        GROUP BY F.EMCODI, F.CPNROP
                                                                                                        /*--SE INACTIVAN LAS RECLAMACIONES POR AHORA NO SE TRATAN
                                                                                                        UNION
                                                                                                        SELECT F.EMCODI, R.NUMEPEDI CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F, FV_ASVEFA01 CF, RCL_RECLCLIE R, RCL_ACCIONES A
                                                                                                         WHERE F.EMCODI = CF.EMCODI
                                                                                                           AND F.DICODI = CF.DICODI
                                                                                                           AND F.ASCANA = CF.ASCANA
                                                                                                           AND F.CFNROF = CF.CFNROF
                                                                                                           AND CF.EMCODI = A.EMPRESA
                                                                                                           AND CF.CFNDEF = A.NUMEFACT
                                                                                                           AND A.EMPRESA = R.EMPRESA
                                                                                                           AND A.NUMERCL = R.NUMERCL
                                                                                                           AND A.ANNO = R.ANNO
                                                                                                           AND R.EMPRESA = HFT.EMPRESA
                                                                                                           AND R.NUMEPEDI = HFT.NUMEPEDI
                                                                                                           AND A.NUMEFACT IS NOT NULL
                                                                                                           AND A.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                                           AND A.TIPOACCI = P_UTILIDAD.F_VALODEVA('TIACABCA')
                                                                                                           AND R.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                                           AND R.NUMEPEDI IS NOT NULL
                                                                                                           AND F.CPNROP IS NULL
                                                                                                         GROUP BY F.EMCODI, R.NUMEPEDI
                                                                                                        --SE INACTIVAN LAS RECLAMACIONES POR AHORA NO SE TRATAN*/
                                                                                          )
                                                                                         )
                                               )
                )
               )
         GROUP BY 
            DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO');
   
      --
      nCS_INGRPECP NUMBER := 0;
      --
      CURSOR Q_INGRPECP(vTecnologia VARCHAR2) IS
         SELECT 
                  DECODE(DT.TIPO_IMPRE, 'FLEXO', DECODE(DT.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') TECNOLOGIA,
                  SUM(F.LFIMPO) IMPORTE
         FROM FV_ASVEFA02 F,
              (SELECT DISTINCT HFT.EMPRESA, HFT.NUMEPEDI, TEC.TIPO_IMPRE, TEC.FILMAR
              FROM HFICTEC HFT, FIC_CABEOTRE O,
                   (SELECT LSC.EMPRESA, LSC.NUMETRAB, LSC.TIPO_IMPRE, LSC.FILMAR FROM PRI_LISELCOL LSC
                    WHERE (LSC.EMPRESA, LSC.NUMETRAB, LSC.CONTADOR||LSC.POSICION) IN 
                          (SELECT LSCM.EMPRESA, LSCM.NUMETRAB, MAX(LSCM.CONTADOR||LSCM.POSICION) FROM PRI_LISELCOL LSCM
                           WHERE LSCM.EMPRESA = LSC.EMPRESA 
                             AND LSCM.NUMETRAB = LSC.NUMETRAB
                           GROUP BY LSCM.EMPRESA, LSCM.NUMETRAB)) TEC 
              WHERE HFT.EMPRESA = TEC.EMPRESA
                AND HFT.NUMETRAB = TEC.NUMETRAB
                AND O.EMPRESA = HFT.EMPRESA
                AND O.TIP_ARTI = HFT.TIP_ARTI
                AND O.COD_ARTI = HFT.PRODUCTO
                AND O.MODI = HFT.MODI
                AND O.REVI = HFT.REVI
                AND HFT.NUMEPEDI IS NOT NULL
                AND O.EMPRESA = vEmpresa
                AND O.NUMERO = nNumero
                AND O.ANNO = SUBSTR(nNumero,1,4)
             ) DT
        WHERE F.EMCODI = DT.EMPRESA
          AND F.CPNROP = DT.NUMEPEDI
          AND F.VATCOD = P_UTILIDAD.F_VALODEVA('TIARGCF4')
          AND F.EMCODI =vEmpresa
          AND F.PPTIPO NOT IN ('A','X')
          AND F.CPNROP IS NOT NULL
          AND EXISTS (SELECT 'X' FROM FV_ASVEPEH02 LP WHERE LP.EMCODI = F.EMCODI AND LP.CPNROP = F.CPNROP AND LP.LPLINP = F.LPLINP AND LP.VATCOD = F.VATCOD AND LP.ARCARF = F.ARCARF)
          AND DECODE(DT.TIPO_IMPRE, 'FLEXO', DECODE(DT.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') = vTecnologia
        GROUP BY 
                 DECODE(DT.TIPO_IMPRE, 'FLEXO', DECODE(DT.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO');
      --
      nCS_ABONPEGR NUMBER := 0;
      --
      CURSOR Q_ABONPEGR(vTecnologia VARCHAR2) IS
         SELECT ' ' TECNOLOGIA, 0 IMPORTE FROM DUAL;
         /*--SE INACTIVA POR AHORA LOS ABONOS, POR AHORA NO SE TRATAN
         SELECT 
                  DECODE(RCL.TIPO_IMPRE, 'FLEXO', DECODE(RCL.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') TECNOLOGIA,
                  SUM(F.LFIMPO) IMPORTE
         FROM FV_ASVEFA02 F, FV_ASVEFA01 CF,
              (SELECT DISTINCT R.EMPRESA, A.NUMEABON, TEC.TIPO_IMPRE, TEC.FILMAR
               FROM RCL_RECLCLIE R, RCL_ACCIONES A, HFICTEC HFT, FIC_CABEOTRE O,
                    (SELECT LSC.EMPRESA, LSC.NUMETRAB, LSC.TIPO_IMPRE, LSC.FILMAR FROM PRI_LISELCOL LSC
                     WHERE (LSC.EMPRESA, LSC.NUMETRAB, LSC.CONTADOR||LSC.POSICION) IN 
                           (SELECT LSCM.EMPRESA, LSCM.NUMETRAB, MAX(LSCM.CONTADOR||LSCM.POSICION) FROM PRI_LISELCOL LSCM
                            WHERE LSCM.EMPRESA = LSC.EMPRESA 
                              AND LSCM.NUMETRAB = LSC.NUMETRAB
                            GROUP BY LSCM.EMPRESA, LSCM.NUMETRAB)) TEC 
               WHERE A.EMPRESA = R.EMPRESA
                 AND A.NUMERCL = R.NUMERCL
                 AND A.ANNO = R.ANNO
                 AND HFT.EMPRESA = R.EMPRESA
                 AND HFT.NUMEPEDI = R.NUMEPEDI
                 AND HFT.EMPRESA = TEC.EMPRESA
                 AND HFT.NUMETRAB = TEC.NUMETRAB
                 AND O.EMPRESA = HFT.EMPRESA
                 AND O.TIP_ARTI = HFT.TIP_ARTI
                 AND O.COD_ARTI = HFT.PRODUCTO
                 AND O.MODI = HFT.MODI
                 AND O.REVI = HFT.REVI
                 AND A.NUMEABON IS NOT NULL
                 AND R.NUMEPEDI IS NOT NULL
                 AND HFT.NUMEPEDI IS NOT NULL
                 AND A.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                 AND A.TIPOACCI = P_UTILIDAD.F_VALODEVA('TIACABCA')
                 AND R.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                 AND O.EMPRESA = vEmpresa
                 AND O.NUMERO = nNumero
                 AND O.ANNO = SUBSTR(nNumero,1,4)
           ) RCL
         WHERE F.EMCODI = CF.EMCODI
           AND F.DICODI = CF.DICODI
           AND F.ASCANA = CF.ASCANA
           AND F.CFNROF = CF.CFNROF
           AND CF.EMCODI = RCL.EMPRESA
           AND CF.CFNDEF = RCL.NUMEABON
           AND F.VATCOD = P_UTILIDAD.F_VALODEVA('TIARGCF4')
           AND F.EMCODI = vEmpresa
           AND F.PPTIPO IN ('A','X')
         GROUP BY 
                       DECODE(RCL.TIPO_IMPRE, 'FLEXO', DECODE(RCL.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO')
         --SE INACTIVA POR AHORA LOS ABONOS, POR AHORA NO SE TRATAN*/
      --
      nCS_COCOEXPN NUMBER := 0;
      --
      CURSOR Q_COCOEXPN(vTecnologia VARCHAR2) IS
         SELECT P_UTILIDAD.F_VALOCAMPO(LV.VALOR,'COSTE_AGRUPADO') CONCEPTO, P_UTILIDAD.F_VALOCAMPO(LV.VALOR,'ORDEN') ORDEN, 
          DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') TECNOLOGIA,
          SUM(LPC.PEDIITLI) IMPORTE
         FROM PRI_CABEPECO CPC, PRI_LINEPECO LPC, PRI_TRABAJOS TRA, VALORES_LISTA LV,
        (SELECT LSC.EMPRESA, LSC.NUMETRAB, LSC.TIPO_IMPRE, LSC.FILMAR FROM PRI_LISELCOL LSC
         WHERE (LSC.EMPRESA, LSC.NUMETRAB, LSC.CONTADOR||LSC.POSICION) IN 
               (SELECT LSCM.EMPRESA, LSCM.NUMETRAB, MAX(LSCM.CONTADOR||LSCM.POSICION) FROM PRI_LISELCOL LSCM
                WHERE LSCM.EMPRESA = LSC.EMPRESA 
                  AND LSCM.NUMETRAB = LSC.NUMETRAB
                GROUP BY LSCM.EMPRESA, LSCM.NUMETRAB)) TEC 
         WHERE CPC.EMPRESA = LPC.EMPRESA
         AND CPC.NUMETRAB = LPC.NUMETRAB
         AND CPC.NUMEPEDI = LPC.NUMEPEDI
         AND LPC.EMPRESA = TRA.EMPRESA
         AND LPC.NUMETRAB = TRA.NUMETRAB
         AND LPC.EMPRESA = TEC.EMPRESA
         AND LPC.NUMETRAB = TEC.NUMETRAB
         AND LPC.MARCBORR = 'N'
         AND CPC.MARCBORR = 'N'
         AND LV.CODIGO = 'ANE_COCOEXGR'
         AND P_UTILIDAD.F_VALOCAMPO(LV.VALOR,'CONCEPTO') = LPC.PRODCOMP
         AND TRA.TIPOTRAB IN ('PRI_FTOK','PRI_PSP')
         AND TRA.EMPRESA = vEmpresa
         AND DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') = vTecnologia
         AND (
          (TRA.TIPOTRAB = 'PRI_FTOK' AND EXISTS (SELECT 'X' FROM HFICTEC HFT, FIC_CABEOTRE O
                                                                                    WHERE O.EMPRESA = HFT.EMPRESA
                                                                                          AND O.TIP_ARTI = HFT.TIP_ARTI
                                                                                          AND O.COD_ARTI = HFT.PRODUCTO
                                                                                          AND O.MODI = HFT.MODI
                                                                                          AND O.REVI = HFT.REVI
                                                                                          AND HFT.EMPRESA = TRA.EMPRESA AND HFT.NUMETRAB = TRA.NUMETRAB AND HFT.NUMEPEDI IS NOT NULL
                                                                                          AND O.EMPRESA = vEmpresa
                                                                                          AND O.NUMERO = nNumero
                                                                                          AND O.ANNO = SUBSTR(nNumero,1,4)
                                                                                          AND EXISTS (SELECT F.EMCODI, F.CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F
                                                                                           WHERE F.EMCODI = HFT.EMPRESA
                                                                                                 AND F.CPNROP = HFT.NUMEPEDI
                                                                                                 AND F.CPNROP IS NOT NULL
                                                                                           GROUP BY F.EMCODI, F.CPNROP
                                                                                           /*--SE INACTIVAN LAS RECLAMACIONES, POR AHORA NO SE TRATAN
                                                                                           UNION
                                                                                           SELECT F.EMCODI, R.NUMEPEDI CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F, FV_ASVEFA01 CF, RCL_RECLCLIE R, RCL_ACCIONES A
                                                                                           WHERE F.EMCODI = CF.EMCODI
                                                                                                 AND F.DICODI = CF.DICODI
                                                                                                 AND F.ASCANA = CF.ASCANA
                                                                                                 AND F.CFNROF = CF.CFNROF
                                                                                                 AND CF.EMCODI = A.EMPRESA
                                                                                                 AND CF.CFNDEF = A.NUMEFACT
                                                                                                 AND A.EMPRESA = R.EMPRESA
                                                                                                 AND A.NUMERCL = R.NUMERCL
                                                                                                 AND A.ANNO = R.ANNO
                                                                                                 AND R.EMPRESA = HFT.EMPRESA
                                                                                                 AND R.NUMEPEDI = HFT.NUMEPEDI
                                                                                                 AND A.NUMEFACT IS NOT NULL
                                                                                                 AND A.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                                 AND A.TIPOACCI = P_UTILIDAD.F_VALODEVA('TIACABCA')
                                                                                                 AND R.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                                 AND R.NUMEPEDI IS NOT NULL
                                                                                                 AND F.CPNROP IS NULL
                                                                                           GROUP BY F.EMCODI, R.NUMEPEDI
                                                                                           --SE INACTIVAN LAS RECLAMACIONES, POR AHORA NO SE TRATAN*/
                                                                                          )
                                                )
          )OR
          (TRA.TIPOTRAB = 'PRI_PSP' AND EXISTS (SELECT 'X' FROM PRI_PSP PSP WHERE PSP.EMPRESA = TRA.EMPRESA AND PSP.NUMETRAB = TRA.NUMETRAB
                                                                              AND EXISTS (SELECT 'X' FROM HFICTEC HFT, FIC_CABEOTRE O
                                                                                      WHERE O.EMPRESA = HFT.EMPRESA
                                                                                            AND O.TIP_ARTI = HFT.TIP_ARTI
                                                                                            AND O.COD_ARTI = HFT.PRODUCTO
                                                                                            AND O.MODI = HFT.MODI
                                                                                            AND O.REVI = HFT.REVI
                                                                                            AND HFT.EMPRESA = PSP.EMPRESA AND HFT.NUMEPSP = PSP.NUMEPSP AND HFT.ANNOPSP = PSP.ANNOPSP AND HFT.NUMEPEDI IS NOT NULL
                                                                                            AND O.EMPRESA = vEmpresa
                                                                                            AND O.NUMERO = nNumero
                                                                                            AND O.ANNO = SUBSTR(nNumero,1,4)
                                                                                            AND EXISTS (SELECT F.EMCODI, F.CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F
                                                                                                        WHERE F.EMCODI = HFT.EMPRESA
                                                                                                              AND F.CPNROP = HFT.NUMEPEDI
                                                                                                              AND F.CPNROP IS NOT NULL
                                                                                                        GROUP BY F.EMCODI, F.CPNROP
                                                                                                        /*--SE INACTIVAN LAS RECLAMACIONES, POR AHORA NO SE TRATAN
                                                                                                        UNION
                                                                                                        SELECT F.EMCODI, R.NUMEPEDI CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F, FV_ASVEFA01 CF, RCL_RECLCLIE R, RCL_ACCIONES A
                                                                                                         WHERE F.EMCODI = CF.EMCODI
                                                                                                               AND F.DICODI = CF.DICODI
                                                                                                               AND F.ASCANA = CF.ASCANA
                                                                                                               AND F.CFNROF = CF.CFNROF
                                                                                                               AND CF.EMCODI = A.EMPRESA
                                                                                                               AND CF.CFNDEF = A.NUMEFACT
                                                                                                               AND A.EMPRESA = R.EMPRESA
                                                                                                               AND A.NUMERCL = R.NUMERCL
                                                                                                               AND A.ANNO = R.ANNO
                                                                                                               AND R.EMPRESA = HFT.EMPRESA
                                                                                                               AND R.NUMEPEDI = HFT.NUMEPEDI
                                                                                                               AND A.NUMEFACT IS NOT NULL
                                                                                                               AND A.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                                               AND A.TIPOACCI = P_UTILIDAD.F_VALODEVA('TIACABCA')
                                                                                                               AND R.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                                               AND R.NUMEPEDI IS NOT NULL
                                                                                                               AND F.CPNROP IS NULL
                                                                                                         GROUP BY F.EMCODI, R.NUMEPEDI
                                                                                                        --SE INACTIVAN LAS RECLAMACIONES, POR AHORA NO SE TRATAN*/
                                                                                          )
                                                                                         )
                                               )
          )
         )
         GROUP BY P_UTILIDAD.F_VALOCAMPO(LV.VALOR,'COSTE_AGRUPADO'), P_UTILIDAD.F_VALOCAMPO(LV.VALOR,'ORDEN'),
                  DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO')
         ORDER BY P_UTILIDAD.F_VALOCAMPO(LV.VALOR,'ORDEN'), P_UTILIDAD.F_VALOCAMPO(LV.VALOR,'COSTE_AGRUPADO');
      --
      nCS_MINUPROD NUMBER := 0;
      --
      CURSOR Q_HORAPROD(vTecnologia VARCHAR2) IS
         SELECT 
          DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') TECNOLOGIA,
          SUM(TIE.MINUTOS) MINUPROD
         FROM (SELECT EMPRESA, TIPOTRAB, NUMETRAB, SUM(MINUTOS) MINUTOS FROM
        (SELECT TR.EMPRESA, TR.TIPOTRAB, TR.NUMETRAB, SUM(((TO_NUMBER(TO_CHAR(PA.HORAFINA,'HH24')) * 60) + TO_NUMBER(TO_CHAR(PA.HORAFINA,'MI'))) - ((TO_NUMBER(TO_CHAR(PA.HORAINIC,'HH24')) * 60) + TO_NUMBER(TO_CHAR(PA.HORAINIC,'MI')))) MINUTOS
         FROM PRI_TAREAS TA, PRI_PARTTRAB PA, PRI_TRABAJOS TR, ANE_USDEEMPR UD  
         WHERE TA.EMPRESA = TR.EMPRESA 
           AND TA.NUMETRAB = TR.NUMETRAB 
           AND TA.EMPRESA = PA.EMPRESA 
           AND TA.NUMETRAB = PA.NUMETRAB 
           AND TA.CONTADOR = PA.CONTADOR
           AND TA.TECNRESP = UD.USUARIO
           AND UD.EMPRESA = vEmpresa
           AND TA.EMPRESA = vEmpresa
           AND TA.TECNRESP = P_UTILIDAD.F_VALODEVA('GESTPREIM')
           AND TR.TIPOTRAB IN ('PRI_FTOK','PRI_PSP')
         GROUP BY TR.EMPRESA, TR.TIPOTRAB, TR.NUMETRAB
         UNION ALL
         SELECT TR.EMPRESA, TR.TIPOTRAB, TR.NUMETRAB, SUM(((TO_NUMBER(TO_CHAR(PA.HORAFINA,'HH24')) * 60) + TO_NUMBER(TO_CHAR(PA.HORAFINA,'MI'))) - ((TO_NUMBER(TO_CHAR(PA.HORAINIC,'HH24')) * 60) + TO_NUMBER(TO_CHAR(PA.HORAINIC,'MI')))) MINUTOS
         FROM PRI_TAREAS TA, PRI_PARTTRAB PA, PRI_TRABAJOS TR, ANE_USDEEMPR UD  
         WHERE TA.EMPRESA = TR.EMPRESA 
           AND TA.NUMETRAB = TR.NUMETRAB 
           AND TA.EMPRESA = PA.EMPRESA 
           AND TA.NUMETRAB = PA.NUMETRAB 
           AND TA.CONTADOR = PA.CONTADOR
           AND TA.TECNRESP = UD.USUARIO
           AND UD.EMPRESA = vEmpresa
           AND TA.EMPRESA = vEmpresa
           AND TA.TECNRESP != P_UTILIDAD.F_VALODEVA('GESTPREIM')
           AND TR.TIPOTRAB IN ('PRI_FTOK','PRI_PSP')
         GROUP BY TR.EMPRESA, TR.TIPOTRAB, TR.NUMETRAB)
         GROUP BY EMPRESA, TIPOTRAB, NUMETRAB
        )TIE, 
        (SELECT LSC.EMPRESA, LSC.NUMETRAB, LSC.TIPO_IMPRE, LSC.FILMAR FROM PRI_LISELCOL LSC
         WHERE (LSC.EMPRESA, LSC.NUMETRAB, LSC.CONTADOR||LSC.POSICION) IN 
               (SELECT LSCM.EMPRESA, LSCM.NUMETRAB, MAX(LSCM.CONTADOR||LSCM.POSICION) FROM PRI_LISELCOL LSCM
                WHERE LSCM.EMPRESA = LSC.EMPRESA 
                  AND LSCM.NUMETRAB = LSC.NUMETRAB
                GROUP BY LSCM.EMPRESA, LSCM.NUMETRAB)) TEC 
         WHERE TIE.EMPRESA = TEC.EMPRESA
           AND TIE.NUMETRAB = TEC.NUMETRAB
           AND DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') = vTecnologia
           AND (
          (TIE.TIPOTRAB = 'PRI_FTOK' AND EXISTS (SELECT 'X' FROM HFICTEC HFT, FIC_CABEOTRE O
                                                                                    WHERE O.EMPRESA = HFT.EMPRESA
                                                                                          AND O.TIP_ARTI = HFT.TIP_ARTI
                                                                                          AND O.COD_ARTI = HFT.PRODUCTO
                                                                                          AND O.MODI = HFT.MODI
                                                                                          AND O.REVI = HFT.REVI
                                                                                          AND HFT.EMPRESA = TIE.EMPRESA AND HFT.NUMETRAB = TIE.NUMETRAB AND HFT.NUMEPEDI IS NOT NULL
                                                                                          AND O.EMPRESA = vEmpresa
                                                                                          AND O.NUMERO = nNumero
                                                                                          AND O.ANNO = SUBSTR(nNumero,1,4)
                                                                         AND EXISTS (SELECT F.EMCODI, F.CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F
                                                                                     WHERE F.EMCODI = HFT.EMPRESA
                                                                                       AND F.DICODI = '01'
                                                                                       AND F.ASCANA = 1
                                                                                       AND F.CPNROP = HFT.NUMEPEDI
                                                                                       AND F.CPNROP IS NOT NULL
                                                                                     GROUP BY F.EMCODI, F.CPNROP
                                                                                     /*--SE INACTIVAN LAS RECLAMACIONES, POR AHORA NO SE TRATAN
                                                                                     UNION
                                                                                     SELECT F.EMCODI, R.NUMEPEDI CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F, FV_ASVEFA01 CF, RCL_RECLCLIE R, RCL_ACCIONES A
                                                                                     WHERE F.EMCODI = CF.EMCODI
                                                                                       AND F.DICODI = CF.DICODI
                                                                                       AND F.ASCANA = CF.ASCANA
                                                                                       AND F.CFNROF = CF.CFNROF
                                                                                       AND CF.DICODI = '01'
                                                                                       AND CF.ASCANA = 1
                                                                                       --
                                                                                       AND CF.EMCODI = A.EMPRESA
                                                                                       AND CF.CFNDEF = A.NUMEFACT
                                                                                       --
                                                                                       AND A.EMPRESA = R.EMPRESA
                                                                                       AND A.NUMERCL = R.NUMERCL
                                                                                       AND A.ANNO = R.ANNO
                                                                                       --
                                                                                       AND R.EMPRESA = HFT.EMPRESA
                                                                                       AND R.NUMEPEDI = HFT.NUMEPEDI
                                                                                       --
                                                                                       AND A.NUMEFACT IS NOT NULL
                                                                                       AND A.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                       AND A.TIPOACCI = P_UTILIDAD.F_VALODEVA('TIACABCA')
                                                                                       AND R.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                       AND R.NUMEPEDI IS NOT NULL
                                                                                       AND F.CPNROP IS NULL
                                                                                     GROUP BY F.EMCODI, R.NUMEPEDI
                                                                                     --SE INACTIVAN LAS RECLAMACIONES, POR AHORA NO SE TRATAN*/
                                                                                    )
                                          )
                )OR
                (TIE.TIPOTRAB = 'PRI_PSP' AND EXISTS (SELECT 'X' FROM PRI_PSP PSP WHERE PSP.EMPRESA = TIE.EMPRESA AND PSP.NUMETRAB = TIE.NUMETRAB
                                                                        AND EXISTS (SELECT 'X' FROM HFICTEC HFT, FIC_CABEOTRE O
                                                                                    WHERE O.EMPRESA = HFT.EMPRESA
                                                                                          AND O.TIP_ARTI = HFT.TIP_ARTI
                                                                                          AND O.COD_ARTI = HFT.PRODUCTO
                                                                                          AND O.MODI = HFT.MODI
                                                                                          AND O.REVI = HFT.REVI
                                                                                          AND HFT.EMPRESA = PSP.EMPRESA AND HFT.NUMEPSP = PSP.NUMEPSP AND HFT.ANNOPSP = PSP.ANNOPSP AND HFT.NUMEPEDI IS NOT NULL
                                                                                          AND O.EMPRESA = vEmpresa
                                                                                          AND O.NUMERO = nNumero
                                                                                          AND O.ANNO = SUBSTR(nNumero,1,4)
                                                                                          AND EXISTS (SELECT F.EMCODI, F.CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F
                                                                                                  WHERE F.EMCODI = HFT.EMPRESA
                                                                                                    AND F.DICODI = '01'
                                                                                                    AND F.ASCANA = 1
                                                                                                    AND F.CPNROP = HFT.NUMEPEDI
                                                                                                    AND F.CPNROP IS NOT NULL
                                                                                                  GROUP BY F.EMCODI, F.CPNROP
                                                                                                  /*--SE INACTIVAN LAS RECLAMACIONES, POR AHORA NO SE TRATAN
                                                                                                  UNION
                                                                                                  SELECT F.EMCODI, R.NUMEPEDI CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F, FV_ASVEFA01 CF, RCL_RECLCLIE R, RCL_ACCIONES A
                                                                                                   WHERE F.EMCODI = CF.EMCODI
                                                                                                     AND F.DICODI = CF.DICODI
                                                                                                     AND F.ASCANA = CF.ASCANA
                                                                                                     AND F.CFNROF = CF.CFNROF
                                                                                                     AND CF.DICODI = '01'
                                                                                                     AND CF.ASCANA = 1
                                                                                                     --
                                                                                                     AND CF.EMCODI = A.EMPRESA
                                                                                                     AND CF.CFNDEF = A.NUMEFACT
                                                                                                     --
                                                                                                     AND A.EMPRESA = R.EMPRESA
                                                                                                     AND A.NUMERCL = R.NUMERCL
                                                                                                     AND A.ANNO = R.ANNO
                                                                                                     --
                                                                                                     AND R.EMPRESA = HFT.EMPRESA
                                                                                                     AND R.NUMEPEDI = HFT.NUMEPEDI
                                                                                                     --
                                                                                                     AND A.NUMEFACT IS NOT NULL
                                                                                                     AND A.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                                     AND A.TIPOACCI = P_UTILIDAD.F_VALODEVA('TIACABCA')
                                                                                                     AND R.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                                     AND R.NUMEPEDI IS NOT NULL
                                                                                                     AND F.CPNROP IS NULL
                                                                                                   GROUP BY F.EMCODI, R.NUMEPEDI
                                                                                                  --SE INACTIVAN LAS RECLAMACIONES, POR AHORA NO SE TRATAN*/
                                                                                    )
                                                                                   )
                                         )
                )
               )  
         GROUP BY 
            DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO');
      --INICIO Q_COTRPREG
      nCS_COSTDIRE NUMBER := 0;
      nCS_COSTINDI NUMBER := 0;
      nCS_NUMEHORA NUMBER := 0;
      nCF_TOTACOPE NUMBER := 0;
      nCP_COSTHORA NUMBER := 0;
      nCP_IMPORTE NUMBER := 0;
      --
      CURSOR Q_COTRPREG(vTecnologia VARCHAR2) IS
         SELECT TIE.OTRAEMPR,
          DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') TECNOLOGIA,
          SUM(TIE.MINUTOS) MINUPROD
         FROM (SELECT EMPRESA, OTRAEMPR, TIPOTRAB, NUMETRAB, SUM(MINUTOS) MINUTOS FROM
        (SELECT TR.EMPRESA, UD.EMPRESA OTRAEMPR, TR.TIPOTRAB, TR.NUMETRAB, SUM(((TO_NUMBER(TO_CHAR(PA.HORAFINA,'HH24')) * 60) + TO_NUMBER(TO_CHAR(PA.HORAFINA,'MI'))) - ((TO_NUMBER(TO_CHAR(PA.HORAINIC,'HH24')) * 60) + TO_NUMBER(TO_CHAR(PA.HORAINIC,'MI')))) MINUTOS
         FROM PRI_TAREAS TA, PRI_PARTTRAB PA, PRI_TRABAJOS TR, ANE_USDEEMPR UD  
         WHERE TA.EMPRESA = TR.EMPRESA 
           AND TA.NUMETRAB = TR.NUMETRAB 
           AND TA.EMPRESA = PA.EMPRESA 
           AND TA.NUMETRAB = PA.NUMETRAB 
           AND TA.CONTADOR = PA.CONTADOR
           AND TA.TECNRESP = UD.USUARIO
           AND UD.EMPRESA != vEmpresa
           AND TA.EMPRESA = vEmpresa
           AND TA.TECNRESP = P_UTILIDAD.F_VALODEVA('GESTPREIM')
           AND TR.TIPOTRAB IN ('PRI_FTOK','PRI_PSP')
         GROUP BY TR.EMPRESA, UD.EMPRESA, TR.TIPOTRAB, TR.NUMETRAB
         UNION ALL
         SELECT TR.EMPRESA, UD.EMPRESA OTRAEMPR, TR.TIPOTRAB, TR.NUMETRAB, SUM(((TO_NUMBER(TO_CHAR(PA.HORAFINA,'HH24')) * 60) + TO_NUMBER(TO_CHAR(PA.HORAFINA,'MI'))) - ((TO_NUMBER(TO_CHAR(PA.HORAINIC,'HH24')) * 60) + TO_NUMBER(TO_CHAR(PA.HORAINIC,'MI')))) MINUTOS
         FROM PRI_TAREAS TA, PRI_PARTTRAB PA, PRI_TRABAJOS TR, ANE_USDEEMPR UD  
         WHERE TA.EMPRESA = TR.EMPRESA 
           AND TA.NUMETRAB = TR.NUMETRAB 
           AND TA.EMPRESA = PA.EMPRESA 
           AND TA.NUMETRAB = PA.NUMETRAB 
           AND TA.CONTADOR = PA.CONTADOR
           AND TA.TECNRESP = UD.USUARIO
           AND UD.EMPRESA != vEmpresa
           AND TA.EMPRESA = vEmpresa
           AND TA.TECNRESP != P_UTILIDAD.F_VALODEVA('GESTPREIM')
           AND TR.TIPOTRAB IN ('PRI_FTOK','PRI_PSP')
         GROUP BY TR.EMPRESA, UD.EMPRESA, TR.TIPOTRAB, TR.NUMETRAB)
         GROUP BY EMPRESA, OTRAEMPR, TIPOTRAB, NUMETRAB
        )TIE, 
        (SELECT LSC.EMPRESA, LSC.NUMETRAB, LSC.TIPO_IMPRE, LSC.FILMAR FROM PRI_LISELCOL LSC
         WHERE (LSC.EMPRESA, LSC.NUMETRAB, LSC.CONTADOR||LSC.POSICION) IN 
               (SELECT LSCM.EMPRESA, LSCM.NUMETRAB, MAX(LSCM.CONTADOR||LSCM.POSICION) FROM PRI_LISELCOL LSCM
                WHERE LSCM.EMPRESA = LSC.EMPRESA 
                  AND LSCM.NUMETRAB = LSC.NUMETRAB
                GROUP BY LSCM.EMPRESA, LSCM.NUMETRAB)) TEC 
         WHERE TIE.EMPRESA = TEC.EMPRESA
           AND TIE.NUMETRAB = TEC.NUMETRAB
           AND DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO') = vTecnologia
           AND EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = TIE.OTRAEMPR)
           AND (
          (TIE.TIPOTRAB = 'PRI_FTOK' AND EXISTS (SELECT 'X' FROM HFICTEC HFT, FIC_CABEOTRE O
                                                                                    WHERE O.EMPRESA = HFT.EMPRESA
                                                                                          AND O.TIP_ARTI = HFT.TIP_ARTI
                                                                                          AND O.COD_ARTI = HFT.PRODUCTO
                                                                                          AND O.MODI = HFT.MODI
                                                                                          AND O.REVI = HFT.REVI
                                                                                          AND HFT.EMPRESA = TIE.EMPRESA AND HFT.NUMETRAB = TIE.NUMETRAB AND HFT.NUMEPEDI IS NOT NULL
                                                                                          AND O.EMPRESA = vEmpresa
                                                                                          AND O.NUMERO = nNumero
                                                                                          AND O.ANNO = SUBSTR(nNumero,1,4)
                                                                         AND EXISTS (SELECT F.EMCODI, F.CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F
                                                                                     WHERE F.EMCODI = HFT.EMPRESA
                                                                                       AND F.DICODI = '01'
                                                                                       AND F.ASCANA = 1
                                                                                       AND F.CPNROP = HFT.NUMEPEDI
                                                                                       AND F.CPNROP IS NOT NULL
                                                                                     GROUP BY F.EMCODI, F.CPNROP
                                                                                     /*--SE EXCLUYEN LOS ABONOS, POR AHORA NO SE TRATAN
                                                                                     UNION
                                                                                     SELECT F.EMCODI, R.NUMEPEDI CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F, FV_ASVEFA01 CF, RCL_RECLCLIE R, RCL_ACCIONES A
                                                                                     WHERE F.EMCODI = CF.EMCODI
                                                                                       AND F.DICODI = CF.DICODI
                                                                                       AND F.ASCANA = CF.ASCANA
                                                                                       AND F.CFNROF = CF.CFNROF
                                                                                       AND CF.DICODI = '01'
                                                                                       AND CF.ASCANA = 1
                                                                                       --
                                                                                       AND CF.EMCODI = A.EMPRESA
                                                                                       AND CF.CFNDEF = A.NUMEFACT
                                                                                       --
                                                                                       AND A.EMPRESA = R.EMPRESA
                                                                                       AND A.NUMERCL = R.NUMERCL
                                                                                       AND A.ANNO = R.ANNO
                                                                                       --
                                                                                       AND R.EMPRESA = HFT.EMPRESA
                                                                                       AND R.NUMEPEDI = HFT.NUMEPEDI
                                                                                       --
                                                                                       AND A.NUMEFACT IS NOT NULL
                                                                                       AND A.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                       AND A.TIPOACCI = P_UTILIDAD.F_VALODEVA('TIACABCA')
                                                                                       AND R.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                       AND R.NUMEPEDI IS NOT NULL
                                                                                       AND F.CPNROP IS NULL
                                                                                     GROUP BY F.EMCODI, R.NUMEPEDI
                                                                                    --SE EXCLUYEN LOS ABONOS, POR AHORA NO SE TRATAN*/
                                                                                    )
                                          )
                )OR
                (TIE.TIPOTRAB = 'PRI_PSP' AND EXISTS (SELECT 'X' FROM PRI_PSP PSP WHERE PSP.EMPRESA = TIE.EMPRESA AND PSP.NUMETRAB = TIE.NUMETRAB
                                                                        AND EXISTS (SELECT 'X' FROM HFICTEC HFT, FIC_CABEOTRE O
                                                                                    WHERE O.EMPRESA = HFT.EMPRESA
                                                                                          AND O.TIP_ARTI = HFT.TIP_ARTI
                                                                                          AND O.COD_ARTI = HFT.PRODUCTO
                                                                                          AND O.MODI = HFT.MODI
                                                                                          AND O.REVI = HFT.REVI
                                                                                          AND HFT.EMPRESA = PSP.EMPRESA AND HFT.NUMEPSP = PSP.NUMEPSP AND HFT.ANNOPSP = PSP.ANNOPSP AND HFT.NUMEPEDI IS NOT NULL
                                                                                          AND O.EMPRESA = vEmpresa
                                                                                          AND O.NUMERO = nNumero
                                                                                          AND O.ANNO = SUBSTR(nNumero,1,4)
                                                                                          AND EXISTS (SELECT F.EMCODI, F.CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F
                                                                                                  WHERE F.EMCODI = HFT.EMPRESA
                                                                                                    AND F.DICODI = '01'
                                                                                                    AND F.ASCANA = 1
                                                                                                    AND F.CPNROP = HFT.NUMEPEDI
                                                                                                    AND F.CPNROP IS NOT NULL
                                                                                                  GROUP BY F.EMCODI, F.CPNROP
                                                                                                  /*--SE EXCLUYEN LOS ABONOS, POR AHORA NO SE TRATAN
                                                                                                  UNION
                                                                                                  SELECT F.EMCODI, R.NUMEPEDI CPNROP, MIN(TRUNC(F.CFFALT)) FROM FV_ASVEFA02 F, FV_ASVEFA01 CF, RCL_RECLCLIE R, RCL_ACCIONES A
                                                                                                   WHERE F.EMCODI = CF.EMCODI
                                                                                                     AND F.DICODI = CF.DICODI
                                                                                                     AND F.ASCANA = CF.ASCANA
                                                                                                     AND F.CFNROF = CF.CFNROF
                                                                                                     AND CF.DICODI = '01'
                                                                                                     AND CF.ASCANA = 1
                                                                                                     --
                                                                                                     AND CF.EMCODI = A.EMPRESA
                                                                                                     AND CF.CFNDEF = A.NUMEFACT
                                                                                                     --
                                                                                                     AND A.EMPRESA = R.EMPRESA
                                                                                                     AND A.NUMERCL = R.NUMERCL
                                                                                                     AND A.ANNO = R.ANNO
                                                                                                     --
                                                                                                     AND R.EMPRESA = HFT.EMPRESA
                                                                                                     AND R.NUMEPEDI = HFT.NUMEPEDI
                                                                                                     --
                                                                                                     AND A.NUMEFACT IS NOT NULL
                                                                                                     AND A.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                                     AND A.TIPOACCI = P_UTILIDAD.F_VALODEVA('TIACABCA')
                                                                                                     AND R.ESTADO != P_UTILIDAD.F_VALODEVA('RCESTANU')
                                                                                                     AND R.NUMEPEDI IS NOT NULL
                                                                                                     AND F.CPNROP IS NULL
                                                                                                   GROUP BY F.EMCODI, R.NUMEPEDI
                                                                                                  --SE EXCLUYEN LOS ABONOS, POR AHORA NO SE TRATAN*/
                                                                                    )
                                                                                   )
                                         )
                )
               )  
         GROUP BY TIE.OTRAEMPR,
                  DECODE(TEC.TIPO_IMPRE, 'FLEXO', DECODE(TEC.FILMAR,'S','FLEXO/ANALOGICO','FLEXO/DIGITAL'),'HUECO');
      --
      CURSOR Q_ANNOS IS
         SELECT DISTINCT A.ANNO FROM ANE_CODEANNO A
         WHERE EXISTS (SELECT 'X' FROM VALORES_LISTA LVE WHERE LVE.CODIGO = 'GNR_EMPRACGR' AND LVE.VALOR = A.EMPRESA)
           AND A.ANNO = TO_CHAR(dFecha_Cierre,'YYYY')
         ORDER BY A.ANNO;
      --
      CURSOR Q_COSTDIRE(vOtraEmpr ANE_CONFCPDR.EMPRESA%TYPE, vAnno ANE_CONFCPDR.ANNO%TYPE) IS
         SELECT ANNO, SUM(COSTE) COSTE FROM (
         --------------Costes Directos
         SELECT CP.ANNO, SUM(CP.COSTE) COSTE 
         FROM ANE_CONFCPDR CP, GNR_SPDEEMPR SPDE
         WHERE CP.SECCION = SPDE.SECCION
           AND CP.EMPRESA = vOtraEmpr
           AND CP.ANNO = vAnno
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(vAnno||DECODE(CP.MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
          AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(vAnno||DECODE(CP.MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'))
          AND SPDE.DEPARTAM = vP_CODEPREI
         GROUP BY CP.ANNO
         --------------Restos de Costes Directos
         UNION ALL
         SELECT CP.ANNO, SUM(CP.COSTE) COSTE 
         FROM ANE_CONFRCDR CP, GNR_SPDEEMPR SPDE
         WHERE CP.SECCION = SPDE.SECCION
           AND CP.EMPRESA = vOtraEmpr
           AND CP.ANNO = vAnno
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(vAnno||DECODE(CP.MES,'ENERO','01', 
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
                                                                           'DICIEMBRE','12')) 
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(vAnno||DECODE(CP.MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'))
           AND SPDE.DEPARTAM = vP_CODEPREI
         GROUP BY CP.ANNO
         )
         GROUP BY ANNO;
      --
      CURSOR Q_COSTINDI(vOtraEmpr ANE_CONFCPDR.EMPRESA%TYPE, vAnno ANE_CONFCPDR.ANNO%TYPE) IS
         SELECT ANNO, SUM(COSTE) COSTE FROM (
         SELECT PER.ANNO, IND.COSTINDI * PER.NUMEPERS COSTE
         FROM
         (SELECT C.EMPRESA, C.ANNO, SUM(C.COSTE / I.NUMEPERS) COSTINDI 
            FROM PRD_CONFCOIR C, VALORES_LISTA L, PRD_CONFINRE I
         WHERE C.CONCEPTO = P_UTILIDAD.F_VALOCAMPO(L.VALOR,'CONCEPTO')
           AND C.EMPRESA = I.EMPRESA
           AND C.ANNO = I.ANNO
           AND C.MES = I.MES
           AND P_UTILIDAD.F_VALOCAMPO(L.VALOR,'INDUCTOR') = I.INDUCTOR
           AND L.CODIGO = 'PRD_COPRASIN'
           AND I.INDUCTOR != vP_INDUPEUN --PERSONAL UNIFORMADO
           AND NVL(I.NUMEPERS,0) != 0
           AND C.EMPRESA = vOtraEmpr
           AND C.ANNO = vAnno
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(vAnno||DECODE(C.MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(vAnno||DECODE(C.MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12'))
         GROUP BY C.EMPRESA, C.ANNO) IND,
         (SELECT PL.EMPRESA, PL.ANNO, PL.NUMEPERS
          FROM ANE_CONFPMSR PL, GNR_SPDEEMPR SPDE
          WHERE PL.SECCION = SPDE.SECCION
            AND SPDE.DEPARTAM = vP_CODEPREI
            AND PL.EMPRESA = vOtraEmpr
            AND PL.ANNO = vAnno
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(vAnno||DECODE(PL.MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(vAnno||DECODE(PL.MES,'ENERO','01', 
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
                                                                           'DICIEMBRE','12'))) PER
         WHERE PER.EMPRESA = IND.EMPRESA
           AND PER.ANNO = IND.ANNO
         --------------Costes Indirectos Departamentales Inductor igual a Personal Uniformado
         UNION ALL
         SELECT PER.ANNO, IND.COSTINDI * PER.NUMEPEUN COSTE
         FROM
         (SELECT C.EMPRESA, C.ANNO, SUM(C.COSTE / I.NUMEPERS) COSTINDI 
            FROM PRD_CONFCOIR C, VALORES_LISTA L, PRD_CONFINRE I
         WHERE C.CONCEPTO = P_UTILIDAD.F_VALOCAMPO(L.VALOR,'CONCEPTO')
           AND C.EMPRESA = I.EMPRESA
           AND C.ANNO = I.ANNO
           AND C.MES = I.MES
           AND P_UTILIDAD.F_VALOCAMPO(L.VALOR,'INDUCTOR') = I.INDUCTOR
           AND L.CODIGO = 'PRD_COPRASIN'
           AND I.INDUCTOR = vP_INDUPEUN --PERSONAL UNIFORMADO
           AND NVL(I.NUMEPERS,0) != 0
           AND C.EMPRESA = vOtraEmpr
           AND C.ANNO = vAnno
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(vAnno||DECODE(C.MES,'ENERO','01',
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
                                                                           'DICIEMBRE','12')) 
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(vAnno||DECODE(C.MES,'ENERO','01', 
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
                                                                           'DICIEMBRE','12'))
         GROUP BY C.EMPRESA, C.ANNO) IND,
         (SELECT PL.EMPRESA, PL.ANNO, PL.NUMEPEUN
          FROM ANE_CONFPMSR PL, GNR_SPDEEMPR SPDE
          WHERE PL.SECCION = SPDE.SECCION
            AND SPDE.DEPARTAM = vP_CODEPREI
            AND PL.EMPRESA = vOtraEmpr
            AND PL.ANNO = vAnno
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(vAnno||DECODE(PL.MES,'ENERO','01', 
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
                                                                           'DICIEMBRE','12')) 
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(vAnno||DECODE(PL.MES,'ENERO','01', 
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
                                                                           'DICIEMBRE','12'))) PER
         WHERE PER.EMPRESA = IND.EMPRESA
           AND PER.ANNO = IND.ANNO
         )
         GROUP BY ANNO;
      --
      CURSOR Q_NUMEHORA(vOtraEmpr ANE_CONFCPDR.EMPRESA%TYPE) IS
         SELECT SUM(HOREEFCO+UNGRREAL) NUMEHORA FROM ANE_CODEANMS
         WHERE EMPRESA = vOtraEmpr
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) <= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                          'DICIEMBRE','12')) 
           AND TO_NUMBER(TO_CHAR(dFecha_Cierre,'YYYYMM')) >= TO_NUMBER(ANNO||DECODE(MES,'ENERO','01',
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
                                                                          'DICIEMBRE','12'));
      --FIN Q_COTRPREG
   begin
      FOR R_TECNOLOGIA IN Q_TECNOLOGIA LOOP
           nCS_NUMEGRRE := 0;
           nCS_SUM_COSTUNOT := 0;
           nCF_OTCODEPA := 0;
           --
         nCF_COSTPRPR := 0;
          nCP_INGRVEGR := 0;
          nCP_MARGBRCO := 0;
          nCP_RESUPREI := 0;
         nCF_INNEPECG := 0;
         nCP_TotaMinu := 0;
         nCF_TOTAHORA := 0;
           --
           FOR R_NUMEGRRE IN Q_NUMEGRRE(R_TECNOLOGIA.TECNOLOGIA) LOOP
              nCS_NUMEGRRE := nCS_NUMEGRRE + NVL(R_NUMEGRRE.NUMEGRAB,0);
              nCS_SUM_COSTUNOT := CS_SUM_COSTUNOT(vEmpresa, dFecha_Cierre);
              nCF_OTCODEPA := (R_NUMEGRRE.NUMEGRAB * nCS_SUM_COSTUNOT);
              --
              nCS_OTCODEPA := nCS_OTCODEPA + NVL(nCF_OTCODEPA,0); --(SUM)
           END LOOP;
           --
           nCS_INGRPECP := 0;
           --
         FOR R_INGRPECP IN Q_INGRPECP(R_TECNOLOGIA.TECNOLOGIA) LOOP
            nCS_INGRPECP := nCS_INGRPECP + NVL(R_INGRPECP.IMPORTE,0);
         END LOOP;
         --
         nCS_ABONPEGR := 0;
         --
         FOR R_ABONPEGR IN Q_ABONPEGR(R_TECNOLOGIA.TECNOLOGIA) LOOP
            nCS_ABONPEGR := nCS_ABONPEGR + NVL(R_ABONPEGR.IMPORTE,0);
         END LOOP;
         --
         nCS_COCOEXPN := 0;
         --
         FOR R_COCOEXPN IN Q_COCOEXPN(R_TECNOLOGIA.TECNOLOGIA) LOOP
            nCS_COCOEXPN := nCS_COCOEXPN + NVL(R_COCOEXPN.IMPORTE,0);
         END LOOP;
         --
         nCS_MINUPROD := 0;
         --
         FOR R_HORAPROD IN Q_HORAPROD(R_TECNOLOGIA.TECNOLOGIA) LOOP
            nCS_MINUPROD := nCS_MINUPROD + NVL(R_HORAPROD.MINUPROD,0);
         END LOOP;
         --
         nCS_COSTDIRE := 0;
         nCS_COSTINDI := 0; 
         nCS_NUMEHORA := 0;
         nCF_TOTACOPE := 0;
         nCP_COSTHORA := 0;
         nCP_IMPORTE := 0;
         --
         FOR R_COTRPREG IN Q_COTRPREG(R_TECNOLOGIA.TECNOLOGIA) LOOP
            FOR R_ANNOS IN Q_ANNOS LOOP
               FOR R_COSTDIRE IN Q_COSTDIRE(R_COTRPREG.OTRAEMPR, R_ANNOS.ANNO) LOOP
                   nCS_COSTDIRE := nCS_COSTDIRE + NVL(R_COSTDIRE.COSTE,0);
               END LOOP;
               --
               FOR R_COSTINDI IN Q_COSTINDI(R_COTRPREG.OTRAEMPR, R_ANNOS.ANNO) LOOP
                   nCS_COSTINDI := nCS_COSTINDI + NVL(R_COSTINDI.COSTE,0);
               END LOOP;
               --
               FOR R_NUMEHORA IN Q_NUMEHORA(R_COTRPREG.OTRAEMPR) LOOP
                  nCS_NUMEHORA := nCS_NUMEHORA + NVL(R_NUMEHORA.NUMEHORA,0);
               END LOOP;
            END LOOP;
            --
             IF NVL(nCS_NUMEHORA,0) != 0 THEN
                nCP_COSTHORA := (NVL(nCS_COSTDIRE,0) + NVL(nCS_COSTINDI,0)) / nCS_NUMEHORA;
             ELSE
                nCP_COSTHORA := 0;
             END IF;
             --
             nCP_IMPORTE := (R_COTRPREG.MINUPROD / 60) * nCP_COSTHORA;
             --
             nCS_COTRPREG := nCS_COTRPREG + NVL(nCP_IMPORTE,0); --(SUM)
             --
            nCF_TOTACOPE := (NVL(nCS_COSTDIRE,0) + NVL(nCS_COSTINDI,0));
         END LOOP;
         --
         nCF_COSTPRPR := ((nCS_MINUPROD / 60) * nCP_COSTHORA_HORAPROD);
         --
         nCP_INGRVEGR := (nCS_INGRPECP - nCS_ABONPEGR) + nCP_INGRINPC;
         --
         nCP_MARGBRCO := nCP_INGRVEGR - nCS_COCOEXPN;
         --
         nCP_RESUPREI := nCP_MARGBRCO - nCS_COTRPREG - nCS_OTCODEPA - nCF_COSTPRPR;
         --
         nCS_CP_RESUPREI := NVL(nCS_CP_RESUPREI,0) + NVL(nCP_RESUPREI,0); --(SUM)
          --
         nCF_INNEPECG := nCS_INGRPECP - nCS_ABONPEGR;
         --
         nCP_TotaMinu := F_CeroIzqu(TRUNC(nCS_MINUPROD - (TRUNC(nCS_MINUPROD/60) * 60)));
         --
         nCF_TOTAHORA := F_CeroIzqu(TRUNC(nCS_MINUPROD/60));
      END LOOP;
      --
      RETURN NULL;
   end;
--------------------FIN GRABADOS--------------------------
--------------------CF_CALCULOS---------------------------
   FUNCTION CF_CALCULOS 
   RETURN NUMBER IS
   BEGIN
       --Diferencias Unidades Fisicas Consumos
      nCP_DIMLCOKG_CS := NVL(nCS_CP_MALACRKG,0) - NVL(nCS_CP_MALACEKG,0);
      --
      IF NVL(nCS_CP_MALACEKG,0) != 0 THEN
         nCP_DPMLCOKG_CS := (NVL(nCS_CP_MALACRKG,0) - NVL(nCS_CP_MALACEKG,0)) / NVL(nCS_CP_MALACEKG,0);
      ELSE
         nCP_DPMLCOKG_CS := 0;
      END IF;
      --
      nCP_DIMLCOM2_CS := NVL(nCS_CP_MALACRM2,0) - NVL(nCS_CP_MALACEM2,0);
      --
      IF NVL(nCS_CP_MALACEM2,0) != 0 THEN
         nCP_DPMLCOM2_CS := (NVL(nCS_CP_MALACRM2,0) - NVL(nCS_CP_MALACEM2,0)) / NVL(nCS_CP_MALACEM2,0);
      ELSE
         nCP_DPMLCOM2_CS := 0;
      END IF;
      --
      nCP_DIMLCOML_CS := NVL(nCS_CP_MALACRML,0) - NVL(nCS_CP_MALACEML,0);
      --
      IF NVL(nCS_CP_MALACEML,0) != 0 THEN
         nCP_DPMLCOML_CS := (NVL(nCS_CP_MALACRML,0) - NVL(nCS_CP_MALACEML,0)) / NVL(nCS_CP_MALACEML,0);
      ELSE
         nCP_DPMLCOML_CS := 0;
      END IF;
      --Diferencia Consumo Euros
      nCP_DIFECOEU_CS := NVL(nCS_CP_COCOREAL,0) - NVL(nCS_CP_COCOESTA,0);
      --
      IF NVL(nCS_CP_COCOESTA,0) != 0 THEN
         nCP_DIPOCOEU_CS := ((NVL(nCS_CP_COCOREAL,0) - NVL(nCS_CP_COCOESTA,0)) / NVL(nCS_CP_COCOESTA,0)) * 100;
      ELSE               
         nCP_DIPOCOEU_CS := 0;
      END IF;
      --Diferencia Facturado Euros
      nCP_DIFEFAEU_CS := NVL(nCS_CP_COLAREAL,0) - NVL(nCS_CP_COLAESTA,0);
      --
      IF NVL(nCS_CP_COLAESTA,0) != 0 THEN
         nCP_DIPOFAEU_CS := ((NVL(nCS_CP_COLAREAL,0) - NVL(nCS_CP_COLAESTA,0)) / NVL(nCS_CP_COLAESTA,0)) * 100;
      ELSE               
         nCP_DIPOFAEU_CS := 0;
      END IF;
      --Diferencias Unidades Fisicas Mermas Totales
      nCP_DIMLMTKG_CS := NVL(nCS_CP_MALAMRKG,0) - NVL(nCS_CP_MALAMEKG,0);
      --
      IF NVL(nCS_CP_MALAMEKG,0) != 0 THEN
         nCP_DPMLMTKG_CS := (NVL(nCS_CP_MALAMRKG,0) - NVL(nCS_CP_MALAMEKG,0)) / NVL(nCS_CP_MALAMEKG,0);
      ELSE
         nCP_DPMLMTKG_CS := 0;
      END IF;
      --
      nCP_DIMLMTM2_CS := NVL(nCS_CP_MALAMRM2,0) - NVL(nCS_CP_MALAMEM2,0);
      --
      IF NVL(nCS_CP_MALAMEM2,0) != 0 THEN
         nCP_DPMLMTM2_CS := (NVL(nCS_CP_MALAMRM2,0) - NVL(nCS_CP_MALAMEM2,0)) / NVL(nCS_CP_MALAMEM2,0);
      ELSE
         nCP_DPMLMTM2_CS := 0;
      END IF;
      --
      nCP_DIMLMTML_CS := NVL(nCS_CP_MALAMRML,0) - NVL(nCS_CP_MALAMEML,0);
      --
      IF NVL(nCS_CP_MALAMEML,0) != 0 THEN
         nCP_DPMLMTML_CS := (NVL(nCS_CP_MALAMRML,0) - NVL(nCS_CP_MALAMEML,0)) / NVL(nCS_CP_MALAMEML,0);
      ELSE
         nCP_DPMLMTML_CS := 0;
      END IF;
      --Diferencia Merma Total
      nCP_DIFEMTEU_CS := NVL(nCS_CP_COMTREAL,0) - NVL(nCS_CP_COMTESTA,0);
      --
      IF NVL(nCS_CP_COMTESTA,0) != 0 THEN
         nCP_DIPOMTEU_CS := ((NVL(nCS_CP_COMTREAL,0) - NVL(nCS_CP_COMTESTA,0)) / NVL(nCS_CP_COMTESTA,0)) * 100;
      ELSE               
         nCP_DIPOMTEU_CS := 0;
      END IF;
      --Porcentajes de Mermas Estandar
      IF NVL(nCS_CP_MALACEML,0) != 0 THEN
         nCP_POMTESUN_CS := (NVL(nCS_CP_MALAMEML,0) / nCS_CP_MALACEML) * 100;
      ELSE
         nCP_POMTESUN_CS := 0;
      END IF;
      --Porcentajes de Mermas Real
      IF NVL(nCS_CP_MALACRML,0) != 0 THEN
         nCP_POMTREUN_CS := (NVL(nCS_CP_MALAMRML,0) / nCS_CP_MALACRML) * 100;
      ELSE
         nCP_POMTREUN_CS := 0;
      END IF;
      --Diferencias Porcentajes de Mermas
      IF NVL(nCP_DIMLCOML_CS,0) != 0 THEN
         nCP_DPMTESUN_CS := (NVL(nCP_DIMLMTML_CS,0) / nCP_DIMLCOML_CS) * 100;
      ELSE
         nCP_DPMTESUN_CS := 0;
      END IF;
      --Diferencias Porcentajes de Euros
      IF NVL(nCP_DIFECOEU_CS,0) != 0 THEN
         nCP_DIPOMETO_CS := (NVL(nCP_DIFEMTEU_CS,0) / nCP_DIFECOEU_CS) * 100;
      ELSE
         nCP_DIPOMETO_CS := 0;
      END IF;
      --Abonos de la OT
      nCP_DIFEABON_CS := nCS_CP_ABONREAL - NVL(nCS_CP_ABONESTA,0);
      --
      IF NVL(nCS_CP_ABONESTA,0) != 0 THEN
         nCP_DIPOABON_CS := ((nCS_CP_ABONREAL - NVL(nCS_CP_ABONESTA,0)) / NVL(nCS_CP_ABONESTA,0)) * 100;
      ELSE
         nCP_DIPOABON_CS := 0;
      END IF;
      --Ingresos Netos
      nCP_DIFEINNE_CS := nCS_CP_INNEREAL - nCS_CP_INNEESTA;
      --
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_DIPOINNE_CS := ((nCS_CP_INNEREAL - nCS_CP_INNEESTA) / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_DIPOINNE_CS := 0;
      END IF;
      --Consumos de Lamina                             
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POCLESTA_CS := (NVL(nCS_CP_COLAESTA,0) / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POCLESTA_CS := 0;
      END IF;
      --                                  
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POCLREAL_CS := (NVL(nCS_CP_COLAREAL,0) / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POCLREAL_CS := 0;
      END IF;
      --Mermas de Produccion
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POMEPRES_CS := (nCS_CP_COMTESTA / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POMEPRES_CS := 0;
      END IF;
      --
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POMEPRRE_CS := (nCS_CP_COMTREAL / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POMEPRRE_CS := 0;
      END IF;
      --Coste de Mano de Obra de Produccion
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POCMOPES_CS := (NVL(nCS_CF_COSTE_TOTAL_ESTANDAR,0) / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POCMOPES_CS := 0;
      END IF;
      --
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POCMOPRE_CS := (NVL(nCS_CF_COSTE_TOTAL_REAL,0) / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POCMOPRE_CS := 0;
      END IF;
      --
      nCP_DIFECMOP_CS := nCP_POCMOPRE_CS - nCP_POCMOPES_CS;
      --
      IF nCP_POCMOPES_CS != 0 THEN
         nCP_DIPOCMOP_CS := ((nCP_POCMOPRE_CS - nCP_POCMOPES_CS) / nCP_POCMOPES_CS) * 100;
      ELSE
         nCP_DIPOCMOP_CS := 0;
      END IF;
      --Otros costes de Producción
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POOTCPES_CS := (NVL(nCP_SUM_OTROCOST_E,0) / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POOTCPES_CS := 0;
      END IF;
      --
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POOTCPRE_CS := (NVL(nCP_SUM_OTROCOST_R,0) / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POOTCPRE_CS := 0;
      END IF;
      --
      nCP_DIFEOTCP_CS := NVL(nCP_SUM_OTROCOST_R,0) - NVL(nCP_SUM_OTROCOST_E,0);
      --
      IF NVL(nCP_SUM_OTROCOST_E,0) != 0 THEN
         nCP_DIPOOTCP_CS := (nCP_DIFEOTCP_CS / NVL(nCP_SUM_OTROCOST_E,0)) *100;
      ELSE
         nCP_DIPOOTCP_CS := 0;
      END IF;
      --Calidad
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POCALIES_CS := (NVL(nCP_SUM_CALIDAD_E,0) / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POCALIES_CS := 0;
      END IF;
      --
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POCALIRE_CS := (NVL(nCP_SUM_CALIDAD_R,0) / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POCALIRE_CS := 0;
      END IF;
      --
      nCP_DIFECALI_CS := NVL(nCP_SUM_CALIDAD_R,0) - NVL(nCP_SUM_CALIDAD_E,0);
      --
      IF NVL(nCP_SUM_CALIDAD_E,0) != 0 THEN 
         nCP_DIPOCALI_CS := (nCP_DIFECALI_CS / NVL(nCP_SUM_CALIDAD_E,0)) * 100;
      ELSE
         nCP_DIPOCALI_CS := 0;
      END IF;
      --Logistica Interna
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POLOINES_CS := (NVL(nCP_SUM_LOGIINTE_E,0) / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POLOINES_CS := 0;
      END IF;
      --
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POLOINRE_CS := (NVL(nCP_SUM_LOGIINTE_R,0) / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POLOINRE_CS := 0;
      END IF;
      --
      nCP_DIFELOIN_CS := NVL(nCP_SUM_LOGIINTE_R,0) - NVL(nCP_SUM_LOGIINTE_E,0);
      --
      IF NVL(nCP_SUM_LOGIINTE_E,0) != 0 THEN 
         nCP_DIPOLOIN_CS := (nCP_DIFELOIN_CS / NVL(nCP_SUM_LOGIINTE_E,0)) * 100;
      ELSE
         nCP_DIPOLOIN_CS := 0;
      END IF;
      --Almacen
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POALMAES_CS := (NVL(nCP_SUM_ALMACEN_E,0) / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POALMAES_CS := 0;
      END IF;
      --
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POALMARE_CS := (NVL(nCP_SUM_ALMACEN_R,0) / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POALMARE_CS := 0;
      END IF;
      --
      nCP_DIFEALMA_CS := NVL(nCP_SUM_ALMACEN_R,0) - NVL(nCP_SUM_ALMACEN_E,0);
      --
      IF NVL(nCP_SUM_ALMACEN_E,0) != 0 THEN 
         nCP_DIPOALMA_CS := (nCP_DIFEALMA_CS / NVL(nCP_SUM_ALMACEN_E,0)) * 100;
      ELSE
         nCP_DIPOALMA_CS := 0;
      END IF;
      --Total Costes Soporte Produccion
      nCP_TOCOSPES_CS := NVL(nCP_SUM_CALIDAD_E,0) + NVL(nCP_SUM_LOGIINTE_E,0) + NVL(nCP_SUM_ALMACEN_E,0);
      --
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POTCSPES_CS := (nCP_TOCOSPES_CS / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POTCSPES_CS := 0;
      END IF;
      --
      nCP_TOCOSPRE_CS := NVL(nCP_SUM_CALIDAD_R,0) + NVL(nCP_SUM_LOGIINTE_R,0) + NVL(nCP_SUM_ALMACEN_R,0);
      --
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POTCSPRE_CS := (nCP_TOCOSPRE_CS / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POTCSPRE_CS := 0;
      END IF;
      --
      nCP_DIFETCSP_CS := nCP_TOCOSPRE_CS - nCP_TOCOSPES_CS;
      --
      IF nCP_TOCOSPES_CS != 0 THEN
         nCP_DIPOTCSP_CS := (nCP_DIFETCSP_CS / nCP_TOCOSPES_CS) * 100;
      ELSE
         nCP_DIPOTCSP_CS := 0;
      END IF;
      --Costes de Comercializacion
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POCOCOES_CS := (NVL(nCP_SUM_COSTCOME_E,0) / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POCOCOES_CS := 0;
      END IF;
      --
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POCOCORE_CS := (NVL(nCP_SUM_COSTCOME_R,0) / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POCOCORE_CS := 0;
      END IF;
      --
      nCP_DIFECOCO_CS := NVL(nCP_SUM_COSTCOME_R,0) - NVL(nCP_SUM_COSTCOME_E,0);
      --
      IF NVL(nCP_SUM_COSTCOME_E,0) != 0 THEN 
         nCP_DIPOCOCO_CS := (nCP_DIFECOCO_CS / NVL(nCP_SUM_COSTCOME_E,0)) * 100;
      ELSE
         nCP_DIPOCOCO_CS := 0;
      END IF;
      --Costes de Distribucion
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POCODIES_CS := (NVL(nCP_SUM_COSTDIST_E,0) / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POCODIES_CS := 0;
      END IF;
      --
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POCODIRE_CS := (NVL(nCP_SUM_COSTDIST_R,0) / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POCODIRE_CS := 0;
      END IF;
      --
      nCP_DIFECODI_CS := NVL(nCP_SUM_COSTDIST_R,0) - NVL(nCP_SUM_COSTDIST_E,0);
      --
      IF NVL(nCP_SUM_COSTDIST_E,0) != 0 THEN 
         nCP_DIPOCODI_CS := (nCP_DIFECODI_CS / NVL(nCP_SUM_COSTDIST_E,0)) * 100;
      ELSE
         nCP_DIPOCODI_CS := 0;
      END IF;
      --Costes Administrativos
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POCOADES_CS := (NVL(nCP_SUM_COSTADMI_E,0) / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POCOADES_CS := 0;
      END IF;
      --
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POCOADRE_CS := (NVL(nCP_SUM_COSTADMI_R,0) / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POCOADRE_CS := 0;
      END IF;
      --
      nCP_DIFECOAD_CS := NVL(nCP_SUM_COSTADMI_R,0) - NVL(nCP_SUM_COSTADMI_E,0);
      --
      IF NVL(nCP_SUM_COSTADMI_E,0) != 0 THEN 
         nCP_DIPOCOAD_CS := (nCP_DIFECOAD_CS / NVL(nCP_SUM_COSTADMI_E,0)) * 100;
      ELSE
         nCP_DIPOCOAD_CS := 0;
      END IF;
      --Costes Financieros Calculo de % y Diferencias
      IF nCS_CP_INNEESTA != 0 THEN
         nCP_POCOFIES_CS := (NVL(nCS_CP_COFIESTA,0) / nCS_CP_INNEESTA) * 100;
      ELSE
         nCP_POCOFIES_CS := 0;
      END IF;
      --
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POCOFIRE_CS := (NVL(nCS_CP_COFIREAL,0) / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POCOFIRE_CS := 0;
      END IF;
      --
      nCP_DIFECOFI_CS := NVL(nCS_CP_COFIREAL,0) - NVL(nCS_CP_COFIESTA,0);
      --
      IF NVL(nCS_CP_COFIESTA,0) != 0 THEN 
         nCP_DIPOCOFI_CS := (nCP_DIFECOFI_CS / NVL(nCS_CP_COFIESTA,0)) * 100;
      ELSE
         nCP_DIPOCOFI_CS := 0;
      END IF;   	                  
      --Margen de los Grabados
      IF nCS_CP_INNEREAL != 0 THEN
         nCP_POMAGRRE_CS := (NVL(nCS_CP_RESUPREI,0) / nCS_CP_INNEREAL) * 100;
      ELSE
         nCP_POMAGRRE_CS := 0;
      END IF;
      --
      nCP_DIFEMAGR_CS := NVL(nCS_CP_RESUPREI,0) - NVL(nCP_MAGRESTA_CS,0);
      --
      IF NVL(nCP_MAGRESTA_CS,0) != 0 THEN 
         nCP_DIPOMAGR_CS := (nCP_DIFEMAGR_CS / NVL(nCP_MAGRESTA_CS,0)) * 100;
      ELSE
         nCP_DIPOMAGR_CS := 0;
      END IF;
      --
      RETURN NULL;
   END;
--------------------FIN CF_CALCULOS-----------------------
begin
   --BEFORE
   P_ANE_INRETC.P_BorraTabla_AM;
   --
   P_ANE_INDRCO.P_BorraTabla_AM;
   --
   P_ANE_INTCRE.P_BorraTabla_AM;
   --
   P_ANE_INDECO.P_BorraTabla_AM;
   --
   OPEN cGNR_INDUEMPR;
   FETCH cGNR_INDUEMPR INTO vP_DESC_IRPIPTCS;
   CLOSE cGNR_INDUEMPR;
   --
   OPEN cPeesTint('BLANCO', 'FLEXO');
   FETCH cPeesTint INTO vP_PesoBlFl;
   CLOSE cPeesTint;
   --
   OPEN cPeesTint('RESTO', 'FLEXO');
   FETCH cPeesTint INTO vP_PesoReFl;
   CLOSE cPeesTint;
   --
   OPEN cPeesTint('BLANCO', 'HUECO');
   FETCH cPeesTint INTO vP_PesoBlHu;
   CLOSE cPeesTint;
   --
   OPEN cPeesTint('RESTO', 'HUECO');
   FETCH cPeesTint INTO vP_PesoReHu;
   CLOSE cPeesTint;
   --FIN BEFORE
   FOR rOT IN cOT(vEmpresa_OT,nNumero_OT,nAnno_OT) LOOP
--INICIO--
      rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS := NULL;
      --VARIABLES de FUERA
      nCS_CP_COLAESTA := 0;
      nCS_CP_COLAREAL := 0;
      --
      nCS_COSTDIRE_HORAPROD := 0;
      nCS_COSTINDI_HORAPROD := 0;
      nCS_NUMEHORA_HORAPROD := 0;
      nCF_TOTACOPE_HORAPROD := 0;
      nCP_COSTHORA_HORAPROD := 0;
      nCS_CP_COMTESTA := 0;
      nCS_CP_COMTREAL := 0;
      nCS_CF_COSTE_TOTAL_ESTANDAR := 0;
      nCS_CF_COSTE_TOTAL_REAL := 0;
      nCS_CP_COFIESTA := 0;
      nCS_CP_COFIREAL := 0;
      nCS_CP_PRECIO_FAC := 0;
      nCS_CP_ABONESTA := 0;
      nCS_CP_ABONREAL := 0;
      nCP_DIMLCOKG_CS := 0;
      nCP_DIMLCOM2_CS := 0;
      nCP_DIMLCOML_CS := 0;
      nCS_CP_MALACEKG := 0;
      nCS_CP_MALACEM2 := 0;
      nCS_CP_MALACEML := 0;
      nCP_DIFECOEU_CS := 0;
      nCS_CP_COCOESTA := 0;
      nCS_CP_MALACRKG := 0;
      nCS_CP_MALACRM2 := 0;
      nCS_CP_MALACRML := 0;
      nCP_DPMLCOKG_CS := 0;
      nCP_DPMLCOM2_CS := 0;
      nCP_DPMLCOML_CS := 0;
      nCS_CP_COCOREAL := 0;
      nCP_DIPOCOEU_CS := 0;
      nCS_CP_MALAMEKG := 0;
      nCS_CP_MALAMEM2 := 0;
      nCS_CP_MALAMEML := 0;
      nCP_DIFEFAEU_CS := 0;
      nCP_DIPOFAEU_CS := 0;
      nCP_DIMLMTKG_CS := 0;
      nCP_DIMLMTM2_CS := 0;
      nCP_DIMLMTML_CS := 0;
      nCS_CP_MALAMRKG := 0;
      nCS_CP_MALAMRM2 := 0;
      nCS_CP_MALAMRML := 0;
      nCP_DPMLMTKG_CS := 0;
      nCP_DPMLMTM2_CS := 0;
      nCP_DPMLMTML_CS := 0;
      nCP_DIFEMTEU_CS := 0;
      nCP_DIPOMTEU_CS := 0;
      nCP_DPMTESUN_CS := 0;
      nCP_DIPOMETO_CS := 0;
      nCP_DIFEABON_CS := 0;
      nCP_DIPOABON_CS := 0;
      nCP_DIFEINNE_CS := 0;
      nCP_DIPOINNE_CS := 0;
      nCP_POCLESTA_CS := 0;
      nCP_POCLREAL_CS := 0;
      nCP_POMEPRES_CS := 0;
      nCP_POMEPRRE_CS := 0;
      nCP_POCMOPES_CS := 0;
      nCP_POCMOPRE_CS := 0;
      nCP_DIFECMOP_CS := 0;
      nCP_DIPOCMOP_CS := 0;
      nCP_POOTCPES_CS := 0;
      nCP_POOTCPRE_CS := 0;
      nCP_DIFEOTCP_CS := 0;
      nCP_DIPOOTCP_CS := 0;
      nCP_POCALIES_CS := 0;
      nCP_POCALIRE_CS := 0;
      nCP_POLOINES_CS := 0;
      nCP_POLOINRE_CS := 0;
      nCP_POALMAES_CS := 0;
      nCP_POALMARE_CS := 0;
      nCP_DIFECALI_CS := 0;
      nCP_DIPOCALI_CS := 0;
      nCP_DIFELOIN_CS := 0;
      nCP_DIPOLOIN_CS := 0;
      nCP_DIFEALMA_CS := 0;
      nCP_DIPOALMA_CS := 0;
      nCP_POTCSPES_CS := 0;
      nCP_POTCSPRE_CS := 0;
      nCP_DIFETCSP_CS := 0;
      nCP_DIPOTCSP_CS := 0;
      nCP_POCOCOES_CS := 0;
      nCP_POCOCORE_CS := 0;
      nCP_DIFECOCO_CS := 0;
      nCP_DIPOCOCO_CS := 0;
      nCP_POCODIES_CS := 0;
      nCP_POCODIRE_CS := 0;
      nCP_DIFECODI_CS := 0;
      nCP_DIPOCODI_CS := 0;
      nCP_POCOADES_CS := 0;
      nCP_POCOADRE_CS := 0;
      nCP_DIFECOAD_CS := 0;
      nCP_DIPOCOAD_CS := 0;
      nCP_POCOFIES_CS := 0;
      nCP_POCOFIRE_CS := 0;
      nCP_DIFECOFI_CS := 0;
      nCP_DIPOCOFI_CS := 0;
      nCP_POMAGRES_CS := 0;
      nCP_POMAGRRE_CS := 0;
      nCP_DIFEMAGR_CS := 0;
      nCP_DIPOMAGR_CS := 0;
      nCS_CP_TOCODIES_CS := 0;
      nCS_CP_TOCODIRE_CS := 0;
      --
      FOR rQ_ANNOS_HORAPROD IN Q_ANNOS_HORAPROD(rOT.FECHA_CIERRE) LOOP
         FOR rQ_COSTDIRE_HORAPROD IN Q_COSTDIRE_HORAPROD(rOT.EMPRESA, rOT.FECHA_CIERRE, rQ_ANNOS_HORAPROD.ANNO) LOOP
            nCS_COSTDIRE_HORAPROD := NVL(nCS_COSTDIRE_HORAPROD,0) + NVL(rQ_COSTDIRE_HORAPROD.COSTE,0);
         END LOOP;
         --
         FOR rQ_COSTINDI_HORAPROD IN Q_COSTINDI_HORAPROD(rOT.EMPRESA, rOT.FECHA_CIERRE, rQ_ANNOS_HORAPROD.ANNO) LOOP
            nCS_COSTINDI_HORAPROD := NVL(nCS_COSTINDI_HORAPROD,0) + NVL(rQ_COSTINDI_HORAPROD.COSTE,0);
         END LOOP;
      END LOOP;
      --
      FOR rQ_NUMEHORA_HORAPROD IN Q_NUMEHORA_HORAPROD(rOT.EMPRESA, rOT.FECHA_CIERRE) LOOP
         nCS_NUMEHORA_HORAPROD := NVL(nCS_NUMEHORA_HORAPROD,0) + NVL(rQ_NUMEHORA_HORAPROD.NUMEHORA,0);
      END LOOP;
      --
      IF NVL(nCS_NUMEHORA_HORAPROD,0) != 0 THEN
         nCP_COSTHORA_HORAPROD := (NVL(nCS_COSTDIRE_HORAPROD,0) + NVL(nCS_COSTINDI_HORAPROD,0)) / nCS_NUMEHORA_HORAPROD;
      ELSE                        
         nCP_COSTHORA_HORAPROD := 0;
      END IF;
      --
      nCF_TOTACOPE_HORAPROD := (NVL(nCS_COSTDIRE_HORAPROD,0) + NVL(nCS_COSTINDI_HORAPROD,0));
      --
      nCS_MINUTOS_REAL_OT := 0;
      nCS_MINUTOS_ESTANDAR_OT := 0;
      nCS_CP_COSTHORA_OT := 0;
      nCS_CP_COSTHORE_OT := 0;
      nCS_CF_COSTE_TOTAL_ESTANDAR_TI := 0;
      nCS_CF_COSTE_TOTAL_REAL_TI := 0;
      nCS_CF_DESV_COSTE_TOTAL_T := 0;
      nCS_CF_DESGLOSE_COSTE_HORA_TI := 0;
      nCS_CF_DESGLOSE_VELOCIDAD_TI := 0;
      --
      vCF_MINUTOS_REAL_HORAS_OT := '00';
      vCP_MINUTOS_REAL_MINUTOS_OT := '00';
      vCP_MINUTOS_ESTANDAR_HORAS_OT := '00';
      vCP_MIN_ESTANDAR_MINUTOS_OT := '00';
      vCP_DESVIACION_TIE_HORAS_OT := '00';
      vCP_DESVIACION_TIE_MINUTOS_OT := '00';
      --Se borra el Registro de Objetivo de Coste de OT
      rANE_OBJECOST.EMPRESA := rOT.EMPRESA;
      rANE_OBJECOST.NUMERO_OT := rOT.NUMERO;
      rANE_OBJECOST.FECHA_CIERRE_OT := rOT.FECHA_CIERRE;
      rANE_OBJECOST.CODIGO_CLIENTE := NULL;
      rANE_OBJECOST.DESCRIPCION_CLIENTE := NULL;
      rANE_OBJECOST.TIPO_ARTICULO := rOT.TIP_ARTI;
      rANE_OBJECOST.CODIGO_ARTICULO := rOT.COD_ARTI;
      rANE_OBJECOST.DESCRIPCION_ARTICULO := rOT.DESCRIPCION;
      rANE_OBJECOST.MODIFICACION_ARTICULO := rOT.MODI;
      rANE_OBJECOST.REVISION_ARTICULO := rOT.REVI;
      rANE_OBJECOST.MATERIAL_BASE := NULL;
      rANE_OBJECOST.NUMERO_OTT := rOT.NUMEOTTE;
      rANE_OBJECOST.NUMERO_PEDIDO := rOT.NUMEPEDI;
      rANE_OBJECOST.NUMERO_LINEA_PEDIDO := rOT.LINEPEDI;
      rANE_OBJECOST.TIPO_PEDIDO := NULL;
      rANE_OBJECOST.PEDIDO_NACIONAL_EXPORTACION := NULL;
      rANE_OBJECOST.CANTIDAD_CERRADA_UNIDAD := rOT.CANTCERR;
      rANE_OBJECOST.UNIDAD_CANTIDAD_CERRADA := rOT.UNIDAD;
      rANE_OBJECOST.CANTIDAD_CERRADA_ML := NULL;
      rANE_OBJECOST.CANTIDAD_CERRADA_ML_PRODUCCION := NULL;
      rANE_OBJECOST.ANCHO_MM_ARTICULO := NULL;
      rANE_OBJECOST.ANCHO_MM_PRODUCCION := NULL;
      rANE_OBJECOST.NUMERO_DE_REPETICIONES := NULL;
      rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS := NULL;
      rANE_OBJECOST.FECHA_CALCULO := SYSDATE;
      --
      nCP_MALACRML := 0;
      nCP_MALACRM2 := 0;
      nCP_MALACRKG := 0;
      nCP_MALACEML := 0;
      nCP_MALACEM2 := 0;
      nCP_MALACEKG := 0;
      nCP_MALAMRML := 0;
      nCP_MALAMEML := 0;
      nCP_COMTREAL := 0;
      nCP_COMTESTA := 0;
      nCP_COLAREAL := 0;
      nCP_COLAESTA := 0;
      --
      vCP_PEDINUMO := NULL;
      --Pedido Nuevo o Modificado
      OPEN cPediNumo(rOT.EMPRESA, rOT.NUMEPEDI, rOT.LINEPEDI);
      FETCH cPediNumo INTO vCP_PEDINUMO;
      CLOSE cPediNumo;
      --
      vCP_PEDINUMO := NVL(vCP_PEDINUMO,'NE'); --Si es nulo se marca como que no existe
      --
      rANE_OBJECOST.TIPO_PEDIDO := vCP_PEDINUMO;
      --
      OPEN cFIC_INFOPROD(rOT.EMPRESA, rOT.NUMERO, rOT.ANNO);
      FETCH cFIC_INFOPROD INTO rFIC_INFOPROD;
      CLOSE cFIC_INFOPROD;
      --
      nCP_ANCHO_MM_PROD := rFIC_INFOPROD.TOTAL;
      --
      rANE_OBJECOST.ANCHO_MM_PRODUCCION := nCP_ANCHO_MM_PROD;
      --
      IF NVL(nCP_ANCHO_MM_PROD,0) != 0 THEN
         nCP_M2ML := nCP_ANCHO_MM_PROD / 1000;
      ELSE
         nCP_M2ML := NULL;
         P_ERRORES('19- No existe ancho de Produccion Total, no existe Numero de Repeticiones');
      END IF;
      --
      nCP_N_VECES := rFIC_INFOPROD.N_VECES;
      --
      rANE_OBJECOST.NUMERO_DE_REPETICIONES := nCP_N_VECES;
      --
      nVencimiento := NULL;
      vVPacod := NULL;
      --
      IF rOT.TIP_ARTI = vP_TIARFIF4 THEN
         vCP_CLIENTE_ID := SUBSTR(rOT.COD_ARTI,4,4);
         --
         rANE_OBJECOST.CODIGO_CLIENTE := vCP_CLIENTE_ID;
         --
         IF P_Utilidad.F_Valida_RegiTabla('CLIENTES','EMPRESA,CLIENTE_ID',rOT.EMPRESA||','||vCP_CLIENTE_ID, vValoRegr) THEN
           vCP_RAZON_SOC := P_UTILIDAD.F_ValoCampo(vValoRegr,'RAZON_SOC');
           --
           rANE_OBJECOST.DESCRIPCION_CLIENTE := vCP_RAZON_SOC;
         ELSE
           vCP_CLIENTE_ID := NULL;
           --
           vCP_TIPOPEDI := 'N';
           --
           rANE_OBJECOST.PEDIDO_NACIONAL_EXPORTACION := vCP_TIPOPEDI;
         END IF;
         --
         IF vCP_CLIENTE_ID IS NOT NULL THEN
      	     OPEN cPais(rOT.EMPRESA, vCP_CLIENTE_ID);
      	     FETCH cPais INTO vVPacod;
      	     CLOSE cPais;
      	     --
      	     IF vVPacod IS NOT NULL THEN
                IF vVPacod = vP_PAISESPA THEN
                   vCP_TIPOPEDI := 'N';
                ELSE
                   vCP_TIPOPEDI := 'E';
                END IF;
             ELSE
                vCP_TIPOPEDI := 'N';
             END IF;
             --
             rANE_OBJECOST.PEDIDO_NACIONAL_EXPORTACION := vCP_TIPOPEDI;
      	     --
      	     rVencimiento.MCPLAZ := NULL;
      	     rVencimiento.MCPVTO := NULL;
      	     rVencimiento.MCLVTO := NULL;
      	     --
      	     OPEN cVencimiento(rOT.EMPRESA, vCP_CLIENTE_ID);
      	     FETCH cVencimiento INTO rVencimiento;
      	     CLOSE cVencimiento;
      	     --
      	     IF rVencimiento.MCPLAZ IS NOT NULL THEN
      	        IF rVencimiento.MCPLAZ = 1 THEN
      	           nVencimiento := NVL(rVencimiento.MCPVTO,0);
      	        ELSE
      	           nVencimiento := NVL(rVencimiento.MCPVTO,0) + ((NVL(rVencimiento.MCPLAZ,0) - 1) * NVL(rVencimiento.MCLVTO,0));
      	        END IF;            
      	     ELSE
      	        nVencimiento := 0;
      	     END IF;
      	  END IF;
         --
         OPEN cHFTGESTI(rOT.EMPRESA, rOT.TIP_ARTI, rOT.COD_ARTI,
                        rOT.MODI, rOT.REVI);
         FETCH cHFTGESTI INTO nCP_ANCHO_MM, nLargo, vMatBase;
         CLOSE cHFTGESTI;
         --
         rANE_OBJECOST.MATERIAL_BASE := vMatBase;
         rANE_OBJECOST.ANCHO_MM_ARTICULO := nCP_ANCHO_MM;
      ELSIF rOT.TIP_ARTI = vP_TIARSEF4 THEN
         vCP_RAZON_SOC := NULL;
         --
         OPEN cFIC_SEGESTI(rOT.EMPRESA, rOT.TIP_ARTI, rOT.COD_ARTI);
         FETCH cFIC_SEGESTI INTO nCP_ANCHO_MM, nLargo, vMatBase;
         CLOSE cFIC_SEGESTI;
         --
         vCP_TIPOPEDI := 'N';
         --
         rANE_OBJECOST.MATERIAL_BASE := vMatBase;
         rANE_OBJECOST.PEDIDO_NACIONAL_EXPORTACION := vCP_TIPOPEDI;
         rANE_OBJECOST.ANCHO_MM_ARTICULO := nCP_ANCHO_MM;
      ELSE
         vCP_RAZON_SOC := NULL;
         nCP_ANCHO_MM := NULL;
         --
         vCP_TIPOPEDI := 'N';
         --
         rANE_OBJECOST.PEDIDO_NACIONAL_EXPORTACION := vCP_TIPOPEDI;
      END IF;
      --
      IF vVPacod IS NOT NULL THEN
         --Costes Financieros
         --ESTANDAR
         --Calculo de Costes de Matriz a ser Subrepartidos
         nReFiGest_E := NULL;
         --
         rIngrGast_Estandar.ENERIMCU := NULL;
         rIngrGast_Estandar.FEBRIMCU := NULL;
         rIngrGast_Estandar.MARZIMCU := NULL;
         rIngrGast_Estandar.ABRIIMCU := NULL;
         rIngrGast_Estandar.MAYOIMCU := NULL;
         rIngrGast_Estandar.JUNIIMCU := NULL;
         rIngrGast_Estandar.JULIIMCU := NULL;
         rIngrGast_Estandar.AGOSIMCU := NULL;
         rIngrGast_Estandar.SEPTIMCU := NULL;
         rIngrGast_Estandar.OCTUIMCU := NULL;
         rIngrGast_Estandar.NOVIIMCU := NULL;
         rIngrGast_Estandar.DICIIMCU := NULL;
         --
         OPEN cIngrGast_Estandar(vP_EMPRGEST, rOT.FECHA_CIERRE);
         FETCH cIngrGast_Estandar INTO rIngrGast_Estandar;
         CLOSE cIngrGast_Estandar;
         --
         IF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '01' THEN
            nReFiGest_E := rIngrGast_Estandar.ENERIMCU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '02' THEN
      	    nReFiGest_E := rIngrGast_Estandar.FEBRIMCU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '03' THEN
      	    nReFiGest_E := rIngrGast_Estandar.MARZIMCU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '04' THEN
      	    nReFiGest_E := rIngrGast_Estandar.ABRIIMCU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '05' THEN
      	    nReFiGest_E := rIngrGast_Estandar.MAYOIMCU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '06' THEN
      	    nReFiGest_E := rIngrGast_Estandar.JUNIIMCU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '07' THEN
      	    nReFiGest_E := rIngrGast_Estandar.JULIIMCU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '08' THEN
      	    nReFiGest_E := rIngrGast_Estandar.AGOSIMCU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '09' THEN
      	    nReFiGest_E := rIngrGast_Estandar.SEPTIMCU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '10' THEN
      	    nReFiGest_E := rIngrGast_Estandar.OCTUIMCU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '11' THEN
      	    nReFiGest_E := rIngrGast_Estandar.NOVIIMCU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '12' THEN
      	    nReFiGest_E := rIngrGast_Estandar.DICIIMCU;
         END IF;
         --
         nReFiGest_E := NVL(nReFiGest_E,0);
         --Calculo de Costes de Empresa
         nResuFina_E := NULL;
         --
         rIngrGast_Estandar.ENERIMCU := NULL;
         rIngrGast_Estandar.FEBRIMCU := NULL;
         rIngrGast_Estandar.MARZIMCU := NULL;
         rIngrGast_Estandar.ABRIIMCU := NULL;
         rIngrGast_Estandar.MAYOIMCU := NULL;
         rIngrGast_Estandar.JUNIIMCU := NULL;
         rIngrGast_Estandar.JULIIMCU := NULL;
         rIngrGast_Estandar.AGOSIMCU := NULL;
         rIngrGast_Estandar.SEPTIMCU := NULL;
         rIngrGast_Estandar.OCTUIMCU := NULL;
         rIngrGast_Estandar.NOVIIMCU := NULL;
         rIngrGast_Estandar.DICIIMCU := NULL;
         --
         OPEN cIngrGast_Estandar(rOT.EMPRESA, rOT.FECHA_CIERRE);
         FETCH cIngrGast_Estandar INTO rIngrGast_Estandar;
         CLOSE cIngrGast_Estandar;
         --Calculo de la Facturación
         nFacturacion_E := NULL;
         --
         rPRD_CONFFAES.FACTENER := NULL;
         rPRD_CONFFAES.FACTFEBR := NULL;
         rPRD_CONFFAES.FACTMARZ := NULL;
         rPRD_CONFFAES.FACTABRI := NULL;
         rPRD_CONFFAES.FACTMAYO := NULL;
         rPRD_CONFFAES.FACTJUNI := NULL;
         rPRD_CONFFAES.FACTJULI := NULL;
         rPRD_CONFFAES.FACTAGOS := NULL;
         rPRD_CONFFAES.FACTSEPT := NULL;
         rPRD_CONFFAES.FACTOCTU := NULL;
         rPRD_CONFFAES.FACTNOVI := NULL;
         rPRD_CONFFAES.FACTDICI := NULL;
         --
         OPEN cPRD_CONFFAES(rOT.EMPRESA, rOT.FECHA_CIERRE);
         FETCH cPRD_CONFFAES INTO rPRD_CONFFAES;
         CLOSE cPRD_CONFFAES;
         --
         IF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '01' THEN
            nResuFina_E := rIngrGast_Estandar.ENERIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTENER;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '02' THEN
            nResuFina_E := rIngrGast_Estandar.FEBRIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTFEBR;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '03' THEN
            nResuFina_E := rIngrGast_Estandar.MARZIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTMARZ;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '04' THEN
            nResuFina_E := rIngrGast_Estandar.ABRIIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTABRI;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '05' THEN
            nResuFina_E := rIngrGast_Estandar.MAYOIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTMAYO;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '06' THEN
            nResuFina_E := rIngrGast_Estandar.JUNIIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTJUNI;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '07' THEN
            nResuFina_E := rIngrGast_Estandar.JULIIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTJULI;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '08' THEN
            nResuFina_E := rIngrGast_Estandar.AGOSIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTAGOS;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '09' THEN
            nResuFina_E := rIngrGast_Estandar.SEPTIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTSEPT;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '10' THEN
            nResuFina_E := rIngrGast_Estandar.OCTUIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTOCTU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '11' THEN
            nResuFina_E := rIngrGast_Estandar.NOVIIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTNOVI;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '12' THEN
            nResuFina_E := rIngrGast_Estandar.DICIIMCU;
            nFacturacion_E := rPRD_CONFFAES.FACTDICI;
         END IF;
         --
         nResuFina_E := NVL(nResuFina_E,0);
         nFacturacion_E := NVL(nFacturacion_E,0);
         --
         rANE_PORECOMA.PORECMPH := NULL;
         rANE_PORECOMA.PORECMMA := NULL;
         --% Reparto Costes Matriz
         OPEN cANE_PORECOMA('E',rOT.FECHA_CIERRE);
         FETCH cANE_PORECOMA INTO rANE_PORECOMA;
         CLOSE cANE_PORECOMA;
         --Coste de Empresa + Coste de Matriz Subrepartido
         IF rOT.EMPRESA = vP_EMPRPHAR THEN
            nResuFina_E := nResuFina_E + ((nReFiGest_E * NVL(rANE_PORECOMA.PORECMPH,0)) / 100);
         ELSIF  rOT.EMPRESA = vP_EMPRMANV THEN                                                        
            nResuFina_E := nResuFina_E + ((nReFiGest_E * NVL(rANE_PORECOMA.PORECMMA,0)) / 100);
         END IF;
         --% COSTE FINANCIERO DE INVERSION POR OT
         IF NVL(nFacturacion_E,0) != 0 THEN
            nPOCFOTIN_E := nResuFina_E / nFacturacion_E;
         ELSE
            nPOCFOTIN_E := 0;
         END IF;
      	  --REAL
   --<   	  
      	--Calculo de Costes de Matriz a ser Subrepartidos
         nReFiGest_R := NULL;
         --
         rIngrGast_Real.IMPOCUEN := NULL;
         --
         OPEN cIngrGast_Real(vP_EMPRGEST,rOT.FECHA_CIERRE);
         FETCH cIngrGast_Real INTO rIngrGast_Real;
         CLOSE cIngrGast_Real;
         --
         nReFiGest_R := NVL(rIngrGast_Real.IMPOCUEN,0);
         --Calculo de Costes de Empresa
         nResuFina_R := NULL;
         --
         rIngrGast_Real.IMPOCUEN := NULL;
         --
         OPEN cIngrGast_Real(rOT.EMPRESA,rOT.FECHA_CIERRE);
         FETCH cIngrGast_Real INTO rIngrGast_Real;
         CLOSE cIngrGast_Real;
         --Calculo de la Facturación
         nFacturacion_R := NULL;
         --
         rPRD_CONFFARE.FACTENER := NULL;
         rPRD_CONFFARE.FACTFEBR := NULL;
         rPRD_CONFFARE.FACTMARZ := NULL;
         rPRD_CONFFARE.FACTABRI := NULL;
         rPRD_CONFFARE.FACTMAYO := NULL;
         rPRD_CONFFARE.FACTJUNI := NULL;
         rPRD_CONFFARE.FACTJULI := NULL;
         rPRD_CONFFARE.FACTAGOS := NULL;
         rPRD_CONFFARE.FACTSEPT := NULL;
         rPRD_CONFFARE.FACTOCTU := NULL;
         rPRD_CONFFARE.FACTNOVI := NULL;
         rPRD_CONFFARE.FACTDICI := NULL;
         --
         OPEN cPRD_CONFFARE(rOT.EMPRESA,rOT.FECHA_CIERRE);
         FETCH cPRD_CONFFARE INTO rPRD_CONFFARE;
         CLOSE cPRD_CONFFARE;
         --
         IF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '01' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTENER;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '02' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTFEBR;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '03' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTMARZ;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '04' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTABRI;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '05' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTMAYO;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '06' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTJUNI;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '07' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTJULI;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '08' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTAGOS;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '09' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTSEPT;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '10' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTOCTU;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '11' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTNOVI;
         ELSIF TO_CHAR(rOT.FECHA_CIERRE,'MM') = '12' THEN
            nFacturacion_R := rPRD_CONFFARE.FACTDICI;
         END IF;
         --
         nResuFina_R := NVL(rIngrGast_Real.IMPOCUEN,0);
         nFacturacion_R := NVL(nFacturacion_R,0);
         --
         rANE_PORECOMA.PORECMPH := NULL;
         rANE_PORECOMA.PORECMMA := NULL;
         --% Reparto Costes Matriz
         OPEN cANE_PORECOMA('R',rOT.FECHA_CIERRE);
         FETCH cANE_PORECOMA INTO rANE_PORECOMA;
         CLOSE cANE_PORECOMA;
         --Coste de Empresa + Coste de Matriz Subrepartido
         IF rOT.EMPRESA = vP_EMPRPHAR THEN
            nResuFina_R := nResuFina_R + ((nReFiGest_R * NVL(rANE_PORECOMA.PORECMPH,0)) / 100);
         ELSIF rOT.EMPRESA = vP_EMPRMANV THEN                                                        
            nResuFina_R := nResuFina_R + ((nReFiGest_R * NVL(rANE_PORECOMA.PORECMMA,0)) / 100);
         END IF;
         --% COSTE FINANCIERO DE INVERSION POR OT
         IF NVL(nFacturacion_R,0) != 0 THEN
            nPOCFOTIN_R := nResuFina_R / nFacturacion_R;
         ELSE
            nPOCFOTIN_R := 0;
         END IF;
      END IF;
      --
      OPEN cPrecio(rOT.EMPRESA, rOT.NUMERO);
      FETCH cPrecio INTO nCP_PRECIO_FAC;
      CLOSE cPrecio;
      --
      nCS_CP_PRECIO_FAC := NVL(nCS_CP_PRECIO_FAC,0) + NVL(nCP_PRECIO_FAC,0);
      --Cantidades en Factores
      IF rOT.UNIDAD = vP_TIPOUNML THEN
         nCP_CANTCERR_ML := rOT.CANTCERR;
      ELSE
      	nFactor := 0;
      	--
         BEGIN
            --Calculo del Factor de Conversion a la Unidad de Venta
            nFactor := P_Articulo.F_Factor (rOT.EMPRESA,vMatBase,
                                            nCP_ANCHO_MM, nLargo,
                                            rOT.UNIDAD,vP_TIPOUNML);
         EXCEPTION 
            WHEN OTHERS THEN
               nFactor := 0;
               P_ERRORES('20- No se puede calcular FC de '||rOT.UNIDAD||'->'||vP_TIPOUNML||' para la OT');
         END;
         --
         IF NVL(nFactor,0) != 0 THEN
            nCP_CANTCERR_ML := NVL(rOT.CANTCERR,0) * (1 / nFactor);
         ELSE
            P_ERRORES('21- (No existe FC) No se puede calcular la Cantidad Cerrada ML para la OT');
         END IF;
      END IF;
      --
      rANE_OBJECOST.CANTIDAD_CERRADA_ML := nCP_CANTCERR_ML;
      --Cantidad Cerrada Produccion
      IF NVL(nCP_N_VECES,0) != 0 THEN
         nCP_CANTCERR_ML_PROD := nCP_CANTCERR_ML / nCP_N_VECES;
      ELSE
         nCP_CANTCERR_ML_PROD := 0;
      END IF;                
      --
      rANE_OBJECOST.CANTIDAD_CERRADA_ML_PRODUCCION := nCP_CANTCERR_ML_PROD;
      --Calculo de Factor en M2 para Coste de Merma
      nFactorM2 := 0;
      --
      BEGIN
         --Calculo del Factor de Conversion a la Unidad de Venta
         nFactorM2 := P_Articulo.F_Factor (rOT.EMPRESA,vMatBase,
                                           nCP_ANCHO_MM, nLargo,
                                           vP_TIPOUNML,vP_TIPOUNM2);
      EXCEPTION 
         WHEN OTHERS THEN
            nFactorM2 := 0;
            P_ERRORES('22- No se puede calcular FC de '||vP_TIPOUNML||'->'||vP_TIPOUNM2||' para la OT');
      END;   
      --Se calculan los Costes de las MP, Calculo de Numero de Materiales, Mermas de Materiales
      P_Materiales(rOT.EMPRESA, rOT.NUMERO,
                   rOT.NUMEOTTE, rOT.ANNOOTTE,
                   rOT.TIP_ARTI, rOT.COD_ARTI,
                   rOT.Fecha_Cierre);
      /*--
      nCS_CP_COLAESTA := NVL(nCS_CP_COLAESTA,0) + NVL(nCP_COLAESTA,0);
      nCS_CP_COLAREAL := NVL(nCS_CP_COLAREAL,0) + NVL(nCP_COLAREAL,0);
      nCS_CP_COMTESTA := NVL(nCS_CP_COMTESTA,0) + NVL(nCP_COMTESTA,0);
      nCS_CP_COMTREAL := NVL(nCS_CP_COMTREAL,0) + NVL(nCP_COMTREAL,0);*/
      --Ejecuta el ultimo bucle que no se alcanza a tratar con la condición de cambio de Fase
      --Si ya ha ejecutado un bucle por lo menos 
      IF NVL(nNumeMaFS,0) = 0 THEN
         P_ERRORES('23- Posible Error en la estructura no se pueden establecer correctamente el numero de materiales');
      END IF;
      --
      IF nFaSeUlti IS NOT NULL AND NVL(nNumeMaFS,0) != 0 THEN
         rMetrCons.MAQUCODI := NULL;
         --Se busca la cantidad consumida en la Fase Secuencia
         OPEN cMetrCons(rOT.EMPRESA, rOT.NUMERO, nFaSeUlti);
         FETCH cMetrCons INTO rMetrCons;
         CLOSE cMetrCons;
         --
         IF rMetrCons.MAQUCODI IS NOT NULL THEN
            --Calculo de la Merma de Material
            IF INSTR(rMetrCons.MAQUCODI,'LAMINADORA') != 0 OR INSTR(rMetrCons.MAQUCODI,'LAQUEADORA') != 0 THEN
                IF nNumeMaFS = 1 THEN --Esto es cuando se lamina con un material de otra fase
                   nCP_MALACRML := NVL(nCP_MALACRML,0) + (rMetrCons.CANTCON1 * nCP_N_Veces);
                   nCP_MALAMRML := NVL(nCP_MALAMRML,0) + ((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML);
                   IF NVL(nFactorM2,0) != 0 THEN
                      nCP_COMTREAL := NVL(nCP_COMTREAL,0) + ((((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) / nFactorM2) * nPrecReFS);
                   ELSE
                      P_ERRORES('24- (No existe FC) No se puede acumular Merma Total Real para la MP en la Fase: '||nFaSeUlti);
                   END IF;
                ELSIF MOD(nNumeMaFS,2) = 0 THEN --Si el numero de materiales es par se reparten por iguales en los consumos
                  nCP_MALACRML := NVL(nCP_MALACRML,0) + ((rMetrCons.CANTCON1 * nCP_N_Veces) * (nNumeMaFS / 2)) + ((rMetrCons.CANTCON2 * nCP_N_Veces) * (nNumeMaFS / 2));
                  nCP_MALAMRML := NVL(nCP_MALAMRML,0) + (((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS / 2)) + (((rMetrCons.CANTCON2 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS / 2));
                  IF NVL(nFactorM2,0) != 0 THEN
                     nCP_COMTREAL := NVL(nCP_COMTREAL,0) + 
                                     (
                                      (
                                       (
                                        ((((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS / 2)) 
                                        + 
                                        (((rMetrCons.CANTCON2 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS / 2))
                                        ) / nFactorM2
                                       ) * nPrecReFS
                                      ) / nNumeMaFS
                                     );
                  ELSE
                     P_ERRORES('25- (No existe FC) No se puede acumular Merma Total Real para la MP en la Fase: '||nFaSeUlti);
                  END IF;
               ELSIF MOD(nNumeMaFS,2) != 0 THEN--Si el numero de materiales es impar se reparten de forma desigual en los consumos
                  nCP_MALACRML := NVL(nCP_MALACRML,0) + ((rMetrCons.CANTCON1 * nCP_N_Veces) * TRUNC(nNumeMaFS / 2)) + ((rMetrCons.CANTCON2 * nCP_N_Veces) * (nNumeMaFS - TRUNC(nNumeMaFS / 2)));
                  nCP_MALAMRML := NVL(nCP_MALAMRML,0) + (((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * TRUNC(nNumeMaFS / 2)) + (((rMetrCons.CANTCON2 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS - TRUNC(nNumeMaFS / 2)));
                  --
                  IF NVL(nFactorM2,0) != 0 THEN
                     nCP_COMTREAL := NVL(nCP_COMTREAL,0) + 
                                     (
                                      (
                                       (
                                        ((((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * TRUNC(nNumeMaFS / 2)) 
                                        +(((rMetrCons.CANTCON2 * nCP_N_Veces) - nCP_CantCerr_ML) * (nNumeMaFS - TRUNC(nNumeMaFS / 2)))
                                        ) / nFactorM2
                                       ) * nPrecReFS
                                      ) / nNumeMaFS
                                     ); 
                  ELSE
                     P_ERRORES('26- (No existe FC) No se puede acumular Merma Total Real para la MP en la Fase: '||nFaSeUlti);
                  END IF;
               END IF;
            ELSE
               nCP_MALACRML := NVL(nCP_MALACRML,0) + ((rMetrCons.CANTCON1 * nCP_N_Veces) * nNumeMaFS);
               nCP_MALAMRML := NVL(nCP_MALAMRML,0) + (((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * nNumeMaFS);
               --
               IF NVL(nFactorM2,0) != 0 THEN
                  nCP_COMTREAL := NVL(nCP_COMTREAL,0) + ((((((rMetrCons.CANTCON1 * nCP_N_Veces) - nCP_CantCerr_ML) * nNumeMaFS) / nFactorM2) * nPrecReFS) / nNumeMaFS);
               ELSE
                  P_ERRORES('27- (No existe FC) No se puede acumular Merma Total Real para la MP en la Fase: '||nFaSeUlti);
               END IF;
            END IF;
         END IF;
         --
         nNumeMaFS := 0;
         nPrecReFS := 0;
      END IF;
      --Si se encuentran errores en el Factor de conversion los precios de Consumos de Lamina se ponen a 0
      IF bError THEN
         --Ingreso Neto Estandar de Consumo de Lamina
   	    nCP_COLAESTA := 0;
      END IF;
      --
      nCP_MALACEML := nCP_CANTCERR_ML * nNumeMate;
      nCP_MALAFAML := nCP_CANTCERR_ML * nNumeMate;
      --
      IF rOT.UNIDAD = vP_TIPOUNM2 THEN
      	nCP_MALACEM2 := rOT.CANTCERR * nNumeMate;
         nCP_MALAFAM2 := rOT.CANTCERR * nNumeMate;
      ELSE
      	nFactor := 0;
      	--
         BEGIN
            --Calculo del Factor de Conversion a la Unidad de Venta
            nFactor := P_Articulo.F_Factor (rOT.EMPRESA,vMatBase,
                                            nCP_ANCHO_MM, nLargo,
                                            rOT.UNIDAD,vP_TIPOUNM2);
         EXCEPTION 
            WHEN OTHERS THEN
               nFactor := 0;
               P_ERRORES('28- No se puede calcular FC de '||rOT.UNIDAD||'->'||vP_TIPOUNM2||' para la OT');
         END;
         --
         IF NVL(nFactor,0) != 0 THEN
            nCP_MALACEM2 := (NVL(rOT.CANTCERR,0) * (1 / nFactor)) *  nNumeMate;
            nCP_MALAFAM2 := (NVL(rOT.CANTCERR,0) * (1 / nFactor)) *  nNumeMate;
         ELSE
            P_ERRORES('29- (No existe FC) No se puede calcular los M2 Consumidos y Facturados Estandar para la OT');
         END IF;
      END IF;
      --
      IF rOT.UNIDAD = vP_TIPOUNKG THEN
      	 nCP_MALACEKG := rOT.CANTCERR * nNumeMate;
         nCP_MALAFAKG := rOT.CANTCERR * nNumeMate;
      ELSE
         IF vMatBase IS NOT NULL THEN
      	   nFactor := 0;
      	   --
            BEGIN
               --Calculo del Factor de Conversion a la Unidad de Venta
               nFactor := P_Articulo.F_Factor (rOT.EMPRESA,vMatBase,
                                               nCP_ANCHO_MM, nLargo,
                                               rOT.UNIDAD,vP_TIPOUNKG);
            EXCEPTION 
               WHEN OTHERS THEN
                  nFactor := 0;
                  P_ERRORES('30.1- No se puede calcular FC de '||rOT.UNIDAD||'->'||VP_TIPOUNKG||' para la OT');
            END;               
         ELSE
            nFactor := 0;
            P_ERRORES('30.2- No se puede calcular FC de '||rOT.UNIDAD||'->'||VP_TIPOUNKG||' para la OT, no existe MatBase');
         END IF;
         --
         IF NVL(nFactor,0) != 0 THEN
            nCP_MALACEKG := (NVL(rOT.CANTCERR,0) * (1 / nFactor)) * nNumeMate;
            nCP_MALAFAKG := (NVL(rOT.CANTCERR,0) * (1 / nFactor)) * nNumeMate;
         ELSE
            P_ERRORES('31- (No existe FC) No se puede calcular los KG Consumidos y Facturados Estandar para la OT');
         END IF;
      END IF;
      --Calculo de Mermas en M2
      nFactor := 0;
      --
      BEGIN
         --Calculo del Factor de Conversion a la Unidad de Venta
         nFactor := P_Articulo.F_Factor (rOT.EMPRESA,vMatBase,
                                         nCP_ANCHO_MM, nLargo,
                                         vP_TIPOUNML,vP_TIPOUNM2);
      EXCEPTION 
         WHEN OTHERS THEN
            nFactor := 0;
            P_ERRORES('32- No se puede calcular FC de '||vP_TIPOUNML||'->'||vP_TIPOUNM2||' para la OT');
      END;
      --
      IF NVL(nFactor,0) != 0 THEN
      	nCP_MALACRM2 := (NVL(nCP_MALACRML,0) * (1 / nFactor));
         nCP_MALAMRM2 := (NVL(nCP_MALAMRML,0) * (1 / nFactor));
      ELSE
         P_ERRORES('33- (No existe FC) No se puede calcular los M2 Consumidos y de Mermas Reales para la OT');
      END IF;
      --Calculo de Mermas en KG
      nFactor := 0;
      --
      BEGIN
         --Calculo del Factor de Conversion a la Unidad de Venta
         nFactor := P_Articulo.F_Factor (rOT.EMPRESA,vMatBase,
                                         nCP_ANCHO_MM, nLargo,
                                         vP_TIPOUNML,vP_TIPOUNKG);
      EXCEPTION 
         WHEN OTHERS THEN
            nFactor := 0;
            P_ERRORES('34- No se puede calcular FC de '||vP_TIPOUNML||'->'||vP_TIPOUNKG||' para la OT');
      END;
      --
      IF NVL(nFactor,0) != 0 THEN
      	nCP_MALACRKG := (NVL(nCP_MALACRML,0) * (1 / nFactor));
         nCP_MALAMRKG := (NVL(nCP_MALAMRML,0) * (1 / nFactor));
      ELSE
         P_ERRORES('35- (No existe FC) No se puede calcular los KG Consumidos y de Mermas Reales para la OT');
      END IF;
      --Conste Consumo Real
      nCP_COCOESTA := NVL(nCP_COLAESTA,0) + NVL(nCP_COMTESTA,0);
      --Conste Consumo Real
      nCP_COCOREAL := NVL(nCP_COLAREAL,0) + NVL(nCP_COMTREAL,0);
      --Porcentajes de Mermas Estandar
      
      --Porcentajes de Mermas Real
      
      --Diferencias Unidades Fisicas Consumos

      --Diferencias Unidades Fisicas Mermas Totales

      --Diferencias Porcentajes de Mermas
      
      --Diferencia Consumo Euros
      
      --Diferencia Facturado Euros
      
      --Diferencia Merma Total
      
      --Diferencias Porcentajes de Euros
      
      --Abonos de la OT
      --OPEN cAbonos;
      --FETCH cAbonos INTO nCP_ABONREAL;
      --CLOSE cAbonos;                 
      --
      nCP_ABONREAL := NVL(nCP_ABONREAL,0);
      --
      nCS_CP_ABONESTA := NVL(nCS_CP_ABONESTA,0) + NVL(nCP_ABONESTA,0);
      nCS_CP_ABONREAL := NVL(nCS_CP_ABONREAL,0) + NVL(nCP_ABONREAL,0);
      --Ingresos Netos
      nCP_INNEESTA := NVL(nCP_PRECIO_FAC,0) - NVL(nCP_ABONESTA,0);
      --
      nCS_CP_INNEESTA := NVL(nCS_CP_INNEESTA,0) + NVL(nCP_INNEESTA,0);
      --
      nCP_INNEREAL := NVL(nCP_PRECIO_FAC,0) - NVL(nCP_ABONREAL,0);
      --
      nCS_CP_INNEREAL := NVL(nCS_CP_INNEREAL,0) + NVL(nCP_INNEREAL,0);
      --Costes Financieros
      IF vVPacod IS NOT NULL THEN
         --ESTANDAR
         --1. OPERACIONES DE INVERSION
         nVaOpInve_E := nCP_INNEESTA * nPOCFOTIN_E;
         --2. OPERACIONES DE CIRCULANTE
         nOperCirc_E := NULL;
         --Busqueda de Porcentajes de Operaciones de Circulante
         OPEN cOperCirc('E', rOT.FECHA_CIERRE);
         FETCH cOperCirc INTO nOperCirc_E;
         CLOSE cOperCirc;
         --
         nVaOpCirc_E := (nCP_INNEESTA * (NVL(nOperCirc_E,0) / 100)) * (nVencimiento / 360);
         --Seguro de Credito es igual para Estandar y Real
      	OPEN cANE_TASECRPA(rOT.EMPRESA, vVPacod, rOT.FECHA_CIERRE);
      	FETCH cANE_TASECRPA INTO nTaanSces;
      	CLOSE cANE_TASECRPA;
      	--Coste de Seguro de Credito  + 1. + 2.
      	nCP_COFIESTA := ((nCP_INNEESTA * NVL(nTaanSces,0)) / 100) + --1.
      	                (nVaOpInve_E + nVaOpCirc_E);   
         --REAL
         --1. OPERACIONES DE INVERSION
         nVaOpInve_R := nCP_INNEREAL * nPOCFOTIN_R;
         --2. OPERACIONES DE CIRCULANTE
         nOperCirc_R := NULL;
         --Busqueda de Porcentajes de Operaciones de Circulante
         OPEN cOperCirc('R', rOT.FECHA_CIERRE);
         FETCH cOperCirc INTO nOperCirc_R;
         CLOSE cOperCirc;
         --
         nVaOpCirc_R := (nCP_INNEREAL * (NVL(nOperCirc_R,0) / 100)) * (nVencimiento / 360);
         --
         --Coste de Seguro de Credito  + 1. + 2.
      	nCP_COFIREAL := ((nCP_INNEREAL * NVL(nTaanSces,0)) / 100) + --1.
      	                (nVaOpInve_R + nVaOpCirc_R);
         --Costes Financieros Calculo de % y Diferencias
         
      ELSE
         nCP_COFIESTA := 0;
         nCP_COFIREAL := 0;
      END IF;
      --
      nCS_CP_COLAESTA := NVL(nCS_CP_COLAESTA,0) + NVL(nCP_COLAESTA,0);
      nCS_CP_COLAREAL := NVL(nCS_CP_COLAREAL,0) + NVL(nCP_COLAREAL,0);
      nCS_CP_COMTESTA := NVL(nCS_CP_COMTESTA,0) + NVL(nCP_COMTESTA,0);
      nCS_CP_COMTREAL := NVL(nCS_CP_COMTREAL,0) + NVL(nCP_COMTREAL,0);
      --
      nCS_CP_COFIESTA := NVL(nCS_CP_COFIESTA,0) + NVL(nCP_COFIESTA,0);
      nCS_CP_COFIREAL := NVL(nCS_CP_COFIREAL,0) + NVL(nCP_COFIREAL,0);
      nCS_CP_MALACEKG := NVL(nCS_CP_MALACEKG,0) + NVL(nCP_MALACEKG,0);
      nCS_CP_MALACEM2 := NVL(nCS_CP_MALACEM2,0) + NVL(nCP_MALACEM2,0);
      nCS_CP_MALACEML := NVL(nCS_CP_MALACEML,0) + NVL(nCP_MALACEML,0);
      nCS_CP_COCOESTA := NVL(nCS_CP_COCOESTA,0) + NVL(nCP_COCOESTA,0);
      nCS_CP_MALACRKG := NVL(nCS_CP_MALACRKG,0) + NVL(nCP_MALACRKG,0);
      nCS_CP_MALACRM2 := NVL(nCS_CP_MALACRM2,0) + NVL(nCP_MALACRM2,0);
      nCS_CP_MALACRML := NVL(nCS_CP_MALACRML,0) + NVL(nCP_MALACRML,0);
      nCS_CP_COCOREAL := NVL(nCS_CP_COCOREAL,0) + NVL(nCP_COCOREAL,0);
      nCS_CP_MALAMEKG := NVL(nCS_CP_MALAMEKG,0) + NVL(nCP_MALAMEKG,0);
      nCS_CP_MALAMEM2 := NVL(nCS_CP_MALAMEM2,0) + NVL(nCP_MALAMEM2,0);
      nCS_CP_MALAMEML := NVL(nCS_CP_MALAMEML,0) + NVL(nCP_MALAMEML,0);
      nCS_CP_MALAMRKG := NVL(nCS_CP_MALAMRKG,0) + NVL(nCP_MALAMRKG,0);
      nCS_CP_MALAMRM2 := NVL(nCS_CP_MALAMRM2,0) + NVL(nCP_MALAMRM2,0);
      nCS_CP_MALAMRML := NVL(nCS_CP_MALAMRML,0) + NVL(nCP_MALAMRML,0);
      -----------------------TIEMPOS--------------------------
      vCF_MINUTOS_REAL_HORAS_TI := '00';
      vCP_MINUTOS_REAL_MINUTOS_TI := '00';
      nCF_CANTIPROD_TI := 0;
      nCF_VELOCIDAD_ESTANDAR_TI := 0;
      nCF_MINUTOS_ESTANDAR_TI := 0;
      nCP_MINUTOS_ESTANDAR_HORAS_TI := '00';
      nCP_MIN_ESTANDAR_MINUTOS_TI := '00';
      nCF_DESVIACION_TIE_TI := 0;
      vCP_DESVIACION_TIE_HORAS_TI := '00';
      vCP_DESVIACION_TIE_MINUTOS_TI := '00';
      nNumeOtua := 0;
      nCostOtim := 0;
      nCP_COSTTOTA_TI := 0;
      nCP_HORATOTA_TI := 0;
      nCP_COSTHORA_TI := 0;
      nCP_COSTTORE_TI := 0;
      nCP_HORATORE_TI := 0;
      nCP_COSTHORE_TI := 0;
      nCF_COSTE_TOTAL_ESTANDAR_TI := 0;
      nCF_COSTE_TOTAL_REAL_TI := 0;
      nCF_DESVIACION_COSTE_TOTAL_TI := 0;
      nCF_DESGLOSE_COSTE_HORA_TI := 0;
      nCF_DESGLOSE_VELOCIDAD_TI := 0;
      nCP_COSTHORA_SEC_TI := 0;
      nCP_COSTHORE_SEC_TI := 0;
      --
      bExisCabe := FALSE;
      --
      BEGIN
         --Se borran los conceptos calculados
         DELETE ANE_OBCOCALC WHERE EMPRESA = rOT.EMPRESA AND NUMERO_OT = rOT.NUMERO;
         --
         IF rOT.ROWID_OC IS NULL THEN
            INSERT INTO ANE_OBJECOST (EMPRESA,NUMERO_OT,FECHA_CIERRE_OT,CODIGO_CLIENTE,DESCRIPCION_CLIENTE,TIPO_ARTICULO,
                                      CODIGO_ARTICULO,DESCRIPCION_ARTICULO,MODIFICACION_ARTICULO,REVISION_ARTICULO,MATERIAL_BASE,
                                      NUMERO_OTT,NUMERO_PEDIDO,NUMERO_LINEA_PEDIDO,TIPO_PEDIDO,PEDIDO_NACIONAL_EXPORTACION,
                                      CANTIDAD_CERRADA_UNIDAD,UNIDAD_CANTIDAD_CERRADA,CANTIDAD_CERRADA_ML,CANTIDAD_CERRADA_ML_PRODUCCION,
                                      ANCHO_MM_ARTICULO,ANCHO_MM_PRODUCCION,NUMERO_DE_REPETICIONES,ERRORES_E_INCOSISTENCIAS,FECHA_CALCULO)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,rANE_OBJECOST.FECHA_CIERRE_OT,rANE_OBJECOST.CODIGO_CLIENTE,rANE_OBJECOST.DESCRIPCION_CLIENTE,rANE_OBJECOST.TIPO_ARTICULO,
                    rANE_OBJECOST.CODIGO_ARTICULO,rANE_OBJECOST.DESCRIPCION_ARTICULO,rANE_OBJECOST.MODIFICACION_ARTICULO,rANE_OBJECOST.REVISION_ARTICULO,rANE_OBJECOST.MATERIAL_BASE,
                    rANE_OBJECOST.NUMERO_OTT,rANE_OBJECOST.NUMERO_PEDIDO,rANE_OBJECOST.NUMERO_LINEA_PEDIDO,rANE_OBJECOST.TIPO_PEDIDO,rANE_OBJECOST.PEDIDO_NACIONAL_EXPORTACION,
                    rANE_OBJECOST.CANTIDAD_CERRADA_UNIDAD,rANE_OBJECOST.UNIDAD_CANTIDAD_CERRADA,rANE_OBJECOST.CANTIDAD_CERRADA_ML,rANE_OBJECOST.CANTIDAD_CERRADA_ML_PRODUCCION,
                    rANE_OBJECOST.ANCHO_MM_ARTICULO,rANE_OBJECOST.ANCHO_MM_PRODUCCION,rANE_OBJECOST.NUMERO_DE_REPETICIONES,rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS,rANE_OBJECOST.FECHA_CALCULO);
         ELSE
            UPDATE ANE_OBJECOST
            SET EMPRESA = rANE_OBJECOST.EMPRESA,NUMERO_OT = rANE_OBJECOST.NUMERO_OT,FECHA_CIERRE_OT = rANE_OBJECOST.FECHA_CIERRE_OT,CODIGO_CLIENTE = rANE_OBJECOST.CODIGO_CLIENTE,DESCRIPCION_CLIENTE = rANE_OBJECOST.DESCRIPCION_CLIENTE,TIPO_ARTICULO = rANE_OBJECOST.TIPO_ARTICULO,
                CODIGO_ARTICULO = rANE_OBJECOST.CODIGO_ARTICULO,DESCRIPCION_ARTICULO = rANE_OBJECOST.DESCRIPCION_ARTICULO,MODIFICACION_ARTICULO = rANE_OBJECOST.MODIFICACION_ARTICULO,REVISION_ARTICULO = rANE_OBJECOST.REVISION_ARTICULO,MATERIAL_BASE = rANE_OBJECOST.MATERIAL_BASE,
                NUMERO_OTT = rANE_OBJECOST.NUMERO_OTT,NUMERO_PEDIDO = rANE_OBJECOST.NUMERO_PEDIDO,NUMERO_LINEA_PEDIDO = rANE_OBJECOST.NUMERO_LINEA_PEDIDO,TIPO_PEDIDO = rANE_OBJECOST.TIPO_PEDIDO,PEDIDO_NACIONAL_EXPORTACION = rANE_OBJECOST.PEDIDO_NACIONAL_EXPORTACION,
                CANTIDAD_CERRADA_UNIDAD = rANE_OBJECOST.CANTIDAD_CERRADA_UNIDAD,UNIDAD_CANTIDAD_CERRADA = rANE_OBJECOST.UNIDAD_CANTIDAD_CERRADA,CANTIDAD_CERRADA_ML = rANE_OBJECOST.CANTIDAD_CERRADA_ML,CANTIDAD_CERRADA_ML_PRODUCCION = rANE_OBJECOST.CANTIDAD_CERRADA_ML_PRODUCCION,
                ANCHO_MM_ARTICULO = rANE_OBJECOST.ANCHO_MM_ARTICULO,ANCHO_MM_PRODUCCION = rANE_OBJECOST.ANCHO_MM_PRODUCCION,NUMERO_DE_REPETICIONES = rANE_OBJECOST.NUMERO_DE_REPETICIONES,ERRORES_E_INCOSISTENCIAS = rANE_OBJECOST.ERRORES_E_INCOSISTENCIAS,FECHA_CALCULO = rANE_OBJECOST.FECHA_CALCULO
            WHERE ROWID = rOT.ROWID_OC;
         END IF;
         --
         bExisCabe := TRUE;
      EXCEPTION
         WHEN OTHERS THEN
            bExisCabe := FALSE;
      END;
      --
      FOR rTiempos IN cTiempos(rOT.EMPRESA, rOT.NUMERO) LOOP
         nCF_CANTIPROD_TI := NULL;
         --
         OPEN cPasadas(rTiempos.ID_EMPRESA_TI,rTiempos.ID_ORDEN_TRABAJO_TI,rTiempos.ID_MAQUINA_TI);
         FETCH cPasadas INTO nCF_CANTIPROD_TI;
         CLOSE cPasadas;
         --
         nPRD_CAVAESAR := NULL;
         ---
         OPEN cPRD_CAVAESAR(rTiempos.ID_EMPRESA_TI,rOT.TIP_ARTI,rOT.COD_ARTI,rTiempos.ID_MAQUINA_TI);
         FETCH cPRD_CAVAESAR INTO nPRD_CAVAESAR;
         CLOSE cPRD_CAVAESAR;
         --
         IF NVL(nPRD_CAVAESAR,0) != 0 THEN
            nCF_VELOCIDAD_ESTANDAR_TI := nPRD_CAVAESAR;
         ELSE
            nCF_VELOCIDAD_ESTANDAR_TI := 0;
         END IF;
         --
	      IF NVL(nCF_VELOCIDAD_ESTANDAR_TI,0) != 0 THEN
	         nCF_MINUTOS_ESTANDAR_TI := NVL(nCF_CANTIPROD_TI,0) / NVL(nCF_VELOCIDAD_ESTANDAR_TI,0);
         ELSE
            nCF_MINUTOS_ESTANDAR_TI := 0;
	      END IF;
         --
         nCF_DESVIACION_TIE_TI := (NVL(nCF_MINUTOS_ESTANDAR_TI,0) - NVL(rTiempos.MINUTOS_REAL_TI,0));
         --
         vCP_DESVIACION_TIE_HORAS_TI := F_CeroIzqu(TRUNC(nCF_DESVIACION_TIE_TI/60));
         --
         vCP_DESVIACION_TIE_MINUTOS_TI := F_CeroIzqu(TRUNC(nCF_DESVIACION_TIE_TI - (TRUNC(nCF_DESVIACION_TIE_TI/60) * 60)));
         --
         nCP_MINUTOS_ESTANDAR_HORAS_TI := F_CeroIzqu(TRUNC(nCF_MINUTOS_ESTANDAR_TI/60));
         --
         nCP_MIN_ESTANDAR_MINUTOS_TI := F_CeroIzqu(TRUNC(nCF_MINUTOS_ESTANDAR_TI - (TRUNC(nCF_MINUTOS_ESTANDAR_TI/60) * 60)));
         --
         vCP_MINUTOS_REAL_MINUTOS_TI := F_CeroIzqu(TRUNC(rTiempos.MINUTOS_REAL_TI - (TRUNC(rTiempos.MINUTOS_REAL_TI/60) * 60)));
         --
         vCF_MINUTOS_REAL_HORAS_TI := (F_CeroIzqu(TRUNC(rTiempos.MINUTOS_REAL_TI/60)));
         -----
         nCP_COSTTOTA_TI := NULL;
         nCP_HORATOTA_TI := NULL;
         nCP_COSTHORA_SEC_TI := NULL;
         --
         nCP_COSTTORE_TI := NULL;
         nCP_HORATORE_TI := NULL;
         nCP_COSTHORE_SEC_TI := NULL;
         --
         nNumeOtua := NULL;
         nCostOtim := NULL;
         --
         IF rTiempos.ID_MAQUINA_TI != 'MONTAJE' THEN
            P_PRD_SECCANCO.P_CALCTOTA_SECCION_ESTANDAR(rOT.EMPRESA,rOT.ANNO,rTiempos.ID_MAQUINA_TI, 'H',
                                                       nCP_COSTTOTA_TI,nCP_HORATOTA_TI,nCP_COSTHORA_SEC_TI,
                                                       nNumeOtua,nCostOtim);
            --
            P_PRD_SECCANCO.P_CALCTOTA_SECCION_REAL(rOT.EMPRESA,rOT.ANNO,rTiempos.ID_MAQUINA_TI, 'H',
                                                   nCP_COSTTORE_TI,nCP_HORATORE_TI,nCP_COSTHORE_SEC_TI,
                                                   nNumeOtua,nCostOtim);
            --
            nCP_COSTHORA_TI := nCP_COSTHORA_SEC_TI;
            nCP_COSTHORE_TI := nCP_COSTHORE_SEC_TI;
         ELSE                  
            P_PRD_SECCANCO.P_CALCTOTA_SECCION_ESTANDAR(rOT.EMPRESA,rOT.ANNO,rTiempos.ID_MAQUINA_TI, 'O',
                                                       nCP_COSTTOTA_TI,nCP_HORATOTA_TI,nCostOtim,
                                                       nNumeOtua,nCP_COSTHORA_SEC_TI);
            --
            P_PRD_SECCANCO.P_CALCTOTA_SECCION_REAL(rOT.EMPRESA,rOT.ANNO,rTiempos.ID_MAQUINA_TI, 'O',
                                                   nCP_COSTTORE_TI,nCP_HORATORE_TI,nCostOtim,
                                                   nNumeOtua,nCP_COSTHORE_SEC_TI);
            --
            nCP_COSTHORA_TI := NULL;
            nCP_COSTHORE_TI := NULL;
         END IF;
         --
         IF rTiempos.ID_MAQUINA_TI != 'MONTAJE' THEN
            nCF_COSTE_TOTAL_ESTANDAR_TI := (NVL(nCP_COSTHORA_TI,0) * (NVL(nCF_MINUTOS_ESTANDAR_TI,0)/60));
         ELSE                  
            nCF_COSTE_TOTAL_ESTANDAR_TI := (NVL(nCP_COSTHORA_SEC_TI,0));
         END IF;
         --
         IF rTiempos.ID_MAQUINA_TI != 'MONTAJE' THEN
            nCF_COSTE_TOTAL_REAL_TI := (NVL(nCP_COSTHORE_TI,0) * (NVL(rTiempos.MINUTOS_REAL_TI,0)/60));
         ELSE                  
            nCF_COSTE_TOTAL_REAL_TI := (NVL(nCP_COSTHORE_SEC_TI,0));
         END IF;
         --
         nCF_DESVIACION_COSTE_TOTAL_TI := (nCF_COSTE_TOTAL_ESTANDAR_TI - nCF_COSTE_TOTAL_REAL_TI);
         --
         nCF_DESGLOSE_COSTE_HORA_TI := ((NVL(nCP_COSTHORA_TI,0) - NVL(nCP_COSTHORE_TI,0)) * (NVL(nCF_MINUTOS_ESTANDAR_TI,0)/60));
         --
         nCF_DESGLOSE_VELOCIDAD_TI := (nCF_DESVIACION_COSTE_TOTAL_TI - nCF_DESGLOSE_COSTE_HORA_TI);
         --
--TIEMPOS--
         nCS_MINUTOS_REAL_OT := NVL(nCS_MINUTOS_REAL_OT,0) + NVL(rTiempos.MINUTOS_REAL_TI,0);
         nCS_MINUTOS_ESTANDAR_OT := NVL(nCS_MINUTOS_ESTANDAR_OT,0) + NVL(nCF_MINUTOS_ESTANDAR_TI,0);
         nCS_CP_COSTHORA_OT := NVL(nCS_CP_COSTHORA_OT,0) + NVL(nCP_COSTHORA_SEC_TI,0);
         nCS_CP_COSTHORE_OT := NVL(nCS_CP_COSTHORE_OT,0) + NVL(nCP_COSTHORE_SEC_TI,0);
         nCS_CF_COSTE_TOTAL_ESTANDAR_TI := NVL(nCS_CF_COSTE_TOTAL_ESTANDAR_TI,0) + NVL(nCF_COSTE_TOTAL_ESTANDAR_TI,0);
         nCS_CF_COSTE_TOTAL_REAL_TI := NVL(nCS_CF_COSTE_TOTAL_REAL_TI,0) + NVL(nCF_COSTE_TOTAL_REAL_TI,0);
         nCS_CF_DESV_COSTE_TOTAL_T := NVL(nCS_CF_DESV_COSTE_TOTAL_T,0) + NVL(nCF_DESVIACION_COSTE_TOTAL_TI,0);
         nCS_CF_DESGLOSE_COSTE_HORA_TI := NVL(nCS_CF_DESGLOSE_COSTE_HORA_TI,0) + NVL(nCF_DESGLOSE_COSTE_HORA_TI,0);
         nCS_CF_DESGLOSE_VELOCIDAD_TI := NVL(nCS_CF_DESGLOSE_VELOCIDAD_TI,0) + NVL(nCF_DESGLOSE_VELOCIDAD_TI,0);
         --
         IF bExisCabe AND rTiempos.ID_MAQUINA_TI != 'MONTAJE' THEN
            BEGIN
               --Se insertan los Tiempos
               INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
               VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TIEMPOS '||rTiempos.ID_MAQUINA_TI,'T. ESTANDAR',nCF_MINUTOS_ESTANDAR_TI,nContInco + 1);
               --
               nContInco := nContInco + 1;
               --
               INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
               VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TIEMPOS '||rTiempos.ID_MAQUINA_TI,'T. REAL',rTiempos.MINUTOS_REAL_TI,nContInco + 1);
               --
               nContInco := nContInco + 1;
               --
               INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
               VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TIEMPOS '||rTiempos.ID_MAQUINA_TI,'DESVIACION',nCF_DESVIACION_TIE_TI,nContInco + 1);
               --
               nContInco := nContInco + 1;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         END IF;
      END LOOP;
      --
      nCS_CF_COSTE_TOTAL_ESTANDAR := NVL(nCS_CF_COSTE_TOTAL_ESTANDAR,0) + NVL(nCS_CF_COSTE_TOTAL_ESTANDAR_TI,0);
      nCS_CF_COSTE_TOTAL_REAL := NVL(nCS_CF_COSTE_TOTAL_REAL,0) + NVL(nCS_CF_COSTE_TOTAL_REAL_TI,0);
      --
      nCS_DESVIACION_TIE_OT := (NVL(nCS_MINUTOS_ESTANDAR_OT,0) - NVL(nCS_MINUTOS_REAL_OT,0));
      --
      vCP_DESVIACION_TIE_HORAS_OT := F_CeroIzqu(TRUNC(nCS_DESVIACION_TIE_OT/60));
	   --
	   vCP_DESVIACION_TIE_MINUTOS_OT := F_CeroIzqu(TRUNC(nCS_DESVIACION_TIE_OT - (TRUNC(nCS_DESVIACION_TIE_OT/60) * 60)));
	   --
	   vCP_MINUTOS_ESTANDAR_HORAS_OT := F_CeroIzqu(TRUNC(nCS_MINUTOS_ESTANDAR_OT/60));
	   --
	   vCP_MIN_ESTANDAR_MINUTOS_OT := F_CeroIzqu(TRUNC(nCS_MINUTOS_ESTANDAR_OT - (TRUNC(nCS_MINUTOS_ESTANDAR_OT/60) * 60)));
	   --
	   vCP_MINUTOS_REAL_MINUTOS_OT := F_CeroIzqu(TRUNC(nCS_MINUTOS_REAL_OT - (TRUNC(nCS_MINUTOS_REAL_OT/60) * 60)));
	   --
      vCF_MINUTOS_REAL_HORAS_OT := (F_CeroIzqu(TRUNC(nCS_MINUTOS_REAL_OT/60)));
      --
      IF bExisCabe THEN
         BEGIN
            --Se insertan los Tiempos Totales
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TIEMPOS TOTALES','T. ESTANDAR',nCS_MINUTOS_ESTANDAR_OT,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TIEMPOS TOTALES','T. REAL',nCS_MINUTOS_REAL_OT,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TIEMPOS TOTALES','DESVIACION',nCS_DESVIACION_TIE_OT,nContInco + 1);
            --
            nContInco := nContInco + 1;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END IF;
      --
      nCF_VELOCIDAD_REAL_ML := 0;
      nCF_VELOCIDAD_ESTANDAR_ML := 0;
      nCF_DESVIACION_VEL_ML := 0;
      --
      FOR rVelocidad IN cVelocidad(rOT.EMPRESA, rOT.NUMERO) LOOP
         nEventos := NULL;
         --
         OPEN cEventos(rOT.EMPRESA, rOT.NUMERO, rVelocidad.ID_MAQUINA_ML);
         FETCH cEventos INTO nEventos;
         CLOSE cEventos;
         --
         IF NVL(nEventos,0) != 0 THEN
            nCF_VELOCIDAD_REAL_ML := rVelocidad.CANTPROD_ML / nEventos;
         ELSE
            nCF_VELOCIDAD_REAL_ML := 0;
         END IF;
         --
         nPRD_CAVAESAR := NULL;
         --
         OPEN cPRD_CAVAESAR(rOT.EMPRESA, rOT.TIP_ARTI, rOT.COD_ARTI, rVelocidad.ID_MAQUINA_ML);
         FETCH cPRD_CAVAESAR INTO nPRD_CAVAESAR;
         CLOSE cPRD_CAVAESAR;
         --
         IF NVL(nPRD_CAVAESAR,0) != 0 THEN
            nCF_VELOCIDAD_ESTANDAR_ML := nPRD_CAVAESAR;
         ELSE
            nCF_VELOCIDAD_ESTANDAR_ML := 0;
         END IF;
         --
         nCF_DESVIACION_VEL_ML := (nCF_VELOCIDAD_ESTANDAR_ML - nCF_VELOCIDAD_REAL_ML);
         --
         IF bExisCabe THEN
            BEGIN
               --Se insertan los Velocidades
               INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
               VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'VELOCIDADES '||rVelocidad.ID_MAQUINA_ML,'V. ESTANDAR',nCF_VELOCIDAD_ESTANDAR_ML,nContInco + 1);
               --
               nContInco := nContInco + 1;
               --
               INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
               VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'VELOCIDADES '||rVelocidad.ID_MAQUINA_ML,'V. REAL',nCF_VELOCIDAD_REAL_ML,nContInco + 1);
               --
               nContInco := nContInco + 1;
               --
               INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
               VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'VELOCIDADES '||rVelocidad.ID_MAQUINA_ML,'DESVIACION',nCF_DESVIACION_VEL_ML,nContInco + 1);
               --
               nContInco := nContInco + 1;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         END IF;
      END LOOP;
      --Calculo de Costes de Departamentos
      nCF_SUM_DEPARTAM := CF_SUM_DEPARTAM(rOT.EMPRESA,  rOT.NUMERO,
                                          rOT.FECHA_CIERRE);
      --
      nCF_SUM_DEPARTAM_E := CF_SUM_DEPARTAM_E(rOT.EMPRESA,  rOT.NUMERO,
                                              rOT.FECHA_CIERRE);
      --
      nCF_GRABADOS := CF_GRABADOS(rOT.EMPRESA,  rOT.NUMERO, rOT.ANNO,
                                  rOT.FECHA_CIERRE);
      --
      nCF_CALCULOS := CF_CALCULOS;
      -----------------------TINTAS---------------------------
      nCF_TINTAS := CF_TINTAS(rOT.EMPRESA,  rOT.NUMERO,
                              rOT.TIP_ARTI, rOT.COD_ARTI,
                              rOT.MODI,     rOT.REVI,
                              rOT.FECHA_CIERRE);
      --
      nCS_CP_TOCODIES_CS := NVL(nCS_CP_TOCODIES_CS,0) + NVL(nCS_CP_TOCODIES,0);
      nCS_CP_TOCODIRE_CS := NVL(nCS_CP_TOCODIRE_CS,0) + NVL(nCS_CP_TOCODIRE,0);
      --
      IF bExisCabe THEN
         BEGIN
            --Se insertan los calculos de Objetivos de Costes
            --ESTANDAR
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMIDOS','KG ESTANDAR',nCP_MALACEKG,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMIDOS','M2 ESTANDAR',nCP_MALACEM2,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMIDOS','ML ESTANDAR',nCP_MALACEML,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMIDOS','EUROS ESTANDAR',nCP_COCOESTA,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'FACTURADOS','KG ESTANDAR',nCP_MALAFAKG,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'FACTURADOS','M2 ESTANDAR',nCP_MALAFAM2,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'FACTURADOS','ML ESTANDAR',nCP_MALAFAML,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'FACTURADOS','EUROS ESTANDAR',nCP_COLAESTA,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMA TOTAL','KG ESTANDAR',nCP_MALAMEKG,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMA TOTAL','M2 ESTANDAR',nCP_MALAMEM2,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMA TOTAL','ML ESTANDAR',nCP_MALAMEML,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMA TOTAL','EUROS ESTANDAR',nCP_COMTESTA,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'% MERMA TOTAL','KG ESTANDAR',nCP_POMTESUN_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'% MERMA TOTAL','M2 ESTANDAR',nCP_POMTESUN_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'% MERMA TOTAL','ML ESTANDAR',nCP_POMTESUN_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'% MERMA TOTAL','EUROS ESTANDAR',nCP_POMTESEU_EU,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --REAL
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMIDOS','KG REAL',nCP_MALACRKG,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMIDOS','M2 REAL',nCP_MALACRM2,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMIDOS','ML REAL',nCP_MALACRML,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMIDOS','EUROS REAL',nCP_COCOREAL,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'FACTURADOS','KG REAL',nCP_MALAFAKG,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'FACTURADOS','M2 REAL',nCP_MALAFAM2,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'FACTURADOS','ML REAL',nCP_MALAFAML,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'FACTURADOS','EUROS REAL',nCP_COLAREAL,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMA TOTAL','KG REAL',nCP_MALAMRKG,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMA TOTAL','M2 REAL',nCP_MALAMRM2,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMA TOTAL','ML REAL',nCP_MALAMRML,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMA TOTAL','EUROS REAL',nCP_COMTREAL,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'% MERMA TOTAL','KG REAL',nCP_POMTREUN_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'% MERMA TOTAL','M2 REAL',nCP_POMTREUN_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'% MERMA TOTAL','ML REAL',nCP_POMTREUN_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'% MERMA TOTAL','EUROS REAL',nCP_POMTREEU_EU,nContInco + 1);
            --
            nContInco := nContInco + 1;
            ------------------------------------------------------------------------------------------------------------
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'INGRESOS: Cantidad cerrada en la ud de venta x precio de venta del pedido.','EUROS ESTANDAR',nCS_CP_PRECIO_FAC,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'INGRESOS: Cantidad cerrada en la ud de venta x precio de venta del pedido.','EUROS REAL',nCS_CP_PRECIO_FAC,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'ABONOS POR DIFERENCIAS DE PRECIOS Y CANTIDAD','EUROS ESTANDAR',nCS_CP_ABONESTA,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'ABONOS POR DIFERENCIAS DE PRECIOS Y CANTIDAD','EUROS REAL',nCS_CP_ABONREAL,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --CONSUMOS DE LAMINA
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE LAMINA','EUROS ESTANDAR',nCS_CP_COLAESTA,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE LAMINA','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POCLESTA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE LAMINA','EUROS REAL',nCS_CP_COLAREAL,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE LAMINA','% SOBRE INGRESOS NETOS REAL',nCP_POCLREAL_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE LAMINA','EUROS REAL - ESTANDAR',nCP_DIFEFAEU_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE LAMINA','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOFAEU_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --CONSUMOS DE TINTAS
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE TINTAS','EUROS ESTANDAR',nCS_CP_TOCODIES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE TINTAS','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POCTESTA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE TINTAS','EUROS REAL',nCS_CP_TOCODIRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE TINTAS','% SOBRE INGRESOS NETOS REAL',nCP_POCTREAL_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE TINTAS','EUROS REAL - ESTANDAR',nCP_DIFECOTI_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CONSUMOS DE TINTAS','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOCOTI_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --TOTAL CONSUMOS
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL CONSUMOS','EUROS ESTANDAR',nCP_TOTACOES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL CONSUMOS','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POTOCOES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL CONSUMOS','EUROS REAL',nCP_TOTACORE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL CONSUMOS','% SOBRE INGRESOS NETOS REAL',nCP_POTOCORE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL CONSUMOS','EUROS REAL - ESTANDAR',nCP_DIFETOCO_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL CONSUMOS','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOTOCO_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --MERMAS DE PRODUCCION
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMAS DE PRODUCCION','EUROS ESTANDAR',nCS_CP_COMTESTA,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMAS DE PRODUCCION','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POMEPRES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMAS DE PRODUCCION','EUROS REAL',nCS_CP_COMTREAL,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMAS DE PRODUCCION','% SOBRE INGRESOS NETOS REAL',nCP_POMEPRRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMAS DE PRODUCCION','EUROS REAL - ESTANDAR',nCP_DIFEMTEU_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MERMAS DE PRODUCCION','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOMTEU_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --COSTE DE LOS PRODUCTOS VENDIDOS
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTE DE LOS PRODUCTOS VENDIDOS','EUROS ESTANDAR',nCP_COPRVEES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTE DE LOS PRODUCTOS VENDIDOS','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POCOPVES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTE DE LOS PRODUCTOS VENDIDOS','EUROS REAL',nCP_COPRVERE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTE DE LOS PRODUCTOS VENDIDOS','% SOBRE INGRESOS NETOS REAL',nCP_POCOPVRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTE DE LOS PRODUCTOS VENDIDOS','EUROS REAL - ESTANDAR',nCP_DICOPRVE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTE DE LOS PRODUCTOS VENDIDOS','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DPCOPRVE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --MARGEN SOBRE LOS MATERIALES
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN SOBRE LOS MATERIALES','EUROS ESTANDAR',nCP_MAMAESTA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN SOBRE LOS MATERIALES','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POMAMAES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN SOBRE LOS MATERIALES','EUROS REAL',nCP_MAMAREAL_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN SOBRE LOS MATERIALES','% SOBRE INGRESOS NETOS REAL',nCP_POMAMARE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN SOBRE LOS MATERIALES','EUROS REAL - ESTANDAR',nCP_DIFEMAMA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN SOBRE LOS MATERIALES','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOMAMA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --MANO DE OBRA DE PRODUCCION DIRECTA E INDIRECTA
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MANO DE OBRA DE PRODUCCION DIRECTA E INDIRECTA','EUROS ESTANDAR',nCS_CF_COSTE_TOTAL_ESTANDAR,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MANO DE OBRA DE PRODUCCION DIRECTA E INDIRECTA','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POCMOPES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MANO DE OBRA DE PRODUCCION DIRECTA E INDIRECTA','EUROS REAL',nCS_CF_COSTE_TOTAL_REAL,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MANO DE OBRA DE PRODUCCION DIRECTA E INDIRECTA','% SOBRE INGRESOS NETOS REAL',nCP_POCMOPRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MANO DE OBRA DE PRODUCCION DIRECTA E INDIRECTA','EUROS REAL - ESTANDAR',nCP_DIFECMOP_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MANO DE OBRA DE PRODUCCION DIRECTA E INDIRECTA','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOCMOP_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --OTROS COSTES DE PRODUCCION
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'OTROS COSTES DE PRODUCCION','EUROS ESTANDAR',nCP_SUM_OTROCOST_E,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'OTROS COSTES DE PRODUCCION','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POOTCPES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'OTROS COSTES DE PRODUCCION','EUROS REAL',nCP_SUM_OTROCOST_R,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'OTROS COSTES DE PRODUCCION','% SOBRE INGRESOS NETOS REAL',nCP_POOTCPRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'OTROS COSTES DE PRODUCCION','EUROS REAL - ESTANDAR',nCP_DIFEOTCP_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'OTROS COSTES DE PRODUCCION','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOOTCP_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --MARGEN DE PRODUCCION
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE PRODUCCION','EUROS ESTANDAR',nCP_MARGPRES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE PRODUCCION','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POMAPRES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE PRODUCCION','EUROS REAL',nCP_MARGPRRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE PRODUCCION','% SOBRE INGRESOS NETOS REAL',nCP_POMAPRRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE PRODUCCION','EUROS REAL - ESTANDAR',nCP_DIFEMAPR_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE PRODUCCION','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOMAPR_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --CALIDAD
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CALIDAD','EUROS ESTANDAR',nCP_SUM_CALIDAD_E,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CALIDAD','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POCALIES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CALIDAD','EUROS REAL',nCP_SUM_CALIDAD_R,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CALIDAD','% SOBRE INGRESOS NETOS REAL',nCP_POCALIRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CALIDAD','EUROS REAL - ESTANDAR',nCP_DIFECALI_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CALIDAD','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOCALI_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --LOGISTICA INTERNA
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'LOGISTICA INTERNA','EUROS ESTANDAR',nCP_SUM_LOGIINTE_E,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'LOGISTICA INTERNA','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POLOINES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'LOGISTICA INTERNA','EUROS REAL',nCP_SUM_LOGIINTE_R,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'LOGISTICA INTERNA','% SOBRE INGRESOS NETOS REAL',nCP_POLOINRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'LOGISTICA INTERNA','EUROS REAL - ESTANDAR',nCP_DIFELOIN_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'LOGISTICA INTERNA','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOLOIN_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --ALMACEN
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'ALMACEN','EUROS ESTANDAR',nCP_SUM_ALMACEN_E,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'ALMACEN','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POALMAES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'ALMACEN','EUROS REAL',nCP_SUM_ALMACEN_R,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'ALMACEN','% SOBRE INGRESOS NETOS REAL',nCP_POALMARE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'ALMACEN','EUROS REAL - ESTANDAR',nCP_DIFEALMA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'ALMACEN','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOALMA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --TOTAL COSTES SOPORTE DE PRODUCCION
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL COSTES SOPORTE DE PRODUCCION','EUROS ESTANDAR',nCP_TOCOSPES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL COSTES SOPORTE DE PRODUCCION','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POTCSPES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL COSTES SOPORTE DE PRODUCCION','EUROS REAL',nCP_TOCOSPRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL COSTES SOPORTE DE PRODUCCION','% SOBRE INGRESOS NETOS REAL',nCP_POTCSPRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL COSTES SOPORTE DE PRODUCCION','EUROS REAL - ESTANDAR',nCP_DIFETCSP_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'TOTAL COSTES SOPORTE DE PRODUCCION','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOTCSP_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --MARGEN INDUSTRIAL
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN INDUSTRIAL','EUROS ESTANDAR',nCP_MAINESTA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN INDUSTRIAL','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POMAINES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN INDUSTRIAL','EUROS REAL',nCP_MAINREAL_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN INDUSTRIAL','% SOBRE INGRESOS NETOS REAL',nCP_POMAINRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN INDUSTRIAL','EUROS REAL - ESTANDAR',nCP_DIFEMAIN_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN INDUSTRIAL','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOMAIN_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --COSTES DE COMERCIALIZACION
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE COMERCIALIZACION','EUROS ESTANDAR',nCP_SUM_COSTCOME_E,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE COMERCIALIZACION','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POCOCOES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE COMERCIALIZACION','EUROS REAL',nCP_SUM_COSTCOME_R,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE COMERCIALIZACION','% SOBRE INGRESOS NETOS REAL',nCP_POCOCORE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE COMERCIALIZACION','EUROS REAL - ESTANDAR',nCP_DIFECOCO_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE COMERCIALIZACION','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOCOCO_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --MARGEN COMERCIAL
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN COMERCIAL','EUROS ESTANDAR',nCP_MACOESTA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN COMERCIAL','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POMACOES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN COMERCIAL','EUROS REAL',nCP_MACOREAL_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN COMERCIAL','% SOBRE INGRESOS NETOS REAL',nCP_POMACORE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN COMERCIAL','EUROS REAL - ESTANDAR',nCP_DIFEMACO_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN COMERCIAL','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOMACO_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --COSTES DE DISTRIBUCION
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE DISTRIBUCION','EUROS ESTANDAR',nCP_SUM_COSTDIST_E,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE DISTRIBUCION','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POCODIES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE DISTRIBUCION','EUROS REAL',nCP_SUM_COSTDIST_R,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE DISTRIBUCION','% SOBRE INGRESOS NETOS REAL',nCP_POCODIRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE DISTRIBUCION','EUROS REAL - ESTANDAR',nCP_DIFECODI_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES DE DISTRIBUCION','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOCODI_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --MARGEN DE CONTRIBUCION
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE CONTRIBUCION','EUROS ESTANDAR',nCP_MARCESTA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE CONTRIBUCION','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POMARCES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE CONTRIBUCION','EUROS REAL',nCP_MARCREAL_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE CONTRIBUCION','% SOBRE INGRESOS NETOS REAL',nCP_POMARCRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE CONTRIBUCION','EUROS REAL - ESTANDAR',nCP_DIFEMARC_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE CONTRIBUCION','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOMARC_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --COSTES ADMINISTRATIVOS
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES ADMINISTRATIVOS','EUROS ESTANDAR',nCP_SUM_COSTADMI_E,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES ADMINISTRATIVOS','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POCOADES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES ADMINISTRATIVOS','EUROS REAL',nCP_SUM_COSTADMI_R,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES ADMINISTRATIVOS','% SOBRE INGRESOS NETOS REAL',nCP_POCOADRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES ADMINISTRATIVOS','EUROS REAL - ESTANDAR',nCP_DIFECOAD_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES ADMINISTRATIVOS','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOCOAD_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --EBITDA
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'EBITDA','EUROS ESTANDAR',nCP_MAEBESTA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'EBITDA','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POMAEBES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'EBITDA','EUROS REAL',nCP_MAEBREAL_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'EBITDA','% SOBRE INGRESOS NETOS REAL',nCP_POMAEBRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'EBITDA','EUROS REAL - ESTANDAR',nCP_DIFEMAEB_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'EBITDA','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOMAEB_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --COSTES FINANCIEROS
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES FINANCIEROS','EUROS ESTANDAR',nCS_CP_COFIESTA,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES FINANCIEROS','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POCOFIES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES FINANCIEROS','EUROS REAL',nCS_CP_COFIREAL,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES FINANCIEROS','% SOBRE INGRESOS NETOS REAL',nCP_POCOFIRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES FINANCIEROS','EUROS REAL - ESTANDAR',nCP_DIFECOFI_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'COSTES FINANCIEROS','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOCOFI_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --CASH FLOW OPERATIVO
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO','EUROS ESTANDAR',nCP_CFOPESTA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POCFOPES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO','EUROS REAL',nCP_CFOPREAL_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO','% SOBRE INGRESOS NETOS REAL',nCP_POCFOPRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO','EUROS REAL - ESTANDAR',nCP_DIFECFOP_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOCFOP_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --MARGEN DE GRABADOS
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE GRABADOS','EUROS ESTANDAR',nCP_MAGRESTA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE GRABADOS','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POMAGRES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE GRABADOS','EUROS REAL',nCS_CP_RESUPREI,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE GRABADOS','% SOBRE INGRESOS NETOS REAL',nCP_POMAGRRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE GRABADOS','EUROS REAL - ESTANDAR',nCP_DIFEMAGR_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'MARGEN DE GRABADOS','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOMAGR_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --CASH FLOW OPERATIVO + MARGEN DE GRABADOS
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO + MARGEN DE GRABADOS','EUROS ESTANDAR',nCP_CFMGESTA_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO + MARGEN DE GRABADOS','% SOBRE INGRESOS NETOS ESTANDAR',nCP_POCFMGES_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO + MARGEN DE GRABADOS','EUROS REAL',nCP_CFMGREAL_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO + MARGEN DE GRABADOS','% SOBRE INGRESOS NETOS REAL',nCP_POCFMGRE_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO + MARGEN DE GRABADOS','EUROS REAL - ESTANDAR',nCP_DIFECFMG_CS,nContInco + 1);
            --
            nContInco := nContInco + 1;
            --
            INSERT INTO ANE_OBCOCALC(EMPRESA,NUMERO_OT,CONCEPTO,ETIQUETA_VALOR_CONCEPTO,VALOR_CONCEPTO,ORDEN_EN_INFORME)
            VALUES (rANE_OBJECOST.EMPRESA,rANE_OBJECOST.NUMERO_OT,'CASH FLOW OPERATIVO + MARGEN DE GRABADOS','% SOBRE INGRESOS NETOS REAL- ESTANDAR',nCP_DIPOCFMG_CS,nContInco + 1);
            --
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END IF;
   END LOOP;
end;
/
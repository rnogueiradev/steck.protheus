/****************************************
MSTECK02
Ação.........: Rotina de geração de Planilha de Faturamento
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 09/09/2021
Chamado......: 20211014021957
****************************************/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "TBICODE.ch"

USER FUNCTION MSTECK02()
LOCAL _cLockBy := ""
PRIVATE oMes
PRIVATE cMes := SPACE(02)
PRIVATE oAno
PRIVATE cAno := SPACE(04)
PRIVATE oDir
PRIVATE cDir := SPACE(100)
PRIVATE oBtOk
PRIVATE oBtSair
PRIVATE oBtSel
PRIVATE dDtIni  := ""
PRIVATE dDtFim  := ""
PRIVATE dDtRef  := ""

//// Verifica se está chamando via JOB
If Select("SX2")==0
  PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'
  IF !LockByName(_cLockBy,.F.,.F.,.T.)
    RETURN
  ELSE
    _cLockBy		:= "MSTECK02"
    cDir := GetSrvProfString ("STARTPATH","") 
    cAno := ALLTRIM(STR(YEAR(DATE())))
    cMes := ALLTRIM(STR(Month(DATE())))
    MSTECK2B()
    UnLockByName(_cLockBy,.F.,.F.,.T.)
    RESET ENVIRONMENT
  ENDIF 
ELSE
  IF !LockByName(_cLockBy,.F.,.F.,.T.)
    RETURN
  ELSE
    //// Chama a Tela de parâmetros
    MSTECK2A()
    UnLockByName(_cLockBy,.F.,.F.,.T.)
  ENDIF
ENDIF
RETURN

STATIC FUNCTION MSTECK2A()
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Planilha de Faturamento" FROM 000, 000  TO 200, 500 PIXEL

    @ 015, 012 SAY "Informe o Mês de Referência:" SIZE 073, 007 OF oDlg PIXEL
    @ 013, 090 MSGET oMes VAR cMes SIZE 012, 010 OF oDlg PIXEL
    @ 030, 012 SAY "Informe o Ano de Referência:" SIZE 070, 007 OF oDlg PIXEL
    @ 028, 090 MSGET oAno VAR cAno SIZE 021, 010 OF oDlg PIXEL
    @ 045, 012 SAY "Informe o diretório:" SIZE 070, 007 OF oDlg PIXEL
    @ 060, 180 BUTTON oBtSel  PROMPT "Selecionar" SIZE 037, 012 OF oDlg ACTION(FileDlg()) PIXEL
    @ 060, 012 MSGET oDir VAR cDir SIZE 150, 010 OF oDlg PIXEL WHEN .F.
    @ 080, 013 BUTTON oBtOk   PROMPT "Confirmar"  SIZE 037, 012 OF oDlg ACTION(MsgMeter({|oMeter,oText,oDlgP,lEnd|MSTECK2B(oMeter,oText,oDlgP,lEnd)},"Carregando Informações...", "Carregando Informações..."),oDlg:End()) PIXEL
    @ 080, 079 BUTTON oBtSair PROMPT "Fechar"     SIZE 037, 012 OF oDlg ACTION(oDlg:End()) PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

RETURN

STATIC FUNCTION MSTECK2B(oMeter,oText,oDlgP,lEnd)
LOCAL nCount  := 0
//LOCAL cArqXml := cDir+"\STK_FAT"+ALLTRIM(cAno)+ALLTRIM(cMes)+"_"+DTOS(DATE())+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+SUBSTR(TIME(),7,2)+".XLS"
LOCAL cArqXml := "\arquivos\SFTP-INTEGRAÇÕES\STECKCONECTA\PENDING\STK_FAT"+ALLTRIM(cAno)+ALLTRIM(cMes)+"_"+DTOS(DATE())+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+SUBSTR(TIME(),7,2)+".XLS"
////D:\TOTVS\Microsiga\Protheus12\PROTHEUS_DATA_DIST\arquivos\SFTP-INTEGRAÇÕES\STECKCONECTA\PENDING
LOCAL aVetor := {}
LOCAL i := 0
LOCAL oFWMsExcel
LOCAL dDtIni := cAno+cMes+"01"
LOCAL dDtFim := DTOS(LASTDATE(STOD(cAno+cMes+"01")))

IF IsBlind() = .F.
  //// Contador da barra
  oMeter:nTotal := 100
ENDIF

cQuery := ""

cQuery += " SELECT EMISSAO      F2_EMISSAO,
cQuery += "        CODIGO       F2_CLIENTE,
cQuery += "        RAZAO_SOCIAL A1_NOME,
cQuery += "        GRUPO_VENDAS A1_GRPVEN,
cQuery += "        ACY_DESCRI,
cQuery += "        AGRUPAMENTO  X5_DESCRI,
cQuery += "        DESC_GRUPO   BM_DESC,
cQuery += "        PRODUTO      B1_COD,
cQuery += "        DESCRICAO    B1_DESC,
cQuery += "        LIQUIDO      D2_TOTAL,
cQuery += "        QUANTIDADE   D2_QUANT
cQuery += " FROM   (SELECT 'SP'                            AS EMPRESA,
cQuery += "                'FAT'                           AS MODALIDADE,
cQuery += "                F2_DOC                          AS NOTA_FISCAL,
cQuery += "                F2_EMISSAO                      AS EMISSAO,
cQuery += "                D2_QUANT                        AS QUANTIDADE,
cQuery += "                D2_COD                          AS PRODUTO,
cQuery += "                SB1.B1_DESC                     AS DESCRICAO,
cQuery += "                Nvl(Trim(TX5.X5_DESCRI), 'N/A') AS AGRUPAMENTO,
cQuery += "                Nvl(BM_DESC, 'SEM GRUPO')       AS DESC_GRUPO,
cQuery += "                A1_GRPVEN                       AS GRUPO_VENDAS,
cQuery += "                ACY_DESCRI,
cQuery += "                A1_COD                          AS CODIGO,
cQuery += "                A1_NOME                         AS RAZAO_SOCIAL,
cQuery += "                SD2.R_E_C_N_O_                  AS RECNO,
cQuery += "                SD2.D2_TOTAL - SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6
cQuery += "                - D2_DIFAL
cQuery += "                - D2_ICMSCOM                    AS LIQUIDO
cQuery += "         FROM   SD2110 SD2
cQuery += "                INNER JOIN(SELECT *
cQuery += "                           FROM   SA1110)SA1
cQuery += "                        ON SA1.D_E_L_E_T_ = ' '
cQuery += "                           AND A1_COD = D2_CLIENTE
cQuery += "                           AND A1_LOJA = D2_LOJA
cQuery += "                           AND SA1.A1_GRPVEN <> 'ST'
cQuery += "                           AND SA1.A1_GRPVEN <> 'SC'
cQuery += "                           AND SA1.A1_EST <> 'EX'
cQuery += "                LEFT JOIN ACY110 CY
cQuery += "                       ON CY.D_E_L_E_T_ = ' '
cQuery += "                          AND CY.ACY_GRPVEN = SA1.A1_GRPVEN
cQuery += "                LEFT JOIN SC5110 C5
cQuery += "                       ON C5_FILIAL = D2_FILIAL
cQuery += "                          AND C5_NUM = D2_PEDIDO
cQuery += "                          AND C5.D_E_L_E_T_ = ' '
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                           FROM   SF2110)SF2
cQuery += "                        ON SF2.D_E_L_E_T_ = ' '
cQuery += "                           AND F2_DOC = D2_DOC
cQuery += "                           AND F2_SERIE = D2_SERIE
cQuery += "                           AND F2_FILIAL = D2_FILIAL
cQuery += "                INNER JOIN(SELECT *
cQuery += "                           FROM   SB1110)SB1
cQuery += "                        ON SB1.D_E_L_E_T_ = ' '
cQuery += "                           AND SB1.B1_COD = D2_COD
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   UDBP12.SB1030)TB1
cQuery += "                       ON TB1.D_E_L_E_T_ = ' '
cQuery += "                          AND TB1.B1_COD = D2_COD
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SBM110)SBM
cQuery += "                       ON SBM.D_E_L_E_T_ = ' '
cQuery += "                          AND BM_GRUPO = SB1.B1_GRUPO
cQuery += "                          AND SBM.BM_XAGRUP <> ' '
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SA3110)SA3
cQuery += "                       ON SA3.D_E_L_E_T_ = ' '
cQuery += "                          AND SA3.A3_COD = F2_VEND1
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SA3110)TA3
cQuery += "                       ON TA3.D_E_L_E_T_ = ' '
cQuery += "                          AND TA3.A3_COD = SA3.A3_SUPER
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SX5110)SX5
cQuery += "                       ON SX5.X5_TABELA = 'A2'
cQuery += "                          AND SX5.X5_CHAVE = SA1.A1_REGIAO
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SX5110)TX5
cQuery += "                       ON Trim(TX5.X5_TABELA) = 'ZZ'
cQuery += "                          AND Trim(TX5.X5_CHAVE) = Trim(SBM.BM_XAGRUP)
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   UDBP12.SB9030)SB9
cQuery += "                       ON SB9.D_E_L_E_T_ = ' '
cQuery += "                          AND SB9.B9_FILIAL = '01'
cQuery += "                          AND SB9.B9_COD = SD2.D2_COD
cQuery += "                          AND Substr(SB9.B9_DATA, 1, 6) =
cQuery += "                              Substr(D2_EMISSAO, 1, 6)
cQuery += "                          AND SB9.B9_LOCAL = '15'
cQuery += "                          AND SB1.B1_CLAPROD = 'C'
cQuery += "                          AND TB1.B1_CLAPROD = 'F'
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SB9110)TB9
cQuery += "                       ON TB9.D_E_L_E_T_ = ' '
cQuery += "                          AND TB9.B9_FILIAL = '01'
cQuery += "                          AND TB9.B9_COD = SD2.D2_COD
cQuery += "                          AND Substr(TB9.B9_DATA, 1, 6) =
cQuery += "                              Substr(D2_EMISSAO, 1, 6)
cQuery += "                          AND TB9.B9_LOCAL = '03'
cQuery += "         WHERE  SD2.D_E_L_E_T_ = ' ' 
cQuery += "                AND SD2.D2_CF IN ("+AllTrim(GetMV("ST_CFOPVEN",,""))+")
cQuery += "                AND Substr(D2_EMISSAO, 1, 6) = '"+substr(dtos(date()),1,6)+"' 
cQuery += "               AND F2_TIPO='N'
cQuery += "         UNION
cQuery += "         SELECT 'AM'                            AS EMPRESA,
cQuery += "                'FAT'                           AS MODALIDADE,
cQuery += "                F2_DOC                          AS NOTA_FISCAL,
cQuery += "                F2_EMISSAO                      AS EMISSAO,
cQuery += "                D2_QUANT                        AS QUANTIDADE,
cQuery += "                D2_COD                          AS PRODUTO,
cQuery += "                SB1.B1_DESC                     AS DESCRICAO,
cQuery += "                Nvl(Trim(TX5.X5_DESCRI), 'N/A') AS AGRUPAMENTO,
cQuery += "                Nvl(BM_DESC, 'SEM GRUPO')       AS DESC_GRUPO,
cQuery += "                A1_GRPVEN                       AS GRUPO_VENDAS,
cQuery += "                ACY_DESCRI,
cQuery += "                A1_COD                          AS CODIGO,
cQuery += "                A1_NOME                         AS RAZAO_SOCIAL,
cQuery += "                SD2.R_E_C_N_O_                  AS RECNO,
cQuery += "                SD2.D2_TOTAL - SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6
cQuery += "                - D2_DIFAL
cQuery += "                - D2_ICMSCOM                    AS LIQUIDO
cQuery += "         FROM   UDBP12.SD2030 SD2
cQuery += "                INNER JOIN(SELECT *
cQuery += "                           FROM   UDBP12.SA1030)SA1
cQuery += "                        ON SA1.D_E_L_E_T_ = ' '
cQuery += "                           AND A1_COD = D2_CLIENTE
cQuery += "                           AND A1_LOJA = D2_LOJA
cQuery += "                           AND SA1.A1_GRPVEN <> 'ST'
cQuery += "                           AND SA1.A1_GRPVEN <> 'SC'
cQuery += "                           AND SA1.A1_EST <> 'EX'
cQuery += "                LEFT JOIN ACY110 CY
cQuery += "                       ON CY.D_E_L_E_T_ = ' '
cQuery += "                          AND CY.ACY_GRPVEN = SA1.A1_GRPVEN
cQuery += "                INNER JOIN(SELECT *
cQuery += "                           FROM   UDBP12.SF2030)SF2
cQuery += "                        ON SF2.D_E_L_E_T_ = ' '
cQuery += "                           AND F2_DOC = D2_DOC
cQuery += "                           AND F2_SERIE = D2_SERIE
cQuery += "                           AND F2_FILIAL = D2_FILIAL
cQuery += "                INNER JOIN(SELECT *
cQuery += "                           FROM   SB1110)SB1
cQuery += "                        ON SB1.D_E_L_E_T_ = ' '
cQuery += "                           AND SB1.B1_COD = D2_COD
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   UDBP12.SB1030)TB1
cQuery += "                       ON TB1.D_E_L_E_T_ = ' '
cQuery += "                          AND TB1.B1_COD = D2_COD
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SBM110)SBM
cQuery += "                       ON SBM.D_E_L_E_T_ = ' '
cQuery += "                          AND BM_GRUPO = SB1.B1_GRUPO
cQuery += "                          AND SBM.BM_XAGRUP <> ' '
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   UDBP12.SA3030)SA3
cQuery += "                       ON SA3.D_E_L_E_T_ = ' '
cQuery += "                          AND SA3.A3_COD = F2_VEND1
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   UDBP12.SA3030)TA3
cQuery += "                       ON TA3.D_E_L_E_T_ = ' '
cQuery += "                          AND TA3.A3_COD = SA3.A3_SUPER
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   UDBP12.SX5030)SX5
cQuery += "                       ON SX5.X5_TABELA = 'A2'
cQuery += "                          AND SX5.X5_CHAVE = SA1.A1_REGIAO
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SX5110)TX5
cQuery += "                       ON Trim(TX5.X5_TABELA) = 'ZZ'
cQuery += "                          AND Trim(TX5.X5_CHAVE) = Trim(SBM.BM_XAGRUP)
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   UDBP12.SB9030)SB9
cQuery += "                       ON SB9.D_E_L_E_T_ = ' '
cQuery += "                          AND SB9.B9_FILIAL = '01'
cQuery += "                          AND SB9.B9_COD = SD2.D2_COD
cQuery += "                          AND Substr(SB9.B9_DATA, 1, 6) =
cQuery += "                              Substr(D2_EMISSAO, 1, 6)
cQuery += "                          AND SB9.B9_LOCAL = '15'
cQuery += "                          AND SB1.B1_CLAPROD = 'C'
cQuery += "                          AND TB1.B1_CLAPROD = 'F'
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SB9110)TB9
cQuery += "                       ON TB9.D_E_L_E_T_ = ' '
cQuery += "                          AND TB9.B9_FILIAL = '01'
cQuery += "                          AND TB9.B9_COD = SD2.D2_COD
cQuery += "                          AND Substr(TB9.B9_DATA, 1, 6) =
cQuery += "                              Substr(D2_EMISSAO, 1, 6)
cQuery += "                          AND TB9.B9_LOCAL = '03'
cQuery += "         WHERE  SD2.D_E_L_E_T_ = ' ' 

cQuery += "                AND D2_FILIAL = '01'
cQuery += "                AND SD2.D2_CF IN ("+AllTrim(GetMV("ST_CFOPVEN",,""))+")
cQuery += "                AND Substr(D2_EMISSAO, 1, 6) = '"+substr(dtos(date()),1,6)+"' 
cQuery += "               AND F2_TIPO='N'


cQuery += "         UNION
cQuery += "         SELECT 'SP'                            AS EMPRESA,
cQuery += "                'DEV'                           AS MODALIDADE,
cQuery += "                D1_DOC                          AS NOTA_FISCAL,
cQuery += "                D1_DTDIGIT                      AS EMISSAO,
cQuery += "                D1_QUANT                        AS QUANTIDADE,
cQuery += "                D1_COD                          AS PRODUTO,
cQuery += "                SB1.B1_DESC                     AS DESCRICAO,
cQuery += "                Nvl(Trim(TX5.X5_DESCRI), 'N/A') AS AGRUPAMENTO,
cQuery += "                Nvl(BM_DESC, 'SEM GRUPO')       AS DESC_GRUPO,
cQuery += "                A1_GRPVEN                       AS GRUPO_VENDAS,
cQuery += "                ACY_DESCRI,
cQuery += "                A1_COD                          AS CODIGO,
cQuery += "                A1_NOME                         AS RAZAO_SOCIAL,
cQuery += "                SD1.R_E_C_N_O_                  AS RECNO,
cQuery += "                ( D1_TOTAL - SD1.D1_VALIMP5 - SD1.D1_VALIMP6 - SD1.D1_VALICM - D1_DIFAL ) *- 1 AS LIQUIDO
cQuery += "         FROM   SD1110 SD1
cQuery += "                INNER JOIN(SELECT *
cQuery += "                           FROM   SA1110)SA1
cQuery += "                        ON SA1.D_E_L_E_T_ = ' '
cQuery += "                           AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += "                           AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += "                           AND SA1.A1_GRPVEN <> 'ST'
cQuery += "                           AND SA1.A1_GRPVEN <> 'SC'
cQuery += "                           AND SA1.A1_EST <> 'EX'
cQuery += "                           AND SA1.A1_FILIAL = '  '
cQuery += "                LEFT JOIN ACY110 CY
cQuery += "                       ON CY.D_E_L_E_T_ = ' '
cQuery += "                          AND CY.ACY_GRPVEN = SA1.A1_GRPVEN
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                           FROM   SF2110)SF2
cQuery += "                        ON SF2.D_E_L_E_T_ = ' '
cQuery += "                           AND SF2.F2_DOC = D1_NFORI
cQuery += "                           AND SF2.F2_SERIE = D1_SERIORI
cQuery += "                           AND SF2.F2_FILIAL = SD1.D1_FILIAL
cQuery += "                INNER JOIN(SELECT *
cQuery += "                           FROM   SB1110)SB1
cQuery += "                        ON SB1.D_E_L_E_T_ = ' '
cQuery += "                           AND SB1.B1_COD = D1_COD
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   UDBP12.SB1030)TB1
cQuery += "                       ON TB1.D_E_L_E_T_ = ' '
cQuery += "                          AND TB1.B1_COD = D1_COD
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SBM110)SBM
cQuery += "                       ON SBM.D_E_L_E_T_ = ' '
cQuery += "                          AND BM_GRUPO = SB1.B1_GRUPO
cQuery += "                          AND SBM.BM_XAGRUP <> ' '
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SA3110)SA3
cQuery += "                       ON SA3.D_E_L_E_T_ = ' '
cQuery += "                          AND SA3.A3_COD = F2_VEND1
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SA3110)TA3
cQuery += "                       ON TA3.D_E_L_E_T_ = ' '
cQuery += "                          AND TA3.A3_COD = SA3.A3_SUPER
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SX5110)SX5
cQuery += "                       ON SX5.X5_TABELA = 'A2'
cQuery += "                          AND SX5.X5_CHAVE = SA1.A1_REGIAO
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SX5110)TX5
cQuery += "                       ON Trim(TX5.X5_TABELA) = 'ZZ'
cQuery += "                          AND Trim(TX5.X5_CHAVE) = Trim(SBM.BM_XAGRUP)
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   UDBP12.SB9030)SB9
cQuery += "                       ON SB9.D_E_L_E_T_ = ' '
cQuery += "                          AND SB9.B9_FILIAL = '01'
cQuery += "                          AND SB9.B9_COD = SD1.D1_COD
cQuery += "                          AND Substr(SB9.B9_DATA, 1, 6) =
cQuery += "                              Substr(SD1.D1_DTDIGIT, 1, 6)
cQuery += "                          AND SB9.B9_LOCAL = '15'
cQuery += "                          AND SB1.B1_CLAPROD = 'C'
cQuery += "                          AND TB1.B1_CLAPROD = 'F'
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SB9110)TB9
cQuery += "                       ON TB9.D_E_L_E_T_ = ' '
cQuery += "                          AND TB9.B9_FILIAL = '01'
cQuery += "                          AND TB9.B9_COD = SD1.D1_COD
cQuery += "                          AND Substr(TB9.B9_DATA, 1, 6) =
cQuery += "                              Substr(SD1.D1_DTDIGIT, 1, 6)
cQuery += "                          AND TB9.B9_LOCAL = '03'
cQuery += "         WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += "                AND SD1.D1_CF IN("+GetMV("ST_CFOPDEV",.F.,'1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211')+")
cQuery += "                AND Substr(SD1.D1_DTDIGIT, 1, 6) = '"+substr(dtos(date()),1,6)+"' 
cQuery += "                AND SD1.D1_TIPO = 'D'
cQuery += "         UNION
cQuery += "         SELECT 'AM'                            AS EMPRESA,
cQuery += "                'DEV'                           AS MODALIDADE,
cQuery += "                D1_DOC                          AS NOTA_FISCAL,
cQuery += "                D1_DTDIGIT                      AS EMISSAO,
cQuery += "                D1_QUANT                        AS QUANTIDADE,
cQuery += "                D1_COD                          AS PRODUTO,
cQuery += "                SB1.B1_DESC                     AS DESCRICAO,
cQuery += "                Nvl(Trim(TX5.X5_DESCRI), 'N/A') AS AGRUPAMENTO,
cQuery += "                Nvl(BM_DESC, 'SEM GRUPO')       AS DESC_GRUPO,
cQuery += "                A1_GRPVEN                       AS GRUPO_VENDAS,
cQuery += "                ACY_DESCRI,
cQuery += "                A1_COD                          AS CODIGO,
cQuery += "                A1_NOME                         AS RAZAO_SOCIAL,
cQuery += "                SD1.R_E_C_N_O_                  AS RECNO,
cQuery += "                ( D1_TOTAL - SD1.D1_VALIMP5 - SD1.D1_VALIMP6 - SD1.D1_VALICM - D1_DIFAL ) *- 1 AS LIQUIDO
cQuery += "         FROM   UDBP12.SD1030 SD1
cQuery += "                INNER JOIN(SELECT *
cQuery += "                           FROM   UDBP12.SA1030)SA1
cQuery += "                        ON SA1.D_E_L_E_T_ = ' '
cQuery += "                           AND SA1.A1_COD = SD1.D1_FORNECE
cQuery += "                           AND SA1.A1_LOJA = SD1.D1_LOJA
cQuery += "                           AND SA1.A1_GRPVEN <> 'ST'
cQuery += "                           AND SA1.A1_GRPVEN <> 'SC'
cQuery += "                           AND SA1.A1_EST <> 'EX'
cQuery += "                           AND SA1.A1_FILIAL = '  '
cQuery += "                LEFT JOIN ACY110 CY
cQuery += "                       ON CY.D_E_L_E_T_ = ' '
cQuery += "                          AND CY.ACY_GRPVEN = SA1.A1_GRPVEN
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                           FROM   UDBP12.SF2030)SF2
cQuery += "                        ON SF2.D_E_L_E_T_ = ' '
cQuery += "                           AND SF2.F2_DOC = D1_NFORI
cQuery += "                           AND SF2.F2_SERIE = D1_SERIORI
cQuery += "                           AND SF2.F2_FILIAL = SD1.D1_FILIAL
cQuery += "                INNER JOIN(SELECT *
cQuery += "                           FROM   SB1110)SB1
cQuery += "                        ON SB1.D_E_L_E_T_ = ' '
cQuery += "                           AND SB1.B1_COD = D1_COD
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   UDBP12.SB1030)TB1
cQuery += "                       ON TB1.D_E_L_E_T_ = ' '
cQuery += "                          AND TB1.B1_COD = D1_COD
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SBM110)SBM
cQuery += "                       ON SBM.D_E_L_E_T_ = ' '
cQuery += "                          AND BM_GRUPO = SB1.B1_GRUPO
cQuery += "                          AND SBM.BM_XAGRUP <> ' '
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SA3110)SA3
cQuery += "                       ON SA3.D_E_L_E_T_ = ' '
cQuery += "                          AND SA3.A3_COD = F2_VEND1
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SA3110)TA3
cQuery += "                       ON TA3.D_E_L_E_T_ = ' '
cQuery += "                          AND TA3.A3_COD = SA3.A3_SUPER
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SX5110)SX5
cQuery += "                       ON SX5.X5_TABELA = 'A2'
cQuery += "                          AND SX5.X5_CHAVE = SA1.A1_REGIAO
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SX5110)TX5
cQuery += "                       ON Trim(TX5.X5_TABELA) = 'ZZ'
cQuery += "                          AND Trim(TX5.X5_CHAVE) = Trim(SBM.BM_XAGRUP)
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   UDBP12.SB9030)SB9
cQuery += "                       ON SB9.D_E_L_E_T_ = ' '
cQuery += "                          AND SB9.B9_FILIAL = '01'
cQuery += "                          AND SB9.B9_COD = SD1.D1_COD
cQuery += "                          AND Substr(SB9.B9_DATA, 1, 6) =
cQuery += "                              Substr(SD1.D1_DTDIGIT, 1, 6)
cQuery += "                          AND SB9.B9_LOCAL = '15'
cQuery += "                          AND SB1.B1_CLAPROD = 'C'
cQuery += "                          AND TB1.B1_CLAPROD = 'F'
cQuery += "                LEFT JOIN(SELECT *
cQuery += "                          FROM   SB9110)TB9
cQuery += "                       ON TB9.D_E_L_E_T_ = ' '
cQuery += "                          AND TB9.B9_FILIAL = '01'
cQuery += "                          AND TB9.B9_COD = SD1.D1_COD
cQuery += "                          AND Substr(TB9.B9_DATA, 1, 6) =
cQuery += "                              Substr(SD1.D1_DTDIGIT, 1, 6)
cQuery += "                          AND TB9.B9_LOCAL = '03'
cQuery += "         WHERE  SD1.D_E_L_E_T_ = ' '
cQuery += "                AND SD1.D1_CF IN("+GetMV("ST_CFOPDEV",.F.,'1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211')+")
cQuery += "                AND SD1.D1_FILIAL = '01'
cQuery += "                AND Substr(SD1.D1_DTDIGIT, 1, 6) = '"+substr(dtos(date()),1,6)+"' 
cQuery += "                AND SD1.D1_TIPO = 'D') TMP

cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSF2', .F., .T.)

WHILE TSF2->(!EOF())
  AADD(aVetor,{"Steck Brasil",;
  STRZERO(MONTH(STOD(TSF2->F2_EMISSAO)),2),;
  "BRASIL",;
  ALLTRIM(TSF2->F2_CLIENTE),;
  ALLTRIM(TSF2->A1_NOME),;
  ALLTRIM(TSF2->A1_GRPVEN),;
  ALLTRIM(TSF2->A1_GRPVEN),;
  ALLTRIM(TSF2->A1_GRPVEN),;
  ALLTRIM(TSF2->ACY_DESCRI),;
  ALLTRIM(TSF2->X5_DESCRI),;
  ALLTRIM(TSF2->BM_DESC),;
  ALLTRIM(TSF2->B1_COD),;
  ALLTRIM(TSF2->B1_DESC),;
  "",;
  TSF2->D2_TOTAL,; //ALLTRIM(TRANSFORM(TSF2->D2_TOTAL, "99,999,999.99999")),;
  TSF2->D2_QUANT }) //ALLTRIM(TRANSFORM(TSF2->D2_QUANT , "99,999,999.99999"))})  
	TSF2->(DBSKIP())

  IF IsBlind() = .F.
    nCount := nCount + 1
    bAction:={|| oMeter:Set(nCount), SysRefresh(), !lEnd}
    Eval(bAction)
    
    IF nCount >= 100
      oMeter:nTotal := 100
      nCount := 0
    ENDIF
  ENDIF

ENDDO
TSF2->(DBCLOSEAREA())

// Criando o objeto que irá gerar o conteúdo do Excel
oFWMsExcel := FWMSExcel():New()
 
// Alterando atributos
oFWMsExcel:SetFontSize(11)                 // Tamanho Geral da Fonte
oFWMsExcel:SetFont("Calibri")                // Fonte utilizada
//oFWMsExcel:SetBgGeneralColor("#000000")    // Cor de Fundo Geral
//oFWMsExcel:SetTitleBold(.F.)               // Título Negrito
//oFWMsExcel:SetTitleFrColor("#FFFFFF")      // Cor da Fonte do título - Azul Claro
//oFWMsExcel:SetLineFrColor("#d4d4d4")       // Cor da Fonte da primeira linha - Cinza Claro
//oFWMsExcel:Set2LineFrColor("#ffffff")      // Cor da Fonte da segunda linha - Branco
 
/************************************
Criando a ABA da planlinha para receber as informações
Não utilizar número junto com sinal de menos. Ex.: 1-
************************************/
oFWMsExcel:AddworkSheet("R7041") 

/**********************
Criando a Tabela 
Parâmetros: 
1 - Informar a mesma descrição da AddworkSheet("R7041")
2 - Informar a descrição da tabela 
**********************/
oFWMsExcel:AddTable("R7041","R7041 - Sales Trend")

/**********************************
Criando Colunas
FWMsExcelEx():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)-> NIL
cWorkSheet  - Caracteres  - Nome da planilha
cTable      -	Caracteres  - Nome da tabela	
cColumn     -	Caracteres  - Titulo da tabela que será adicionada	
nAlign      -	Numérico    - Alinhamento da coluna ( 1-Left,2-Center,3-Right )	
nFormat     -	Numérico    - Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )	
lTotal      -	Lógico      - Indica se a coluna deve ser totalizada	
**********************************/
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","Sales Organization"  ,1,1) // "Sales Organization"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","Calendar month"      ,1,1) // "Calendar month"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","Sales Office (M)"    ,1,1) // "Sales Office (M)"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","Sold-to Party"       ,1,1) // "Sold-to Party"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend",""                    ,1,1) // ""
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","Pricing Class L1 (M)",1,1) // "Pricing Class L1 (M)"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","Pricing Class L2 (M)",1,1) // "Pricing Class L2 (M)"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","Pricing Class L3 (M)",1,1) // "Pricing Class L3 (M)"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","Business type(M)"    ,1,1) // "Business type(M)"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","Helios Code (M)"     ,1,1) // "Helios Code (M)"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","LCOS Level 6"        ,1,1) // "LCOS Level 6"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","Material"            ,1,1) // "Material"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend",""                    ,1,1) // ""
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","Prod.hierarchy (M)"  ,1,1) // "Prod.hierarchy (M)"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","BRL"                 ,3,2) // "BRL"
oFWMsExcel:AddColumn("R7041","R7041 - Sales Trend","PCE"                 ,3,1) // "PCE"


oFWMsExcel:AddRow("R7041","R7041 - Sales Trend",{"","","","","","","","","","","","","","","",""})
oFWMsExcel:AddRow("R7041","R7041 - Sales Trend",{"","","","","","","","","","","","","","","",""})

  FOR i := 1 TO LEN(aVetor)

    IF IsBlind() = .F.
      nCount := nCount + 1
      bAction:={|| oMeter:Set(nCount), SysRefresh(), !lEnd}
      Eval(bAction)
      
      IF nCount >= 100
        oMeter:nTotal := 100
        nCount := 0
      ENDIF
    ENDIF

    /*****************************************
    Criando as Linhas 
    FWMsExcelEx():AddRow(< cWorkSheet >, < cTable >, < aRow >,< aCelStyle >)-> NIL
    cWorkSheet  - Caracteres  - Nome da planilha	
    cTable      - Caracteres  - Nome da tabela	
    aRow        - Array       - Array com as informações da linha da linha	
    aCelStyle   - Array       - Array com as posições das colunas que receberão o estilo específicos	
    oFWMsExcel:AddRow("R7041","TABR7041",{11,12,13,sToD('20140317')})
    *****************************************/
    //Criando as Linhas
    oFWMsExcel:AddRow("R7041","R7041 - Sales Trend",{aVetor[i,01],;
                                          aVetor[i,02],;
                                          aVetor[i,03],;
                                          aVetor[i,04],;
                                          aVetor[i,05],;
                                          aVetor[i,06],;
                                          aVetor[i,07],;
                                          aVetor[i,08],;
                                          aVetor[i,09],;
                                          aVetor[i,10],;
                                          aVetor[i,11],;
                                          aVetor[i,12],;
                                          aVetor[i,13],;
                                          aVetor[i,14],;
                                          aVetor[i,15],;
                                          INT(aVetor[i,16])})
  NEXT


  //  Ativando o arquivo e gerando o xml
  oFWMsExcel:Activate()
  oFWMsExcel:GetXMLFile(cArqXml)
       
  //  Abrindo o excel e abrindo o arquivo xml
  //oExcel := MsExcel():New()        // Abre uma nova conexão com Excel
  //oExcel:WorkBooks:Open(cArqXml)   // Abre uma planilha
  //oExcel:SetVisible(.T.)           // Visualiza a planilha
  //oExcel:Destroy()

RETURN

STATIC FUNCTION FileDlg()

local cTmp := getTempPath()
local cArquivo := tFileDialog( "Todos os arquivo (*.*) | Arquivos texto (*.txt) ", 'Selecao de Arquivos',, cTmp, .F., GETF_MULTISELECT ) 
MsgInfo(cArquivo)
/*    
LOCAL tmp := getTempPath()
LOCAL targetDir := tFileDialog( "All files (*.xml) | All Text files (*.xml) ",'Salvar arquivo no diretório',              , tmp           , .F.       , GETF_RETDIRECTORY )
cDir := targetDir
//oDir:Refresh()
//                   tFileDialog([ cMascara]                                   , [ cTitulo]                  ,[ nMascpadrao], [ cDirinicial], [ lSalvar], [ nOpcoes]) 
*/
RETURN

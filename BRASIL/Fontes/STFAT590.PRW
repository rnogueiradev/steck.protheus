#include 'protheus.ch'
#include 'TBICONN.CH'
/*
*****************************************************************
* Programa    : STFAT590                                       *
* Data Criação: 27/04/2022                                      *
* Autor       : Gessé Antonio Roldão                            *
* Cliente     : Steck                                           *
*****************************************************************
* Detalhes    : Geração de planilha contendo a relação de       *
*             : clientes cadastrados                            *
*****************************************************************
*/
User Function STFAT590()
Private lSchedule := .F.

If Select("SX3") == 0            // Verifico se está sendo chamada por Schedule
   lSchedule := .T.
   PREPARE ENVIRONMENT EMPRESA "11" FILIAL "01" MODULO "FAT" TABLES "AF9","SB1","SB2","SB3","SB5","SB8","SB9","SBD","SBF","SBJ","SBK","SC2","SC5","SC6","SD1","SD2","SD3","SD4","SD5","SD8","SDB","SDC","SF1","SF2","SF4","SA1","SM2","SAH","SM0"
EndIf

Conout("Inicio da execução da rotina STFAT590 na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

Processa({|| PROC_GRV()}, "Gerando as informações")

Conout("Término da execução da rotina STFAT590 na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

If lSchedule
   RESET ENVIRONMENT
Endif

Return
   
/*
************************************************************************
* Função que processa as informações e gera a planilha conforme layout *
************************************************************************
*/
Static Function PROC_GRV()
Local cQuery := ""

//Private cLocArq := SuperGetMv("STFAT590",.F.,"\spool\")     && Para testes locais
Private cLocArq := SuperGetMv("STFAT590",.F.,"\arquivos\SFTP-INTEGRAÇÕES\STECKCONECTA\CUSTOMERS\PENDING")
Private aCabecExcel := {"CNPJ","SapCode","SapCode_headquarter","BusinessName","Name","Category","Email_seller","Status","City","State","CEP","Address1","Address2"}
Private aCamposSA1  := {"A1_CGC","A1_COD","A1_LOJA","A1_NREDUZ","A1_NOME","X5_DESCRI","A3_EMAIL","A1_MSBLQL","A1_MUN","A1_EST","A1_CEP","A1_END","A1_COMPLEM"}

If !ExistDir( cLocArq )
   If lSchedule
      Conout("A pasta "+cLocArq+" não existe no RootPath !!!")
      Conout("crie a pasta "+cLocArq+" no RootPath ou crie ou corrija o parâmetro STFAT590")
   Else
      MsgAlert("A pasta "+cLocArq+" não existe no RootPath !!!","Atenção!")
      MsgAlert("crie a pasta "+cLocArq+" no RootPath ou crie ou corrija o parâmetro STFAT590","Solução!")
   Endif
   Return
Endif

//cQuery := "SELECT A1_CGC, A1_COD, A1_LOJA, A1_NREDUZ, A1_NOME, X5_DESCRI, ISNULL(A3_EMAIL, ' ') A3_EMAIL, "
cQuery := "SELECT A1_CGC, A1_COD, A1_LOJA, A1_NREDUZ, A1_NOME, X5_DESCRI, NVL(A3_EMAIL, ' ') A3_EMAIL, "
cQuery += "CASE WHEN A1_MSBLQL = '1' THEN 'Inactive' ELSE 'Active' END AS A1_MSBLQL, "
cQuery += "A1_MUN, A1_EST, A1_CEP, A1_END, A1_COMPLEM "
cQuery += "FROM "+RetSqlName("SA1")+" SA1 "
cQuery += "LEFT OUTER JOIN "+RetSqlName("SA3")+" SA3 ON A3_COD = A1_VEND AND SA3.D_E_L_E_T_ = ' ' AND A3_FILIAL = '"+xFilial("SA3")+"' "
cQuery += "LEFT OUTER JOIN "+RetSqlName("SX5")+" SX5 ON X5_TABELA = 'Z0' AND X5_CHAVE = A1_XESCALA AND SX5.D_E_L_E_T_ = ' ' AND X5_FILIAL = '"+xFilial("SX5")+"' "
cQuery += "WHERE SA1.D_E_L_E_T_ = ' ' "
cQuery += "AND A1_GRPVEN <> 'ST' "
cQuery += "AND A1_GRPVEN <> 'SC' "
cQuery += "AND A1_EST <> 'EX' "
cQuery += "AND A1_CGC <> ' ' "
cQuery += "AND A1_FILIAL = '"+xFilial("SA1")+"' "
cQuery += "AND A1_XCONECT = '1' "
cQuery += "ORDER BY A1_COD, A1_LOJA "

If Select("TRB") > 0
   TRB->( DbCloseArea() )
Endif               

DbUseArea( .T., 'TOPCONN', TCGenQry( , , cQuery ), 'TRB', .F., .T. )

GERAXML()

Return

/*****************************************************************************************************************
* Função para geração do arquivo XML (para posterior abertura no MS-Excel)
*****************************************************************************************************************/
Static Function GERAXML()
Local cNomArq := ""
Local oCellHorAlign := FwXlsxCellAlignment():Horizontal()
Local oCellVertAlign := FwXlsxCellAlignment():Vertical()
Local cFont := FwPrinterFont():Calibri()

Local nQtd    := 0
Local nLin    := 1
Local nTam    := 0
Local x       := 0

local oPrtXlsx as object
local cFilename as character
local lRet as logical

Local nSize   := 11
Local lItalic := .F.
Local lBold   := .T.
Local lUnderlined := .F.

Local cHorAlignment := oCellHorAlign:Center()
Local cVertAlignment := oCellVertAlign:Center()
Local lWrapText := .F.
Local nRotation := 180           // 270
Local cCustomFormat := ""

// Nome do arquivo definido conforme solicitado pelo Sr. Everson
cNomArq := "STK_CAD"+Left(DtoS(dDatabase),4)+Substr(DtoS(dDatabase),5,2)+"_"+DtoS(dDatabase)
cNomArq += Substr(Time(),1,2)+Substr(Time(),4,2)+Substr(Time(),7,2)+".XLSX"

cFilename := '/system/'+Criatrab(Nil,.F.)

ferase(cFilename+".rel")

oPrtXlsx:= FwPrinterXlsx():New()

lRet := oPrtXlsx:Activate(cFilename+".rel")

lRet := oPrtXlsx:AddSheet("Planilha1")

// Seta texto vermelho com alinhamento horizontal e vertical centralizado e com rotação de texto vertical
lRet := oPrtXlsx:SetCellsFormat(cHorAlignment, cVertAlignment, lWrapText, nRotation, "FFFFFF","CC0000", cCustomFormat)
lRet := oPrtXlsx:SetFont(cFont, nSize, lItalic, lBold, lUnderlined)

// Monto o cabeçalho contendo o nome dos campos da planilha (linha 1)
For x := 1 to Len(aCabecExcel)
   lRet := oPrtXlsx:SetText(nLin, x, aCabecExcel[x])
Next

For x := 1 to Len(aCamposSA1)
   nTam := GetSx3Cache(aCamposSA1[x],"X3_TAMANHO")
   nTam := Max(nTam, Len(aCabecExcel[x]))
   If aCamposSA1[x] = "A1_COD" .or. aCamposSA1[x] = "A1_CEP" .or. aCamposSA1[x] = "A1_MSBLQL"
      nTam := 10
   Endif
   If aCamposSA1[x] = "A1_LOJA" .or. aCamposSA1[x] = "A1_NREDUZ"
      nTam := 22
   Endif
   lret := oPrtXlsx:SetColumnsWidth(x, x, nTam)
Next

lRet := oPrtXlsx:ResetCellsFormat()
lRet := oPrtXlsx:ResetFont()

DbSelectArea("TRB")
DbGoTop()

While !TRB->(Eof())
   nQtd ++
   DbSkip()
Enddo

DbGoTop()

ProcRegua(nQtd)

While !TRB->(Eof())
   If !lSchedule
      IncProc("Processando o cliente... "+TRB->A1_CGC+" - "+TRB->A1_NREDUZ)
   Endif
   nLin ++
   SA1->(DbSetOrder(1))
   SA1->(DbSeek(xFilial("SA1")+TRB->A1_COD,.T.))
   lRet := oPrtXlsx:SetText(nLin, 1, TRB->A1_CGC)
   lRet := oPrtXlsx:SetText(nLin, 2, TRB->A1_COD+TRB->A1_LOJA)
   lRet := oPrtXlsx:SetText(nLin, 3, SA1->A1_COD+SA1->A1_LOJA)
   lRet := oPrtXlsx:SetText(nLin, 4, TRB->A1_NREDUZ)
   lRet := oPrtXlsx:SetText(nLin, 5, TRB->A1_NOME)
   lRet := oPrtXlsx:SetText(nLin, 6, TRB->X5_DESCRI)
   lRet := oPrtXlsx:SetText(nLin, 7, TRB->A3_EMAIL)
   lRet := oPrtXlsx:SetText(nLin, 8, TRB->A1_MSBLQL)
   lRet := oPrtXlsx:SetText(nLin, 9, TRB->A1_MUN)
   lRet := oPrtXlsx:SetText(nLin, 10, TRB->A1_EST)
   lRet := oPrtXlsx:SetText(nLin, 11, TRANSFORM(TRB->A1_CEP,"@R 99999-999"))
   lRet := oPrtXlsx:SetText(nLin, 12, TRB->A1_END)
   lRet := oPrtXlsx:SetText(nLin, 13, TRB->A1_COMPLEM)

   TRB->(DbSkip())

Enddo

lRet := oPrtXlsx:toXlsx()

oPrtXlsx:DeActivate()

__CopyFile( cFilename + ".XLSX", cLocArq + cNomArq )

TRB->( DbCloseArea() )

Return

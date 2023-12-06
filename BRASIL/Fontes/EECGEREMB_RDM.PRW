#Include "AVERAGE.CH"

/*
Programa...: EECGEREMB_RDM.PRW
Objetivo...: Gerar automaticamente um processo de embarque tendo como base os dados da rotina
de embalagens customizadas pela Microsiga para a Steck.
Autor......: Julio de Paula Paz
Data/Hora..: 25/08/2010
Observações:
*/

//definicao de tipos de uso de mensagens (EE4)
#define TM_SIT "1"   //mensagem visivel em desc. situacao
#define TM_CAR "2"   //mensagem visivel em cartas
#define TM_FAT "3"   //mensagem visivel em faturas
#define TM_INS "4"   //mensagem visivel em instrumento embarque
#define TM_DOC "5"   //mensagem visivel para criterios de origem de produtos
#define TM_GER "*"   //mensagem visivel generica nao visivel ao usuario para ser usada no EE2

//definicao de tipos de cadastros para mensagens (EE2)
#define MC_TMEN   "1"   //mensagem relacionada a TABELA DE MENSAGENS
#define MC_TCPG   "2"   //mensagem para condicoes de pagamento
#define MC_CPRO   "3"   //mensagem relacionadaa CADASTRO DE PRODUTOS
#define MC_TMOE   "4"   //mensagem relacionada tabela de moedas
#define MC_CBAN   "5"   //mensagem relacionada a bancos
#define MC_TEMB   "6"   //mensagem relacionada ao cadastro de embalagens
#define MC_CPAI   "7"   //mensagem relacionada ao cadastro de paises
#define MC_TUNM   "8"   //mensagem relacionada a Tabela de Unidades de Medida

//Definição dos tipos de Pedido/Embarque
#define PC_RG " " //Regular
#define PC_RC "2" //Remessa por Consignação.
#define PC_VC "3" //Pedido de Venda por Consignação.
#define PC_BN "4" //Back to Back Normal.
#define PC_BC "5" //Remessa por consignação com Back To Back.
#define PC_VR "6" //Embarque de Venda Regular
#define PC_VB "7" //Embarque de Venda com Back To Back
#define PC_CF "8" //Processo de exportação de café
#define PC_CM "9" //Processo de exportação de commodities

//definicao de quando ocorre um lancamento
#define OC_PE   "P"   //pedido
#define OC_EM   "Q"   //embarque
#define OC_EMBA "E"   //embalagem
#define OC_FI   "F"   //FINANCAS
#define OC_DEM  "D"   //Demurrage

//definicao de situacao de processos apresentado em ordem de uso
#define ST_PC  "*"     //processo/embarque cancelado (EE7/EEC)
//fase pedido (EE7->EE7_STATUS)
#define ST_SC  "1"     //aguardando solicitacao de credito
#define ST_LC  "2"     //aguardando liberacao de credito
#define ST_CL  "3"     //credito liberado
#define ST_PE  "7"     //lancado na fase de embarque
//fase embarque (EEC->EEC_STATUS)
#define ST_DC  "4"     //aguardando confeccao documentos
#define ST_AE  "5"     //aguardando embarque
#define ST_EM  "6"     //embarcado
// Novos status 609
#define ST_CC  "8"     //cambio a contratar
#define ST_EP  "9"     //cambio parcial
#define ST_CO  "A"     //cambio contratado
#define ST_LP  "E"     //lanc. parcial na fase de embarque
// Integracao Faturamento
#define ST_AF  "B"     //aguardando faturamento
#define ST_FP  "C"     //faturado parcialmente
#define ST_FA  "D"     //faturado
#define ST_RV  "F"     //pedido especial para rv sem vinculacao


/*
Função          : EECGerEmb()
Parâmetros      :
Retorno         :
Objetivo        : Função Principal para Gerar automaticamente um processo de embarque tendo como base os dados da rotina
de embalagens customizadas pela Microsiga para a Steck.
Autor           : Julio de Paula Paz
Data/Hora       : 23/08/2010 - 09:00
Obs.            : - Estrutura das tabelas de embalagens
- CB3: Cadastro do Tipo de Embalagem;
- CB6: Volumes do Pedido;(os 6 primeiros dígitos correspondem ao número da Ordem de Separação - a relação com o CB7 em relação ao pedido é de N->N)
- CB7: Capa da Ordem de Separação;
- CB9: Itens Separados.
- Os relacionamentos destas tabelas são realizados pelos seguintes campos:
CB7->CB9: CB7_ORDSEP->CB9_ORDSEP
CB9->CB6: CB9_PEDIDO->CB6_PEDIDO
CB6->CB3: CB6_TIPOVOL->CB3_CODEMB
*/
User Function EECGerEmb()
	Local lRet := .F.
	Local aButtons := {{"LBTIK",{|| MarcaDesmarca()} ,"Marca/Desmarca Todos"} }
	Local bDesmarca
	Local bMarca
	Local bOk,bCancel
	Local nOpc
	Local aExibeCampos
	Local oDlg
	Private cNomeArq, cNomeArq1, cNomeArq2
	Private cMarca := GetMark()
	Private cProcesso := ""
	Private lInverte := .F.
	Private oMarca
	Private aArqsTemp

	//Begin Sequence
	Processa( {|| lRet := CriaWorks() },"Criando Arquivos Temporários..." )

	If ! lRet
		Break
	EndIf

	Processa( {|| lRet := GeraDados() },"Gerando Dados das Embalagens..." )

	// Seleção dos dados
	bMarca := {|| WorkSel->WK_FLAG := cMarca}
	bDesmarca := {|| WorkSel->WK_FLAG := Space(2)}

	aExibeCampos:={{"WK_FLAG","","  "},;
	{{|| WorkSel->WK_PEDFAT},"","Ped.de Venda"},;
	{{|| WorkSel->WK_ORDSEP},"","Numero Ordem"},;
	{{|| WorkSel->WK_CLIENT},"","Importador"},;
	{{|| WorkSel->WK_LOJA}  ,"","Loja Import."},;
	{{|| WorkSel->WK_NOMECL},"","Nome Import."},;
	{{|| WorkSel->WK_DTEMIS},"","Data Emissão"},;
	{{|| WorkSel->WK_FORN  },"","Fornecedor"},;
	{{|| WorkSel->WK_FOLOJA},"","Loja Forn."},;
	{{|| WorkSel->WK_NOMFOR},"","Nome Forn."}}

	WorkSel->(DbGoTop())

	nOpc := 0
	bOk := {|| If(ValidaSel(),(nOpc := 1,oDlg:End()),)}
	bCancel := {|| nOpc := 0, oDlg:End()}
	Define MsDialog oDlg Title "Seleção de Ordem de Separação para Geração Automática de Embarques" From DLG_LIN_INI,DLG_COL_INI To DLG_LIN_FIM,DLG_COL_FIM Of oMainWnd Pixel
	aPos := PosDlg(oDlg)
	aPos[1] := 20//48

	oMark := MsSelect():New("WorkSel","WK_FLAG",,aExibeCampos,@lInverte,@cMarca,aPos,,,,oDlg)
	oMark:bAval := {|| if(Empty(WorkSel->WK_FLAG),Eval(bMarca),Eval(bDesMarca))  }

	Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel,,aButtons)

	If nOpc == 1
		Processa( {|| lRet := GrvEmbarque() },"Gravando processo de embarque..." ) // Grava processo de embarque e a tabela ZZA para a rotina de estufagem.
		If lRet
			MsgInfo("Rotina de criação de embarque finalizada com sucesso.","Atenção")
		Else
			MsgInfo("Rotina de criação de embarque finalizada.","Atenção")
		EndIf
	Else
		lRet := .F.
		MsgInfo("Rotina de criação de embarque cancelada.","Atenção")
	EndIf

	//End Sequence

	If Select("WorkZZA") > 0
		WorkZZA->(E_EraseArq(cNomeArq))
	EndIf

	If Select("WorkSel") > 0
		WorkSel->(E_EraseArq(cNomeArq1,cNomeArq2))
	EndIf

	// Exclui Works criadas para criação do embarque através da função AE102SETWORKS(aTMP)
	EEC->(dbSetOrder(1))
	If(Select("WorkIP") > 0,WorkIP->(E_ERASEARQ(aArqsTemp[1],aArqsTemp[6])),) //cNomArqIp = 1, cNomArq5 = 6
	If(Select("WorkDe") > 0,WorkDe->(E_EraseArq(aArqsTemp[2])),) // cNomArq1 = 2
	If(Select("WorkAg") > 0,WorkAg->(E_EraseArq(aArqsTemp[3])),) // cNomArq2 = 3
	If(Select("WorkIn") > 0,WorkIn->(E_EraseArq(aArqsTemp[4])),) // cNomArq3 = 4
	If(Select("WorkEm") > 0,WorkEm->(E_ERASEARQ(aArqsTemp[5])),) // cNomArq4 = 5
	If(Select("WorkNF") > 0,WorkNF->(E_EraseArq(aArqsTemp[7])),) // cNomArq6 = 7
	If(Select("WorkNo") > 0,WorkNo->(E_EraseArq(aArqsTemp[8])),) // cNomArq7 = 8
	If(Select("WorkDoc")  > 0,WorkDoc->(E_EraseArq(aArqsTemp[9],aArqsTemp[10])),) // cNomArq8 = 9, cNomArq82 = 10
	If(Select("WorkCalc") > 0,WorkCalc->(E_EraseArq(aArqsTemp[11])),) // cNomArq9 = 11
	If(Select("WorkInv") > 0,WorkInv->(E_EraseArq(aArqsTemp[12])),) // cArqCapInv = 12
	If(Select("WorkDetInv") > 0,WorkDetInv->(E_EraseArq(aArqsTemp[13],aArqsTemp[14])),) // cArqDetInv = 13, cArq2DetInv = 14
	If(Select("WORKSLD_AD") > 0,WORKSLD_AD->(E_EraseArq(aArqsTemp[15])),) // cArqAdiant = 15
	If(Select("WkEY5") > 0,WkEY5->(E_EraseArq(aArqsTemp[16], aArqsTemp[17])),) // cArqWkEY5 = 16, cArq2WkEY5 = 17
	If(Select("WkEY6") > 0,WkEY6->(E_EraseArq(aArqsTemp[18])),) // cArqWkEY6 = 18
	If(Select("WkEY7") > 0,WkEY7->(E_EraseArq(aArqsTemp[19], aArqsTemp[20])),) // cArqWkEY7 = 19, cArq2WkEY7 = 20
	If(Select("WorkGrp")  > 0, WorkGrp->(E_EraseArq(aArqsTemp[21])),) // cNomArqGrp   // 21
	If(Select("WorkOpos") > 0,WorkOpos->(E_EraseArq(aArqsTemp[22])),) // cNomArqOpos = 22
	If(Select("WKEXZ") > 0, WKEXZ->(E_EraseArq(aArqsTemp[23])),) // cArqCapOIC = 23
	If(Select("WKEY2") > 0, WKEY2->(E_EraseArq(aArqsTemp[24])),) // cArqDetOIC = 24
	If(Select("WkArm") > 0, WkArm->(E_EraseArq(aArqsTemp[25])),) // cWorkArmazem = 25
	//If(Select("WkEYU") > 0, WkEYU->(E_EraseArq(cArqWkEYU)),) //
	If(Select("WkEYU") > 0, WkEYU->(DbCloseArea()),)   // Será aberto chamado para tratar este item.
	If(Select("Wk_NfRem") > 0, Wk_NfRem->(E_EraseArq(aArqsTemp[26])),) // cArqNFRem = 26
	//If(Select("WorkEDG") > 0, WorkEDG->(E_EraseArq(cArqDrawSC)),)
	If(Select("WorkEDG") > 0, WorkEDG->(DbCloseArea()),) // Será aberto chamado para tratar este item.

	DbSelectArea("EEC")

	/*
	aArqsTemp := Ae102SetWorks()
	// Array com os nomes dos arquivos das tabelas temporárias criadas pela função Ae102SetWorks().
	aRet:={cNomArqIp    // 1
	,cNomArq1     // 2
	,cNomArq2     // 3
	,cNomArq3     // 4
	,cNomArq4     // 5
	,cNomArq5     // 6
	,cNomArq6     // 7
	,cNomArq7     // 8
	,cNomArq8     // 9
	,cNomArq82    // 10
	,cNomArq9     // 11
	,cArqCapInv   // 12
	,cArqDetInv   // 13
	,cArq2DetInv  // 14
	,cArqAdiant   // 15
	,cArqWkEY5    // 16
	,cArq2WkEY5   // 17
	,cArqWkEY6    // 18
	,cArqWkEY7    // 19
	,cArq2WkEY7   // 20
	,cNomArqGrp   // 21
	,cNomArqOpos  // 22
	,cArqCapOIC   // 23
	,cArqDetOIC   // 24
	,cWorkArmazem // 25
	,cArqNFRem    // 26
	*/

Return Nil

/*
Função          : CriaWorks()
Parâmetros      :
Retorno         :
Objetivo        : Cria Tabela temporária.
Autor           : Julio de Paula Paz
Data/Hora       : 23/08/2010 - 09:00
Obs.            :
*/
Static Function CriaWorks()
	Local lRet
	Local aCmpDbf := {}
	Local aCmpMsSelect := {}

	Private aHeader:={}
	Private aCampos:={}

	//Begin Sequence
	lRet := .T.
	Aadd(aCmpDbf,{"WK_PREEMB","C",20,0})         //"Processo"
	Aadd(aCmpDbf,{"WK_SEQEMB","C",6 ,0})         //"Seq.Embarq."
	Aadd(aCmpDbf,{"WK_PEDIDO","C",20,0})         //"Pedido Exp."
	Aadd(aCmpDbf,{"WK_SEQUEN","C",6 ,0})         //"Seq.Pedido"
	Aadd(aCmpDbf,{"WK_PEDFAT","C",6 ,0})         //"Ped.de Venda"
	Aadd(aCmpDbf,{"WK_FATIT" ,"C",2 ,0})         //"Item do PV"
	Aadd(aCmpDbf,{"WK_CONTNR","C",20,0})         //"No.Container"
	Aadd(aCmpDbf,{"WK_PALLET","C",20,0})         //"Pallet"
	Aadd(aCmpDbf,{"WK_ORDSEP","C",20,0})         //"Numero Ordem"
	Aadd(aCmpDbf,{"WK_CODETI","C",10,0})         //"Cod.Etiqueta"
	Aadd(aCmpDbf,{"WK_PROD"  ,"C",15,0})         //"Produto"
	Aadd(aCmpDbf,{"WK_VOLUME","C",10,0})         //"Volume"
	Aadd(aCmpDbf,{"WK_ITEM"  ,"C",3 ,0})         //"Item"
	Aadd(aCmpDbf,{"WK_QTEEMB","N",12,2})         //"Qtde Embalad"
	Aadd(aCmpDbf,{"WK_LOTECT","C",10,0})         //"Lote"
	Aadd(aCmpDbf,{"WK_NUMLOT","C",6 ,0})         //"SubLote"
	Aadd(aCmpDbf,{"WK_NUMSER","C",20,0})         //"Num de Serie"
	Aadd(aCmpDbf,{"WK_DOC"   ,"C",9 ,0})         //"Documento"
	Aadd(aCmpDbf,{"WK_TIPVOL","C",3 ,0})         //"Tipo Volume"
	Aadd(aCmpDbf,{"WK_DSCVOL","C",60,0})         //"Descr.Volume"
	Aadd(aCmpDbf,{"WK_PESVOL","N",15,3})         //"Peso Volume"
	Aadd(aCmpDbf,{"WK_CLIENT","C",6 ,0})         //"Importador"
	Aadd(aCmpDbf,{"WK_LOJA  ","C",2 ,0})         //"Loja Import."
	Aadd(aCmpDbf,{"WK_NOMECL","C",60,0})         //"Nome Import."
	Aadd(aCmpDbf,{"WK_DTEMIS","D",8 ,0})         //"Data Emissão Separação Mercadoria"
	Aadd(aCmpDbf,{"WK_FORN"  ,"C",6 ,0})         //"Fornecedor"
	Aadd(aCmpDbf,{"WK_FOLOJA  ","C",2 ,0})       //"Loja Forn."
	Aadd(aCmpDbf,{"WK_NOMFOR" ,"C",60,0})        //"Nome Forn."
	Aadd(aCmpDbf,{"WK_FLAG"  ,"C",2 ,0})         //"Flag"


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomeArq 	:=  CriaTrab(aCmpDbf)
	dbUseArea( .T.,"DBFCDX", cNomeArq,"WorkZZA", .F. , .F. )

	cNomeArqI := Subs(cNomeArq,1,7)+"A"
	IndRegua("WorkZZA",cNomeArqI,"WK_ORDSEP+WK_PEDIDO",,,)		//"Selecionando Registros..."

	dbClearIndex()
	dbSetIndex(cNomeArqI+OrdBagExt())

	/* Ticket 20190507000040 - Everson Santana
	cNomeArq:=E_CriaTrab(,aCmpDbf,"WorkZZA")

	If !Used()
	Help(" ",1,"E_NAOHAREA")
	lRet := .F.
	Break
	EndIf

	IndRegua("WorkZZA",cNomeArq+OrdBagExt(),"WK_ORDSEP+WK_PEDIDO")
	*/

	Aadd(aCmpMsSelect,{"WK_FLAG"  ,"C",2 ,0})         //"Flag"
	Aadd(aCmpMsSelect,{"WK_PREEMB","C",20,0})         //"Processo"
	Aadd(aCmpMsSelect,{"WK_SEQEMB","C",6 ,0})         //"Seq.Embarq."
	Aadd(aCmpMsSelect,{"WK_PEDIDO","C",20,0})         //"Pedido Exp."
	Aadd(aCmpMsSelect,{"WK_SEQUEN","C",6 ,0})         //"Seq.Pedido"
	Aadd(aCmpMsSelect,{"WK_PEDFAT","C",6 ,0})         //"Ped.de Venda"
	Aadd(aCmpMsSelect,{"WK_FATIT" ,"C",2 ,0})         //"Item do PV"
	Aadd(aCmpMsSelect,{"WK_ORDSEP","C",20,0})         //"Numero Ordem"
	Aadd(aCmpMsSelect,{"WK_CLIENT","C",6 ,0})         //"Importador"
	Aadd(aCmpMsSelect,{"WK_LOJA  ","C",2 ,0})         //"Loja Import."
	Aadd(aCmpMsSelect,{"WK_NOMECL","C",60,0})         //"Nome Import."
	Aadd(aCmpMsSelect,{"WK_DTEMIS","D",8 ,0})         //"Data Emissão Separação Mercadoria"
	Aadd(aCmpMsSelect,{"WK_FORN"  ,"C",6 ,0})         //"Fornecedor"
	Aadd(aCmpMsSelect,{"WK_FOLOJA","C",2 ,0})         //"Loja Forn."
	Aadd(aCmpMsSelect,{"WK_NOMFOR","C",60,0})        //"Nome Forn."

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomeArq1 	:=  CriaTrab(aCmpMsSelect)
	dbUseArea( .T.,"DBFCDX", cNomeArq1,"WorkSel", .F. , .F. )

	cNomeArq1I := Subs(cNomeArq1,1,7)+"A"
	IndRegua("WorkSel",cNomeArq1I,"WK_ORDSEP",,,)		//"Selecionando Registros..."

	dbClearIndex()
	dbSetIndex(cNomeArq1I+OrdBagExt())

	/* Ticket 20190507000040 - Everson Santana
	cNomeArq1:=E_CriaTrab(,aCmpMsSelect,"WorkSel")
	If !Used()
	Help(" ",1,"E_NAOHAREA")
	lRet := .F.
	Break
	EndIf
	IndRegua("WorkSel",cNomeArq1+OrdBagExt(),"WK_ORDSEP")
	*/

	cNomeArq2 := CriaTrab(,.f.)

	cNomeArq2I := Subs(cNomeArq2,1,7)+"A"
	IndRegua("WorkSel",cNomeArq2I,"WK_PEDFAT",,,)		//"Selecionando Registros..."

	dbClearIndex()
	dbSetIndex(cNomeArq2I+OrdBagExt())

	/* Ticket 20190507000040 - Everson Santana
	IndRegua("WorkSel",cNomeArq2+OrdBagExt(),"WK_PEDFAT")
	*/

	Set Index To (cNomeArq1I+OrdBagExt()), (cNomeArq2I+OrdBagExt())

	//End Sequence

Return lRet

/*
Função          : GeraDados()
Parâmetros      :
Retorno         :
Objetivo        : Carregar a work de dados com as ordens de separação de embalagens que ainda não
foram vinculadas a um processo de embarque.
Autor           : Julio de Paula Paz
Data/Hora       : 27/08/2010 - 10:00
Obs.            :
*/
Static Function GeraDados()
	Local lRet
	Local cQry
	Local nTotalRegs
	Local cWhere

	//Begin Sequence
	lRet := .T.

	nTotalRegs := 1
	// Contagem de registros
	cQry := "SELECT Count(*) AS NTOTREGS"
	cQry += " FROM "+RetSqlName("CB7")+" CB7 "
	cWhere := " WHERE CB7.D_E_L_E_T_ <> '*' AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"'"
	cWhere += " AND CB7.CB7_PEDIDO <> '"+Space(AvSx3("CB7_PEDIDO",3))+"' "
	cWhere += " AND CB7.CB7_ORDSEP NOT IN (SELECT ZZA_ORDSEP FROM "+RetSqlName("ZZA")+" ZZA WHERE ZZA.D_E_L_E_T_ <> '*' AND ZZA.ZZA_FILIAL = '"+xFilial("ZZA")+"' )"

	cQry := ChangeQuery(cQry+cWhere)
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQry), "QRY2", .F., .T.)

	nTotalRegs := 0
	If !QRY2->(Eof()) .And. ! QRY2->(Bof())
		nTotalRegs := QRY2->NTOTREGS
	EndIf
	QRY2->(DbCloseArea())

	If nTotalRegs == 0
		MsgInfo("Não existem dados para gerar o embarque automaticamente.","Atenção")
		lRet := .F.
		Break
	EndIf

	// Query da Ordem de Separação
	cQry := "SELECT CB7_ORDSEP, CB7_PEDIDO, CB7_CLIENT, CB7_LOJA, CB7_DTEMIS"
	cQry += " FROM "+RetSqlName("CB7")+" CB7 "
	//Giovani Zago 28/03/14 uma bosta este fonte to tentando melhorar.....
	cQry += " INNER JOIN ( SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
	cQry += " ON SC5.C5_NUM  = CB7_PEDIDO
	cQry += " AND SC5.D_E_L_E_T_ = ' '
	cQry += " AND SC5.C5_FILIAL = CB7.CB7_FILIAL
	cQry += " AND SC5.C5_PEDEXP <> ' '
	cQry += " AND SC5.C5_EMISSAO > '20160330' " // GIOVANI ZAGO 06/03/17 CHAMADO: 005108
	//cQry += " WHERE CB7.D_E_L_E_T_ = ' '
	//cQry += " AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"'"


	cQry := ChangeQuery(cQry+cWhere)
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQry), "QRY", .F., .T.)
	TcSetField("QRY","CB7_DTEMIS","D",8,0)

	Procregua(nTotalRegs)
	lTemDados := .F.

	SC5->(DbSetOrder(1)) // C5_FILIAL+C5_NUM  - Chave 1 do pedido de venda módulo Microsiga.
	CB9->(DbSetOrder(2)) // CB9_FILIAL+CB9_ORDSEP+CB9_VOLUME+CB9_DISPID - Chave 2 do cadastro de volumes.
	CB6->(DbSetOrder(2)) // CB6_FILIAL+CB6_PEDIDO+CB6_LOCALI
	CB3->(DbSetOrder(1)) // CB3_FILIAL+CB3_CODEMB
	SA1->(DbSetOrder(1))
	SA2->(DbSetOrder(1))

	Do While !QRY->(Eof())

		If ! SC5->(DbSeek(xFilial("SC5")+QRY->CB7_PEDIDO))
			QRY->(DbSkip())
			Loop
		EndIf

		If Empty(SC5->C5_PEDEXP)
			QRY->(DbSkip())
			Loop
		EndIf

		CB9->(DbSeek(xFilial("CB9")+QRY->CB7_ORDSEP))
		Do While ! CB9->(Eof()) .And. CB9->(CB9_FILIAL+CB9_ORDSEP) == xFilial("CB9")+QRY->CB7_ORDSEP
			// Esta Query através do registro da tabela CB9, posiciona no item de pedido da tabela EE8,
			// tendo como base o numero do pedido de exportação da tabela SC5 e a sequencia do item no pedido de venda (Tabela CB9).
			cQry := " SELECT DISTINCT EE8_SEQUEN,EE8_FORN,EE8_FOLOJA "
			cQry += " FROM "+RetSqlName("EE8")+" EE8 WHERE EE8.D_E_L_E_T_ <> '*' AND EE8.EE8_FILIAL = '"+xFilial("EE8")+"' "
			cQry += " AND EE8.EE8_PEDIDO = '"+SC5->C5_PEDEXP+"' AND EE8.EE8_FATIT = '"+CB9->CB9_ITESEP+"' "

			cQry := ChangeQuery(cQry)
			dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQry), "QRYEE8", .F., .T.)

			If !QRYEE8->(Eof()) .And. !QRYEE8->(Bof())
				CB6->(DbSeek(xFilial("CB6")+QRY->CB7_PEDIDO))
				CB3->(DbSeek(xFilial("CB3")+CB6->CB6_TIPVOL))
				SA1->(DbSeek(xFilial("SA1")+QRY->(CB7_CLIENT+CB7_LOJA)))
				SA2->(DbSeek(xFilial("SA2")+QRYEE8->(EE8_FORN+EE8_FOLOJA)))
				WorkZZA->(DbAppend())
				WorkZZA->WK_PEDIDO  := SC5->C5_PEDEXP //"Pedido Exp."
				WorkZZA->WK_SEQUEN  := QRYEE8->EE8_SEQUEN //"Seq.Pedido"
				WorkZZA->WK_PEDFAT  := QRY->CB7_PEDIDO //"Ped.de Venda"
				WorkZZA->WK_FATIT   := CB9->CB9_ITESEP //"Item do PV"
				WorkZZA->WK_ORDSEP  := QRY->CB7_ORDSEP //"Numero Ordem"
				WorkZZA->WK_CODETI  := CB9->CB9_CODETI //"Cod.Etiqueta"
				WorkZZA->WK_PROD    := CB9->CB9_PROD //"Produto"
				WorkZZA->WK_VOLUME  := Right(Alltrim(CB9->CB9_VOLUME),4) //"Volume"
				WorkZZA->WK_ITEM    := CB9->CB9_ITEM //"Item"
				WorkZZA->WK_QTEEMB  := CB9->CB9_QTESEP //"Qtde Embalad"
				WorkZZA->WK_LOTECT  := CB9->CB9_LOTECT //"Lote"
				WorkZZA->WK_NUMLOT  := CB9->CB9_NUMLOT //"SubLote"
				WorkZZA->WK_NUMSER  := CB9->CB9_NUMSER //"Num de Serie"
				WorkZZA->WK_DOC     := CB9->CB9_DOC //"Documento"
				WorkZZA->WK_TIPVOL  := CB3->CB3_CODEMB//"Tipo Volume"
				WorkZZA->WK_DSCVOL  := CB3->CB3_DESCRI//"Descr.Volume"
				WorkZZA->WK_PESVOL  := CB3->CB3_PESO//"Peso Volume"
				WorkZZA->WK_CLIENT  := SA1->A1_COD //"Importador"
				WorkZZA->WK_LOJA    := SA1->A1_LOJA //"Loja Import."
				WorkZZA->WK_NOMECL  := SA1->A1_NOME //"Nome Import."
				WorkZZA->WK_DTEMIS  := QRY->CB7_DTEMIS //"Data Emissão Separação Mercadoria"
				WorkZZA->WK_FORN    := SA2->A2_COD //"Fornecedor"
				WorkZZA->WK_FOLOJA  := SA2->A2_LOJA //"Loja Forn."
				WorkZZA->WK_NOMFOR 	:= SA2->A2_NOME// Nome Forn.
				WorkZZA->(MsUnlock())
			EndIf
			QRYEE8->(DbCloseArea())

			CB9->(DbSkip())
		EndDo

		QRY->(DbSkip())
	EndDo
	QRY->(DbCloseArea())

	WorkZZA->(DbGoTop())

	// Tabela de work para ser exibida no MsSelect para o usuário selecionar a ordens de separação
	// para criação do processo de embarque.
	Do While ! WorkZZA->(Eof())
		If !WorkSel->(DbSeek(WorkZZA->WK_ORDSEP))
			WorkSel->(DbAppend())
			AvReplace("WorkZZA","WorkSel")
			WorkSel->(MsUnlock())
		EndIf
		WorkZZA->(DbSkip())
	EndDo

	//End Sequence

Return lRet

/*
Função          : ValidaSel()
Parâmetros      : Nenhum
Retorno         : .T. / .F.
Objetivo        : Validar as seleções de ordens de separação para a geração automática de processos de embarque da exportação.
Autor           : Julio de Paula Paz
Data/Hora       : 27/08/2010 - 10:00
Obs.            :
*/
Static Function ValidaSel()
	Local lRet := .T.
	Local lSelecionou := .F.
	Local cImportLoja := ""
	Local cFornecLoja := ""

	Begin Sequence
		WorkSel->(DbGoTop())
		If WorkSel->(Eof())
			If !Empty(WorkSel->WK_FLAG)
				cImportLoja := (WorkSel->WK_CLIENT + WorkSel->WK_LOJA)
				cFornecLoja := (WorkSel->WK_FORN + WorkSel->WK_FOLOJA)
			EndIf
		EndIf
		Do While ! WorkSel->(Eof())
			If !Empty(WorkSel->WK_FLAG) .And. Empty(cImportLoja)
				cImportLoja := (WorkSel->WK_CLIENT + WorkSel->WK_LOJA)
				cFornecLoja := (WorkSel->WK_FORN + WorkSel->WK_FOLOJA)
			EndIf

			If !Empty(WorkSel->WK_FLAG)
				If cImportLoja <> (WorkSel->WK_CLIENT + WorkSel->WK_LOJA)
					MsgStop("Não é permitido selecionar clientes diferentes para gerar o processo de embarque.","Atenção")
					lRet := .F.
					Break
				EndIf
				If cFornecLoja <>(WorkSel->WK_FORN + WorkSel->WK_FOLOJA)
					MsgStop("Não é permitido selecionar Fornecedores diferentes para gerar o processo de embarque.","Atenção")
					lRet := .F.
					Break
				EndIf
				lSelecionou := .T.
			EndIf
			WorkSel->(DbSkip())
		EndDo
		If !lSelecionou
			MsgStop("Para gerar o processo de embarque é obrigatório a seleção de pelo menos uma ordem de separação.","Atenção")
			lRet := .F.
			Break
		EndIf
	End Sequence

Return lRet

/*
Função          : GrvEmbarque()
Parâmetros      : Nenhum
Retorno         : .T. / .F.
Objetivo        : Criar automaticamente os processos de embarque.
Autor           : Julio de Paula Paz
Data/Hora       : 27/08/2010 - 10:00
Obs.            :
*/
Static Function GrvEmbarque()
	Local lRet := .F.
	Local nI, nProcesso
	Local aOrd := SaveOrd({"EEC","SX3","EE8"})
	Local nOrderSX3 := SX3->(IndexOrd())

	// Cria as variáveis de memória para geração do embarque. Abre as tabelas do Embarque.
	dbSelectArea("EXB")
	dbSelectArea("SYS")
	IF SX2->(dbSeek("EXL"))
		dbSelectArea("EXL")
	Endif
	IF SX2->(dbSeek("EXM"))
		dbSelectArea("EXM")
	Endif
	IF SX2->(dbSeek("EES"))
		dbSelectArea("EES")
	Endif
	IF SX2->(dbSeek("EXP"))
		dbSelectArea("EXP")
	Endif
	IF SX2->(dbSeek("EXR"))
		dbSelectArea("EXR")
	Endif

	//Tabelas de Armazéns
	IF SX2->(dbSeek("EY5"))
		dbSelectArea("EY5")
	Endif
	IF SX2->(dbSeek("EY7"))
		dbSelectArea("EY7")
	Endif

	dbSelectArea("EEF")

	Private Inclui := .T.
	Private nSelecao := 3
	Private lIntegra:=IsIntFat()
	Private lConsolida := EECFlags("INTERMED")

	Private lInt := lIntegra // lIntegra nao cabia no x3_when do ee9_sldini

	Private cFilSB1Aux  := xFilial("SB1"), lAbriuExp:= .F.
	Private cTIPMEN:=TM_SIT,cIDCAPA

	Private cCadastro:=AVTITCAD("EEC")//"Embarque"

	Private cWHENOD,cVIA,cWHENSA1,cWHENSA2,lMV0039,aMEMOITEM

	Private bTotal := {|x| x := if(x=="SOMA",1,-1),;
	M->EEC_PESLIQ += x*If(lConvUnid,AvTransUnid(WorkIp->EE9_UNPES,If(!Empty(M->EEC_UNIDAD),M->EEC_UNIDAD,"KG"),WorkIp->EE9_COD_I,WorkIp->EE9_PSLQTO,.F.),WorkIp->EE9_PSLQTO),;
	M->EEC_PESBRU += x*If(lConvUnid,AvTransUnid(WorkIp->EE9_UNPES,If(!Empty(M->EEC_UNIDAD),M->EEC_UNIDAD,"KG"),WorkIp->EE9_COD_I,WorkIp->EE9_PSBRTO,.F.),WorkIp->EE9_PSBRTO),;
	M->EEC_TOTPED += x*WorkIP->EE9_PRCINC,;
	M->EEC_TOTITE += x*1,;
	AE100TTela(.F.)}

	Private aMemos := { {"EEC_CODMAR","EEC_MARCAC"},;
	{"EEC_DSCGEN","EEC_GENERI"},;
	{"EEC_CODMEM","EEC_OBS"},;
	{"EEC_CODOBP","EEC_OBSPED"} }

	Private lLibPes:= GetNewPar("MV_AVG0009",.F.)

	Private aCampoPed:={}, aPITDELETADOS:={}, aPITPOS, lPITGRAVA

	Private aCAMPOPIT:={}

	Private lSITUACAO:=.T.

	Private oItens,oVlrTotSCob, oPedido, oLiquido, oBruto, cITEPIC:=AVSX3("EEC_TOTITE",AV_PICTURE),;
	cTPEPIC:=AVSX3("EEC_TOTPED",AV_PICTURE), cPLIPIC:=AVSX3("EEC_PESLIQ",AV_PICTURE),;
	cPBRPIC:=AVSX3("EEC_PESBRU",AV_PICTURE),cPESQDESP,aHDENCHOICE

	Private aCamposEXL := {}

	//Cria variaveis para Cambio
	Private aITEMCAMBIO

	//Cria variaveis para Itens processos
	Private aITEMENCHOICE

	//Cria variaveis para Registro documentos
	Private aITEMREGDOC

	//Cria variaveis para transito
	Private aITEMTRANSITO

	//Cria variaveis para faturamento
	Private aITEMFATURA

	// Cria variaveis para Depesas ...
	Private aDeEnchoice, aDePos, aDeBrowse

	// Cria variaveis para agentes/empresas
	Private aAgEnchoice, aAgPos, aAgBrowse

	// Cria variaveis para instituicoes
	Private aInEnchoice, aInPos, aInBrowse

	// Alterado por Heder M Oliveira - 8/13/1999
	Private cCodImport := Space(AVSX3("EEC_IMPORT",AV_TAMANHO)) // Usado na funcao AE100IMPORT

	// Cria variaveis para Notas Fiscais AWR Sexta Feira 13/08/1999
	Private aNFDeletados:={}

	// Cria variaveis para Notify's.
	Private aNoEnchoice, aNoPos, aNoBrowse

	// Cria variaveis para a agenda de atividades.
	Private aDocBrowse, aDocDeletados:={}
	Private cTPMODU := ""
	Private lTemTPMODU
	Private bTPMODUECF

	Private aPreCalcBrowse, aPreCalcDeletados:={}

	Private lConsign := EECFlags("CONSIGNACAO")
	If lConsign .And. !Type("cTipoProc") == "C"
		Private cTipoProc := PC_RG
	EndIf

	Private lBACKTO    := GetMV("MV_BACKTO",,.F.) .AND. ChkFile("EXK") ;
	.AND. EE8->( FieldPos("EE8_INVPAG") > 0 ) .AND. EE9->( FieldPos("EE9_INVPAG") > 0  );
	.And. (!lConsign .Or. cTipoProc $ PC_BN+PC_BC)

	//Cria variáveis para uso nas funções do Drawback
	Private lIntDraw := (!lConsign .OR. !lBackTo) .And. GetMV("MV_EEC_EDC",,.F.) .And. ( GetMV("MV_AVG0024",,"") != SM0->M0_CODFIL .Or. Empty( GetMV("MV_AVG0024",,"") ) )
	Private lIntFina := GetMV("MV_EEC_EFF",,.F.) //Verifica se existe a integração com o Módulo SIGAEFF
	SX3->(DBSETORDER(2))
	Private lExistEDD   := SX3->(dbSeek("EDD_FILIAL"))
	Private lOkEE9_ATO  := SX3->(dbSeek("EE9_ATOCON"))
	Private lYSTPMODU   := SX3->(DBSEEK("YS_TPMODU")) .AND. SX3->(DBSEEK("YS_MOEDA"))
	Private lOkYS_PREEMB:= SX3->(dbSeek("YS_PREEMB")) .and. SX3->(dbSeek("YS_INVEXP"))
	lTemTPMODU := SX3->(DbSeek("ECF_TPMODU"))

	If lIntDraw .And. lConsign .And. cTipoProc $ PC_VR+PC_VB
		lIntDraw := .F.
	EndIf

	//Selecionar Pedido(Integrado com Faturamento - SIGAFAT) não Faturado.
	Private lSelNotFat := SuperGetMV("MV_AVG0067", .F., .F., xFilial("EE9"))

	Private lNRotinaLC := .f.
	lNRotinaLC :=    (EEL->(FieldPos("EEL_SLDVNC")) # 0) ;
	.And. (EEL->(FieldPos("EEL_SLDEMB")) # 0) ;
	.And. (EEL->(FieldPos("EEL_RENOVA")) # 0)

	Private lTratComis := GETMV("MV_AVG0077",,.F.)

	Private cOcorre := OC_EM

	Private aInvEnchoice, aInvBrowse

	Private aDetInvBrowse
	Private aDetInvEnchoice,aAltDetInv
	Private aCInvDeletados := {}
	Private aDInvDeletados := {}
	Private lRefazRateio   := .F.

	//Manutenção de OIC´s
	Private aCapOICDel := {}
	Private aDetOICDel := {}
	Private aEXZBrowse := {}
	Private aEY2Browse := {}
	Private aSafras    := {}

	Private lDrawSC := ChkFile("EDG")   //Verifica se a tabela para Draw Back sem cobertura cambial existe (EDG)
	Private aDelEdg := {}
	Private aEY7Deletados := {}

	//Retorno do F3 nos Itens do Pedido
	Private cRetF3BtB

	Private aCampoEYU, lItFabric := GetMv("MV_AVG0138",,.F.), aItFabPos, aEYUDel,nRegFabrIt

	Private lIntEmb := EECFlags("INTEMB")
	Private lMFilEDC  := VerSenha(115)  ;
	.And.  Posicione("SX2",1,"ED1","X2_MODO") == "C" ;
	.And.  Posicione("SX2",1,"ED2","X2_MODO") == "C" ;
	.And.  Posicione("SX2",1,"EDD","X2_MODO") == "C" ;
	.And.  Posicione("SX2",1,"EE9","X2_MODO") == "E" ;
	.And.  Posicione("SX2",1,"SW8","X2_MODO") == "E" ;
	.And.  ED1->( FieldPos("ED1_FILORI") ) > 0  ;
	.And.  ED2->( FieldPos("ED2_FILORI") ) > 0  ;
	.And.  EDD->( FieldPos("EDD_FILEXP") ) > 0  ;
	.And.  EDD->( FieldPos("EDD_FILIMP") ) > 0

	If Select("Header_p") = 0
		AbreEEC()
	EndIf

	If lTemTPMODU
		cTPMODU:='EXPORT'
		bTPMODUECF := {|| ECF->ECF_TPMODU = 'EXPORT' }
	Else
		bTPMODUECF := {|| .T. }
	EndIf

	If lIntDraw
		// Verifica se o F3 de Ato Concessório está ativado.
		If SX3->( dbSeek("EE9_ATOCON") ) .AND. Empty(SX3->X3_F3)
			RecLock("SX3",.F.)
			SX3->X3_F3 := "EI1"
			SX3->( MsUnLock() )
		Endif
		//
	Else
		// Retirae o F3 de Ato Concessório caso não haja integração.
		If SX3->( dbSeek("EE9_ATOCON") ) .AND. !Empty(SX3->X3_F3)
			RecLock("SX3",.F.)
			SX3->X3_F3 := "   "
			SX3->( MsUnLock() )
		Endif
		//**
		If lExistEDD
			Private fWorkAnt, fWorkAnt2, fWorkAnt3
		EndIf
	EndIf

	SX3->(DBSETORDER(nOrderSX3))

	Private cFilED3, cFilSA5:=xFilial("SA5"), cFilED0, cFilEE9:=xFilial("EE9"), cFilEDD, cFilED1, cFilED2
	Private cFilEE8:=xFilial("EE8"), cFilSYS:=xFilial("SYS"), cFilEDE

	// Flag para verificacao de intermediario na geracao do embarque...
	Private lIntermed :=.f.

	Private cItens:=""

	Private lALTERA:=.T.

	Private lCambio := .F.

	// Flag para conversao de unidades ...
	Private lConvUnid:=.f.

	// Flag para tratamento de commodities ...
	Private lCommodity:=.f.

	// ** Flag para acionamento de Adiantamentos (pagamento antecipado).
	Private lPagtoAnte := GetMv("MV_AVG0039",,.f.)

	// ** Flag para teste nos gatilhos na manutencao de pagamento antecipado.
	Private lIsEmb := .t.

	// ** Flag para habilitar botão de digitação dos dados do siscomex. (RE/SD/Ato concessório).
	Private lDigDataSis := .f.

	Private lRecriaPed := .f., lAtuFil := .f.

	Private aEECCamposEditaveis := {}

	/* Array de controle de dados importantes para os tratamentos de pré-calculo. Os valores que serão gravados
	no array, servirá para verificar qdo as despesas terão que se reapuradas. */
	Private aDadosPreCalc := {}

	Private cFilBr := "", cFilEx := ""

	Private lB2BFat := IsProcNotFat()

	Private bTiraMark := {|| WorkIP->WP_FLAG:="",;
	If(lIntegra .and. !lB2BFat .and. !lSelNotFat, WorkIP->WP_SLDATU := WorkIP->EE9_SLDINI, WorkIP->WP_SLDATU += WorkIP->EE9_SLDINI ),; //ER - 03/12/2008. Apenas quando for integração com o Faturamento, sem a possibilidade de incluir Embarques sem Nota e em processos regulares que o saldo será copiado e não adicionado ao campo WP_SLDATU.
	WORKIP->WP_OLDINI := WorkIP->EE9_SLDINI,;
	WorkIP->EE9_SLDINI := 0,;
	SubTotal(),;
	WorkIP->EE9_PRCTOT := 0,;
	WorkIP->EE9_PRCINC := 0,;
	If(!lLibPes,WorkIP->EE9_PSLQTO := 0,),; // JPM - !lLibPes - 23/02/06 - Não zerar os pesos quando for digitação manual.
	If(!lLibPes,WorkIP->EE9_PSBRTO := 0,),;
	WorkIP->EE9_QTDEM1 := 0,;
	AEAntMarca(2), AE108VlMark(.F.) }


	// ** Define se haverão os novos tratamentos de alteração de valores após o embarque.
	Private lAltValPosEmb := GetMv("MV_AVG0081",,.f.)

	// ** Habilita os novos tratamentos de multi Off-Shore
	Private lMultiOffShore := GetMv("MV_AVG0083",,.f.) .And. EEC->(FieldPos("EEC_NIOFFS")) > 0;
	.And. EEC->(FieldPos("EEC_CLIENF")) > 0;
	.And. EEC->(FieldPos("EEC_CLOJAF")) > 0


	/* Flag para habilitar/desabilitar a rotina de
	levantamento de campos e replicação de dados na filial de off-shore. */
	Private lReplicaDados := GetMv("MV_AVG0079",,.f.)

	Private aProdComDif:={}

	// Variável que define se é uma replicacao de processo - Novos tratamentos de Multi Off-Shore
	Private lReplicacao := .f.

	// ** Variáveis utilizadas na função de replicação de dados.
	Private cArqMain, cArqMain2, cArqMain3, cArqMain4

	// Arquivo temporário utilizado na validação e controle de adiantamentos.
	Private cArqAdiant

	Private lNfRemessa := .F.
	If GetMv("MV_AVG0174",.T.)
		lNfRemessa := GetMv("MV_AVG0174",.F.,.F.) .and. lIntegra
	EndIf
	/* Inclusão do tratamento de nota fiscal de remessa, para atender
	ao convênio ICMS n.º 84 no DOU de 29/09/09 */
	If lNfRemessa
		ChkFile("EYY")
		Select("EYY")

		If FieldPos("EYY_PEDIDO") == 0 .And. FieldPos("EYY_SEQUEN") == 0 .And. FieldPos("EYY_FASE") == 0
			MsgInfo("Para continuar utilizando a rotina de notas fiscais de remessa será necessário " + ENTER +;
			"aplicar o compatibilizador UE080265. Favor contactar o suporte técnico " + ENTER +;
			"da Average Tecnologia ou do fornecedor do seu sistema.", "Atenção")
			lNfRemessa:= .F.
		EndIf
	EndIf


	Private aNfRemDeletados := {}
	Private cArqNFRem

	lCommodity := EECFlags("COMMODITY")

	If (EEC->(FieldPos("EEC_UNIDAD")) # 0) .And. (EE9->(FieldPos("EE9_UNPES")) # 0) .And.;
	(EE9->(FieldPos("EE9_UNPRC")) # 0)
		lConvUnid :=.t.
	EndIf

	lIntermed := EECFlags("INTERMED")

	// Variáveis referentes à rotina de controle de quantidades entre filiais Brasil e Off-Shore
	If EECFlags("INTERMED")  //A rotina controle de quantidade passou a ser padrão para Off-Shore
		Private aConsolida := {}
		Ap104KeyX3(aConsolida) // acerta tamanho

		// Campos da work de agrupamento e da msselect
		Private aGrpCpos  := {"WP_FLAG",;
		"EE9_PEDIDO","EE9_ORIGEM","EE9_COD_I" ,"EE9_VM_DES",;
		"EE9_FORN"  ,"EE9_FOLOJA","EE9_FABR"  ,"EE9_FALOJA",;
		"EE9_PART_N","EE9_PRECO" ,"EE9_UNIDAD","EE9_SLDINI",;
		"EE9_PRCTOT","EE9_PRCINC","EE9_PSLQUN","EE9_PSLQTO",;
		"EE9_EMBAL1","EE9_QTDEM1","EE9_QE"    ,"EE9_PSBRUN",;
		"EE9_PSBRTO","WP_SLDATU"}
		Ap104KeyX3(aGrpCpos) // acerta tamanho

		// Informações referentes aos campos acima. "S" - Sempre igual, "N" - Não é sempre igual, "T" - Totaliza
		// Obs.: para cada posição do aGrpCpos, deve ter uma posição correspondente no aGrpInfo
		Private aGrpInfo  := {"S",;
		"S","S","S","S",; // Para o campo EE9_VM_DES as informações devem ser sempre iguais para todo o grupo. Se for "N" o campo não aparece na enchoice.
		"S","S","S","S",;
		"S","N","S","T",;
		"T","T","S","T",;
		"S","T","S","S",;
		"T","T"}

		Private bConsolida, cGrpFilter, cConsolida := Ap104StrCpos(aConsolida)// variáveis para filtro
		Private b2Consolida, c2GrpFilter // filtro da filial oposta

		ASize(aGrpCpos,Len(aGrpCpos)+Len(aConsolida)) //redimensiona para colocar os campos do aConsolida.
		ASize(aGrpInfo,Len(aGrpCpos))
		For nI := 1 To Len(aConsolida)
			If (nPos := AScan(aGrpCpos,aConsolida[nI])) > 0
				aGrpInfo[nPos] := "S"
				ASize(aGrpCpos,Len(aGrpCpos)-1)
				ASize(aGrpInfo,Len(aGrpCpos))
			Else
				AIns(aGrpCpos,nI+4)
				aGrpCpos[nI+4] := aConsolida[nI]
				AIns(aGrpInfo,nI+4)
				aGrpInfo[nI+4] := "S" // sempre igual
			EndIf
		Next
	EndIf

	Private aGrpBrowse

	If EECFLAGS("CAFE")
		Private cEmpOIC, cComplOic
	EndIF

	Private cWorkArmazem // Manutenção de Armazéns

	Private cFilAtu  := xFilial("EEC")
	Private lFilBr   := cFilAtu == cFilBr
	Private cFilOpos := If(lFilBr,cFilEx,cFilBr)
	Private lFilEx   := !lFilBr

	// Desabilita/Habilita mensagem(opção) para eliminar saldo de pedidos embarcados parcialmente.
	Private lMsgZeraSaldo := GetMv("MV_AVG0136",,.F.)

	Private lNfRemNovaVersao:= .F.

	Private aPedidos := {}

	Private __KEEPUSRFILES // By JPP - 26/02/2013

	Private lTotRodape

	// Flag para habilitar botão de digitação dos dados do siscomex. (RE/SD/Ato concessório).
	lDigDataSis := GetMv("MV_AVG0054",,.f.)

	If lIntDraw .and. lOkEE9_ATO
		cFilED3 := xFilial("ED3")
		cFilED0 := xFilial("ED0")
		cFilED1 := xFilial("ED1")
		cFilED2 := xFilial("ED2")
		ED2->(dbSetOrder(2))
		ED0->(dbSetOrder(2))
		ED1->(dbSetOrder(1))
		If lExistEDD
			cFilEDD := xFilial("EDD")
			cFilEDE := xFilial("EDE")
		EndIf
	EndIf
	lMV0039 := GETMV("MV_AVG0039",,.F.)

	// CAMPO MEMO DOS ITENS
	aMEMOITEM := {{"EE9_DESC","EE9_VM_DES"}}

	If EECFlags("AMOSTRA")
		aAdd(aMEMOITEM,{"EE9_QUADES","EE9_DSCQUA"})
	EndIf

	If EECFlags("INTTRA")
		aAdd(aMemoItem, {"EE9_DINTCD", "EE9_DINT"})
	EndIf

	Begin Sequence
		WorkSel->(DbSetOrder(2)) // WK_PEDFAT
		WorkSel->(DbSetFilter({|| WK_FLAG == cMarca },"WK_FLAG =='"+cMarca+"'"))
		WorkSel->(dbGoTop())

		cProcesso := GetMv("MV_STECK01",,"000000")
		nProcesso := Val(Alltrim(cProcesso)) + 1
		cProcesso := StrZero(nProcesso,6) + "/" + Right(Str(Year(dDatabase),4),2)
		EEC->(DbSetOrder(1))
		Do While .T. // Este procedimento foi desenvolvido para evitar duplicidade na geração de processos. No caso de dois usuários acessarem a rotina juntos.
			If !MsgYesNo("Confirma a geração do processo de embarque: '" + cProcesso + "' "+ENTER+;
			"Para as Ordens de Separação selecionadas?","Atenção")
				Break
			EndIf
			If EEC->(DbSeek(xFilial("EEC")+AvKey(cProcesso,"EEC_PREEMB")))
				If MsgYesNo("Já existe um processo de embarque com esse número. Deseja gerar um novo número de processo?","Atenção")
					cProcesso := GetMv("MV_STECK01",,"000000")
					nProcesso := Val(Alltrim(cProcesso)) + 1
					cProcesso := StrZero(nProcesso,6) + "/" + Right(Str(Year(dDatabase),4),2)
					If EEC->EEC_PREEMB == AvKey(cProcesso,"EEC_PREEMB")
						nProcesso := nProcesso + 1
						cProcesso := StrZero(nProcesso,6) + "/" + Right(Str(Year(dDatabase),4),2)
					EndIf
				Else
					MsgInfo("A Geração de Processo de Embarque foi cancelada!","Atenção")
					Break
				EndIf
			Else
				Exit
			EndIf
		EndDo

		// Atualiza o parâmetro "MV_STECK01" com o ultimo número de processo gerado.
		SetMv("MV_STECK01",StrZero(nProcesso))

		// Cria numeração do Embarque conforme Pedidos Selecionados. // Fernando - 22/11/13
		Processa( {|| SelCodEmb() },"Cria numeração do Embarque conforme Pedidos Selecionados..." )

		// Seleciona itens de embarque para geração do processo.
		Processa( {|| SelItWorkZZA() },"Selecionando itens de embarque para criação do processo..." )

		// Cria as tabela de Works para geração do embarque. Os nomes das tabelas são armazenados no array aArqsTemp.
		aArqsTemp := Ae102SetWorks()

		WorkIp->(DbSetOrder(1))

		For nI := 1 To EEC->(Fcount())
			M->&(EEC->(FieldName(nI))) := CRIAVAR(EEC->(FieldName(nI)))
		Next
		SX3->(DbSetOrder(1))
		SX3->(DbSeek("EEC"))
		Do While ! SX3->(Eof()) .AND. SX3->X3_ARQUIVO == "EEC"
			If SX3->X3_CONTEXT = "V"
				cCAMPO  := ALLTRIM(SX3->X3_CAMPO)
				&cCAMPO := ""
			EndIf
			SX3->(DbSkip())
		EndDo
		For nI := 1 To EXL->(FCount())
			M->&(EXL->(FieldName(nI))) := Criavar(EXL->(FieldName(nI)))
		Next
		M->EEC_STATUS := ST_DC //aguardando confeccao documentos
		DSCSITEE7(.F.,OC_EM)
		cIDCAPA       := M->EEC_IDIOMA

		WorkZZA->(DbSetFilter({|| WK_FLAG == cMarca },"WK_FLAG =='"+cMarca+"'")) // Apenas os registros selecionados irão grar o embarque.
		WorkZZA->(DbGoTop()) // Posiciona no primeiro registro da tabela ZZA para pegar o primeiro numero de pedido.

		M->EEC_PREEMB := cProcesso
		M->EEC_PEDREF := WorkZZA->WK_PEDIDO

		AE100PEDREF() // Carrega a capa do processo de embarque.

		M->EEC_PREEMB := cProcesso

		WorkIP->(__dbZap())
		Processa( {|| CarregaItEmb() },"Carrega os itens de embarque..." )

		Processa( {|| lRet := VldSaldoEE8() }," Validando Saldos dos itens de pedido..." )

		If !lRet
			MsgStop("Não existem saldos disponíveis nos itens de pedido para geração do embarque!","Atenção")
			Break
		EndIf

		// Grava o processo de embarque criado sobre os dados lidos da Ordem de Separação.
		AE102SETGRVEMB()

		Processa( {|| lRet := AtuSaldoEE8() }," Atualizando saldos itens de pedido..." )

		WorkZZA->(DbGoTop())
		Do While ! WorkZZA->(Eof())
			If Empty(WorkZZA->WK_FLAG)
				WorkZZA->(DbSkip())
				Loop
			EndIf
			*
			ZZA->(Reclock("ZZA",.T.))
			ZZA->ZZA_FILIAL := xFilial("ZZA")
			ZZA->ZZA_PREEMB := WorkZZA->WK_PREEMB       //"Processo"
			ZZA->ZZA_SEQEMB := WorkZZA->WK_SEQEMB       //"Seq.Embarq."
			ZZA->ZZA_PEDIDO := WorkZZA->WK_PEDIDO       //"Pedido Exp."
			ZZA->ZZA_SEQUEN := WorkZZA->WK_SEQUEN       //"Seq.Pedido"
			ZZA->ZZA_PEDFAT := WorkZZA->WK_PEDFAT       //"Ped.de Venda"
			ZZA->ZZA_FATIT  := WorkZZA->WK_FATIT        //"Item do PV"
			ZZA->ZZA_CONTNR := WorkZZA->WK_CONTNR       //"No.Container"
			ZZA->ZZA_PALLET := WorkZZA->WK_PALLET       //"Pallet"
			ZZA->ZZA_ORDSEP := WorkZZA->WK_ORDSEP       //"Numero Ordem"
			ZZA->ZZA_CODETI := WorkZZA->WK_CODETI       //"Cod.Etiqueta"
			ZZA->ZZA_PROD   := WorkZZA->WK_PROD         //"Produto"
			ZZA->ZZA_VOLUME := WorkZZA->WK_VOLUME       //"Volume"
			ZZA->ZZA_ITEM   := WorkZZA->WK_ITEM         //"Item"
			ZZA->ZZA_QTEEMB := WorkZZA->WK_QTEEMB       //"Qtde Embalad"
			ZZA->ZZA_LOTECT := WorkZZA->WK_LOTECT       //"Lote"
			ZZA->ZZA_NUMLOT := WorkZZA->WK_NUMLOT       //"SubLote"
			ZZA->ZZA_NUMSER := WorkZZA->WK_NUMSER       //"Num de Serie"
			ZZA->ZZA_DOC    := WorkZZA->WK_DOC          //"Documento"
			ZZA->ZZA_TIPVOL := WorkZZA->WK_TIPVOL       //"Tipo Volume"
			ZZA->ZZA_DSCVOL := WorkZZA->WK_DSCVOL       //"Descr.Volume"
			ZZA->ZZA_PESVOL := WorkZZA->WK_PESVOL       //"Peso Volume"
			*
			ZZA->ZZA_CLIENT := WorkZZA->WK_CLIENT       //"Importador"
			ZZA->ZZA_LOJACL := WorkZZA->WK_LOJA         //"Loja Import."
			ZZA->ZZA_NOMECL := WorkZZA->WK_NOMECL       //"Nome Import."
			ZZA->ZZA_DTEMIS := WorkZZA->WK_DTEMIS       //"Data Emissão Separação Mercadoria"
			ZZA->ZZA_FORN   := WorkZZA->WK_FORN         //"Fornecedor"
			ZZA->ZZA_FOLOJA := WorkZZA->WK_FOLOJA       //"Loja Forn."
			ZZA->ZZA_NOMFOR := WorkZZA->WK_NOMFOR      //"Nome Forn."

			WorkZZA->(DbSkip())
		EndDo
		lRet := .T.
	End Sequence

	RestOrd(aOrd)

Return lRet

/*
Função          : SelItWorkZZA()
Parâmetros      :
Retorno         :
Objetivo        : Selecionando itens de embarque para criação do processo
Autor           : Julio de Paula Paz
Data/Hora       : 27/08/2010 - 09:40
Obs.            :
*/
Static Function SelItWorkZZA()
	Local lRet

	//Begin Sequence
	WorkSel->(DbGoTop())
	Do While ! WorkSel->(Eof())
		ProcRegua(WorkZZA->(LastRec()))

		WorkZZA->(DbSeek(WorkSel->WK_ORDSEP))
		Do While ! WorkZZA->(Eof()) .And. WorkZZA->WK_ORDSEP == WorkSel->WK_ORDSEP
			IncProc("Selcionando itens da Ordem de separação: '"+AllTrim(WorkSel->WK_ORDSEP)+"' ")
			WorkZZA->(RecLock("WorkZZA",.F.))
			WorkZZA->WK_FLAG := cMarca
			WorkZZA->WK_PREEMB := cProcesso
			WorkZZA->(MsUnlock())

			WorkZZA->(DbSkip())
		EndDo

		WorkSel->(DbSkip())
	Enddo

	//End Sequence

Return lRet

/*
Função          : CarregaItEmb()
Parâmetros      :
Retorno         :
Objetivo        : Carrega os itens de embarque com os dados da tabela WorkZZA.
Autor           : Julio de Paula Paz
Data/Hora       : 30/08/2010 - 12:12
Obs.            :
*/
Static Function CarregaItEmb()
	Local lRet
	Local nI, nJ
	Local nQtd
	Local cSeqEmb
	Local aCpoNotCopy := {"EE8_FATIT"}

	//Begin Sequence
	ProcRegua(WorkZZA->(LastRec()))
	WorkZZA->(DbGoTop())
	EE8->(DbSetOrder(1))

	Do While ! WorkZZA->(Eof())
		IncProc("Processando Pedido/Sequencia: '"+AllTrim(WorkZZA->WK_PEDIDO)+"/"+WorkZZA->WK_SEQUEN)
		EE8->(DbSeek(xFilial("EE8")+WorkZZA->(WK_PEDIDO+WK_SEQUEN)))
		WorkIp->(DbSetOrder(1))
		If ! WorkIp->(DbSeek(WorkZZA->(WK_PEDIDO+WK_SEQUEN)))
			WorkIp->(DbSetOrder(2))
			WorkIp->(DbGoBottom())
			cSeqEmb := Str(Val(WorkIP->EE9_SEQEMB)+1,AvSx3("EE9_SEQEMB",AV_TAMANHO))

			WorkIP->(DBAPPEnd())

			For nI := 1 To EE8->(FCount())
				cField := EE8->(FieldName(nI))

				//Verifica os campos que não devem ser carregados automaticamente.
				If aScan(aCpoNotCopy,cField) > 0
					Loop
				EndIf

				bGETSETEE8:=FIELDWBLOCK(cFIELD,Select("EE8"))
				cFIELDEE9:="EE9"+SubStr(ALLTRIM(cFIELD),4)
				bGETSETEE9:=FIELDWBLOCK(cFIELDEE9,Select("WorkIP"))
				If ( WorkIP->(FIELDPOS(cFIELDEE9))#0)
					EVAL(bGETSETEE9,EVAL(bGETSETEE8))
				EndIf
			Next nI

			WorkIP->TRB_ALI_WT:= "EE8"
			WorkIP->TRB_REC_WT:= EE8->(Recno())

			For nJ := 1 To Len(aMemoItem)
				cCampoCod := "EE8"+Substr(aMemoItem[nJ,1],4,7)
				cCampoMem := "EE8"+Substr(aMemoItem[nJ,2],4,7)
				If EE8->(Fieldpos(cCampoCod)) > 0 .And. AvSX3(cCampoMem,,,.t.) .And.;
				EE9->(Fieldpos(aMemoItem[nJ,1])) > 0 .And. AvSX3(aMemoItem[nJ,2],,,.t.)
					WorkIp->&(aMemoItem[nJ,2]) := MSMM(&("EE8->"+cCampoCod),AVSX3(cCampoMem)[AV_TAMANHO])
				EndIf
			Next
			WorkIP->EE9_PREEMB    := CPROCESSO
			//saldos de quantidade na 1. vez (embarque total)
			WorkIP->EE9_SLDINI := 0
			WorkIP->WP_SLDATU  := EE8->EE8_SLDATU
			WorkIP->WP_FLAG    := ""

			WorkIP->EE9_PRCTOT := 0
			WorkIP->EE9_PRCINC := 0

			WorkIP->EE9_QTDEM1 := 0
			WorkIP->EE9_SEQEMB := cSeqEmb
		Else
			cSeqEmb := WorkIP->EE9_SEQEMB
		EndIf
		WorkZZA->(RecLock("WorkZZA",.F.))
		WorkZZA->WK_SEQEMB := cSeqEmb
		WorkZZA->(MsUnlock())

		If Ascan(aPedidos, WorkZZA->WK_PEDIDO) == 0
			Aadd(aPedidos,WorkZZA->WK_PEDIDO)
		EndIf

		WorkZZA->(DbSkip())
	EndDo

	WorkIp->(DbSetOrder(1))

	// Carrega as quantidades dos itens de embarque e calcula os totais.
	ProcRegua(WorkZZA->(LastRec()))
	WorkZZA->(DbGoTop())

	Do While ! WorkZZA->(Eof())
		WorkIp->(DbSeek(WorkZZA->(WK_PEDIDO+WK_SEQUEN)))
		nQtd := WorkIP->EE9_SLDINI + WorkZZA->WK_QTEEMB

		WorkIp->(RecLock("WorkIp",.F.))
		WorkIp->WP_FLAG := cMarca
		WorkIp->EE9_SLDINI := nQtd
		WorkIp->EE9_QTDEM1 := nQtd / WorkIp->EE9_QE

		// Carrega as variáveis de memória para cálculo dos pesos.
		For nI := 1 TO WorkIP->(FCount())
			M->&(WorkIP->(FieldName(nI))) := WorkIP->(FieldGet(nI))
		Next nInc

		// Calcula os pesos
		AE100CALC("PESOS")

		AvReplace("M","WorkIp")

		WorkZZA->(DbSkip())
	EndDo

	// Força o cálculo dos preços.
	Ae100PrecoI(.t., .f.)

	//End Sequence

Return lRet

/*
Funcao          : MarcaDesmarca()
Parametros      :
Retorno         : .T./.F.
Objetivos       : Marcar e desmarcar todos os dados da WORKMB para emissão do relatório.
Autor           : Julio de Paula Paz
Data/Hora       : 30/08/2010 - 13:00
Revisao         :
Obs.            :
*/
Static Function MarcaDesmarca()
	Local lRet , cTipoMarca

	//Begin Sequence
	cTipoMarca := cMarca
	WorkSel->(DbGoTop())
	Do While !WorkSel->(Eof())
		If !Empty(WorkSel->WK_FLAG)
			cTipoMarca := Space(2)
		EndIf

		WorkSel->(DbSkip())
	EndDo

	WorkSel->(DbGoTop())
	Do While !WorkSel->(Eof())
		WorkSel->(RecLock("WorkSel",.F.))
		WorkSel->WK_FLAG := cTipoMarca
		WorkSel->(MsUnlock())

		WorkSel->(DbSkip())
	EndDo

	WorkSel->(DbGoTop())
	//End Sequence

Return lRet


/*
Funcao          : VldSaldoEE8()
Parametros      :
Retorno         : .T./.F.
Objetivos       : Valida Saldos dos itens de pedido.
Autor           : Julio de Paula Paz
Data/Hora       : 23/08/2010 - 09:00
Revisao         :
Obs.            :
*/
Static Function VldSaldoEE8()
	Local lRet := .T.
	Local aSaldos := {}
	Local nI
	Local aOrd := SaveOrd({"EE8"})

	//Begin Sequence
	EE8->(DbSetOrder(1))
	WorkIp->(DbGotop())
	Do While ! WorkIp->(Eof())
		nI := aScan(aSaldos,{|x| x[1] == WorkIp->EE9_PEDIDO .And. x[2] == WorkIp->EE9_SEQUEN })
		If nI == 0
			If EE8->(DbSeek(xFilial("EE8")+WorkIp->(EE9_PEDIDO+EE9_SEQUEN)))
				Aadd(aSaldos,{EE8->EE8_PEDIDO,EE8->EE8_SEQUEN,Workip->EE9_SEQEMB,EE8->EE8_SLDATU})
			EndIf
		EndIf
		WorkIp->(DbSkip())
	EndDo

	WorkIp->(DbGotop())
	Do While ! WorkIp->(Eof())
		nI := aScan(aSaldos,{|x| x[3] == WorkIp->EE9_SEQEMB })
		If nI > 0
			aSaldos[nI,4] -= WorkIp->EE9_SLDINI
		EndIf
		WorkIp->(DbSkip())
	EndDo

	For nI := 1 To Len(aSaldos)
		If aSaldos[nI,4] < 0
			lRet := .t.    // Retorna falso porque a gravação deste processo gera saldo negativo.
			//  Break
		EndIf
	Next

	//End Sequence

	RestOrd(aOrd)

Return lRet

/*
Funcao          : AtuSaldoEE8()
Parametros      :
Retorno         : .T./.F.
Objetivos       : Atualiza saldos dos itens de pedido.
Autor           : Julio de Paula Paz
Data/Hora       : 01/09/2010 - 13:00
Revisao         :
Obs.            :
*/
Static Function AtuSaldoEE8()
	Local lRet
	Local aOrd := SaveOrd({"EE8"})

	//Begin Sequence
	EE8->(DbSetOrder(1))
	WorkIp->(DbGotop())
	Do While ! WorkIp->(Eof())
		If EE8->(DbSeek(xFilial("EE8")+WorkIp->(EE9_PEDIDO+EE9_SEQUEN)))
			EE8->(Reclock("EE8",.F.))
			EE8->EE8_SLDATU := EE8->EE8_SLDATU - WorkIp->EE9_SLDINI
			EE8->(MsUnlock())
		EndIf
		WorkIp->(DbSkip())
	EndDo

	//End Sequence

	RestOrd(aOrd)

Return lRet

/*
Funcao          : HaEmbPacking(cPedVenda,cOrdSeparacao,lMensagem)
Parametros      : cPedVenda = Numero do pedido de venda
cOrdSeparacao = Numero da Ordem de separação
lMensagem = .T. => Exibe uma mensgem caso seja encontrado no modulo da exportação
o pedido de venda e a ordem de separação.
.F. => Não exibe a mensagem.
O Default é .F>
Retorno         : .T./.F.
Objetivos       : Verificar se um pedido de venda e uma ordem de separação de mercadorias já estão
lançados na rotina de embarque, do módulo da Exportação.
Autor           : Julio de Paula Paz
Data/Hora       : 08/09/2010 - 17:40
Revisao         :
Obs.            :
*/
User Function HaEmbPacking(cPedVenda,cOrdSeparacao,lMensagem)
	Local lRet := .F.
	Local aOrd := SaveOrd({"ZZA"})

	Default lMensagem := .F.

	//Begin Sequence
	ZZA->(DbSetOrder(3)) // ZZA_FILIAL+ZZA_PEDFAT+ZZA_ORDSEP
	If ZZA->(DbSeek(xFilial("ZZA")+Avkey(cPedVenda,"ZZA_PEDFAT")+AvKey(cOrdSeparacao,"ZZA_ORDSEP")))
		If ! Empty(lMensagem) .And. lMensagem
			MsgInfo("Este 'Pedido de Venda' e esta 'Ordem de Separação' já estão lançados no Módulo da Exportação!","Atenção")
		EndIf
		lRet := .T.
	EndIf

	//End Sequence

	RestOrd(aOrd)

Return lRet


/*
Função          : SelCodEmb()
Objetivo        : Selecionando pedidos para criação do codigo do embarque
Autor           : Fernando Pereira
Data/Hora       : 22/11/2013 - 16:40
Obs.            :
*/
Static Function SelCodEmb()
	Local lRet
	Local nPv := 0
	Local _lPin := .F.  //pro jeff
	Local _cPinh := "A"
	cProcesso := ""

	WorkSel->(DbGoTop())
	Do While ! WorkSel->(Eof())
		ProcRegua(WorkSel->(LastRec()))
		IncProc("Selcionando itens para criar Cod Embarq: '"+AllTrim(WorkSel->WK_PEDIDO)+"' ")

		cProcesso := cProcesso + SUBSTR(alltrim(WorkSel->WK_PEDIDO),1,6)
		nPv := nPv + 1
		While !_lPin

			DbSelectArea("EE9")
			EE9->(DbSetOrder(2))
			If ! EE9->(DbSeek(xFilial("EE9")+cProcesso))
				_lPin := .T.
			Else
				cProcesso:= alltrim(cProcesso)+Iif('A' $ alltrim(cProcesso),Soma1(_cPinh),_cPinh)
			EndIf
		End
		WorkSel->(DbSkip())

		If !WorkSel->(Eof()) .and. nPv <= 2
			cProcesso := cProcesso + "-"
		Else
			Exit
		Endif
	Enddo

Return lRet


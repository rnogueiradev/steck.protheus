#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCPA01  บ Autor ณ RVG                บ Data ณ 18/01/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ PRODUCOES CHAO DE FABRICA STECK                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK - PRODUCAO                   	                      บฑฑ
ฑฑฬออออออออออฯอออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.ณ  Data  ณ Manutencao Efetuada                           บฑฑ
ฑฑฬออออออออออออออุออออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ  /  /  ณ                                               บฑฑ
ฑฑบ              ณ  /  /  ณ                                               บฑฑ
ฑฑศออออออออออออออฯออออออออฯออออออออออออออออlอออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STPCPA01()

	Local aCores	:= {	{ 'C2_XSTATUS==" "' , 'ENABLE' },; 	//Aberto
	{ 'C2_XSTATUS=="A"' , 'BR_AMARELO'},;	//Em Apontamento
	{ 'C2_XSTATUS=="E"' , 'DISABLE'}}		//Encerrado

	Private cNum     := ''
	Private nUsado   := 0
	Private cCadastro:= "Chใo de Fแbrica - STECK"
	Private aRotina  := {}
	Private aPos     := {15, 1, 70, 315}
	Private aObjects := {}
	Private aPosObj  := {}
	Private aSize    := MsAdvSize()
	Private aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	Private qC6_EFD_STA
	Private qB1_DESC
	Private qB1_MTTR
	Private qG2_OBS
	Private qA7_CLIENTE
	Private qA7_CLIELOJA
	Private qA7_CLIEDESC
	Private qZ2_DESCRI
	Private q_FORNDESC

	Private aPosGet  := MsObjGetPos(aSize[3]-aSize[1],305,	{{5,25,120,140,230,250},{105}})

	AAdd(aObjects,{  0,  50,.T.,.F.})
	AAdd(aObjects,{  0,   0,.T.,.F.})
	AAdd(aObjects,{  0, 205,.T.,.F.})

	aPosObj := MsObjSize(aInfo,aObjects)

	aAdd(aRotina,{"Pesquisar"       ,"AxPesqui"   ,0,1})
	aAdd(aRotina,{"Visualizar"      ,'u_STResult' ,0,2})
	aAdd(aRotina,{"Apontar"         ,'u_STResult' ,0,4})
	aAdd(aRotina,{"Encerrar"        ,'u_STResult' ,0,4})
	aAdd(aRotina,{"Reabre"          ,'u_STReabre' ,0,4})
	aAdd(aRotina,{"Consultar Itens" ,'U_STCONSULT' ,0,4})
	aAdd(aRotina,{"Kardex p/ Dia"   ,'MATC030'     ,0,4})
	aAdd(aRotina,{"Legenda"         ,"u_STResLeg" ,0,2})

	//aAdd(aRotina,{"Estornar"        ,'u_STResult' ,0,4})
	If Empty(Posicione("SX3",1,"SB1","X3_ARQUIVO"))
		Help("",1,"","NOcAlias","NรO ษ POSSอVEL EXECUTAR, FALTA"+ENTER+" CRIAR TABELA SB1",1,0)
		Return()
	Endif

	DbSelectArea("SC2")
	DbSetOrder(1)

	mBrowse(,,,,"SC2",,,,,,aCores)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTResult  บAutor  ณ RVG                บ Data ณ  18/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STResult(__cAlias,__nRecno,_nopc)

	Local nX          := 0
	Local nOpcA       := 0
	Local oDlg        := Nil
	Local oMainWnd    := Nil

	//Local aTitles     := {"Produ็๕es","Configura็๕es","Opera็๕es","Horas Improdutivas","Perdas","Lotes"}
	Local aTitles     := {"Produ็๕es","Configura็๕es","Opera็๕es","Horas Improdutivas","Lotes"}

	Local oFolder
	Local oMemo1
	Local oMemo2
	Local oMemo3
	Local oMemo4

	Local aAlter1    := {}
	Local aAlter2    := {}
	Local aAlter3    := {}
	Local aAlter4    := {}
	Local aAlter5    := {}
	Local aAlter6    := {}
	Local oGet

	Local _cApropri := ""
	Local _lApropri := .T.
	Local _nI       := 0
	Local _aPropri  := {}
	Local _lOrdSep  := .T.
	Local _c90      := ''
	Local _cArmProd := AllTrim(GetMv("MV_LOCPROC"))+"-10"
	Local aLocProd  := {}
	Local _lLocProd := .T.
	Local _nj

	Private aHeader := {}
	Private aCols   := {}
	Private bCampo  := { |nField| Field(nField)}

	Private cMemo1  := ""
	Private cMemo2  := ""
	Private cMemo3  := ""
	Private cMemo4  := ""
	Private aPosObj := {}
	Private _nAjuste:= 30

	Dbselectarea("SD4")
	SD4->(DbSetOrder(2))//D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	SD4->(DbGoTop())
	DbSeek(xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
	While SD4->(! Eof() .and. D4_FILIAL+Left(D4_OP,11) == xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

		DbSelectarea("SB1")
		SB1->(DbSetOrder(1))//B1_FILIAL+B1_COD
		SB1->(DbGoTop())
		If SB1->(DbSeek(xFilial("SB1")+(SD4->D4_COD)))
			_cApropri := SB1->B1_APROPRI
		Endif

		If Alltrim(_cApropri) == "D" .Or. Empty (_cApropri)
			_lApropri := .F.
			Exit
		Endif

		SD4->(DbSkip())
	End

	Dbselectarea("SD4")
	SD4->(DbSetOrder(2))//D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	SD4->(DbGoTop())
	DbSeek(xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
	While SD4->(! Eof() .and. D4_FILIAL+Left(D4_OP,11) == xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

		_c90 += ALLTRIM(SD4->D4_LOCAL)+'|'

		SD4->(DbSkip())
	End

	while (npos := at("|",_c90) ) > 0
		aadd( aLocProd,substr(_c90,1,npos-1) )
		_c90:= substr(_c90,npos+1,len(_c90))
	end

	For _nj := 1 to len(aLocProd)
		If aLocProd[_nj] $ _cArmProd
			_lLocProd := .T.
		Else
			_lLocProd := .F.
			Exit
		Endif
	Next _nj

	If !_lApropri  .And. !_lLocProd
		DbSelectarea("CB7")
		CB7->(DbSetOrder(5))//CB7_FILIAL+CB7_OP+CB7_LOCAL+CB7_STATUS
		CB7->(DbGoTop())
		If !CB7->(DbSeek(xFilial("SC2")+(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))) .And. !(SC2->C2_XBENEF = 'S')//.And. cEmpAnt == '03'//STECK MANAUS
			MSGSTOP( "A Ordem de Produ็ใo "+SC2->C2_NUM+" nใo foi autorizada pelo PCP para Separa็ใo junto ao Almoxarifado."+ Chr(10) + Chr(13) +;
				Chr(10) + Chr(13) +;
				"Dessa forma nใo serแ possํvel realizar qualquer tipo de apontamento"+ Chr(10) + Chr(13),;
				"Ordem de Produ็ใo sem Ordem de Separa็ใo")
			_lOrdSep := .F.
		Endif
	Endif

	//If cEmpAnt == '01' .OR. (cEmpAnt == '03' .AND. _lOrdSep)
	If _lOrdSep
		_cOp := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		_cxOp := SC2->C2_NUM +SC2->C2_ITEM +SC2->C2_SEQUEN
		DbSelectArea("SB1")
		DbSetOrder(1)
		Dbseek(xfilial("SB1")+SC2->C2_PRODUTO)

		_cReponsavel 	:= cUserName
		_dData 			:= date()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do aHeader e aCols (1)                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectarea("PP1")
		dbsetorder(1)

		Dbseek(xfilial("PP1")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

		IF !EOF()
			//_cReponsavel 	:= SC2->C2_XAPONT
			//_dData 			:= SC2->C2_XDTAPT
			//IF _nOpc == 3
			//	msgstop("Resultado ja cadastrado, somente Visualizacao sera permitida !!!")
			//	_nOpc := 2
			//Endif
		Endif

		aHeader1 :=  _CriaHeader("PP1","")//,"PP1_CODIGO")
		aCols1   :=  _carga_Acols("PP1",1,"PP1_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader1)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do aHeader e aCols (2)                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aHeader2 :=  _CriaHeader("PP2","")//,"PP2_CODIGO")
		aCols2   := _carga_Acols("PP2",1,"PP2_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader2)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do aHeader e aCols (3)                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aHeader3 :=  _CriaHeader("PP3","")//,"PP3_CODIGO")
		aCols3   := _carga_Acols("PP3",1,"PP3_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader3)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do aHeader e aCols (4)                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aHeader4 :=  _CriaHeader("PP4","")//,"PP4_CODIGO")
		aCols4   := _carga_Acols("PP4",1,"PP4_OP",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader4)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do aHeader e aCols (5)                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aHeader5 :=  _CriaHeader("PP5","")//,"PP5_CODIGO")
		aCols5   := _carga_Acols("PP5",1,"PP5_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader5)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do aHeader e aCols (6)                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aHeader6 :=  _CriaHeader("PP6","")//,"PP6_CODIGO")
		aCols6   := _carga_Acols("PP6",1,"PP6_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader6)

		aHeader7 :=  _CriaHeader("PP9","")//,"PP6_CODIGO")
		aCols7   := _carga_Acols("PP9",1,"PP9_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader7)

		aPosObj := MsObjSize( aInfo, aObjects )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEnvia para processamento dos Getsณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

		@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] LABEL '' OF oDlg PIXEL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMonta Enchoiceณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Private _cProduto 	:= SC2->C2_PRODUTO
		Private _cDesc      := SB1->B1_DESC
		Private _dEmissao	:= SC2->C2_EMISSAO
		Private _dinicio	:= SC2->C2_DATPRI
		Private _dFim    	:= SC2->C2_DATPRF
		Private _nQuant  	:= SC2->C2_QUANT
		Private _nQuje   	:= SC2->C2_QUJE

		@ 010+_nAjuste,aPosGet[1,1] SAY "Ordem de Producao" OF oDlg PIXEL SIZE 050,008
		@ 009+_nAjuste,aPosGet[1,2]+20 MSGET _cop  WHEN .F. OF oDlg PIXEL SIZE 050,006

		@ 021+_nAjuste,aPosGet[1,1] SAY "Produto" OF oDlg PIXEL SIZE 050,068
		@ 020+_nAjuste,aPosGet[1,2]+20 MSGET _cProduto PICTURE PesqPict('SC2','C2_PRODUTO') F3 CpoRetF3('C2_PRODUTO') WHEN .F. OF oDlg PIXEL SIZE 50,006

		@ 032+_nAjuste,aPosGet[1,1] SAY "Descricao" OF oDlg PIXEL SIZE 050,068
		@ 031+_nAjuste,aPosGet[1,2]+20 MSGET _cDesc WHEN .F. OF oDlg PIXEL SIZE 150,006

		@ 043+_nAjuste,aPosGet[1,1] SAY "Dt.Emissao" OF oDlg PIXEL SIZE 050,068
		@ 042+_nAjuste,aPosGet[1,2]+20 MSGET _demissao WHEN .F. OF oDlg PIXEL SIZE 040,006

		@ 010+_nAjuste,aPosGet[1,3] SAY "Planej de:" OF oDlg PIXEL SIZE 050,068
		@ 009+_nAjuste,aPosGet[1,4] MSGET _dInicio  WHEN .F. OF oDlg PIXEL SIZE 050,006

		@ 021+_nAjuste,aPosGet[1,3] SAY "       Ate:" OF oDlg PIXEL SIZE 050,068
		@ 020+_nAjuste,aPosGet[1,4] MSGET _dFim WHEN .F. OF oDlg PIXEL SIZE 050,006

		@ 032+_nAjuste,aPosGet[1,3] SAY "Quantidade:" OF oDlg PIXEL SIZE 050,068
		@ 031+_nAjuste,aPosGet[1,4] MSGET _nQuant PICTURE PesqPict('SC2','C2_QUANT') WHEN .F. OF oDlg PIXEL SIZE 060,006

		//@ 043+_nAjuste,aPosGet[1,3] SAY "Qtd.Produzidas" OF oDlg PIXEL SIZE 050,068
		//@ 042+_nAjuste,aPosGet[1,4] MSGET _nQuje  PICTURE PesqPict('SC2','C2_QUJE') WHEN .F. OF oDlg PIXEL SIZE 050,006

		oFolder := TFolder():New(aPosObj[3,1],aPosObj[3,2],aTitles,{"HEADER"},oDlg,,,, .T., .F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1]-40,)

		//Acerto no folder para nao perder o foco
		For nX := 1 to Len(oFolder:aDialogs)
			DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[nX]
		Next nX

		// Pasta de Produ็๕es

		oFolder:aDialogs[1]:oFont := oDlg:oFont
		oGetDad1 := MsNewGetDados():New(0,;
			0,;
			(aPosObj[1][3]*2-15),;
			(aPosObj[1][4])-10,;
			iif(_nopc==3,GD_INSERT+GD_DELETE+GD_UPDATE,),;
			"U_xAc1VLin()",;
			"U_xAc1VTud()",;
			"",;
			,;
			,;
			9999,;
			"U_XALTPP1()",;
			,;
			"U_XDELPP1()",;
			oFolder:aDialogs[1],;
			aHeader1,;
			aCols1)

		oGetDad1:lF3Header = .T.
		oGetDad1:bchange := {||_ft1adl()}

		//oGetDad1:oBrowse:bLostFocus := { || montacs_ST1() }

		// Pasta de Configura็๕es

		oFolder:aDialogs[2]:oFont := oDlg:oFont
		@ 2,3 SAY "Operadores" OF oFolder:aDialogs[2] PIXEL SIZE 050,068 COLOR CLR_HBLUE
		oGetDad5 := MsNewGetDados():New(	10,;
			0,;
			aPosObj[1][3]-10,;
			aPosObj[1][4]-10,;
			iif(_nopc==3,GD_INSERT+GD_DELETE+GD_UPDATE,),;
			"U_xAc5VLin()",;
			"U_xAc1VTud()",;
			"",;
			,;
			,;
			,;
			,;
			,;
			,;
			oFolder:aDialogs[2],;
			aHeader5,;
			aCols5)
		oGetDad5:lF3Header = .T.
		oGetDad5:bchange := {||_ft5adl()}

		@ aPosObj[1][3]+(aPosObj[1][3]/3)-35,3 SAY "Ord.Produ็ใo Amarradas" OF oFolder:aDialogs[2] PIXEL SIZE 150,68 COLOR CLR_HBLUE
		oGetDad6 := MsNewGetDados():New(aPosObj[1][3]+((aPosObj[1][3]/3-25)),;
			0,;
			(aPosObj[1][3]*2)-15,;
			(aPosObj[1][4])-10,;
			iif(_nopc==3,GD_INSERT+GD_DELETE+GD_UPDATE,),;
			"U_Ac6VLin()",;
			"U_Ac1VTud()",;
			"",;
			,;
			,;
			9999,;
			,;
			,;
			,;
			oFolder:aDialogs[2],;
			aHeader6,;
			aCols6)
		oGetDad6:lF3Header = .T.
		oGetDad6:bchange := {||_ft6adl()}

		// Pasta de Opera็๕es
		oFolder:aDialogs[3]:oFont := oDlg:oFont
		oGetDad2 := MsNewGetDados():New(	0,;
			0,;
			(aPosObj[1][3]*2)-15,;
			(aPosObj[1][4])-10,;
			iif(_nopc==3,GD_INSERT+GD_DELETE+GD_UPDATE,),;
			"U_xAc2VLin()",;
			"U_xAc1VTud()",;
			"",;
			,;
			,;
			9999,;
			,;
			,;
			,;
			oFolder:aDialogs[3],;
			aHeader2,;
			aCols2)
		oGetDad2:lF3Header = .T.
		oGetDad2:bchange := {||_ft2adl()}

		// Pasta de Horas Improdutivas
		oFolder:aDialogs[4]:oFont := oDlg:oFont
		//@ 2,3 SAY "Refino Quimico" OF oFolder:aDialogs[3] PIXEL SIZE 050,068 COLOR CLR_HBLUE
		oGetDad3 := MsNewGetDados():New(	0,;
			0,;
			(aPosObj[1][3]*2)-15,;
			(aPosObj[1][4])-10,;
			iif(_nopc==3,GD_INSERT+GD_DELETE+GD_UPDATE,),;
			"U_xAc3VLin()",;
			"U_xAc1VTud()",;
			"",;
			,;
			,;
			9999,;
			,;
			,;
			,;
			oFolder:aDialogs[4],;
			aHeader3,;
			aCols3)
		oGetDad3:lF3Header = .T.
		oGetDad3:bchange := {||_ft3adl()}
		/*
		// Pasta de Perdas
		oFolder:aDialogs[5]:oFont := oDlg:oFont
		oGetDad4 := MsNewGetDados():New(	0,;//aPosObj[1][3]+((aPosObj[1][3]/3)),;
		0,;
		(aPosObj[1][3]*2)+20,;
		(aPosObj[1][4])-10,;
		iif(_nopc==3,GD_INSERT+GD_DELETE+GD_UPDATE,),;
		"U_xAc4VLin()",;
		"U_xAc1VTud()",;
		"",;
		,;
		,;
		9999,;
		,;
		,;
		,;
		oFolder:aDialogs[5],;
		aHeader4,;
		aCols4)
		oGetDad4:lF3Header = .T.
		oGetDad4:bchange := {||_ft4adl()}
		*/
		// Pasta de Lotes
		oFolder:aDialogs[5]:oFont := oDlg:oFont
		oGetDad7 := MsNewGetDados():New(	0,;
			0,;
			(aPosObj[1][3]*2)-15,;
			(aPosObj[1][4])-10,;
			iif(_nopc==3,GD_INSERT+GD_DELETE+GD_UPDATE,),;
			"U_xAc7VLin()",;
			"U_xAc1VTud()",;
			"",;
			,;
			,;
			9999,;
			,;
			,;
			,;
			oFolder:aDialogs[5],;
			aHeader7,;
			aCols7)
		oGetDad7:lF3Header = .T.
		oGetDad7:bchange := {||_ft7adl()}

		@ 247,aPosGet[1,1] SAY "Apontador" OF oDlg PIXEL SIZE 050,068
		@ 247,aPosGet[1,2] MSGET _cReponsavel WHEN .f. OF oDlg PIXEL SIZE 040,006

		@ 261,aPosGet[1,1] SAY "Data" OF oDlg PIXEL SIZE 050,068
		@ 261,aPosGet[1,2] MSGET _dData WHEN .t. OF oDlg PIXEL SIZE 040,006

		@ 247+_nAjuste,aPosGet[1,3] SAY "Qtd.Produzidas" OF oDlg PIXEL SIZE 050,068
		@ 247+_nAjuste,aPosGet[1,4] MSGET _nQuje  PICTURE PesqPict('SC2','C2_QUJE') WHEN .F. OF oDlg PIXEL SIZE 050,006

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,if(u_xAc1VTud(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

		If nOpcA == 1
			Do case

			case  _nOpc == 3

				Begin Transaction
					STGrv001()
				End Transaction

			case _nOpc == 4

				Begin Transaction
					STEefetiva()
				End Transaction

			case _nOpc == 5

				Alert("A op็ใo de estorno deve ser realizada pela rotina denominada PRODUCAO localizada em seu Menu de acesso ao Protheus...!!!")
				//Begin Transaction
				//STPCPor001()
				//End Transaction

			EndCase
		Endif
		Set Filter To
	Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaHeaderบAutor  ณRVG                 บ Data ณ  18/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _CriaHeader(_cfile,_cExecessao)

	nUsado  := 0
	_xaHeader := {}

	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek(_cfile)
	While ( !Eof() .And. SX3->X3_ARQUIVO == _cfile )
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )

			if ! Alltrim(X3_CAMPO) $ _cExecessao

				aAdd(_xaHeader,{ Trim(X3Titulo()), ;
					alltrim(SX3->X3_CAMPO), ;
					SX3->X3_PICTURE , ;
					SX3->X3_TAMANHO , ;
					SX3->X3_DECIMAL , ;
					SX3->X3_VALID   , ;
					SX3->X3_USADO   , ;
					SX3->X3_TIPO    , ;
					SX3->X3_F3,;
					SX3->X3_CONTEXT ,;
					SX3->X3_CBOX,;
					SX3->X3_RELACAO } )

				nUsado++
			Endif

		Endif

		DbSkip()
	End

Return(_xaHeader)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_carga_AcolsบAutor  ณ RVG                บ Data ณ  19/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _carga_Acols(_cTabela,_nidice,_cCampo,_cChave,_xAHeadLoc)
	Local _LocAcols := {}
	Local Nx

	Dbselectarea(_cTabela)
	Dbsetorder(1)
	dbseek(xfilial(_cTabela)+_cChave)

	if eof()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do vazio ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		aAdd(_LocAcols, Array(Len(_xAHeadLoc)+1))
		For nX := 1 to Len(_xAHeadLoc)
			_LocAcols[1,nX] := CriaVar(_xAHeadLoc[nX,2])
		Next nX
		_LocAcols[1,Len(_xAHeadLoc)+1] := .f.

	else

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do acols com dados para alteraco ou exclusao ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		do while !eof()   .and. alltrim(&_cCampo) == alltrim(_cChave)
			aAdd(_LocAcols, Array(Len(_xAHeadLoc)+1))
			For nX := 1 to Len(_xAHeadLoc)
				If type(_xAHeadLoc[nX,2]) <> "U"
					_LocAcols[len(_LocAcols),nX] := &(_xAHeadLoc[nX,2])
				Endif
			Next nX
			_LocAcols[len(_LocAcols),Len(_xAHeadLoc)+1] := .f.
			dbskip()
		enddo
	endif

return(_LocAcols)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณRVG                 บ Data ณ  25/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xAc1VTud()

	Local _nPos01   := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP1_CODIGO" })
	Local _nPos02   := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP1_COD" })
	Local _nPos03   := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP1_QUANT" })
	Local _nPos04   := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP1_DATA" })
	Local _nPos05   := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP1_MOTPER" })
	Local _nPos06   := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP1_LOCPER" })

	Local _nPos07   := Ascan(aHeader2,{|x| AllTrim(x[2]) == "PP2_CODIGO" })
	Local _nPos08   := Ascan(aHeader2,{|x| AllTrim(x[2]) == "PP2_OPER" })
	Local _nPos09   := Ascan(aHeader2,{|x| AllTrim(x[2]) == "PP2_RECURS" })
	Local _nPos10   := Ascan(aHeader2,{|x| AllTrim(x[2]) == "PP2_OPERAD" })
	Local _nPos11   := Ascan(aHeader2,{|x| AllTrim(x[2]) == "PP2_DTINI" })
	Local _nPos12   := Ascan(aHeader2,{|x| AllTrim(x[2]) == "PP2_DTFIM" })
	Local _nPos13   := Ascan(aHeader2,{|x| AllTrim(x[2]) == "PP2_HRINI" })
	Local _nPos14   := Ascan(aHeader2,{|x| AllTrim(x[2]) == "PP2_HRFIM" })

	Local _nPos15   := Ascan(aHeader3,{|x| AllTrim(x[2]) == "PP3_OPER" })
	Local _nPos16   := Ascan(aHeader3,{|x| AllTrim(x[2]) == "PP3_RECURS" })
	Local _nPos17   := Ascan(aHeader3,{|x| AllTrim(x[2]) == "PP3_MOTIVO" })
	Local _nPos18   := Ascan(aHeader3,{|x| AllTrim(x[2]) == "PP3_DTINI" })
	Local _nPos19   := Ascan(aHeader3,{|x| AllTrim(x[2]) == "PP3_DTFIM" })
	Local _nPos20   := Ascan(aHeader3,{|x| AllTrim(x[2]) == "PP3_HRINI" })
	Local _nPos21   := Ascan(aHeader3,{|x| AllTrim(x[2]) == "PP3_HRFIM" })
	Local _nPos22   := Ascan(aHeader3,{|x| AllTrim(x[2]) == "PP3_OPERAD" })
	Local _nPos23   := Ascan(aHeader3,{|x| AllTrim(x[2]) == "PP3_CODIGO" })

	Local _nPos24   := Ascan(aHeader7,{|x| AllTrim(x[2]) == "PP9_CODIGO" })
	Local _nPos25   := Ascan(aHeader7,{|x| AllTrim(x[2]) == "PP9_PROD" })
	Local _nPos26   := Ascan(aHeader7,{|x| AllTrim(x[2]) == "PP9_LOTE" })
	Local _nPos27   := Ascan(aHeader7,{|x| AllTrim(x[2]) == "PP9_QUANT" })

	Local _nX       := 0
	Local _lRet     := .T.
	Local _nQtdeOP  := SC2->C2_QUANT
	Local _nQtdePr  := SC2->C2_QUJE
	Local _nQtdeTol := (SC2->C2_QUANT)*(GetMv("ST_PRECAP")/100)
	Local _nQtdCols := 0
	Local _cBenef   := SC2->C2_XBENEF

	//Valida็๕es para Produ็๕es
	For _nX:=1 To Len (oGetDad1:aCols)

		If !oGetDad1:aCols[_nX,Len(aHeader1)+1]

			_nQtdCols	+= oGetDad1:aCols[_nX][_nPos03]

			If at(".",cvaltochar((oGetDad1:aCols[_nX][_nPos03]))) > 0
				_lRet	:= .F.
				MSGSTOP( "Quantidade Fracionada informada em Produ็๕es ...!!!"+ Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor informar uma Quantidade Vแlida ...!!!"+ Chr(10) + Chr(13),;
					"Quantidade Fracionada")
			Endif

			If !Empty(oGetDad1:aCols[_nX][_nPos05]) .And. Empty(oGetDad1:aCols[_nX][_nPos06])
				_lRet	:= .F.
				MSGSTOP( "Motivo de Perda preenchido e nใo definido Armaz้m da Qualidade em Produ็๕es ...!!!"+ Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
					"Armaz้m da Qualidade")
			EndIf

			If !Empty(oGetDad1:aCols[_nX][_nPos06]) .And. Empty(oGetDad1:aCols[_nX][_nPos05])
				_lRet	:= .F.
				MSGSTOP( "Armaz้m da Qualidade preenchido e nใo definido Motivo de Perda em Produ็๕es ...!!!"+ Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
					"Motivo de Perda")
			EndIf

			If !(AllTrim(oGetDad1:aCols[_nX][_nPos02])==AllTrim(SC2->C2_PRODUTO))
				_lRet	:= .F.
				MsgAlert("Aten็ใo, produto apontado diferente da ordem de produ็ใo!")
			EndIf

			If !(AllTrim(oGetDad1:aCols[_nX][_nPos01])==AllTrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
				_lRet	:= .F.
				MSGSTOP( "N๚mero da Ordem de Produ็ใo nใo pode ser alterado em Produ็๕es ...!!!"+ Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
					"N๚mero de Ordem de Produ็ใo")
			EndIf

			If Empty(oGetDad1:aCols[_nX][_nPos03])
				_lRet	:= .F.
				MSGSTOP( "A Quantidade Produzida nใo foi informada em Produ็๕es ...!!!"+ Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
					"Quantidade Produzida")

			ElseIf Empty(oGetDad1:aCols[_nX][_nPos04])
				_lRet	:= .F.
				MSGSTOP( "A Data de Produ็ใo nใo foi informado em Produ็๕es ...!!!"+ Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
					"Data de Produ็ใo")
			Endif

		EndIf

	Next

	If _nQtdCols > (_nQtdeOP+_nQtdeTol)
		_lRet	:= .F.
		MSGSTOP( "A Quantidade Apontada ้ maior do que a Quantidade informada na Ordem de Produ็ใo ...!!!"+ Chr(10) + Chr(13) +;
			"Quantidade da OP: " +CVALTOCHAR(_nQtdeOP)+;
			Chr(10) + Chr(13) +;
			"Quantidade jแ Produzida: "+CVALTOCHAR(_nQtdePr)+;
			Chr(10) + Chr(13) +;
			"Quantidade Apontada: "+CVALTOCHAR(_nQtdCols)+;
			Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
			"Excedente de Produ็ใo")

	EndIf

	//Valida็๕es para Opera็๕es - Roteiros
	For _nX:=1 To Len (oGetDad2:aCols)
		If _cBenef <> 'S' //Chamado 002654
			If !oGetDad2:aCols[_nX,Len(aHeader2)+1]

				If !(oGetDad2:aCols[_nX][_nPos11]==oGetDad2:aCols[_nX][_nPos12])
					_lRet	:= .F.
					MSGSTOP( "A Data de Inํcio do Roteiro nใo pode ser diferente da Data Final ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Diverg๊ncia Data Roteiro")
				EndIf

				If Val(SubStr(oGetDad2:aCols[_nX][_nPos13],1,2)) > Val(SubStr(oGetDad2:aCols[_nX][_nPos14],1,2))
					_lRet	:= .F.
					MSGSTOP( "A Hora de Inํcio do Roteiro nใo pode ser maior do que a Hora Final ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Diverg๊ncia Hora Roteiro")
				EndIf

				If Val(SubStr(oGetDad2:aCols[_nX][_nPos13],1,2)) = Val(SubStr(oGetDad2:aCols[_nX][_nPos14],1,2))
					If Val(SubStr(oGetDad2:aCols[_nX][_nPos13],4,2)) > Val(SubStr(oGetDad2:aCols[_nX][_nPos14],4,2))
						_lRet	:= .F.
						MSGSTOP( "Quando a Hora Inicial do Roteiro for igual a Hora Final, o Minuto de Inํcio do Roteiro nใo pode ser maior do que o Minuto Final ...!!!"+ Chr(10) + Chr(13) +;
							Chr(10) + Chr(13) +;
							"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
							"Diverg๊ncia Minuto Roteiro")
					EndIf
				EndIf

				If Empty(oGetDad2:aCols[_nX][_nPos07])
					_lRet	:= .F.
					MSGSTOP( "O N๚mero da Ordem de Produ็ใo nใo foi informado no Roteiro ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Roteiro sem N๚mero de Ordem de Produ็ใo")
				ElseIf Empty(oGetDad2:aCols[_nX][_nPos08])
					_lRet	:= .F.
					MSGSTOP( "O C๓digo da Opera็ใo nใo foi informado no Roteiro ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Roteiro sem C๓digo da Opera็ใo")
				ElseIf Empty(oGetDad2:aCols[_nX][_nPos09])
					_lRet	:= .F.
					MSGSTOP( "O Recurso nใo foi informado no Roteiro ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Roteiro sem Recurso")
				ElseIf Empty(oGetDad2:aCols[_nX][_nPos11])
					_lRet	:= .F.
					MSGSTOP( "A Data Inicial nใo foi informada no Roteiro ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Roteiro sem Data Inicial")
				ElseIf Empty(oGetDad2:aCols[_nX][_nPos13])
					_lRet	:= .F.
					MSGSTOP( "A Hora Inicial nใo foi informada no Roteiro ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Roteiro sem Hora Inicial")
				ElseIf Empty(oGetDad2:aCols[_nX][_nPos12])
					_lRet	:= .F.
					MSGSTOP( "A Data Final nใo foi informada no Roteiro ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Roteiro sem Data Final")
				ElseIf Empty(oGetDad2:aCols[_nX][_nPos14])
					_lRet	:= .F.
					MSGSTOP( "A Hora Final nใo foi informada no Roteiro ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Roteiro sem Hora Final")
				ElseIf Empty(oGetDad2:aCols[_nX][_nPos10])
					_lRet	:= .F.
					MSGSTOP( "O Operador nใo foi informado no Roteiro ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Roteiro sem Operador")
				Endif

			Endif
		Endif
	Next

	//Valida็๕es para Horas Improdutivas
	For _nX:=1 To Len (oGetDad3:aCols)

		If !oGetDad3:aCols[_nX,Len(aHeader3)+1]

			If !(oGetDad3:aCols[_nX][_nPos18]==oGetDad3:aCols[_nX][_nPos19])
				_lRet	:= .F.
				MSGSTOP( "A Data de Inํcio de Hora Improdutiva nใo pode ser diferente da Data Final ...!!!"+ Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
					"Diverg๊ncia Data - Hora Improdutiva")
			EndIf

			If Val(SubStr(oGetDad3:aCols[_nX][_nPos20],1,2)) > Val(SubStr(oGetDad3:aCols[_nX][_nPos21],1,2))
				_lRet	:= .F.
				MSGSTOP( "A Hora de Inํcio de Hora Improdutiva nใo pode ser maior do que a Hora Final ...!!!"+ Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
					"Diverg๊ncia Hora - Hora Improdutiva")
			EndIf

			If Val(SubStr(oGetDad3:aCols[_nX][_nPos20],1,2)) = Val(SubStr(oGetDad3:aCols[_nX][_nPos21],1,2))
				If Val(SubStr(oGetDad3:aCols[_nX][_nPos20],4,2)) > Val(SubStr(oGetDad3:aCols[_nX][_nPos21],4,2))
					_lRet	:= .F.
					MSGSTOP( "Quando a Hora Inicial de Hora Improdutiva for igual a Hora Final, o Minuto de Inํcio de Hora Improdutiva nใo pode ser maior do que o Minuto Final ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Diverg๊ncia Minuto - Hora Improdutiva")
				EndIf
			EndIf

			If !(Empty(oGetDad3:aCols[_nX][_nPos15]))
				If Empty(oGetDad3:aCols[_nX][_nPos23])
					_lRet	:= .F.
					MSGSTOP( "O N๚mero da Ordem de Produ็ใo nใo foi informado em Horas Improdutivas ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Horas Improdutivas sem N๚mero de Ordem de Produ็ใo")
				ElseIf Empty(oGetDad3:aCols[_nX][_nPos15])
					_lRet	:= .F.
					MSGSTOP( "O C๓digo da Opera็ใo nใo foi informado em Horas Improdutivas ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Horas Improdutivas sem C๓digo da Opera็ใo")
				ElseIf Empty(oGetDad3:aCols[_nX][_nPos16])
					_lRet	:= .F.
					MSGSTOP( "O Recurso nใo foi informado em Horas Improdutivas ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Horas Improdutivas sem Recurso")
				ElseIf Empty(oGetDad3:aCols[_nX][_nPos17])
					_lRet	:= .F.
					MSGSTOP( "O Motivo nใo foi informado em Horas Improdutivas ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Horas Improdutivas sem Motivo")
				ElseIf Empty(oGetDad3:aCols[_nX][_nPos18])
					_lRet	:= .F.
					MSGSTOP( "A Data Inicial nใo foi informada em Horas Improdutivas ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Horas Improdutivas sem Data Inicial")
				ElseIf Empty(oGetDad3:aCols[_nX][_nPos20])
					_lRet	:= .F.
					MSGSTOP( "A Hora Inicial nใo foi informada em Horas Improdutivas ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Horas Improdutivas sem Hora Inicial")
				ElseIf Empty(oGetDad3:aCols[_nX][_nPos19])
					_lRet	:= .F.
					MSGSTOP( "A Data Final nใo foi informada em Horas Improdutivas ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Horas Improdutivas sem Data Final")
				ElseIf Empty(oGetDad3:aCols[_nX][_nPos21])
					_lRet	:= .F.
					MSGSTOP( "A Hora Final nใo foi informada em Horas Improdutivas ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Horas Improdutivas sem Hora Final")
				ElseIf Empty(oGetDad3:aCols[_nX][_nPos22])
					_lRet	:= .F.
					MSGSTOP( "O Operador nใo foi informado em Horas Improdutivas ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Horas Improdutivas sem Operador")
				Endif
			Endif
		Endif
	Next

	//Valida็๕es para Lotes
	For _nX:=1 To Len (oGetDad7:aCols)

		If !oGetDad7:aCols[_nX,Len(aHeader7)+1]

			If !(AllTrim(oGetDad7:aCols[_nX][_nPos24])==AllTrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
				_lRet	:= .F.
				MSGSTOP( "N๚mero da Ordem de Produ็ใo nใo pode ser alterado em Lotes ...!!!"+ Chr(10) + Chr(13) +;
					Chr(10) + Chr(13) +;
					"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
					"N๚mero de Ordem de Produ็ใo")
			EndIf

			If !(Empty(oGetDad7:aCols[_nX][_nPos25])) .OR. !(Empty(oGetDad7:aCols[_nX][_nPos26])) .OR. !(Empty(oGetDad7:aCols[_nX][_nPos27]))
				If Empty(oGetDad7:aCols[_nX][_nPos25])
					_lRet	:= .F.
					MSGSTOP( "O Componente da Ordem de Produ็ใo nใo foi preenchido em Lotes ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Componentes")
				ElseIf Empty(oGetDad7:aCols[_nX][_nPos26])
					_lRet	:= .F.
					MSGSTOP( "O Lote nใo foi preenchido em Lotes ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Lote nใo Preenchido")
				ElseIf Len(Alltrim(oGetDad7:aCols[_nX][_nPos26])) < 4
					_lRet	:= .F.
					MSGSTOP( "Lote Invแlido informado em Lotes ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor informar um Lote Vแlido ...!!!"+ Chr(10) + Chr(13),;
						"Lote Invแlido")
				ElseIf Empty(oGetDad7:aCols[_nX][_nPos27])
					_lRet	:= .F.
					MSGSTOP( "Quantidade nใo foi preenchida em Lotes ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Quantidade nใo Preenchida em Lotes")
				ElseIf !((oGetDad7:aCols[_nX][_nPos27]) > 0)
					_lRet	:= .F.
					MSGSTOP( "Quantidade Invแlida informada em Lotes ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor informar uma Quantidade Vแlida ...!!!"+ Chr(10) + Chr(13),;
						"Quantidade Invแlida em Lotes")
				Endif
			Endif
		Endif
	Next

	if empty(_cReponsavel)
		msgstop("Campo responsavel deve ser preenchido !!!")
		_lret := .f.
	endif

	if empty(_dData)
		msgstop("Campo Data deve ser preenchido !!!")
		_lret := .f.
	endif

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGrv001  บAutor  ณRVG                 บ Data ณ  27/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gravacao da Tela de Digitacao                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STGrv001
	Private lMsErroAuto := .F.

	_Grava_Acols("PP1",1,"PP1_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader1, oGetDad1:aCols )
	_Grava_Acols("PP2",1,"PP2_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader2, oGetDad2:aCols )
	_Grava_Acols("PP3",1,"PP3_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader3, oGetDad3:aCols )
	//_Grava_Acols("PP4",1,"PP4_OP"	 ,SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader4, oGetDad4:aCols )
	_Grava_Acols("PP5",1,"PP5_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader5, oGetDad5:aCols )
	_Grava_Acols("PP6",1,"PP6_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader6, oGetDad6:aCols )
	_Grava_Acols("PP9",1,"PP9_CODIGO",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,aHeader7, oGetDad7:aCols )

	Dbselectarea("SC2")
	reclock("SC2",.f.)
	C2_XAPONT := _cReponsavel
	C2_XDTAPT := dDataBase
	C2_XSTATUS:= "A"
	msunlock()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณRVG                 บ Data ณ  27/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _Grava_Acols(_cTabela,_nOrdem,_cCampo,_cChave,_aHeader, _aCols )
	Local _nLin,_nCol
	Dbselectarea(_cTabela)
	Dbsetorder(_nOrdem)
	dbseek(xfilial(_cTabela)+_cChave)

	Do While alltrim(&_cCampo) == alltrim(_cChave) .and. !eof()
		reclock(_cTabela,.f.)
		DbDelete()
		msunlock()
		Dbskip()
	Enddo

	For _nlin=1 to len(_aCols)

		if !_aCols[_nlin,len(_aCols[_nlin])]

			//	if alltrim(&_cCampo) == alltrim(_cChave)
			//		reclock(_cTabela,.f.)
			//	else
			reclock(_cTabela,.t.)
			&_cCampo := _cChave
			&(_cTabela+"_FILIAL") := XFILIAL(_cTabela)
			//	endif

			For _nCol := 1 to Len(_aHeader)
				&(_aHeader[_nCol,2]) := _Acols[_nlin,_nCol]
			Next _nCol

		Endif

		Msunlock()
		Dbskip()

	Next _nLin

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณRVG                 บ Data ณ  10/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*/
Static Function montacs_ST1()

	Local n := oGetDad1:oBrowse:nat
	Local _nPerda := 0 //POSICIONE("SA1",1,XFILIAL("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA,"A1_PRDCONT")

	_nPos1 := Ascan(aHeader1, {|x| Alltrim(x[2]) == "PP1_CODIGO"})
	_nPos2 := Ascan(aHeader2, {|x| Alltrim(x[2]) == "PP2_CODIGO"})
	_nPos3 := Ascan(aHeader3, {|x| Alltrim(x[2]) == "PP3_CODIGO"})
	_nPos4 := Ascan(aHeader4, {|x| Alltrim(x[2]) == "PP4_OP"})
	_nPos5 := Ascan(aHeader5, {|x| Alltrim(x[2]) == "PP5_CODIGO"})
	_nPos6 := Ascan(aHeader6, {|x| Alltrim(x[2]) == "PP6_CODIGO"})
	_nPos7 := Ascan(aHeader7, {|x| Alltrim(x[2]) == "PP9_CODIGO"})

	oGetDad1:Refresh()
	oGetDad2:Refresh()
	oGetDad3:Refresh()
	oGetDad4:Refresh()
	oGetDad5:Refresh()
	oGetDad6:Refresh()
	oGetDad7:Refresh()
return .t.

/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณRVG                 บ Data ณ  27/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xexpl_qtd56()

	Local n := oGetDad2:oBrowse:nat
	Local _nPerda := POSICIONE("SA1",1,XFILIAL("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA,"A1_PRDCONT")
	Local nx
	_nPos5   	:= Ascan(aHeader5, {|x| Alltrim(x[2]) == "PA5_LIGA"})
	_nPos5a   	:= Ascan(aHeader5, {|x| Alltrim(x[2]) == "PA5_PESO"})
	_nquant     := &(Readvar())
	_cProduto 	:= oGetDad5:aCols[n,_nPos5]

	dbselectarea("SG1")
	dbseek(xfilial("SG1")+_cProduto)
	n:=0

	DO WHILE alltrim(G1_COD) == alltrim(_cProduto) .AND. !EOF()

		n++

		_nPos6a := Ascan(aHeader6, {|x| Alltrim(x[2]) == "PA6_METAL"})
		_nPos6b := Ascan(aHeader6, {|x| Alltrim(x[2]) == "PA6_DESCR"})
		_nPos6c := Ascan(aHeader6, {|x| Alltrim(x[2]) == "PA6_PESO"})
		_nPos6d := Ascan(aHeader6, {|x| Alltrim(x[2]) == "PA6_PERDA"})
		_nPos6e := Ascan(aHeader6, {|x| Alltrim(x[2]) == "PA6_PESLIQ"})

		oGetDad6:oBrowse:nat := n

		if n > len(oGetDad6:aCols)
			aAdd(oGetDad6:aCols, Array(Len(aHeader6)+1))
			For nX := 1 to Len(aHeader6)
				oGetDad6:aCols[n,nX] := CriaVar(aHeader6[nX,2])
			Next nX
			oGetDad6:aCols[n,Len(aHeader6)+1] := .f.

		endif
		oGetDad6:aCols[n,_nPos6a] :=  SG1->G1_COMP
		oGetDad6:aCols[n,_nPos6b] :=  POSICIONE("SB1",1,XFILIAL("SB1")+SG1->G1_COMP,"B1_DESC")
		oGetDad6:aCols[n,_nPos6c] :=  _nquant*(SG1->G1_QUANT/100)
		oGetDad6:aCols[n,_nPos6d] :=  _nPerda
		oGetDad6:aCols[n,_nPos6e] :=  _nquant*(SG1->G1_QUANT/100) * (1-(_nPerda/100))

		DBSKIP()
	ENDDO

	oGetDad6:oBrowse:nat := 1

	oGetDad5:Refresh()
	oGetDad6:oBrowse:Refresh()

return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STEST001 บAutor  ณRVG                 บ Data ณ 27/01/13    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*/
Static Function STEST001()
	Local _ncount
	DbSelectarea("PP1")
	dbsetorder(1)

	Dbseek(xfilial("PP1")+SC2->C2_NUM+SC2->C2_ITEM+SC2->D2_SEQUEN)

	do while !EOF() .and. PP1->PP1_CODIGO == SC2->C2_NUM+SC2->C2_ITEM+SC2->D2_SEQUEN
		RECLOCK("PP1",.F.)
		DELETE
		MSUNLOCK()
		DBSKIP()
	ENDDO

	DbSelectarea("PP2")
	dbsetorder(1)

	Dbseek(xfilial("PP2")+SC2->C2_NUM+SC2->C2_ITEM+SC2->D2_SEQUEN)

	do while !EOF() .and. PP2->PP2_CODIGO == SC2->C2_NUM+SC2->C2_ITEM+SC2->D2_SEQUEN
		RECLOCK("PP2",.F.)
		DELETE
		MSUNLOCK()
		DBSKIP()
	ENDDO

	DbSelectarea("PP3")
	dbsetorder(1)

	Dbseek(xfilial("PP3")+SC2->C2_NUM+SC2->C2_ITEM+SC2->D2_SEQUEN)

	do while !EOF() .and. PP3->PP3_CODIGO == SC2->C2_NUM+SC2->C2_ITEM+SC2->D2_SEQUEN
		RECLOCK("PP3",.F.)
		DELETE
		MSUNLOCK()
		DBSKIP()
	ENDDO

	DbSelectarea("PP4")
	dbsetorder(1)

	Dbseek(xfilial("PP4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->D2_SEQUEN)

	do while !EOF() .and. PP4->PP4_CODIGO == SC2->C2_NUM+SC2->C2_ITEM+SC2->D2_SEQUEN
		RECLOCK("PP4",.F.)
		DELETE
		MSUNLOCK()
		DBSKIP()
	ENDDO

	Dbselectarea("SC2")
	reclock("SC2",.F.)
	C2_XAPONT:=SPACE(20)
	C2_XDTPT :=CTOD("  /  /  ")
	MSUNLOCK()

	Dbselectarea("SD3")
	DBSETORDER(4)
	DBSEEK(XFILIAL("SD3")+SD1->D1_NUMSEQ)
	_AESTORNOS := {}

	DO WHILE D3_NUMSEQ == SD1->D1_NUMSEQ .AND. !EOF()
		IF D3_ESTORNO # "S"
			AADD(_AESTORNOS,RECNO())
		ENDIF
		DBSKIP()
	ENDDO

	For _ncount := 1 to len(_AESTORNOS)
		Dbselectarea("SD3")
		dBgoTo(_AESTORNOS[_ncount])

		aArraySD3 	:= {	{"D3_TM",SD3->D3_TM,Nil},;
			{"D3_COD",SD3->D3_COD,Nil},;
			{"D3_QUANT",SD3->D3_QUANT,Nil},;
			{"D3_LOCAL",SD3->D3_LOCAL,Nil},;
			{"D3_CHAVE",SD3->D3_CHAVE,Nil},;
			{"D3_EMISSAO",SD3->D3_EMISSAO,Nil},;
			{"D3_NUMSEQ",SD3->D3_NUMSEQ,Nil} ,;
			{"D3_LOTECTL",SD3->D3_NUMSEQ,Nil} }

		MATA240(aArraySD3,5)
		If lMsErroAuto
			MostraErro()
			Final("Erro no estorno do apontamento no arquivo de movimentacoes." )
		EndIf
	Next _ncount
RETURN

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  11/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _GetDOper(_lGatilho)

	Default _lGatilho := .t.
	Dbselectarea("SG2")
	DbSetOrder(1)
	Dbseek(Xfilial("SG2")+SC2->C2_PRODUTO+SC2->C2_ROTEIRO + &(READVAR()) )

	IF EOF()

		MsgStop("Opera็ใo nใo faz parte do Roteiro da OP, Verifique !!!")
		_lRet :=.f.

	Else

		_lRet := .t.

		if _lGatilho
			Do Case

			Case Ascan(aHeader1, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
				oGetDad1:aCols[oGetDad1:oBrowse:nat,Ascan(aHeader1, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SG2->G2_DESCRI

			Case Ascan(aHeader2, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
				oGetDad2:aCols[oGetDad2:oBrowse:nat,Ascan(aHeader2, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SG2->G2_DESCRI

			Case Ascan(aHeader3, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
				oGetDad3:aCols[oGetDad3:oBrowse:nat,Ascan(aHeader3, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SG2->G2_DESCRI

			Case Ascan(aHeader4, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
				oGetDad4:aCols[oGetDad4:oBrowse:nat,Ascan(aHeader4, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SG2->G2_DESCRI

			Case Ascan(aHeader5, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
				oGetDad5:aCols[oGetDad5:oBrowse:nat,Ascan(aHeader5, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SG2->G2_DESCRI

			Case Ascan(aHeader6, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
				oGetDad6:aCols[oGetDad6:oBrowse:nat,Ascan(aHeader6, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SG2->G2_DESCRI

			Endcase
		Endif
	Endif

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  11/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function _GetDProd(_lGatilho)

	Default _lGatilho := .t.

	Dbselectarea("SC2")
	IF SC2->C2_PRODUTO <> &(READVAR())

		IF "PP4" $ UPPER(READVAR()) .AND.  MsgYesno("Produto nao ้ desta OP, Continua Mesmo assim ???  ")

			_lRet :=.t.

		Else

			_lRet :=.f.

		endif

	Else

		_lRet := .t.

		Do Case

		Case Ascan(aHeader1, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad1:aCols[oGetDad1:oBrowse:nat,Ascan(aHeader1, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SB1->B1_DESC

		Case Ascan(aHeader2, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad2:aCols[oGetDad2:oBrowse:nat,Ascan(aHeader2, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SB1->B1_DESC

		Case Ascan(aHeader3, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad3:aCols[oGetDad3:oBrowse:nat,Ascan(aHeader3, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SB1->B1_DESC

		Case Ascan(aHeader4, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad4:aCols[oGetDad4:oBrowse:nat,Ascan(aHeader4, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SB1->B1_DESC

		Case Ascan(aHeader5, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad5:aCols[oGetDad5:oBrowse:nat,Ascan(aHeader5, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SB1->B1_DESC

		Case Ascan(aHeader6, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad6:aCols[oGetDad6:oBrowse:nat,Ascan(aHeader6, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SB1->B1_DESC

		Endcase

	Endif

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  11/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function _GetDFunc(_lGatilho)

	Default _lGatilho := .t.

	Dbselectarea("SRA")
	DbSetOrder(1)
	Dbseek(Xfilial("SRA")+&(READVAR()))

	IF EOF()

		MsgStop("Opera็ใo nใo faz parte do Roteiro da OP, Verifique !!!")
		_lRet :=.f.

	Else

		_lRet := .t.

		Do Case

		Case Ascan(aHeader1, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad1:aCols[oGetDad1:oBrowse:nat,Ascan(aHeader1, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SRA->RA_NOME

		Case Ascan(aHeader2, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad2:aCols[oGetDad2:oBrowse:nat,Ascan(aHeader2, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SRA->RA_NOME

		Case Ascan(aHeader3, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad3:aCols[oGetDad3:oBrowse:nat,Ascan(aHeader3, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SRA->RA_NOME

		Case Ascan(aHeader4, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad4:aCols[oGetDad4:oBrowse:nat,Ascan(aHeader4, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SRA->RA_NOME

		Case Ascan(aHeader5, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad5:aCols[oGetDad5:oBrowse:nat,Ascan(aHeader5, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SRA->RA_NOME

		Case Ascan(aHeader6, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad6:aCols[oGetDad6:oBrowse:nat,Ascan(aHeader6, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SRA->RA_NOME

		Endcase

	Endif

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  11/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function _GetDMot(_lGatilho)

	Default _lGatilho := .t.

	Dbselectarea("SX5")
	DbSetOrder(1)
	Dbseek(Xfilial("SX5")+'44'+&(READVAR()))

	IF EOF()

		MsgStop("Motivo Nao cadastrado, Verifique !!!")
		_lRet :=.f.

	Else

		_lRet := .t.

		Do Case

		Case Ascan(aHeader1, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad1:aCols[oGetDad1:oBrowse:nat,Ascan(aHeader1, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SX5->X5_DESCRI

		Case Ascan(aHeader2, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad2:aCols[oGetDad2:oBrowse:nat,Ascan(aHeader2, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SX5->X5_DESCRI

		Case Ascan(aHeader3, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad3:aCols[oGetDad3:oBrowse:nat,Ascan(aHeader3, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SX5->X5_DESCRI

		Case Ascan(aHeader4, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad4:aCols[oGetDad4:oBrowse:nat,Ascan(aHeader4, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SX5->X5_DESCRI

		Case Ascan(aHeader5, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad5:aCols[oGetDad5:oBrowse:nat,Ascan(aHeader5, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SX5->X5_DESCRI

		Case Ascan(aHeader6, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
			oGetDad6:aCols[oGetDad6:oBrowse:nat,Ascan(aHeader6, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SX5->X5_DESCRI

		Endcase

	Endif

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RCG                บ Data ณ  11/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function _GetDCod(_lGatilho)

	Default _lGatilho := .t.

	if &(READVAR()) <>   _cOp

		MSGSTOP( "Nใo ้ permitido alterar o N๚mero da Ordem de Produ็ใo ...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
			"Ordem de Produ็ใo")

		_lRet :=.f.
	Else
		Dbselectarea("SC2")
		DbSetOrder(1)
		Dbseek(Xfilial("SC2")+&(READVAR()))

		IF EOF()

			MsgStop("Ordem de Produ็ใo nใo cadastrada, Verifique !!!")
			_lRet :=.f.

		Else

			_lRet := .t.

			If !'PP2' $ upper(ALLTRIM(READVAR()))  .and. !'PP3' $ upper(ALLTRIM(READVAR()))
				Do Case

				Case Ascan(aHeader1, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
					oGetDad1:aCols[oGetDad1:oBrowse:nat,Ascan(aHeader1, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SC2->C2_PRODUTO

				Case Ascan(aHeader2, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
					oGetDad2:aCols[oGetDad2:oBrowse:nat,Ascan(aHeader2, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SC2->C2_PRODUTO

				Case Ascan(aHeader3, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
					oGetDad3:aCols[oGetDad3:oBrowse:nat,Ascan(aHeader3, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SC2->C2_PRODUTO

				Case Ascan(aHeader4, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
					oGetDad4:aCols[oGetDad4:oBrowse:nat,Ascan(aHeader4, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SC2->C2_PRODUTO

				Case Ascan(aHeader5, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
					oGetDad5:aCols[oGetDad5:oBrowse:nat,Ascan(aHeader5, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SC2->C2_PRODUTO

				Case Ascan(aHeader6, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) > 0
					oGetDad6:aCols[oGetDad6:oBrowse:nat,Ascan(aHeader6, {|x| Alltrim(x[2]) == substr(ALLTRIM(READVAR()),4) }) + 1]	:= SC2->C2_PRODUTO

				Endcase
			Endif

		Endif
	Endif
Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  25/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xAc1VLin()
	// producoes

return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  25/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xAc2VLin()
	// operacoes

	_lRet := .t.

return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  25/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xAc3VLin()
	// horas improdutivas

return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  25/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xAc4VLin()
	// perdas

return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  25/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xAc5VLin()
	// Operadores

return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  25/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xAc6VLin()
	// ops amarradas

return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  25/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xAc7VLin()
	// ops amarradas

return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RVG                บ Data ณ  25/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _ft5adl

	Local _nx
	Local _nPosop := Ascan(aHeader5,{|x| AllTrim(x[2]) == "PP5_CODIGO" })
	Local _nPosRi := Ascan(aHeader5,{|x| AllTrim(x[2]) == "PP5_RI" })
	Local _nPosNm := Ascan(aHeader5,{|x| AllTrim(x[2]) == "PP5_NOME" })

	If _nPosop <> 0 .and.  empty(oGetDad5:aCols[len(oGetDad5:aCols),_nPosop])
		oGetDad5:aCols[len(oGetDad5:aCols),_nPosop] := _cxop
	Endif

	If _nPosNm <> 0

		For _nx :=1 to len(oGetDad5:aCols)

			if empty(oGetDad5:aCols[_nx,_nPosNm])

				oGetDad5:aCols[_nx,_nPosNm] := Posicione("SRA",1,xFilial("SRA")+oGetDad5:aCols[_nx,_nPosRi],"RA_NOME")

			Endif

		Next _nx

	Endif

	oGetDad5:refresh()
return .t.

// ******************************************************************************************************************************

Static Function _ft1adl
	Local _nx
	Local _nPosop 	:= Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP1_CODIGO" })
	Local _nPosProd := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP1_COD" })
	Local _nPosDesc := Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP1_DESC" })
	Local _lRet	  := .T.

	If _nPosop <> 0 .and.  empty(oGetDad1:aCols[len(oGetDad1:aCols),_nPosop])
		oGetDad1:aCols[len(oGetDad1:aCols),_nPosop] := _cxop
	Endif

	If _nPosProd <> 0 .and.  empty(oGetDad1:aCols[len(oGetDad1:aCols),_nPosProd])
		oGetDad1:aCols[len(oGetDad1:aCols),_nPosProd] := _cProduto
	Endif

	If _nPosDesc <> 0

		For _nx :=1 to len(oGetDad1:aCols)

			if empty(oGetDad1:aCols[_nx,_nPosDesc])

				oGetDad1:aCols[_nx,_nPosDesc] := Posicione("SB1",1,xFilial("SB1")+oGetDad1:aCols[_nx,_nPosProd],"B1_DESC")

			Endif

		Next _nx

	Endif

Return(_lRet)

// ******************************************************************************************************************************

Static Function _ft2adl

	Local _nPosop := Ascan(aHeader2,{|x| AllTrim(x[2]) == "PP2_CODIGO" })

	If _nPosop <> 0 .and.  empty(oGetDad2:aCols[len(oGetDad2:aCols),_nPosop])
		oGetDad2:aCols[len(oGetDad2:aCols),_nPosop] := _cxop
	Endif

return .t.

// ******************************************************************************************************************************

Static Function _ft3adl

	Local _nPosop := Ascan(aHeader3,{|x| AllTrim(x[2]) == "PP3_CODIGO" })

	If _nPosop <> 0 .and.  empty(oGetDad3:aCols[len(oGetDad3:aCols),_nPosop])
		oGetDad3:aCols[len(oGetDad3:aCols),_nPosop] := _cxop
	Endif

return .t.

// ******************************************************************************************************************************
/*
Static Function _ft4adl

Local _nPosop := Ascan(aHeader4,{|x| AllTrim(x[2]) == "PP4_OP" })

	If _nPosop <> 0 .and.  empty(oGetDad4:aCols[len(oGetDad4:aCols),_nPosop])
oGetDad4:aCols[len(oGetDad4:aCols),_nPosop] := _cxop
	Endif

return .t.
*/

// ******************************************************************************************************************************

Static Function _ft6adl
	Local  _nx
	Local _nPosop 	:= Ascan(aHeader6,{|x| AllTrim(x[2]) == "PP6_CODIGO" })
	Local _nPosProd := Ascan(aHeader6,{|x| AllTrim(x[2]) == "PP6_PROD" })
	Local _nPosDesc := Ascan(aHeader6,{|x| AllTrim(x[2]) == "PP6_DESC" })

	If _nPosop <> 0 .and.  empty(oGetDad6:aCols[len(oGetDad6:aCols),_nPosop])
		oGetDad6:aCols[len(oGetDad6:aCols),_nPosop] := _cop
	Endif

	For _nx := 1 to len(oGetDad6:aCols)

		If _nPosop <> 0 .and.  empty(oGetDad6:aCols[_nx,_nPosProd])
			oGetDad6:aCols[len(oGetDad6:aCols),_nPosProd] := Posicione("SB1",1,xFilial("SB1")+oGetDad6:aCols[_nx,_nPosop],"C2_PRODUTO")
		Endif

		If _nPosDesc <> 0 .and.  empty(oGetDad6:aCols[_nx,_nPosDesc])
			oGetDad6:aCols[len(oGetDad6:aCols),_nPosDesc] := Posicione("SB1",1,xFilial("SB1")+oGetDad6:aCols[_nx,_nPosProd],"B1_DESC")
		Endif

	Next _nx

return .t.

// ******************************************************************************************************************************

Static Function _ft7adl

	Local _nPosop := Ascan(aHeader7,{|x| AllTrim(x[2]) == "PP9_CODIGO" })

	If _nPosop <> 0 .and.  empty(oGetDad7:aCols[len(oGetDad7:aCols),_nPosop])
		oGetDad7:aCols[len(oGetDad7:aCols),_nPosop] := _cXop
	Endif
return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCPA01  บAutor  ณ RVG Solucoes       ณ Data ณ 21/03/13    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STEefetiva

	Local nI
	Local aAreaSB1   := SB1->(GetArea())
	Local aAreaSC2   := SC2->(GetArea())
	Local aVetor     := {}
	Local aApOrd     := {}
	Local lRet       := .T.
	Local cD3TM    	 := GetMV("ST_XAPTOP",,"100")
	Local nModOld 	 := nModulo
	Local _cLocProd := AllTrim(GetMv("MV_LOCPROC"))+"-10"

	//Local _cApropri := ""
	//Local _cLocal90 := ""

	Local _lValid := .T.
	Local _aSd4   := {}
	Local _aOperacoes	:= aClone(oGetDad2:aCols)
	Local _aOperFinal	:= {}
	Local _cQuery	:= ""
	Local _cAlias	:= "QRYTEMP"
	Local _cQuery2 := ""
	Local _cAlias2 := GetNextAlias()
	Local _cQuery3 := ""
	Local _cAlias3 := GetNextAlias()
	Local _cQuery4 := ""
	Local _cAlias4 := GetNextAlias()
	Local __nX		:= 0
	Local _lRet	:= .T.
	Local _nPosOper := Ascan(aHeader2,{|x| AllTrim(x[2]) == "PP2_OPER" })
	Local _nQtdSG2 := 0
	Local _nQtdCol := 0
	Local _cLocalC2:= ""
	Local _cBenef   := SC2->C2_XBENEF
	//>> Ticket 20201022009286 - Everson Santana - 27.10.2020
	Local aCabSDA    := {}
	Local aItSDB        := {}
	Local _aItensSDB := {}
	Local _cLocPad 	:= ""
	Local _cCodSE	:= ""
	//<< Ticket 20201022009286

	Private	lMsErroAuto := .F.

	Private L250Auto := .f.

	_cQuery  := " SELECT G2_FILIAL FILIAL, G2_PRODUTO PRODUTO, G2_OPERAC OPERAC "
	_cQuery  += " FROM " +RetSqlName("SG2")+ " G2 "
	_cQuery  += " WHERE G2.D_E_L_E_T_=' ' AND G2_FILIAL='"+xFilial("SG2")+"' AND G2_PRODUTO='"+SC2->C2_PRODUTO+"' "
	_cQuery  += " AND G2_CODIGO='"+SC2->C2_ROTEIRO+"'

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	For __nX:=1 To Len(_aOperacoes)
		AADD(_aOperFinal,AllTrim(_aOperacoes[__nX][_nPosOper]))
	Next

	While (_cAlias)->(!Eof())
		_nQtdSG2++
		If aScan(_aOperFinal,{|x| x == AllTrim((_cAlias)->OPERAC)})>0
			_nQtdCol++
		EndIf
		(_cAlias)->(DbSkip())
	EndDo
	If _cBenef <> 'S' //Chamado 002654
		If _nQtdCol<>_nQtdSG2
			MsgAlert("Aten็ใo, quantidade de opera็๕es cadastradas diferente da tabela padrใo!")
			Return
		EndIf
	Endif

	Dbselectarea("SD4")
	SD4->(DbSetOrder(2))//D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	SD4->(DbGoTop())
	DbSeek(xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
	While SD4->(! Eof() .and. D4_FILIAL+Left(D4_OP,11) == xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

		If !ALLTRIM(SD4->D4_LOCAL) $ _cLocProd
			MsgStop("Existem diverg๊ncias para a efetiva็ใo do apontamento...!!!"+ Chr(10) + Chr(13) +;
				Chr(10) + Chr(13) +;
				"Consulte a tela a seguir para verificar os motivos das diverg๊ncias...!!!")
			U_STCONSULT()
			_lValid	:= .F.
		Endif

		SD4->(DbSkip())

	End

	If _lValid
		Dbselectarea("SC2")
//		_cAre_c2 := getarea()
		//reclock("SC2",.f.)
		//C2_XSTATUS:= "E"
		//msunlock()

		Dbselectarea("PP2")
		Dbsetorder(1)
		Dbseek(xfilial("PP2")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

		do While !eof() .and. Substr(PP2_CODIGO,1,11) == Substr(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,1,11)

			if empty(PP2_RECNO)

				aCampos:={	{"H6_OP" 	 ,PP2->PP2_CODIGO	  	,Nil},;
					{"H6_PRODUTO",SC2->C2_PRODUTO    	,Nil},;
					{"H6_OPERAC" ,PP2->PP2_OPER     	,Nil},;
					{"H6_RECURSO",PP2->PP2_RECURS   	,Nil},;
					{"H6_FERRAM" ,""                 	,Nil},;
					{"H6_DATAINI",PP2->PP2_DTINI 		,Nil},;
					{"H6_HORAINI",PP2->PP2_HRINI    	,Nil},;
					{"H6_DATAFIN",PP2->PP2_DTFIM    	,Nil},;
					{"H6_HORAFIN",PP2->PP2_HRFIM    	,Nil},;
					{"H6_QTDPROD",0		   		    	,Nil},;
					{"H6_QTDPERD",0			        	,Nil},;
					{"H6_DTAPONT",DDATABASE   			,Nil},;
					{"H6_TEMPO"  ,CalcTime(PP2->PP2_DTINI,PP2->PP2_HRINI,PP2->PP2_DTFIM,PP2->PP2_HRFIM)   			,Nil},;
					{"H6_OPERADO",PP2_OPERAD   			,Nil},;
					{"H6_SEQ"    ,			"" 			,Nil}}

				lMSErroAuto := .F.
				lMSHelpAuto := .F.

				MsgRun("Aguarde, Efetuando Apontamento ",,{||	MSExecAuto({|x,y| Mata681(x,y)},aCampos,3) })

				If lMsErroAuto
					//	Mostraerro()
					lOkArquivo := .f.
				Else

					RecLock("PP2",.f.)
					pp2_recno := SH6->(Recno())
					msunlock()

				Endif
			Endif
			Dbselectarea("PP2")
			DbSkip()

		Enddo

		//nModulo := 10

		Dbselectarea("PP3")
		Dbsetorder(1)
		Dbseek(xfilial("PP3")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

		do While !eof() .and. Substr(PP3_CODIGO,1,11) == Substr(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,1,11)

			if empty(PP3_RECNO)

				aCampos:={{"H6_RECURSO",PP3->PP3_RECURS    	,Nil},;
					{"H6_OPERAC" ,PP3->PP3_OPER     	,Nil},;
					{"H6_FERRAM" ,""                 	,Nil},;
					{"H6_DATAINI",PP3->PP3_DTINI 		,Nil},;
					{"H6_HORAINI",PP3->PP3_HRINI    	,Nil},;
					{"H6_DATAFIN",PP3->PP3_DTFIM    	,Nil},;
					{"H6_HORAFIN",PP3->PP3_HRFIM    	,Nil},;
					{"H6_DTAPONT",dDatabase   		    ,Nil},;
					{"H6_MOTIVO" ,PP3->PP3_MOTIVO		,Nil},;
					{"H6_OPERADO",PP3->PP3_OPERAD  		,Nil},;
					{"H6_TEMPO"  ,CalcTime(PP3->PP3_DTINI,PP3->PP3_HRINI,PP3->PP3_DTFIM,PP3->PP3_HRFIM),Nil},;
					{"H6_OBSERVA",""					,Nil}}

				MsgRun("Aguarde, Efetuando Apontamento ",,{|| MSExecAuto({|x,y| Mata682(x,y)},aCampos,3) })

				lMSErroAuto := .F.
				lMSHelpAuto := .F.

				If lMsErroAuto
					//	Mostraerro()
					lOkArquivo := .f.
				Else

					RecLock("PP3",.f.)
					pp3_recno := SH6->(Recno())
					msunlock()

				Endif
			Endif
			Dbselectarea("PP3")
			DbSkip()

		Enddo

		//nModulo := 10

		// Recria os empenhos  com base nos movimentos do SD3

		Check_Emp()

		//

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Posiciona nas tabelas para apontamento da OP. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))

		//>>Ticket 20201022009286 - Everson Satnana - 27.10.2020
		_cLocPad 	:= SB1->B1_LOCPAD 
		_cCodSE		:= SB1->B1_XCODSE
		//<<Ticket 20201022009286
		
		Dbselectarea("PP1")
		Dbsetorder(1)
		Dbseek(xfilial("PP1")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

		do While !eof() .and. Substr(PP1_CODIGO,1,11) == Substr(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,1,11)
			If Empty(PP1->PP1_STATUS)

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Gera Apontamento da OP.		                            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				if empty(PP1_RECNO)

					_cParc := "T"

					If PP1->PP1_QUANT<SC2->C2_QUANT
						_cParc := "P"
					EndIf

					VerEmp(PP1->PP1_CODIGO)// Chamado 008853 - Everson Santana - 18.01.2019

					_cDoc := ""

					_cQuery4 := " SELECT D3_DOC
					_cQuery4 += " FROM "+RetSqlName("SD3")+" D3
					_cQuery4 += " WHERE D3.D_E_L_E_T_=' ' AND D3_FILIAL='"+SC2->C2_FILIAL+"'
					_cQuery4 += " AND D3_TM='"+cD3TM+"' AND D3_COD='"+SC2->C2_PRODUTO+"'
					_cQuery4 += " AND D3_OP='"+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)+"'
					_cQuery4 += " ORDER BY D3_DOC DESC

					If !Empty(Select(_cAlias4))
						DbSelectArea(_cAlias4)
						(_cAlias4)->(dbCloseArea())
					Endif

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery4),_cAlias4,.T.,.T.)

					dbSelectArea(_cAlias4)
					(_cAlias4)->(dbGoTop())

					If (_cAlias4)->(!Eof())
						_cDoc := Soma1((_cAlias4)->D3_DOC)
					Else
						_cDoc := SC2->(C2_NUM+C2_ITEM)+"A"
					EndIf

					_aMata250 := {}
					aAdd(_aMata250, {"D3_TM"      	, cD3TM	             										, NIL})
					aAdd(_aMata250, {"D3_COD"     	, SC2->C2_PRODUTO		 										, NIL})
					aAdd(_aMata250, {"D3_UM"      	, SB1->B1_UM			 										, NIL})
					aAdd(_aMata250, {"D3_QUANT"   	, PP1->PP1_QUANT 		 										, NIL})
					aAdd(_aMata250, {"D3_PERDA"   	, 0                    		    							, NIL})
					aAdd(_aMata250, {"D3_OP"      	, SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)			 					, NIL})
					aAdd(_aMata250, {"D3_PARCTOT" 	, _cParc               										, NIL})
					aAdd(_aMata250, {"D3_LOCAL"   	, Iif(Empty(PP1->PP1_LOCPER),SC2->C2_LOCAL,PP1->PP1_LOCPER)	, NIL})
					aAdd(_aMata250, {"D3_EMISSAO" 	, dDataBase            										, NIL})
					aAdd(_aMata250, {"D3_DOC" 		, _cDoc					             				, NIL})
					aAdd(_aMata250, {"D3_CF"   , "PR0"		 										, NIL})

					lMsErroAuto := .F.
					lMSHelpAuto := .T.
					/*
					If !Empty(PP1->PP1_LOCPER)
						_cLocalC2	:= SC2->C2_LOCAL
						SC2->(RecLock("SC2",.F.))
						SC2->C2_LOCAL	:= PP1->PP1_LOCPER
						SC2->(MsUnlock())
					EndIf
					*/
					MsgRun("Aguarde, Efetuando Apontamento ",,{||		MSExecAuto({|x,y| Mata250(x,y)},_aMata250,3)}) //Inclusao

				/*	If !Empty(_cLocalC2)
						SC2->(RecLock("SC2",.F.))
						SC2->C2_LOCAL	:= _cLocalC2  Retirado nใo transferia para armazem 97 --Jefferson
						SC2->(MsUnlock())
						_cLocalC2	:= ""
				EndIf*/

				If lMsErroAuto

						Mostraerro()
						lOkArquivo := .f.

				Else

						_cQuery  := " SELECT MAX(D3.R_E_C_N_O_) RECSD3
						_cQuery  += " FROM " +RetSqlName("SD3")+ " D3
						_cQuery  += " WHERE D3.D_E_L_E_T_=' ' AND D3_FILIAL='"+PP1->PP1_FILIAL+"'
						_cQuery  += " AND D3_TM='100' AND D3_COD='"+PP1->PP1_COD+"' AND D3_CF='PR0'
						_cQuery  += " AND D3_OP='"+PP1->PP1_CODIGO+"' AND D3_EMISSAO='"+DTOS(PP1->PP1_DATA)+"'

					If !Empty(Select(_cAlias))
							DbSelectArea(_cAlias)
							(_cAlias)->(dbCloseArea())
					Endif

						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

						dbSelectArea(_cAlias)
						(_cAlias)->(dbGoTop())

					If (_cAlias)->(!Eof())

							_cQuery3 := " SELECT D3.R_E_C_N_O_ RECSD3, NVL(DA.R_E_C_N_O_,0) RECSDA
							_cQuery3 += " FROM "+RetSqlName("SD3")+" D3
							_cQuery3 += " LEFT JOIN "+RetSqlName("SDA")+" DA
							_cQuery3 += " ON DA_FILIAL=D3_FILIAL AND DA_DOC=D3_DOC AND DA_LOCAL=D3_LOCAL AND DA_ORIGEM='SD3' AND DA_NUMSEQ=D3_NUMSEQ AND DA.D_E_L_E_T_=' '
							_cQuery3 += " WHERE D3.D_E_L_E_T_=' ' AND D3.R_E_C_N_O_="+CVALTOCHAR((_cAlias)->RECSD3)

						If !Empty(Select(_cAlias3))
								DbSelectArea(_cAlias3)
								(_cAlias3)->(dbCloseArea())
						Endif

							dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

							dbSelectArea(_cAlias3)
							(_cAlias3)->(dbGoTop())

						If (_cAlias3)->(!Eof())

								DbSelectArea("SD3")
								SD3->(DbGoTo((_cAlias3)->RECSD3))

								PP1->(Reclock("PP1",.F.))
								PP1->PP1_STATUS	:= SD3->D3_PARCTOT
								PP1->PP1_NUMSEQ	:= SD3->D3_NUMSEQ
								PP1->PP1_RECNO	:= (_cAlias3)->RECSD3
								PP1->(MsUnLock())

								SD3->(Reclock("SD3",.F.))
								SD3->D3_XOBS	:= PP1->PP1_OBS
								SD3->(MsUnLock())

							If (_cAlias3)->RECSDA>0

								//>>Ticket 20201022009286 - Everson Satnana - 27.10.2020
								If cFilAnt = '05' .and. _cLocPad = '90' .and. _cCodSE = 'S'
									//Cabe็alho com a informa็ใo do item e NumSeq que sera endere็ado.

										aCabSDA := {{"DA_PRODUTO" ,SD3->D3_COD       ,Nil},;	  
													{"DA_NUMSEQ"  ,SD3->D3_NUMSEQ,Nil}}

									//Dados do item que serแ endere็ado

										aItSDB := {{"DB_ITEM"	  ,"0001"	    ,Nil},;                   
													{"DB_ESTORNO"  ," "	      	,Nil},;                   
													{"DB_LOCALIZ"  ,"PRODUCAO"  ,Nil},;                   
													{"DB_DATA"	  ,dDataBase    ,Nil},;                   
													{"DB_QUANT"  ,SD3->D3_QUANT ,Nil}}       

										aadd(_aItensSDB,aitSDB)
									//Executa o endere็amento do item

										MsgRun("Aguarde, Efetuando Endere็amento ",,{|| MATA265( aCabSDA, _aItensSDB, 3)}) //Inclusao									

									If lMsErroAuto

									MostraErro()
									
									Endif

								EndIf
								//<<

								DbSelectArea("SDA")
								SDA->(DbGoTo((_cAlias3)->RECSDA))

								SDA->(RecLock("SDA",.F.))
								SDA->DA_XOBS	:= PP1->PP1_OBS
								SDA->(MsUnLock())
			
							EndIf

						EndIf

					EndIf

				EndIf

			EndIf

		EndIf

			Dbselectarea("PP1")
			DbSkip()

	Enddo

		// Acertando Rastro de Produtos Steck

		Dbselectarea("PP9")
		Dbsetorder(1)
		Dbseek(xfilial("PP9")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

	do While !eof() .and. Substr(PP9_CODIGO,1,11) == Substr(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,1,11)

			PA0->(RecLock("PA0",.T.))
			PA0->PA0_FILIAL 	:= xFilial("PA0")
			PA0->PA0_ORDSEP 	:= ""
			PA0->PA0_DOC		:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
			PA0->PA0_TIPDOC		:= 'D4P'
			PA0->PA0_ITSEP		:= ""
			PA0->PA0_PROD   	:= PP9->PP9_PROD
			PA0->PA0_LOTEX  	:= PP9->PP9_LOTE
			PA0->PA0_QTDE		:= PP9->PP9_QUANT
			PA0->PA0_USU	 	:= __cUserID
			PA0->PA0_DTSEP  	:= dDataBase
			PA0->PA0_HRSEP  	:= Time()
			Msunlock()
			Dbselectarea("PP9")
			Dbskip()
	Enddo

		_lOk := .t.

		Dbselectarea("PP1")
		Dbsetorder(1)
		Dbseek(xfilial("PP1")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

	do While !eof() .and. Substr(PP1_CODIGO,1,11) == Substr(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,1,11)

		if empty(PP1_RECNO)
				_lOk := .f.
		endif
			Dbskip()

	Enddo

		Dbselectarea("SC2")
//		RestArea( _cAre_c2 )

	if _lOk
			Dbselectarea("SC2")
			reclock("SC2",.f.)
			C2_XSTATUS:= "E"
		If C2_QUJE >= C2_QUANT
				C2_DATRF := ddatabase
		Endif
			msunlock()
	Endif
Else
		Alert("Apontamento nใo serแ realizado...!!!")
Endif
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ CalcTime ณ Autor ณ RVG Solucoes          ณ Data ณ 21/03/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Calcula tempo gasto na operacao                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CalcTime(_dDtIni,_CHrini,_dDtFim,_cHrFim)
	Static cTpHr
	Local cTime      :=""
	Local nTempoCen  :=0
	Local lUsaCalend := GetMV("MV_USACALE",, .T.)
	Local cForHora   :=  "N"
	Local nZeros     := At(":", PesqPict("SH6", "H6_TEMPO")) - 1
	//Local lApsDrummer:= SuperGetMv("MV_APS",.F.,"")=="DRUMMER"

	If cTpHr == Nil
		cTpHr := GetMv("MV_TPHR")
	EndIf

	If lUsaCalend
		If !Empty(M->H6_RECURSO)
			SH1->(dbSetOrder(1))
			If SH1->(dbSeek(xFilial("SH1")+PP2->PP2_RECURS))
				nTempoCen:=A680TimeCale(_dDtIni,A680ConvHora(_CHrini, cForHora),_dDtFim,A680ConvHora(_cHrFim, cForHora),PP2->PP2_RECURS)

			Else
				nTempoCen:=0
			EndIf
		EndIf
	Else
		nTempoCen := A680Tempo(_dDtIni,A680ConvHora(_CHrini, cForHora),_dDtFim,A680ConvHora(_cHrFim, cForHora))
	EndIf

	cTime := StrZero(Int(nTempoCen), nZeros) + ":" + StrZero(Mod(nTempoCen, 1) * 100, 2)
	cTime := A680ConvHora(cTime, "C", cForHora)

Return cTime

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RefVAuto บAutor  ณRVG Solcuoes        บ Data ณ  13/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta array de Execauto conforme Ordem do Dicionario(SX3) บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SMC				                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RefVAuto(aLayout, cAlias2)
	Local nP       := 0
	Local aArea    := GetArea()
	Local aAreaSX3 := SX3->(GetArea())
	Local aRet     := {}

	dbSelectArea("SX3")
	dbSetOrder(4)
	dbSeek(cAlias2)
	While !EOF() .and. SX3->X3_ARQUIVO == cAlias2
		nP := aScan(aLayOut, {|x| Upper(Alltrim(x[1])) == Upper(Alltrim(X3_CAMPO))})
		If nP > 0
			AADD(aRet, aLayOut[nP])
		Endif
		dbSelectArea("SX3")
		dbSkip()
	Enddo

	// Restaura as Areas
	RestArea(aAreaSX3)
	RestArea(aArea)

Return aClone(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCPA01  บAutor  ณMicrosiga           บ Data ณ  04/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function pca01em()
	Local _cArea := getarea()
	_lRet := .t.

	Dbselectarea("SD4")
	SD4->(DbSetOrder(1))//D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE
	SD4->(DbGoTop())
	dbSeek(xFilial('SD4')+&(readvar())+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)

	if eof()
		MsgStop("Produto nao faz parte dos empenhos da OP !")
		_lRet := .f.
	Endif

	RestArea(_cArea)

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณFt300Leg  ณAutor  ณ Flex Projects         ณ Data ณ13.12.2012 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณDemonstra a legenda das cores da mbrowse                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNenhum                                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณEsta rotina monta uma dialog com a descricao das cores da    ณฑฑ
ฑฑณ          ณMbrowse.                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ STFTA001                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STResLeg()
	Local aCores    := {{"ENABLE"		,"Sem Apontamentos"},;
		{"BR_AMARELO"	,"Apontamenos incluidos"},;
		{"DISABLE"		,"Finalizado"}}

	BrwLegenda(cCadastro,"Status de Apontamento",aCores)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCPA01  บAutor  ณMicrosiga           บ Data ณ  04/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STReabre

	Dbselectarea("SC2")
	reclock("SC2",.f.)
	C2_XSTATUS:= "A"
	msunlock()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSD1100I   บAutor  ณMicrosiga           บ Data ณ  03/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function Check_Emp()

	Local _cQuery
	_cQuery := " SELECT DISTINCT D3_COD,SUM(D3_QUANT) AS QUANTIDADE "
	_cQuery += " FROM "+RetSqlName("SD3")
	_cQuery += " WHERE D3_FILIAL = '"+XFILIAL('SD3')+"' "
	_cQuery += " AND D3_OP = '" +SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) +"'"
	_cQuery += " AND D_E_L_E_T_ = ' ' "
	_cQuery += " AND D3_CF LIKE 'RE%' "
	_cQuery += " AND D3_ESTORNO = ' ' "
	_cQuery += " GROUP BY D3_COD "
	_cQuery += " ORDER BY D3_COD "

	dbUseArea(.T., "TOPCONN",TCGENQRY(,,_cQuery),"TRB1",.F.,.T.)

	TCSetField('TRB1','QUANTIDADE', 'N',14,2)

	DbSelectarea('TRB1')

	Do While !EOF()

		Dbselectarea("SD4")
		SD4->(DbSetOrder(1))//D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE
		SD4->(DbGoTop())
		dbSeek(xFilial('SD4')+TRB1->D3_COD+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)

		if !eof()

			reclock("SD4",.F.)
			d4_quant := d4_qtdeori  - trb1->quantidade
			msunlock()

		Endif

		DbSelectarea('TRB1')
		Dbskip()

	Enddo

	DbSelectarea('TRB1')
	DbClosearea()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSD1100I   บAutor  ณMicrosiga           บ Data ณ  03/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STCONSULT()

	Local _lValid   := .F.
	Local _aDados   := {}
	Local _cDescri  := ""
	Local _cTipo    := ""
	Local _cUnidade := ""
	Local _cApropri := ""
	Local _cLocal90 := ""
	Local lOk		  := .T.
	Local aSize     := MsAdvSize(, .F., 400)
	Local aButtons  := {}
	Private oListBox

	Dbselectarea("SD4")
	SD4->(DbSetOrder(2))//D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	SD4->(DbGoTop())
	If DbSeek(xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
		While SD4->(! Eof() .and. D4_FILIAL+Left(D4_OP,11) == xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

			DbSelectarea("SB1")
			SB1->(DbSetOrder(1))//B1_FILIAL+B1_COD
			SB1->(DbGoTop())
			If SB1->(DbSeek(xFilial("SB1")+(SD4->D4_COD)))
				_cDescri  := SB1->B1_DESC
				_cTipo    := SB1->B1_TIPO
				_cUnidade := SB1->B1_UM
				_cApropri := SB1->B1_APROPRI
			Endif
			/*
			DbSelectarea("SB2")
			SB2->(DbSetOrder(1))//B2_FILIAL+B2_COD+B2_LOCAL
			SB2->(DbGoTop())
			If SB2->(DbSeek(xFilial("SB2")+(SD4->D4_COD)+'90'))
			_cLocal90  := SB2->B2_QATU
			Endif
			*/
			DbSelectarea("SBF")
			SBF->(DbSetOrder(1))//B2_FILIAL+B2_COD+B2_LOCAL
			SBF->(DbGoTop())
			If SBF->(DbSeek(xFilial("SBF")+'90'+'PRODUCAO'+ Space(7)+(SD4->D4_COD)))
				_cLocal90  := SBF->BF_QUANT
			Else
				_cLocal90  := 0
			Endif

			DO CASE

			CASE _cApropri = "D"
				_cApropri := "Direta"

			CASE _cApropri = "I"
				_cApropri := "Indireta"

			ENDCASE

			Aadd(_aDados,{	SD4->D4_COD,;
				_cDescri,;
				_cTipo,;
				_cUnidade,;
				_cApropri,;
				SD4->D4_LOCAL,;
				SD4->D4_XORDSEP,;
				SD4->D4_QTDEORI,;
				SD4->D4_QUANT,;
				_cLocal90})
			SD4->(DbSkip())

		End

		Define MSDialog oDlgCons Title "Consulta de Itens de Apropria็ใo Direta e Indireta da Ordem de Produ็ใo" From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

		@ 45, 05 LISTBOX oListBox VAR nPosLbx FIELDS HEADER "C๓digo","Descri็ใo","Tipo","Unidade","Apropria็ใo","Armaz้m","Nบ Ordem Separa็ใo","Qtde. Requisitada Estrutura","Qtde. Empenho","Saldo Armaz้m 90" SIZE 440,150 OF oDlgCons PIXEL NOSCROLL

		oListBox:SetArray(_aDados)
		oListBox:bLine := { ||{_aDados[oListBox:nAT][1],;
			_aDados[oListBox:nAT][2],;
			_aDados[oListBox:nAT][3],;
			_aDados[oListBox:nAT][4],;
			_aDados[oListBox:nAT][5],;
			_aDados[oListBox:nAT][6],;
			_aDados[oListBox:nAT][7],;
			_aDados[oListBox:nAT][8],;
			_aDados[oListBox:nAT][9],;
			_aDados[oListBox:nAT][10]}}
		oListBox:blDblClick := {|| _aDados[ oListBox:nAt, 01] ,oDlgCons:End()}
		oListBox:Align := CONTROL_ALIGN_ALLCLIENT // Retorno da pesquisa em tela cheia
		oListBox:Refresh()

		ACTIVATE MSDIALOG oDlgCons ON INIT EnchoiceBar(oDlgCons,{|| nOpca := 1,oDlgCons:End() },{||oDlgCons:End()},,aButtons)
	Else
		Alert("Nใo foram geradas requisi็๕es de empenho para essa OP...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Favor verificar com o PCP...!!!")
	Endif

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSD1100I   บAutor  ณMicrosiga           บ Data ณ  03/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XDELPP1()

	Local _lRet		:= .T.
	Local _nPosStatus	:= Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP1_STATUS" })

	If !Empty(oGetDad1:aCols[n,_nPosStatus])
		_lRet	:= .F.
		MsgAlert("Aten็ใo, linha jแ produzida e nใo pode ser apagada!")
	EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSD1100I   บAutor  ณMicrosiga           บ Data ณ  03/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XALTPP1()

	Local _lRet		:= .T.
	Local _nPosStatus	:= Ascan(aHeader1,{|x| AllTrim(x[2]) == "PP1_STATUS" })

	If !Empty(oGetDad1:aCols[n,_nPosStatus])
		_lRet	:= .F.
		MsgAlert("Aten็ใo, linha jแ produzida e nใo pode ser alterada!")
	EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTPCP001  บAutor  ณ RCG                บ Data ณ  11/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function _GetEmpenho(_lGatilho)

	Local _lRet       := .T.
	Default _lGatilho := .t.

	Dbselectarea("SD4")
	SD4->(DbSetOrder(2))//D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	SD4->(DbGoTop())
	If DbSeek(xFilial('SD4')+SC2->(C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))
		If DbSeek(xFilial('SD4')+SC2->(C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)+Space(3)+(M->PP9_PROD))
			_lRet :=.T.
		Else
			_lRet :=.F.
			MSGSTOP( "O C๓digo do Componente informado nใo faz parte dessa Ordem de Produ็ใo ...!!!"+ Chr(10) + Chr(13) +;
				Chr(10) + Chr(13) +;
				"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
				"Componentes")
		Endif
	Endif

Return _lRet

Static Function VerEmp(_cOP)

	LOCAL aAreaAnt := GETAREA()
	Local _cQuery1 	:= ""
	Local _cQuery2 	:= ""

	_cAlias1 	:= GetNextAlias()
	_cAlias2 	:= GetNextAlias()

	DbSelectArea("SDC")
	SDC->(DbSetOrder(1))
	DbSelectArea("SBF")
	SBF->(DbSetOrder(1))

	_cQuery2 	:= "  SELECT * FROM "+RetSqlName("SD4")+" D4"
	_cQuery2 	+= " WHERE D4_OP = '"+_cOP+"' AND D_E_L_E_T_ = ' ' "

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

	While (_cAlias2)->(!Eof())

		_cQuery1 := " SELECT BF.BF_FILIAL FILIAL,BF.BF_PRODUTO PRODUTO,BF.BF_LOCAL LOCAL,BF.BF_LOCALIZ LOCALIZ,BF.BF_QUANT,BF.BF_EMPENHO EMPBF,BF.R_E_C_N_O_ SBFREC,  "
		_cQuery1 += " NVL(( "
		_cQuery1 += " SELECT Sum(DC.DC_QUANT) "
		_cQuery1 += " FROM "+RetSqlName("SDC")+" DC "
		_cQuery1 += " WHERE  DC.DC_FILIAL = BF.BF_FILIAL "
		_cQuery1 += " AND DC.DC_LOCAL = BF.BF_LOCAL "
		_cQuery1 += " AND DC.DC_QUANT > 0  "
		_cQuery1 += " AND DC.DC_PRODUTO = BF.BF_PRODUTO "
		_cQuery1 += " AND DC.D_E_L_E_T_ = ' ' "
		_cQuery1 += " ),0) QTDDC "
		_cQuery1 += " FROM "+RetSqlName("SBF")+" BF "
		_cQuery1 += " WHERE  BF.BF_PRODUTO = '"+(_cAlias2)->D4_COD+"' "
		_cQuery1 += " AND BF.BF_LOCAL = '90' "
		//	_cQuery1 += " AND BF.BF_EMPENHO > 0 "
		_cQuery1 += " AND BF.D_E_L_E_T_ = ' ' "

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->(!Eof())

			SBF->(DbGoTo((_cAlias1)->SBFREC))

			If SBF->(DbSeek((_cAlias1)->FILIAL+(_cAlias1)->LOCAL+(_cAlias1)->LOCALIZ+(_cAlias1)->PRODUTO))

				SBF->(RecLock("SBF",.F.))
				SBF->BF_EMPENHO := 0 //(_cAlias1)->QTDDC
				SBF->(MsUnLock())

			EndIf

		EndIf

		(_cAlias2)->(dbSkip())

	EndDo

	RESTAREA(aAreaAnt)

Return

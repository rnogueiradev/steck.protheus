#include 'Protheus.ch'
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#Define CR chr(13)+ chr(10)

/*====================================================================================\
|Programa  | XMLPAINEL        | Autor | GIOVANI.ZAGO             | Data | 11/06/2017  |
|=====================================================================================|
|Descrição | XMLPAINEL       				                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | XMLPAINEL          	                                                  |
|=====================================================================================|
|Uso       | Especifico  		                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function XMLPAINEL()
	Local aCoors := FWGetDialogSize( oMainWnd )
	Local oLayerTabFrete, oLayerNeg
	Local oDialog061

	Local oOk           := LoadBitmap( GetResources(), "LBOK" )
	Local oNo           := LoadBitmap( GetResources(), "LBNO" )
	Private oBrwCabec, oBrwXml
	Private cOrig := 'NF-E'
	Private oNFE,oCTE,oNFSE,oLbx
	Private lNFE:=lCTE:=lNFSE := .t.
	Private aLbx := {}

	SZ9->(dbClearFilter())
	SZ9->(dbGoTop())
	If Empty(aLbx)
		aadd(aLbx,{.T.,'NF-E'})
		aadd(aLbx,{.T.,'CT-E'})
		aadd(aLbx,{.T.,'NFS-E'})
	EndIf
	u_Layer()
	Return

	Define MsDialog oDialog061 Title "Painel Xml" From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel
	/* -- Layers -------------------------------------------------- */
	oFWLayer := FWLayer():New()
	oFWLayer:Init(oDialog061, .F., .T.)

	oFWLayer:AddLine('TOP', 25, .F.)
	oFWLayer:AddCollumn('TABFRETE', 100, .T., 'TOP')
	oFWLayer:AddWindow('TABFRETE', 'TABFRETEWIN', "Filtros", 100, .F., .F., /*bAction*/, 'TOP')
	oLayerCabecalho := oFWLayer:GetWinPanel('TABFRETE', 'TABFRETEWIN', 'TOP')


	// Negociação
	oFWLayer:AddLine('BOTTON', 75, .F.)
	oFWLayer:AddCollumn('NEGOC', 100, .T., 'BOTTON')
	oLayerNeg := oFWLayer:GetColPanel('NEGOC', 'BOTTON')


	oPanelCabecalho := TScrollBox():Create(oLayerCabecalho,01,01,10,10,.T.,.T.,.T.)
	oPanelCabecalho:Align := CONTROL_ALIGN_ALLCLIENT

	@ 001,001 listbox oLbx fields header " ", "Tipo"  size  70,60 of oPanelCabecalho pixel on dbLclick(edlista() , oBrwXml:SetFilterDefault("ALLTRIM(SZ9->Z9_ORIGEM) $ '" + ALLTRIM(cOrig) + "'"),oBrwXml:Refresh()   )


	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2]}}
	oLbx:Refresh()

	oBrwXml := FWMBrowse():New()
	oBrwXml:SetAlias('SZ9')
	oBrwXml:SetOwner(oLayerNeg)
	oBrwXml:SetDescription("Xml - Documentos")
	oBrwXml:DisableDetails()
	oBrwXml:SetMenuDef("GFEA061A")
	oBrwXml:ForceQuitButton(.T.)
	oBrwXml:SetProfileID("2")
	oBrwXml:SetAmbiente(.F.)
	oBrwXml:SetWalkthru(.F.)

	oBrwXml:Activate()


	oBrwXml:UpdateBrowse() //Para atualizar após a exclusão das colunas

	//	oBrwCabec:UpdateBrowse() //Para dar foco no grid de tabelas.

	Activate MsDialog oDialog061 Center


Return

Static Function EdLista()

	Local b:= 1

	aLbx[oLbx:nAt,1]	:= !aLbx[oLbx:nAt,1]

	cOrig:= ' '
	for b:= 1 to Len(aLbx)

		If aLbx[b,1]
			cOrig+= Alltrim(aLbx[b,2])+'/'
		EndIf

	next b

	oLbx:Refresh()
Return ()
user function GatPai()


	cOrig:= ' '
	If lNFE
		cOrig+= 'NF-E'
	EndIf
	If lCTE
		cOrig+= '/CT-E'
	EndIf
	If lNFSE
		cOrig+= '/NFS-E'
	EndIf


return (.T.)

//Layer()
User Function Layer()
	Private oDlg ,oBrwXml,oLayer01,oNFE,oSay1,oSTA,oSay2,oCgc,oVal,oDt,oDtFim,oStx
	Private oLayer 	:= FWLayer():new()
	Private aCoors 	:= FWGetDialogSize( oMainWnd )
	Private cOrig 	:= Space(15)
	Private cCgc  	:= Space(14)
	Private nVal  	:= 0
	Private cStx 	:= "3-Todos"
	Private cSTA 	:= "Todos"
	Private dDt  	:= CTOD("  /  /  ")
	Private dDtFim	:= CTOD("  /  /  ")
	Private dDt1  	:= CTOD("  /  /  ")
	Private cNome	:= Space(50)
	Private bcOrig	:= cOrig
	Private bcSta	:= cSTA
	Private bnVal	:= nVal
	Private bcCgc	:= cCgc
	Private bdDt	:= dDt
	Private bdDtFim	:= dDtFim
	Private bcStx	:= cStx
	Private bdDt1	:= dDt1
	Private bcNome	:= cNome
	Private cCadastro := "Painel Xml"

	Define MsDialog oDlg Title cCadastro From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel
	oLayer:init(oDlg,.T.)//Cria as colunas do Layer
	oLayer:addCollumn('Col01',010,.F.)
	oLayer:addCollumn('Col02',090,.F.)  //Adiciona Janelas as colunas
	oLayer:addWindow('Col01','C1_Win01','Filtros',80,.T.,.F.,{||   }, ,{||   })
	//oLayer:addWindow('Col01','C1_Win02','Janela 02',40,.T.,.T.,{||   }, ,{||   })
	oLayer:addWindow('Col02','C2_Win01','Documentos',100,.T.,.F.,{||   },,{||  })
	//oLayer:getWinPanel('Col02','C2_Win01')                             //Coloca o botão de split na coluna
	//oLayer:setColSplit('Col01',CONTROL_ALIGN_LEFT,,{|| Alert("Split Col01!") })

	oLayer01:= oLayer:GetWinPanel('Col01', 'C1_Win01' )

	@ 001, 001 SAY oSay1 PROMPT "Documento:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 010, 000 COMBOBOX oNFE VAR cOrig ITEMS {"NF-E","CT-E","NFS-E","NF-E/CT-E/NFS-E"} Size 55,10 PIXEL OF oLayer01  Valid VALPAI()

	@ 023, 001 SAY oSay2 PROMPT "Status Nf-e:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 032, 000 COMBOBOX oSTA VAR cSta ITEMS {"Ciencia","Nf cancelada","Confirmada Operação","Operação não realizada","Desconhecimento da Operação","Todos"} Size 55,10 PIXEL OF oLayer01  Valid VALPAI()

	@ 044, 001 SAY oSay1 PROMPT "Cnpj:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 053, 000 MSGET oCgc VAR cCgc Size 55,10 PIXEL OF oLayer01 PICTURE '@R 99.999.999/9999-99'    Valid VALPAI()

	@ 065, 001 SAY oSay1 PROMPT "Valor:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 074, 000 MSGET oVal VAR nVal Size 55,10 PIXEL OF oLayer01 PICTURE '@E 99,999,999,999.99'    Valid VALPAI()

	@ 086, 001 SAY oSay1 PROMPT "De Data:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 095, 000 MSGET oDt VAR dDt Size 55,10 PIXEL OF oLayer01 PICTURE '99/99/99'    //Valid VALPAI()

	@ 107, 001 SAY oSay1 PROMPT "Ate Data:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 116, 000 MSGET oDtFim VAR dDtFim Size 55,10 PIXEL OF oLayer01 PICTURE '99/99/99'    Valid VALPAI()


	@ 128, 001 SAY oSay2 PROMPT "Pré-NF:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 137, 000 COMBOBOX oSTx VAR cStx ITEMS {"1-Sem Pré-Nf","2-Com Pré-Nf","3-Todos"} Size 55,10 PIXEL OF oLayer01  Valid VALPAI()

	@ 149, 001 SAY oSay2 PROMPT "Dt Digitação:"	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 158, 000 MSGET oDt1 VAR dDt1 Size 55,10 PIXEL OF oLayer01 PICTURE '99/99/99' Valid VALPAI()

	@ 170, 001 SAY oSay2 PROMPT "Nome"	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 179, 000 MSGET oNome VAR cNome Size 55,10 PIXEL OF oLayer01  Valid VALPAI()


	oLayerBrw := oLayer:GetColPanel('Col02')
	oBrwXml := FWMBrowse():New()
	oBrwXml:SetAlias('SZ9')
	oBrwXml:SetOwner(oLayerBrw)
	oBrwXml:SetDescription("Xml - Documentos")
	oBrwXml:DisableDetails()
	oBrwXml:SetMenuDef(" ")
	oBrwXml:ForceQuitButton(.T.)
	oBrwXml:SetProfileID("1")
	oBrwXml:SetAmbiente(.F.)
	oBrwXml:SetWalkthru(.F.)
	//oBrwXml:SetUseFilter(.F.)
	//oBrwXml:SetUseCaseFilter(.F.)
	//oBrwXml:AddLegend( " AllTrim(SZ9->Z9_ORIGEM) = 'NF-E' .AND. SZ9->Z9_STATUS == '0'"							, "RED"	, "NF-E Aguardando realizar manifesto"     )
	oBrwXml:AddLegend( " Empty(SZ9->Z9_DOC) .AND. SZ9->Z9_STATUS=='E' "                                                   , "DBG07" , "Detectado Inconsistências")
	oBrwXml:AddLegend( " AllTrim(SZ9->Z9_ORIGEM) = 'NF-E'  .AND.  Empty(SZ9->Z9_DOC) .AND. !(SZ9->Z9_STATUS $ 'X/1/8/9') ", "GREEN"	, "NF-E Aguardando gerar pré-nota" )
	oBrwXml:AddLegend( " AllTrim(SZ9->Z9_ORIGEM) = 'NF-E'  .AND. !Empty(SZ9->Z9_DOC) .AND. !(SZ9->Z9_STATUS $ 'X/1/8/9') ", "RED"	, "NF-E Pré-nota gerada"     )
	oBrwXml:AddLegend( " AllTrim(SZ9->Z9_ORIGEM) = 'NF-E'  .AND. SZ9->Z9_STATUS $ 'X/8/9'  "							  , "BLACK"	, "NF-E Nota Cancelada" )          // Valdemir Rabelo 02/06/2021
	oBrwXml:AddLegend( " AllTrim(SZ9->Z9_ORIGEM) = 'CT-E'  .AND. Empty(SZ9->Z9_DOC)    "								  , "BLUE"	, "CT-E Aguardando gerar pré-nota"     )
	oBrwXml:AddLegend( " AllTrim(SZ9->Z9_ORIGEM) = 'CT-E'  .AND. !Empty(SZ9->Z9_DOC)   "								  , "YELLOW", "CT-E Pré-nota gerada"     )
	oBrwXml:AddLegend( " AllTrim(SZ9->Z9_ORIGEM) = 'NFS-E' .AND. Empty(SZ9->Z9_DOC)    "								  , "PINK"	, "NFS-E Aguardando gerar pré-nota"     )
	oBrwXml:AddLegend( " AllTrim(SZ9->Z9_ORIGEM) = 'NFS-E' .AND. !Empty(SZ9->Z9_DOC)   "								  , "GRAY"	, "NFS-E Pré-nota gerada"     )
	oBrwXml:AddLegend( " AllTrim(SZ9->Z9_ORIGEM) = 'NF-E'  .And. (SZ9->Z9_STATUS == '1') " 	  							  , "ORANGE", "NF-E Operação confirmada"     )    // Conforme Ticket: 20210819016253 - 30/08/2021 - Valdemir Rabelo

	oBrwXml:AddButton("Gerar pre-nota" 				,{|| u_MEXML() },,4,,.F.)
	oBrwXml:AddButton("Gerar com arquivo"			,{|| U_EXECPREA() },,3,,.F.)
	oBrwXml:AddButton("Exportar XML"				,{|| U_EXPORTXM() },,2,,.F.)
	oBrwXml:AddButton("Consulta Inconsist" 			,{|| U_INCONSIS() },,4,,.F.)
	oBrwXml:AddButton("Consulta Arquivo XML"		,{|| CONSXML() },,4,,.F.)
//	oBrwXml:AddButton("Executa Automatização"		,{|| U_EXEPRENF(oBrwXml) },,4,,.F.)
	oBrwXml:AddButton("Exec.Automat.Individual"		,{|| U_EXEPRENF(oBrwXml, SZ9->Z9_CHAVE) },,4,,.F.)
	oBrwXml:AddButton("Apresenta Log Alteração"		,{|| LogAltera() },,4,,.F.)
	oBrwXml:AddButton("Rel.Inconsistencia" 			,{|| U_RSTFATAR() },,4,,.F.)
	oBrwXml:AddButton("Danfe"						,{|| U_XVERDANFE(SZ9->Z9_CHAVE) },,3,,.F.)
	oBrwXml:AddButton("Pré-Nota"					,{|| U_VISPRENF() },,2,,.F.)
	oBrwXml:AddButton("Visualizar"					,{|| AxALTERA('SZ9',SZ9->(RECNO()),4) },,2,,.F.)
	oBrwXml:AddButton("Desconhecimento Operação"	,{|| u_Z9XML('1') },,4,,.F.)
	oBrwXml:AddButton("Operação nâo Realizada"		,{|| u_Z9XML('2') },,4,,.F.)
	oBrwXml:AddButton("Confirmação Operação"		,{|| u_Z9XML('3') },,4,,.F.) //oBrwXml:AddButton("Conhecimento Operação"		,{|| u_Z9XML('3') },,4,,.F.) - Alterado conforme chamado - 006870 - Everson Santana 23.02.18

	oBrwXml:Activate()

	VALPAI()
	oBrwXml:UpdateBrowse() //Para atualizar após a exclusão das colunas

	ACTIVATE MSDIALOG oDlg CENTERED

Return

User Function Z9XML(_cEvent)
	Local _Zstat:= ' '
	Local oDlg
	Local cGetMDe:= space(200)
	Local lSaida := .f.

	If _cEvent = '1'
		If MsgYesNo("Deseja realizar o Desconhecimento da Operação ?")
			_Zstat:= '8'
		EndIf
	ElseIf _cEvent = '3'
		If MsgYesNo("Deseja realizar o Confirmação da Operação ?")
			_Zstat:= '1'     // Ticket: 20210819016253 - Valdemir Rabelo 30/08/2021
		EndIf
	ElseIf _cEvent = '2'
		If MsgYesNo("Confirma a Operação nâo Realizada ?")
			_Zstat:= '9'

			While !lSaida

				Define msDialog oDlg Title "Motivo" From 10,10 TO 20,65 Style DS_MODALFRAME

				@ 001,001 Say "Descrição do motivo: " Pixel Of oDlg
				@ 011,003 MsGet cGetMDe valid !empty(cGetMDe) size 200,50 Picture "@!" pixel OF oDlg

				DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION IF(!empty(cGetMDe),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Motivo em Branco","Atenção")) ENABLE OF oDlg

				Activate dialog oDlg centered

			End

		EndIf

	EndIf

	If !(Empty(Alltrim(_Zstat)))
		SZ9->(Reclock("SZ9",.F.))
		SZ9->Z9_STATUS	:= _Zstat
		SZ9->Z9_LOG 	:= Alltrim(SZ9->Z9_LOG)+ CR + "Desconhecimento/Operação"+" Chave: "+SZ9->Z9_CHAVE + " - Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()
		If !(Empty(Alltrim(cGetMDe)))
			SZ9->Z9_DESC	:= Alltrim(cGetMDe)
		EndIf
		SZ9->(MsUnlock())
		SZ9->(DbCommit())
	EndIf

Return

User Function MEXML()

	If SZ9->Z9_ORIGEM = 'NF-E'
	    if u_STXMLVLD(SZ9->Z9_CHAVE, .f.)
		   U_EXECPREN()
		Endif 
	ElseIf SZ9->Z9_ORIGEM = 'NFS-E'
		U_STSF1()
	ElseIf SZ9->Z9_ORIGEM = 'CT-E'
		/*If cEmpAnt=="03" //Somente para manaus pois sp utiliza o frete embarcador
			U_STCTESF1()
		ElseIf cEmpAnt=="01"
			//MsgAlert("Atenção, utilize o módulo de frete embarcador! ")
			U_STCTESF1()
		EndIf*/
		U_STCTESF1()        // Valdemir Rabelo 28/02/2022 - Chamado: 20220209003296
	EndIf

Return()

Static Function VALPAI()

	If !(cOrig==bcOrig) .Or. !(cSta==bcSta) .Or. !(nVal==bnVal) .Or. !(cCgc==bcCgc) .Or. !(dDt==bdDt) .Or. !(dDtFim==bdDtFim) .Or. !(cStx==bcStx) .Or. !(dDt1==bdDt1) .Or. !(cNome==bcNome)
		oProcess := MsNewProcess():New( { || VALPAI1() } , "Filtrando registro" , "Aguarde..." , .F. )
		oProcess:Activate()
	EndIf

Return(.T.)

Static Function VALPAI1()

	Local _cFiltro 		:= ""
	Local aOrig 		:= StrTokArr(AllTrim(cOrig),"/")
	Local _nX := 0
	Private _cOrigem 	:= " "
	Private _cStatus	:= " "
	Private _cValNF		:= " "
	Private _cCgc		:= " "
	Private _cDt		:= " "
	Private _cStx		:= " "
	Private _cDt1		:= " "

	oProcess:SetRegua1(0)
	oProcess:SetRegua1(0)

	_cOrigem 	:= "  ALLTRIM(SZ9->Z9_ORIGEM) $ '" + ALLTRIM(cOrig) + "'  "
	_cStatus	:= Iif(("NF-E" = ALLTRIM(cOrig) .And. cSTA <> "Todos" ),"  .And. ALLTRIM(SZ9->Z9_STATUSA) = '" + ALLTRIM(cSta) + "'  ", " ")
	_cValNF		:= Iif(   nVal<>0 ," .And. SZ9->Z9_VALORNF  = " + cvaltochar(nVal)+"    ", " ")
	_cCgc		:= Iif(  !Empty(Alltrim(cCgc))," .And.  ALLTRIM(SZ9->Z9_CNPJ) = '" + ALLTRIM(cCgc)+"'  "," ")
	_cDt		:= Iif( !Empty(Alltrim(Dtos(dDt))) .AND. !Empty(Alltrim(Dtos(dDtFim))),  " .And.  Dtos(SZ9->Z9_DTEMIS)  >= '" + Dtos(dDt) +"' .And.  Dtos(SZ9->Z9_DTEMIS)  <= '" + Dtos(dDtFim) +"'  "," ")
	_cStx		:= Iif( substr(cStx,1,1) = '1'," .And. ALLTRIM(SZ9->Z9_DOC) = '' ", Iif( substr(cStx,1,1) = '2'," .And.  ALLTRIM(SZ9->Z9_DOC) <> ' ' "," "))
	_cDt1		:= Iif( !Empty(Alltrim(Dtos(dDt1))),  " .And.  Dtos(SZ9->Z9_DTEMIS)  = '" + Dtos(dDt1) +"'  "," ")

	_cFiltro := "@

	If Len(aOrig)>0
		_cFiltro +=  " (
	EndIf
	For _nX:=1 To Len(aOrig)
		_cFiltro += " Z9_ORIGEM='"+aOrig[_nX]+"'
		If !(Len(aOrig)==_nX)
			_cFiltro += " OR
		EndIf
	Next
	If Len(aOrig)>0
		_cFiltro +=  " )
	EndIf

	If "NF-E" = ALLTRIM(cOrig) .And. cSTA <> "Todos"
		_cFiltro += " AND Z9_STATUSA='"+AllTrim(cSta)+"'
	EndIf
	If nVal<>0
		_cFiltro += " AND Z9_VALORNF="+cValToChar(nVal)
	EndIf
	If !Empty(Alltrim(cCgc))
		_cFiltro += " AND Z9_CNPJ='"+AllTrim(cCgc)+"'
	EndIf
	If !Empty(Alltrim(Dtos(dDt))) .AND. !Empty(Alltrim(Dtos(dDtFim)))

		_cFiltro += " AND Z9_DTEMIS BETWEEN '"+DTOS(dDt)+"' AND '"+DTOS(dDtFim)+"'

	EndIf
	If SubStr(cStx,1,1) = '1'
		_cFiltro += " AND Z9_DOC=' '
	ElseIf SubStr(cStx,1,1) = '2'
		_cFiltro += " AND Z9_DOC<>' '
	EndIf

	// Removido conforme solicitação feita via Ticket: 20210430007037
	//_cFiltro += " AND Upper(Trim(Z9_STATUSA)) <> 'NF CANCELADA' "      // Valdemir Rabelo Ticket: 20210420006345 - 26/04/2021

	If !Empty(dDt1)
		_cFiltro += " AND Z9_CHAVE=(
		_cFiltro += " SELECT F1_CHVNFE
		_cFiltro += " FROM "+RetSqlName("SF1")+" F1
		_cFiltro += " WHERE F1.D_E_L_E_T_=' ' AND F1.F1_FILIAL=Z9_FILIAL AND F1.F1_CHVNFE=Z9_CHAVE
		_cFiltro += " AND F1.F1_DTDIGIT='"+DTOS(dDt1)+"'
		_cFiltro += ")
	EndIf

	If !Empty(cNome)
		_cFiltro += " AND Z9_NFOR LIKE ('%"+Alltrim(UPPER(cNome))+"%')
	EndIf

	oBrwXml:CleanFilter()
	oBrwXml:CleanExFilter()
	oBrwXml:SetFilterDefault(_cFiltro)

	oBrwXml:Refresh()

	_cOrigem 	:= " "
	_cStatus	:= " "
	_cValNF		:= " "
	_cCgc		:= " "
	_cDt		:= " "
	_cStx		:= " "

	bcOrig:= cOrig
	bcSta := cSta
	bnVal := nVal
	bcCgc := cCgc
	bdDt  := dDt
	bcStx := cStx
	bdDt1 := dDt1
	bcNome := cNome

Return

/*/{Protheus.doc} CONSXML
description
Rotina para apresentar schema
@type function
@version  
@author Valdemir Jose
@since 04/03/2021
@return return_type, return_description
/*/
Static Function CONSXML()
	Local cArquivo := 'NF_'+SZ9->Z9_CHAVE+".XML"
	Local cPath    := "c:\TEMP\"
	Local cShema   := SZ9->Z9_XML

	if Empty(cShema)
		FWMsgRun(,{|| sleep(3000)},"Informação!","Não existem schema a ser apresentada")
		Return
	Endif

	if file(cPath+cArquivo)
	   FErase(cPath+cArquivo)
	endif 

	Memowrite(cPath+cArquivo, cShema)

	if File(cPath+cArquivo)
		ShellExecute("OPEN", cPath+cArquivo, "", "", 1)
	endif    

Return 

/*/{Protheus.doc} LogAltera
description
Rotina que apresenta o log de alteração
@type function
@version  
@author Valdemir Jose
@since 31/05/2021
@return return_type, return_description
/*/
Static Function LogAltera()
	Local _aParamBox := {}
	lOCAL _aRet      := {}
	Local _cChave    := SZ9->Z9_CHAVE 
	Local _cProduto  := CriaVar("B1_COD")
	Local aPar       := {}

	aadd(_aParamBox, {1, "Dt. Inicial", dDatabase, "@D", "", "", "", 50, .T.})
	aadd(_aParamBox, {1, "Dt. Final"  , dDatabase, "@D", "", "", "", 50, .T.})
	aadd(_aParamBox, {1, "Chave XML"  , _cChave  , "@!", "", "", "", 200, .F.})
	aadd(_aParamBox, {1, "Produto"    , _cProduto, "@!", "", "SB1", "", 50, .F.})
	aadd(_aParamBox, {1, "Serie+Nota" , Space(12), "@!", "", "", "", 50, .F.})

	If !ParamBox(_aParamBox,"Filtro Log",@_aRet,,,.T.,,580)
	   Return 
	Endif 

	aPar       := {MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04, MV_PAR05}
	
	U_STCFG01A("","Z9", aPar)

	// ZH1

Return

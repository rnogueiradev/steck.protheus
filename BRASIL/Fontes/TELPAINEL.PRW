#include 'Protheus.ch'
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#Define CR chr(13)+ chr(10)

/*====================================================================================\
|Programa  | TELPAINEL        | Autor | GIOVANI.ZAGO             | Data | 07/07/2017  |
|=====================================================================================|
|Descrição | TELPAINEL       				                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | TELPAINEL          	                                                  |
|=====================================================================================|
|Uso       | Especifico  		                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function TELPAINEL()
	*----------------------------------*
	Local oBrowse
	Private _UserMvc := GetMv('ST_TELPAI',,'000000/000645')
	
	
	DbSelectArea("Z1C")
	DbSelectArea("Z1D")
	Z1C->(DbSetOrder(1))
	If !(__cUserId $ _UserMvc)
		Z1C->(dbSetFilter({|| Z1C->Z1C_COD = __cUserId .Or.   Z1C->Z1C_SUPER = __cUserId   },' Z1C->Z1C_COD = __cUserId .Or.   Z1C->Z1C_SUPER = __cUserId   '))
	EndIf
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z1C")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("TELPAINEL")				// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("Usuarios de Celular")   	// Descrição do browse
	
	oBrowse:Activate()
	
Return(Nil)



Static Function MenuDef()
	Local aRotina := {}
	Private _UserMvc := GetMv('ST_TELPAI',,'000000/000645')
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE "Analisar"    ACTION "u_xTELPAINEL(aLLTRIM(Z1C->Z1C_NUMERO),aLLTRIM(Z1C->Z1C_NOME))" OPERATION 3 ACCESS 0 //"Alterar"
	If __cuserid $ _UserMvc
		ADD OPTION aRotina TITLE "Consolidado"    ACTION "u_xTELPAINEL('000000000',aLLTRIM(Z1C->Z1C_NOME))" OPERATION 3 ACCESS 0 //"Alterar"
		ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.TELPAINEL" OPERATION 4 ACCESS 0 //"Alterar"
		ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.TELPAINEL" OPERATION 5 ACCESS 0 //"Excluir"
		ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.TELPAINEL" OPERATION 3 ACCESS 0 //"Incluir"
		ADD OPTION aRotina TITLE "Grafico"    ACTION "u_grafico()" OPERATION 3 ACCESS 0 //"Incluir"
		ADD OPTION aRotina TITLE "Importar"    ACTION "u_STCEPIMPORT()" OPERATION 3 ACCESS 0 //"Incluir"
	EndIf
	
	
Return aRotina







User Function xTELPAINEL(_cNumber1,_cNome1)
	Local aCoors := FWGetDialogSize( oMainWnd )
	Local oLayerTabFrete, oLayerNeg
	Local oDialog061
	
	Local oOk           := LoadBitmap( GetResources(), "LBOK" )
	Local oNo           := LoadBitmap( GetResources(), "LBNO" )
	Private oBrwCabec, oBrwXml
	Private cOrig := '4-TODOS'
	Private oNFE,oCTE,oNFSE,oLbx
	Private lNFE:=lCTE:=lNFSE := .t.
	Private aLbx := {}
	Private _cNumber := _cNumber1
	Private _cNome := _cNome1
	If _cNumber = '000000000'
		_cNome :="Geral"
	EndIf
	Z1C->(dbClearFilter())
	Z1C->(dbGoTop())
	
	u_TELLayer()
Return





User Function TELLayer()
	Private oDlg ,oBrwXml,oLayer01,oNFE,oSay1,oSTA,oSay2,oCgc,oVal,oDt,oStx,oLayer02,oT01,oSay3,oT02,oRf
	Private oLayer 	:= FWLayer():new()
	Private aCoors 	:= FWGetDialogSize( oMainWnd )
	Private cOrig 	:= '4-TODOS'
	Private cCgc  	:= Space(14)
	Private cVal  	:= Space(11)
	Private cStx 	:= "Todos"
	Private cSTA 	:= "Todos"
	Private dDt  	:= CTOD("  /  /  ")
	Private cT01	:= "0"
	Private cT02	:= "00:00"
	Private cRf 	:= "Todos"
	Private _cFilter:= ' '
	
	Define MsDialog oDlg Title "Painel Telefonia - "+Upper(_cNome) From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel
	oLayer:init(oDlg,.T.)//Cria as colunas do Layer
	oLayer:addCollumn('Col01',010,.F.)
	oLayer:addCollumn('Col02',090,.F.)  //Adiciona Janelas as colunas
	oLayer:addWindow('Col01','C1_Win01','Filtros',60,.T.,.F.,{||   }, ,{||   })
	oLayer:addWindow('Col01','C1_Win02','TOTAIS',40,.T.,.T.,{||   }, ,{||   })
	oLayer:addWindow('Col02','C2_Win01','Documentos',100,.T.,.F.,{||   },,{||  })
	//oLayer:getWinPanel('Col02','C2_Win01')                             //Coloca o botão de split na coluna
	//oLayer:setColSplit('Col01',CONTROL_ALIGN_LEFT,,{|| Alert("Split Col01!") })
	
	oLayer02:= oLayer:GetWinPanel('Col01', 'C1_Win02' )
	
	
	@ 001, 001 SAY oSay3 PROMPT "Duração:"  	SIZE 037, 010 OF oLayer02 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 015, 000 MSGET oT01 VAR cT01 Size 55,10 PIXEL OF oLayer02 PICTURE '@!'     when .F.
	
	@ 026, 000 MSGET oT02 VAR cT02 Size 55,10 PIXEL OF oLayer02 PICTURE '@!'     when .F.
	
	
	oLayer01:= oLayer:GetWinPanel('Col01', 'C1_Win01' )
	
	@ 001, 001 SAY oSay1 PROMPT "Filtro:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 010, 000 COMBOBOX oNFE VAR cOrig ITEMS {"1-FDS","2-NORMAL","3-FORA DO HORARIO","4-TODOS"} Size 55,10 PIXEL OF oLayer01  Valid VALPAI()
	
	@ 023, 001 SAY oSay2 PROMPT "Mes:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 032, 000 COMBOBOX oSTA VAR cSta ITEMS {"Todos" ,;
		"01-Janeiro"	,"02-Fevereiro",;
		"03-Março"		,"04-Abril",;
		"05-Maio"		,"06-Junho",;
		"07-Julho"		,"08-Agosto",;
		"09-Setembro"	,"10-Outubro",;
		"11-Novembro"	,"12-Dezembro",;
		} Size 55,10 PIXEL OF oLayer01  Valid VALPAI()
	
	@ 044, 001 SAY oSay2 PROMPT "Ano:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 053, 000 COMBOBOX oSTx VAR cStx ITEMS {"Todos","2018","2017","2016","2015"} Size 55,10 PIXEL OF oLayer01  Valid VALPAI()
	
	
	//	@ 044, 001 SAY oSay1 PROMPT "Cnpj:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	//	@ 053, 000 MSGET oCgc VAR cCgc Size 55,10 PIXEL OF oLayer01 PICTURE '@R 99.999.999/9999-99'    Valid VALPAI()
	
	@ 065, 001 SAY oSay1 PROMPT "Numero:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 074, 000 MSGET oVal VAR cVal Size 55,10 PIXEL OF oLayer01 PICTURE '@R 99999999999'    Valid VALPAI()
	
	@ 086, 001 SAY oSay1 PROMPT "Data:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 095, 000 MSGET oDt VAR dDt Size 55,10 PIXEL OF oLayer01 PICTURE '99/99/99'    Valid VALPAI()
	
	@ 107, 001 SAY oSay2 PROMPT "Rec./Efe.:"  	SIZE 037, 007 OF oLayer01 COLORS RGB(0, 74, 119), 16777215 PIXEL
	@ 116, 000 COMBOBOX oRf VAR cRf  ITEMS {"Todos","Recebidas","Efetuadas"} Size 55,10 PIXEL OF oLayer01  Valid VALPAI()
	
	
	
	
	oLayerBrw := oLayer:GetColPanel('Col02')
	oBrwXml := FWMBrowse():New()
	oBrwXml:SetAlias('Z1D')
	oBrwXml:SetOwner(oLayerBrw)
	oBrwXml:SetDescription("Chamadas "+Upper(_cNome))
	oBrwXml:DisableDetails()
	oBrwXml:SetMenuDef(" ")
	oBrwXml:ForceQuitButton(.T.)
	oBrwXml:SetProfileID("1")
	oBrwXml:SetAmbiente(.F.)
	oBrwXml:SetWalkthru(.F.)
	
	oBrwXml:AddLegend( " AllTrim(Z1D->Z1D_DIA)  $ 'SABADO/DOMINGO' "	, "BLACK"		, "SABADO/DOMINGO" )
	oBrwXml:AddLegend( " !(AllTrim(Z1D->Z1D_DIA)  $ 'SABADO/DOMINGO')  .And.  Substr(AllTrim(Z1D->Z1D_HORA),1,2) $ '08/09/10/11/12/13/14/15/16/17'  "	, "GREEN"		, "HORARIO DE TRABALHO" )
	oBrwXml:AddLegend( " !(AllTrim(Z1D->Z1D_DIA)  $ 'SABADO/DOMINGO')  .And.  !(Substr(AllTrim(Z1D->Z1D_HORA),1,2) $ '08/09/10/11/12/13/14/15/16/17') "		, "YELLOW"		, "FORA DO HORARIO DE TRABALHO" )
	
	
	/*
	oBrwXml:AddButton("Gerar pre-nota" 				,{|| u_MEXML() },,4,,.F.)
	oBrwXml:AddButton("Gerar com arquivo"			,{|| U_EXECPREA() },,3,,.F.)
	oBrwXml:AddButton("Exportar XML"				,{|| U_EXPORTXM() },,2,,.F.)
	oBrwXml:AddButton("Rel.Inconsistencia" 			,{|| U_RSTFATAR() },,4,,.F.)
	oBrwXml:AddButton("Danfe"						,{|| U_XVERDANFE(SZ9->Z9_CHAVE) },,3,,.F.)
	oBrwXml:AddButton("Pré-Nota"					,{|| U_VISPRENF() },,2,,.F.)
	oBrwXml:AddButton("Visualizar"					,{|| AxALTERA() },,2,,.F.)
	oBrwXml:AddButton("Desconhecimento Operação"	,{|| u_Z9XML('1') },,4,,.F.)
	oBrwXml:AddButton("Operação nâo Realizada"		,{|| u_Z9XML('2') },,4,,.F.)
	oBrwXml:AddButton("Conhecimento Operação"		,{|| u_Z9XML('3') },,4,,.F.)
	*/
	
	oBrwXml:Activate()
	
	VALPAI()
	
	oBrwXml:UpdateBrowse() //Para atualizar após a exclusão das colunas
	
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return



Static Function VALPAI()
	Private _cOrigem 	:= " "
	Private _cStatus	:= " "
	Private _cValNF		:= " "
	Private _cCgc		:= " "
	Private _cDt		:= " "
	Private _cStx		:= " "
	Private _cFqu		:= " "
	
	If substr(cOrig,1,1)= '1'
		_cOrigem 	:= " AllTrim(Z1D->Z1D_DIA)  $ 'SABADO/DOMINGO' .And. "
		_cFqu		:= "  trim(Z1D.Z1D_DIA)  in ('SABADO','DOMINGO') And   "
	ElseIf substr(cOrig,1,1)= '2'
		_cOrigem 	:= " !(AllTrim(Z1D->Z1D_DIA)  $ 'SABADO/DOMINGO')  .And.  Substr(AllTrim(Z1D->Z1D_HORA),1,2) $ '08/09/10/11/12/13/14/15/16/17' .And. "
		_cFqu		:= " ( trim(Z1D.Z1D_DIA) not in ('SABADO','DOMINGO') ) And    Substr(trim(Z1D.Z1D_HORA),1,2) in ('08','09','10','11','12','13','14','15','16','17') And "
	ElseIf substr(cOrig,1,1)= '3'
		_cOrigem 	:= " !(AllTrim(Z1D->Z1D_DIA)  $ 'SABADO/DOMINGO')  .And.  !(Substr(AllTrim(Z1D->Z1D_HORA),1,2) $ '08/09/10/11/12/13/14/15/16/17') .And.  "
		_cFqu		:= "  trim(Z1D.Z1D_DIA)  not in ('SABADO','DOMINGO') And     Substr(trim(Z1D.Z1D_HORA),1,2) not in ('08','09','10','11','12','13','14','15','16','17') And "
	EndIf
	
	
	If Upper(Alltrim(cSTA)) <> 'TODOS' .And. Empty(Alltrim(DTOS(dDt)))
		_cStatus	:= " Substr(AllTrim(Z1D->Z1D_REF),1,2) =  '"+Substr(cSTA,1,2)+"' .And. "
		_cFqu		+= " Substr(trim(Z1D.Z1D_REF),1,2) =  '"+Substr(cSTA,1,2)+"'  And "
	EndIf
	
	If Upper(Alltrim(cStx)) <> 'TODOS' .And. Empty(Alltrim(DTOS(dDt)))
		_cStx	:= " Substr(AllTrim(Z1D->Z1D_REF),4,4) =  '"+cStx+"' .And. "
		_cFqu		+= " Substr(TRIM(Z1D.Z1D_REF),4,4) =  '"+cStx+"'  And  "
	EndIf
	
	If !Empty(Alltrim(cVal))
		_cValNF	:= "   (ALLTRIM(Z1D->Z1D_NUM) = '"+cVal+"' .Or. ALLTRIM(Z1D->Z1D_PARA) = '"+cVal+"')    .And."
		_cFqu		+= " (TRIM(Z1D.Z1D_NUM) = '"+cVal+"'  Or  TRIM(Z1D.Z1D_PARA) = '"+cVal+"')     And "
	EndIf
	
	_cDt		:= Iif( !Empty(Alltrim(DTOS(dDt))),  "   Z1D->Z1D_DATA  = '" + DTOs(dDt)+"' .And.  "," ")
	
	_cFqu		+= Iif( !Empty(Alltrim(DTOS(dDt))),  "   Z1D.Z1D_DATA  = '" + DTOs(dDt)+"'  And   "," ")
	
	
	If ALLTRIM(_cNumber) = '000000000'
		_cNum		:= "   (ALLTRIM(Z1D->Z1D_NUM) <> ' '
		_cFqu		+= "   (TRIM(Z1D.Z1D_NUM) <> ' '
	ElseIf substr(cRf,1,1)= 'T'
		_cNum:= "   (ALLTRIM(Z1D->Z1D_NUM) = '" + ALLTRIM(_cNumber) + "'  .Or. ALLTRIM(Z1D->Z1D_PARA) = '"+ ALLTRIM(_cNumber) +"'   ) "
		_cFqu		+= "   (TRIM(Z1D.Z1D_NUM) = '" + ALLTRIM(_cNumber) + "'   Or   TRIM(Z1D.Z1D_PARA) = '"+ ALLTRIM(_cNumber) +"'   ) "
	ElseIf substr(cRf,1,1)= 'E'
		_cNum:= "   (ALLTRIM(Z1D->Z1D_NUM) = '" + ALLTRIM(_cNumber) + "'  .And. ALLTRIM(Z1D->Z1D_PARA) <> '"+ ALLTRIM(_cNumber) +"'   ) "
		_cFqu		+= "   (TRIM(Z1D.Z1D_NUM) = '" + ALLTRIM(_cNumber) + "'   And   TRIM(Z1D.Z1D_PARA) <> '"+ ALLTRIM(_cNumber) +"'   ) "
	ElseIf substr(cRf,1,1)= 'R'
		_cNum:= "   (ALLTRIM(Z1D->Z1D_NUM) <> '" + ALLTRIM(_cNumber) + "'  .And. ALLTRIM(Z1D->Z1D_PARA) = '"+ ALLTRIM(_cNumber) +"'   ) "
		_cFqu		+= "   (TRIM(Z1D.Z1D_NUM) <> '" + ALLTRIM(_cNumber) + "'   And   TRIM(Z1D.Z1D_PARA) = '"+ ALLTRIM(_cNumber) +"'   ) "
	EndIf
	
	
	_cFilter:= _cOrigem+ _cStatus+_cStx+_cValNF+_cDt + _cNum
	
	oBrwXml:SetFilterDefault(_cFilter)
	_nT2:= STSUM(upper(_cFqu))
	
	
	_nTi:= int(_nT2/60)
	_nTi:=  _nTi * 60
	_nTi:=  _nT2 - _nTi
	If _nTi < 0
		_nTi:= 0
	EndIf
	cT02:= Space(6)+padl(cValToChar(int(_nT2/60)),2,'0')+":"+padl(cValToChar( _nTi),2,'0')+" Hrs."
	cT01:= Space(6)+cValToChar(_nT2)+" Minutos"
	oBrwXml:Refresh()
	
	oDlg:Refresh()
	_cOrigem 	:= " "
	_cStatus	:= " "
	_cValNF		:= " "
	_cCgc		:= " "
	_cDt		:= " "
	_cStx		:= " "
	
Return(.T.)


//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Administrator

@since 07/07/2017
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	
	
	Local oStr1:= FWFormStruct(2, 'Z1C')
	oView := FWFormView():New()
	
	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:CreateHorizontalBox( 'BOXFORM1', 100)
	oView:SetOwnerView('FORM1','BOXFORM1')
	
Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Administrator

@since 07/07/2017
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	
	
	Local oStr1:= FWFormStruct(1,'Z1C')
	oModel := MPFormModel():New('ModelName')
	oModel:addFields('FIELD1',,oStr1)
	oModel:SetPrimaryKey({ 'Z1C_FILIAL', 'Z1C_COD' })
	
	
	
Return oModel

Static Function STSUM(_cFqu)
	Local _nRex			:=0
	Local cQuery    	:= ' '
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private cAliasLif   := 'STSUM'+cHora+ cMinutos+cSegundos
	
	_cFqu:= StrTran(_cFqu,'.AND.','AND')
	_cFqu:= StrTran(_cFqu,'.OR.','OR')
	_cFqu:= StrTran(_cFqu,'ALLTRIM','TRIM')
	_cFqu:= StrTran(_cFqu,'->','.')
	
	cQuery := " SELECT SUM(Z1D_VALOR) AS TOTAL FROM Z1D010 Z1D WHERE Z1D.D_E_L_E_T_ = ' ' AND   "
	cQuery += Alltrim(_cFqu)
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		
		_nRex 	 := 	(cAliasLif)->TOTAL
	EndIf
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
Return(_nRex)



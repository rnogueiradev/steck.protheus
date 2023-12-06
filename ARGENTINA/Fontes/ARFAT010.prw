#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | ARFAT010        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA REALIZPR SEPARAÇÃO E EMBARQUE                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function ARFAT010()

	Local oBrowse1
	Local _cQuery2 		:= ""
	Local _cPerg 		:= "ARFAT010"
	Private aRotina 	:= MenuDef()
	Private _dMVPAR01	:= Date()
	Private _dMVPAR02	:= Date()

	_cQuery2 := " UPDATE "+RetSqlName("SF2")+" F2
	_cQuery2 += " SET F2_XSTATUS='0'
	_cQuery2 += " WHERE F2.D_E_L_E_T_=' ' AND F2_XSTATUS=' ' AND Substr(F2_SERIE,1,1)='R'

	TCSqlExec(_cQuery2)

	DbSelectArea("SF2")
	SF2->(DbSetOrder(1))

	u_ArPutSx1(_cPerg, "01","Data de?" 	,"mv_par01","mv_ch1","D",08,0,"G")
	u_ArPutSx1(_cPerg, "02","Data ate?"	,"mv_par02","mv_ch2","D",08,0,"G")

	Pergunte(_cPerg,.T.)

	_dMVPAR01 := MV_PAR01
	_dMVPAR02 := MV_PAR02

	DbSelectArea("CB1")
	CB1->(DbSetOrder(2))
	CB1->(DbGoTop())
	If CB1->(DbSeek(xFilial("CB1")+__cUserId))
		If __cUserId $ SuperGetMv("ST_FAT0001",.F.,"000000")
			// Ticket 20210105000170 - informe de embalador de pedidos - Eduado Pereira Sigamat - 16.06.2021 - Inicio
			If __cUserId $ "001086/001125"
				SF2->(dbSetFilter({|| Substring(SF2->F2_SERIE,1,1) = 'R' .And. SF2->F2_XSTATUS == "2" .And. DTOS(SF2->F2_EMISSAO)>=DTOS(_dMVPAR01) .And. DTOS(SF2->F2_EMISSAO)<=DTOS(_dMVPAR02) .And. SF2->F2_XCODOPE=CB1->CB1_CODOPE }," Substring(SF2->F2_SERIE,1,1) = 'R' .And. SF2->F2_XSTATUS == '2' .And. DTOS(SF2->F2_EMISSAO)>=DTOS(_dMVPAR01) .And. DTOS(SF2->F2_EMISSAO)<=DTOS(_dMVPAR02) "))
			Else
			// Ticket 20210105000170 - informe de embalador de pedidos - Eduado Pereira Sigamat - 16.06.2021 - Fim
				SF2->(dbSetFilter({|| Substring(SF2->F2_SERIE,1,1) = 'R' .And. !Empty(SF2->F2_XSTATUS) .And. DTOS(SF2->F2_EMISSAO)>=DTOS(_dMVPAR01) .And. DTOS(SF2->F2_EMISSAO)<=DTOS(_dMVPAR02) .And. SF2->F2_XCODOPE=CB1->CB1_CODOPE }," Substring(SF2->F2_SERIE,1,1) = 'R' .And. !Empty(SF2->F2_XSTATUS) .And. DTOS(SF2->F2_EMISSAO)>=DTOS(_dMVPAR01) .And. DTOS(SF2->F2_EMISSAO)<=DTOS(_dMVPAR02) "))
			EndIf
		ElseIf __cUserId $ SuperGetMv("ST_FAT0002",.F.,"000000")
			//SF2->(dbSetFilter({|| SF2->F2_SERIE = 'R' .And. SF2->F2_XSTATUS = '2' .And. DTOS(SF2->F2_EMISSAO)>=DTOS(_dMVPAR01) .And. DTOS(SF2->F2_EMISSAO)<=DTOS(_dMVPAR02) .And. SF2->F2_XCODOPE=CB1->CB1_CODOPE }," SF2->F2_SERIE = 'R' .And. SF2->F2_XSTATUS = '2' .And. DTOS(SF2->F2_EMISSAO)>=DTOS(_dMVPAR01) .And. DTOS(SF2->F2_EMISSAO)<=DTOS(_dMVPAR02) .And. SF2->F2_XCODOPE=CB1->CB1_CODOPE "))
			SF2->(dbSetFilter({|| Substring(SF2->F2_SERIE,1,1) = 'R' .And. SF2->F2_XSTATUS = '2' .And. DTOS(SF2->F2_EMISSAO)>=DTOS(_dMVPAR01) .And. DTOS(SF2->F2_EMISSAO)<=DTOS(_dMVPAR02) }," Substring(SF2->F2_SERIE,1,1) = 'R' .And. SF2->F2_XSTATUS = '2' .And. DTOS(SF2->F2_EMISSAO)>=DTOS(_dMVPAR01) .And. DTOS(SF2->F2_EMISSAO)<=DTOS(_dMVPAR02)  "))
		Else
			SF2->(dbSetFilter({|| Substring(SF2->F2_SERIE,1,1) = 'R' .And. SF2->F2_XSTATUS = '1' .And. DTOS(SF2->F2_EMISSAO)>=DTOS(_dMVPAR01) .And. DTOS(SF2->F2_EMISSAO)<=DTOS(_dMVPAR02) .And. SF2->F2_XCODOPE=CB1->CB1_CODOPE }," Substring(SF2->F2_SERIE,1,1) = 'R' .And. SF2->F2_XSTATUS = '1' .And. DTOS(SF2->F2_EMISSAO)>=DTOS(_dMVPAR01) .And. DTOS(SF2->F2_EMISSAO)<=DTOS(_dMVPAR02) .And. SF2->F2_XCODOPE=CB1->CB1_CODOPE "))
		EndIf
	Else
		MsgAlert("Código de operador no registrado para este usuario, verifique!")
		Return
	EndIf

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Control de separación")
	oBrowse1:SetAlias("SF2")
	oBrowse1:AddLegend("SF2->F2_XSTATUS=='0'","WHITE"	,"Lib. para la separación")
	oBrowse1:AddLegend("SF2->F2_XSTATUS=='1'","BLUE"	,"Separando")
	oBrowse1:AddLegend("SF2->F2_XSTATUS=='2'","GREEN"	,"Separación terminada")
	oBrowse1:AddLegend("SF2->F2_XSTATUS=='3'","BLACK"	,"Embalaje terminado")
	oBrowse1:SetUseCursor(.F.)
	oBrowse1:Activate()

Return

/*/Protheus.doc MenuDef
@name MenuDef
@desc monta menu principal
@author Renato Nogueira
@since 09/01/2017
/*/

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  				ACTION "AxPesqui"        	OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "VisualiZPr" 				ACTION "VIEWDEF.ARFAT010" 	OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Aloc. separador"			ACTION "U_ARFAT011" 		OPERATION 8  ACCESS 0
	ADD OPTION aRotina TITLE "Finalizar separação"		ACTION "U_ARFAT012" 		OPERATION 9  ACCESS 0
	ADD OPTION aRotina TITLE "Embalar"					ACTION "U_ARFAT013" 		OPERATION 10  ACCESS 0
	ADD OPTION aRotina TITLE "Histórico"				ACTION "U_ARFAT015" 		OPERATION 11  ACCESS 0
	ADD OPTION aRotina TITLE "Imp. Pick List"			ACTION "u_MyMATR265" 		OPERATION 12  ACCESS 0
	ADD OPTION aRotina TITLE "Etiqueta Cliente"			ACTION "u_ARSTETQ1" 		OPERATION 12  ACCESS 0
	ADD OPTION aRotina TITLE "Etiq. Prod. Grande"		ACTION "u_ARSTETQ3" 		OPERATION 12  ACCESS 0

	If __cUserId $ SuperGetMv("ST_FAT0001",.F.,"000000")
		ADD OPTION aRotina TITLE "Deshacer separación"		ACTION "u_ARFAT016" 		OPERATION 12  ACCESS 0
	EndIf

Return aRotina

/*/Protheus.doc ModelDef
@name ModelDef
@desc montar model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local oModel
	Local oStr1 := FWFormStruct(1,'SF2')

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})
	oModel:SetDescription('Main')
	oModel:addFields('FIELD1',,oStr1,)
	oModel:SetPrimaryKey({})
	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')

Return oModel

/*/Protheus.doc ViewDef
@name ViewDef
@desc montar view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView	 := Nil
	Local oStr1	 := FWFormStruct(2, 'SF2')
	Local oModel := FWLoadModel("ARFAT010")

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:CreateHorizontalBox( 'BOXFORM1', 100)
	oView:SetOwnerView('FORM1','BOXFORM1')
	oView:EnableTitleView('FORM1','Cabeçalho')
	oView:EnableControlBar(.T.)
	oView:SetCloseOnOk({|| .T.})

Return oView

/*/Protheus.doc VLDALT
@name VLDALT
@desc validar alteração do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet	:= .T.
	//Local nOp	:= oModel:GetOperation()

Return _lRet

/*/Protheus.doc TUDOOK
@name TUDOOK
@desc validar tudo ok do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet	:= .T.

Return _lRet

/*/Protheus.doc VLDLIN
@name VLDLIN
@desc validar troca de linha do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDLIN(oModel,nLine)

	Local _lRet	:= .T.

Return _lRet

/*/Protheus.doc GrvTOK
@name GrvTOK
@desc realiZP gravação dos dados
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GrvTOK( oModel )

	Local lGrv	:= .T.
	//Local nOp	:= oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv

/*/Protheus.doc ARFAT011
@name ARFAT011
@desc alocar operador
@author Renato Nogueira
@since 12/09/2016
/*/

User Function ARFAT011()

	Local aParams 		:= {}
	Local cCodOpe 		:= Space(TamSX3("CB1_CODOPE")[1])
	Local aRet    		:= {}
	Local _cMV_PAR01	:= MV_PAR01

	If !(SF2->F2_XSTATUS == "0")
		MsgAlert("Não é possível alocar o operador, verifique o status da nota!")
		Return
	EndIf

	aAdd(aParams,{ 1, "Operador", cCodOpe, "@!", 'ExistCpo("CB1")', "CB1", "", 0, .F. })

	If !ParamBox(aParams,"Alocação",@aRet,,,,,,,,.F.)
		Return
	EndIf

	cCodOpe	:= aRet[1]

	MV_PAR01 := _cMV_PAR01

	//Gerar ordem de separação
	DbSelectArea("CB7")

	DbSelectArea("SD2")
	SD2->(DbSetOrder(3)) // D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
	SD2->(DbGoTop())
	If !SD2->(DbSeek(SF2->(F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA)))
		MsgAlert("Atenção, não foi encontrado nenhum item para essa nota, entre em contato com o TI")
		Return
	EndIf

	Begin Transaction
		cOrdSep := GetSXENum( "CB7", "CB7_ORDSEP" )
		CB7->(RecLock("CB7",.T.))
		CB7->CB7_FILIAL := xFilial("CB7")
		CB7->CB7_ORDSEP := cOrdSep
		//CB7->CB7_XAUTSE := "1"
		CB7->CB7_NOTA	:= SF2->F2_DOC
		CB7->CB7_SERIE	:= SF2->F2_SERIE
		CB7->CB7_PEDIDO := SD2->D2_PEDIDO
		CB7->CB7_CLIENT := SF2->F2_CLIENTE
		CB7->CB7_LOJA   := SF2->F2_LOJA
		CB7->CB7_COND   := SF2->F2_COND
		CB7->CB7_LOJENT := SF2->F2_LOJA
		CB7->CB7_TRANSP := SF2->F2_TRANSP
		CB7->CB7_ORIGEM := "1"
		CB7->CB7_TIPEXP := "00*02*06*"
		//CB7->CB7_XPRIAN := SC5->C5_XPRIORI
		CB7->CB7_LOCAL  	:= SD2->D2_LOCAL
		CB7->CB7_DTEMIS 	:= dDataBase
		CB7->CB7_HREMIS 	:= Time()
		CB7->CB7_STATUS 	:= " "
		CB7->CB7_CODOPE 	:= ""
		CB7->CB7_PRIORI 	:= "1"
		//CB7->CB7_XSEP		:= "2"
		CB7->( MsUnlock() )
		While SD2->( !Eof() ) .And. SD2->(D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA) == SF2->(F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA)
			CB8->(RecLock("CB8",.T.))
			CB8->CB8_FILIAL := xFilial("CB8")
			CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
			CB8->CB8_PROD   := SD2->D2_COD
			CB8->CB8_LOCAL  := SD2->D2_LOCAL
			CB8->CB8_ITEM   := SD2->D2_ITEM
			CB8->CB8_PEDIDO := SD2->D2_PEDIDO
			CB8->CB8_SEQUEN := SD2->D2_SEQUEN
			CB8->CB8_QTDORI := SD2->D2_QUANT
			CB8->CB8_SALDOS := SD2->D2_QUANT
			CB8->CB8_SALDOE := SD2->D2_QUANT
			CB8->CB8_LCALIZ := ""
			CB8->CB8_NUMSER := ""
			CB8->CB8_LOTECT := SD2->D2_LOTECTL
			CB8->CB8_NUMLOT := SD2->D2_NUMLOTE
			CB8->CB8_CFLOTE := "1"
			CB8->( MsUnLock() )
			// Tabela CB9
			CB9->(RecLock("CB9",.T.))
			CB9->CB9_FILIAL := xFilial("CB9")
			CB9->CB9_ORDSEP := CB7->CB7_ORDSEP
			CB9->CB9_CODETI := ""
			CB9->CB9_PROD   := CB8->CB8_PROD
			CB9->CB9_CODSEP := CB7->CB7_CODOPE
			CB9->CB9_ITESEP := CB8->CB8_ITEM
			CB9->CB9_SEQUEN := CB8->CB8_SEQUEN
			CB9->CB9_LOCAL  := CB8->CB8_LOCAL
			CB9->CB9_LCALIZ := ""
			CB9->CB9_LOTECT := ""
			CB9->CB9_NUMLOT := ""
			CB9->CB9_NUMSER := ""
			CB9->CB9_LOTSUG := CB8->CB8_LOTECT
			CB9->CB9_SLOTSU := CB8->CB8_NUMLOT
			CB9->CB9_NSERSU := CB8->CB8_NUMSER
			CB9->CB9_PEDIDO := CB8->CB8_PEDIDO
			CB9->CB9_QTESEP := CB8->CB8_QTDORI
			CB9->CB9_STATUS := "1"
			CB9->( MsUnlock() )
			SD2->( DbSkip() )
		EndDo
		SF2->(RecLock("SF2",.F.))
		SF2->F2_XCODOPE := cCodOpe
		SF2->F2_XSTATUS := "1"
		SF2->F2_XORDSEP := cOrdSep
		SF2->( MsUnLock() )
		u_ARFAT014(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_XORDSEP,"1")
		CB7->( ConfirmSX8() )
	End Transaction

	MsgAlert("Operador alocado com sucesso, obrigado!")

Return

/*/Protheus.doc ARFAT012
@name ARFAT012
@desc finaliZPr separação
@author Renato Nogueira
@since 12/09/2016
/*/

User Function ARFAT012()

	If !(SF2->F2_XSTATUS == "1")
		MsgAlert("Não é possível finaliZPr a separação, verifique o status da nota!")
		Return
	EndIf

	If !MsgYesNo("Confirma finaliZPção da separação da nota " + AllTrim(SF2->F2_DOC) + "?")
		Return
	EndIf

	Begin Transaction
		SF2->(RecLock("SF2",.F.))
		SF2->F2_XSTATUS := "2"
		SF2->( MsUnLock() )
		U_ARFAT014(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_XORDSEP,"2")
		DbSelectArea("CB7")
		CB7->(DbSetOrder(1))
		CB7->(DbGoTop())
		If CB7->(DbSeek(SF2->(F2_FILIAL + F2_XORDSEP)))
			CB7->(RecLock("CB7",.F.))
			CB7->CB7_STATUS := "2"
			CB7->(MsUnLock())
		EndIf
		DbSelectArea("CB8")
		CB8->(DbSetOrder(1))
		CB8->(DbGoTop())
		CB8->(DbSeek(CB7->(CB7_FILIAL + CB7_ORDSEP)))
		While CB8->( !Eof() ) .And. CB8->(CB8_FILIAL + CB8_ORDSEP) == CB7->(CB7_FILIAL + CB7_ORDSEP)
			CB8->(RecLock("CB8",.F.))
			CB8->CB8_SALDOS := 0
			CB8->( MsUnLock() )
			CB8->( DbSkip() )
		EndDo
	End Transaction

	MsgAlert("Separação finaliZPda com sucesso, obrigado!")

Return

/*/Protheus.doc ARFAT013
@name ARFAT013
@desc embalar
@author Renato Nogueira
@since 12/09/2016
/*/

User Function ARFAT013()

	If !(SF2->F2_XSTATUS == "2" .Or. SF2->F2_XSTATUS == "3")
		MsgAlert("Não é possível realiZPr a embalagem, verifique o status da nota!")
		Return
	EndIf

	DbSelectArea("SD2")
	SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	SD2->(DbGoTop())
	If !SD2->(DbSeek(SF2->(F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA)))
		MsgAlert("Atenção, não foi encontrado nenhum item para essa nota, entre em contato com o TI")
	Else
		U_ARFSFA30(SF2->F2_XORDSEP,SD2->D2_PEDIDO)
	EndIf

Return

/*/Protheus.doc ARFAT014
@name ARFAT014
@desc histórico
@author Renato Nogueira
@since 12/09/2016
/*/

User Function ARFAT014(_cFilial,_cDoc,_cSerie,_cCliente,_cLoja,_cOrdSep,_cStatus)

	_cFilial 	:= PADR(_cFilial,TamSx3("F2_FILIAL")[1])
	_cDoc 		:= PADR(_cDoc,TamSx3("F2_DOC")[1])
	_cSerie 	:= PADR(_cSerie,TamSx3("F2_SERIE")[1])
	_cCliente 	:= PADR(_cCliente,TamSx3("F2_CLIENTE")[1])
	_cLoja 		:= PADR(_cLoja,TamSx3("F2_LOJA")[1])
	_cOrdSep 	:= PADR(_cOrdSep,TamSx3("F2_XORDSEP")[1])

	DbSelectArea("SZP")
	SZP->( DbSetOrder(1) )
	SZP->( DbGoTop() )
	If SZP->(DbSeek(_cFilial + _cDoc + _cSerie + _cCliente + _cLoja + _cOrdSep + _cStatus))
		SZP->(RecLock("SZP",.F.))
		SZP->ZP_DATA := Date()
		SZP->ZP_HORA := Time()
		SZP->ZP_USER := cUserName
		SZP->( MsUnLock() )
	Else
		SZP->(RecLock("SZP",.T.))
		SZP->ZP_FILIAL	:= _cFilial
		SZP->ZP_DOC		:= _cDoc
		SZP->ZP_SERIE	:= _cSerie
		SZP->ZP_CLIENTE	:= _cCliente
		SZP->ZP_LOJA	:= _cLoja
		SZP->ZP_ORDSEP	:= _cOrdSep
		SZP->ZP_STATUS	:= _cStatus
		SZP->ZP_DATA 	:= Date()
		SZP->ZP_HORA 	:= Time()
		SZP->ZP_USER := cUserName
		SZP->( MsUnLock() )
	EndIf

Return

/*/Protheus.doc ARFAT015
@name ARFAT015
@desc ver histórico
@author Renato Nogueira
@since 12/09/2016
/*/

User Function ARFAT015()

	Local lSaida   		:= .T.
	Local cQuery1		:= ""
	Local cAlias1	 	:= GetNextAlias()
	Local aCampoEdit	:= {}
	Local nY := 0
	Private	_oWindow,;
	oFontWin,;
	_aHead				:= {},;
	_bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,_oWindow:End()) },;
	_bCancel 	    	:= {||(	lSaida:=.f.,_oWindow:End()) },;
	_aButtons	    	:= {},;
	_oGet,;
	_oGet2
	Private _aHeader	:= {}
	Private _aCols		:= {}

	aAdd(_aHeader,{"Usuário"	,"USER"		,"@!"						,25,0,"",,"C","R"})
	aAdd(_aHeader,{"Data"		,"DATA"		,"@!"						,TamSx3("ZP_DATA")[1],0,"",,"D","R"})
	aAdd(_aHeader,{"Hora"		,"HORA"		,"@!"						,TamSx3("ZP_HORA")[1],0,"",,"C","R"})
	aAdd(_aHeader,{"Status"		,"STATUS"	,"@!"						,20,0,"",,"C","R"})

	cQuery1  := " SELECT *
	cQuery1  += " FROM " + RetSqlName("SZP") + " ZP
	cQuery1  += " LEFT JOIN " + RetSqlName("SA1") +" A1
	cQuery1  += " ON A1_COD = ZP_CLIENTE AND A1_LOJA = ZP_LOJA
	cQuery1  += " WHERE ZP.D_E_L_E_T_ = ' ' 
	cQuery1  += " 	AND A1.D_E_L_E_T_ = ' ' 
	cQuery1  += " 	AND ZP_FILIAL = '" + SF2->F2_FILIAL + "' 
	cQuery1  += " 	AND ZP_DOC = '" + SF2->F2_DOC + "'
	cQuery1  += " 	AND ZP_SERIE = '" + SF2->F2_SERIE + "' 
	cQuery1  += " 	AND ZP_CLIENTE = '" + SF2->F2_CLIENTE + "' 
	cQuery1  += " 	AND ZP_LOJA = '" + SF2->F2_LOJA + "'
	cQuery1  += " 	AND ZP_ORDSEP = '" + SF2->F2_XORDSEP + "'
	cQuery1  += " ORDER BY ZP_STATUS
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->( dbGoTop() )

	_aCols := {}

	While (cAlias1)->( !Eof() )
		aAdd(_aCols,Array(Len(_aHeader)+1))
		For nY := 1 To Len(_aHeader)
			DO CASE
				CASE AllTrim(_aHeader[nY][2]) =  "USER"
					_aCols[Len(_aCols)][nY] := (cAlias1)->ZP_USER
				CASE AllTrim(_aHeader[nY][2]) =  "DATA"
					_aCols[Len(_aCols)][nY] := STOD((cAlias1)->ZP_DATA)
				CASE AllTrim(_aHeader[nY][2]) =  "HORA"
					_aCols[Len(_aCols)][nY] := (cAlias1)->ZP_HORA
				CASE AllTrim(_aHeader[nY][2]) =  "STATUS"
					_aCols[Len(_aCols)][nY] := GETSTATUS((cAlias1)->ZP_STATUS)
			ENDCASE
		Next
		_aCols[Len(_aCols)][Len(_aHeader)+1] := .F.
		(cAlias1)->( DbSkip() )
	EndDo

	DEFINE MSDIALOG _oWindow FROM 0,0 TO 400,1000/*500,1200*/ TITLE Alltrim(OemToAnsi('Histórico')) Pixel //430,531
	_oGet	:= MsNewGetDados():New(35,0,_oWindow:nClientHeight/2-20,_oWindow:nClientWidth/2-5,,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(_aCols),,, ,_oWindow,_aHeader,_aCols)
	_oGet:SetArray(_aCols)
	_oWindow:Refresh()
	_oGet:Refresh()
	ACTIVATE MSDIALOG _oWindow CENTERED ON INIT EnchoiceBar(_oWindow,_bOk,_bCancel,,_aButtons)

Return

/*/Protheus.doc GETSTATUS
@name GETSTATUS
@desc descricao
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GETSTATUS(_cStatus)

	Local _cDesc := ""

	_cStatus := AllTrim(_cStatus)

	Do Case
		Case _cStatus=="0"
			_cDesc := "Lib. para separação"
		Case _cStatus=="1"
			_cDesc := "Em separação"
		Case _cStatus=="2"
			_cDesc := "Separação finalizada"
		Case _cStatus=="3"
			_cDesc := "Embalagem finalizada"
		Case _cStatus=="4"
			_cDesc := "Despachado"
	EndCase

Return _cDesc

/*/Protheus.doc ARFAT012
@name ARFAT012
@desc finaliZPr separação
@author Renato Nogueira
@since 12/09/2016
/*/

User Function ARFAT016()

	Local _cQry := ""
	Local _cOS	:= SF2->F2_XORDSEP

	If !(SF2->F2_XSTATUS == "1" .Or. SF2->F2_XSTATUS == "2")
		MsgAlert("Não é possível estornar a separação, verifique o status da nota!")
		Return
	EndIf

	If !MsgYesNo("Confirma estorno da separação da nota " + AllTrim(SF2->F2_DOC) + "?")
		Return
	EndIf

	_cQry := " "
	_cQry += " UPDATE CB7070 SET D_E_L_E_T_ = '*'  
	_cQry += " WHERE CB7_ORDSEP = '" + _cOS + "' 
	_cQry += " 	AND D_E_L_E_T_ = ' ' "
	TCSqlExec(_cQry)

	_cQry := " "
	_cQry += " UPDATE CB8070 SET D_E_L_E_T_ = '*'  
	_cQry += " WHERE CB8_ORDSEP = '" + _cOS + "' 
	_cQry += " 	AND D_E_L_E_T_ = ' ' "
	TCSqlExec(_cQry)

	_cQry := " "
	_cQry += " UPDATE CB9070 SET D_E_L_E_T_ = '*'  
	_cQry += " WHERE CB9_ORDSEP = '" + _cOS + "' 
	_cQry += " 	AND D_E_L_E_T_ = ' ' "
	TCSqlExec(_cQry)

	_cQry := " "
	_cQry += " UPDATE SF2070 SET F2_XORDSEP = ' ',F2_XSTATUS = '0'  
	_cQry += " WHERE F2_XORDSEP = '" + _cOS + "' 
	_cQry += " 	AND D_E_L_E_T_ = ' ' "
	TCSqlExec(_cQry)

Return

User Function MyMATR265()

	zAtuPerg("MTR265", "MV_PAR02", SF2->F2_DOC)
	zAtuPerg("MTR265", "MV_PAR03", SF2->F2_DOC)

	// Garantir que o nome do Cliente esteja ok antes da Impressao
	dbSelectArea("SD2")
	dbSetOrder(3)

	If SD2->(dbSeek(xFilial("SD2") + SF2->(F2_DOC + F2_SERIE)))
		If Len(Alltrim(SD2->D2_XNOME)) = 0
			SD2->(RecLock("SD2",.F.))
			SD2->D2_XNOME := Left(SA1->A1_NOME,40)
			SD2->(MsUnlock())
			TcRefresh("SD2")
		EndIf
	EndIf
		
	MATR265()

Return .T.

/*/Protheus.doc zAtuPerg
Funcao Generica que possibilita atualizar parametros na SX1
@author 	José Carlos Frasson	
@since 		21/11/2019
@version	1.0
/*/

Static Function zAtuPerg(cPergAux, cParAux, xConteud)

	Local aArea      := GetArea()
	Local nPosPar    := 14
	Local nLinEncont := 0
	Local aPergAux   := {}
	Default xConteud := ''

	//Se não tiver pergunta, ou não tiver ordem
	If Empty(cPergAux) .Or. Empty(cParAux)
		Return
	EndIf

	//Chama a pergunta em memória
	Pergunte(cPergAux, .F., /*cTitle*/, /*lOnlyView*/, /*oDlg*/, /*lUseProf*/, @aPergAux)

	//Procura a posição do MV_PAR
	nLinEncont := aScan(aPergAux, {|x| Upper(Alltrim(x[nPosPar])) == Upper(cParAux) })

	//Se encontrou o parâmetro
	If nLinEncont > 0
		//Caracter
		If ValType(xConteud) == 'C'
			&(cParAux+" := '"+xConteud+"'")
			//Data
		ElseIf ValType(xConteud) == 'D'
			&(cParAux+" := sToD('"+dToS(xConteud)+")'")
			//Numérico ou Lógico
		ElseIf ValType(xConteud) == 'N' .Or. ValType(xConteud) == 'L'
			&(cParAux+" := "+cValToChar(xConteud)+"")
		EndIf
		//Chama a rotina para salvar os parâmetros
		__SaveParam(cPergAux, aPergAux)
	EndIf

	RestArea(aArea)

Return


#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
#INCLUDE "STR.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "TopConn.ch"

#Define CR chr(13)+ chr(10)

//Vari�veis Est�ticas
Static cTitulo := "Agenda de Operador"

User Function ARAGENDA()
    Local aArea   	:= GetArea()
    Local oBrowse
    Local cUsrGer	:= SuperGetMv("AR_GERVEND",.F.,"rosana.amato;gabriela.marchetta")
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("SCJ")
 
    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( " CJ_STATUS == 'A' .And. CJ_XPROLIG = dDataBase", 							"BR_VERDE",		"Abierto" )
	oBrowse:AddLegend( " CJ_STATUS == 'B'", 														"DISABLE",		"Aprobado" )
    oBrowse:AddLegend( " CJ_STATUS == 'C'", 														"BR_PRETO",		"Anulado" )
    oBrowse:AddLegend( " CJ_STATUS == 'D'", 														"BR_AMARELO",	"No Presupuestado" )
    oBrowse:AddLegend( " CJ_STATUS == 'A' .And. CJ_XPROLIG > dDataBase",							'BR_AZUL',		"Fecha de Retorno proximo")                            
    oBrowse:AddLegend( " CJ_STATUS == 'A' .And. ( Empty(CJ_XPROLIG) .Or. CJ_XPROLIG < dDataBase )",	"BR_LARANJA",	"Fecha de Retorno en retraso")		
    oBrowse:AddLegend( " CJ_STATUS == 'F'", 														"BR_MARROM",	"Bloqueado" )

    //Defini��o de Filtros aqui...

    If Alltrim(cUserName) $ cUsrGer
    	// Vendedores Supervisores
    Else
		DbSelectArea("SA3")
		SA3->(DbSetOrder(7))
		SA3->(DbGoTop())

		If SA3->(DbSeek(xFilial("SA3")+__cUserId))
	    	oBrowse:SetFilterDefault("SCJ->CJ_XUSRINC = '" + __cUserId +"'")	// Temporario
		Else
			MsgAlert("Atencion, su usuario no esta registrado como vendedor, verifique!")
			RestArea(aArea)
			Return
		EndIf
    EndIf
    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil


Static Function MenuDef() 
	aRotina := {}
	ADD OPTION aRotina TITLE 'Pesquisar'  		ACTION "AxPesqui"        	OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.ARAGENDA" 	OPERATION MODEL_OPERATION_VIEW	ACCESS 0	
	ADD OPTION aRotina TITLE "interacciones"	ACTION "u_ZZYInclui"		OPERATION 6  ACCESS 0 
	ADD OPTION aRotina TITLE "Leyenda"			ACTION "u_ArLegScj"			OPERATION 7  ACCESS 0
Return aRotina


Static Function ModelDef()
	Local oModel 		:= Nil
	Local oStPai 		:= FWFormStruct(1, 'SCJ')
	Local oStFilho 		:= FWFormStruct(1, 'SCK')
	Local oStNeto 		:= FWFormStruct(1, 'ZZY')
	Local aSCKRel		:= {}
	Local aZZYRel		:= {}
	
	//Criando o modelo e os relacionamentos
	//oModel := MPFormModel():New("xxx", /*bPre*/,, /*bPost*/, /*bCommit*/, /*bCancel*/)
	oModel := MPFormModel():New("ARAGE_MD", /*bPre*/,, /*bPost*/, /*bCommit*/, /*bCancel*/)

	oModel:AddFields('SCJMASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('SCKDETAIL','SCJMASTER',	oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
	oModel:AddGrid('ZZYDETAIL','SCJMASTER',	oStNeto,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
	
	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aSCKRel, {'CK_FILIAL',	'CJ_FILIAL'} )
	aAdd(aSCKRel, {'CK_CLIENTE','CJ_CLIENTE'})
	aAdd(aSCKRel, {'CK_LOJA',	'CJ_LOJA'})
	aAdd(aSCKRel, {'CK_NUM',	'CJ_NUM'})
	
	//Fazendo o relacionamento entre o Filho e Neto
	aAdd(aZZYRel, {'ZZY_FILIAL',	'CJ_FILIAL'} )
	aAdd(aZZYRel, {'ZZY_NUM',		'CJ_NUM'}) 
	
	oModel:SetRelation('SCKDETAIL', aSCKRel, SCK->(IndexKey(2)))
	oModel:GetModel('SCKDETAIL'):SetUniqueLine({"CK_FILIAL","CK_NUM"})
	oModel:SetPrimaryKey({})
	
	oModel:SetRelation('ZZYDETAIL', aZZYRel, ZZY->(IndexKey(1)))
	oModel:GetModel('ZZYDETAIL'):SetUniqueLine({"ZZY_FILIAL", "ZZY_NUM"})
	oModel:SetPrimaryKey({})
	
	//Setando as descri��es
	oModel:SetDescription("Agenda de Operadores")
	oModel:GetModel('SCJMASTER'):SetDescription('Presupuesto')
	oModel:GetModel('SCKDETAIL'):SetDescription('Itens')
	oModel:GetModel('ZZYDETAIL'):SetDescription('Interacciones')
	
	//Adicionando totalizadores
	//oModel:AddCalc( 'TOT_ITENS', 	'SCJMASTER', 'SCKDETAIL', 'CK_PRUNIT * CK_QTDVEN', 	'XX_TOT1', 	'SUM', , , 	"Total:" )
	//oModel:AddCalc( 'TOT_ITENS', 	'SCJMASTER', 'SCKDETAIL', 'CK_VALDESC',	'XX_TOT2', 	'SUM', , , 	"Descuentos:" )
	oModel:AddCalc( 'TOT_ITENS', 	'SCJMASTER', 'SCKDETAIL', 'CK_VALOR',	'XX_TOT3', 	'SUM', , , 	"Valor neto:" )
	oModel:AddCalc( 'TOT_ITENS', 	'SCJMASTER', 'SCKDETAIL', 'CK_VALOR', 	'XX_QTDE', 	'COUNT', , ,"Cantidad:" )
	
Return oModel


// INTERFACE GR�FICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ARAGENDA")

    // INSTANCIA AS SUBVIEWS
    //Local oStruSCJ 	:= FwFormStruct(2, 	"SCJ")
    Local oStruSCJ 	:= FwFormStruct(2, 	"SCJ",	{|cCampo| !AllTrim(cCampo) $ "CJ_PROSPE/CJ_LOJPRO/CJ_COTCLI/CJ_FILVEN/CJ_FILENT/CJ_XOBSCJ_XORPC"})
    Local oStruSCK 	:= FwFormStruct(2, 	"SCK")
	Local oStruZZY  := FWFormStruct(2,	"ZZY",	{|cCampo| !AllTrim(cCampo) $ "ZZY_FILIAL/ZZY_NUM/ZZY_ACAO/ZZY_DESMOT"})
	Local oStTot	:= FWCalcStruct(oModel:GetModel('TOT_ITENS'))

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    oView:AddField("VIEW_SCJ",	oStruSCJ, 	"SCJMASTER")
    oView:AddGrid("VIEW_SCK", 	oStruSCK, 	"SCKDETAIL")
    oView:AddField('VIEW_TOT', 	oStTot,		"TOT_ITENS")
    oView:AddGrid("VIEW_ZZY", 	oStruZZY, 	"ZZYDETAIL")

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA",	25)
    oView:CreateHorizontalBox("MEIO", 	25)
    oView:CreateHorizontalBox('TOTAL',	15)
    oView:CreateHorizontalBox("EMBAIXO",35)

    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SCJ", 	"EMCIMA")
    oView:SetOwnerView("VIEW_SCK", 	"MEIO")
    oView:SetOwnerView("VIEW_TOT",	"TOTAL")
    oView:SetOwnerView("VIEW_ZZY", 	"EMBAIXO")

    // DEFINE OS T�TULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SCJ")
    oView:EnableTitleView("VIEW_SCK", 	"Art�culos", RGB(224, 30, 43))
    oView:EnableTitleView("VIEW_TOT",	"Totales",0)
    oView:EnableTitleView("VIEW_ZZY", 	"interacciones", 0)
Return (oView)


User Function ZZYInclui(cUserInc)
Local nOpca 		:= 0
Local aCpos			:= {}
Local cAlias		:= "ZZY" 

Local _cEmail   	:= ""
Local _cCopia   	:= Alltrim(Getmv("AR_MAILSUP",,"gabriela.marchetta@steckgroup.com;;rosana.amato@steckgroup.com;"))
Local _cAssunto 	:= ""
Local aUsuario		:= {}

Local cMsg			:= ""
Local _aAttach		:= {}
Local _cCaminho		:= ""

Private _cOrc		:= ""

Private cCadastro 	:= "Notas de agenda - " + SCJ->CJ_NUM
Private _cNomePdf  	:= cEmpAnt + "_Presupuesto_" + SCJ->CJ_NUM  + ".pdf"
Private _cDirRel   	:= Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')

If !SCJ->CJ_STATUS $ "AxD" 
	MsgAlert("Atencion, El estado del presupuesto no permite interacciones...")
	Return(.F.)
Endif

ALTERA := .F.

AADD(aCpos, "ZZY_MOTIVO")
AADD(aCpos, "ZZY_DTINCL")
AADD(aCpos, "ZZY_CUSERI")
AADD(aCpos, "ZZY_OBS")
AADD(aCpos, "ZZY_RETORN")

RegToMemory("ZZY", .T., .F.)

nOpca := AxInclui(cAlias,	0,	3,/*aAcho*/,"u_ZZYINIC",aCpos,"u_ZZYVld()",;
		/*lF3*/,/*cTransact*/,/*aButtons*/,/*aParam*/,/*aAuto*/,/*lVirtual*/,/*lMaximized*/)
If nOpca == 1

	//Gravar dados e disparar email ao vendedor

	dbSelectArea('SA3')
	SA3->(DbSetOrder(1))
	
	If SA3->(dbSeek(xFilial('SA3') + SCJ->CJ_XCVEND))
		_cEmail := Alltrim(SA3->A3_EMAIL)
	Endif

	Reclock("SCJ",.F.)
	
	_cOrc	:= ZZY->ZZY_NUM 

	Do Case
		Case Left(Alltrim(ZZY->ZZY_MOTIVO),1) == "8"
			_cAssunto	:= "[WFPROTHEUS] - Presupuesto: " + ZZY->ZZY_NUM + " cambiado a la fecha de regreso: " + DTOC(ZZY->ZZY_RETORN)
			CJ_XPROLIG := ZZY->ZZY_RETORN 
	Other
		_cAssunto	:= "[WFPROTHEUS] - Presupuesto: " + ZZY->ZZY_NUM + " cancelado en: " + DTOC(ZZY->ZZY_DTINCL)

		// Atualizacao Cotizacion
		
		SCJ->CJ_STATUS := "C"
	EndCase
	
	SCJ->(MsUnlock())
	
	If Left(Alltrim(ZZY->ZZY_MOTIVO),1) == "8"
		U_ARFAT01()
		aadd( _aAttach  , _cDirRel + _cNomePdf )
	Endif

	cMsg	:= 	ARASSUNT(_cOrc)

	If !u_ARMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		MsgAlert("Problemas no envio de email!")
	Else
		MsgInfo("O status do chamado e o e-mail foram atualizados com sucesso","Sucesso!")
	EndIf

EndIf
Return()


User Function ZZYINIC()
	Local cQuery	:= ""
	Local cItem		:= ""	
	Local lRet		:= .T.

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	cQuery := " SELECT"
	cQuery += " MAX(ZZY_ITEM) ZZY_ITEM"
	cQuery += " FROM " + RetSqlName("ZZY")
	cQuery += " WHERE D_E_L_E_T_ = ' '"
	cQuery += " AND   ZZY_FILIAL = '" + xFilial("ZZY") + "'"
	cQuery += " AND   ZZY_NUM = '" + SCJ->CJ_NUM + "'"
	TCQUERY cQuery NEW ALIAS "TRB"
	
	dbSelectArea("TRB")
	dbGotop()
	
	cItem := StrZero(Val(TRB->ZZY_ITEM) + 1,2)

	TRB->(dbCloseArea())

	If Val(cItem) > 99
		MsgAlert("Atencion, Se alcanz� el n�mero m�ximo de interacciones ...")
		lRet := .F.
	Else
		M->ZZY_NUM 		:= SCJ->CJ_NUM    
		M->ZZY_ITEM		:= cItem
		
		M->ZZY_VEND		:= SCJ->CJ_XCVEND
		M->ZZY_NVEND 	:= Posicione("SA3",1,xFilial("SA3") + SCJ->CJ_XCVEND,"A3_NOME")
	Endif
Return(lRet)



User Function ZZYVld()
Local lRet := .T.

	Do Case
		Case Empty(M->ZZY_MOTIVO) 
			MsgAlert("Atencion, motivo n�o informado...")
			lRet := .F.
		Case Left(M->ZZY_MOTIVO,1) <> "8" .And. !Empty(M->ZZY_RETORN)
			MsgAlert("Atencion, motivo diferente de 8 e data de retorno preenchida...")
			lRet := .F.
		Case Left(M->ZZY_MOTIVO,1) == "8" .And. Empty(M->ZZY_RETORN)
			MsgAlert("Atencion, motivo 8 e data de retorno n�o preenchida...")
			lRet := .F.
		Case Empty(M->ZZY_OBS) 
			MsgAlert("Atencion, campo Observa��o n�o preenchido...")
			lRet := .F.
	EndCase

Return(lRet)

User Function SCKTOT(_cOrc)
Local _nTotal	:= 0
Local cQuery	:= ""

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

cQuery := " SELECT"
cQuery += " SUM(CK_VALOR) VALOR"
cQuery += " FROM " + RetSqlName("SCK")
cQuery += " WHERE D_E_L_E_T_ = ' '"
cQuery += " AND   CK_FILIAL = '" + xFilial("SCK") + "'"
cQuery += " AND   CK_NUM = '" + _cOrc + "'"
TCQUERY cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
dbGotop()

_nTotal	:= TRB->VALOR

TRB->(dbCloseArea())

Return( _nTotal )

User Function ArLegScj()

	Local cTiScp 	:= 'Status - Presupuestos'

	aLegSCP := {;
		{ "ENABLE",		"Abierto"},;
		{ "DISABLE",	"Aprobado"},;
		{ "BR_PRETO",	"Anulado"},;
		{ "BR_AMARELO",	"No Presupuestado"},;
		{ "BR_AZUL",	"Fecha de Retorno proximo"},;
		{ "BR_LARANJA",	"Fecha de Retorno en retraso"},;
		{ "BR_MARROM",	"Bloqueado" }}

	BrwLegenda(" Leyenda ",cTiScp, aLegSCP)

Return()

User Function Vld_CJCli()
Local lRet 		:= .T.
//Local aSaveArea := GetArea()

dbSelectArea("SA1")
SA1->(dbSetOrder(1))

If SA1->(dbSeek(xFilial("SA1") + M->CJ_CLIENTE))
	If SA1->A1_MSBLQL  == "1"
		ApMsgInfo("El cliente esta bloqueado...", "Atencion")
		lRet := .F.
	Endif	
Else
	ApMsgInfo("Cliente no encontrado...", "Atencion")
	lRet := .F.
Endif

//RestArea(aSaveArea)
Return(lRet)

User Function Gat_SCJCto(cAlias)
Local cRet := ""

Default cAlias := "SCJ"

Do Case 
	Case cAlias = "SCJ"
			
		If SU5->(dbSeek(xFilial("SU5") + M->CJ_XCDCONT ) )
			AGB->(dbSetOrder(3))
			If AGB->(dbSeek(xFilial("AGB") + "SU5" + M->CJ_XCDCONT))
				cRet := AGB->AGB_TELEFO
			EndIf
		EndIf
	
	Case cAlias = "SUS"

		If SU5->(dbSeek(xFilial("SUS") + M->US_XCDCONT ) )
			AGB->(dbSetOrder(3))
			If AGB->(dbSeek(xFilial("AGB") + "SU5" + M->US_XCDCONT))
				cRet := AGB->AGB_TELEFO
			EndIf
		EndIf
EndCase 

Return(cRet)


Static Function ARASSUNT(_cOrc)
	Local aArea 	:= GetArea()
	Local _cFrom   	:= "protheus@steck.com.br"
	Local _cAssunto	:= ' '
	Local cFuncSent	:= "ARASSUNT"
	Local i        	:= 0
	Local cArq     	:= ""
	Local cMsg     	:= ""
	Local _nLin
	Local cAttach  	:= ''
	Local _aMsg 	:= {}
	Local nValorTot	:= 0

	If __cuserid = '000000'
		_cAssunto := _cAssunto + " TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf
	
	nValorTot := u_SCKTOT(_cOrc)
	
	DbSelectArea("SCJ")
	SCJ->(DbSetOrder(1))
	SCJ->(DbGoTop())

	If SCJ->(dbSeek(xFilial("SCJ") + _cOrc))
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=80%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	
		cMsg += '<TR BgColor=#FFFFFF><TD><B><Font Color=#000000 Size="2" Face="Arial">Posicionado:  	</Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cUserName + '</Font></TD></TR>'
		
		cMsg += '<TR BgColor=#B0E2FF><TD><B><Font Color=#000000 Size="2" Face="Arial">Cliente:  	</Font></B></TD><TD> <Font Color=#000000 Size="2" Face="Arial">' + SCJ->CJ_CLIENTE	+ ' - ' + Alltrim(Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE,	"A1_NOME")) + '</Font></TD></TR>'
		cMsg += '<TR BgColor=#FFFFFF><TD><B><Font Color=#000000 Size="2" Face="Arial">Vendedor 1:  	</Font></B></TD><TD> <Font Color=#000000 Size="2" Face="Arial">' + SCJ->CJ_XCVEND 	+ ' - ' + Alltrim(Posicione("SA3",1,xFilial("SA3") + SCJ->CJ_XCVEND,	"A3_NOME")) + '</Font></TD></TR>'
		cMsg += '<TR BgColor=#B0E2FF><TD><B><Font Color=#000000 Size="2" Face="Arial">Vendedor 2:  	</Font></B></TD><TD> <Font Color=#000000 Size="2" Face="Arial">' + SCJ->CJ_XCVEND2 	+ ' - ' + Alltrim(Posicione("SA3",1,xFilial("SA3") + SCJ->CJ_XCVEND2,	"A3_NOME")) + '</Font></TD></TR>'
	
		cMsg += '<TR BgColor=#FFFFFF><TD><B><Font Color=#000000 Size="2" Face="Arial">Valor:  		</Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + TRANSFORM(nValorTot ,"@E 99,999,999,999.99") + '</Font></TD></TR>'
	
		cMsg += '<TR BgColor=#B0E2FF><TD><B><Font Color=#000000 Size="2" Face="Arial">Emisi�n:  	</Font></B></TD><TD> <Font Color=#000000 Size="2" Face="Arial">' + dtoc(SCJ->CJ_EMISSAO) + '</Font></TD></TR>'
		cMsg += '<TR BgColor=#FFFFFF><TD><B><Font Color=#000000 Size="2" Face="Arial">Retorno:  	</Font></B></TD><TD> <Font Color=#000000 Size="2" Face="Arial">' + dtoc(SCJ->CJ_XPROLIG) + '</Font></TD></TR>'
		cMsg += '</Font></TD></TR></Table>'	
		
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=5 CELLSPACING=0 Width=80%>'
		cMsg += '<TR BgColor=#FFFFFF><TD><B><Font Color=#000000 Size="2" Face="Arial">Interaciones</Font></B></TD><P>'
		
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=5 CELLSPACING=0 Width=80%>'
		cMsg += '<TR BgColor=#B0E2FF><TD><B><Font Color=#000000 Size="2" Face="Arial">Seq</Font></B></TD><P>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">Fecha</Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">Descricion</Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">Observaciones</Font></TD>'
	
		DbSelectArea("ZZY")
		ZZY->(DbSetOrder(1))
		ZZY->(DbGoTop())

		If ZZY->(DbSeek(cFilAnt+_cOrc))
			While !(ZZY->(Eof())) .And. ZZY->ZZY_NUM = _cOrc

				_cMtzzy := ""
				
				Do Case
					Case ZZY->ZZY_MOTIVO = '1'
						_cMtzzy := 'COSTO SOLO'
					Case ZZY->ZZY_MOTIVO = '2'
						_cMtzzy := 'OTROS COMPRADOS'
					Case ZZY->ZZY_MOTIVO = '3'
						_cMtzzy := 'ART�CULOS INCL. SOLICITAR'
					Case ZZY->ZZY_MOTIVO = '4'
						_cMtzzy := 'COMPRADO EN EL DISTRIBUIDOR'
					Case ZZY->ZZY_MOTIVO = '5'
						_cMtzzy := 'COMPETIDOR PERDIDO'
					Case ZZY->ZZY_MOTIVO = '6'
						_cMtzzy := 'CITA PERDIDA'
					Case ZZY->ZZY_MOTIVO ='8'
						_cMtzzy := 'CARGAR DE NUEVO'
				EndCase

				cMsg += '<TR BgColor=#FFFFFF><TD><B><Font Color=#000000 Size="2" Face="Arial">' + ZZY_ITEM + '</Font></B></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + Dtoc(ZZY_RETORN) + '</Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _cMtzzy + '</Font></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + ZZY->ZZY_OBS + '</Font></TD></TR>'

				ZZY->(dbSkip())
			End
		Else
			// Nao existem interaciones
			cMsg += '<TR BgColor=#FFFFFF><TD><B><Font Color=#000000 Size="2" Face="Arial"></Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial"></Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial"></Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">No hay interaciones</Font></TD></TR>'
		EndIf
		
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'
	EndIf
	RestArea(aArea)
Return(cMsg)

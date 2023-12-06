#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

Static _cRetorno := ""

/*====================================================================================\
|Programa  | STCADSZR        | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018  |
|=====================================================================================|
|Descrição | CADASTRO DE USUARIOS DO PORTAL DE CLIENTES                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCADSZR()

	Local oBrowse
	Private aRotina := MenuDef()

	DbSelectArea("SZR")
	SZR->(DbSetOrder(1))

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Cadastro usuários portal de clientes")
	oBrowse1:SetAlias("SZR")

	oBrowse1:AddLegend("SZR->ZR_STATUS=='A'","GREEN","Ativo")
	oBrowse1:AddLegend("SZR->ZR_STATUS=='I'","RED","Inativo")

	oBrowse1:Activate()

Return()

/*/{Protheus.doc} MenuDef
@name MenuDef
@type Static Function
@desc monta menu principal
@author Renato Nogueira
@since 09/01/2017
/*/

Static Function MenuDef()
	Local aRotina := {}
	Local _cAlias     := "SZR"										// valdemir 16/01/2020
	Public aMotBX := {"ZR_FILIAL","ZR_LOGIN","ZR_NOME"}				// valdemir 16/01/2020

	ADD OPTION aRotina TITLE 'Pesquisar'  				ACTION "AxPesqui"        			OPERATION 1  ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STCADSZR" 			OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Incluir"    				ACTION "VIEWDEF.STCADSZR" 			OPERATION 3  ACCESS 0 //"Inclusao"
	ADD OPTION aRotina TITLE "Alterar"    				ACTION "VIEWDEF.STCADSZR" 			OPERATION 4  ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Anexar"    				ACTION "u_STANEXOK('"+_cAlias+"',,'Portal\')" 	OPERATION 4  ACCESS 0 // valdemir 16/01/2020
	ADD OPTION aRotina TITLE "Enviar acesso"			ACTION "U_STSZR001" 			OPERATION 10  ACCESS 0 //"Alterar"

Return aRotina

/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc montar model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'SZR')
	Local oStr2:= FWFormStruct(1,'Z79')
	Local _aRel	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)
	oModel:addGrid('GRID1','FIELD1',oStr2,,)

	aAdd(_aRel, { 'Z79_EMAIL'	, 'ZR_EMAIL' } )

	oModel:SetRelation('GRID1', _aRel , Z79->(IndexKey(2)) )

	oModel:SetPrimaryKey({})

	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')
	oModel:getModel('GRID1'):SetDescription('Itens')

Return oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc montar view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView:= NIL
	Local oStr1:= FWFormStruct(2, 'SZR')
	Local oStr2:= FWFormStruct(2, 'Z79')
	Local oModel     := FWLoadModel("STCADSZR")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:AddGrid('FORM3' , oStr2,'GRID1')

	oView:CreateHorizontalBox( 'BOXFORM1', 70)
	oView:CreateHorizontalBox( 'BOXFORM3', 30)

	oView:SetOwnerView('FORM1','BOXFORM1')
	oView:SetOwnerView('FORM3','BOXFORM3')

	oView:EnableTitleView('FORM1','Cabeçalho')
	oView:EnableTitleView('FORM1','Itens')

	oView:EnableControlBar(.T.)

	oView:SetCloseOnOk({|| .T.})

	oView:AddUserButton( 'Teste user', 'NOTE', {|oView| U_STSZR004()} )

Return oView

/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc validar alteração do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet				:= .T.
	Local nOp         		:= oModel:GetOperation()

Return(_lRet)

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc validar tudo ok do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet			:= .T.

Return(_lRet)

/*/{Protheus.doc} VLDLIN
@name VLDLIN
@type Static Function
@desc validar troca de linha do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDLIN(oModel,nLine)

	Local _lRet	:= .T.

Return(_lRet)

/*/{Protheus.doc} GrvTOK
@name GrvTOK
@type Static Function
@desc realiza gravação dos dados
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GrvTOK( oModel )

	Local lGrv		:= .T.
	Local nOp		:= oModel:GetOperation()
	Local _cCopia	:= "renato.oliveira@steck.com.br;aricleia.silva@steck.com.br"
	Local _nX

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

	If nOp==3 //Enviar email para o cliente passando o acesso

		SZR->(RecLock("SZR",.F.))
		SZR->ZR_SENHA := cValToChar(Randomize(100000,999999))
		SZR->(MsUnLock())

		U_STSZR001()

	EndIf

	_aCnpjs := U_STFAT440(SZR->ZR_EMAIL)
	If Len(_aCnpjs)==0
		AADD(_aCnpjs,SZR->ZR_LOGIN)
	EndIf

	DbSelectArea("AC8")
	AC8->(DbSetOrder(2)) //AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
	DbSelectArea("SA1")
	SA1->(DbSetOrder(3)) //A1_FILIAL+A1_CGC
	For _nX:=1 To Len(_aCnpjs)
		If SA1->(DbSeek(xFilial("SA1")+_aCnpjs[_nX]))
			If !AC8->(DbSeek(xFilial("AC8")+"SA1"+xFilial("AC8")+SA1->(A1_COD+A1_LOJA)))

				_cCodCont := GetSXENum("SU5","U5_CODCONT")
				SU5->(ConfirmSX8())

				SU5->(RecLock("SU5",.T.))
				SU5->U5_CODCONT := _cCodCont
				SU5->U5_CONTAT  := "PORTAL CLIENTE (AJUSTAR)"
				SU5->U5_DDD		:= "11"
				SU5->U5_FCOM1 	:= "99999999"
				SU5->U5_EMAIL	:= "contato@steck.com.br"
				SU5->U5_ATIVO 	:= "1"
				SU5->U5_FUNCAO	:= "000001"
				SU5->U5_DEPTO	:= "000000001"
				SU5->U5_MSBLQL  := "2"
				SU5->U5_SOLICTE := "2"
				SU5->(MsUnLock())

				AC8->(RecLock("AC8",.T.))
				AC8->AC8_ENTIDA := "SA1"
				AC8->AC8_CODENT := SA1->(A1_COD+A1_LOJA)
				AC8->AC8_CODCON := _cCodCont
				AC8->(MsUnLock())

			EndIf
		EndIf
	Next

Return lGrv

/*====================================================================================\
|Programa  | STSZRVL1       | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018   |
|=====================================================================================|
|Descrição | VALIDAR CNPJ DIGITADO					                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STSZRVL1()

	Local _lRet 	:= .F.
	Local _cQuery1 	:= ""
	Local _cAlias1  := GetNextAlias()

	_cTpUser	:= M->ZR_TPUSER
	_cLogin 	:= &(ReadVar())
	_cLogin 	:= AllTrim(_cLogin)

	If AllTrim(_cTpUser)=="C"

		_cQuery1 := " SELECT *
		_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
		_cQuery1 += " WHERE A1.D_E_L_E_T_=' ' AND

		If Len(_cLogin)==14
			_cQuery1 += " A1_CGC='"+_cLogin+"'
		ElseIf Len(_cLogin)==8
			_cQuery1 += " SUBSTR(A1_CGC,1,8)='"+_cLogin+"'
		ElseIf Len(_cLogin)==11
			_cQuery1 += " SUBSTR(A1_CGC,1,11)='"+_cLogin+"' AND A1_PESSOA='F'
		Else
			MsgAlert("Atenção, o CNPJ deve possuir 8, 14 ou 11 caracteres, verifique!")
			Return(.F.)
		EndIf

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->(Eof())
			MsgAlert("Atenção, CNPJ não encontrado no cadastro de clientes, verifique!")
			Return(.F.)
		Else
			DbSelectArea("SA1")
			SA1->(DbGoTop())
			SA1->(DbGoTo((_cAlias1)->R_E_C_N_O_))
			Return(.T.)
		EndIf

	Else

		DbSelectArea("SA3")
		SA3->(DbSetOrder(1))
		If !SA3->(DbSeek(xFilial("SA3")+_cLogin))
			MsgAlert("Vendedor não encontrado, verifique!")
			Return(.F.)
		EndIf

	EndIf

Return(.T.)

/*====================================================================================\
|Programa  | STSZRVL2       | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018   |
|=====================================================================================|
|Descrição | TELA PARA SELECIONAR AS ROTINAS		                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STSZRVL2()

	Local _aHeader		:= {}
	Local _aCols		:= {}
	Local lSaida   		:= .T.
	Local lConfirma 	:= .F.
	Local nY:= 0
	Local _nX:= 0
	//Private _cRetorno	:= ""
	Local _oWindow,;
	oFontWin,;
	_bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,_oWindow:End()) },;
	_bCancel 	    	:= {||(	lSaida:=.f.,_oWindow:End()) },;
	_aButtons	    	:= {},_oGet

	_cRetorno := ""

	Aadd(_aHeader,{"Mar/Des"							,"MARKBROW"			    ,"@BMP"				,2	  ,0    ,"",,"C",""})
	Aadd(_aHeader,{"Sequencia"							,"SEQ"			    	,"@!"				,2	  ,0    ,"",,"C",""})
	Aadd(_aHeader,{"Rotina	"							,"ROT"			    	,"@!"				,55	  ,0    ,"",,"C",""})

	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))
	SX5->(DbGoTop())
	SX5->(DbSeek(xFilial("SX5")+"_B"))

	While SX5->(!Eof()) .And. SX5->X5_TABELA=="_B"

		AADD(_aCols,Array(Len(_aHeader)+1))

		For nY := 1 To Len(_aHeader)

			DO CASE
			CASE AllTrim(_aHeader[nY][2]) =  "MARKBROW"
				If SubStr(M->ZR_ACESSOS,Val(SX5->X5_CHAVE),1)=="X"
					_aCols[Len(_aCols)][nY] := "LBOK"
				Else
					_aCols[Len(_aCols)][nY] := "LBNO"
				EndIf
			CASE AllTrim(_aHeader[nY][2]) =  "SEQ"
				_aCols[Len(_aCols)][nY] := SX5->X5_CHAVE
			CASE AllTrim(_aHeader[nY][2]) =  "ROT"
				_aCols[Len(_aCols)][nY] := SX5->X5_DESCRI
			ENDCASE

		Next

		_aCols[Len(_aCols)][Len(_aHeader)+1] := .F.

		SX5->(DbSkip())
	EndDo

	DEFINE MSDIALOG _oWindow FROM 0,0 TO 300,800/*500,1200*/ TITLE Alltrim(OemToAnsi('Selecionar rotinas')) Pixel //430,531
	_oGet1	:= MsNewGetDados():New(030,000,_oWindow:nClientHeight/2-5,_oWindow:nClientWidth/2-5,GD_UPDATE,,,,{'MARKBROW'},,Len(_aCols),,,,_oWindow,_aHeader,_aCols)
	bDbClick := _oGet1:oBrowse:bLDblClick
	_oGet1:oBrowse:bLDblClick := {|| (Iif(_oGet1:aCols[_oGet1:nAt,1]=="LBNO",_oGet1:aCols[_oGet1:nAt,1]:="LBOK",_oGet1:aCols[_oGet1:nAt,1]:="LBNO"),_oGet1:oBrowse:Refresh(),"")}
	_oGet1:SetArray(_aCols)
	ACTIVATE MSDIALOG _oWindow CENTERED ON INIT EnchoiceBar(_oWindow,_bOk,_bCancel,,_aButtons)

	If lConfirma

		For _nX:=1 To Len(_oGet1:aCols)
			If _oGet1:aCols[_nX][1]=="LBOK"
				_cRetorno += "X"
			Else
				_cRetorno += " "
			EndIf
		Next _nX

	Else

		_cRetorno := ""

	EndIf

Return(.T.)

/*====================================================================================\
|Programa  | STSZRVL3       | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018   |
|=====================================================================================|
|Descrição | TELA PARA SELECIONAR AS ROTINAS - RETORNO                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STSZRVL3()

Return(_cRetorno)

/*====================================================================================\
|Programa  | STSZR001       | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018   |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STSZR001()

	Local _cCopia	:= ""
	Local cMsg      := ""

	_cAssunto := "Seja bem-vindo ao portal de clientes da Steck"

	cMsg := ' <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	cMsg += ' <html xmlns="http://www.w3.org/1999/xhtml">
	cMsg += ' <head>
	cMsg += ' 	<title>STECK</title>
	cMsg += ' 	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	cMsg += ' 	<meta name="color-scheme" content="only">
	cMsg += ' </head>
	cMsg += ' <body bgcolor="#FFFFFF" text="#273338" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="background-color: #FFFFFF;">
	cMsg += ' 
	cMsg += ' <!-- Body --> 
	cMsg += ' <table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
	cMsg += ' 	<tbody>
	cMsg += ' 		<tr>
	cMsg += ' 		<td>
	cMsg += ' 			<!-- Header -->
	cMsg += ' 			<table width="650" border="0" bgcolor="#FFFFFF" cellpadding="0" cellspacing="0" style="display: block;"><tr><td width="650" height="20"></td></tr></table>
	cMsg += ' 			<table width="650" border="0" bgcolor="#FFFFFF" cellpadding="0" cellspacing="0">
	cMsg += ' 				<tr>
	cMsg += ' 					<td width="650" align="center">
	cMsg += ' 						<img src="https://bucket-site-steck.s3.sa-east-1.amazonaws.com/images/emkt/steck-header-institucional-header.png" alt="STECK" style="display: block; border: none;" />
	cMsg += ' 					</td>
	cMsg += ' 				</tr>
	cMsg += ' 			</table>
	cMsg += ' 			<table width="600" border="0" bgcolor="#FFFFFF" cellpadding="0" cellspacing="0"><tr><td width="600" height="30"></td></tr></table>
	cMsg += ' 			<!-- Header -->
	cMsg += ' 
	cMsg += ' 			<!-- Content -->
	cMsg += ' 			<table width="650" border="0" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" align="center">
	cMsg += ' 				<tr>
	cMsg += ' 					<td width="600">
	cMsg += ' 						<p style="color: #464646; font-size: 16px; line-height: 23px; font-family: Arial, Helvetica, sans-serif, sans-serif;">
	cMsg += ' 							Olá <b>'+Alltrim(SZR->ZR_NOME)+'</b>,
	cMsg += ' 						</p>
	cMsg += ' 						<p style="margin: 0 0 0 0; color: #464646; font-size: 16px; line-height: 23px; font-family: Arial, Helvetica, sans-serif, sans-serif;">
	cMsg += ' 							Seja bem-vindo ao portal de clientes da Steck!<br />
	cMsg += ' 							<a href="https://portalcliente.steck.com.br/#/" target="_blank" style="display: inline-block;">Clique aqui</a> para acessar o nosso portal.<br />
	cMsg += ' 							Seu login para acesso é: '+AllTrim(SZR->ZR_EMAIL)+'<br />
	cMsg += ' 							Sua senha inicial é: <i>'+AllTrim(SZR->ZR_SENHA)+'</i>
	cMsg += ' 						</p>
	cMsg += ' 					</td>
	cMsg += ' 					<td width="50" bgcolor="#FFFFFF" align="left">&nbsp;</td>
	cMsg += ' 				</tr>
	cMsg += ' 			</table>
	cMsg += ' 			<table width="650" border="0" bgcolor="#FFFFFF" cellpadding="0" cellspacing="0" style="display: block;"><tr><td width="650" height="40"></td></tr></table>
	cMsg += ' 			<!-- Content -->
	cMsg += ' 
	cMsg += ' 		</td>
	cMsg += ' 		</tr>
	cMsg += ' 	</tbody>
	cMsg += ' </table>
	cMsg += ' <!-- Body --> 
	cMsg += ' </body>
	cMsg += ' </html>

	U_STMAILTES(SZR->ZR_EMAIL, _cCopia, _cAssunto, cMsg,{},"")

	MsgAlert("Acesso enviado com sucesso!")

Return()

/*====================================================================================\
|Programa  | STSZR003       | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018   |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STSZR003(_cCgc,_cEmail)

	Local oModel	:= FWModelActive()
	Local oView := FWViewActive() 
	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local nI := 0

	omodelAut := oModel:GetModel('GRID1')

	For nI := 1 To omodelAut:Length()
		omodelAut:GoLine( nI )
		If !omodelAut:IsDeleted()
			omodelAut:DeleteLine()
		EndIf
	Next

	nLinha := Len(omodelAut:Acols)

	_cQuery1 := " SELECT A1_CGC
	_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' ' AND
	_cQuery1 += " A1_CGC LIKE '"+AllTrim(_cCgc)+"%'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		omodelAut:AddLine()
		omodelAut:SetValue("Z79_CNPJS",(_cAlias1)->A1_CGC)
		omodelAut:SetValue("Z79_EMAIL",_cEmail)

		(_cAlias1)->(DbSkip())
	EndDo

	oView:Refresh()

Return(_cCgc)

User Function STSZR004()

MsgAlert(M->ZR_NOME)

Return()

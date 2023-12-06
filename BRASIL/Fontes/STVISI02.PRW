#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STVISI02       | Autor | GIOVANI.ZAGO             | Data | 09/10/2017    |
|=====================================================================================|
|Sintaxe   | STVISI02                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================
*/
*----------------------------------*
User Function STVISI02()
	*----------------------------------*
	Local oBrowse
	Private _UserMvc := GetMv('ST_VISI02',,'000000/000645/000210')
	Private _lPartic := .T.
	DbSelectArea("Z1S")

	Z1S->(DbSetOrder(1))
	Z1S->(dbSetFilter({|| Z1S->Z1S_COD = Z1R->Z1R_COD    },' Z1S->Z1S_COD = Z1R->Z1R_COD '))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z1S")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("STVISI02")				// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("Cadastro de Visitas")   	// Descrição do browse
	oBrowse:Activate()

Return(Nil)

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "U_XREEVI" 	OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    	ACTION "U_XREEAL" 	OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    	ACTION "U_XREEEX" 	OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    	ACTION "U_XREEIN" 	OPERATION 3 ACCESS 0 //"Incluir"

Return aRotina

User Function XREEIN()

	FWExecView("INCLUIR",'STVISI03', MODEL_OPERATION_INSERT, , {|| .T. },{|| .T.},,,{|| .T.})

Return

User Function XREEAL()

	FWExecView("ALTERAR",'STVISI03', MODEL_OPERATION_UPDATE, ,{|| .T.} ,{|oModel| STVISI12(oModel)},,,{|| .T.})

Return

User Function XREEEX()

	FWExecView("EXCLUIR",'STVISI03', MODEL_OPERATION_DELETE, , {|| .T. },{|| .T.},,,{|| .T.})

Return

User Function XREEVI()

	FWExecView("VISUALIZAR",'STVISI03', MODEL_OPERATION_VIEW, , {|| .T. },{|| .T.},,,{|| .T.})

Return


Static Function STVISI12( oModel )

	Local lRet			:= .T.
	Local _cQuery 	:= ""
	Local _cQuery1 	:= ""
	Local _cAlias		:= ""
	Local _cAlias1	:= ""
	Local _cEmail    	:= ""
	Local _cCopia   	:= ""
	Local _cAssunto 	:= ""
	Local cMsg	    	:= ""
	Local cAttach   	:= ""
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ""
	Local n 			:= 0
	Local lCont 		:= .f.

	Local oModel 	:= FwModelActive()
	Local oModel := oModel:GetModel('REGISTRO')

	_cAlias1 := GetNextAlias()
	_cQuery1 := " SELECT * FROM "+RetSqlName("SA3")+" SA3 "
	_cQuery1 += " WHERE SA3.A3_COD = '"+Z1R->Z1R_VEND+"' "
	_cQuery1 += " AND SA3.D_E_L_E_T_ = ' ' "

	If Select(_cAlias1) > 0
		(_cAlias1)->(dbCloseArea())
	EndIf

	_cQuery1 := ChangeQuery(_cQuery1)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	_cEmail	  := (_cAlias1)->A3_EMAIL

	_cAssunto := 'Feedback Gestão - Visitas Steck'

	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>Feedback Gestão - Visitas Steck</FONT> </Caption>'
	cMsg += '<TR><B><TD>Num. Visita</TD><TD>Data Visita</TD><TD>COD CLIENTE</TD><TD>Loja</TD><TD>Nome</TD><TD>Feedback</TD><TD>Data Feedback</TD></B></TR>'

	For n := 1 to Len(oModel:aCols)

		If oModel:aCols[n][15] = dDataBase

			cMsg += '<TR BgColor=#B0E2FF>'

			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + oModel:aCols[n][02]+ ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + Dtoc(oModel:aCols[n][03]) + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + oModel:aCols[n][11] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + oModel:aCols[n][12] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + POSICIONE("SA1", 1, xFilial("SA1") + oModel:aCols[n][11]+oModel:aCols[n][12], "A1_NOME") + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + oModel:aCols[n][14] + '</Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + Dtoc(oModel:aCols[n][15]) + '</Font></TD>'
			cMsg += '</TR>'

			lCont := .T.
		EndIf

	Next n

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(STVISI12)</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'


	If lCont

		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			MsgInfo("Problemas no envio de email!")
		EndIf

	EndIf

Return lRet



User Function STZ1SVAL()

	DbSelectArea("Z1S")
	Z1S->(DbGoTop())
	Z1S->(DbSetOrder(2))
	If Z1S->(DbSeek(xFilial("Z1S")+M->Z1S_CLIENT+M->Z1S_LOJA))
		MsgInfo("Cliente ja Cadastrado.......!!!!!")
	EndIf
	
Return (.F.)


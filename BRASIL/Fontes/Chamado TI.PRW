#include 'PROTHEUS.CH'
#include 'TOPCONN.CH'

#DEFINE DS_MODALFRAME 128
#DEFINE CR    chr(13)+chr(10)
#Define URLWS	'http://atendimento.steck.com.br'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ST_ChamaTIºAutor  |Renato Nogueira     º Data ³  17/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para abrir chamados de TI							  º±±
±±º          ³			                           					      º±±
±±º          ³    									  				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 		                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ST_ChamaTI
	Local  aCores := { {"SZ0->Z0_STATUS == '1'", "BR_VERDE"},;
		{"SZ0->Z0_STATUS == '2'", "BR_VERMELHO"},;
		{"SZ0->Z0_STATUS == '3'", "BR_AZUL"},;
		{"SZ0->Z0_STATUS == '4'", "BR_CINZA"},;
		{"SZ0->Z0_STATUS == '5'", "BR_BRANCO"},;
		{"SZ0->Z0_STATUS == '6'", "BR_PINK"},;
		{"SZ0->Z0_STATUS == '7'", "BR_LARANJA"},;
		{"SZ0->Z0_STATUS == '8'", "BR_PRETO"},;
		{"SZ0->Z0_STATUS == '9'", "BR_AMARELO"},;
		{"SZ0->Z0_STATUS == 'X'", "BR_MARROM"};
		}

	Private cCadastro := "Chamados de TI"
	Private aRotina   := MenuDef()

	Private cDelFunc := ".T."	// Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cAlias   := "SZ0"

	Public _xChamaTI:= AllTrim(UsrRetName(__cUserId))

	SZ0->(dbSetOrder(1))

	If	(__cUserId $  GetMv("ST_SZ001",,"000415/000402/000421"))
		SZ0->(dbSetFilter({|| SZ0->Z0_USUARIO =  _xChamaTI .oR. SZ0->Z0_APROV = '000402' },'SZ0->Z0_USUARIO =  _xChamaTI .oR. SZ0->Z0_APROV = "000402"  '))
	ElseIf	(__cUserId $  GetMv("ST_SZ002",,"000527"))
		SZ0->(dbSetFilter({|| alltrim(SZ0->Z0_USUARIO) $  "augusto.medolago/ewerton.souza/fernando.torres/juliana.queiroz/silvia.carlos/susan.paiva/simone.paula" .oR. SZ0->Z0_APROV = "000527" },' Alltrim(SZ0->Z0_USUARIO) $ "augusto.medolago/ewerton.souza/fernando.torres/juliana.queiroz/silvia.carlos/susan.paiva/simone.paula" .oR. SZ0->Z0_APROV = "000527" '))
	ElseIf 	!(__cUserId $  GetMv("ST_SZ0",,"000000/000009/000645/001036/000342/000010"))
		SZ0->(dbSetFilter({|| SZ0->Z0_USUARIO =  _xChamaTI .oR. SZ0->Z0_APROV = __cUserId },'SZ0->Z0_USUARIO =  _xChamaTI .oR. SZ0->Z0_APROV = __cUserId  '))
	EndIF

	mBrowse(6, 1, 22, 105, cAlias,,,,,,aCores)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ TIAltera  ³ Autor ³ ERO    				³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Altera o chamado de TI.                                      ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TIAltera(cAlias, nReg, nOpc)

	Local _MEMO    := " "
	Local aArea    := GetArea()
	Local aAreaSZ0 := SZ0->(GetArea())
	Local aButtons := {}
	Local lRet	   := .F.

	aAdd(aButtons,{"PMSSETAUP",{|| STDISPHML()},"Disp. em homol","Disp. em homol"})
	aAdd(aButtons,{"PMSSETAUP",{|| STUPIMG()  },"Anexar Arquivo"  ,"Anexar Arquivo"})

	DO CASE
	CASE SZ0->Z0_STATUS = "1"
		If AllTrim(SZ0->Z0_USUARIO) == AllTrim(UsrRetName(__cUserId))
			lRet	:= .T.
		EndIf
	CASE SZ0->Z0_STATUS $ "3#4"
		If AllTrim(__cUserId) == AllTrim(SZ0->Z0_ANALIST)
			lRet	:= .T.
		EndIf
	ENDCASE

	If !lRet
		MsgAlert("Este chamado não pode ser alterado")
		Return
	EndIf

	If __cUserId == AllTrim(SZ0->Z0_ANALIST) .And. SZ0->Z0_STATUS="3"
		If MsgYesNo("Deseja alterar o status para em desenvolvimento?")

			SZ0->(RecLock("SZ0", .F.))
			SZ0->Z0_STATUS := "4"	//Em desenvolvimento
			SZ0->(MsUnlock())

			STGRVHIST(SZ0->Z0_FILIAL,SZ0->Z0_NUM,SZ0->Z0_STATUS,__cUserId)

		EndIf
	EndIf

	nOpca := 0
	nOpca := AxAltera(cAlias, nReg, nOpc, , , , , ".T.",,,aButtons)

	RestArea(aAreaSZ0)
	RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ TICancela ³ Autor ³ ERO    				³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Cancela o chamado de TI.                                     ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TICancela()

	If SZ0->Z0_STATUS $ "12345" .And. (__cUserId=="000000" .Or. __cUserId==SZ0->Z0_APROV)

		If MsgYesNo("Deseja cancelar o chamado:"+SZ0->Z0_NUM)

			SZ0->(RecLock("SZ0", .F.))
			SZ0->Z0_DTENC  := dDataBase
			SZ0->Z0_HRENC  := SubStr(Time(), 1, 5)
			SZ0->Z0_STATUS := "9"	// Cancelado
			SZ0->(MsUnlock())

			STGRVHIST(SZ0->Z0_FILIAL,SZ0->Z0_NUM,SZ0->Z0_STATUS,__cUserId)

		EndIf

	Else

		Alert("Este chamado não pode ser cancelado, chame o Administrador!")
		Return

	EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ TIEncerra ³ Autor ³ ERO                    ³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Encerra o chamado de TI.                                     ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TIEncerr()

	Local dEncTI  := dDataBase
	Local cHoraTI := SubStr(Time(), 1, 5)
	Local lResp   := .F.
	Local oDlgEnc, oSay1, oGetData, oSay3, oGetHora, oGrp5, oSBtn7, oBtnCancel
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := 'Novo chamado ERP'
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local aUsuario  := {}
	PswOrder(1)
	/*
	If Empty(SZ0->ZO_HRTOTAL)
	MsgAlert("Solicite ao analista que preencha a quantidade de horas de atendimento!")
	Return
	EndIf
	*/
	If PswSeek(Alltrim(SZ0->Z0_ALTPRD), .T. )
		aUsuario := PSWRET() // Retorna vetor com informações do usuário
	EndIf

	If SZ0->Z0_STATUS = "7" .And. __cUserId==aUsuario[1][1]

		If MsgYesNo("Deseja encerrar o chamado número "+SZ0->Z0_NUM+"?")

			SZ0->(RecLock("SZ0", .F.))
			SZ0->Z0_DTENC  := Date()//dEncTI
			SZ0->Z0_HRENC  := Time()//cHoraTI
			SZ0->Z0_STATUS := "8"	// Encerrado
			SZ0->(MsUnlock())

			STGRVHIST(SZ0->Z0_FILIAL,SZ0->Z0_NUM,SZ0->Z0_STATUS,__cUserId)

			PswOrder(2)

			If PswSeek(Alltrim(SZ0->Z0_USUARIO), .T. )
				aUsuario := PSWRET() // Retorna vetor com informações do usuário
			EndIf

			_cEmail	  := aUsuario[1,14]

			_cAssunto := 'O chamado ERP - '+SZ0->Z0_NUM+' - foi aplicado com sucesso em produção'
			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>Solicitante: </b>'+Alltrim(SZ0->Z0_USUARIO)+'<br><b>Descrição: </b>'+SZ0->Z0_OBS+'</body></html>'

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		EndIf

	Elseif SZ0->Z0_STATUS <> "7"

		MsgAlert("Atenção, o chamado não está com status de aprovado pelo usuário!")
		Return

	Elseif __cUserId<>aUsuario[1][1]

		MsgAlert("Atenção, você não é o analista responsável por colocar em produção!")
		Return

	EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ TILegenda ³ Autor ³ ERO 					³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Exibe as legendas do browse.                                 ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TILegenda()

	BrwLegenda(cCadastro, "Legenda", {	{"BR_VERDE"   , "Aguardando Aprov. Superv." },;
		{"BR_VERMELHO","Aprovado Supervisor"},;
		{"BR_AZUL","Aprovado para desenvolvimento"},;
		{"BR_CINZA","Em desenvolvimento"},;
		{"BR_BRANCO","Aguardando aceite usuário"},;
		{"BR_PINK","Aprovado pelo usuário"},;
		{"BR_LARANJA","Liberado p/ Amb. Produção"},;
		{"BR_PRETO", "Chamado Concluído"},;
		{"BR_MARROM", "Cancelado por falta de interação"},;
		{"BR_AMARELO" , "Chamado Cancelado"}  })

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ STSZ0INC  ³ Autor ³ ERO 					³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Inclusão de novo chamado                                     ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STSZ0INC(cAlias,nReg,nOpc)

	Local nOpcao    := 0
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := 'Novo chamado ERP'
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _aGrupos
	Local _lRet		:= .T.
	Local nI
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local cQuery2 	:= ""
	Local cAlias2 	:= "QRYTEMP2"
	Local cQuery2 	:= ""
	Local cAlias3 	:= "QRYTEMP3"
	Local cQuery4 	:= ""
	Local cAlias4 	:= "QRYTEMP4"
	Local _cErro	:= 0

	If __cUserId=="000000"
		MsgAlert("Usuário Administrador não pode incluir chamados!")
		Return(Nil)
	EndIf

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf

	cQuery1	 := " SELECT * "
	cQuery1  += " FROM " +RetSqlName("ZZE")+ " ZZE "
	cQuery1  += " WHERE ZZE.D_E_L_E_T_=' ' AND ZZE_GRPSOL LIKE '%"+_aGrupos[1][10][1]+"%' "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If Empty((cAlias1)->ZZE_CODIGO)
		_lRet	:= .F.
		_cErro	:= 0 //Usuário não está cadastrado na tabela
	EndIf

	cQuery2	:=  " SELECT COUNT(*) CONTADOR "
	cQuery2  += " FROM " +RetSqlName("ZZE")+ " ZZE "
	cQuery2  += " WHERE ZZE.D_E_L_E_T_=' ' AND ZZE_GRPSOL LIKE '%"+_aGrupos[1][10][1]+"%' "

	If !Empty(Select(cAlias2))
		DbSelectArea(cAlias2)
		(cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlias2,.T.,.T.)

	dbSelectArea(cAlias2)
	(cAlias2)->(dbGoTop())

	If (cAlias2)->CONTADOR>1
		_lRet	:= .F.
		_cErro	:= 2 //Usuário está amarrado com mais de um aprovador
	EndIf

	cQuery3	:=  " SELECT COUNT(*) CONTADOR "
	cQuery3  += " FROM " +RetSqlName("SZ0")+ " Z0 "
	cQuery3  += " WHERE Z0.D_E_L_E_T_=' ' AND Z0_STATUS='5' AND Z0_USUARIO='"+cUserName+"' "

	If !Empty(Select(cAlias3))
		DbSelectArea(cAlias3)
		(cAlias3)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),cAlias3,.T.,.T.)

	dbSelectArea(cAlias3)
	(cAlias3)->(dbGoTop())

	If (cAlias3)->CONTADOR>=1
		_lRet	:= .F.
		_cErro	:= 3 //Usuário com chamado pendente de interação
	EndIf

	If _lRet

		MsgInfo("Atenção!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
			"Ao abrir um chamado procure detalhar a situação o máximo possível,"+Chr(13)+Chr(10)+;
			"colocando em detalhes o ocorrido e descrevendo com clareza o que"+Chr(13)+Chr(10)+;
			"você precisa que seja feito."+Chr(13)+Chr(10)+;
			" "+Chr(13)+Chr(10)+;
			"O que sempre preencher no chamado:"+Chr(13)+Chr(10)+;
			" "+Chr(13)+Chr(10)+;
			"- Nome e caminho da rotina"+Chr(13)+Chr(10)+;
			"- Caso seja algum erro ou bloqueio, enviar a mensagem que estiver aparecendo"+Chr(13)+Chr(10)+;
			"- Descrever passo a passo a operação que está sendo realizada"+Chr(13)+Chr(10)+;
			"- O que exatamente deve ser corrigido ou criado"+Chr(13)+Chr(10)+;
			" "+Chr(13)+Chr(10)+;
			"Agradecemos a colaboração.")

		nOpcao     := AxInclui(cAlias,nReg,nOpc)
		Altera     := lAltera     :=     .F.
		Inclui     := lInclui     :=     .T.

		If nOpcao == 1

			_cEmail	  := (cAlias1)->ZZE_EMAIL

			_cNum := U_STTEC020()

			SZ0->(RecLock("SZ0",.F.))
			SZ0->Z0_NUM := _cNum
			SZ0->(MsUnLock())

			_cAssunto := 'Novo chamado ERP - '+SZ0->Z0_NUM+' - Aguardando aprovação'
			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>Solicitante: </b>'+Alltrim(SZ0->Z0_USUARIO)+'<br><b>Descrição: </b>'+SZ0->Z0_OBS+'</body></html>'

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			SZ0->(Reclock("SZ0",.F.))
			SZ0->Z0_STATUS	:= "1"
			SZ0->Z0_APROV	:= (cAlias1)->ZZE_APROV
			SZ0->(Msunlock())

			STGRVHIST(SZ0->Z0_FILIAL,SZ0->Z0_NUM,SZ0->Z0_STATUS,__cUserId)

			If MsgYesNo("Deseja inserir um anexo no chamado?")
				STUPIMG()
			EndIf

		EndIf

	Elseif !_lRet .And. _cErro==0

		MsgInfo("Atenção, seu usuário não está cadastrado como solicitante, entre em contato com o T.I.","Erro")
		Return(Nil)

	Elseif !_lRet .And. _cErro==2

		MsgInfo("Atenção, seu usuário está amarrado em mais de um aprovador, entre em contato com o T.I.","Erro")
		Return(Nil)

	Elseif !_lRet .And. _cErro==3

		MsgInfo("Atenção, seu usuário já possui chamados em aberto pendentes, faça a interação nestes chamados para abrir um novo","Erro")
		Return(Nil)

	EndIf

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ TIAltera  ³ Autor ³ ERO    				³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Altera o chamado de TI.                                      ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AprovCham()

	Local cST_GESTTI	:= SuperGetMV("ST_GESTTI",,"")
	Local aUsuario
	Local _cEmail   	:= ""
	Local _cCopia   	:= ""
	Local _cAssunto 	:= 'Novo chamado ERP'
	Local cMsg	    	:= ""
	Local cAttach   	:= ''
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	Local cGetCod		:=  space(6)
	Local cGetMot		:=  space(100)
	Local lSaida		:= .F.

	//aUsuario	:= PswRet()

	PswOrder(1)

	If PswSeek(cST_GESTTI, .T. )
		aUsuario := PSWRET() // Retorna vetor com informações do usuário
	EndIf

	//Verificar se o status está aguardando aprovação do supervisor ou do gestor de TI

	If SZ0->Z0_STATUS == "1" //Aprovação do supervisor

		If __cUserId == SZ0->Z0_APROV

			If MsgYesNo("Deseja aprovar o chamado número: "+SZ0->Z0_NUM)

				SZ0->(Reclock("SZ0",.F.))
				SZ0->Z0_STATUS	:= "2"
				SZ0->(Msunlock())

				_cEmail	  := aUsuario[1,14]

				_cAssunto := 'Novo chamado ERP - '+SZ0->Z0_NUM+' - aprovado pelo supervisor'
				cMsg := ""
				cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
				cMsg += '<b>Solicitante: </b>'+Alltrim(SZ0->Z0_USUARIO)+'<br><b>Descrição: </b>'+SZ0->Z0_OBS+'</body></html>'

				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

				STGRVHIST(SZ0->Z0_FILIAL,SZ0->Z0_NUM,SZ0->Z0_STATUS,__cUserId)

				MsgInfo("Chamado aprovado com sucesso","OK")

			EndIf

		Else

			MsgAlert("Atenção, você não é o aprovador deste chamado, verifique!")

		EndIf

	ElseIf SZ0->Z0_STATUS == "2" //Aprovação do gestor de TI

		If __cUserId == cST_GESTTI

			//If MsgYesNo("Deseja aprovar o chamado número: "+SZ0->Z0_NUM)

			SZ0->(Reclock("SZ0",.F.))
			SZ0->Z0_STATUS	:= "3"
			SZ0->(Msunlock())

			STGRVHIST(SZ0->Z0_FILIAL,SZ0->Z0_NUM,SZ0->Z0_STATUS,__cUserId)

			While !lSaida

				Define msDialog oDlg Title "Alocar analista" From 10,10 TO 20,45 Style DS_MODALFRAME

				@ 000,001 Say "Analista: " Pixel Of oDlg
				@ 010,003 ComboBox cGetCod  ITEMS  {"000009","000010","000342","000645","001036"  }  valid   AllTrim(cGetCod)$GetMv("ST_USERSTI") size 60,10    pixel OF oDlg

				DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION IF(!empty(cGetCod),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Parametro em Branco","Atenção")) ENABLE OF oDlg

				Activate dialog oDlg centered

			End

			If nOpcao = 1

				SZ0->(Reclock("SZ0",.F.))
				SZ0->Z0_ANALIST	:= cGetCod
				SZ0->(Msunlock())

				PswOrder(1)

				If PswSeek(cGetCod, .T. )
					aUsuario := PSWRET() // Retorna vetor com informações do usuário
				EndIf

				_cEmail	  := aUsuario[1,14]

				_cAssunto := 'Novo chamado ERP - '+SZ0->Z0_NUM+' - aprovado pelo gestor de TI'
				cMsg := ""
				cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
				cMsg += '<b>Solicitante: </b>'+Alltrim(SZ0->Z0_USUARIO)+'<br><b>Descrição: </b>'+SZ0->Z0_OBS+'</body></html>'

				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			EndIf

		Else

			MsgAlert("Atenção, você não é o aprovador deste chamado, verifique!")

		EndIf

	ElseIf SZ0->Z0_STATUS == "5" //Aprovação do usuário

		PswOrder(2)

		If PswSeek(Alltrim(SZ0->Z0_USUARIO), .T. )
			aUsuario := PSWRET() // Retorna vetor com informações do usuário
		EndIf

		If __cUserId == aUsuario[1][1]

			If MsgYesNo("O chamado "+SZ0->Z0_NUM+" foi solucionado com sucesso?")

				SZ0->(Reclock("SZ0",.F.))
				SZ0->Z0_STATUS	:= "6"
				SZ0->Z0_ACEITE 	:= "S"
				SZ0->(Msunlock())

				STGRVHIST(SZ0->Z0_FILIAL,SZ0->Z0_NUM,SZ0->Z0_STATUS,__cUserId)

				PswOrder(1)

				If PswSeek(cST_GESTTI, .T. )
					aUsuario := PSWRET() // Retorna vetor com informações do usuário
				EndIf

				_cEmail	  := aUsuario[1,14]

				PswOrder(1)

				If PswSeek(SZ0->Z0_ANALIST, .T. )
					aUsuario := PSWRET() // Retorna vetor com informações do usuário
				EndIf

				_cEmail	  := _cEmail+";"+aUsuario[1,14]

				_cAssunto := 'O chamado ERP - '+SZ0->Z0_NUM+' - aprovado pelo usuário'
				cMsg := ""
				cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
				cMsg += '<b>Solicitante: </b>'+Alltrim(SZ0->Z0_USUARIO)+'<br><b>Descrição: </b>'+SZ0->Z0_OBS+'</body></html>'

				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			Else

				MsgAlert("Atenção, o chamado não foi aceito, por favor digite o motivo na próxima tela!")

				While !lSaida

					Define msDialog oDlg Title "Observação não aceite!" From 10,10 TO 20,65 Style DS_MODALFRAME

					@ 000,001 Say "Motivo: " Pixel Of oDlg
					@ 010,003 MsGet cGetMot valid !empty(cGetMot) size 200,10 Picture "@!" pixel OF oDlg

					DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION IF(!empty(cGetMot),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Parametro em Branco","Atenção")) ENABLE OF oDlg

					Activate dialog oDlg centered

				End

				If nOpcao = 1

					cGetMot	:= Alltrim(cGetMot)+" - "+DTOC(DDATABASE)+" [] "

					SZ0->(Reclock("SZ0",.F.))
					SZ0->Z0_STATUS		:= "4"
					SZ0->Z0_ACEITE 		:= "N"
					//SZ0->Z0_HRTOTAL 	:= ""
					//MSMM(SZ0->Z0_NUM,,,cGetMot,1,,,"SZ0","Z0_NAOACEI",,.T.)
					SZ0->Z0_NAOACEI		:= cGetMot
					SZ0->(Msunlock())

					STGRVHIST(SZ0->Z0_FILIAL,SZ0->Z0_NUM,SZ0->Z0_STATUS,__cUserId)

					PswOrder(1)

					If PswSeek(SZ0->Z0_ANALIST, .T. )
						aUsuario := PSWRET() // Retorna vetor com informações do usuário
					EndIf

					_cEmail	  := aUsuario[1,14]

					_cAssunto := 'O chamado ERP - '+SZ0->Z0_NUM+' - não foi aprovado pelo usuário'
					cMsg 	  := ""
					cMsg	  := "Observação: "+cGetMot

					U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

				EndIf

			EndIf

		Else

			MsgAlert("Atenção, você não é o solicitante desse chamado, verifique!")

		EndIf

	ElseIf SZ0->Z0_STATUS == "6" //Ultima aprovação do gestor

		If __cUserId == cST_GESTTI

			//If MsgYesNo("Deseja aprovar para produção o chamado número: "+SZ0->Z0_NUM)

			SZ0->(Reclock("SZ0",.F.))
			SZ0->Z0_STATUS	:= "7"
			SZ0->(Msunlock())

			STGRVHIST(SZ0->Z0_FILIAL,SZ0->Z0_NUM,SZ0->Z0_STATUS,__cUserId)
			cGetCod:= '000009'
			If SZ0->Z0_ANALIST = '000009'
				cGetCod:= '001036'
			Else
				cGetCod:= '000009'
			EndIf
			nOpcao := 1

			If nOpcao = 1

				SZ0->(Reclock("SZ0",.F.))
				SZ0->Z0_ALTPRD	:= cGetCod
				SZ0->(Msunlock())

			EndIf

			PswOrder(1)

			If PswSeek(SZ0->Z0_ALTPRD, .T. )
				aUsuario := PSWRET() // Retorna vetor com informações do usuário
			EndIf

			_cEmail	  := aUsuario[1,14]

			_cAssunto := 'O chamado ERP - '+SZ0->Z0_NUM+' - foi aprovado pelo gestor para colocar em produção'
			cMsg 	  := ""
			cMsg	  := "Observação: "+cGetMot

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		Else

			MsgAlert("Atenção, você não é o gestor de TI para aprovar esse chamado, verifique!")

		EndIf

	Else

		MsgAlert("Atenção, este chamado ainda não pode ser aprovado, verifique!")

	EndIf

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ STGRVHIST ³ Autor ³ 	 					³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Grava status do chamado.	                                  ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function STGRVHIST(_cFilial,_cNum,_cStatus,_cCodUsuario)

	Local _aArea     := GetArea()

	dbSelectArea("ZZF")
	ZZF->(DbSetOrder(1))
	ZZF->(DbGoTop())

	ZZF->(Reclock("ZZF",.T.))

	ZZF->ZZF_FILIAL	:=	xFilial("ZZF")
	ZZF->ZZF_NUM	:=	_cNum
	ZZF->ZZF_STATUS	:=	_cStatus
	ZZF->ZZF_CODUSR	:=	_cCodUsuario
	ZZF->ZZF_DTSOLI	:=	DDATABASE
	ZZF->ZZF_HRSOLI	:=	SUBSTR(TIME(),1,5)

	ZZF->(Msunlock())

	RestArea(_aArea)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ STDISPHML ³ Autor ³ 	 					³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Grava status do chamado.	                                  ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function STDISPHML()

	Local aUsuario	:= {}
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := 'Novo chamado ERP'
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''

	If SZ0->Z0_STATUS=="4" .And. __cUserId==AllTrim(SZ0->Z0_ANALIST) .And. !Empty(M->Z0_SOLUCAO) .And. !Empty(M->Z0_ROTINA) .And. !Empty(M->Z0_HRTOTAL) .And. !Empty(M->Z0_PROCEDE)

		If MsgYesNo("Confirma disponibilização do processo no ambiente de homologação?")

			SZ0->(Reclock("SZ0",.F.))
			SZ0->Z0_STATUS	:= "5"
			M->Z0_STATUS	:= "5"
			SZ0->Z0_DTENTRE	:= DDATABASE
			M->Z0_DTENTRE	:= DDATABASE
			SZ0->(Msunlock())

			STGRVHIST(SZ0->Z0_FILIAL,SZ0->Z0_NUM,SZ0->Z0_STATUS,__cUserId)

			PswOrder(2)

			If PswSeek(Alltrim(SZ0->Z0_USUARIO), .T. )
				aUsuario := PSWRET() // Retorna vetor com informações do usuário
			EndIf

			_cEmail	  := aUsuario[1,14]

			_cAssunto := 'Chamado ERP: '+SZ0->Z0_NUM+' - disponível para testes no ambiente - '+M->Z0_RPOHML
			cMsg 	  := ""
			cMsg	  := "Descrição: "+M->Z0_SOLUCAO

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			MsgInfo("O status do chamado e o e-mail foram atualizados com sucesso","Sucesso!")

		EndIf

	ElseIf __cUserId<>AllTrim(SZ0->Z0_ANALIST)

		MsgAlert("Atenção, você não é o analista deste chamado!")

	ElseIf SZ0->Z0_STATUS<>"4"

		MsgAlert("Atenção, este chamado não está em desenvolvimento!")

	ElseIf Empty(M->Z0_SOLUCAO) .Or. Empty(M->Z0_ROTINA)

		MsgAlert("Atenção, preencha a solução e a rotina!")

	ElseIf Empty(M->Z0_HRTOTAL)

		MsgAlert("Atenção, preencha a quantidade de horas!")

	ElseIf Empty(M->Z0_PROCEDE)

		MsgAlert("Atenção, preencha se o chamado procede ou não!")

	EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ STUPIMG   ³ Autor ³ 	 					³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Subir imagem no servidor	                                  ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function STUPIMG()

	Local _lRet	:= .T.

	_cRet := cGetFile("Arquivos Imagem (*.BMP) |*.bmp|";
		+"Arquivos Imagem (*.JPG) |*.jpg|"+"Arquivos Texto (*.TXT) |*.txt|"+"Planilhas (*.XLS) |*.xls|"+;
		"Planilhas (*.XLSX) |*.xlsx|"+"Arquivos PDF (*.PDF) |*.pdf|"+"Arquivos ZIP (*.ZIP) |*.zip|"+"Arquivos DOC (*.DOC) |*.doc|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	_cRet := ALLTRIM(_cRet)

	If "xlsx" $ Alltrim(_cRet) .Or. "docx" $ Alltrim(_cRet)
		cExtensao	:= right(Alltrim(_cRet),5)
	Else
		cExtensao	:= right(Alltrim(_cRet),4)
	EndIf

	/*
	cTamanho := DIRECTORY(_cRet)[1,2]

	If cTamanho/1024 > 1024
	_lRet	:= .F.
	MsgStop("Atenção, o arquivo pode ter no máximo 1MB")
	Return
	EndIf
	*/

	MakeDir("\img_chamados\")

	lCompacta := .T.
	lSucess := __CopyFile(_cRet,"\img_chamados\"+Alltrim(SZ0->Z0_NUM)+cExtensao)

	If lSucess
		MsgInfo("Cópia efetuada com sucesso para o servidor!","OK")
	Else
		Alert("Falha na cópia")
	EndIf

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ ViewImg   ³ Autor ³ 	 					³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Visualizar imagem      	                                  ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ViewImg(cImage)

	Local oDlg
	Local cStartPath  := GetSrvProfString("Rootpath","")
	Local cPath    := GETTEMPPATH()

	aArquivo	:= DIRECTORY("\img_chamados\*"+Alltrim(SZ0->Z0_NUM)+"*.*")

	aArquivo	:= aSort(aArquivo,,,{|x,y| DTOS(x[3])+x[4] > DTOS(y[3])+y[4]})

	If len(aArquivo)>0

		_cArquivo	:= aArquivo[1][1]
		nRet		:= At(".",_cArquivo)
		cExtensao	:= Upper(SubStr(_cArquivo,nRet+1))

		__CopyFile('\img_chamados\'+Alltrim(SZ0->Z0_NUM)+'.'+cExtensao,cPath+Alltrim(SZ0->Z0_NUM)+'.'+cExtensao)

		DO CASE

		CASE cExtensao="BMP" .Or. cExtensao="JPG"

			WinExec('MsPaint.exe '+cPath+Alltrim(SZ0->Z0_NUM)+'.'+cExtensao)

		CASE cExtensao="TXT"

			WinExec('Notepad.exe '+cPath+Alltrim(SZ0->Z0_NUM)+'.'+cExtensao)

		CASE cExtensao="DOC"

			WinExec('explorer.exe '+cPath+Alltrim(SZ0->Z0_NUM)+'.'+cExtensao)

		CASE cExtensao="DOCX"

			WinExec('explorer.exe '+cPath+Alltrim(SZ0->Z0_NUM)+'.'+cExtensao)

		CASE cExtensao="PDF"

			WinExec('explorer.exe '+cPath+Alltrim(SZ0->Z0_NUM)+'.'+cExtensao)

		CASE cExtensao="XLS"

			WinExec('explorer.exe '+cPath+Alltrim(SZ0->Z0_NUM)+'.'+cExtensao)

		CASE cExtensao="XLSX"

			WinExec('explorer.exe '+cPath+Alltrim(SZ0->Z0_NUM)+'.'+cExtensao)

		CASE cExtensao="ZIP"

			WinExec('explorer.exe '+cPath+Alltrim(SZ0->Z0_NUM)+'.'+cExtensao)

		ENDCASE

	Else

		MsgAlert("Não existe anexo no chamado")

	EndIf

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ TIFilter   ³ Autor ³ 	 					³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Realizar um filtro por status e analista                     ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TIFilter()

	Local _aRet 		:= {}
	Local _aParamBox 	:= {}
	Local _cFiltro		:= ""
	Local oBrowse 		:= GetMBrowse()
	Local aCores := { {"SZ0->Z0_STATUS == '1'", "BR_VERDE"},;
		{"SZ0->Z0_STATUS == '2'", "BR_VERMELHO"},;
		{"SZ0->Z0_STATUS == '3'", "BR_AZUL"},;
		{"SZ0->Z0_STATUS == '4'", "BR_CINZA"},;
		{"SZ0->Z0_STATUS == '5'", "BR_BRANCO"},;
		{"SZ0->Z0_STATUS == '6'", "BR_PINK"},;
		{"SZ0->Z0_STATUS == '7'", "BR_LARANJA"},;
		{"SZ0->Z0_STATUS == '8'", "BR_PRETO"},;
		{"SZ0->Z0_STATUS == '9'", "BR_AMARELO"}}

	Private cCadastro := "Chamados de TI"
	Private aRotina   := MenuDef()

	Private cDelFunc := ".T."	// Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cAlias   := "SZ0"

	SZ0->(dbSetOrder(1))

	AADD(_aParamBox,{5,"Aguardando Aprov. Superv.",.F.,500,"",.F.})
	AADD(_aParamBox,{5,"Aprovado Supervisor",.F.,500,"",.F.})
	AADD(_aParamBox,{5,"Aprovado para desenvolvimento",.F.,500,"",.F.})
	AADD(_aParamBox,{5,"Em desenvolvimento",.F.,500,"",.F.})
	AADD(_aParamBox,{5,"Aguardando aceite usuário",.F.,500,"",.F.})
	AADD(_aParamBox,{5,"Aprovado pelo usuário",.F.,500,"",.F.})
	AADD(_aParamBox,{5,"Liberado p/ Amb. Produção",.F.,500,"",.F.})
	AADD(_aParamBox,{5,"Chamado concluído",.F.,500,"",.F.})
	AADD(_aParamBox,{5,"Chamado cancelado",.F.,500,"",.F.})
	AADD(_aParamBox,{1,"Analista",Space(6),"","","USR","",0,.F.})

	If ParamBox(_aParamBox,"Filtro de chamados                      ",@_aRet,,,.T.,,500)

		_cFiltro	+= "( Z0_STATUS == '0' "

		If _aRet[1]
			_cFiltro	+= " .Or. Z0_STATUS == '1' "
		EndIf
		If _aRet[2]
			_cFiltro	+= " .Or. Z0_STATUS == '2' "
		EndIf
		If _aRet[3]
			_cFiltro	+= " .Or. Z0_STATUS == '3' "
		EndIf
		If _aRet[4]
			_cFiltro	+= " .Or. Z0_STATUS == '4' "
		EndIf
		If _aRet[5]
			_cFiltro	+= " .Or. Z0_STATUS == '5' "
		EndIf
		If _aRet[6]
			_cFiltro	+= " .Or. Z0_STATUS == '6' "
		EndIf
		If _aRet[7]
			_cFiltro	+= " .Or. Z0_STATUS == '7' "
		EndIf
		If _aRet[8]
			_cFiltro	+= " .Or. Z0_STATUS == '8' "
		EndIf
		If _aRet[9]
			_cFiltro	+= " .Or. Z0_STATUS == '9' "
		EndIf

		_cFiltro	+= " ) "

		If !Empty(_aRet[10])
			_cFiltro	+= " .And. ( Alltrim(Z0_ANALIST) == '"+Alltrim(_aRet[10])+"' ) "
		EndIf

		DbSelectArea(cAlias)
		Set Filter To
		(cAlias)->(dbGoTop())
		Set Filter To &(_cFiltro)
		(cAlias)->(dbGoTop())

	EndIf

	oBrowse:SetFilterDefault(_cFiltro)

Return()

Static Function MenuDef()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Array contendo as Rotinas a executar do programa      ³
	//³ ----------- Elementos contidos por dimensao ------------     ³
	//³ 1. Nome a aparecer no cabecalho                              ³
	//³ 2. Nome da Rotina associada                                  ³
	//³ 3. Usado pela rotina                                         ³
	//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
	//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
	//³    2 - Simplesmente Mostra os Campos                         ³
	//³    3 - Inclui registros no Bancos de Dados                   ³
	//³    4 - Altera o registro corrente                            ³
	//³    5 - Remove o registro corrente do Banco de Dados          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local  aRotina   := {	{"Pesquisar" , "AxPesqui"   , 0, 1},;
		{"Visualizar", "AxVisual"   , 0, 2},;
		{"Incluir"   , "U_STNEWMOV" , 0, 3},;
		{"Alterar"   , "U_TIAltera" , 0, 4},;
		{"Encerrar"  , "U_TIEncerr", 0, 5},;
		{"Cancelar"  , "U_TICancela", 0, 6},;
		{"Aprovar/Reprovar" , "U_AprovCham", 0, 3},;
		{"Legenda"   , "U_TILegenda", 0, 3},;
		{"Anexo"     , "U_ViewImg"  , 0, 3},;
		{"Filtro"    , "U_TIFilter" , 0, 3},;
		{"Alocar"    , "U_STTI0001" , 0, 3},;
		{"Alterar p/ projeto" , "U_STTI0002" , 0, 3},;
		{"Alterar previsão" , "U_STTI0003" , 0, 3},;
		{"Movidesk" , "U_STMOVDESK" , 0, 3};
		}

		//{"Incluir"   , "U_STSZ0INC" , 0, 3},;


Return aRotina

User Function STMOVDESK ()

	ShellExecute( "Open", "%PROGRAMFILES%\Internet Explorer\iexplore.exe", "https://steck.movidesk.com", "C:\", 1 )

Return
/*/{Protheus.doc} STTI0001
@name STTI0001
@type User Function
@desc alocar chamado
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STTI0001()

	Local _cQuery := ""
	Local _cAlias := GetNextAlias()
	Local cDtPrev := STOD(" ")
	Local lSaida  := .F.

	If !(__cUserId $ GetMv("ST_USERSTI"))
		MsgAlert("Atenção, usuário não está parametrizado como analista do TI, verifique!")
		Return
	EndIf

	_cQuery := " SELECT COUNT(*) CONTADOR
	_cQuery += " FROM SZ0010 Z0
	_cQuery += " WHERE Z0.D_E_L_E_T_=' ' AND Z0_STATUS IN ('3','4') AND Z0_ANALIST='"+__cUserId+"' AND Z0_TIPO='C'
	_cQuery += " AND Z0_TERCEIR=' '

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->CONTADOR>0
		MsgAlert("Atenção, você possui chamados em aberto, verifique!")
		Return
	EndIf

	_cQuery := " SELECT *
	_cQuery += " FROM (
	_cQuery += " SELECT *
	_cQuery += " FROM (
	_cQuery += " SELECT *
	_cQuery += " FROM SZ0010 Z0
	_cQuery += " WHERE Z0.D_E_L_E_T_=' ' AND Z0_STATUS='2' AND Z0_TIPO='C'
	_cQuery += " ORDER BY Z0_NUM
	_cQuery += " ) XXX
	_cQuery += " WHERE ROWNUM<=10
	_cQuery += " ) YYY
	_cQuery += " WHERE Z0_NUM='"+SZ0->Z0_NUM+"'

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->(Eof())
		MsgAlert("Atenção, você deve alocar um dos 10 chamados mais antigos, verifique!")
		Return
	EndIf

	If !MsgYesNo("Confirma a alocação do chamado "+SZ0->Z0_NUM+" para o seu usuário?")
		Return
	EndIf

	//Pegar data de previsão
	While !lSaida

		Define msDialog oDlg Title "Previsão" From 10,10 TO 20,45 Style DS_MODALFRAME

		@ 000,001 Say "Previsão: " Pixel Of oDlg
		@ 010,003 MsGet cDtPrev valid (!empty(cDtPrev) .And. cDtPrev>=DDATABASE) size 60,10 Picture "@D" pixel OF oDlg

		DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION IF(!empty(cDtPrev),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Parametro em Branco","Atenção")) ENABLE OF oDlg

		Activate dialog oDlg centered

	End

	If nOpcao = 1

		SZ0->(Reclock("SZ0",.F.))
		SZ0->Z0_STATUS	:= "3"
		SZ0->Z0_ANALIST := __cUserId
		SZ0->Z0_DTTERM  := cDtPrev
		SZ0->(Msunlock())

		_cAssunto := 'O chamado ERP - '+SZ0->Z0_NUM+' está em desenvolvimento'

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Solicitação: </b>'+AllTrim(SZ0->Z0_DESCRI)+'<br>'
		cMsg += '<b>Analista: </b>'+UsrFullName(SZ0->Z0_ANALIST)+'<br>'
		cMsg += '<b>Previsão de entrega: </b>'+DTOC(SZ0->Z0_DTTERM)+'</body></html>'

		PswOrder(2)

		If PswSeek(Alltrim(SZ0->Z0_USUARIO), .T. )
			aUsuario := PSWRET() // Retorna vetor com informações do usuário
		EndIf

		_cCaminho := ""
		_aAttach  := {}
		_cCopia   := ""
		_cEmail	  := aUsuario[1,14]

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		MsgAlert("Chamado alocado com sucesso, boa sorte :)")

	EndIf

Return()

/*/{Protheus.doc} STTI0002
@name STTI0002
@type User Function
@desc alocar chamado
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STTI0002()

	If !(__cUserId $ GetMv("ST_USERSTI"))
		MsgAlert("Atenção, usuário não está parametrizado como analista do TI, verifique!")
		Return
	EndIf

	If !MsgYesNo("Confirma a alteração do chamado "+SZ0->Z0_NUM+" para projeto?")
		Return
	EndIf

	SZ0->(Reclock("SZ0",.F.))
	SZ0->Z0_TIPO	:= "P"
	SZ0->(Msunlock())

	MsgAlert("Chamado alterado com sucesso para projeto, obrigado!")

Return

/*/{Protheus.doc} STTI0003
@name STTI0003
@type User Function
@desc alterar previsão
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STTI0003()

	Local _aRet 		:= {}
	Local _aParamBox 	:= {}

	If !(AllTrim(__cUserId) == AllTrim(SZ0->Z0_ANALIST))
		MsgAlert("Atenção, você não é o analista alocado para este chamado, verifique!")
		Return
	EndIf

	AADD(_aParamBox,{1,"Dt. prevista",STOD(" ")	,"@D","","","",0,.T.})
	AADD(_aParamBox,{1,"Motivo"		 ,Space(200)	,"@!","","","",0,.T.})

	If !ParamBox(_aParamBox,"Alterar previsão",@_aRet,,,.T.,,500)
		Return
	EndIf

	SZ0->(Reclock("SZ0",.F.))
	SZ0->Z0_DTTERM	:= MV_PAR01
	SZ0->(Msunlock())

	_cAssunto := 'O chamado ERP - '+SZ0->Z0_NUM+' teve a previsão de atendimento alterada

	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<b>Solicitação: </b>'+AllTrim(SZ0->Z0_DESCRI)+'<br>'
	cMsg += '<b>Analista: </b>'+UsrFullName(SZ0->Z0_ANALIST)+'<br>'
	cMsg += '<b>Previsão de entrega: </b>'+DTOC(SZ0->Z0_DTTERM)+'<br>'
	cMsg += '<b>Motivo: </b>'+MV_PAR02+'</body></html>'

	PswOrder(2)

	If PswSeek(Alltrim(SZ0->Z0_USUARIO), .T. )
		aUsuario := PSWRET() // Retorna vetor com informações do usuário
	EndIf

	_cCaminho := ""
	_aAttach  := {}
	_cCopia   := ""
	_cEmail	  := aUsuario[1,14]

	U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

	MsgAlert("Previsão alterada com sucesso, obrigado!")

Return

User Function STNEWMOV()

Local cUrl := URLWS

MsgAlert("Por favor para incluir novos chamados acesse o link abaixo, obrigado!"+CR+CR+cUrl)


Return .f.

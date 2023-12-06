#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ARCADSZ3  ºAutor  ³Renato Nogueira     º Data ³  07/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastrar representante x grupos - comissões			      º±±
±±º          ³ 						                 			          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ARCADSZ3()

	Local aRotAdic		:= {}
	Local bNoTTS  		:= {||WFPOSALT(.F.)}

	aadd(aRotAdic,{ "Copiar","U_STCOPSZ3", 0 , 10 })

	Dbselectarea("SZ3")

	_cTitulo := "Cadastro de representante x grupo

	AxCadastro("SZ3",_cTitulo,,,aRotAdic,,,,)

Return(.T.)

/*====================================================================================\
|Programa  | STCOPSZ3        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA COPIAR CADASTRO EXISTENTE	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOPSZ3()

	Local _aParamBox 	:= {}
	Local _aRet 		:= {}
	Local _cQuery1 		:= ""
	Local _cAlias1		:= GetNextAlias()

	AADD(_aParamBox,{1,"Copiar de" ,SZ3->Z3_VENDEDO,"@!","","",".F.",50,.T.})
	AADD(_aParamBox,{1,"Copiar para" ,Space(6),"@!","ExistCpo('SA3')","SA3",".T.",50,.T.})

	If ParamBox(_aParamBox,"Copiar comissões",@_aRet,,,.T.,,500)

		If !MsgYesNo("Confirma cópia dos registros do vendedor "+SZ3->Z3_VENDEDO+" para o vendedor "+MV_PAR02+"?")
			Return
		EndIf

		DbSelectArea("SA3")
		SA3->(DbSetOrder(1))
		SA3->(DbGoTop())
		If !SA3->(DbSeek(xFilial("SA3")+MV_PAR02))
			MsgAlert("Vendedor de destino não encontrado, verifique!")
			Return
		EndIf

		_aArea := GetArea()

		_cQuery1 := " SELECT *
		_cQuery1 += " FROM "+RetSqlName("SZ3")+" Z3
		_cQuery1 += " WHERE Z3.D_E_L_E_T_=' ' AND Z3_VENDEDO='"+MV_PAR01+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		SZ3->(DbSetOrder(1))

		While (_cAlias1)->(!Eof())

			SZ3->(DbGoTop())
			If SZ3->(DbSeek(xFilial("SZ3")+MV_PAR02+(_cAlias1)->Z3_GRUPO))

				M->Z3_FILIAL	:= SZ3->Z3_FILIAL
				M->Z3_VENDEDO	:= SZ3->Z3_VENDEDO
				M->Z3_NOMVEND	:= SZ3->Z3_NOMVEND
				M->Z3_GRUPO		:= SZ3->Z3_GRUPO
				M->Z3_NOMGRUP	:= SZ3->Z3_NOMGRUP
				M->Z3_COMIS		:= SZ3->Z3_COMIS
				M->Z3_USERLGI	:= SZ3->Z3_USERLGI
				M->Z3_USERLGA	:= SZ3->Z3_USERLGA
				M->Z3_LOG		:= SZ3->Z3_LOG

				SZ3->(RecLock("SZ3",.F.))
				SZ3->Z3_COMIS	:= (_cAlias1)->Z3_COMIS
				SZ3->(MsUnLock())

			Else

				M->Z3_FILIAL	:= SZ3->Z3_FILIAL
				M->Z3_VENDEDO	:= SZ3->Z3_VENDEDO
				M->Z3_NOMVEND	:= SZ3->Z3_NOMVEND
				M->Z3_GRUPO		:= SZ3->Z3_GRUPO
				M->Z3_NOMGRUP	:= SZ3->Z3_NOMGRUP
				M->Z3_COMIS		:= SZ3->Z3_COMIS
				M->Z3_USERLGI	:= SZ3->Z3_USERLGI
				M->Z3_USERLGA	:= SZ3->Z3_USERLGA
				M->Z3_LOG		:= SZ3->Z3_LOG

				SZ3->(RecLock("SZ3",.T.))
				SZ3->Z3_VENDEDO := MV_PAR02
				SZ3->Z3_NOMVEND	:= SA3->A3_NOME
				SZ3->Z3_GRUPO 	:= (_cAlias1)->Z3_GRUPO
				SZ3->Z3_NOMGRUP := (_cAlias1)->Z3_NOMGRUP
				SZ3->Z3_COMIS	:= (_cAlias1)->Z3_COMIS
				SZ3->(MsUnLock())

			EndIf

			WFPOSALT(.T.)

			(_cAlias1)->(DbSkip())
		EndDo

		RestArea(_aArea)

		MsgAlert("Cópia efetuada com sucesso, obrigado!")

	EndIf

Return

/*====================================================================================\
|Programa  | WFPOSALT        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
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

Static Function WFPOSALT(_lInverte)

	Local _lAlterado 	:= .F.
	Local _cAssunto	 	:= ""

	_cMsg := ""
	_cMsg += '<html>'
	_cMsg += '<head>'
	_cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	_cMsg += '</head>'
	_cMsg += '<body>'
	_cMsg += "Comissão do vendedor "+AllTrim(SZ3->Z3_NOMVEND)+" grupo "+AllTrim(SZ3->Z3_NOMGRUP)+" foi alterada conforme abaixo:<br><br>"

	_cMsg	+= "Usuário: "+cUserName+"<br>"
	_cMsg	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+"<br><br>"

	_cMsg 	+= "<table border='1'><tr>
	_cMsg	+= "<td><b>Campo</b></td><td><b>Anterior</b></td><td><b>Novo</b></td></tr>

	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SZ3"))

	While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SZ3"

		If !(M->(&(SX3->X3_CAMPO)) == &("SZ3->"+SX3->X3_CAMPO))

			_cMsg		+= "<tr>
			_cMsg		+= "<td>"+AllTrim(SX3->X3_TITULO)+"</td>

			DO CASE
				CASE AllTrim(SX3->X3_TIPO )=="C"
				If _lInverte
					_cMsg		+= "<td>"+M->(&(SX3->X3_CAMPO))+"</td><td>"+&("SZ3->"+SX3->X3_CAMPO)+"</td>"
				Else
					_cMsg		+= "<td>"+&("SZ3->"+SX3->X3_CAMPO)+"</td><td>"+M->(&(SX3->X3_CAMPO))+"</td>"
				EndIf
				CASE AllTrim(SX3->X3_TIPO )=="N"
				If _lInverte
					_cMsg		+= "<td>"+CVALTOCHAR(M->(&(SX3->X3_CAMPO)))+"</td><td>"+CVALTOCHAR(&("SZ3->"+SX3->X3_CAMPO))+"</td>"
				Else
					_cMsg		+= "<td>"+CVALTOCHAR(&("SZ3->"+SX3->X3_CAMPO))+"</td><td>"+CVALTOCHAR(M->(&(SX3->X3_CAMPO)))+"</td>"
				EndIf
				CASE AllTrim(SX3->X3_TIPO )=="D"
				If _lInverte
					_cMsg		+= "<td>"+DTOC(M->(&(SX3->X3_CAMPO)))+"</td><td>"+DTOC(&("SZ3->"+SX3->X3_CAMPO))+"</td>"
				Else
					_cMsg		+= "<td>"+DTOC(&("SZ3->"+SX3->X3_CAMPO))+"</td><td>"+DTOC(M->(&(SX3->X3_CAMPO)))+"</td>"
				EndIf
			ENDCASE

			_lAlterado	:= .T.
		EndIf

		SX3->(DbSkip())

	EndDo

	_cMsg += '</table>'
	_cMsg += '</body>'
	_cMsg += '</html>'

	If _lAlterado

		_cEmail   := SuperGetMv("ST_CADSZ31",.F.," ")
		_cCopia	  := ""
		_cAssunto := "[PROTHEUS] - Comissão alterada"
		_aAttach  := {}
		_cCaminho := ""

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, _cMsg,_aAttach,_cCaminho)
	

	EndIf

Return(.T.)
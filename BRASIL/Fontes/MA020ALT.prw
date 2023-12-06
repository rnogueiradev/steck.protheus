#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA020ALT ºAutor  ³ Ricardo Posman     º Data ³  15/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao do Cadastro de Fornecedores.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras / Fiscal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA020ALT()

	//Local aAreaAtu	:= GetArea()
	Local _cMsg			:= ""
	Local _lAlterado	:= .F.

	lOk := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Obriga a digitacao do CNPJ / CPF quando o Fornecedor nao for pessoa fisica ou juridica ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     

	// Chama Funcao para validar cadastro   

	If SA2->A2_TIPO <> "X"
		If EMPTY(M->A2_CGC)
			MSGAlert("Atenção! Digite o CNPJ / CPF do Fornecedor. ")
			Return (.F.)
		Endif
		If EMPTY(M->A2_INSCR)
			MSGAlert("Atenção! Digite a Inscricao Estadual do Fornecedor ou informe se ISENTO. ")
			Return (.F.)
		Endif
	Endif

	IF ((ALTERA) .And. (!__cUserId$ GetMv("ST_MA020AL",,"000219/000295/000025/000026/000527/000028")))
		//	M->A2_MSBLQL := '1' // GIOVANI ZAGO NAO BLOQUEIA MAIS O FORNECEDOR SOLICITAÇÃO FABIO/JULIANA 05/12/2016
		//MsgAlert("Foi feita uma alteração no fornecedor e ele foi bloqueado - Somente os responsáveis poderão desbloquear")
	EndIf

	IF (M->A2_EST="EX")
		M->A2_CGC  		:= ""
		M->A2_EMAIL		:= ""
		M->A2_ID_FBFN	:= "3"
	EndIf

	If ALTERA

		_cMsg	+= "Usuário: "+cUserName+CHR(13) +CHR(10)
		_cMsg	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13) +CHR(10)
		_cMsg	+= "Campo | Anterior | Novo "+CHR(13) +CHR(10)

		DbSelectArea("SX3")
		SX3->(DbGoTop())
		SX3->(DbSetOrder(1))
		SX3->(DbSeek("SA2"))

		While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SA2"

			//If X3Uso(SX3->X3_USADO) .And. ! (AllTrim(SX3->X3_CAMPO) $ "A2_PAISDES#A2_DTPAWB#A2_NOMFAV#A2_XNRESP#A2_XUSRINC#A2_ZDFRMPG")
			
			If X3Uso(SX3->X3_USADO) .And. SX3->X3_VISUAL != "V"

				If !(M->(&(SX3->X3_CAMPO)) == &("SA2->"+SX3->X3_CAMPO))

					_cMsg		+= SX3->X3_CAMPO+" | "

					DO CASE
						CASE AllTrim(SX3->X3_TIPO )=="C"
						_cMsg		+= &("SA2->"+SX3->X3_CAMPO)+" | "+M->(&(SX3->X3_CAMPO))+CHR(13)+CHR(10)
						CASE AllTrim(SX3->X3_TIPO )=="N"
						_cMsg		+= CVALTOCHAR(&("SA2->"+SX3->X3_CAMPO))+" | "+CVALTOCHAR(M->(&(SX3->X3_CAMPO)))+CHR(13)+CHR(10)
						CASE AllTrim(SX3->X3_TIPO )=="D"
						_cMsg		+= DTOC(&("SA2->"+SX3->X3_CAMPO))+" | "+DTOC(M->(&(SX3->X3_CAMPO)))+CHR(13)+CHR(10)
					ENDCASE

					_lAlterado	:= .T.

				EndIf

			EndIf

			SX3->(DbSkip())

		EndDo

	EndIf

	If _lAlterado
		M->A2_XLOG		:= _cMsg+CHR(13)+CHR(10)+M->A2_XLOG
		M->A2_XQTDALT	:= SA2->A2_XQTDALT+1
	EndIf

	If INCLUI
		_cMsg	+= "Usuário: "+cUserName+CHR(13) +CHR(10)
		_cMsg	+= "Incluido em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13) +CHR(10)
		M->A2_XLOG		:= _cMsg+CHR(13)+CHR(10)+M->A2_XLOG
	EndIf

	DbSelectArea("AI3")
	AI3->(DbSetOrder(2))
	AI3->(DbGoTop())
	If AI3->(DbSeek(xFilial("AI3")+M->A2_CGC))
		AI3->(RecLock("AI3",.F.))
		AI3->AI3_EMAIL := M->A2_EMAIL
		AI3->(MsUnLock())
	EndIf	

Return(lOK)
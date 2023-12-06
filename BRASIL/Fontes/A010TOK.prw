#INCLUDE "rwmake.ch" 
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK.	ºAutor  ³Renato Nogueira     º Data ³  17/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado gerar log de alteração de alguns produtos   º±±
±±º          ³Teste gio							  	 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Lógico										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A010TOK()

	Local aArea     	:= GetArea()
	Local aAreaSB1  	:= SB1->(GetArea())
	Local lRet			:= .T.
	Local _cMsg			:= ""
	Local _lAlterado	:= .F.
	Local _cEmail  			:= " "//"richely.lima@steck.com.br"
	Local _cCopia  			:= " " 
	Local _cAssunto			:= ""
	Local cMsg	   			:= ""
	Local cMsg1	   			:= ""
	Local cAttach  			:= ''
	Local _aAttach 			:= {}
	Local _cCaminho 		:= ''
	Local lEnvMail			:= .F.
	Local _cLocpad 			:= GETMV("ST_LOCMAIL",,"")
	Local _cMsg1			:= ""
	Private _cEmails		:= ""
	Private aCampos			:= {}
	Private _aCampos		:= {}
	Private lRetWF			:= .T.
	If AllTrim(M->B1_TIPO) $ "PA#PI" .And. Empty(M->B1_ZCODOL) .And. cEmpAnt=="01"
		MsgAlert("Atenção, o produto é PA ou PI e o campo Cod Ofer Log não foi preenchido!")
		Return(.F.)
	EndIf

	If AllTrim(M->B1_TIPO) $ "PA" .And. Empty(M->B1_XABC)
		MsgAlert("Atenção, o produto é PA e o campo ABC (aba Dados Logísticos) não foi preenchido!")
		Return(.F.)
	EndIf

	If AllTrim(M->B1_TIPO) $ "PA" .And. Empty(M->B1_XFMR)
		MsgAlert("Atenção, o produto é PA e o campo FMR (aba Dados Logísticos) não foi preenchido!")
		Return(.F.)
	EndIf

	If ALTERA

		_cMsg	+= "Usuário: "+cUserName+CHR(13) +CHR(10)
		_cMsg	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13) +CHR(10)
		_cMsg	+= "Campo | Anterior | Novo "+CHR(13) +CHR(10)

		If !(M->B1_QE == SB1->B1_QE)
			_cMsg		+= "B1_QE"+" | "+CVALTOCHAR(SB1->B1_QE)+" | "+CVALTOCHAR(M->B1_QE)+CHR(13) +CHR(10)
			_lAlterado	:= .T.
		EndIf
		If !(M->B1_ESTSEG == SB1->B1_ESTSEG)
			_cMsg		+= "B1_ESTSEG"+" | "+CVALTOCHAR(SB1->B1_ESTSEG)+" | "+CVALTOCHAR(M->B1_ESTSEG)+CHR(13) +CHR(10)
			_lAlterado	:= .T.
		EndIf
		If !(M->B1_PE == SB1->B1_PE)
			_cMsg		+= "B1_PE"+" | "+CVALTOCHAR(SB1->B1_PE)+" | "+CVALTOCHAR(M->B1_PE)+CHR(13) +CHR(10)
			_lAlterado	:= .T.
		EndIf
		If !(M->B1_TIPE == SB1->B1_TIPE)
			_cMsg		+= "B1_TIPE"+" | "+SB1->B1_TIPE+" | "+M->B1_TIPE+CHR(13) +CHR(10)
			_lAlterado	:= .T.
		EndIf
		If !(M->B1_LE == SB1->B1_LE)
			_cMsg		+= "B1_LE"+" | "+CVALTOCHAR(SB1->B1_LE)+" | "+CVALTOCHAR(M->B1_LE)+CHR(13) +CHR(10)
			_lAlterado	:= .T.
		EndIf
		If !(M->B1_PROC == SB1->B1_PROC)
			_cMsg		+= "B1_PROC"+" | "+SB1->B1_PROC+" | "+M->B1_PROC+CHR(13) +CHR(10)
			_lAlterado	:= .T.
		EndIf
		If !(M->B1_MRP == SB1->B1_MRP)
			_cMsg		+= "B1_MRP"+" | "+SB1->B1_MRP+" | "+M->B1_MRP+CHR(13) +CHR(10)
			_lAlterado	:= .T.
		EndIf
		If !(M->B1_XABC == SB1->B1_XABC)
			_cMsg		+= "B1_XABC"+" | "+SB1->B1_XABC+" | "+M->B1_XABC+CHR(13) +CHR(10)
			_lAlterado	:= .T.
		EndIf
		If !(M->B1_XFMR == SB1->B1_XFMR)
			_cMsg		+= "B1_XFMR"+" | "+SB1->B1_XFMR+" | "+M->B1_XFMR+CHR(13) +CHR(10)
			_lAlterado	:= .T.
		EndIf
		If !(M->B1_LOCPAD == SB1->B1_LOCPAD)
			_cMsg		+= "B1_LOCPAD"+" | "+SB1->B1_LOCPAD+" | "+M->B1_LOCPAD+CHR(13) +CHR(10)
			cMsg	+= "  Usuário: "+cUserName
			cMsg	+= "  Alterado em: "+DTOC(DDATABASE)+" "+TIME()
			cMsg 	+= "  B1_LOCPAD"+" de "+SB1->B1_LOCPAD+"  para "+M->B1_LOCPAD
			_cAssunto:= 'Código - ('+AllTrim(SB1->B1_COD)+') - Alterado Local Padrao'
			U_STMAILTES(_cEmail+_cLocpad, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			cMsg 	:= ' '
		EndIf

		If AllTrim(SB1->B1_TIPO)=="PA"
			If AllTrim(M->B1_MSBLQL)=="2" .And. AllTrim(SB1->B1_MSBLQL)=="1" //Bloqueado para desbloqueado
				_cAssunto:= 'Código - ('+AllTrim(SB1->B1_COD)+') - desbloqueado ou ativado'
				cMsg		+= "Desbloqueado"
				lEnvMail	:= .T.
			EndIf
			If AllTrim(M->B1_XDESAT)=="2" .And. AllTrim(SB1->B1_XDESAT)=="1" //Desativado para ativado
				_cAssunto:= 'Código - ('+AllTrim(SB1->B1_COD)+') - desbloqueado ou ativado'
				cMsg	+= "Ativado"
				lEnvMail	:= .T.
			EndIf
			If lEnvMail //Chamado 001319
				//U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			EndIf
		EndIf
		/* Bloco de codigo comentado devido ao desuso desta regra de negocio
		If ((AllTrim(SB1->B1_MSBLQL)=="2" .And. AllTrim(M->B1_MSBLQL)=="1") .Or. ;
		(AllTrim(SB1->B1_XDESAT)=="1" .And. AllTrim(M->B1_XDESAT)=="2") .Or. ;
		(Empty(SB1->B1_XDESAT) .And. AllTrim(M->B1_XDESAT)=="2")) .And. (STPRODEDI()) .And. cEmpAnt=="01"

			If __cUserId=="000000"
				_cMsg1	:= "TESTE - FAVOR DESCONSIDERAR"
			EndIf

			If !U_STMAILTES(_cEmails, "", "Código: "+AllTrim(M->B1_COD)+" bloqueado e/ou desativado e consta na lista do EDI", _cMsg1,_aAttach,_cCaminho)
				VtAlert("Problemas no envio de email!")
			EndIf

		EndIf
		*/
		//Chamado 002553 (jonas.bruno) - Atendido por Thiago Godinho em 07/10/16
		_aCampos	:=	U_StGetX3("SB1")
		IF Len(_aCampos) > 0  //Chamado 005111 - Atendido por Robson Mazzarotto. //giovani zago variavel nao estava declarada array se usa len e nao empty como estava
			lRetWF := U_STWFAprovB1( 1, , _aCampos )
		endif

	EndIf

	If _lAlterado
		M->B1_XLOG	:= _cMsg+CHR(13)+CHR(10)+M->B1_XLOG
	EndIf
	If Inclui .or. Altera
		U_STGERSB5() //Carregar informações da desoneração
	EndIf
	RestArea(aAreaSB1)
	RestArea(aArea)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STPRODEDI	ºAutor  ³Renato Nogueira     º Data ³  24/07/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³														      º±±
±±º          ³									  	 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Lógico										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STPRODEDI()

	Local _lEdi			:= .F.
	Local cQuery1 		:= ""
	Local cAlias1 		:= "QRYTEMP"

	cQuery1	 := " SELECT * "
	cQuery1  += " FROM " +RetSqlName("SZD")+ " ZD "
	cQuery1  += " WHERE D_E_L_E_T_=' ' AND ZD_CODSTE='"+M->B1_COD+"' "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	While (cAlias1)->(!Eof())

		If AllTrim((cAlias1)->ZD_CLIENTE)=="008724" .Or. AllTrim((cAlias1)->ZD_CLIENTE)=="010566" //Cliente PJ e Neblina
			_cEmails	+= ";eliane.silva@steck.com.br;"
		ElseIf AllTrim((cAlias1)->ZD_CLIENTE)=="006596" //Cliente Nortel
			_cEmails	+= "marcelo.oliveira@steck.com.br;danielle.bronharo@steck.com.br"
		ElseIf AllTrim((cAlias1)->ZD_CLIENTE)=="003382" //Cliente Dimensional
			_cEmails	+= "marcelo.oliveira@steck.com.br;danielle.bronharo@steck.com.br"
		ElseIf AllTrim((cAlias1)->ZD_CLIENTE)=="031167" //Cliente Decorwatts
			_cEmails	+= "andrea.dias@steck.com.br;karina.moi@steck.com.br;"
		EndIf

		_lEdi	:= .T.
		(cAlias1)->(DbSkip())
	EndDo

Return(_lEdi)


User Function StGetX3(cArq)
	Local nSavOrder,cSavRec,cAlias := Alias()
	Local aCampos := {}
	Local cUsado := ""
	Local _cCampo	:= " "
	//Local _cMsg	:= " "
	Local cUsuarioA := ""
	Local cDataA		:= ""
	Local cUserAtual	:= cUserName
	Local dDataAtual	:= dDataBase
	Local cHora		:= Time()

	DbSelectarea("SX3")
	nSavRec := Recno()
	nSavOrder := IndexOrd()
	cUserOld := U_StGetUserLg("B1_USERLGA")
	cDtOld := U_StGetUserLg("B1_USERLGA", 2)

	DbSetOrder(1)
	DbSeek(cArq)
	While X3_ARQUIVO ==	cArq
		IF !("USERLG" $ X3_CAMPO) .AND. !(X3_CONTEXT == "V")

			_cCampo	:= X3_CAMPO
			cUsado   := X3TreatUso(X3_USADO) //cUsado   := FirstBitOff(Bin2Str(X3_USADO))
			// Verifica se o campo é usado
			If !Empty(cUsado)
				If !(M->&_cCampo == SB1->&_cCampo)
					AADD(aCampos,{SB1->B1_COD,Alltrim(SB1->B1_DESC),X3_CAMPO,X3Titulo(),SB1->&_cCampo,M->&_cCampo,cUserOld,cDtOld,cUserAtual,dtoc(dDataAtual),cHora,cModulo})
					//_cMsg		+= _cCampo+" | "+CVALTOCHAR(SB1->&_cCampo)+" | "+CVALTOCHAR(M->&_cCampo)+CHR(13) +CHR(10)

				EndIf

			EndIf
		Endif
		dbSkip()
	End

	DbSetOrder(nSavOrder)
	DbSelectarea(cAlias)
Return aCampos




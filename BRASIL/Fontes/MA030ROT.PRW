#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | MA030BRW         | Autor | GIOVANI.ZAGO             | Data | 24/01/2013  |
|=====================================================================================|
|Descrição |   MA030BRW      Filtro por Vendedor	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MA030BRW                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function MA030ROT(  )
	*-----------------------------*
	//Local _cCod    := __cuserid
	Local aMenust  := {}
	Local _cGrp    := '000000/000141/000180/000147/000118'
	Local _aGrupos := {}

	If IsBlind()
		Return(aMenust)
	EndIf

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos  := PswRet()
	Endif
	//	aAdd(aMenust,{'giovani',"A030Inclui" , 0 , 3,81,NIL})

	AAdd( aMenust, { 'WFs P/ EDIs', "U_STALTZ88('C')", 9, 0 } )
	//AAdd( aMenust, { 'Lista E-mails p/ WFs', "U_STCADZ88('C')", 9, 0 } )
	AAdd( aMenust, { 'Observação', "U_STXMSG2()", 9, 0 } )
	
	If (_aGrupos[1][10][1] $ _cGrp)//Chamado 002260 - Atualização de Cadastro
		AAdd( aMenust, { 'Importação CSV', "U_STIMPSA1()", 9, 0 } )
	Endif

	AAdd( aMenust, { 'Subir p/ stkAtendimento', "U_STSTKA10(.F.)", 9, 0 } )

	If __cUserId $ GetMv("STFAT3702",,"000010#000231#000641#000380#000391#000366#000378")
		//AAdd( aMenust, { 'Enviar tab. preço geral', "U_STFAT371()", 9, 0 } )
		//AAdd( aMenust, { 'Enviar tab. preço cliente', "U_STFAT370(.T.,'C')", 9, 0 } )
		AAdd( aMenust, { 'Limpar envios de tabela', "U_STFAT372()", 9, 0 } )
	EndIf
	
	If __cUserId $ GetMV("ST_SA1VEND",,"000582","000800", "001243")
		AAdd( aMenust, { 'Import. Carteira CSV', "U_STIMPSA3()", 9, 0 } )
	EndIf

Return(aMenust)

/*====================================================================================\
|Programa  | STXMSG2         | Autor | RENATO.NOGUEIRA          | Data | 14/10/2015   |
|=====================================================================================|
|Descrição |   STXMSG2      Cadastrar mensagem	                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STXMSG2                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STXMSG2()

	Local aArea   		:= GetArea()
	Local _aRet 		:= {}
	Local _aParamBox 	:= {}
	Local _cMsg			:= ""

	/*
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	SA3->(DbGoTop())
	If SA3->(DbSeek(xFilial("SA3")+__cUserId))
	If !SubStr(SA3->A3_COD,1,1) $ "S#G" //Acesso somente para supervisores e gerentes
	MsgAlert("Atenção, rotina disponível somente para supervisores e gerentes, verifique!")
	Return
	EndIf
	EndIf
	*/
	If !__cUserId $ GetMv("ST_STXMSG2")
		MsgInfo("Atenção, acesso não permitido, verifique!","MA030ROT")
		Return
	EndIf

	AADD(_aParamBox,{1,"Observação",Space(250),"","","","",0,.F.})

	If ParamBox(_aParamBox,"Adicionar observação",@_aRet,,,.T.,,500)

		_cMsg	+= "Usuário: "+cUserName+CHR(13)+CHR(10)
		_cMsg	+= "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)

		SA1->(RecLock("SA1",.F.))
		SA1->A1_XMSG2	:= SA1->A1_XMSG2+CHR(13)+CHR(10)+_cMsg+"Obs: "+MV_PAR01
		SA1->(MsUnLock())

		MsgAlert("Mensagem cadastrada com sucesso!")

	EndIf

	RestArea(aArea)

Return()

/*====================================================================================\
|Programa  | STFAT371        | Autor | RENATO.OLIVEIRA           | Data | 26/03/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT371()

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT COUNT(*) CONTADOR
	_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' ' AND A1_XDTENVP<>' ' 

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->CONTADOR>0
		If !MsgYesNo("Atenção, existem clientes com o envio preenchido, deseja continuar?")
			MsgAlert("Envio cancelado!")
			Return
		EndIf
	EndIf

	If !MsgYesNo("Confirma o disparo para todos os clientes cadastrados?")
		MsgAlert("Envio cancelado!")
		Return
	EndIf

	StartJob("U_STFAT370",GetEnvServer(),.F.,.F.,"G")

	MsgAlert("O processamento foi iniciado, obrigado!")

Return()

/*/{Protheus.doc} STIMPSA3()
    (long_description)
    Ponto de Entrada em MATA030 - Carregar via CSV ajuste de A1_VEND1
    @type  Function
    @author user
    Jose Carlos Frasson
    @since date
    16/11/2020
    @example
/*/
User Function STIMPSA3()
	PRIVATE _oBtArq
	PRIVATE _oBtArq1
	PRIVATE _oBtArq2
	PRIVATE _oBtFecha
	PRIVATE _oBtOk
	PRIVATE _cPath 		:= ""
	PRIVATE _oCaminho
	PRIVATE _cCaminho 	:= SPACE(100)

	STATIC _oDlg

	DEFINE MSDIALOG _oDlg TITLE "Informe o Caminho do Arquivo para Importação" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL
	@ 009, 005 SAY "Selecione o Arquivo: " SIZE 094, 007 OF _oDlg PIXEL
	@ 019, 005 BUTTON _oBtArq PROMPT "Selecionar" SIZE 082, 012 OF _oDlg ACTION(PROCDIR()) PIXEL
	@ 035, 005 MSGET _oCaminho VAR _cCaminho SIZE 189, 010 OF _oDlg PIXEL WHEN .F.
	@ 055, 036 BUTTON _oBtOk    PROMPT "Importar" SIZE 037, 012 OF _oDlg ACTION(Processa({|| IMPPROD(_cCaminho) },"Processando..."),_oDlg:END()) PIXEL
	@ 055, 117 BUTTON _oBtFecha PROMPT "FECHAR"   SIZE 037, 012 OF _oDlg ACTION(_oDlg:END()) PIXEL
	ACTIVATE MSDIALOG _oDlg CENTERED

Return()

Static Function IMPPROD(_cCaminho)
	Local cLinha	:= ""
	Local aCampos 	:= {}
	Local aDados	:= {}
	Local lPrim   	:= .T.
	Local i			:= 0
	Local j			:= 0
	Local cCampo	:= ""
	Local aRet 		:= {} //TamSX3(cCampo)
	Local aLinha 	:= {}
	Local _cEmail	:= ""
	Local _cCopia	:= GetEmail(IIF(__cUserId == "000800", "000582", "000800")) 
	Local _aAttach	:= {}
	
	FT_FUSE(_cCaminho)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	
	While !FT_FEOF()
		IncProc("Lendo arquivo texto...")

		cLinha := FT_FREADLN()

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	Begin Transaction
		ProcRegua(Len(aDados))
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbGoTop()

		_cAssunto := "[WFPROTHEUS] - Importacao Carteira clientes - PE - PB - Area com Erro - Gerencia - Via Arquivo .CSV" 

		cMsg := ""
		cMsg += '<html><head><title>' + SM0->M0_NOME + "/" + Alltrim(SM0->M0_FILIAL) +'</title></head><body>'

		For i:=1 to Len(aDados)

			IncProc("Importando Carteira clientes - PE - PB - ÁREA COM ERRO - GERENCIA...")

			If SA1->(dbSeek(xFilial("SA1") + aDados[i,1] + aDados[i,2] )) 
				If SA1->A1_VEND <> aDados[i,4]  

					AADD(aLinha, "Cliente: " + SA1->A1_COD + "/" + SA1->A1_LOJA  + " - " + Alltrim(SA1->A1_NOME) + " com área alterada de: " + Alltrim(SA1->A1_VEND) + " para: " + Alltrim(aDados[i,4]) )
					
					cMsg += '<b> Cliente: ' + SA1->A1_COD + "/" + SA1->A1_LOJA  + " - " + Alltrim(SA1->A1_NOME) + ' com área alterada de: ' + Alltrim(SA1->A1_VEND) + ' para: ' + Alltrim(aDados[i,4]) + ' por ' + UsrFullName(__cUserId) + ' </b></body></html>' + CRLF
					
					Reclock("SA1",.F.)
					SA1->A1_VEND 	:= aDados[i,4]
					SA1->A1_XDTENVM	:= Ctod("  /  /  ") 
					SA1->(MsUnlock())
					
				Endif
			Endif
				
		Next i
		
		If len(aLinha) > 0
			_cEmail 	:= GetEmail(__cUserId)

			u_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		EndIf
		
	End Transaction

	FT_FUSE()

	If len(aLinha) > 0
		ApMsgInfo("Atualização concluída com sucesso. " + Alltrim(Str(len(aLinha))) + " Registro(s) processado(s)","[STECK]")
	Else
		ApMsgInfo("Nenhuma nova atualização foi encontrada...","[STECK]")
	EndIf

Return

/*
|==============================================================================|
|                     				S T E C 		                 				  |
|==============================================================================|
| Programa  | PROCDIR	      |Autor Everson Santana 		|Data 04/01/2017	  |
|-----------+------------------------------------------------------------------|
|           |                                                                  |
|           | Seleciona arquivo de processamento    								  |
| Descrição | 														    	   		  |
|           | 									                               	  |
|-----------+------------------------------------------------------------------|
|    Uso    |  TOTVS Protheus | Módulo | SIGACFG          | Chamado | 9999999  |
|------------------------------------------------------------------------------|
|>>>>>>>>>>>>>>>>>>>>>>>>>> Histórico de Alterações <<<<<<<<<<<<<<<<<<<<<<<<<<<|
|------------------------------------------------------------------------------|
|   Data    |               Alteração               |    Autor     |  Chamado  |
|-----------+---------------------------------------+--------------+-----------|
|==============================================================================|
*/
STATIC FUNCTION PROCDIR()

	LOCAL _CEXTENS   := "Arquivo a ser Anexado (*.CSV) |*.CSV|"
	_cPath := CGETFILE(_CEXTENS, "Selecione o arquivo", , , .T., GETF_NETWORKDRIVE+GETF_LOCALFLOPPY+GETF_LOCALHARD)
	_cArq := ALLTRIM(_cPath)
	IF !EMPTY(_cPath)
		IF LEN(_cArq) <= 0
			AVISO( cTitulo, "Não existe arquio no diretório informado.", {"OK"} )
			_cCaminho := ""
			_oCaminho:REFRESH()
		ELSE
			_cCaminho := _cArq
			_oCaminho:REFRESH()
		ENDIF
	ENDIF

RETURN()

//-------------------------------------------------------------------
// Busca e-mail conforme parâmetro passado
// Input: Model
// Retorno: String
//-------------------------------------------------------------------
Static Function GetEmail(cUsuMail)
	Local aGrpMail := Separa(cUsuMail,"/",.F.)
	Local nX   := 0
	Local cRET := ""
	Local cCodTMP := ""

	if VldUsu(cUsuMail)
	   PswOrder(2)
		if PswSeek( cUsuMail, .T. )
			cCodTMP := PswID()
		endif
	   cRET := UsrRetMail( cCodTMP ) 
	else
		For nX := 1 to Len(aGrpMail)
			if nX > 1
			cRET += ";"
			Endif
			cRET += UsrRetMail(aGrpMail[nX])
		Next
	Endif

Return cRET

//-------------------------------------------------------------------
// Valida Usuário. Verifica se foi passado usuário 
// Input: Model
// Retorno: Lógico
//-------------------------------------------------------------------
Static Function Vldusu(pcUsuMail)
	Local lRET := .F.
	Local aVld := Separa("A/a/E/e/I/i/O/o/U/u",'/')
	Local nX   := 0

	For nX := 1 to Len(aVld)
		if !lRET
		   lRET := (At(aVld[nX], pcUsuMail) > 0)
		Endif
	Next

Return lRET

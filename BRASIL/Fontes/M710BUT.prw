#Include "Protheus.ch"
#Include "mata712.ch"

/*/{Protheus.doc} M710BUT
    (long_description)
		Ponto de Entrada para adicionar o botão de gerar OPs/SCs
		Após confirmação será apresentado uma nova tela para informar o
		motivo, somente das datas selecionadas.
    @author user
        Valdemir Rabelo
    @since date
        15/07/2019
    @Tickt
        20190412000059 - MRP
/*/
User Function M710BUT()
    Local aButtons  := {}
    LOCAL bGera
    Local cNumOpDig := Criavar("C2_NUM",.F.) 
    Local cStrTipo, cStrGrupo := ""
    Local oTempTable := nil
    Private aPeriod  := {}

    a712MCond(@cStrTipo,@cStrGrupo)

    bGera    := {|| If(lAtvFilNes,M712FilNec(.T.),.T.),; 
                    A712Gera(@cNumOpDig,cStrTipo,cStrGrupo,@oTempTable,@aDiversos),;
                    If(lAtvFilNes,M712FilNec(.T.),.T.)  }
    
    aadd(aButtons,{'FIGURA',{|| Eval(bGera)},'#Gera OPs/SCs'})
	aadd(aButtons,{'FIGURA',{|| U_STMRP882()},'MRP - STECK'})
	aAdd(aButtons, { "FIGURA", {|| u_SchMrp15(2) }, "# Exporta MRP" })

Return(aButtons)


/*
{Protheus.doc} MontaTela
    (long_description)
        Monta tela para informar Motivo, conforme período selecionado
    @author user
        Valdemir Rabelo
    @since date
        15/07/2019
*/
Static Function MontaTela(aPeriod)
    Local aAlterGDa  	:= {}
    Local aHeaderPER 	:= {}
    Local aColsPER   	:= {}
    Local aRegS         := {}
    Local nOpca      	:= 0
    Local nI			:= 0
    Local cTitle	 	:= OemToAnsi("INFORME O MOTIVO")	//
    //Variaveis tipo objeto
    Local oGetP,oDlgP,oSize

    //Divide cabeçalho                                             
    oSize := FwDefSize():New()
    oSize:SetWindowSize({000,000,300,350})
    oSize:AddObject("NUMERO",100,80,.T.,.T.) //Dimensionavel
    oSize:AddObject("OP"    ,100,20,.T.,.T.) //Dimensionavel
    oSize:lProp := .T.                      //Proporcional
    oSize:aMargins := {3,3,3,3}             //Espaco ao lado dos objetos 0, entre eles 3
    //Dispara os calculos
    oSize:Process() 

    Aadd(aHeaderPER,{"Periodos",; 
                    "PERMRP",;
                    "@!",;
                    10,;
                    0,;
                    "",;
                    "",;
                    "D",;
                    "",;
                    "",;
                    "",;
                    "",;
                    ""})

    Aadd(aHeaderPER,{"TIPO",; //
                    "C2_TPOP",;
                    "@!",;
                    1,;
                    0,;
                    "Pertence('12')",;
                    "",;
                    "C",;
                    "",;
                    "",;
                    "1=Firme;2=Previsto",;
                    "",;
                    ""})

    Aadd(aHeaderPER,{"Motivo",; 
                    "C2_SEQUEN",;
                    "@!",;
                    3,;
                    0,;
                    "ExistCpo('SZ1')",;
                    "",;
                    "C",;
                    "SZ1",;
                    "",;
                    "",;
                    "",;
                    ""})
	/*
    Aadd(aHeaderPER,{"Destino",; //
                    "C2_ZDESTIN",;
                    "@!",;
                    1,;
                    0,;
                    "Pertence('123456')",;
                    "",;
                    "C",;
                    "",;
                    "",;
                    "1=São Paulo;2=Argentina;3=México;4=Local;5=Fábrica;6=Costa Rica",;
                    "",;
                    ""})
    */
    AADD(aAlterGDa,"C2_SEQUEN")
    //AADD(aAlterGDa,"C2_TPOP")
	//AADD(aAlterGDa,"C2_ZDESTIN")

    For nI:=1 to Len(aPeriod)
        if aPeriod[nI][1]:cName=="LBOK"
            AADD(aRegS,{aPeriod[nI][2],aPeriod[nI][3],SPACE(3),.F.})
        endif
    Next nI

    aColsPER := aClone(aRegS)

    DEFINE MSDIALOG oDlgP TITLE cTitle FROM 000,000 TO 340,350 OF oMainWnd PIXEL

    oGetP := MsNewGetDados():New(oSize:GetDimension("NUMERO","LININI"),oSize:GetDimension("NUMERO","COLINI"),;
                                oSize:GetDimension("NUMERO","LINEND")+40,oSize:GetDimension("NUMERO","COLEND"),;
                                    3,"AllwaysTrue","AllwaysTrue",/*cIniCpos*/,aAlterGDa,/*nFreeze*/,990,/*cFieldOk*/, /*cSuperDel*/,;
                                "AllwaysFalse", oDlgP, @aHeaderPER, @aColsPER)
    oGetP:SetEditLine(.F.)
    oGetP:lInsert := .F.

    ACTIVATE MSDIALOG oDlgP ON INIT EnchoiceBar(oDlgP,{||nOpca:=2,oDlgP:End()},{||oDlgP:End()}) CENTERED

    if nOpca == 2
        aRegS := aClone(oGetP:aCols)
    endif

Return aRegS






/*-------------------------------------------------------------------------/
//Programa:	A712Gera
//Autor:		Rodrigo de Almeida Sartorio
//Data:		22.08.02
//Descricao:	Gera OP/SC de acordo com os Periodos Selecionados   
//Parametros:	01.cNumOpDig - Numero da Op inicial a ser digitado pelo usuario
//				02.cStrTipo  - String com tipos a serem processados 
//				03.cStrGrupo - String com grupos a serem processados  
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712Gera(cNumOpDig,cStrTipo,cStrGrupo,oTempTable,aRegSel)
Local aSays		:= {}
Local aButtons	:= {}
Local nOpca		:= 0
Local lOpMax99	:= .T.
Local nRetry_0  := 0
Local nRetry_1  := 0
Local cValue    := ""
Local cTotal    := ""
Local cCount    := ""
Local aTMP      := {}

Default oTempTable := Nil
DEFAULT aRegSel    := {}

// FMT CONSULTORIA
IF cEmpAnt=='03' .and. Empty(_cDestOP)
	U_TelaDest(.f.)
Endif	

If lVisRes
	AADD(aSays,OemToAnsi(STR0121))
	AADD(aSays,OemToAnsi(STR0122))
	AADD(aSays,OemToAnsi(STR0123))
	AADD(aButtons, { 1,.T.,{|o| nOpcA:= 1,If(MsgYesNo(OemToAnsi(STR0124),OemToAnsi(STR0030)),o:oWnd:End(),nOpcA:=2) } } )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	If aPergs711[4] == 2
		AADD(aButtons, { 5,.T.,{|o| cSelPerSC:=A712SelPer(cSelPerSc,STR0125,"SC",@cNumOpDig,@lOpMax99,@cSelFSC,@aTMP), aRegSel := MontaTela(aTMP) }} )
		AADD(aButtons, { 5,.T.,{|o| cSelPer:=A712SelPer(cSelPer,STR0126,"OP",@cNumOpDig,@lOpMax99,@cSelF) }} )
	Else
		AADD(aButtons, { 5,.T.,{|o| cSelPerSC:=cSelPer:=A712SelPer(cSelPer,STR0125+" / "+STR0126,"SCOP",@cNumOpDig,@lOpMax99,@cSelF) }} )
	EndIf
EndIf

If cIntgPPI != "1"
	cValue := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt)
	cTotal := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt+"TOTAL")
	cCount := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt+"COUNT")
EndIf

If !lBatch .And. lVisRes
	If cIntgPPI != "1"
		If !Empty(cValue) .And. (cValue != "3" .And. cValue != "30")
			MsgInfo(STR0150+CHR(13)+CHR(10)+ STR0080 + " " + cCount + STR0098 + cTotal,STR0030) //"A integração da exclusão de ordens de produção previstas com o PC-Factory ainda está em processamento, por favor aguarde." \n "Ordem de produção " XXX de XXX "Atenção"
			Return Nil
		EndIf
	EndIf
	FormBatch(STR0030,aSays,aButtons,,200,450)
Else
	//Se existe a integração com o PPI, aguarda a finalização da thread que
	//envia as ordens excluidas.
	If cIntgPPI != "1"
		While !Empty(cValue) .And. (cValue != "3" .And. cValue != "30")
			Sleep(500)
			cValue := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt)
		End
	EndIf
	nOpca := 1
Endif

lDigNumOp := !Empty(cNumOpDig)

If nOpca == 1
	//Emite OP's e SC's
	FWMsgRun(,{|lEnd| MAT712OPSC(cNumOpDig,lOpMax99,cStrTipo,cStrGrupo,@oTempTable)},"Conectando ao link informado...","Aguarde")
	
	//Inicia thread para integrar as ordens de produção com o PPI.
	If cIntgPPI != "1"
		StartJob("A712IntPPI",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,c711NumMRP,cIntgPPI,__cUserId)

		//Neste ponto, apenas valida se conseguiu subir a thread.
		//após subir a thread, deixa executando e antes de fechar o MRP é feita a validação da thread em execução.
		//Apenas vai fechar o MRP quando terminar o processamento da thread.
		While .T.
			Do Case
				//TRATAMENTO PARA ERRO DE SUBIDA DE THREAD
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '0'
					If nRetry_0 > 50
						//Conout(Replicate("-",65))
						//Conout("MATA712: "+ "Não foi possivel realizar a subida da thread 'A712IntPPI'")
						//Conout(Replicate("-",65))

						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Não foi possivel realizar a subida da thread 'A712IntPPI'","Não foi possivel realizar a subida da thread 'A712IntPPI'")
						Final("Não foi possivel realizar a subida da thread 'A712IntPPI'") 
					Else
						nRetry_0 ++
					EndIf

				//TRATAMENTO PARA ERRO DE CONEXAO
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '10'
					If nRetry_1 > 5
						//Conout(Replicate("-",65))
						//Conout("MATA712: Erro de conexao na thread 'A712IntPPI'")
						//Conout("Numero de tentativas excedidas")
						//Conout(Replicate("-",65))

						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","MATA712: Erro de conexao na thread 'A712IntPPI'","MATA712: Erro de conexao na thread 'A712IntPPI'")
						Final("MATA712: Erro de conexao na thread 'A712IntPPI'") 
					Else
						//Inicializa variavel global de controle de Job
						PutGlbValue("A712IntPPI"+cEmpAnt+cFilAnt,"0")
						GlbUnLock()

						//Reiniciar thread
						//Conout(Replicate("-",65))
						//Conout("MATA712: Erro de conexao na thread 'A712IntPPI'")
						//Conout("Tentativa numero: " + StrZero(nRetry_1,2))
						//Conout(Replicate("-",65))

						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Reiniciando a thread : A712IntPPI","Reiniciando a thread : A712IntPPI")

						//Dispara thread para Stored Procedure
						StartJob("A712IntPPI",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,c711NumMRP,cIntgPPI,__cUserId)
					EndIf
					nRetry_1++

				//TRATAMENTO PARA ERRO DE APLICACAO
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '20'
					//Conout(Replicate("-",65))
					//Conout("MATA712: Erro ao efetuar a conexão na thread 'A712IntPPI'")
					//Conout(Replicate("-",65))

					//Atualiza o log de processamento
					ProcLogAtu("MENSAGEM","MATA712: Erro ao efetuar a conexão na thread 'A712IntPPI'","MATA712: Erro ao efetuar a conexão na thread 'A712IntPPI'")
					Final("MATA712: Erro ao efetuar a conexão na thread 'A712IntPPI'")  
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '2'
					//Thread iniciou processamento, continua a execução do programa.
					//Conout("MATA712: Thread A712IntPPI iniciou o processamento.")
					Exit
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '3'
					//Já finalizou o processamento.
					Exit
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '30'
					//Já finalizou o processamento. mas com erros.
					//Conout(GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt+"ERRO"))
					Exit
			EndCase
			Sleep(500)
		End
	EndIf

	//Ponto de Entrada apos criacao de OPs/SCs    
	If (ExistBlock("MTA710OPSC"))
		ExecBlock("MTA710OPSC",.F.,.F.,{cNumOpdig})
	EndIf
EndIf

Return Nil


/*-------------------------------------------------------------------------/
//Programa:	A712SelPer
//Autor:		Rodrigo de Almeida Sartorio
//Data:		22.08.02
//Descricao:	Seleciona periodo para geracao de OPs/SCs   
//Parametros:	01.cPer      - Variavel com os periodos marcados/desmarcados
//				02.cTitulo   - Titulo a ser apresentado na DIALOG       
//				03.cTipo711  - Tipo da Selecao - OP / SC / OP e SC
//				04.cNumOpDig - Numero da Op inicial a ser digitado pelo usuario
//				05.lOpMax99  - Indica se o maximo de itens por op e 99 
//				06.cTpOP     - Tipo da OP      
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712SelPer(cPer,cTitulo,cTipo711,cNumOpDig,lOpMax99,cTpOP, aTMP)
Local lOp        	:= "OP" $ cTipo711
Local lOpMaxDig  	:= lOpMax99
Local aAlterGDa  	:= {}
Local aHeaderPER 	:= {}
Local aColsPER   	:= {}
Local nOpca      	:= 0
Local nI			:= 0
Local cNumOpGet  	:= cNumOpDig
Local cTitle	 	:= OemToAnsi(STR0129+cTitulo)	//"Periodos para geracao de "
Local cSelPer		:= ""
Local nSelec	 	:= 1
Local dDatDe  	:= dDataBase
Local dDatAte 	:= dDataBase
//Variaveis tipo objeto
Local oGetPer,oDlgPer
DEFAULT aTMP    := {}

//Divide cabeçalho                                             
oSize := FwDefSize():New()
oSize:SetWindowSize({000,000,300,350})
oSize:AddObject("NUMERO",100,80,.T.,.T.) //Dimensionavel
oSize:AddObject("OP"    ,100,20,.T.,.T.) //Dimensionavel
oSize:lProp := .T. //Proporcional
oSize:aMargins := {3,3,3,3} //Espaco ao lado dos objetos 0, entre eles 3
//Dispara os calculos
oSize:Process() 

Aadd(aHeaderPER,{" "	,; 
                 "CHKOK"	,;
                 "@BMP",;
                 1,;
                 0,;
                 "",;
                 "",;
                 "",;
                 "",;
                 "",;
                 "",;
                 "",;
                 ""})

Aadd(aHeaderPER,{"Periodos",;  
                 "PERMRP",;
				   "@!",;
                 10,;
                 0,;
                 "",;
                 "",;
                 "D",;
                 "",;
                 "",;
                 "",;
                 "",;
                 ""})

Aadd(aHeaderPER,{"TIPO",; 
 		          "C2_TPOP",;
                 "@!",;
                 1,;
                 0,;
                 "Pertence('12')",;
                 "",;
                 "C",;
                 "",;
                 "",;
                 "1=Firme;2=Previsto",; 
                 "",;
                 ""})
	
AADD(aAlterGDa,"C2_TPOP")

AADD(aAlterGDa,"CHKOK")

For nI:=1 to Len(aPeriodos)
	AADD(aColsPER,{If(Substr(cPer,nI,1)=="û",oOk,oNo),DTOC(aPeriodos[nI]),If(Substr(cTpOP,nI,1)=="û","1","2"),.F.})
Next nI

//Verifica se seleciona OP
If lOP .And. Empty(cNumOpGet)
	cNumOpGet := CRIAVAR("C2_NUM",.F.)
EndIf

DEFINE MSDIALOG oDlgPer TITLE cTitle FROM 000,000 TO 400,350 OF oMainWnd PIXEL

oGetPer := MsNewGetDados():New(oSize:GetDimension("NUMERO","LININI"),oSize:GetDimension("NUMERO","COLINI"),;
                               oSize:GetDimension("NUMERO","LINEND"),oSize:GetDimension("NUMERO","COLEND"),;
	     				          3,"AllwaysTrue","AllwaysTrue",/*cIniCpos*/,aAlterGDa,/*nFreeze*/,990,/*cFieldOk*/, /*cSuperDel*/,;
                               "AllwaysFalse", oDlgPer, @aHeaderPER, @aColsPER)
oGetPer:SetEditLine(.F.)
oGetPer:AddAction("CHKOK",{||If(oGetPer:aCols[oGetPer:nAT,1] == oOk,oNo,oOk)})
oGetPer:lInsert := .F.

oTButMarDe := TButton():New(oSize:GetDimension("NUMERO","LININI")+1,oSize:GetDimension("NUMERO","COLINI")+1,,;
                            oDlgPer,{|| AT712IMarc(@oGetPer)},16,10,,,.F.,.T.,.F.,,.F.,,,.F.)

@ oSize:GetDimension("OP","LININI")+2,oSize:GetDimension("OP","COLINI") Say OemtoAnsi(STR0131) SIZE 100,7 OF oDlgPer PIXEL
@ oSize:GetDimension("OP","LININI")  ,oSize:GetDimension("OP","COLINI")+15 MSGET dDatDe PICTURE "99/99/99" SIZE 50,09 OF oDlgPer PIXEL
@ oSize:GetDimension("OP","LININI")+2,oSize:GetDimension("OP","COLINI")+80 Say OemtoAnsi(STR0132) SIZE 100,7 OF oDlgPer PIXEL
@ oSize:GetDimension("OP","LININI")  ,oSize:GetDimension("OP","COLINI")+100 MSGET dDatAte PICTURE "99/99/99" SIZE 50,09 OF oDlgPer PIXEL

@ oSize:GetDimension("OP","LININI")+15,oSize:GetDimension("OP","COLINI") RADIO oRdx VAR nSelec SIZE 70,10 PROMPT  OemToAnsi(STR0133),OemToAnsi(STR0134)
@ oSize:GetDimension("OP","LININI")+35,oSize:GetDimension("OP","COLINI") BUTTON STR0135 SIZE 055,010 ACTION A712Reprog(@oGetPer,nSelec,dDatDe,dDatAte) OF oDlgPer PIXEL

If lOP
	@ oSize:GetDimension("OP","LININI")+55,oSize:GetDimension("OP","COLINI") Say OemtoAnsi(STR0136) SIZE 100,7 OF oDlgPer PIXEL	//"Numero Inicial p/geracao"
	@ oSize:GetDimension("OP","LININI")+53,oSize:GetDimension("OP","COLINI")+100 MSGET cNumOpGet SIZE 50,09 OF oDlgPer PIXEL
	@ oSize:GetDimension("OP","LININI")+70,oSize:GetDimension("OP","COLINI") CHECKBOX oChk VAR lOPMaxDig PROMPT OemToAnsi(STR0137) SIZE 85, 10 OF oDlgPer PIXEL //"Maximo de 99 itens por OP"
	oChk:oFont := oDlgPer:oFont
EndIf

ACTIVATE MSDIALOG oDlgPer ON INIT EnchoiceBar(oDlgPer,{||nOpca:=2,oDlgPer:End()},{||oDlgPer:End()}) CENTERED

If nOpca = 2
	If lOp
		lOpMax99 := lOpMaxDig
		If Empty(cNumOpGet)
			cNumOpDig := GetNumSc2()
		Else
			cNumOpDig := cNumOpGet
		EndIf
	EndIf
	
	For nI:=1 to Len(oGetPer:aCols)
		If oGetPer:aCols[nI][1] == oOk
			If nI == 1
				cSelPer :="û"
			Else
				cSelPer :=cSelPer+"û"
			EndIf
		Else
			If nI == 1
				cSelPer :=" "
			Else
				cSelPer :=cSelPer+" "
			EndIf
		EndIf

		If oGetPer:aCols[nI][3] == "1"
			If nI == 1
				cTpOP :="û"
			Else
				cTpOP :=cTpOP+"û"
			EndIf
		Else
			If nI == 1
				cTpOP :=" "
			Else
				cTpOP :=cTpOP+" "
			EndIf
		EndIf
	Next nI
    cPer := cSelPer
    aTMP := aClone(oGetPer:aCols)
EndIf

Return cPer

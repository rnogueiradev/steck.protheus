#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | FIMPCSVEXEC        | Autor | BRUNO REIS           | Data | 04/05/2023  |
|=====================================================================================|
|Descrição | ROTINA PARA INSERIR PEDIDO DE VENDA E ORCAMENTO VIA CSV                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
User function FIMPCSVEXEC()
    Default cFilEmp    := ''
	Default cEmpresa   := ''
	default cMessageError := ''
    Private _cPastLoc := "c:\logcsv\"  
	Private aCombo			:= {}
	Private __aRet := {}
	Private aParamBox := {}
	Private _cAno		:= Space(4)
    Private cTipoImp    := '01'  //01 =PEDIDO DE VENDA //02 = ORCAMENTO
    //U_cCmpObrigat()
    
    //return

    If	! ExistDir( _cPastLoc )
		MakeDir(_cPastLoc) 		// cria o diretorio local
	EndIf
	aCombo := {"01-PED.VENDA","02-ORC VENDA" }

	AADD(aParamBox,{2,"Importacao de CSV",,aCombo,100,"",.T.})
 
	If !ParamBox(aParamBox,"Importacao de CSV ",@__aRet,,,.T.,,500) 
		Return
	Endif
	
    //RpcSetType( 3 )
	//RpcSetEnv("07","01",,,"COM")
    //U_cCmpObrigat()
    If __aRet[1] == "01-PED.VENDA"
        cTipoImp := "01"
    ElseIf __aRet[1] == "02-ORC VENDA"  
        cTipoImp := "02"
    Endif    
    Processa({|| u_FArqCsv(cTipoImp)}, "Lendo TXT....")
Return
User Function FArqCsv(cTipoImp)
Local 	cLinha		:= ""
Local nTotLinha := 0
Local nAtual    := 0
Private	aItens		:={}
Private	aCampos	:={}
	
cfOpen:=cGetFile("Arquivos Csv (MS DOS)|*.csv",;
                OemToAnsi("Abrir Arquivo para Importacao *CSV..."),;
                0,;
                GetSrvProfString("c:\",""),;
                .T.)

if !Empty(cFOpen)
		//Alert(" Arquivo Encontrado ! ")
		FT_Fuse(cfOpen)
        nTotLinha:= FT_FLASTREC()
        FT_FGOTOP()
		While !FT_FEOF()
            nAtual := nAtual + 1
            ProcRegua(nTotLinha)
            IncProc("Lendo a linha " + cValToChar(nAtual) + " de " + cValToChar(nTotLinha) + "...")       
            //Alert(" Passou Aqui 1 ! ")
			cLinha  := FT_FReadLn() // Retorna a linha corrente
			If  Empty(aCampos)
                //Alert(" Passou Aqui 2 ! ")
				aCampos := &("{'"+StrTran(cLinha,";","','")+"'}")
			Else
                //Alert(" Passou Aqui 2 ! ")
				aAdd(aItens,&("{'"+StrTran(cLinha,";","','")+"'}"))
			Endif
			FT_FSkip()
		End		
		FT_FUse()
		nTotal := Len(aItens)
       // ProcRegua(nTotal)
Endif   
Processa({|| U_FGerArrExec(aCampos,aItens,cTipoImp)}, "Importando  ....")     
//U_FGerArrExec(aCampos,aItens)

Return 
User Function FGerArrExec(aCampos,aItens,cTipoImp)
Local aArrCabExec := {}
Local aArrITNExec := {}
Local x           := 0
Local y           := 0
Local cTypeLg     := ""
Local cCampoCab   := "" 
Local cCampoItn   := ""
Local aItensSC6   := {}
Local nTotLinha  := Len(aItens)
Local nAtual     := 0

	For x := 1 to Len(aItens)
        If Len(aItens[x]) == Len(aCampos)
            nAtual := nAtual+ 1
            ProcRegua(nTotLinha)
            IncProc("Lendo " + cValToChar(nAtual) + " de " + cValToChar(nTotLinha) + "...")       
                For y := 1 to Len(aCampos)
                    if Alltrim(Upper(aItens[x][1])) <> "PULA_LINHA" //$ aItens[x][1]
                        If "CAB_" $ aCampos[y]  
                            If Alltrim(Upper(aItens[x][1])) <> "CABECALHO"
                                cCampoCab   := Alltrim(SubStr(aCampos[y],5,len(aCampos[y])))
                                cTypeLg     := FWSX3Util():GetFieldType(cCampoCab)
                                aadd(aArrCabExec,{cCampoCab , TrataCampo(aItens[x][y], cTypeLg ) , Nil})	
                            Endif    
                        Else
                
                            cCampoItn   := Alltrim(SubStr(aCampos[y],5,len(aCampos[y])))
                            cTypeLg     := FWSX3Util():GetFieldType(cCampoItn) 
                            aadd(aArrITNExec,{cCampoItn , TrataCampo(aItens[x][y], cTypeLg ) , Nil})	  
                    //        aArrITNExec := FWVetByDic( aArrITNExec, 'SC6' )
                    //      aadd(aItensSC6, aArrITNExec)
                        Endif
                    Else
                    //   U_FGEREXECAUT(aArrCabExec,aArrITNExec)
                    U_FGEREXECAUT(aArrCabExec,aItensSC6,cTipoImp)
                    aArrCabExec := {}
                    aArrITNExec := {}
                    aItensSC6   := {}
                    x:= x+1
                    y := 0
                    If x > len(aItens)
                        //Alert("Processo Concluido")
                        MSGINFO( "Importacao finalizado com sucesso verifique a pasta  C:\LOGCSV\ ", "Imp.CSV" )
                        Return
                    Endif
                    //U_FGEREXECAUT(aArrCabExec,aArrITNExec) 
                    Endif    
                Next
                If cTipoImp == '01'
                    aArrCabExec := FWVetByDic( aArrCabExec, 'SC5' )
                    aArrITNExec := FWVetByDic( aArrITNExec, 'SC6' )
                ELseIf  cTipoImp == '02'
                    aArrCabExec := FWVetByDic( aArrCabExec, 'SCJ' )
                    aArrITNExec := FWVetByDic( aArrITNExec, 'SCK' )
                Endif   
                aadd(aItensSC6, aArrITNExec)
                
                y := 0  
                //aArrCabExec := {}
                aArrITNExec := {}
        Else
            MSGINFO( "Cabecalho esta diferente dos itens, verifique a quantidade de campos x linha de itens", "Imp. Pedido CSV" )
            Return
        Endif

    next x
Return
User Function FGEREXECAUT(aArrCabExec,aItensSC6,cTipoImp)
Local cRetExec:= ""
Local aRetLog := {}
Local nZ      := 0
Local cLogName := "IMPCSV"+ "_" + DToS(Date()) + "_" + StrTran(Time(), ":", "_")+".log"
Local _cPastLoc := "c:\logcsv" 

//Variaveis Private tratativa de retorno da execauto.
Private lMsErroAuto    := .F.
//Para uso da GetAutoGrLog()
Private lAutoErrNoFile := .T. 

If Len(aItensSC6) > 0 .AND. Len(aArrCabExec) > 0 

			// Executa a inclusão do pedido de venda
            If cTipoImp == '01'			
			    MSExecAuto({|a,b,c| MATA410(a,b,c)},aArrCabExec, aItensSC6, 3)
			ELseIf  cTipoImp == '02'
                MATA415(aArrCabExec,aItensSC6,3)
            Endif
			// Se execauto com erro
			If lMsErroAuto
				cRetExec    := "Não foi possível incluir. " + CRLF
				aRetLog     := GetAutoGrLog()
				For nZ := 1 To Len(aRetLog)
					cRetExec += aRetLog[nZ] + CRLF
				Next nZ
                EECVIEW(cRetExec)
                MemoWrite(_cPastLoc+"\erro_"+cLogName, cRetExec)
			Else
                If cTipoImp == '01'	
                    cRetExec := "PEDIDO INCLUIDO COM SUCESSO->"+SC5->C5_NUM
                    MemoWrite(_cPastLoc+"\OK_"+SC5->C5_FILIAL+"_"+SC5->C5_NUM+"_"+cLogName, cRetExec)
                    //Alert("INCLUIDO COM SUCESSO")
                ELseIf  cTipoImp == '02'
                    cRetExec := "PRESUPUESTO INCLUIDO COM SUCESSO->"+SCJ->CJ_NUM
                    MemoWrite(_cPastLoc+"\OK_"+SCJ->CJ_FILIAL+"_"+SCJ->CJ_NUM+"_"+cLogName, cRetExec)
                Endif
            Endif    
Else
    Alert("ARRAY VAZIO")
Endif
		
Return
User Function cCmpObrigat()
Local aCmpSC5 :={}
Local aCmpSC6 :={}
Local x := 0
Local cCriaArq := ""
aCmpSC5:= FWSX3Util():GetAllFields( "SCJ" , .F. )
aCmpSC6:= FWSX3Util():GetAllFields( "SCK" , .F. )
for x := 1 to Len(aCmpSC5)
    If X3Obrigat(aCmpSC5[x])
        cCriaArq:= cCriaArq + "CAB_"+alltrim(aCmpSC5[x])+";"
    Endif
  
next
x:= 0
for x := 1 to Len(aCmpSC6)
    If X3Obrigat(aCmpSC6[x])
        cCriaArq:= cCriaArq + "ITN_"+alltrim(aCmpSC6[x])+";"
    Endif  
next
MemoWrite("c:\log\cmpped.txt", cCriaArq)

Return
Static Function TrataCampo(xCampo,xTpType,lRetCmp,cTamCmp) 
						
	Local  aArea                  := GetArea()
	Local cRet
	Local lRetCmp 				  := .T.
	If upper(xCampo) == ".T." .or. upper(xCampo) == ".F." 
		xTpType := "L"
	Endif
	Do Case
		Case xTpType == "L" 	
				If upper(xCampo) == ".T."
					cRet := .T.
				ELSE
					cRet := .F.
				ENDIF	
		Case xTpType == ValType(xCampo)//regra para campo logico
				cRet := xCampo
				/*
				If ValType(cRet) == "C"
				    lRetCmp := LEN(cRet) <= cTamCmp
				Else
					lRetCmp := .T.
				Endif
				*/
		Case xTpType == "N" .And. ValType(xCampo) == "C"
			//xCampo := StrTran(xCampo,".","")
			xCampo := StrTran(xCampo,",",".")
			//lRetCmp := LEN(xCampo) <= cTamCmp //VALIDA TAMNHO DO CAMPO 
			cRet := Val(xCampo)
		
		Case xTpType == "C" .And. ValType(xCampo) == "N"
			cRet := AllTrim(Str(xCampo))
			//lRetCmp := LEN(cRet) <= cTamCmp //VALIDA TAMNHO DO CAMPO
		
		Case xTpType == "C" .And. ValType(xCampo) == "D"
			cRet := DtoC(xCampo)
		    //lRetCmp := LEN(cRet) <= cTamCmp //VALIDA TAMNHO DO CAMPO
			
		Case xTpType = "D" .And. ValType(xCampo) == "C"
			//lRetCmp := LEN(xCampo) <= cTamCmp //VALIDA TAMNHO DO CAMPO
			cRet :=CtoD(xCampo)
		
		If Empty(cRet)
			cRet := StoD(xCampo)
		EndIf
		
		Case xTpType == "M"
			//cRet := xGrava
			cRet := xCampo
	EndCase
RestArea(aArea) 
return cRet


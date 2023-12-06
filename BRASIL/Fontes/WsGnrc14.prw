#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ WsGnrc14 บAutor ณJonathan Schmidt Alves บ Data ณ29/06/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de montagem de chamada webservice Thomson.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Parametros recebidos:                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ aMethds: Matriz de metodos e recnos montagem               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ nMsgPrc: Mensagem de processamento                         บฑฑ
ฑฑบ          ณ         Ex: 2=AskYesNo                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                   WsGnrc14 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function WsGnrc14(aMethds, nMsgPrc)
Local aRet := { .F., Nil, "" }
Local lProc := .T.
// Variaveis montagem
Local _z1
Local _n1
Local _n2
Local aResult
Local aMoldes
// Variaveis processamento
Local cDtHrP := ""
Local cArqDes := ""
Local cNomApi := ""
Local cEndUrl := ""
Local cMntXml := ""
Local aParam := {}
Local aParams := {}
// Mensagem AskYesNo
Default nMsgPrc := 0
ConOut("WsGnrc01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
_n0 := 1
While _n0 <= Len( aMethds ) // Rodo nos grupos de integracao (Unidades Medida/Produtos/etc)
    lProc := .F. // .F.=Ainda nao processado/falha no processamento .T.=Ja processado
    _n1 := 1
    While _n1 <= Len(aMethds[_n0,06]) .And. !lProc // Rodo nos metodos
        // Parte 01: Montagem da matriz molde
        aMoldes := MntMolds(aMethds[ _n0, 02 ], aMethds[ _n0, 04 ], aMethds[ _n0, 05 ], @aMethds[ _n0 ], nMsgPrc) // Montagem dos moldes
        If Len(aMoldes) > 0 // Moldes carregados
            cInterf := RTrim(aMethds[ _n0, 01 ]) // Interface                   Ex: "SFW_UNM"
            cNomApi := RTrim(aMethds[ _n0, 02 ]) // Nome Api                    Ex: "PKG_SFW_UNIDADE_MEDIDA.PRC_UNIDADE_MEDIDA"
            cEndUrl := RTrim(aMethds[ _n0, 03 ]) // Endereco Url                Ex: "https://gtmproj-steck.onesourcelogin.com/sfw-generic-ws/PrcUnidadeMedidaWSImpl?wsdl"
            cTipInt := aMethds[ _n0, 04 ] // Tipo de Interface                  Ex: "01"=IN, "02"=OUT
            cIntAmb := aMethds[ _n0, 05 ] // Ambiente Integracao                Ex: "TST"=Teste "DSV"=Desenvolvimento "PRD"=Producao
            aParams := aMethds[ _n0, 06, _n1 ] // Parametros do metodo
            aRecnos := aMethds[_n0,07] // Recnos posicionamentos
            aRepets := aMethds[_n0,08] // Repeticoes
            _n2 := 1
            While _n2 <= Max( Len( aParams ), 1) .And. !lProc // Rodo nos parametros do metodo
                cDtHrP := DtoS(Date()) + "_" + StrTran(Time(),":","")                       // Data + Hora + Minuto + Segundo Processamento         Ex: "20201812_152473"
                cArqDes := "C:\TEMP\" + "THOMSON_" + cDtHrP + "_" + cNomApi + ".XML"         // Arquivo de Processamento                             Ex: "THOMSON_20201812_1524735_PKG_SFW_UNIDADE_MEDIDA.PRC_UNIDADE_MEDIDA.XML"
                Sleep(800)
                // Parte 02: Preparacao dos parametros
                If Len(aParams) == 0 // Nao tem parametros
                    aParam := {}
                Else // Passa parametro conforme nParam
                    aParam := aParams[_n2]
                EndIf
                // Parte 03: Carregamento dos dados
                aResult := LoadDads(nMsgPrc, aRecnos, aMoldes, aParam, aRepets)
                // Parte 04: Gravacao dos dados carregados em arquivo
                aRet := GrvsDads(nMsgPrc, "", cArqDes, aResult, aMoldes, cDtHrP)
                // Parte 05: Comunicacao webservice
                If aRet[01] // .T.=Sucesso
                    If !Empty(aRet[03]) // Dados montados para comunicacao webservice
                        cMntXml := aRet[03] // Dados
                        aRet := u_WsGnrc15(cNomApi, cEndUrl, cIntAmb, cMntXml, nMsgPrc)
                        If aRet[01] // .T.=Sucesso .F.=Falha
                            cMsg01 := "Integracao Totvs -> Thomson... Sucesso!"
                            cMsg02 := "Contatando webservice... Sucesso!"
                            cMsg03 := aRet[03]
                            cMsg04 := ""
                            If nMsgPrc == 2 // 2=AskYesNo
                                For _z1 := 1 To 4
                                    u_AtuAsk09(nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "OK")
                                    Sleep(300)
                                Next
                            EndIf
                            // Processamento do retorno
                            lProc := .T.
                        EndIf
                        // Mensagem de retorno (sucesso ou falha)
                        cArqDes := "C:\TEMP\" + "THOMSON_" + cDtHrP + "_" + cNomApi + "_Result.XML"         // Arquivo de Processamento                             Ex: "THOMSON_20201812_1524735_PKG_SFW_UNIDADE_MEDIDA.PRC_UNIDADE_MEDIDA.XML"
                        nHdl := fCreate(cArqDes, Nil, Nil, .F.) // Cria arquivo txt
                        If nHdl >= 0 // Sucesso na criacao do arquivo
                            cDado := aRet[03]
                            fWrite(nHdl, cDado, Len(cDado)) // Gravo dados no arquivo
                            fClose(nHdl) // Finaliza processo e fecha arquivo
                        EndIf
                    EndIf
                EndIf
                _n2++
            End
        EndIf
        _n1++
    End
    If !lProc // Nao obteve sucesso em nenhum metodo dos parametros, entao abandona
        cMsg01 := "Integracao Totvs -> Thomson... Falha!"
        cMsg02 := "Metodo: " + aMethds[_n0,01]
        cMsg03 := aRet[03]
        cMsg04 := ""
        If nMsgPrc == 2 // 2=AskYesNo
            For _z1 := 1 To 4
                u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "UPDERROR")
                Sleep(500)
            Next
        Else // 1=MsgStop
            MsgStop(cMsg01 + Chr(13) + Chr(10) + ;
            cMsg02 + Chr(13) + Chr(10) + ;
            cMsg03 + Chr(13) + Chr(10) + ;
            cMsg04,"WsGnrc14")
        EndIf
        Exit
    Else // Sucesso
        cMsg01 := "Integracao Totvs -> Thomson... Sucesso!"
        cMsg02 := ""
        cMsg03 := ""
        cMsg04 := ""
        For _z1 := 1 To 4
            u_AtuAsk09(++nCurrent, cMsg01, cMsg02, cMsg03, cMsg04, 80, "OK")
            Sleep(030)
        Next
    EndIf
    _n0++
End
ConOut("WsGnrc01: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ MntMolds บAutor ณJonathan Schmidt Alves บ Data ณ29/06/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem do layout de integracao (Methods XML).            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ Parametros recebidos:                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ cNomApi: Nome da Api para montagem do XML                  บฑฑ
ฑฑบ          ณ          Ex: PKG_SFW_UNIDADE_MEDIDA.PRC_UNIDADE_MEDIDA     บฑฑ
ฑฑบ          ณ              PKG_SFW_PRODUTOS.PRC_PRODUTO                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ cTipInt: Tipo de Interface                                 บฑฑ
ฑฑบ          ณ          Ex: "01"=IN (Entrada)                             บฑฑ
ฑฑบ          ณ              "02"=OUT (Saida)                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ cIntAmb: Integracao no Ambiente                            บฑฑ
ฑฑบ          ณ          Ex: "TES"=Ambiente de testes (QA)                 บฑฑ
ฑฑบ          ณ              "DES"=Ambiente de desenvolvimento (PRJ)       บฑฑ
ฑฑบ          ณ              "PRO"=Ambiente de producao (PRO)              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ aMethds: Matriz de metodos e recnos montagem               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ nMsgPrc: Mensagem de processamento                         บฑฑ
ฑฑบ          ณ          Ex: 2=AskYesNo                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function MntMolds(cNomApi, cTipInt, cTipAmb, aMethds, nMsgPrc)
Local aMoldes := {}
Local _z1
ConOut("MntMolds: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
If nMsgPrc == 2 // 2=AskYesNo
	For _z1 := 1 To 4
		u_AtuAsk09(++nCurrent,"Integracao Totvs -> Thomson", aMethds[09], "Montando Estrutura XML (" + cNomApi + ")...", "", 80, "PROCESSA")
		Sleep(030)
	Next
EndIf
DbSelectArea("ZT2")
ZT2->(DbSetOrder(2)) // ZT2_FILIAL + ZT2_CODIGO + ZT2_CODITE
DbSelectArea("ZT1")
ZT1->(DbSetOrder(3)) // ZT1_FILIAL + ZT1_TIPINT + ZT1_NOMAPI
If ZT1->(DbSeek( _cFilZT1 + cTipInt + cNomApi ))
    While ZT1->(!EOF()) .And. ZT1->ZT1_FILIAL + ZT1->ZT1_TIPINT + ZT1->ZT1_NOMAPI == _cFilZT1 + cTipInt + PadR(cNomApi, TamSX3("ZT1_NOMAPI")[01])
        If ZT1->ZT1_CODSTA == "01" // "01"=Ativo
            If !Empty( &("ZT1->ZT1_URL" + cTipAmb) ) // Url preenchida
                If ZT2->(DbSeek( ZT1->ZT1_FILIAL + ZT1->ZT1_CODIGO ))
                    While ZT2->(!EOF()) .And. ZT2->ZT2_FILIAL + ZT2->ZT2_CODIGO == ZT1->ZT1_FILIAL + ZT1->ZT1_CODIGO // Codigo Interface confere
                        If ZT2->ZT2_CODSTA == "01" // "01"=Ativo
                            //            { {           01.01,           01.02,           01.03,           01.04,           01.05,           01.06,           01.07 }, {           02.01,           02.02,           02.03,           02.04,           02.05,           02.06,           02.07,           02.08,           02.09,           02.10,           02.11 } }
                            aAdd(aMoldes, { { ZT2->ZT2_NOMFLD, ZT2->ZT2_REGINT, ZT2->ZT2_DESCRI, ZT2->ZT2_TIPDAD, ZT2->ZT2_TAMDAD, ZT2->ZT2_TAMDEC, ZT2->ZT2_REPETS }, { ZT2->ZT2_POSIC1, ZT2->ZT2_POSIC2, ZT2->ZT2_POSIC3, ZT2->ZT2_CONDI1, ZT2->ZT2_ORIGEM, ZT2->ZT2_CONDI2, ZT2->ZT2_TRATA1, ZT2->ZT2_ASPDUP, ZT2->ZT2_TRATA2, ZT2->ZT2_FLDGRV, ZT2->ZT2_DETALH } })
                        EndIf
                        ZT2->(DbSkip())
                    End
                EndIf
            EndIf
            If Len(aMoldes) > 0
                aMethds[01] := ZT1->ZT1_INTERF              // Interface
                aMethds[02] := ZT1->ZT1_NOMAPI              // Nome da API
                aMethds[03] := &("ZT1->ZT1_URL" + cTipAmb)  // Endereco URL
                Exit
            EndIf
        EndIf
        ZT1->(DbSkip())
    End
EndIf
If Len(aMoldes) > 0 // Estrutura carregada...
    cMsg03 := "Montando Estrutura XML (" + cNomApi + ")... Sucesso!"
    cImage := "OK"
Else
    cMsg03 := "Montando Estrutura XML (" + cNomApi + ")... Falha!"
    cMsg04 := "Nao foi encontrada estrutura ZT2 para a montagem de dados!"
    cImage := "UPDERROR"
EndIf
If nMsgPrc == 2 // 2=AskYesNo
	For _z1 := 1 To 4
		u_AtuAsk09(++nCurrent,"Integracao Totvs -> Thomson", aMethds[09], cMsg03, cMsg04, 80, cImage)
		Sleep(Iif(cImage == "UPDERROR",800,030))
	Next
EndIf
ConOut("MntMolds: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg02)
ConOut("MntMolds: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
Return aMoldes

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ LoadDads บAutor ณJonathan Schmidt Alvesบ Data ณ 29/06/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carregamento dos registros (posicionado/parametrizados).   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Parametros recebidos:                                      บฑฑ
ฑฑบ          ณ nMsgPrc: Tipo de mensagem de processamento                 บฑฑ
ฑฑบ          ณ          Ex: 2=AskYesNo                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ aRecTab: Tabela e os recnos da tabela para posicionamento. บฑฑ
ฑฑบ          ณ         [01]: Tabela de posicionamento. Ex: "SB1"          บฑฑ
ฑฑบ          ณ         [02]: Matriz de recnos. Ex: { 10, 11, 12, 13 }     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ         Exemplo: { { "SB1", { 10, 11, 12, 13 } } }         บฑฑ
ฑฑบ          ณ         Exemplo: { { "SD1", { 101, 102, 103, 104 } } }     บฑฑ
ฑฑบ          ณ         Exemplo: { { "SD1", { 101, 102, 103, 104 } }       บฑฑ
ฑฑบ          ณ                    { "SZA", {   0,  10,  11,  12 } } }     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ aMoldes: Matriz de moldes                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ aParams: Parametros aParGet ou aParSet para adequacao de   บฑฑ
ฑฑบ          ณ          variaveis na montagem dos moldes                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ aRepets: Matriz de repeticoes                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ aMoldes: Matriz mestre de moldes.                          บฑฑ
ฑฑบ          ณ         Estrutura segue os layouts de cada integracao.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function LoadDads(nMsgPrc, aRecTab, aMoldes, aParams, aRepets)
Local _w
Local _w2
Local _n
Local _n2
Local _z1
Local cTab := Space(03)
Local cTip := Space(01)
Local nTam := 0
Local nDec := 0
// Variaveis repeticoes
local nRepets := 0
Local nRepSta := 0
Local lRepets := .F.
Local nRep := 0
// Resultado
Local nResult := 0
Local aResult := {}
ConOut("")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Parametros recebidos:")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aRecTab: (matriz de registros para carregamento)")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aMoldes: (matriz de moldes layout)")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aParams: (parametros)")
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aRepets: (repeticoes)")
If Len(aRecTab) > 0 // Recnos alimentados
	If nMsgPrc == 2 // 2=AskYesNo
		For _z1 := 1 To 4
			u_AtuAsk09(++nCurrent,"Integracao Totvs -> Thomson","Processando dados...", "", "", 80, "PROCESSA")
			Sleep(030)
		Next
	EndIf
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Avaliando dados para carregamento...")
    cTab := aRecTab[01,01] // Tabela principal de posicionamento
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Tabela Principal: " + cTab)
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Recnos para posicionamento: " + cValToChar(Len(aRecTab[01,02])))
    For _n := 1 To Len(aRecTab[01,02]) // Recnos para posicionamentos (SB1/SD1,etc)
    	(cTab)->(DbGoto( aRecTab[01,02,_n] )) // Posiciono tabela pincipal
        // Posicionamento das demais tabelas
        For _n2 := 2 To Len(aRecTab)
        	If aRecTab[_n2,02,_n] > 0 // Recno para posicionamento
        		(aRecTab[_n2,01])->(DbGoto(aRecTab[_n2,02,_n]))
        	Else
        		(aRecTab[_n2,01])->(DbGobottom())
        		(aRecTab[_n2,01])->(DbSkip()) // Deixo em EOF
        	EndIf
        Next
        If (cTab)->(!EOF())
            // Adequacao dos parametros em variaveis
            If Len( aParams ) > 0 // Depende da estrutura da matriz 2 formas diferentes
                If _n <= Len(aParams) .And. ValType(aParams[ _n, 01]) == "A" // Matriz com elementos por registro
                    For _n2 := 1 To Len(aParams[ _n ])
                        &(aParams[ _n, _n2, 01 ]) := &(aParams[ _n, _n2, 02 ]) // Alimentacao das variaveis
                    Next
                Else // Matriz com x elementos para todo o processamento
                    For _n2 := 1 To Len(aParams)
                        &(aParams[ _n2, 01 ]) := &(aParams[ _n2, 02 ]) // Alimentacao das variaveis
                    Next
                EndIf
            EndIf
            aAdd(aResult, Array(0))
            nJump := 0
            nResult++
            nRepets := 0
            nRepSta := 0
            _w := 1
            While _w <= Len(aMoldes)
                // Elementos 01, 02 e 03 Posicionamentos                                                        ZT2_POSIC1, ZT2_POSIC2, ZT2_POSIC3
                For _w2 := 1 To 3
                    If !Empty(aMoldes[_w,02,_w2])
                        &(aMoldes[_w,02,_w2])
                    EndIf
                Next
                // Elementos: 04, 05 e 06 Variaveis basicas de processamento
                cTip := aMoldes[_w,01,04] //                                                                     ZT2_TIPDAD
                nTam := aMoldes[_w,01,05] //                                                                     ZT2_TAMDAD
                nDec := aMoldes[_w,01,06] //                                                                     ZT2_DECDAD
                cRep := aMoldes[_w,01,07] //                                                                     ZT2_REPETS
                // Repeticoes
                lRepets := .F.
                If !Empty(cRep) // Inicio/Fim de repeticao
                    If (nRep := ASCan(aRepets, {|x|, x[01] == cRep })) > 0 // Inicio/Fim de repeticao
                        If nRepSta == 0 // Sem start, entao eh o start
                            nRepets++
                            If nRepets <= Len(aRepets[nRep,02]) // Reposiciono tabelas, variaveis auxiliares...
                                // Reposiciono tabelas
                                If Len(aRepets[nRep,02]) > 0 .And. nRepets <= Len(aRepets[nRep,02]) // Tabelas/Recnos de repeticao
                                    For _w2 := 1 To Len(aRepets[nRep,02,nRepets])
                                        DbSelectArea(aRepets[nRep,02,nRepets,_w2,01])                                // Abro a tabela
                                        If aRepets[nRep,02,nRepets,_w2,02] > 0
                                            (aRepets[nRep,02,nRepets,_w2,01])->(DbGoto(aRepets[nRep,02,nRepets,_w2,02]))    // Posiciono no registro
                                        Else // Sem posicao
                                            (aRepets[nRep,02,nRepets,_w2,01])->(DbGoBottom())
                                            (aRepets[nRep,02,nRepets,_w2,01])->(DbSkip()) // Deixo em EOF
                                        EndIf
                                    Next
                                EndIf
                                // Variaveis auxiliares
                                If Len(aRepets[nRep,03]) > 0 .And. nRepets <= Len(aRepets[nRep,03]) // Variaveis auxiliares de repeticao
                                    For _w2 := 1 To Len(aRepets[nRep,03,nRepets])
                                        &(aRepets[nRep,03,nRepets,_w2,01]) := aRepets[nRep,03,nRepets,_w2,02] // Variavel recebe conteudo
                                    Next
                                EndIf
                            EndIf
                            nRepSta := _w
                        Else // Fim, entao zero o nRepets
                            If nRepets == Len(aRepets[nRep,02]) // Ja acabou
                                nRepets := 0
                                nRepSta := 0
                            Else // Ainda faltam repeticoes
                                lRepets := .T.
                            EndIf
                        EndIf
                    Else // Se nao existe na montagem, entao nao continuo ate sair do repets
                        If nJump == 1
                            nJump := 3 // 3=No final reativo integracoes
                        Else
                            nJump := 1
                        EndIf
                    EndIf
                EndIf
                If nJump == 0 // 0=Sem pulo de repeticao
                    // Reset das Variaveis de informacoes
                    xDado := ReseVars(cTip, nTam, nDec)
                    // Elemento 04: Validacao pre-carregamento
                    If &(aMoldes[_w,02,04]) // Validacao pre-carregamento origem         Ex: "SB1->(!EOF())             ZT2_CONDI1
                        // Elemento 05: Montagem da variavel temporaria 'xDado' a partir da Origem da Informacao        ZT2_ORIGEM
                        xDado := &(aMoldes[_w,02,05]) // Variavel temporaria             Ex: "SB1->B1_COD"
                    EndIf
                    // Elemento 06: Condicao para consideracao do campo ja carregado em 'xDado' ou nao
                    // Caso invalido, todo o registro eh desconsiderado na integracao
                    If &(aMoldes[_w,02,06]) // Condicao                                                                 ZT2_CONDI2
                        // Elemento 07: Tratamento da informacao em 'xDado'             Ex: "PadR(xDado,nTam)           ZT2_TRATA1
                        If !Empty( aMoldes[_w,02,07])
                            xDado := &(aMoldes[_w,02,07])
                        EndIf
                        // Elemento 08: Questao das Aspas Duplas (Usado em montagens Json)                              ZT2_ASPDUP
                        If &(aMoldes[_w,02,08]) // Aspas Duplas                      Ex: ".T."
                            If At("=",xDado) > 0
                                xDado := Stuff(xDado,At('=',xDado),1,'="')
                                If Rat(" ",xDado) > 0
                                    xDado := Stuff(xDado,Rat(' ',xDado),1,'" ')
                                EndIf
                            ElseIf At(">",xDado) > 0
                                xDado := Stuff(xDado,At('>',xDado),1,'>"')
                                If Rat("<",xDado) > 0
                                    xDado := Stuff(xDado,Rat('<',xDado),1,'"<')
                                EndIf
                            EndIf
                        EndIf
                        // Elemento 09: Tratamento final apos Aspas Duplas
                        If !Empty(aMoldes[_w,02,09]) //                                                                 ZT2_TRATA2
                            xDado := &(aMoldes[_w,02,09])
                        EndIf
                        aAdd(aResult[nResult], xDado) // Inclusao de cada elemento processado na matriz resultado
                    Else // Nao valido pre-carregamento, entao registro sera desconsiderado
                        ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Validacao pre-carregamento nao atendida em: " + aMoldes[ _w, 01, 01 ])
                        // aSize(aResult, --nResult) // Removo este ultimo elemento (desconsiderado)
                        // Exit
                    EndIf
                    If lRepets // .T.=Repetir a partir do nRepSta
                        _w := nRepSta - 1 // Volto pro inicio da repeticao
                        nRepSta := 0
                    EndIf
                EndIf
                If nJump == 3
                    nJump := 0 // Removo jump de repeticao
                EndIf
                _w++
            End
        EndIf
    Next
	If nMsgPrc == 2 // 2=AskYesNo
		For _z1 := 1 To 4
			u_AtuAsk09(++nCurrent,"Integracao Totvs -> Thomson","Processando dados... Sucesso!", "", "", 80, "OK")
			Sleep(030)
		Next
	EndIf
    ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Registros carregados: " + cValToChar(Len(aResult)))
EndIf
ConOut("LoadDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
ConOut("")
Return aResult

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ ReseVars บAutor ณJonathan Schmidt Alvesบ Data ณ 29/06/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para reset das variaveis conforme os tipos/etc.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Parametros recebidos:                                      บฑฑ
ฑฑบ          ณ cTip: Tipo do dado para o reset.                           บฑฑ
ฑฑบ          ณ       Exemplo: "C"=Char "N"=Numerico                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ nTam: Tamanho do dado para o reset.                        บฑฑ
ฑฑบ          ณ       Exemplo: 10                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ nDec: Tamanho do dado decimal para o reset.                บฑฑ
ฑฑบ          ณ       Exemplo: 2                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ReseVars(cTip, nTam, nDec)
Local cRes := ""
If cTip == "C" // Char
    cRes := Iif(nTam > 0, Space(nTam), "")
ElseIf cTip == "N" // Num
    If nDec > 0
        cRes := Replicate("0", nTam - nDec) + "." + Replicate("0",nDec)
    Else
        cRes := Iif(nTam > 0, Replicate("0",nTam), "")
    EndIf
ElseIf cTip == "D" // Data
    cRes := Replicate(" ",nTam)
EndIf
Return cRes

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ GrvsDads บAutor ณJonathan Schmidt Alvesบ Data ณ 29/06/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gravacoes dos resultados nos arquivos para integracao.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Esta funcao faz a gravacao dos arquivos magneticos e tambemบฑฑ
ฑฑบ          ณ faz a gravacao dos arquivos de logs de processamento.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Nos arquivos de log de processamento podemos identificar   บฑฑ
ฑฑบ          ณ os tipos de registros, as datas+horas de disparo bem como  บฑฑ
ฑฑบ          ณ sucesso ou falha na concretizacao dos processamentos.      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ Parametros recebidos:                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ nMsgPrc: Tipo de mensagem de processamento                 บฑฑ
ฑฑบ          ณ       Exemplo: 2=AskYesNo                                  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ cTabLog: Tabela de Logs conforme o processo em questao.    บฑฑ
ฑฑบ          ณ         Exemplo: "ZB1", "ZD1", etc                         บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ cArqDes: Arquivo destino onde serao gravados os dados.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ         Exemplo: "PRDDMM_HHMMSS.TXT"                       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ aResult: Matriz de resultados montados (dados gravacoes).  บฑฑ
ฑฑบ          ณ         Estrutura preparada em Linhas + Colunas.           บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ aMoldes: Matriz mestre de moldes.                          บฑฑ
ฑฑบ          ณ         Estrutura segue os layouts de cada integracao.     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ cDtHrP: Data + Hora de Processamento                       บฑฑ
ฑฑบ          ณ         Data e Hora do processamento do arquivo e log      บฑฑ
ฑฑบ          ณ         Exemplo: "1905_202000"                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function GrvsDads(nMsgPrc, cTabLog, cArqDes, aResult, aMoldes, cDtHrP)
Local lRet := .T.
Local _w1
Local _w2
Local _w3
Local _z1
Local nHdl := Nil
Local cDado := ""
Local cDados := ""
Local nLines := 0
Local aRgsLg := {}
ConOut("")
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Parametros recebidos:")
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " cTabLog: " + cTabLog)
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " cArqDes: " + cArqDes)
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aResult: (matriz de resutados para gravacao)")
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " aMoldes: (matriz de moldes layout)")
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " cDtHrP: " + cDtHrP)
If Len(aResult) > 0 // Dados para gravacao
	If nMsgPrc == 2 // 2=AskYesNo
		For _z1 := 1 To 4
			u_AtuAsk09(++nCurrent,"Integracao Totvs -> Thomson","Gravando dados...", "", "", 80, "PROCESSA")
			Sleep(030)
		Next
	EndIf
    ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Avaliando dados para gravacao...")
    ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Registros: " + cValToChar(Len(aResult)))
    If !File("C:\TEMP")	// Verifico se o diretorio existe
        MakeDir("C:\TEMP") // Cria a pasta local
    EndIf
    If lRet // Dados todos validos... iniciar a gravacao
        ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Dados todos validos... iniciando gravacoes... (arquivo/logs)")
        // Gravacao do arquivo e dos logs
        nHdl := fCreate(cArqDes, Nil, Nil, .F.) // Cria arquivo txt
        If nHdl >= 0 // Sucesso na criacao do arquivo
            For _w1 := 1 To Len(aResult) // Rodo em cada linha montada no aResult
                If !Empty(cTabLog)
                    RecLock(cTabLog,.T.)
                    &(cTabLog + "->" + cTabLog + "_FILIAL") := xFilial(cTabLog)
                EndIf
                cDado := ""
                For _w2 := 1 To Len(aResult[_w1]) // Conferencia nos tamanhos
                    cDado += aResult[_w1,_w2] // Concatenando sempre (tudo como char mesmo)
                    If !Empty(cTabLog)
                        &( cTabLog + "->" + aMoldes[_w2,02,08]) := aResult[_w1,_w2] // Gravando campos de Logs
                    EndIf
                Next
                // cDado += Chr(13) + Chr(10) // Pula linha
                cDados += cDado
                fWrite(nHdl, cDado, Len(cDado)) // Gravo dados no arquivo
                If !Empty(cTabLog)
                    &(cTabLog + "->" + cTabLog + "_DTHRLG") := cDtHrP       // Data + Hora do Processamento                 Ex: "1905_202000"
                    &(cTabLog + "->" + cTabLog + "_STATLG") := "1"          // Status da geracao do log                     Ex: "1"=Em Geracao "2"=Gerado com sucesso
                    (cTabLog)->(MsUnlock())
                    aAdd(aRgsLg, (cTabLog)->(Recno())) // Inclusao dos registros para marcadao de "2"=Gerado com sucesso no final
                EndIf
            Next
            fClose(nHdl) // Finaliza processo e fecha arquivo
            If !Empty(cTabLog)
                // Concretizacao dos logs como "2"=Gerados (evitando erros no meio das geracoes)
                ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concretizando logs...")
                For _w3 := 1 To Len(aRgsLg)
                    (cTabLog)->(DbGoto(aRgsLg[_w3]))
                    RecLock(cTabLog,.F.)
                    &(cTabLog + "->" + cTabLog + "_ARQPRC") := SubStr(cArqDes, Rat( "\",cArqDes) + 1,20)    // Obtencao do nome do arquivo                  // Arquivo de processamento                     Ex: "PR1905_202000.TXT"
                    &(cTabLog + "->" + cTabLog + "_STATLG") := "2"          								// Status da geracao do log                     Ex: "2"=Gerado com sucesso
                    (cTabLog)->(MsUnlock())
                Next
                ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concretizando logs... Concluido!")
                ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Dados todos validos... iniciando gravacoes... (arquivo/logs) Concluido!")
            EndIf
        Else // Falha na criacao do arquivo
            ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Falha na criacao do arquivo (fCreate)!")
            ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Detalhe da falha:")
            ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + AllTrim(Ferror()))
        EndIf
		If nMsgPrc == 2 // 2=AskYesNo
			For _z1 := 1 To 4
				u_AtuAsk09(++nCurrent,"Integracao Totvs -> Thomson","Gravando dados... Sucesso!", "", "", 80, "OK")
				Sleep(030)
			Next
		EndIf
    EndIf
Else // Dados nao disponibilizados para gravacao
    ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Dados nao disponibilizados para geracao do arquivo!")
    MsgStop("Dados nao disponibilizados para geracao do arquivo!","GrvsDads")
    lRet := .F.
EndIf
ConOut("GrvsDads: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
ConOut("")
Return { lRet, nLines, cDados }

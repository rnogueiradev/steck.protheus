#INCLUDE "JSON.CH"
#INCLUDE "SHASH.CH"
#INCLUDE "AARRAY.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ STWEB080 ºAutor³ Jonathan Schmidt Alves ºData ³ 07/02/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de Pedidos de Venda a partir de pedidos de compra. º±±
±±º          ³                                                            º±±
±±º          ³ STWEB070.PRW: Preparacao da chamada na origem              º±±
±±º          ³      StWeb071(): Inicio do processamento                   º±±
±±º          ³      StWeb072(): Montagem das matrizes aCabec/aItens       º±±
±±º          ³      StWeb073(): Chamada webservice Rest                   º±±
±±º          ³                                                            º±±
±±º          ³ STWEB080.PRW: Processamento da chamada no destino          º±±
±±º          ³      StWeb081(): Inicio do processamento                   º±±
±±º          ³      StWeb082(): Processamento do ExecAuto MATA410         º±±
±±º          ³      StWeb083(): Adequacoes ExecAuto no ambiente           º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ StWeb081 ºAutor³ Jonathan Schmidt Alves ºData ³ 07/02/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inicio dos processamentos para geracao do pedido de venda. º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

WSRESTFUL StWeb081 DESCRIPTION "Ped Compra -> Ped Venda"
WSMETHOD POST DESCRIPTION "Ped Compra -> Ped Venda" WSSYNTAX "/rest/StWeb081"
END WSRESTFUL

WSMETHOD POST WSSERVICE StWeb081
Local _w1
Local cResp := ""
Local cEmp := ""
Local cFil := ""
Local aRet := { .T., "", "", "", "", Nil, Nil, Nil, Nil, Nil, "" }
Local aResult := {}
Private oJson
Private cJson := ""
Private aDados := { Array(0), Array(0), Array(0) }
Private cUserName := "Totvs"
ConOut("")
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " ########################## StWeb081: Geracao de Pedidos de Venda #########################")
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Json recebido: ")
ConOut(cJson := ::GetContent())
// ################### Adequacao Json -> Matrizes ExecAuto #####################
// Estrutura aRet:
// {   01,     02,     03,     04,     05,      06,      07,     08,     09,    10,    11 }
// { lVld, cMsg01, cMsg02, cMsg03, cMsg04, cCodEmp, cCodFil, aCabec, aItens, aPrcs, cJson }
// Json em Objeto
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Carregando dados para o objeto oJson...")

oJson := JsonObject():New()
oJson := FromJson( cJson )
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Carregando dados para o objeto oJson... Concluido!")
// Emp
cEmp := oJson:aData[01,02]                                                          // Empresa                      Ex: "03"
// Fil
cFil := oJson:aData[02,02]                                                          // Filial                       Ex: "01"
// Logando na empresa/filial conforme
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Abrindo Empresa/Filial: " + cEmp + "/" + cFil + "...")
//RpcSetType(3)
//RpcSetEnv(cEmp, cFil, Nil, Nil, "FAT")
_aTabsFile	:= {"SX5","SB1","SB2","SBM","SB5","SES","SM2","SYP",/*"XXJ",*/"SA1","SA2","SA4","SC1","SC5","SC6","SC7","SY1","SAH","NNR","SYD","SF4","SE2","SED", "ZRP" } // Array contendo os Alias a serem abertos na troca de Emp/Fil
_aTabsSX	:= {"SIX","SX1","SX2","SX3","SX4","SX6","SX7","SXB","SXA","SXD","SX9","SXK","SXO"} // ,"SXP","SXQ","SXR","SXT","SXS","SXU","SXV"} // Array contendo os Alias SXs a serem abertos na troca de Emp/Fil
//u_UPDEMPFIL( cEmp, cFil, _aTabsSX, _aTabsFile) // Altera ambiente empresa/filial para a filial da variavel cFil
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Abrindo Empresa/Filial: " + cEmp + "/" + cFil + "... Concluido!")
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Processando dados do objeto oJson para as matrizes (Cabec/Itens/Procs)...")
// Cabec
aCabec := oJson:aData[03,02,01]:aData                                               // Cabecalho                    Dados do cabecalho SC5
ChckDads( @aCabec )
aEval(aCabec, {|x|, aAdd(x, Nil) })                                                 // Adequacao
aDados[01] := aClone(aCabec)                                                        // Inclusao na matriz
// Itens
aItens := oJson:aData[04,02,01]:aData                                               // Itens
For _w1 := 1 To Len( aItens )
    aItem := aItens[_w1,02]:aData                                                   // Matriz com itens             Dados dos itens SC6
    ChckDads( @aItem )                                                              // Adequacao
    aEval(aItem, {|x|, aAdd(x, Nil) })                                              // Adequacao
    aAdd(aDados[02], aClone(aItem))                                                 // Inclusao na matriz
Next
// Procs
aProcs := oJson:aData[05,02,01]:aData
For _w1 := 1 To Len( aProcs )
    aProc := aProcs[_w1,02]:aData                                                   // Matriz com itens             Blocos de codigo para processamento
    aProc[02,02] := &(aProc[02,02])                                                 // Adequacao bloco de codigo
    aAdd(aDados[03], { aProc[01,02], aProc[02,02], aProc[03,02], aProc[04,02] })    // Inclusao na matriz
Next
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Processando dados do objeto oJson para as matrizes (Cabec/Itens/Procs)... Concluido!")
// Estrutura aDados:
// {     01,     02,     03 }
// { aCabec, aItens, aProcs }
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Adequando matriz mestre de processamento...")
aRet[08] := aClone( aDados[01] ) // aCabec
aRet[09] := aClone( aDados[02] ) // aItens
aRet[10] := aClone( aDados[03] ) // aProcs
aRet[11] := cJson                // Json
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Cabec: " + cValToChar(Len(aRet[08])) )
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Itens: " + cValToChar(Len(aRet[09])) )
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Procs: " + cValToChar(Len(aRet[10])) )
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Adequando matriz mestre de processamento... Concluido!")
// ############################ Fim da Adequacao  ############################
// Segue processamento das Adequacoes e ExecAuto
aResult := u_StWeb082( aRet )
If aResult[01] // .T.=Sucesso no processamento
    cResp := '{ "Result": 0, "Msg01": "' + aResult[02] + '","Msg02": "' + aResult[03] + '","Msg03": "' + aResult[04] + '" }' // Detalhes do processamento
Else // .F.=Falha
    cResp := '{ "Result": -1, "Msg01": "' + aResult[02] + '","Msg02": "' + aResult[03] + '","Msg03": "' + aResult[04] + '" }' // Detalhes da falha
EndIf
::SetResponse(cResp)
ConOut("StWeb081: " + DtoC(Date()) + " " + Time() + " " + cUserName + " ########################## StWeb081: Concluido #########################")
ConOut("")
Return .T.

/*
*/

Static Function ChckDads( aDados )
	Local _w1
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // X3_CAMPO
// Adequacao Cabec
	For _w1 := 1 To Len(aDados)
		If SX3->(DbSeek(aDados[_w1,01]))
			If SX3->X3_TIPO == "D"
				aDados[_w1,02] := StoD(aDados[_w1,02])
			EndIf
		EndIf
	Next
	SX3->(DbSetOrder(1)) // X3_ARQUIVO + X3_ORDEM
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ StWeb082 ºAutor³ Jonathan Schmidt Alves ºData ³ 16/02/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento do ExecAuto MATA410 (Pedido de Venda) no     º±±
±±º          ³ ambiente destino.                                          º±±
±±º          ³                                                            º±±
±±º          ³ Parametros recebidos:                                      º±±
±±º          ³ aRet[ 01 ]   .T.=Sucesso no processamento .F.=Falha        º±±
±±º          ³     [ 02 ]   Mensagem 01 da falha                          º±±
±±º          ³     [ 03 ]   Mensagem 02 da falha                          º±±
±±º          ³     [ 04 ]   Mensagem 03 da falha                          º±±
±±º          ³     [ 05 ]   Mensagem 04 da falha                          º±±
±±º          ³     [ 06 ]   Empresa para processamento  Ex: "03"          º±±
±±º          ³     [ 07 ]   Filial para processamento   Ex: "01"          º±±
±±º          ³     [ 08 ]   Matriz cabecalho ExecAuto MATA410             º±±
±±º          ³     [ 09 ]   Matriz itens ExecAuto MATA410                 º±±
±±º          ³     [ 10 ]   Matriz de adequacoes na base                  º±±
±±º          ³     [ 11 ]   Json montado para integracao webservice       º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function StWeb082( aRet )
Local _w1
Local _w2
Local lRet := .F.
Local cMsg01 := ""
Local cMsg02 := ""
Local cMsg03 := ""
Local aResult := {}
LOCAL _cArq  := ""
LOCAL _cDir  := ""
LOCAL	_cFile := ""
LOCAL _cEmail   := ""
LOCAL _cCopia   := ""
LOCAL _cAssunto := ""
LOCAL _aAttach  := {}
LOCAL _cCaminho := ""
LOCAL _cMsg     := ""
LOCAL nX := 0 
//LOCAL _cArq := ""
//LOCAL _cDir := ""
LOCAL aVetErro := {}
LOCAL _cErro := ""
LOCAL cMsgRet := ""
//LOCAL _cFile := ""
LOCAL nHdlXml := 0
LOCAL _cRetorno := ""
Local _cQuery   := ""

//>>
Local _cCodcli	:= ""
Local _cLojcli	:= ""
Local _cProd	:= ""
Local _cCondpg	:= ""
Local _cOper	:= ""
Local _cTipoCli := "S"
Local _cConsumo := ""
Local _cTabela 	:= ""
Local _cPedCom := ""
Local _cPedVen := ""

PRIVATE _XTES	      := ""
//<<
Private lMsErroAuto  := .F.
Private cCodSeq := "000001"
Private _cFilZCA := xFilial("ZCA")

ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
DbSelectArea("SX3")
SX3->(DbSetOrder(2)) // X3_CAMPO

/*
DbSelectArea("ZCA")
ZCA->(DbSetOrder(1)) // ZCA_FILIAL + ZCA_CODSEQ + ZCA_ITESEQ
If ZCA->(DbSeek(_cFilZCA))
    ZCA->(DbSeek(_cFilZCA + "999999",.T.))
    ZCA->(DbSkip(-1))
    cCodSeq := Soma1(ZCA->ZCA_CODSEQ,4)
EndIf-
*/

// Processamento do aCabec, aItens na base do ExecAuto
	ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Processamentos StWeb083...")
	aResult := u_StWeb083( @aRet[08], @aRet[09], aRet[10] ) // Adequa aCabec e aItens por referencia (processando na base, ou seja, depois do WebService)
	ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Processamentos StWeb083... Concluido!")
	If aResult[01] // .T.=Adequacoes/Posicionamentos ExecAuto realizados com sucesso
		ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Apresentando Dados do Cabecalho ExecAuto...")
		For _w1 := 1 To Len( aRet[08] ) // Cabecalho
			If SX3->(DbSeek( aRet[08,_w1,01] ))
				ConOut(aRet[08,_w1,01] + ": " + &({ "aRet[08,_w1,02]", "cValToChar(aRet[08,_w1,02])", "DtoC(aRet[08,_w1,02])" } [ At(SX3->X3_TIPO,"CND") ]))
				//>>

				If aRet[08,_w1,01] $ "C5_TABELA"
					_cTabela := aRet[08,_w1,02]
				EndIf

				If aRet[08,_w1,01] $ "C5_CLIENTE"
					_cCodcli := aRet[08,_w1,02]
				EndIf

				If aRet[08,_w1,01] $ "C5_LOJACLI"
					_cLojcli := aRet[08,_w1,02]
				EndIf

				If aRet[08,_w1,01] $ "C5_ZCONDPG"
					_cCondpg := aRet[08,_w1,02]
				EndIf
				//<<

            /*
            RecLock("ZCA",.T.)
            ZCA->ZCA_FILIAL := _cFilZCA             // Filial
            ZCA->ZCA_CODSEQ := cCodSeq              // Codigo sequencial
            ZCA->ZCA_ITESEQ := StrZero(_w1,6)       // Item sequencial
            ZCA->ZCA_CABFLD := aRet[08,_w1,01]      // Field
            &("ZCA->ZCA_CAB" + { "CHR", "NUM", "DAT" } [ At(SX3->X3_TIPO,"CND") ]) := aRet[08,_w1,02]       // Informacao
            ZCA->(MsUnlock())
            */
			EndIf
		Next
		ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Apresentando Dados do Cabecalho ExecAuto... Concluido!")
		ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Apresentando Dados dos Itens ExecAuto...")
		For _w1 := 1 To Len( aRet[09] ) // Itens
			For _w2 := 1 To Len( aRet[09,_w1] ) // Rodo nos dados de cada item
				If SX3->(DbSeek( aRet[09,_w1,_w2,01] ))
					ConOut(aRet[09,_w1,_w2,01] + ": " + &({ "aRet[09,_w1,_w2,02]", "cValToChar(aRet[09,_w1,_w2,02])", "DtoC(aRet[09,_w1,_w2,02])" } [ At(SX3->X3_TIPO,"CND") ]))

					//>>
					If Alltrim(aRet[09,_w1,_w2,01]) $ "C6_PRODUTO"
						_cProd := aRet[09,_w1,_w2,02]
					EndIf

					If Alltrim(aRet[09,_w1,_w2,01]) $ "C6_OPER"
						_cOper := aRet[09,_w1,_w2,02]
					EndIf

					If Alltrim(aRet[09,_w1,_w2,01]) $ "C6_TES"
						//u_STTESINTELIGENTE()
						aRet[09,_w1,_w2,02] := U_STRETSST(_cOper,_cCodcli ,_cLojcli,_cProd,_cCondpg,'TES' ,.F. ,_cTipoCli,_cConsumo,_cTabela,@_XTES)
					EndiF
					//<<
				EndIf
			Next
		Next
		SX3->(DbSetOrder(1)) // X3_ARQUIVO + X3_ORDEM
		ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Apresentando Dados dos Itens ExecAuto... Concluido!")
		ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Processando ExecAuto MATA410...")

		//// Empresa Manaus
        IF cEmpAnt = "03" .AND. cFilAnt = "01"
			_cEmail   := GETMV("MSTECK018",,"renato.oliveira@steck.com.br;tamires.eufrazio@steck.com.br;lucas.medeiros@steck.com.br")
		ELSEIF cEmpAnt = "01" .AND. cFilAnt = "05"
			_cEmail   := GETMV("MSTECK018",,"renato.oliveira@steck.com.br;thiago.ribeiro@steck.com.br;rodrigo.ferreira@steck.com.br")
		ENDIF

		lMsErroAuto := .F.
		MsExecAuto({|x,y,z|, MATA410(x,y,z) }, aRet[08], aRet[09], 3)
		If lMsErroAuto = .T. // .T.=Falha no execauto

		/*********************************
		Trata o erro do execauto
		*********************************/
		_cArq := "StWeb082_"+dtos(date())+Substr(time(),1,2) + Substr(time(),4,2)+".log"
		_cDir := "\arquivos\logs\"
		IF !ExistDir(_cDir)
			Makedir(_cDir)
		ENDIF

		_cErro := MostraErro(_cDir,_cArq)
		IF EMPTY(_cErro)
			aVetErro := GetAutoGRLog()	
			FOR nX := 1 TO LEN(aVetErro)		
				_cErro += aVetErro[nX]
			NEXT Nx
		ENDIF

		IF EMPTY(cMsgRet)
			_cRetorno := _cErro 
		ELSE
			_cRetorno := cMsgRet + " - " + _cErro
			_cErro    := _cRetorno
		ENDIF 

		/************************************
		Grava o arquivo de log na pasta:
		************************************/
		_cFile  := _cDir + _cArq  
		nHdlXml := FCreate(_cFile,0)
		IF nHdlXml > 0
			FWrite(nHdlXml,_cErro)
			FClose(nHdlXml)		
		ENDIF		

        _cCopia   := ""
        _cAssunto := "[WFPROTHEUS] Erro na Geração do Pedido de Venda na Indústria - Pedido de compra: "+aRet[09,1,12,2]
        _aAttach  := {}
        _cCaminho := ""
        _cMsg     := ""
		// Definicao do cabecalho do email
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>'+_cAssunto+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<Img Src="https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>'+_cAssunto +'</FONT> </Caption></Table><BR>'

		// Definicao do texto/detalhe do email                                         ï¿½
		FT_FUSE(_cFile)
		FT_FGOTOP()
		WHILE !FT_FEOF()
   	   cMsg += '<tr>'+Ft_FReadLn()+'</tr><br>'
		 FT_FSKIP()
		ENDDO
		// Definicao do rodape do email
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">(STWEB080)</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'
    U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

    ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Processando ExecAuto MATA410... Falha!")
		cMsg01 := "Erro ao inserir o Pedido de Venda via execauto!"
  	Else // .F.=Sucesso no execauto
        ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Processando ExecAuto MATA410... Sucesso!")
        cMsg01 := "Pedido de Venda gerado com sucesso na empresa/filial destino!"
        cMsg02 := "Empresa/Filial: " + cEmpAnt + "/" + cFilAnt
        cMsg03 := "Pedido: " + SC5->C5_NUM
        lRet := .T.

			//// Empresa Manaus
			IF cEmpAnt = "03" .AND. cFilAnt = "01"
				_cEmail   := GETMV("MSTECK018",,"renato.oliveira@steck.com.br;tamires.eufrazio@steck.com.br;lucas.medeiros@steck.com.br")
			ELSEIF cEmpAnt = "01" .AND. cFilAnt = "05"
				_cEmail   := GETMV("MSTECK018",,"renato.oliveira@steck.com.br;thiago.ribeiro@steck.com.br;rodrigo.ferreira@steck.com.br")
			ENDIF
			_cCopia   := ""
			_cAssunto := "[WFPROTHEUS] Pedido de Venda gerado com sucesso: "+SC5->C5_NUM
			_aAttach  := {}
			_cCaminho := ""
			_cMsg     := ""
			// Definicao do cabecalho do email
			cMsg := ""
			cMsg += '<html>'
			cMsg += '<head>'
			cMsg += '<title>'+_cAssunto+'</title>'
			cMsg += '</head>'
			cMsg += '<body>'
			cMsg += '<Img Src="https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42"><BR>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>'+_cAssunto +'</FONT> </Caption></Table><BR>'

			// Definicao do texto/detalhe do email                                         ï¿½
            cMsg := '<tr>Pedido de Venda gerado com sucesso na empresa/filial destino!</tr><br>'
            cMsg := '<tr>Empresa/Filial: '+cEmpAnt+"/"+cFilAnt+'</tr><br>'
            cMsg := '<tr>Pedido: '+SC5->C5_NUM+'</tr><br>'

			// Definicao do rodape do email
			cMsg += '<P>'
			cMsg += '<Table align="center">'
			cMsg += '<tr>'
			cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">(STWEB080)</td>'
			cMsg += '</tr>'
			cMsg += '</Table>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '</body>'
			cMsg += '</html>'
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

            //>>Ticket 20220823016275 - Everosn Santana - 23.08.2022

			//// Empresa Manaus
			cQuery := " "

			IF cEmpAnt = "03" .AND. cFilAnt = "01"

				cQuery := "SELECT C6.C6_PRODUTO,C6.C6_FILIAL,C6.C6_NUM,C6.C6_ITEM,C6.C6_NUMPCOM,C6.C6_ITEMPC FROM "+AllTrim(GetMv("STALIASIND"))+".SC6030 C6 "
				cQuery += "WHERE C6.D_E_L_E_T_ = ' ' "
				cQuery += "AND C6.C6_NUM = '"+SC5->C5_NUM+"' "
				cQuery += "AND C6.C6_FILIAL = '"+cFilAnt+"' "				
				cQuery += "ORDER BY C6.C6_ITEM"
				cQuery := ChangeQuery(cQuery)

				ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Select pedido de venda."+ALLTRIM(cQuery))
				DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)

				DbselectArea('TSC6')
				DbGotop()

				_cPedVen := SC5->C5_NUM
				_cPedCom := TSC6->C6_NUMPCOM

				WHILE TSC6->(!EOF())

					ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Update para atulizar item do produto!"+ALLTRIM(TSC6->C6_PRODUTO))

					_cQuery := " "
					_cQuery := " UPDATE "+AllTrim(GetMv("STALIASDIS"))+".SC7110 C7 "
					_cQuery += " SET C7.C7_XPEDGER = 'S', C7.C7_ZNUMPV = '" + SC5->C5_NUM + "' , C7.C7_XPEDVEN = '" + SC5->C5_NUM + "', C7.C7_XITEMPV = '"+TSC6->C6_ITEM+"', C7.C7_XDATAPV = '"+DTOS(DATE())+"' "
					_cQuery += " WHERE C7.D_E_L_E_T_ = ' ' "
					_cQuery += " AND C7_FILIAL = '01' "
					_cQuery += " AND C7_PRODUTO = '"+TSC6->C6_PRODUTO+"' "
					_cQuery += " AND C7_NUM = '"+Alltrim(TSC6->C6_NUMPCOM)+"' "
					_cQuery += " AND C7_ITEM = '"+Alltrim(TSC6->C6_ITEMPC)+"' "
				
					ConOut("1StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Update para atulizar o numero do pedido!"+ALLTRIM(_cQuery))

					nErrQry := TCSqlExec( _cQuery )

					If nErrQry <> 0
						Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
					EndIf

					TSC6->(DBSKIP())

				END
				TSC6->(DBCLOSEAREA())

				//>>
				_cQuery := " "
				_cQuery := " UPDATE "+AllTrim(GetMv("STALIASIND"))+".SC5030 SET C5_ZNUMPC = '"+Alltrim(_cPedCom)+"' "
				_cQuery += " WHERE C5_FILIAL = '01' "
				_cQuery += " AND C5_NUM = '"+_cPedVen+"' "
				_cQuery += " AND D_E_L_E_T_ = ' ' "

				nErrQry := TCSqlExec( _cQuery )

				If nErrQry <> 0
					Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
				EndIf
				//<<	
			ELSEIF cEmpAnt = "01" .AND. cFilAnt = "05"
						
				cQuery := "SELECT C6.C6_PRODUTO,C6.C6_FILIAL,C6.C6_NUM,C6.C6_ITEM,C6.C6_NUMPCOM,C6.C6_ITEMPC FROM "+AllTrim(GetMv("STALIASIND"))+".SC6010 C6 "
				cQuery += "WHERE C6.D_E_L_E_T_ = ' ' "
				cQuery += "AND C6.C6_NUM = '"+SC5->C5_NUM+"' "
				cQuery += "AND C6.C6_FILIAL = '"+cFilAnt+"' "
				cQuery += "ORDER BY C6.C6_ITEM"
				cQuery := ChangeQuery(cQuery)

				ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Select pedido de venda."+ALLTRIM(cQuery))
				DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)

				DbselectArea('TSC6')
				DbGotop()

				_cPedVen := SC5->C5_NUM
				_cPedCom := TSC6->C6_NUMPCOM				
				
				WHILE TSC6->(!EOF())

					ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Update para atulizar item do produto!"+ALLTRIM(TSC6->C6_PRODUTO))

					_cQuery := " "
					_cQuery := " UPDATE "+AllTrim(GetMv("STALIASDIS"))+".SC7110 C7 "
					_cQuery += " SET C7.C7_XPEDGER = 'S', C7.C7_ZNUMPV = '" + SC5->C5_NUM + "' , C7.C7_XPEDVEN = '" + SC5->C5_NUM + "', C7.C7_XITEMPV = '"+TSC6->C6_ITEM+"', C7.C7_XDATAPV = '"+DTOS(DATE())+"' "
					_cQuery += " WHERE C7.D_E_L_E_T_ = ' ' "
					_cQuery += " AND C7_FILIAL = '01' "
					_cQuery += " AND C7_PRODUTO = '"+TSC6->C6_PRODUTO+"' "
					_cQuery += " AND C7_NUM = '"+Alltrim(TSC6->C6_NUMPCOM)+"' "
					_cQuery += " AND C7_ITEM = '"+Alltrim(TSC6->C6_ITEMPC)+"' "
				
					ConOut("1StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Update para atulizar o numero do pedido!"+ALLTRIM(_cQuery))

					nErrQry := TCSqlExec( _cQuery )

					If nErrQry <> 0
						Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
					EndIf

					TSC6->(DBSKIP())

				END
				TSC6->(DBCLOSEAREA())
	  		ENDIF

			//>>
				_cQuery := " "
				_cQuery := " UPDATE "+AllTrim(GetMv("STALIASIND"))+".SC5010 SET C5_ZNUMPC = '"+Alltrim(_cPedCom)+"' "
				_cQuery += " WHERE C5_FILIAL = '05' "
				_cQuery += " AND C5_NUM = '"+_cPedVen+"' "
				_cQuery += " AND D_E_L_E_T_ = ' ' "

				nErrQry := TCSqlExec( _cQuery )

				If nErrQry <> 0
					Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
				EndIf
				//<<	
			//<< Ticket 20220823016275

		EndIf
Else // .F.=Falha nas Adequacoes/Posicionamentos
	cMsg01 := aResult[02]
	ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Mensagem da falha:")
	ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsg01)
EndIf
	ConOut("StWeb082: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
	
Return { lRet, cMsg01, cMsg02, cMsg03 }

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ StWeb083 ºAutor ³ Jonathan Schmidt Alves ºData³ 16/02/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preparacao dos execautos para processamento via webservice.º±±
±±º          ³                                                            º±±
±±º          ³ Realiza as adequacoes do aCabec e do aItens na base onde o º±±
±±º          ³ ExecAuto sera processando, fazendo as chamadas necessarias º±±
±±º          ³ conforme os Blocos de Codigo de montagem.                  º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function StWeb083( aCabec, aItens, aPrcs )
Local _w1
Local _w2
Local lRet := .T.
Local nFnd := 0
Local cMsgRet := ""
Local xDado := Nil
Private aMtrz := Array(0)
ConOut("StWeb083: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Iniciando...")
// Montagem aMtrz
aEval(aCabec, {|x| aAdd(aMtrz, x) })
For _w1 := 1 To Len( aItens )
    aEval(aItens[_w1], {|x| aAdd(aMtrz, x) })
Next
// Rodo em cada elemento (Cabec e aItens)
For _w1 := 1 To Len( aMtrz )
    If ValType( aMtrz[ _w1, 02 ] ) == "B"
        xDado := Eval( aMtrz[ _w1, 02 ] )
    Else
        xDado := aMtrz[ _w1, 02 ]
    EndIf
    For _w2 := 1 To 2 // 1=BF Before field      2=AF After field
        nFnd := 0
        While (nFnd := ASCan(aPrcs, {|x|, x[01] == aMtrz[_w1,01] }, nFnd + 1, Nil)) > 0
            If aPrcs[nFnd, 03 ] == { "BF", "AF" }[ _w2 ] // Before field, After field, After all
                If !(lRet := Eval( aPrcs[ nFnd, 02 ] )) // Falha no Evaluate (posicionamento/validacao)
                    cMsgRet := aPrcs[ nFnd, 04 ] // Mensagem da falha
                    Exit
                EndIf
            EndIf
        End
        If lRet // .T.=Sucesso
            If _w2 == 1 // "BF"=Before field
                &(aMtrz[_w1,01]) := xDado // Montagem das variaveis M->
                If ValType( aMtrz[ _w1, 02 ] ) == "B" // Abro o bloco de codigo
                    aMtrz[ _w1, 02 ] := xDado
                EndIf
            EndIf
        Else // Falha
            Exit
        EndIf
    Next
Next
If lRet // After all
    For _w1 := 1 To Len( aMtrz ) // Rodo em cada elemento (Cabec e aItens) 
        If aMtrz[ _w1, 01 ] == "C5_CLIENTE" // Cabec.. remonto todas as variaveis do Cabec
            For _w2 := _w1 To Len( aCabec )
                &( aMtrz[_w2,01] ) := aMtrz[_w2,02] // Remontagem de cada variavel
            Next
        ElseIf aMtrz[ _w1, 01 ] == "C6_ITEM" // Itens
            For _w2 := _w1 To _w1 + Len( aItens[01] ) - 1
                &( aMtrz[_w2,01] ) := aMtrz[_w2,02] // Remontagem de cada variavel
            Next
        EndIf
        nFnd := 0
        While (nFnd := ASCan(aPrcs, {|x|, x[01] == aMtrz[_w1,01] .And. x[03] == "AA" }, nFnd + 1, Nil)) > 0

            ConOut("StWeb083: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Evaluate Field: " + aPrcs[ nFnd, 01 ])
            If !(lRet := Eval( aPrcs[ nFnd, 02 ] )) // Falha no Evaluate (posicionamento/validacao)
                cMsgRet := aPrcs[ nFnd, 04 ] // Mensagem da falha
                Exit
            Else // Sucesso no evaluate
                aMtrz[ _w1, 02 ] := &( aPrcs[ nFnd, 01 ] )
            EndIf
        End
        If !lRet // Falha
            Exit
        EndIf
    Next
EndIf
If !lRet // .F.=Falha
    ConOut("StWeb083: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Mensagem da falha:")
    ConOut("StWeb083: " + DtoC(Date()) + " " + Time() + " " + cUserName + " " + cMsgRet)
EndIf
ConOut("StWeb083: " + DtoC(Date()) + " " + Time() + " " + cUserName + " Concluido!")
//     { .T.=Sucesso/.F.=Falha, Mensagem detalhe da Falha }
Return {                  lRet,                   cMsgRet }

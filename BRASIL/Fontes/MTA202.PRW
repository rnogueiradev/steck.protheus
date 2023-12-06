#include "PROTHEUS.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA202    ºAutor  ³Everlado Gallo      º Data ³  15/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verificar o Componente que esta sendo manipulado 			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MTA202()      
    // Valdemir 23/09/2019
    FWMsgRun(, {|| U_AjusPeso()} ,,"Aguarde, Ajustando Peso do Produto: "+cCodAtual)

    _lRet := u_mta200() // ponto exatamente igual ao ponto no cadastro de estruturas

Return _lRet


//--------------------------------------------------------------
/*/{Protheus.doc} Function AjusPeso
Description                                                     
Rotina para Ajustar o Peso do Produto Pai com base nos componentes
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br                                             
@since 23/09/2019                                                   
/*/                                                             
//--------------------------------------------------------------
User Function AjusPeso(cCodAtual)
    Local cQry      := ""
    Local aAreaAjus := GetArea()
    Local cCodProd  := ALLTRIM(cCodAtual)
    Local nTotPeso  := 0
    Local aDadosWF  := {}

    dbSelectArea("SB1")
    dbSetOrder(1)

    cQry := "SELECT " + CRLF
    cQry += "GG_COD, GG_COMP " + CRLF
    cQry += "FROM " + RETSQLNAME("SGG") + " SGG " + CRLF
    cQry += "WHERE SGG.D_E_L_E_T_ = ' ' " + CRLF 
    cQry += " AND SGG.GG_COD='" + cCodProd + "' " + CRLF
    cQry += " AND SGG.GG_FILIAL='" + XFILIAL("SGG") + "' " + CRLF
    TcQuery cQry New Alias "TAJUS"

    While TAJUS->( !Eof() )
        if SB1->( dbSeek(XFilial("SB1")+TAJUS->GG_COMP) )
           if SB1->B1_PESBRU > 0
              nTotPeso  += SB1->B1_PESBRU
           else 
              IF (aSCAN(aDADOSWF, {|X| X[1]==TAJUS->GG_COMP})==0)
                 aAdd(aDadosWF, {TAJUS->GG_COMP, SB1->B1_DESC, cCodProd} )
              ENDIF 
           Endif
        Endif 
        TAJUS->( dbSkip() )
    EndDo

    TAJUS->( dbCloseArea() )

    if nTotPeso > 0
       if SB1->( dbSeek(XFilial("SB1")+cCodProd) )
          RecLock("SB1",.F.)
          SB1->B1_PESBRU := nTotPeso
          MsUnlock()
       endif 
    Endif 

    IF LEN(aDadosWF) > 0
       EnvPrdWF(aDadosWF)
    ENDIF 

    RestArea( aAreaAjus )

Return


//--------------------------------------------------------------
/*/{Protheus.doc} Function AjusPeso
Description                                                     
Rotina para ENVIO DE WF para os componentes sem peso
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br                                             
@since 23/09/2019                                                   
/*/                                                             
//--------------------------------------------------------------
Static Function EnvPrdWF(aDadosWF)
    Local _cEmail   := SuperGetMV("STEMLAJPES",.F.,"valdemir.rabelo@sigamat.com.br")
    Local _cCopia   := ""
    Local _cAssunto := 'COMPONENTES SEM INFORMAÇÃO DO PESO'
    Local cMsg      := MTMntMsg(aDadosWF)
    Local _aAttach  := ""
    Local _cCaminho := ""

    U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} Function AjusPeso
Description                                                     
Rotina para montagem do corpo do e-mail
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br                                             
@since 23/09/2019                                                   
/*/                                                             
//-------------------------------------
Static Function MTMntMsg(aCols )
	Local cMsg      := ""
	Local cCaminho	:= ""
    Local _aMsg     := {}
    Local _cAssunto := 'COMPONENTES SEM INFORMAÇÃO DO PESO'
    Local cFornced  := cLojaFor := cNomeFor := ""
    Local nX
    Local _nLin

	 Aadd( _aMsg , { "Produto: "         , cValtoChar(ACOLS[1][3]) } )
    Aadd( _aMsg , { " "                 , '' } )
    // Apresenta as ações tomadas dos departamentos
    For nX := 1 to Len(aCols)
            Aadd( _aMsg , { "Componente: "      , aCols[Nx, 1] } )
            Aadd( _aMsg , { "Descrição: "       , aCols[Nx, 2] } )
            Aadd( _aMsg , { " "                 , '' } )
    Next

	//A Definicao do cabecalho do email
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//A Definicao do texto/detalhe do email
	For _nLin := 1 to Len(_aMsg)
		If _aMsg[_nLin][1]=="Componente: "
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf

		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

	Next

	//A Definicao do rodape do email
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

Return cMsg

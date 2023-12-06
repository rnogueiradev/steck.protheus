#INCLUDE "PROTHEUS.CH"
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MT120GRV.prw   | AUTOR | Ricardo Posman     | DATA | 08/12/2007 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | PE na gravacao do Pedido de Compra para buscar Motivo de        |//
//|           | Compra indicado na Solicitacao de Compra                        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

User Function MT120GRV()

Local lRet		:= .T.
Local aArea		:= GetArea()
Local aAreaSc7	:= SC7->(GetArea())
Local aAreaSC1	:= SC1->(GetArea())
Local _Mot		:= ""
Local _Comp		:= ""
Local _cMpv		:= ""
Local i			:= 0
Local _cNumPed	:= SC7->C7_NUM
Local _cUsrSoli := ""
Local _cUsrAprv := ""
Local _cEmaSoli := ""
Local _cEmaAprv := ""
Local nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEM" })
Local nPosMot	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_MOTIVO" })
Local nPosObs1	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_XOBS1"})
Local nObs := 0

Local _cMesMrp := ""
Local _cAnoMrp := ""

If IsInCallStack("u_STBenped") .Or. IsInCallStack("U_SCHMRP23") .Or. Type("__cZRPPed") == "C" //Caso Seja o execauto da nota de Beneficiamento
    Return .T.
EndIf

aAltObs1 := {}

For i:=1 to Len(aCols)

    If PARAMIXB[3]
        If Posicione("SC7",1,xFilial("SC7") + _cNumPed + aCols[i,nPosItem],"C7_XOBS1") <> aCols[i,nPosObs1]
            aAdd(aAltObs1,{_cNumPed, aCols[i,nPosItem], aCols[i,nPosObs1]})
        EndIf
    EndIf

    Dbselectarea("SC1")
    Dbsetorder(1)
    DbGotop() //>> Chamado 006693
    DBSEEK (Xfilial("SC1")+aCols[i,GdFieldPos("C7_NUMSC")]+ aCols[i,GdFieldPos("C7_ITEMSC")] )      //Nao deletado e nao vazio
    _Mot 	:= SC1->C1_MOTIVO
    _Comp	:= SC1->C1_COMPSTK
    _cMpv	:= SC1->C1_XEMAIL

    _cUsrSoli := SC1->C1_USER
    _cUsrAprv := SC1->C1_ZAPROV

    If ! Empty(_cUsrSoli)
        PswOrder(1)
        If PswSeek(_cUsrSoli,.T.)
            _aRetUser	:= PswRet(1)
            _cEmaSoli	:= alltrim(_aRetUser[1,14])
        EndIf
    EndIf

    If ! Empty(_cUsrAprv)
        If PswSeek(_cUsrAprv,.T.)
            _aRetUser	:= PswRet(1)
            _cEmaAprv	:= alltrim(_aRetUser[1,14])
        EndIf
    EndIf

    If Inclui .And. !(Empty(Alltrim(_cMpv)))
        aCols[i,GdFieldPos("C7_XEMAIL")] 	:= _cMpv
    Else
        aCols[i,GdFieldPos("C7_XEMAIL")] 	:= _cMpv
    EndIf

    If empty(_Mot)
        _Mot   := aCols[i,GdFieldPos("C7_MOTIVO")]
    Endif

    If empty(_Comp)
        _Comp   := aCols[i,GdFieldPos("C7_COMPSTK")]
    Endif
    aCols[i,GdFieldPos("C7_MOTIVO")] 	:= _Mot
    aCols[i,GdFieldPos("C7_COMPSTK")] 	:= _Comp
    If cEmpAnt = '01'
        If !(IsInCallStack("CNTA121")) .And. !(IsInCallStack("U_STCOM220"))
            aCols[i,GdFieldPos("C7_XMESMRP")] 	:= _cMesMrp
            aCols[i,GdFieldPos("C7_XANOMRP")] 	:= _cAnoMrp
        EndIf
    Endif

Next i

If ! Empty(aAltObs1)
    For nObs := 1 to Len(aAltObs1)

        _cEmail	:= ""
        If ! Empty(_cEmaSoli)
            _cEmail	+= _cEmaSoli
        EndIf

        If ! Empty(_cEmaAprv)
            If ! Empty(_cEmail)
                _cEmail += ";"
            EndIf
            _cEmail += _cEmaAprv
        EndIf

        //_cEmail		:= "richard.nahas@rvgsolucoes.com.br"

        _cCopia		:= ""
        _cAssunto	:= "[WFPROTHEUS] - Alteração Observação Pedido / Item: " + aAltObs1[nObs,1] + " / " + aAltObs1[nObs,2]

        cMsg		:= ""
        cMsg		+= '<html><head><title>' + Alltrim(SM0->M0_NOME) + "/" + Alltrim(SM0->M0_FILIAL) + '</title></head><body>'
        cMsg		+= '<b>Observação Protheus</b><BR><BR>'
        cMsg		+= '<b>'+Strtran(aAltObs1[nObs,3],chr(13)+chr(10),'<br>')+'</b><BR><BR></body></html>'

        _aAttach  	:= {}
        _cCaminho 	:= ''

            U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
            

    Next nObs
EndIf

If lRet .And. PARAMIXB[3]
    STLOGSC7()
EndIf

RestArea(aArea)
RestArea(aAreaSc7)
RestArea(aAreaSC1)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STLOGSC7	ºAutor  ³Renato Nogueira     º Data ³  22/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Log de alterações do pedido de compras						    º±±
±±º          ³	    							 	 				           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STLOGSC7()

Local _cMsg			:= ""
Local _lAlterou		:= .F.
Local _cNum			:= ""
Local _nX			:= 0
Public _aItensInc	:= {}

For _nX :=1 To Len(aCols)

    SC7->(DbGoTo(aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C7_REC_WT"})]))

    If SC7->(!Eof()) ////Verificar se houve alteração nas linhas

        _cMsg	:= ""
        _cMsg	+= "Usuário: "+cUserName+CRLF
        _cMsg	+= "Alterado em: "+DTOC(DATE())+" "+TIME()+CRLF
        _cMsg	+= "Campo               | Anterior                               | Novo                                   "+CRLF

        _cNum	:= SC7->C7_NUM

        If !(AllTrim(CCONDICAO)==AllTrim(SC7->C7_COND))
            _lAlterou	:= .T.
            _cMsg	+= PADR("C7_COND",20)+"|"+PADR(SubStr(SC7->C7_COND,1,40),40)+"|"+PADR(CCONDICAO,40)+CRLF
        EndIf
        `
        DbSelectArea("SX3")
        SX3->(DbSetOrder(1))

        If SX3->(DbSeek("SC7"))

            While ( SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SC7" )

                If !(SX3->X3_USADO=="€€€€€€€€€€€€€€€")

                    If SX3->X3_CONTEXT<>"V"

                        If aScan(aHeader,{|x| AllTrim(x[2])==AllTrim(SX3->X3_CAMPO)})>0

                            If !(aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])==AllTrim(SX3->X3_CAMPO)})]==SC7->&(SX3->X3_CAMPO)) //Campo alterado

                                _lAlterou	:= .T.

                                If SX3->X3_TIPO=="N"
                                    _cMsg	+= PADR(SX3->X3_CAMPO,20)+"|"+PADR(SubStr(CVALTOCHAR(SC7->&(SX3->X3_CAMPO)),1,40),40)+"|"+PADR(SubStr(CVALTOCHAR(aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])==AllTrim(SX3->X3_CAMPO)})]),1,40),40)+CRLF
                                ElseIf SX3->X3_TIPO $ "C#M"
                                    _cMsg	+= PADR(SX3->X3_CAMPO,20)+"|"+PADR(SubStr(SC7->&(SX3->X3_CAMPO),1,40),40)+"|"+PADR(SubStr(aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])==AllTrim(SX3->X3_CAMPO)})],1,40),40)+CRLF
                                ElseIf SX3->X3_TIPO=="D"
                                    _cMsg	+= PADR(SX3->X3_CAMPO,20)+"|"+PADR(SubStr(DTOC(SC7->&(SX3->X3_CAMPO)),1,40),40)+"|"+PADR(SubStr(DTOC(aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])==AllTrim(SX3->X3_CAMPO)})]),1,40),40)+CRLF
                                EndIf

                            EndIf

                        EndIf

                    EndIf

                EndIf

                SX3->(DbSkip())
            End

            If !Empty(_cMsg) .And. _lAlterou
                AADD(_aItensInc,{_cNum,aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C7_ITEM"})],_cMsg})
                _lAlterou	:= .F.
            EndIf

        EndIf

    Else //Linha nova

        _cMsg	:= ""
        _cMsg	+= "Usuário: "+cUserName+CRLF
        _cMsg	+= "Incluido em: "+DTOC(DATE())+" "+TIME()+CRLF
        _cMsg	+= "Item "+aCols[_nX][1]+" Produto "+aCols[_nX][2]+" foi incluido "+CRLF
        AADD(_aItensInc,{_cNum,aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C7_ITEM"})],_cMsg})

    EndIf

Next _nX

Return()

#Include "Protheus.ch"

/*/Protheus.doc EICSI400
Ponto de entrada para limpar a solicitação de compras depois que exclui a SI
@author Robson Mazzarotto
@since 28/03/2017
@version 12.1.25
@links_or_references https://tdn.totvs.com/pages/releaseview.action?pageId=6806908
/*/

User Function EICSI400()

Local aArea		:= GetArea()
Local cParam	:= ParamIXB
Local cStrDisabl
Local cStrEnable
Local cYellow	:= CLR_YELLOW
Local cEmail	:= ""
Local cCopia	:= ""
Local cAssunto	:= ""
Local cAprov	:= ""

If cParam == "GRV_EXCLUI"
	dbSelectArea("SC1")
	dbSetOrder(12)
	dbGoTop()
	If dbSeek(xFilial("SC1") + SW1->W1_SI_NUM)
		while !Eof() .And. SC1->C1_NUM_SI == SW1->W1_SI_NUM
			RecLock('SC1', .F.)
			SC1->C1_COTACAO := "IMPORT"
			SC1->C1_NUM_SI	:= ""
			SC1->C1_ZSTATUS	:= "1"
			SC1->( MsUnlock() )
			dbSkip()
		Enddo
	EndIf
EndIf

// Ticket 20210326004956 - Melhorias Sistemicas / Comex (EIC) - Passo 2
If cParam == "1"
	cStrEnable	:= "SW0->W0_XAPROV1 = ' ' .And. SW0->W0_XAPROV2 = ' ' "		// Sem nenhuma Aprovação realizada - Legenda Verde
	cYellow		:= "SW0->W0_XAPROV1 <> ' ' .And. SW0->W0_XAPROV2 = ' ' "	// Primeira aprovação realizada - Legenda Amarela
	cStrDisabl	:= "SW0->W0_XAPROV1 <> ' ' .And. SW0->W0_XAPROV2 <> ' ' "	// Duas aprovações realizadas - Legenda Vermelha
	aRdCores := {{cStrDisabl,"DISABLE"},{cStrEnable,"ENABLE"},{cYellow,"AMARELO"}}
EndIf

//Ticket 20220725014476
/*
If cParam == "DEPOIS_TELA_INCLUI"
	If nOpcA == 1
		SZI->( dbSetOrder(3) )	// ZI_FILIAL + ZI_CC + ZI_APROVP
		SZI->( dbGoTop() )
		If SZI->( dbSeek(xFilial("SZI") + SW1->W1_CTCUSTO) )
			cAprov := SZI->ZI_APROVP
			If Empty(M->W0_XAPROV1) .And. Empty(M->W0_XAPROV2)
				cAssunto := "Atencao - SI inclusa, aguardando a 1ª Aprovação."
				cEmail	 := UsrRetMail(cAprov)
				cCopia	 := UsrRetMail(RetCodUsr(M->W0_SOLIC))
				u_STWF400(M->W0__NUM, cAssunto, cEmail, cCopia)
			EndIf
		Else
			MsgAlert("Atenção - Não existe Aprovador para este Centro de Custo" + Chr(13) + Chr(10) +;
					 "Favor verificar. - P.E.: EICSI400")
		EndIf
	EndIf
EndIf
*/

RestArea(aArea)

Return

/*/Protheus.doc STWF400
(long_description) Montagem do Array para envio do WF conforme Aprovação
@author user Eduardo Pereira - Sigamat
@since 15/04/2021
@version 12.1.25
/*/

User Function STWF400(cNumSW0, cAssunto, cEmail, cCopia)

Local _aMsg	:= {}

aAdd(_aMsg,{ "Filial", "SI" })

// 		    Filial			Nro SI
//			01				02
aAdd(_aMsg,{cFilAnt, cNumSW0})

If Len(_aMsg) > 1
    STWF400A(_aMsg, cNumSW0, cAssunto, cEmail, cCopia)
EndIf

cEmail	:= ""
_aMsg   := {}
aAdd(_aMsg,{ "Filial", "SI" })

Return

/*/Protheus.doc STWF400A
(long_description) Montagem do WF e envio do e-mail das Aprovações
@author user Eduardo Pereira - Sigamat
@since 15/04/2021
@version 12.1.25
/*/

Static Function STWF400A(_aMsg, cNumSW0, cAssunto, cEmail, cCopia)

Local aArea 		:= GetArea()
Local cFuncSent		:= "STWF400"
Local cMsg     		:= ""
Local _nLin			:= 0

// Definicao do cabecalho do email
cMsg := ""
cMsg += '<html>'
cMsg += '   <head>'
cMsg += '       <title>' + cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</title>'
cMsg += '   </head>'
cMsg += '   <body>'
cMsg += '       <HR Width=85% Size=3 Align=Centered Color=Red> <P>'
cMsg += '       <Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
cMsg += '           <Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</FONT> </Caption>'

// Definicao do texto/detalhe do email
For _nLin := 1 to Len(_aMsg)
    If (_nLin/2) == Int( _nLin/2 )
        cMsg += '           <TR BgColor=#B0E2FF>'
    Else
        cMsg += '           <TR BgColor=#FFFFFF>'
    EndIf
    If _nLin = 1
        cMsg += '           <TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
        cMsg += '           <TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
    Else
        cMsg += '           <TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
        cMsg += '           <TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
    EndIf
Next

// Definicao do rodape do email
cMsg += '       </Table>'
cMsg += '       <P>'
cMsg += '       <Table align="center">'
cMsg += '           <tr></tr>'
cMsg += '           <tr></tr>'
cMsg += '           <tr>'
cMsg += '               <td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: ' + DtoC(Date()) + '-' + Time() + '  - <font color="red" size="1">(' + cFuncSent + ')</td>'
cMsg += '           </tr>'
cMsg += '       </Table>'
cMsg += '       <HR Width=85% Size=3 Align=Centered Color=Red> <P>'
cMsg += '   </body>'
cMsg += '</html>'

If Dow(Date()) <> 1 .And. Dow(Date()) <> 7 //domingo ---- sabado
    U_STMAILTES(cEmail, cCopia, cAssunto, cMsg,,,'   ')
EndIf

RestArea(aArea)

Return

#Include 'Protheus.ch'
#Include 'RWMake.ch'

/*/Protheus.doc MT100LOK
(long_description) Ponto de Entrada para validar a quantidade do Documento de Entrada x Autorização de Entrega
type User Function
@author Eduardo Pereira - Sigamat
@since 24/03/2021
@version 12.1.25
see (links_or_references) https://tdn.totvs.com/pages/releaseview.action?pageId=6085397
/*/

User Function MT100LOK()

Local _aArea 	:= GetArea()
Local _aAreaSC7 := SC7->( GetArea() )
Local _aAreaSD1	:= SD1->( GetArea() )
Local lRet	 	:= .T.

// Ponto de chamada ConexãoNF-e sempre como primeira instrução.
    lRet := U_GTPE004()

    // Restrição para validações não serem chamadas duas vezes ao utilizar o importador da ConexãoNF-e,
    // mantendo a chamada apenas no final do processo, quando a variavel l103Auto estiver .F.
    If lRet .And. !FwIsInCallStack('U_GATI001') .Or. IIf(Type('l103Auto') == 'U',.T.,!l103Auto)
    EndIf



SC7->( dbSetOrder(1) )	// C7_FILIAL + C7_NUM + C7_ITEM + C7_SEQUEN
SC7->( dbSeek(xFilial("SC7") + GdFieldGet('D1_PEDIDO') + GdFieldGet('D1_ITEMPC')) )
If SC7->C7_TIPO = 2	// Tipo A.E
	If GdFieldGet('D1_QUANT') > SC7->C7_QUANT - SC7->C7_QUJE
		apMsgInfo(	"As quantidades estão divergentes, conforme abaixo:" + CRLF + CRLF +;
					"<FONT COLOR='RED' SIZE='4'>Quantidade do Doc. Entrada.: </FONT>" + Alltrim(cValtoChar(GdFieldGet('D1_QUANT'))) + CRLF +;
					"<FONT COLOR='BLUE' SIZE='4'>Quantidade do A.E.: </FONT>" + Alltrim(cValtoChar(SC7->C7_QUANT - SC7->C7_QUJE)) + CRLF + CRLF + CRLF +;
					"<B>Favor, informar a mesma quantidade do A.E.</B>","Atenção - P.E.: MT100LOK")
		lRet   := .F.
	EndIf
EndIf
RestArea( _aAreaSD1 )
RestArea( _aAreaSC7 )
RestArea( _aArea )

Return lRet

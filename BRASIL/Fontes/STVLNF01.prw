#Include "Protheus.ch"
#Include "RWMake.ch"

/*/Protheus.doc nomeStaticFunction
(long_description) Tratamento para inclus�o do Documento de Entrada quando o numero da nota e fornecedor j� existir apresenta mensagem na tela avisando.
Fun��o U_STVLNF01() esta sendo chamada no X3_VALID do campo F1_FORNECE.
@author Eduardo Pereira - Sigamat
@since 05/05/2021
@version 12.1.25
/*/

User Function STVLNF01()

Local lRet := .T.

If !FWIsInCallStack("U_JOBPRENF") .Or. !FWIsInCallStack("U_XMLPAINEL")
    If Inclui
        SF1->( dbSetOrder(1) )  // F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO
        If SF1->( dbSeek(xFilial("SF1") + cNFiscal + cSerie + cA100For + cLoja) )
            apMsgInfo(	"<FONT COLOR='BLUE' SIZE='4'>Nota Fiscal: </FONT><B>" + Alltrim(cNFiscal) + "</B><FONT COLOR='BLUE' SIZE='4'> e S�rie: </FONT><B>" + Alltrim(cSerie) + "</B>" + CRLF + CRLF +;
                        "<FONT COLOR='BLUE' SIZE='4'>Fornecedor: </FONT><B>" + Alltrim(cA100For) + "</B><FONT COLOR='BLUE' SIZE='4'> e Loja: </FONT><B>" + Alltrim(cLoja) + "</B>"+ CRLF + CRLF + CRLF +;
                        "<B>J� existe no sistema, favor verificar.</B>","Aten��o - STVLNF01")
            lRet := .F.
        EndIf
    EndIf
EndIf

Return lRet

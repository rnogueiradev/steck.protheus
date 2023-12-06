#Include "Protheus.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±ÉÍÍÍ
ÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
±±±±ºPrograma  ³CT105TOK ºAutor  ³Microsiga           º Data ³  15/12/09   º±±±±Ì
ÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±±±º
Desc.     ³ Validação do TOK, na gravação dos lançamentos contábeis     º±±±±º       
   ³ tela
 principal dos lanc cont automaticos (mbrowse)         º±±±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍ
 ÍÍÍÍÍÍÍÍÍÍÍ
 ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±±±ºUso       ³ AP                                                        
º±±±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßßßßßßßß*/


User Function CT105CHK()

Local _lRet  := .t.


DbSelectArea("TMP")
DbGotop()

While !TMP->(EOF())
    
   If Empty(TMP->CT2_XCLASS) .And. TMP->CT2_ORIGEM=="CTBA102"
        _lRet := .F.
        MsgInfo("Por favor, informar a classificação do lançamento.!!","Atenção")    
        Exit 
   Endif

   DbSelectArea("TMP")
   DbSkip()
Enddo


If FunName()<>"CTBA102"
_lRet  := .t.
Endif

Return(_lRet)

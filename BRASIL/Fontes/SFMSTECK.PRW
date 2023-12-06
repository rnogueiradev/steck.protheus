#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±|Ponto de  ³SFMSTECK  |Autor  ³Ricardo Posman         |Data  ³18.09.2007|±±
±±³Entrada   ³          ³       |                       |      |          |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±|Descricao ³Gatilho que substitui funcao da tes inteligente.            |±±
±±|          ³                                                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SFMSTECK() 


LOCAL _Contrib  := IIF(Empty(SA1->A1_CONTRIB),"N","S")  
Local _ClTrib   := SA1->A1_TIPO 					
Local _ClassPr  := SB1->B1_CLAPROD   				// OK
Local _PrTrib   := SB1->B1_GRTRIB      
Local _Ipi		:= IIF(Empty(SB1->B1_POSIPI),"N","S") // OK
Local _Tes		:= ""
Local _Oper     := ""

If FunName() == 'MATA410'
      _Oper :=M->C6_OPER      
ElseIf FunName() == 'MATA415'
      _Oper :=M->CK_OPER
ElseIf FunName() == 'TMKA271'    // UB_TES
      _Oper :=M->UB_OPER

Endif            
 
cQuery := " SELECT FM_TS "
cQuery += " FROM "+RetSqlName("SFM")+ " 
cQuery += " WHERE FM_FILIAL='"+xFILIAL("SFM")+"' "
cQuery += " AND  FM_IPI= '" + _Ipi + "' "
cQuery += " AND  FM_CLAPROD= '" + _ClassPr + "' "
cQuery += " AND  FM_ICMS= '" + _Contrib + "' "  
cQuery += " AND  FM_CLAPROD= '" + _ClassPr + "' "
cQuery += " AND  FM_TIPO= '" + _Oper + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY FM_TS "

MEMOWRITE("SFM.SQL",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"XFM", .F., .T.)

_Tes := XFM->FM_TS

XFM->(dbCloseArea())

If Empty(_Tes)

MsgAlert("Nao foi possivel localizar a TES desta operacao. Verifique.")

Endif

Return (_Tes) 
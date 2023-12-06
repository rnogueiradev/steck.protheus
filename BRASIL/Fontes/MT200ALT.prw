#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT200ALT  ºAutor  ³FlexProjects        º Data ³ 20/02/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  bloqe=ueio de alteracao de estrutura de produto           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT200ALT 

	MsgStop("Quaisquer manutencoes de Estrutura, deverao ser feitas atraves de Pre-Estrutura") 

	REGSG1()

return .f.

Static Function REGSG1()

	Local aBkArea		:=	GetArea()
	Local cTop01			:=	"SQL01"
	Local cIDConf		  	:= RetCodUsr()
	Local cDescUsr 		:= UsrRetName(cIDConf)

	dbSelectArea("PC3")
	PC3->(dbSetOrder(1))

	cQuery	:=		" SELECT G1_COD COD,G1_COMP COMP,G1_QUANT  QUANT	"
	cQuery	+=	" FROM "+RetSqlName("SG1")+" SG1 "
	cQuery	+=	" WHERE G1_FILIAL='"+xFilial("SG1")+"' AND G1_COD='"+SG1->G1_COD+"' AND SG1.D_E_L_E_T_!='*' "

	If !Empty(Select(cTop01))
		DbSelectArea(cTop01)
		(cTop01)->(dbCloseArea())
	Endif

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery),cTop01, .T., .T. )

	While (cTop01)->(!Eof())

		//PC3_FILIAL+PC3_COD+PC3_COMP  
		If PC3->(dbSeek(xFilial("PC3")+(cTop01)->COD+(cTop01)->COMP))
			RecLock("PC3",.F.)
			PC3->PC3_FILIAL		:=	xFilial("PC3")
			PC3->PC3_COD			:=	(cTop01)->COD
			PC3->PC3_COMP		:=	(cTop01)->COMP
			PC3->PC3_QUANT		:=	(cTop01)->QUANT
			PC3->(MsUnLock())
		Else
			RecLock("PC3",.T.)
			PC3->PC3_FILIAL		:=	xFilial("PC3")
			PC3->PC3_COD			:=	(cTop01)->COD
			PC3->PC3_COMP		:=	(cTop01)->COMP
			PC3->PC3_QUANT		:=	(cTop01)->QUANT
			PC3->(MsUnLock())
		EndIf

		(cTop01)->(dbSkip())

	EndDo

	If !Empty(Select(cTop01))
		DbSelectArea(cTop01)
		(cTop01)->(dbCloseArea())
	Endif

	RestArea(aBkArea)

Return() 
#include "Rwmake.ch"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STPCE002 ºAutor  ³RVG Solcuoes        º Data ³  05/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tratamento para codigo de barras STECK                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STPCE002()

Local aArea     := GetArea()
Local aAreaSB1  := SB1->(GetArea())
Local cCodEan    := "789"
Local cCodEmp    := GetMv("MV_XCODEMP") // 3401 Criar parametro para codigo da empresa.
Local cSequen    := GetMv("MV_XSEQBAR")// Sequencial utilizado na geracao do  codigo de barras
Local cCodBar    := " " 
Local cNewCodBar := " "

IF SB1->B1_XCRIACB == 'S'  .AND. EMPTY(SB1->B1_CODBAR)
	cCodBar    := cCodEan + cCodEmp + cSequen
	cNewCodBar := cCodBar + EanDigito(cCodBar)// Funcao padrao do sistema que calculo digito do codigo de barras 
	
	PutMv("MV_XSEQBAR",Soma1(cSequen))
	
	Dbselectarea("SB1")
	Reclock("SB1") 
	SB1->B1_CODBAR := cNewCodBar
	MsUnlock()
	MsgStop("Este Produto recebeu o Codigo de Barras: "+cNewCodBar)
Endif	

RestArea(aAreaSB1)
RestArea(aArea)
 
Return(.T.)



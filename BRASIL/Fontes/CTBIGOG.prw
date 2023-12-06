#include "totvs.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTBIGOG ºAutor  ³Cristiano Pereira º Data ³  06/12/12      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se a conta contabil gera classe de valor            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CTBIGOG(_cConta)
    

	_aArea:= GetArea()

	If ValType(_cConta)=="N"
		_cConta := AllTrim(Str(_cConta))
	Endif



	If ValType(SD1->D1_TIPO)=="C" .And. Rtrim(SD1->D1_TIPO)=="D" .And. FunName()=="CTBANFE"
	
		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)

			If SA1->A1_XRELAC=="1" .Or. !Empty(SA1->A1_CONTA)

				DbSelectArea("CT1")
				DbSetOrder(1)
				If DbSeek(xFilial("CT1")+_cConta)
					If !Empty(CT1->CT1_XIG)
						_cConta:= CT1->CT1_XIG
					ElseIf !Empty(CT1_XOG)
						_cConta:= CT1->CT1_XOG
					Endif
				Endif
			Endif
		endif
	elseIf  FunName()=="CTBANFS"
		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)

			If SA1->A1_XRELAC=="1" .Or. !Empty(SA1->A1_CONTA)

				DbSelectArea("CT1")
				DbSetOrder(1)
				If DbSeek(xFilial("CT1")+_cConta)
					If !Empty(CT1->CT1_XIG)
						_cConta:= CT1->CT1_XIG
					ElseIf !Empty(CT1_XOG)
						_cConta:= CT1->CT1_XOG
					Endif
				Endif
			Endif
		endif

	Endif

	RestArea(_aArea)

Return(_cConta)

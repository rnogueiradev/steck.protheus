#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
SISP001 -> Utilizada para Verificacao e retorno de dados referente a Agencia e Conta a
utilizado na geracao do ITAUPAG.PAG ( SISPAG )
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
			13/01/2012 - Marcelo Araujo Dente - marcelo.dente@totvs.com.br
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SISP001()

	IF (SEA->EA_TIPO == "30")

		IF AT("-",SRA->RA_CTDEPSA) == 0
			_cReturn1 :=StrZero(Val(Alltrim(SUBSTR(SRA->RA_BCDEPSA,1,3))),5)+" "+StrZero(Val(SUBS(SRA->RA_CTDEPSA,1,Len(Alltrim(SRA->RA_CTDEPSA))-1)),12)
		Else
			_cReturn1 :=StrZero(Val(Alltrim(SUBSTR(SRA->RA_BCDEPSA,1,3))),5)+" "+StrZero(Val(SUBS(SRA->RA_CTDEPSA,1,AT("-",SRA->RA_CTDEPSA)-1)),12)
		Endif

	ELSE

		//>> Chamado 006557 - Everson Santana 22.03.18 - Validar a Conta no Cadastro do Titulo
		If !Empty(SE2->E2_FORAGE)

			IF AT("-",SE2->E2_FORCTA) == 0
				_cReturn1 :=StrZero(Val(Alltrim(SE2->E2_FORAGE)),5)+" "+StrZero(Val(SUBS(SE2->E2_FORCTA,1,Len(Alltrim(SE2->E2_FORCTA)))),12)
			Else
				_cReturn1 :=StrZero(Val(Alltrim(SE2->E2_FORAGE)),5)+" "+StrZero(Val(SUBS(SE2->E2_FORCTA,1,AT("-",SE2->E2_FORCTA))),12)
			Endif

		Else
		//<< Chamado 006557 - Everson Santana 22.03.18 - Validar a Conta no Cadastro do Titulo
			IF AT("-",SA2->A2_NUMCON) == 0
				_cReturn1 :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,1,Len(Alltrim(SA2->A2_NUMCON)))),12)
			Else
				_cReturn1 :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,1,AT("-",SA2->A2_NUMCON))),12)
			Endif
		EndIf
	ENDIF

Return(_cReturn1)
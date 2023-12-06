#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
SISP002 -> Utilizada para Verificacao e retorno de dados referente ao Digito da C/C
a ser utilizado na geracao do ITAUPAG.PAG ( SISPAG )
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
			13/01/2012 - Marcelo Araujo Dente - marcelo.dente@totvs.com.br
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SISP002()

	IF (SEA->EA_TIPO == "30")


		IF AT("-",SRA->RA_BCDEPSA) == 0
			_cReturn2 :=SUBS(Alltrim(SRA->RA_BCDEPSA),-1)
		Else
			_cReturn2 :=SUBS(SRA->RA_BCDEPSA,AT("-",SRA->RA_BCDEPSA)+1,1)
		Endif

	ELSE
		//>> Chamado 006557 - Everson Santana 22.03.18 - Validar a Conta no Cadastro do Titulo
		If !Empty(SE2->E2_FCTADV)

			IF EMPTY(SE2->E2_FCTADV) // CHAMADO 005038 - Robson Mazzarotto
				IF AT("-",SE2->E2_FORCTA) == 0
					_cReturn2 :=SUBS(Alltrim(SE2->E2_FORCTA),-1)
				Else
					_cReturn2 :=SUBS(SE2->E2_FORCTA,AT("-",SE2->E2_FORCTA)+1,1)
				EndIf
			ELSE
				_cReturn2 := SE2->E2_FCTADV
			Endif

		Else
		//<< Chamado 006557 - Everson Santana 22.03.18 - Validar a Conta no Cadastro do Titulo
			IF EMPTY(SA2->A2_X_DVCTA) // CHAMADO 005038 - Robson Mazzarotto
				IF AT("-",SA2->A2_NUMCON) == 0
					_cReturn2 :=SUBS(Alltrim(SA2->A2_NUMCON),-1)
				Else
					_cReturn2 :=SUBS(SA2->A2_NUMCON,AT("-",SA2->A2_NUMCON)+1,1)
				EndIf
			ELSE
				_cReturn2 := SA2->A2_X_DVCTA
			Endif
		EndIF
	ENDIF

Return(_cReturn2)


#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STRSPV    ºAutor  ³João Rinaldi        º Data ³  20/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte para preencher no campo virtual C5_ZDESCCL a Razão    º±±
±±º          ³Social do Cliente ou Fornecedor, de acordo com o Tipo do    º±±
±±º          ³Pedido de Venda para utilização no X3_RELACAO e X3_INIBRW   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//IIF(!INCLUI,POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ,"A1_NOME"),"")
//X3_RELACAO
//POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
//X3_INIBRW

User Function STRSPV(lIniBrw)

	Local _cDescr    := ""
	Default lIniBrw := .F.
	
	If FunName() <> "MATA410"
		Return _cDescr
	EndIf
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If !lIniBrw
		//	If VALType(INCLUI) <> "U"
		//	IF !INCLUI
				IF ( SC5->C5_TIPO $ "NCIP")

					dbselectarea("SA1")
					SA1->(dbSetOrder(1))
					SA1->(DbSeek(xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
					_cDescr := SA1->A1_NOME

				ElseIf ( SC5->C5_TIPO $ "DB")

					dbselectarea("SA2")
					SA2->(dbSetOrder(1))
					SA2->(DbSeek(xFilial("SA2")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
					_cDescr := SA2->A2_NOME

				
			Else
			_cDescr := ""
			Endif
		//	EndIf
		//	Endif
		Else
			IF ( SC5->C5_TIPO $ "NCIP")

					dbselectarea("SA1")
					SA1->(dbSetOrder(1))
					SA1->(DbSeek(xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
					_cDescr := SA1->A1_NOME

				ElseIf ( SC5->C5_TIPO $ "DB")

					dbselectarea("SA2")
					SA2->(dbSetOrder(1))
					SA2->(DbSeek(xFilial("SA2")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
					_cDescr := SA2->A2_NOME

				Endif
		Endif
	EndIf
Return(_cDescr)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STRSPVGAT ºAutor  ³João Rinaldi        º Data ³  20/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho para preencher no campo virtual C5_ZDESCCL a Razão  º±±
±±º          ³Social do Cliente ou Fornecedor, de acordo com o Tipo do    º±±
±±º          ³Pedido de Venda, utilizado no gatilho C5_CLIENTE, seq. 006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function STRSPVGAT()


	Local _cDescrGat := ""
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		IF ( M->C5_TIPO $ "NCIP")

			dbselectarea("SA1")
			SA1->(dbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+ M->C5_CLIENTE + M->C5_LOJACLI ))
			_cDescrGat := SA1->A1_NOME

		ElseIf ( M->C5_TIPO $ "DB")

			dbselectarea("SA2")
			SA2->(dbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+ M->C5_CLIENTE + M->C5_LOJACLI ))
			_cDescrGat := SA2->A2_NOME

		Endif
	EndIf
Return(_cDescrGat)

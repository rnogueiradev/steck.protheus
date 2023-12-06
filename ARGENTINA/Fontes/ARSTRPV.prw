#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณARSTRSPV  บAutor  ณJoใo Rinaldi        บ Data ณ  20/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte para preencher no campo virtual C5_ZDESCCL a Razใo    บฑฑ
ฑฑบ          ณSocial do Cliente ou Fornecedor, de acordo com o Tipo do    บฑฑ
ฑฑบ          ณPedido de Venda para utiliza็ใo no X3_RELACAO e X3_INIBRW   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ARSTRSPV(lIniBrw)

	Local _cDescr    := ""
	Default lIniBrw := .F.

	If FunName() <> "MATA410"

		dbselectarea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA ))
		_cDescr := SA1->A1_NOME

		Return _cDescr
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If !lIniBrw
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTRSPVGAT บAutor  ณJoใo Rinaldi        บ Data ณ  20/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGatilho para preencher no campo virtual C5_ZDESCCL a Razใo  บฑฑ
ฑฑบ          ณSocial do Cliente ou Fornecedor, de acordo com o Tipo do    บฑฑ
ฑฑบ          ณPedido de Venda, utilizado no gatilho C5_CLIENTE, seq. 006  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ARSTRSPC(lIniBrw)

	Local _cDescrGat := ""

	If AllTrim(FunName()) $ ("MATA121#MATA010")
		dbselectarea("SA2")
		SA2->(dbSetOrder(1))
		If SA2->(DbSeek(xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA)))
			_cDescrGat := SA2->A2_NOME
		EndIf
	Else
		If SF1->F1_TIPO=="N"
			dbselectarea("SA2")
			SA2->(dbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+SF1->F1_FORNECE + SF1->F1_LOJA))
			_cDescrGat := SA2->A2_NOME
		Else
			dbselectarea("SA1")
			SA1->(dbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SF1->F1_FORNECE + SF1->F1_LOJA))
			_cDescrGat := SA1->A1_NOME

		Endif
	EndIf

Return(_cDescrGat)

#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBSTCOL  ºAutor  ³Cristiano Pereira   º Data ³  08/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao auxiliar criada para auxiliar a contabilização      º±±
±±º          ³ retorna a conta contabil ou valor conforme parametros      º±±
±±º          ³ cLP = Lançamento Padrão                                    º±±
±±º          ³ cSeq = Sequencia de Lançamento                             º±±
±±º          ³ cTipo = "D" - Debito, "C" - Credito, "V" - Valor           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBSTCOL(cLP,cSeq,cTipo)


	Local xRet := 0
	Local _cQuery := ""


// Definição da Conta Contábil a Débito LP 610
	If cLP = "575" .And. cSeq = "003" .And. cTipo = "H"

		If Select("TSE1")> 0
			DbSelectArea("TSE1")
			dBCloSeArea()
		Endif

		_cQuery  :=  " SELECT SE1.E1_TXMOEDA,SE1.E1_TIPO, SE1.E1_PREFIXO                  "
		_cQuery  +=  " FROM "+RetSqlname("SE1")+" SE1                      "
		_cQuery  +=  " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"' AND      "
		_cQuery  +=  "       SE1.E1_RECIBO = '"+SEL->EL_RECIBO+"' AND      "
		_cQuery  +=  "       SE1.D_E_L_E_T_ <> '*'  AND SE1.E1_TIPO = 'NF' "

		TCQUERY _cQuery NEW ALIAS "TSE1"

		DbSelectArea("TSE1")
		DbGotop()

        xRet:= SUBSTR(SEL->EL_SERIE+ RTRIM(SEL->EL_RECIBO) +" "+TSE1->E1_PREFIXO+" "+Rtrim(SA1->A1_COD)+" "+Rtrim(SUBSTR(SA1->A1_NOME,1,60))+" "+ RTRIM(SEL->EL_XOBS),1,110)+" USD "+ltrim(Rtrim(transform(SEL->EL_VALOR,PesqPict("SEL","EL_VALOR"))))+" TRM "+ltrim(Rtrim(transform(SEL->EL_TXMOE02,"@E 999999.99")))+" TRM "+ltrim(Rtrim(transform(TSE1->E1_TXMOEDA,"@E 999999.99")))
	Endif



return xRet

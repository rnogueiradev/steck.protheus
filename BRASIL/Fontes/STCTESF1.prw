#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCTESF1        | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018  |
|=====================================================================================|
|Descrição | INSERIR CTE NA SF1						                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCTESF1()

	Local cError 	:= ""
	Local cWarning	:= ""
	Local aDados	:= {}
	Local aItens	:= {}
	Local aLinha	:= {}
	Local aCabec	:= {}
	Private lMsErroAuto := .F.

	oXML := XmlParser(SZ9->Z9_XML,"_",@cError,@cWarning)  //carrega arquivo CT-e

	oCTE        := oXML:_CTEPROC:_CTE:_INFCTE
	cCNPJ       := oCTE:_EMIT:_CNPJ:TEXT
	cNumConhe   := strzero(val(oCTE:_IDE:_NCT:TEXT),9)
	cSerie      := oCTE:_IDE:_SERIE:TEXT
	cCnpjBvx 	:= oCTE:_REM:_CNPJ:TEXT
	cCnpjBvx 	:= ""

	If ALLTRIM(cCnpjBvx) <> ALLTRIM(SM0->M0_CGC)
		If Type("oCTE:_IDE:_TOMA4:_CNPJ") <> "U"
			cCnpjBvx := oCTE:_IDE:_TOMA4:_CNPJ:TEXT
		ElseIf Type("oCTE:_IDE:_TOMA04:_CNPJ") <> "U"
			cCnpjBvx := oCTE:_IDE:_TOMA04:_CNPJ:TEXT
		ElseIf Type("oCTE:_IDE:_TOMA04:_TOMA") <> "U"
			If oCTE:_IDE:_TOMA04:_TOMA:TEXT = '0'
				If Type("oCTE:_REM:_CNPJ") <> "U"
					cCnpjBvx := oCTE:_REM:_CNPJ:TEXT
				EndIf
			ElseIf oCTE:_IDE:_TOMA04:_TOMA:TEXT = '1'
				If Type("oCTE:_EXPED:_CNPJ") <> "U"
					cCnpjBvx := oCTE:_EXPED:_CNPJ:TEXT
				EndIf
			ElseIf oCTE:_IDE:_TOMA04:_TOMA:TEXT = '2'
				If Type("oCTE:_RECEB:_CNPJ") <> "U"
					cCnpjBvx := oCTE:_RECEB:_CNPJ:TEXT
				EndIf
			ElseIf oCTE:_IDE:_TOMA04:_TOMA:TEXT = '3'
				If Type("oCTE:_DEST:_CNPJ") <> "U"
					cCnpjBvx := oCTE:_DEST:_CNPJ:TEXT
				EndIf
			EndIf
		ElseIf Type("oCTE:_IDE:_TOMA3:_CNPJ") <> "U"
			cCnpjBvx := oCTE:_IDE:_TOMA3:_CNPJ:TEXT
		ElseIf Type("oCTE:_IDE:_TOMA3:_TOMA") <> "U"
			If oCTE:_IDE:_TOMA3:_TOMA:TEXT = '0'
				If Type("oCTE:_REM:_CNPJ") <> "U"
					cCnpjBvx := oCTE:_REM:_CNPJ:TEXT
				EndIf
			ElseIf oCTE:_IDE:_TOMA3:_TOMA:TEXT = '1'
				If Type("oCTE:_EXPED:_CNPJ") <> "U"
					cCnpjBvx := oCTE:_EXPED:_CNPJ:TEXT
				EndIf
			ElseIf oCTE:_IDE:_TOMA3:_TOMA:TEXT = '2'
				If Type("oCTE:_RECEB:_CNPJ") <> "U"
					cCnpjBvx := oCTE:_RECEB:_CNPJ:TEXT
				EndIf
			ElseIf oCTE:_IDE:_TOMA3:_TOMA:TEXT = '3'
				If Type("oCTE:_DEST:_CNPJ") <> "U"
					cCnpjBvx := oCTE:_DEST:_CNPJ:TEXT
				EndIf
			EndIf
		Else // Jefferson
			cCnpjBvx := oCTE:_DEST:_CNPJ:TEXT
		Endif
	EndIf

	If AllTrim(cCnpjBvx) <> AllTrim(SM0->M0_CGC)

		MsgAlert("Esse conhecimento não pertence a esta empresa, verifique!")

	Else

		cTextoCompl := AllTrim(oCTE:_EMIT:_XNOME:TEXT) //razao social
		cCfop       := oCTE:_IDE:_CFOP:TEXT

		DbSelectArea("SA2")
		DbSetOrder(3)
		DbSeek(xFilial("SA2")+cCNPJ)

		If !Found()
			MsgAlert("Fornecedor não encontrado!")
		Else
			//informaçoes do fornecedor
			cCodFornecedor := SA2->A2_COD
			cLojaFornecedor:= SA2->A2_LOJA
			cNomeFornecedor:= SA2->A2_NOME
			cEstFornecedor := SA2->A2_EST

			if cEstFornecedor = 'SP'
				cCfop := '1'+substr(cCfop,2,4)
			else
				cCfop := '2'+substr(cCfop,2,4)
			endif

			cEmissao := strtran(left(oCTE:_IDE:_DHEMI:TEXT,10),"-","")
			nVlFrete := Val(oCTE:_VPREST:_VTPREST:TEXT)

			nBaseIcm := 0
			nAliqIcm := 0
			nVlIcms  := 0

			if Type("oCTE:_IMP:_ICMS:_ICMS00")  <> "U"
				oIcm := oCTE:_IMP:_ICMS:_ICMS00
			elseif Type("oCTE:_IMP:_ICMS:_ICMS20")  <> "U"
				oIcm := oCTE:_IMP:_ICMS:_ICMS20
			endif

			if Type("oIcm")  <> "U"
				nBaseIcm := val(oIcm:_VBC:TEXT)
				nAliqIcm := val(oIcm:_PICMS:TEXT)
				nVlIcms  := val(oIcm:_VICMS:TEXT)
			endif

			cSerNF := ""
			cNumNF := ""
			nValNf := 0
			cTransp:= ""

			//tomador serviço
			cToma := "0"
			if Type("oCTE:_IDE:_TOMA3:_TOMA")  <> "U"
				cToma := oCTE:_IDE:_TOMA3:_TOMA:TEXT
			endif

			cSerNF := " "
			cNumNF := " "
			nValNf := 0

			if Type("oCTE:_REM:_INFNF:_SERIE")  <> "U"
				cSerNF := oCTE:_REM:_INFNF:_SERIE:TEXT
			Endif
			if Type("oCTE:_REM:_INFNF:NDOC")  <> "U"
				cNumNF := strzero(val(oCTE:_REM:_INFNF:_NDOC:TEXT),9)
			Endif
			if Type("oCTE:_REM:_INFNF:_VNF")  <> "U"
				nValNf := val(oCTE:_REM:_INFNF:_VNF:TEXT)
			ENDIF

			aAdd(aDados,{ , ,;  //empresa=1, filial=2
			cNumConhe, ;            //numero conhecimento -3
			cSerie,;              	         // serie -4
			stod(cEmissao),;			     //emissao -5
			cCodFornecedor,;			     //cod forn - 6
			cLojaFornecedor,;	             // loja forn - 7
			"CTE",;        	             // especie - 8
			cEstFornecedor,;                // uf - 9
			"FRETE",;                      // produto - 10
			"UN",;                         // un - 11
			1,;                             //qtd - 12
			nVlFrete,;                      // val uni -13
			nVlFrete,;                      // val total - 14
			nBaseIcm,;                         //  base icms -15
			nAliqIcm,;                        //  aliq icms  -16
			nVlIcms,;  					    	//  valor icms - 17
			"",;                           //  cc -18     (preenchido direto na gravacao)
			cCfop,;                         //
			cCNPJ,;                         // cnpj  -20
			cTextoCompl,;                  // texto compl. (razao) -21
			nValNf,;						// valor bruto nf 22
			0,; 							// valor frete NF 23
			cNumNF,;                        // NUM NF 24
			cSerNF,;						// Serie NF 25
			oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT,;   //chave CT-e - 26
			oCTE:_IDE:_TPCTE:TEXT } )      //tipo CT-e - 27

			DbSelectArea("SF1")
			SF1->(DbSetOrder(1))
			SF1->(DbGoTop())
			SF1->(DbSeek(xFilial("SF1") + PadR(aDados[1,3],TamSx3("F1_DOC")[1]) + PadR(aDados[1,4],TamSx3("F1_SERIE")[1]) + PadR(aDados[1,6],TamSx3("F1_FORNECE")[1]) + Padr(aDados[1,7],TamsX3("F1_LOJA")[1]) + "N"))

			If !Found()

				aadd(aCabec,{"F1_TIPO"   ,"N"})
				aadd(aCabec,{"F1_FORMUL" ,"N"})
				aadd(aCabec,{"F1_DOC"    ,aDados[1,3]})
				aadd(aCabec,{"F1_SERIE"  ,aDados[1,4]})
				aadd(aCabec,{"F1_EMISSAO",aDados[1,5]})
				aadd(aCabec,{"F1_FORNECE",aDados[1,6]})
				aadd(aCabec,{"F1_LOJA"   ,aDados[1,7]})
				aadd(aCabec,{"F1_ESPECIE", "CTE"})
				aadd(aCabec,{"F1_EST",aDados[1,9]})
				aadd(aCabec,{"F1_COND","001"})

				aadd(aCabec,{"F1_TPFRETE",iif(empty(alltrim(aDados[1,24])),"F","C")})   //verificar se os CTE emitidos ref. coleta em cliente tb são CIF ou se sao FOB
				aadd(aCabec,{"F1_CHVNFE",aDados[1,26]})
				aadd(aCabec,{"F1_TPCTE",iif(aDados[1,27]=="0","N",iif(aDados[1,27]=="1","C","A"))}) //Ticket 20190826000047- Everson Santana - 11.09.2019 - O Tipo do Campo "aDados[1,27]==1" estava como numerico e o correto é caracter

				aLinha := {}
				aadd(aLinha,{"D1_COD",IIF(aDados[1,17]>0,"FRETE","FRETE SEM CRED"),Nil})
				aadd(aLinha,{"D1_UM" ,"UN",NIL})
				aadd(aLinha,{"D1_QUANT",aDados[1,12],Nil})
				aadd(aLinha,{"D1_VUNIT",aDados[1,13],Nil})
				aadd(aLinha,{"D1_TOTAL",aDados[1,14],Nil})
				aadd(aLinha,{"D1_TES",IIF(aDados[1,17]>0,"104","105"),Nil})
				aadd(aLinha,{"D1_CF",Substr(aDados[1,19],1,1)+"352",NIL})
				aAdd(aLinha,{"D1_BASEICM",aDados[1,15],Nil})
				aAdd(aLinha,{"D1_PICM",aDados[1,16],Nil})
				aAdd(aLinha,{"D1_VALICM",aDados[1,17],Nil})
				//
				aadd(aItens,aLinha)

				lMsHelpAuto := .T.
				lMsErroAuto := .F.

				MSExecAuto({|x,y,z| MATA140(x,y,z)},aCabec,aItens,3)

				If lMsErroAuto  //se der erro grava no arquivo de log.

					MostraErro()
					lMsErroAuto := .F.

				Else

					MsgAlert("CTE inserido com sucesso!")

					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_DOC := SF1->F1_DOC
					SZ9->(MsUnLock())

				EndIf

			Else

				MsgAlert("CTE já importado, verifique!")

			EndIf

		EndIf
	EndIf

Return
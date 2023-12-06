#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'

/*

O ponto de entrada CFG10EGR permite outros tratamentos especํficos no momento da gravacao de inclusใo/altera็ใo/exclusใo dos parametros (SX6).

aAlter: Array bi-dimensional, contando as alteracoes realizadas.
Ex.: aAlter[Linha][01]: Campo alterado, aAlter[Linha][02]: Valor anterior, aAlter[Linha][03]: Valor atual alterado[ codigo com tratamentos aqui... ]

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ CFG10EGR บ Autor ณ  Everson Santana   บ Data ณ  22/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ Ponto de entrada criado a fim de descobrir as cagadas de   บฑฑ
ฑฑบDescricao ณ quem poe a mao no SX6. O ponto de entrada eh disparado aposบฑฑ
ฑฑบ          ณ confirmar a tela de edicao do parametro.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ   Uso    ณ Especifico Fini                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFG10EGR()

	Local cCodUser   := ParamIXB[1] 
	Local cNomeUser  := ParamIXB[2] 
	Local cOperacao  := ParamIXB[3] 
	Local cParametro := ParamIXB[4]
	Local aAlter     := ParamIXB[5]

	Local _cEmail 	:= "everson.santana@steck.com.br;Renato.Oliveira@steck.com.br"
	Local _cCopia 	:= ""
	Local _cAssunto := ""
	Local cMsg 		:= ""

	Do Case
		Case cOperacao == "3"

		_cAssunto := "Parโmetro Criado!"
		cMsg	  :=  "Parโmetro: "+Alltrim(cParametro)+" criado pelo usuแrio:   "+Alltrim(cCodUser)+" "+Alltrim(cNomeUser)+". Conte๚do antigo: "+aAlter[01][01]+" / Novo conte๚do: "+aAlter[01][02]+" / Novo conte๚do: "+aAlter[01][03]

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

		Case cOperacao == "4"

		_cAssunto := "Parโmetro Alterado!"
		cMsg	  := "Parโmetro: "+Alltrim(cParametro)+" alterado pelo usuแrio: "+Alltrim(cCodUser)+" "+Alltrim(cNomeUser)+". Conte๚do antigo: "+aAlter[01][02]+" / Novo conte๚do: "+aAlter[01][03]

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

		Case cOperacao == "5"
		
		_cAssunto := "Parโmetro Excluํdo!"
		cMsg	  := "Parโmetro: "+Alltrim(cParametro)+" excluํdo pelo usuแrio: "+Alltrim(cCodUser)+" "+Alltrim(cNomeUser)+". Conte๚do antigo: "+aAlter[01][01]+" / Novo conte๚do: "+aAlter[01][02]+" / Novo conte๚do: "+aAlter[01][03]

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)
		
	End

Return Nil
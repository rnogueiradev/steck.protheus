#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'

/*

O ponto de entrada CFG10EGR permite outros tratamentos espec�ficos no momento da gravacao de inclus�o/altera��o/exclus�o dos parametros (SX6).

aAlter: Array bi-dimensional, contando as alteracoes realizadas.
Ex.: aAlter[Linha][01]: Campo alterado, aAlter[Linha][02]: Valor anterior, aAlter[Linha][03]: Valor atual alterado[ codigo com tratamentos aqui... ]

�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � CFG10EGR � Autor �  Everson Santana   � Data �  22/02/19   ���
�������������������������������������������������������������������������͹��
���          � Ponto de entrada criado a fim de descobrir as cagadas de   ���
���Descricao � quem poe a mao no SX6. O ponto de entrada eh disparado apos���
���          � confirmar a tela de edicao do parametro.                   ���
�������������������������������������������������������������������������͹��
���   Uso    � Especifico Fini                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

		_cAssunto := "Par�metro Criado!"
		cMsg	  :=  "Par�metro: "+Alltrim(cParametro)+" criado pelo usu�rio:   "+Alltrim(cCodUser)+" "+Alltrim(cNomeUser)+". Conte�do antigo: "+aAlter[01][01]+" / Novo conte�do: "+aAlter[01][02]+" / Novo conte�do: "+aAlter[01][03]

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

		Case cOperacao == "4"

		_cAssunto := "Par�metro Alterado!"
		cMsg	  := "Par�metro: "+Alltrim(cParametro)+" alterado pelo usu�rio: "+Alltrim(cCodUser)+" "+Alltrim(cNomeUser)+". Conte�do antigo: "+aAlter[01][02]+" / Novo conte�do: "+aAlter[01][03]

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

		Case cOperacao == "5"
		
		_cAssunto := "Par�metro Exclu�do!"
		cMsg	  := "Par�metro: "+Alltrim(cParametro)+" exclu�do pelo usu�rio: "+Alltrim(cCodUser)+" "+Alltrim(cNomeUser)+". Conte�do antigo: "+aAlter[01][01]+" / Novo conte�do: "+aAlter[01][02]+" / Novo conte�do: "+aAlter[01][03]

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)
		
	End

Return Nil
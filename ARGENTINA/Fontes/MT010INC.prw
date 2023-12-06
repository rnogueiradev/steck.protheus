#Include 'Protheus.ch'

/*
	Autor : Everson Santana
	Data  : 06/11/2019

	PE. Disparado após a inclusão do produto, todos os campos já estão gravados na SB1
	esse PE não retorna nada.

*/

User Function MT010INC()

//+--------------------------------------------------------+
//|Cria locais e Saldos iniciais
//+--------------------------------------------------------+

	//Cria o almoxarifado padrão para esse produto
	CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)

	//Verificando se ja Existe saldo Inicial
	dbSelectArea("SB9")
	dbSetOrder(1)
	If  !DBSeek(xFilial("SB9")+SB1->B1_COD+SB1->B1_LOCPAD)
			RecLock("SB9",.T.)
				SB9->B9_FILIAL :=xFilial("SB9")
				SB9->B9_COD    :=ALLTRIM(SB1->B1_COD)
				SB9->B9_LOCAL  :=ALLTRIM(SB1->B1_LOCPAD)
				SB9->B9_QINI   :=0.00
		    MsUnlock()
    EndIf

Return


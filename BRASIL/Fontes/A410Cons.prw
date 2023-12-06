#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | A410Cons         | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Ponto de Entrada                                                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | A410Cons                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
/****************************************
<<< Alteração >>>
Ação.........: Inclusão da chamada MSTECK05 - Rotina de Importação de Itens via planilha CSV 
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 09/12/2021
Chamados.....: 20211203025898
****************************************/

USER FUNCTION A410Cons()
	Local aBotao:={}
	
	
	aBotao:=U_STFAT35A(aBotao)
	aBotao:=ACLONE(aBotao)
	aBotao:=U_STFA371A(aBotao)
	aBotao:=ACLONE(aBotao)
	// chama rotina para recalcular o preco dos itens com impostos
	aAdd(aBotao,{"ANALITICO",{|| U_STFATG01(.T.)},"Recalcular valores com impostos"})
	aAdd(aBotao,{"ANALITICO",{|| U_STFATG03()},"Prazo TNT"})
	//AADD(aBotao,{"ANALITICO",{|| U_MSTECK05()},"Importa Planilha"}) retirado pois pode colocar preço direto

	
Return(aBotao)




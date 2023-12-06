#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STFAT15          | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  STFAT15    Liberação de regra                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGAP04                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function MA410LEG()
*-----------------------------*

aCor := {{"BR_VERDE","PV em Aberto"},;     			//OK - Pedido em aberto
{"BR_AMARELO","PV Liberado"},;             				//OK - Pedido de Venda Liberado
{"BR_VERMELHO","PV Faturado Totalmente"},;	         	//OK - Pedido de Venda Faturado Totalmente
{"BR_BRANCO","PV Faturado Parcialmente"},;	           	//OK - Pedido de Venda Faturado Parcialmente
{"BR_MARRON","PV Cancelado"},;	           				//OK - Pedido de Venda Cancelado
{"BR_LARANJA","PV Eliminado por Resíduo (Saldo)"},;	    //OK - Pedido de Venda Eliminado por Resíduo (Saldo)
{"BR_AZUL","PV Rejeitado pelo Financeiro"},;           //OK - Pedido de Venda Rejeitado pelo Financeiro 
{"BR_PRETO","PV Bloqueado por Regras Comerciais"}}     //OK - Pedido de Venda Bloqueado por Regras Comerciais
Return(aCor)
		
   

User Function MA410COR()
 
aCores := {{"C5_ZBLOQ == '1' ",'BR_PRETO'},;																		//OK - Pedido de Venda Bloqueado por Regras Comerciais
          { "Empty(C5_NOTA).And. (C5_ZFATBLQ == '3') .And. Empty(C5_ZMOTREJ)",'BR_VERDE' },;						//OK - Pedido em Aberto - Aguardando Liberação Financeiro
  		  { "Empty(C5_NOTA).And. (C5_ZFATBLQ == ' ') .And. Empty(C5_ZMOTREJ)",'BR_AMARELO'},;						//OK - Pedido de Venda Liberado - Liberado Financeiro
		  { "C5_ZFATBLQ == '1'.And. !('XXXX' $ C5_NOTA)",'BR_VERMELHO'},;					   						//OK - Pedido de Venda Faturado Totalmente
		  { "C5_ZFATBLQ == '2'.And. !('XXXX' $ C5_NOTA)",'BR_BRANCO'},;					  							//OK - Pedido de Venda Faturado Parcialmente
  		  { "('XXXX' $ C5_NOTA).And. (C5_ZFATBLQ = '3' .Or. Empty(Alltrim(C5_ZFATBLQ)))" ,'BR_MARRON'},;			//OK - Pedido de Venda Cancelado
   		  { "('XXXX' $ C5_NOTA).And.(C5_ZFATBLQ $ '1/2') ",'BR_LARANJA'},;		 		   							//OK - Pedido de Venda Eliminado por Resíduo (Saldo)
		  { "!Empty(C5_ZMOTREJ).And. !('XXXX' $ C5_NOTA) .And. (C5_ZFATBLQ == ' ')" ,'BR_AZUL'}}					//OK - Pedido de Venda Rejeitado pelo Financeiro

Return(aCores)



/*
User Function MA410COR()

aCores := {{"C5_ZBLOQ == '1' ",'BR_PRETO'},;																		//OK - Pedido de Venda Bloqueado por Regras Comerciais
          { "Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)",'BR_VERDE' },;	   							//OK - Pedido em Aberto
		  { "C5_ZFATBLQ == '1'.And. !('XXXX' $ C5_NOTA)",'BR_VERMELHO'},;					   						//OK - Pedido de Venda Faturado Totalmente
		  { "C5_ZFATBLQ == '2'.And. !('XXXX' $ C5_NOTA)",'BR_BRANCO'},;					  							//OK - Pedido de Venda Faturado Parcialmente
  		  { "('XXXX' $ C5_NOTA).And. C5_ZFATBLQ == ' '",'BR_MARRON'},;			 		   							//OK - Pedido de Venda Cancelado
   		  { "('XXXX' $ C5_NOTA).And.(C5_ZFATBLQ $ '1/2') ",'BR_LARANJA'},;		 		   							//OK - Pedido de Venda Eliminado por Resíduo (Saldo)
  		  { "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ).And.Empty(C5_ZMOTREJ)",'BR_AMARELO'},;		//OK - Pedido de Venda Liberado
		  { "!Empty(C5_ZMOTREJ).And. !('XXXX' $ C5_NOTA)",'BR_AZUL'}}					   							//OK - Pedido de Venda Rejeitado pelo Financeiro

Return(aCores)
*/
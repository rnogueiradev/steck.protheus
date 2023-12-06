#include 'protheus.ch'
#include 'parmtype.ch'

User Function MA415COR()
	
Local aCores	:= 	{	{' CJ_STATUS == "A" .And. CJ_XPROLIG = dDataBase', 								'BR_VERDE'},;
						{' CJ_STATUS=="B"', 															'DISABLE'},;		//Orcamento Baixado
            	    	{' CJ_STATUS=="C"', 															'BR_PRETO'},;		//Orcamento Cancelado
            	    	{' CJ_STATUS=="D"', 															'BR_AMARELO'},;		//Orcamento nao Orcado
            	    	{" CJ_STATUS == 'A' .And. CJ_XPROLIG > dDataBase",								'BR_AZUL'},;		//Fecha de Retorno hoy                            
            	    	{" CJ_STATUS == 'A' .And. ( Empty(CJ_XPROLIG) .Or. CJ_XPROLIG < dDataBase )",	"BR_LARANJA"},; 	//Fecha de Retorno en retraso		
            	    	{'SCJ->CJ_STATUS=="F"', 														'BR_MARROM'}}		//Orcamento bloqueado

Return(aCores)

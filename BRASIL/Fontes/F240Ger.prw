#INCLUDE "Topconn.ch" 
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} F240Ger

@type function
@author Everson Santana
@since 07/11/18
@version Protheus 12 - Financeiro

@history Chamado 006558, Gerar Numeração automaticamente dos Arquivos CNAB ,

/*/

User Function F240Ger()

Local _lRet		:= .t.	
Local _cCaminho := GetMv("ST_SISPAGC") 
Local _cSeq		:=  Soma1(GetMv("ST_SISPAGS"),6)

PutMV("ST_SISPAGS",_cSeq)
 	
	DBSelectArea("SX1")
	DBSetOrder(1)
	nSpace := Len(SX1->X1_GRUPO) - 6
	If DbSeek("FIN240"+Space(nSpace)+"04")
		/* Removido 11/05/23 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		RecLock("SX1",.F.)
		SX1->X1_CNT01 := _cCaminho+_cSeq
		MsUnlock()
		*/
	Endif
	
	MV_PAR04 := _cCaminho+_cSeq
		
	AVISO("Sequencia Gerada", "Sequencia: "+_cSeq, { "Fechar" }, 1)
		
Return _lRet

#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} FA420NAR

@type function
@author Everson Santana
@since 07/11/18
@version Protheus 12 - Financeiro

@history Chamado 006558, Gerar Numeração automaticamente dos Arquivos CNAB ,

/*/

User Function FA420NAR()


	Local _cCaminho := GetMv("ST_CNABM2C")
	Local _cSeq		:=  Soma1(GetMv("ST_CNABM2S"),4)
	Local cArqSaida := _cCaminho + _cSeq //PARAMIXB // parametro 1 - nome do arquivo de saída.

	If MV_PAR05=="341"
       cArqSaida := "\CNAB\SAIDA\PAG_341_"+Rtrim(MV_PAR07)+"_"+_cSeq
	   PutMV("ST_CNABM2S",_cSeq)   
	Else
      	PutMV("ST_CNABM2S",_cSeq)       
	Endif



	AVISO("Sequencia Gerada", "Sequencia: "+cArqSaida, { "Fechar" }, 1)

Return cArqSaida

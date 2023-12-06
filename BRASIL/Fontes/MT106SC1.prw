#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | MT106SC1        | Autor | RENATO.OLIVEIRA           | Data | 18/05/2022  |
|=====================================================================================|
|Descrição | PE no final da geração da requisição                                     | 
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MT106SC1()

	Local _aArea := GetArea()

	conout("passou aqui1111")

	DbSelectArea("SZI")
	SZI->(DbSetOrder(3))//ZI_FILIAL+ZI_CC+ZI_APROVP
	SZI->(DbGoTop())
	If DbSeek(xFilial("SZI")+SC1->C1_CC)

		_cAprovp := SZI->ZI_APROVP
		_cSolici := __cUserId

		DbSelectArea("SZJ")
		SZJ->(DbSetOrder(3))//ZJ_FILIAL+ZJ_SOLICIT+ZJ_APROVP
		SZJ->(DbGoTop())

		If DbSeek(xFilial("SZJ")+(_cSolici)+(_cAprovp))
				
			SC1->(RecLock("SC1",.F.))
			If SC1->C1_ZSTATUS  == '1' .Or. SC1->C1_ZSTATUS == ' '
				SC1->C1_ZSTATUS:= '1'
			Endif
			SC1->C1_ZAPROV   := _cAprovp
			//SC1->C1_ZNOMEAP  := USRRETNAME(_cAprovp)
			//SC1->C1_ZSTATU2 := '5'//Substr(U_STCOM022('4',_cAprovp),1,1)
			//SC1->C1_ZANEXO  := (ADir("\arquivos\SC\"+cEmpAnt+"\"+cFilAnt+"\"+(SC1->C1_NUM)+"\*.MZP*"))
			
			SC1->(MsUnLock())

		EndIf

	EndIf

RestArea(_aArea)

Return()

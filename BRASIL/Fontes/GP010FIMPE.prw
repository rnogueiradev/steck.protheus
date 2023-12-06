#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} GP010FIMPE

@type function
@author Everson Santana
@since 23/03/19
@version Protheus 12 - Gestão de Pessoal

@description Ponto de entrada para grava a tabela Z49 - Avaliação de Experiencia
@history ,Ticket 20200131000266,

/*/

User Function GP010FIMPE()

	If  INCLUI

		DbSelectArea("Z49")
		DbSetOrder(1)

		Reclock("Z49",.t.)

			Z49->Z49_FILIAL		:= xFilial("SRA")
			Z49->Z49_COD 		:= GETSXENUM('Z49','Z49_COD')                                                                                                      
			Z49->Z49_MAT		:= SRA->RA_MAT
			Z49->Z49_NOME		:= SRA->RA_NOME	
			Z49->Z49_USER		:= SRA->RA_XUSRSUP
			Z49->Z49_STATUS		:= "1" 

		MsUnLock()

	EndIf

Return
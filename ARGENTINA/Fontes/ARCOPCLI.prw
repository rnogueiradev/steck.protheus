#INCLUDE "Rwmake.ch"


/*/{Protheus.doc} ARCOPCLI

@type function
@author Everson Santana
@since 21/06/19
@version Protheus 12 - Faturamento

@history ,Ticket 20190610000127,

/*/

User Function ARCOPCLI()

AxInclui("SA1",SA1->(Recno()),3,/*<aAcho>*/,"U_COPIARA1()",/*<aCpos>*/,"U_CPA1VLD()",.F.,/*<cTransact>*/,/*<aButtons>*/,/*<aParam>*/,/*<aAuto>*/,/*<lVirtual>*/,.T.)

Return

//Função para carregamento dos campos em variáveis de memória
User Function COPIARA1()

Local bCampo 	:= { |nCPO| Field(nCPO) }
Local nCountCpo	:= 0

DbSelectArea("SA1")

For nCountCpo := 1 TO SA1->(FCount())

	If (AllTrim(FieldName( nCountCpo )) <> "A1_COD")

		//Inputa o valor do campo posicionado, na variável de memória
		M->&(EVAL(bCampo, nCountCpo)) := FieldGet(nCountCpo)

	EndIf

Next nCountCpo
//valida se existe codigo que esta sendo copiado

Return nil

User Function CPA1VLD()

	If SA1->(dbSeek(xFilial("SA1")+M->A1_COD))

		MsgInfo("Código do Cliente já existente!")
		Return .F.
	Endif

Return .T.
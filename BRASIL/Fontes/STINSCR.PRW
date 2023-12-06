#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"


/*/{Protheus.doc} STINSCR
(Função para gravar incrição no arquivo SISPAG financeiro)

@author jefferson.carlos
@since 25/09/2017
@version 1.0
@return ${return}, ${return_description}

/*/


User Function STINSCR()

	Local cInscr	:=""

	If cempant = "01"

			
		If SEA->EA_FILORIG='01'
			cInscr='116686352116'
		ElseIf SEA->EA_FILORIG='02'
			//cInscr='149885489113'
			cInscr='188149628110'
		ElseIf SEA->EA_FILORIG='03'
			cInscr='149885470116'
		ElseIf SEA->EA_FILORIG='04'
			cInscr='145044391116'
		ElseIf SEA->EA_FILORIG='05'
		     cInscr='331048709119'
		EndIf

		//cInscr:= RTRIM(SM0->M0_INSC)

	elseif cempant = "03"
   
		
		If SEA->EA_FILORIG='01'
			cInscr='000063003392'

		EndIf
	EndIf
	
Return(cInscr)
	
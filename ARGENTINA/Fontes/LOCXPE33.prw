#INCLUDE "Rwmake.ch"


/*/{Protheus.doc} LOCXPE33

PUNTO DE ENTRADA QUE ADICIONA CAMPOS EN EL
ENCABEZADOS DE LA FACTURA DE ENTRADA SF1

@type function
@author Everson Santana
@since 17/12/18
@version Protheus 12 - Compras

@history ,Chamado 008164,

/*/

User Function LOCXPE33()

aCposFact := {}
aCposFact := Paramixb[1]

IF OAPP:CMODNAME == "SIGACOM" .AND. CFUNNAME $ ("MATA102N|MATA466N")

   aAdd(aCposFact,{NIL,"F1_XLOTE"   ,NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})
   aAdd(aCposFact,{NIL,"F1_XLOCAL"   ,NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})
   aAdd(aCposFact,{NIL,"F1_XEND"   ,NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})

ENDIF

//>>Chamado 008798 - Everson Santana - 14.01.2019

IF OAPP:CMODNAME == "SIGAFAT" .AND. CFUNNAME $ ("MATA467N")

   aAdd(aCposFact,{NIL,"F2_XOBS"   ,NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})


ENDIF

//>>Chamado 20190517000009 - Everson Santana - 19.06.2019
IF OAPP:CMODNAME == "SIGAFAT" .AND. CFUNNAME $ ("MATA465N")

	If SX2->X2_CHAVE == "SF1"
	   aAdd(aCposFact,{NIL,"F1_XOBS"   ,NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})
	   aAdd(aCposFact,{NIL,"F1_XLOCAL"   ,NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})
	   aAdd(aCposFact,{NIL,"F1_XSELOUT"   ,NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".F."})
	Else
		aAdd(aCposFact,{NIL,"F2_XOBS"   ,NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})
	EndIf

ENDIF
//<<

//<<

Return(aCposFact)

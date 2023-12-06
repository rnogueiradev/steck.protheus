#Include "Totvs.ch"

/*/{Protheus.doc} M460NUM
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

User Function M460NUM()

//controle para manipulacao do numero do documento
If (Type("__cCHNumNF") == "C" .and. Type("__cCHSerNF") == "C")
    cNumero := __cCHNumNF
    cSerie  := __cCHSerNF
EndIf

Return PARAMIXB

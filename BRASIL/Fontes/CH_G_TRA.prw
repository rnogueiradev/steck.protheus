#Include "Totvs.ch"

/*/{Protheus.doc} CH_G_CLI
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
aDados = Vetor com dados do execauto
aErros = Vetor para incluir erros de validação
*/

User Function CH_G_TRA(oTransp,aDados,aErros)

aAdd(aDados,{"A4_XBLQ",Padr("2",FWSX3Util():GetFieldStruct("A4_XBLQ")[3]),NIL})

Return {aDados,aErros}

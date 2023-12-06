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

User Function CH_G_CLI(oCliente,aDados,aErros)

LOCAL nPosNome := aScan(aDados,{|x| Alltrim(x[1]) == "A1_NOME"})
LOCAL nPosContr:= aScan(aDados,{|x| Alltrim(x[1]) == "A1_CONTRIB"})

aAdd(aDados,{"A1_XCARTE",Padr("S",FWSX3Util():GetFieldStruct("A1_XCARTE")[3]),NIL})
aAdd(aDados,{"A1_XENV",Padr("N",FWSX3Util():GetFieldStruct("A1_XENV")[3]),NIL})

//informacoes padrao
If ("EBAZAR" $ Alltrim(aDados[nPosNome][2]))
    aDados[nPosContr][2] := Padr("1",FWSX3Util():GetFieldStruct("A1_CONTRIB")[3])
    aAdd(aDados,{"A1_NATUREZ",Padr("10101",FWSX3Util():GetFieldStruct("A1_NATUREZ")[3]),NIL})
    aAdd(aDados,{"A1_EMAIL",Padr("NAORESPONDER@MERCADOLIVRE.COM",FWSX3Util():GetFieldStruct("A1_EMAIL")[3]),NIL})
Else
    aAdd(aDados,{"A1_NATUREZ",Padr("10101",FWSX3Util():GetFieldStruct("A1_NATUREZ")[3]),NIL})
    aAdd(aDados,{"A1_EMAIL",Padr("NAORESPONDER@MERCADOLIVRE.COM",FWSX3Util():GetFieldStruct("A1_EMAIL")[3]),NIL})
EndIf

Return {aDados,aErros}

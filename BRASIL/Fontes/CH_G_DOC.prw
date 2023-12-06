#Include "Totvs.ch"

/*/{Protheus.doc} CH_G_DOC
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
aCabec = Vetor com cabeçalho do execauto
aItens = Vetor com item do execauto
aErros = Vetor para incluir erros de validação
*/

User Function CH_G_DOC(oDoc,aCabec,aItens,aErros)

Local nPosEspec := aScan(aCabec,{|x| Alltrim(x[1]) == "F1_ESPECIE"})
//Local nPosDigit := aScan(aCabec,{|x| Alltrim(x[1]) == "F1_DTDIGIT"})
/*
//verifica se é ultimo dia do mes e altera para proximo
If (Month(dDataBase) <> Month(DaySum(dDataBase,1)))
    dDataBase := DaySum(dDataBase,1)
    aCabec[nPosDigit][2] := dDataBase
EndIf
*/
if (aCabec[nPosEspec][2] == 'CTE')
   aadd(aCabec,{"E2_NATUREZ",Padr("24540",FWSX3Util():GetFieldStruct("E2_NATUREZ")[3]),Nil})
endif

Return {aCabec,aItens,aErros}

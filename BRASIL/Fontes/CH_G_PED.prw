//#Include "Totvs.ch"

#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} CH_G_PED
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
aCabec = Vetor com cabeçalho do execauto
aItens = Vetor com item do execauto
aErros = Vetor para incluir erros de validação
*/

User Function CH_G_PED(oPedido,aCabec,aItens,aErros)

Local i 
Local nPosCond  := aScan(aCabec,{|x| Alltrim(x[1]) == "C5_CONDPAG"})
Local nPosClient:= aScan(aCabec,{|x| Alltrim(x[1]) == "C5_CLIENTE"})
Local nPosLoja  := aScan(aCabec,{|x| Alltrim(x[1]) == "C5_LOJACLI"})
Local nPosTipo  := aScan(aCabec,{|x| Alltrim(x[1]) == "C5_TIPO"})
//Local nPosEmis  := aScan(aCabec,{|x| Alltrim(x[1]) == "C5_EMISSAO"})
Local cCondPg   := "554"
Local nPosProd
Local nPosLocal
/*
//verifica se é ultimo dia do mes e altera para proximo
If (Month(dDataBase) <> Month(DaySum(dDataBase,1)))
    dDataBase := DaySum(dDataBase,1)
    aCabec[nPosEmis][2] := dDataBase
EndIf
*/
If (aCabec[nPosTipo][2] == 'N')
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+aCabec[nPosClient][2]+aCabec[nPosLoja][2]))
		//informacoes padrao
		If ("EBAZAR" $ Alltrim(SA1->A1_NOME))
			aAdd(aCabec,{"C5_ZCONSUM",PADR("2",FWSX3Util():GetFieldStruct("C5_ZCONSUM")[3]),Nil})
            aAdd(aCabec,{"C5_TRANSP",PADR("10002",FWSX3Util():GetFieldStruct("C5_TRANSP")[3]),Nil})
            
		EndIf
	EndIf
EndIf

//CONDPAG PERSONALIZADA
If (nPosCond == 0)
    aAdd(aCabec,{"C5_CONDPAG",cCondPg,Nil})
    aAdd(aCabec,{"C5_ZCONDPG",cCondPg,Nil})
else
	aAdd(aCabec,{"C5_ZCONDPG",aCabec[nPosCond][2],Nil})
EndIf

//TIPO DE ENTREGA
aAdd(aCabec,{"C5_XTIPO",PADR("1",FWSX3Util():GetFieldStruct("C5_XTIPO")[3]),Nil})
aAdd(aCabec,{"C5_XTIPF",PADR("1",FWSX3Util():GetFieldStruct("C5_XTIPF")[3]),Nil})
aAdd(aCabec,{"C5_XORDEM",PADR(".",FWSX3Util():GetFieldStruct("C5_XORDEM")[3]),NIL})
aAdd(aCabec,{"C5_XORIG",PADR("2",FWSX3Util():GetFieldStruct("C5_XORIG")[3]),NIL})

//retira campo para compatibilizar execauto
For i:= 1 to len(aItens)
    aDel(aItens[i],aScan(aItens[i],{|x| Alltrim(x[1]) == "C6_OPER"}))
	aSize(aItens[i],Len(aItens[i])-1)
Next

//ajusta todos os itens para o estoque 00
For i:= 1 to len(aItens)
    //verifica posicao de alguns itens
	nPosProd := aScan(aItens[i],{|x| Alltrim(x[1]) == "C6_PRODUTO"})
    nPosLocal:= aScan(aItens[i],{|x| Alltrim(x[1]) == "C6_LOCAL"})
    //CRIA local de estoque
    CriaSb2(aItens[i][nPosProd][2],aItens[i][nPosLocal][2]) 
    //altera valor de local
    If (nPosLocal > 0 .and. Alltrim(aItens[i][nPosLocal][2]) == '06')
        aAdd(aItens[i],{"C6_LOCALIZ",PADR("MELI",FWSX3Util():GetFieldStruct("C6_LOCALIZ")[3]),NIL})
    EndIf
Next


Return {aCabec,aItens,aErros}

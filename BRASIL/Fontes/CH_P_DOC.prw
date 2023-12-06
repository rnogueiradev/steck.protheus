#Include "Totvs.ch"

/*/{Protheus.doc} CH_P_DOC
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
oDoc = JSON do Pedido
*/

User Function CH_P_DOC(oDoc)

Local aCab      := {}
Local aAux      := {}
Local aItem     := {}
Local cEnder    := PADR("MELI",FWSX3Util():GetFieldStruct("DB_LOCALIZ")[3])
Local cAlias    := GetNextAlias()

Private lMsErroAuto := .f.

BeginSql Alias cAlias

SELECT	SD1.D1_COD
    ,   SD1.D1_LOCAL
    ,   SD1.D1_NUMSEQ
    ,   SD1.D1_DOC
    ,   SD1.D1_SERIE
    ,   SD1.D1_FORNECE
    ,   SD1.D1_LOJA
    ,   SD1.D1_QUANT
    ,   SD1.D1_FILIAL

FROM	%Table:SD1% SD1

WHERE	SD1.D1_FILIAL	= %Exp:SF1->F1_FILIAL%
    AND	SD1.D1_DOC		= %Exp:SF1->F1_DOC%
    AND	SD1.D1_SERIE	= %Exp:SF1->F1_SERIE%
    AND	SD1.D1_FORNECE	= %Exp:SF1->F1_FORNECE%
    AND	SD1.D1_LOJA	    = %Exp:SF1->F1_LOJA%
    AND SD1.%notdel%

EndSql

(cAlias)->(dbGoTop())
While (cAlias)->(!Eof())

    //endereçamento de saldo caso houver
    SDA->(dbSetOrder(1))
    If SDA->(dbSeek((cAlias)->D1_FILIAL+(cAlias)->D1_COD+(cAlias)->D1_LOCAL+(cAlias)->D1_NUMSEQ+(cAlias)->D1_DOC+(cAlias)->D1_SERIE+(cAlias)->D1_FORNECE+(cAlias)->D1_LOJA)) .and. SDA->DA_SALDO > 0

        lMsErroAuto := .f.
        aCab  := {}
        aAux  := {}
        aItem := {}

        aAdd(aCab,{"DA_PRODUTO",(cAlias)->D1_COD,NIL})
        aAdd(aCab,{"DA_LOCAL",(cAlias)->D1_LOCAL,NIL})
        aAdd(aCab,{"DA_NUMSEQ",(cAlias)->D1_NUMSEQ,NIL})
        aAdd(aCab,{"DA_DOC",(cAlias)->D1_DOC,NIL})
        aAdd(aCab,{"DA_SERIE",(cAlias)->D1_SERIE,NIL})
        aAdd(aCab,{"DA_CLIFOR",(cAlias)->D1_FORNECE,NIL})
        aAdd(aCab,{"DA_LOJA",(cAlias)->D1_LOJA,NIL})        
        
        aAdd(aAux,{"DB_ITEM",StrZero(1,TamSX3("DB_ITEM")[1]),NIL})
        aAdd(aAux,{"DB_LOCALIZ",cEnder,NIL})
        aAdd(aAux,{"DB_DATA",dDataBase,NIL})
        aAdd(aAux,{"DB_QUANT",(cAlias)->D1_QUANT,NIL})
        aAdd(aItem,aAux)
                        
        MSExecAuto({|x,y,z| mata265(x,y,z)},aCab,aItem,3)

        If lMsErroAuto 


        EndIf
        
    EndIf

    (cAlias)->(dbSkip())

EndDo
(cAlias)->(DbCloseArea())

Return

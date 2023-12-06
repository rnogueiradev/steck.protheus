#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Tbiconn.ch"
#Include "Topconn.ch"

#DEFINE ENTER CHAR(13) + CHAR(10)
/*
Rotina de enedereçamento automatico steck
Liberado - Armazém 10 (endereço RETRABALHO)
Liberado - Armazém 95 (endereço SEGREGADO)
Liberado - Armazém 60 (endereço NF)
Armazém 40 (endereço SINISTRO)
Rejeitado - Armazém 97 (endereço REJEITADOS)
IIf(nAcao < 4,1,2) // Menor 4 Liberado,Maior que 4 Rejeitado
*/
User Function STKENDAT(nTpMov,cProd,cLocAnt,cLocDest,cNumero,cNumSeq,cNtfis,nQtdEnd)

    Local aRet := {"",""}
    Local lRet := .T.
    Local nQuant2UM := 0
    //Local nBaixa	:= 0
    //Local nBaixa2	:= 0
    Local cEndDest  := ""
    Default nTpMov := 0 
    Default cLocDest := ""


    If nTpMov == 1   .And. !Empty(cLocDest) //Liberado
        //Liberado - Armazém 10 (endereço RETRABALHO)
        If cLocDest == "10"
            aRet := {"10","RETRABALHO"}
            cLocDest := "10"
            cEndDest := "RETRABALHO"
        //Liberado - Armazém 95 (endereço SEGREGADO)
        ElseIf cLocDest == "95"
            aRet := {"95","SEGREGADO"}
            cLocDest := "95"
            cEndDest := "SEGREGADO"
        //Liberado - Armazém 60 (endereço NF)
        ElseIf cLocDest == "60"
            aRet := {"60","NF"}
            cLocDest := "60"
            cEndDest := "NF"
        EndIf   
    
    Elseif nTpMov == 2 .And. !Empty(cLocDest) //Rejeitado
        
        //Rejeitado Armazém 40 (endereço SINISTRO)
        If cLocDest == "40"
            aRet := {"40","SINISTRO"}
            cLocDest := "40"
            cEndDest := "SINISTRO"
        //Rejeitado - Armazém 97 (endereço REJEITADOS)
        ElseIf cLocDest == "97"
            aRet := {"97","REJEITADOS"}
            cLocDest := "97"
            cEndDest := "REJEITADOS"
        //Liberado - Armazém 95 (endereço SEGREGADO)
        ElseIf cLocDest == "95"
            aRet := {"95","SEGREGADO"}
            cLocDest := "95"
            cEndDest := "SEGREGADO"
        EndIf
    EndIf
    
    If !Empty(Alltrim(cLocDest)) .And. !Empty(Alltrim(cEndDest))
        nQuant2UM	:= ConvUm(cProd,nQtdEnd,nQuant2UM,2)
        
        cQrySDA := " SELECT DA_NUMSEQ FROM " + RetSqlName("SDA") + " SDA "
        cQrySDA += ENTER +  " WHERE SDA.D_E_L_E_T_ <> '*' AND SDA.DA_FILIAL ='" + xFilial("SDA") + "'  AND SDA.DA_DOC = '" + Alltrim(cNumero) + "' "
        cQrySDA += ENTER +  " AND SDA.DA_PRODUTO = '" + cProd + "' AND SDA.DA_LOCAL = '" + cLocDest + "' AND SDA.DA_SALDO > 0 AND SDA.DA_DATA ='" + DTOS(DDATABASE) +"' "
        
        If Select("TBSDA") > 0 
            TBSDA->(DbCloseArea())
        EndIf
        TCQUERY  cQrySDA NEW ALIAS "TBSDA"
        If TBSDA->(!EOF())
            cNumSeq := TBSDA->DA_NUMSEQ
        Endif   

        SDA->(DbSetOrder(1))
        
        If SDA->(DbSeek(xFilial("SDA")+cProd+cLocDest+cNumSeq))			
            
            lOk :=  A100Distri(SDA->DA_PRODUTO,cLocDest,SDA->DA_NUMSEQ,SDA->DA_DOC,SDA->DA_SERIE,SDA->DA_CLIFOR,SDA->DA_LOJA,AllTrim(cEndDest),Nil,nQtdEnd,SDA->DA_LOTECTL,SDA->DA_NUMLOTE)
            lRet := lOk

        EndIf

          
        If Select("TBSDA") > 0 
            TBSDA->(DbCloseArea())
        EndIf

    EndIf
Return lRet

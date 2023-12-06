#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Tbiconn.ch"
#Include "Topconn.ch"

#DEFINE ENTER CHAR(13) + CHAR(10)
/*
Rotina de enedere�amento automatico steck
Liberado - Armaz�m 10 (endere�o RETRABALHO)
Liberado - Armaz�m 95 (endere�o SEGREGADO)
Liberado - Armaz�m 60 (endere�o NF)
Armaz�m 40 (endere�o SINISTRO)
Rejeitado - Armaz�m 97 (endere�o REJEITADOS)
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
        //Liberado - Armaz�m 10 (endere�o RETRABALHO)
        If cLocDest == "10"
            aRet := {"10","RETRABALHO"}
            cLocDest := "10"
            cEndDest := "RETRABALHO"
        //Liberado - Armaz�m 95 (endere�o SEGREGADO)
        ElseIf cLocDest == "95"
            aRet := {"95","SEGREGADO"}
            cLocDest := "95"
            cEndDest := "SEGREGADO"
        //Liberado - Armaz�m 60 (endere�o NF)
        ElseIf cLocDest == "60"
            aRet := {"60","NF"}
            cLocDest := "60"
            cEndDest := "NF"
        EndIf   
    
    Elseif nTpMov == 2 .And. !Empty(cLocDest) //Rejeitado
        
        //Rejeitado Armaz�m 40 (endere�o SINISTRO)
        If cLocDest == "40"
            aRet := {"40","SINISTRO"}
            cLocDest := "40"
            cEndDest := "SINISTRO"
        //Rejeitado - Armaz�m 97 (endere�o REJEITADOS)
        ElseIf cLocDest == "97"
            aRet := {"97","REJEITADOS"}
            cLocDest := "97"
            cEndDest := "REJEITADOS"
        //Liberado - Armaz�m 95 (endere�o SEGREGADO)
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

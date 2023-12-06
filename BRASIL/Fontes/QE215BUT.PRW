#include "Protheus.ch"
#Include "QIEA215.ch"

/*/{Protheus.doc} QE215BUT
Aprovação/Rejeição automática para Inspeção de Entrada - Liberação Urgente em Lote
@type function
@version 12.1.27
@author Ricardo Munhoz
@since 30/05/2022
/*/
User Function QE215BUT

    Aadd(aButtons,{"CARGA",{|| U_LUrLote()},"Liberação Urgente em LOTE","Lib. Urg. LOTE"})

Return aButtons


/*/{Protheus.doc} LUrLote
Aprovação/Rejeição automática para Inspeção de Entrada - Liberação Urgente em Lote
@type function
@version 12.1.27
@author Ricardo Munhoz
@since 30/05/2022
/*/
User Function LUrLote
Local aArea := GetArea()
Local cFilialX := cFilAnt
Local cNotaX := QEK->QEK_NTFISC
Local cSerieX := QEK->QEK_SERINF
Local cTipoX := QEK->QEK_TIPONF
Local cForneceX := QEK->QEK_FORNEC
Local cLojaForX := QEK->QEK_LOJFOR
Local cAcao := ""
Local aParam := {}
Local aRetParm := {}
Local lOK := .F.

If cTipoX <> "D"
    FWAlertInfo("Rotina disponível somente para Notas Fiscais do Tipo Devolução...")
    Return .F.
EndIf

aAdd(aParam,{1,"Filial: ",cFilialX,"",".T.",,".F.",80,.F.})
aAdd(aParam,{1,"Nota Fiscal: ",cNotaX,"@!",".T.",,".F.",80,.F.})
aAdd(aParam,{1,"Série Nota Fiscal: ",cSerieX,"@!",".T.",,".F.",80,.F.})
aAdd(aParam,{1,"Fornecedor: ",cForneceX,"@!",".T.",,".F.",80,.F.})
aAdd(aParam,{1,"Loja: ",cLojaForX,"@!",".T.",,".F.",80,.F.})
aAdd(aParam,{1,"Tipo Nota Fiscal: ",cTipoX + IIf(cTipoX == "D","=Devolução",""),"@!",".T.",,".F.",80,.F.})
aAdd(aParam,{2,"Ação",cAcao,{"1=Aprovado Armazém 03","2=Aprovado Armazém 10","3=Aprovado Armazém 60","4=Rejeitado Armazém 95","5=Rejeitado Armazém 97"},80,".T.",.F.})

If ParamBox(aParam,"Dados para Processamento",aRetParm)
	lOK	:= .T.
EndIf

If lOK
	Processa({|| fGeraRes(aRetParm)},"Processando [Lib. Urg. LOTE]","Aguarde , processando Nota Fiscal - Geração de Resultado Liberação Laudos Urgentes LOTE...")
    FWAlertSuccess("Processamento Concluído...")
Else
    FWAlertSuccess("Operação Cancelada...")
EndIf

RestArea(aArea)
Return


/*/{Protheus.doc} fGeraRes
Processamento Geração de Resultado
@type function
@version 12.1.27
@author Ricardo Munhoz
@since 30/05/2022
/*/
Static Function fGeraRes(aRet)
Local aArea := GetArea()
Local cFilialX := AllTrim(aRet[1])
Local cNotaX := AllTrim(aRet[2])
Local cSerieX := AllTrim(aRet[3])
Local cForneceX := AllTrim(aRet[4])
Local cLojaForX := AllTrim(aRet[5])
Local cTipoX := Substr(AllTrim(aRet[6]),1,1)
Local nAcao := Val(aRet[7])
Local aArmazem := {"03","10","60","95","97"}
Local cStmt := ""
Local cAlias000 := ""
Local aItem := {}
Local nTotal := 0
Local nAtual := 0

cAlias000 := GetNextAlias()
cStmt := "SELECT QEK_PRODUT,QEK_NUMSEQ,QEK_CERFOR,QEK_LOCORI,QEK_ITEMNF,QEK_TIPONF,QEK_TAMAMO,QEK_DTENTR,QEK_LOTE,QEK_REVI,R_E_C_N_O_ QEKRECNO FROM " + RetSqlName("QEK") + " WHERE "
cStmt += "QEK_FILIAL = '" + cFilialX + "' AND QEK_NTFISC = '" + cNotaX + "' AND QEK_SERINF = '" + cSerieX + "' AND "
cStmt += "QEK_FORNEC = '" + cForneceX + "' AND QEK_LOJFOR = '" + cLojaForX + "' AND QEK_SITENT = '1' AND QEK_TIPONF = '" + cTipoX + "' AND D_E_L_E_T_ = ' ' "
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cStmt),cAlias000,.T.,.T.)

//nTotal := (cAlias000)->(FCount())
Do While !(cAlias000)->(EOF())
    nTotal++
    (cAlias000)->(DbSkip())
EndDo
ProcRegua(nTotal)
(cAlias000)->(DbGoTop())

Do While !(cAlias000)->(EOF()) .And. nAtual < nTotal
	nAtual++
	IncProc("Processando Produto: " + (cAlias000)->QEK_PRODUT + ", registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal))
Begin Transaction
    DbSelectArea("QEL")
	RecLock("QEL",.T.)
	QEL->QEL_FILIAL	:= FWxFilial("QEL")
    QEL->QEL_FORNEC	:= cForneceX
    QEL->QEL_LOJFOR := cLojaForX
    QEL->QEL_PRODUT	:= (cAlias000)->QEK_PRODUT
    QEL->QEL_DTENTR	:= SToD((cAlias000)->QEK_DTENTR)
    QEL->QEL_LOTE	:= (cAlias000)->QEK_LOTE
//    QEL->QEL_LABOR	:= ""
    QEL->QEL_NUMSEQ	:= (cAlias000)->QEK_NUMSEQ
    QEL->QEL_DTENLA	:= SToD((cAlias000)->QEK_DTENTR)
    QEL->QEL_HRENLA	:= Left(Time(),5)
    QEL->QEL_REVI	:= (cAlias000)->QEK_REVI
    QEL->QEL_LAUDO	:= "U"
    QEL->QEL_DTLAUD	:= dDatabase
    QEL->QEL_HRLAUD	:= Left(Time(),5)
    QEL->QEL_DTVAL	:= dDatabase
    QEL->QEL_TAMLOTE := (cAlias000)->QEK_TAMAMO
    If nAcao < 4
        QEL->QEL_QTDAPR	:= (cAlias000)->QEK_TAMAMO
        QEL->QEL_QTREJ	:= "0"
    Else
        QEL->QEL_QTDAPR	:= "0"
        QEL->QEL_QTREJ	:= (cAlias000)->QEK_TAMAMO
    EndIf
    QEL->QEL_DTDILA	:= dDatabase
    QEL->QEL_HRDILA	:= Left(Time(),5)
    QEL->QEL_JUSTLA := "Entrada aprovada em regime de Liberacao Urgente"
    QEL->QEL_NISERI	:= cNotaX + cSerieX + (cAlias000)->QEK_ITEMNF
    QEL->QEL_TIPONF	:= (cAlias000)->QEK_TIPONF
    QEL->QEL_XAPROV	:= AllTrim(GetSX3Cache("QEL_XAPROV","X3_RELACAO"))
    QEL->QEL_NOMRES	:= QA_NUSR(,,.F.,"N")
    QEL->QEL_XFIL	:= FWxFilial("QEL")
    QEL->(MsUnlock())
    DbSelectArea("SD7")
    DbSetOrder(1)
//                     {"D7_QTDE" ,Val(AllTrim((cAlias000)->QEK_TAMAMO)) ,Nil},;
//                     {"D7_OBS" ,"Lib. Urg. LOTE" ,Nil},;
//                     {"D7_MOTREJE" ,"" ,Nil},;
//                     {"D7_ESTORNO" ,NIL ,Nil},;
    If DbSeek(FWxFilial("SD7") + AllTrim((cAlias000)->QEK_CERFOR) + (cAlias000)->QEK_PRODUT + (cAlias000)->QEK_LOCORI)
//        RecLock("SD7",.F.)
//        SD7->D7_LIBERA = 'S'
//        SD7->(MsUnlock())
        aAdd(aItem,{ {"D7_TIPO" ,IIf(nAcao < 4,1,2),Nil},;
                     {"D7_SEQ" ,Soma1(SD7->D7_SEQ) ,Nil},;
                     {"D7_DATA" ,dDatabase ,Nil},;
                     {"D7_PRODUTO" ,SD7->D7_PRODUTO,Nil},;
                     {"D7_QTDE" ,SD7->D7_SALDO ,Nil},;
                     {"D7_SALDO" ,0 ,Nil},;
                     {"D7_DOC" ,SD7->D7_DOC ,Nil},;
                     {"D7_SERIE" ,SD7->D7_SERIE ,Nil},;
                     {"D7_FORNECE" ,SD7->D7_FORNECE ,Nil},;
                     {"D7_LOJA" ,SD7->D7_LOJA ,Nil},;
                     {"D7_LIBERA" ,IIf(nAcao < 4,"S","N") ,Nil},;
                     {"D7_LOCALIZ" ,"QUALIDADE" ,Nil},;
                     {"D7_LOCDEST" ,aArmazem[nAcao] ,Nil}})
        
        cProdMov   :=  SD7->D7_PRODUTO
        cNumero	   :=  SD7->D7_NUMERO
	    cLocAnt	   :=  SD7->D7_LOCAL
        cNumSeqMov :=  SD7->D7_NUMSEQ
        cNumNfMov  :=  SD7->D7_DOC
        cArmMov    :=  aArmazem[nAcao]
        nQtdMov    :=  SD7->D7_SALDO
        nTipoMov   :=  IIf(nAcao < 4,1,2)
        
        lMsErroAuto := .F.
        lMsHelpAuto := .T.

        MSExecAuto({|x,y| mata175(x,y)},aItem,4)
        IF lMsErroAuto
            nAtual := nTotal
            MOSTRAERRO()
            DisarmTransaction()
        Else
          
            DbSelectArea("QEK")
            QEK->(DbGoTo((cAlias000)->QEKRECNO))
            RecLock("QEK",.F.)
            QEK->QEK_CERQUA := QA_SEQUSX6("QIE_CEQU",TamSX3("QEK_CERQUA")[1],"S",STR0090)
   		    QEK->QEK_DATALU	:= dDatabase
    	    QEK->QEK_HORALU	:= Left(Time(),5)
	        QEK->QEK_RESPLU	:= QA_Usuario()[3]
            If nAcao < 4
                QEK->QEK_SITENT := "4"
            Else
                QEK->QEK_SITENT := "3"
            EndIf
            QEK->(MsUnlock())
            //Fazer Enderçamento automático 
            U_STKENDAT( nTipoMov,cProdMov,cLocAnt,cArmMov,cNumero,cNumSeqMov,cNumNfMov,nQtdMov)
            //Fim Enderçamento automático

        Endif
    Else
        FWAlertError("A Chave: " + FWxFilial("SD7") + AllTrim((cAlias000)->QEK_CERFOR) + (cAlias000)->QEK_PRODUT + (cAlias000)->QEK_LOCORI + ". É inexistente na tabela SD7")
//        DisarmTransaction()
    EndIf
End Transaction
    aSize(aItem,0)
    (cAlias000)->(DbSkip())
EndDo

(cAlias000)->(DbCloseArea())
FErase(cAlias000 + GetDbExtension())

RestArea(aArea)
Return

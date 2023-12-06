#INCLUDE "PROTHEUS.CH" 
#Include 'TOTVS.CH'
#Include 'TopConn.ch'

/*/{Protheus.doc} User Function JOBFSFA10
	Job para geração de OS. 
    @type  Function
    @author Antonio Moura
    @since 01/08/2023
    /*/

User Function JOBFSFA10()


Local aCabDoc   :={}
Local nQtdDoc   :=0 
Local aRet      :={}
Local lJob      :=.T.
Local l1PN      :=.F.
Local aDados    :={}
Local lMudaQtd	:=.F.
Local lAutOrd   :=.T.
Local _cLockBy  := "GeraCB7"

Default aOSGer 	:= {}

RpcClearEnv()
RpcSetType(3)
RpcSetEnv("11","01",,,"FAT")	

lAutOrd  := GetMV("ST_AUTORD",.F.,.T.)

IF lAutOrd

   nQtdDoc   := GetMv("FS_QTDDOC")
   cArmSel   := Alltrim(GetNewPar("FS_ARMEXP","03"))
   aCabDoc   := {"C5_NUM","C5_CLIENTE","C5_LOJACLI","C5_XNOME","C5_XTIPO","C5_EMISSAO","C5_XTIPF","QTD_LIN","LIN_SCH","LIN_STK","REABASTECIMENTO","E4_XVLRMIN","C6_VALOR","VLR_SCH","VLR_STK","C5_XBLQFMI","RESERVA","C5_XALERTF"} 

   IF !LockByName(_cLockBy,.F.,.F.,.T.)
	   Conout('Processa ja esta sendo executado em outra seção !!! ')
	   RETURN()
    ENDIF

   aDados:=U_LoadSC5(nQtdDoc,aCabDoc,'',aRet,lJob,l1PN)
   U_GeraCB7R(cArmSel,aDados,lMudaQtd,l1PN,lJob,@aOSGer)

   UnLockByName(_cLockBy,.F.,.F.,.T.)

ENDIF


Return()

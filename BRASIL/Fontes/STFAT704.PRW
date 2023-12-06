#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STFAT704
@name STFAT704
@type User Function
@desc rotina a ser processada via JOB deve eliminar residuo de pedido dos clientes home center. 
@author Antonio Cordeiro Moura
@since 02/10/2023
/*/

User Function STFAT704()

Local cQuery     :=""
Local cAlias     :=""
Local aDados     :={}
Local CanalHome  :=""
Local CliHome    :=""

RpcClearEnv()
RpcSetType(3)
RpcSetEnv("11","01",,,"FAT")	

CanalHome:=GetMv("ST_CANHOME",,"('D3')")
CliHome :=GetMv("ST_CLIHOME",,"('038134','036970')")
nDiaRes  :=GetMv("ST_DIARES",,1)
cAlias   := GetNextAlias()


cQuery := " SELECT SC5.C5_FILIAL FILIAL ,SC5.C5_NUM PEDIDO "+CRLF
cQuery += " FROM "+RetSqlName("SC5")+ " SC5 "+CRLF
cQuery += " INNER JOIN "+RetSqlName("SA1")+ " SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "+CRLF
//cQuery += " AND SA1.A1_GRPVEN = '"+CanalHome+"' "+CRLF
cQuery += " AND SA1.A1_GRPVEN IN "+CanalHome+CRLF
IF ! Empty(CliHome)
    cQuery += " AND SA1.A1_COD IN "+CliHome+CRLF
ENDIF

cQuery += " INNER JOIN "+RetSqlName("SC6")+ " SC6 ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM " +CRLF

cQuery += " AND SC6.C6_QTDENT < SC6.C6_QTDVEN "+CRLF

cQuery += " AND SC6.C6_BLQ<>'R' AND SC6.D_E_L_E_T_ = ' ' "+CRLF

cQuery += " INNER JOIN "+RetSqlName("SD2")+ " SD2 ON SD2.D2_FILIAL = SC6.C6_FILIAL AND SD2.D2_PEDIDO = SC6.C6_NUM " +CRLF
//cQuery += " AND SD2.D2_ITEMPV = SC6.C6_ITEM 
cQuery += " AND SD2.D_E_L_E_T_ = ' ' "+CRLF 

cQuery += " INNER JOIN "+RetSqlName("SF2")+ " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC " +CRLF
cQuery += " AND SD2.D2_SERIE = SD2.D2_SERIE AND SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DAUTNFE <= '"+DTOS(DATE()-nDiaRes)+"' "+CRLF

cQuery += " WHERE SC5.C5_FILIAL = '"+XFILIAL('SC5')+"' "+CRLF
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " GROUP BY SC5.C5_FILIAL,SC5.C5_NUM "+CRLF

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
IF (cAlias)->( ! Eof())
   While (cAlias)->( ! Eof())
      AADD(aDados,{(cAlias)->FILIAL,(cAlias)->PEDIDO})
      (cAlias)->(DBSKIP())
   ENDDO
ENDIF   	  

IF LEN(aDados)>0
   Elimina(aDados) // Elimina residuo. 
ENDIF 

Return()


Static Function Elimina(aDados1)

Local nx:=0
For nx:=1 to len(aDados1)
  DbSelectArea("SC5")
  SC5->(DbSetOrder(1))
  IF SC5->(dbseek(aDados1[nx,1]+aDados1[nx,2]))
     lContinua := ExecBlock("M410VRES",.F.,.F.)
     If lContinua
	    Begin Transaction
	      //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	      //� Eliminacao de residuo                                �
	      //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	      dbSelectArea("SC6")
	      dbSetOrder(1)
	      MsSeek(xFilial("SC6")+SC5->C5_NUM)
	
	      While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM 	== SC5->C5_NUM )
			 lValido  := .T.
			 If lValido .And. !Empty(SC5->C5_PEDEXP) .And. SuperGetMv("MV_EECFAT") // Integracao SIGAEEC
				If FindFunction("EECZERASALDO")
					lValido := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
				Else
					lValido := EECCancelPed(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
				EndIf
			 EndIf
			 If lValido .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
				MaResDoFat(,.T.,.F.)
			 EndIf
			 dbSelectArea("SC6")
			 dbSkip()
	      EndDo
	      SC6->(MaLiberOk({SC5->C5_NUM},.T.))
          IF SC5->C5_NOTA=='XXXXXXXXX' // Residuo eliminado com sucesso. 
 	         SC5->(RecLock("SC5",.F.))
		     SC5->C5_XMOTRES	:= 'STFAT704-JOB Elimina HomeCenter'
			 SC5->C5_XDTRES     :=DATE()
		     SC5->(MsUnLock())              
	      ELSE 
             // Falha na elimina豫o do residuo. 
	      ENDIF   
       End Transaction
	 ENDIF   
   ENDIF
Next 

Return()



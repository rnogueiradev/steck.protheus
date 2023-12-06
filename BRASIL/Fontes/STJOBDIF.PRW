#INCLUDE "PROTHEUS.CH"
#Include 'TOTVS.CH'
#Include 'TopConn.ch'

/*/{Protheus.doc} User Function VERDIF 
	Ver divergências entre pedidos Industria x Distribuidora 
    @type  Function
    @author Antonio Moura
    @since 10/11/2022
/*/

#DEFINE SM0_CODFIL 2

User Function STJOBDIF()

RpcClearEnv()
RpcSetType(3)
RpcSetEnv("11","01",,,"FAT")	

U_VERDIFGUA()

U_VERDIFMAN()

RETURN()



/*/{Protheus.doc} User Function VERDIF 
	Ver divergências entre pedidos Industria Guararema x Distribuidora 
    @type  Function
    @author Antonio Moura
    @since 10/11/2022
////////////////////////////////////////////////////////////////////////////////////////////////////
/*/

User Function VERDIFGUA()


Local cAlias   :=""
Local cConsulta:=""
Local z:=""
Local q:=""
Local nTotRegTmp:=0
Local _cArquivo:=""
Local aRet1:={}
Local cDirTemp    := ""
Local _nDif:=0
Local aFiles:={}
Local cEmp:='01'
Local lDif :=.F.
Private aItem:={}


Default dDataf:=DTOS(DATE()-30)


//RpcClearEnv()
//RpcSetType(3)
//RpcSetEnv("11","01",,,"FAT")	

AddItem()

cAlias   := GetNextAlias()

//cDirTemp    := GetTempPath()
cDirTemp    := '\arquivos\'
_cArquivo:='VERDIFGUA.CSV'
_cArquivo:=cDirTemp+_cArquivo

z := fcreate(_cArquivo)

If z <= 0
   MsgBox('Nao foi possível criar o arquivo!!! Revisar diretório de destino','Atenção','Info')
   Return()
ENDIF


 q:='FILIND;PED_IND;ITEM_IND;QTDVEN_IND;QTDENT_IND;SALDO_ENT_IND;SALDO_REC_DIS;QTD_FAT;D1_DIS;D1_SEMTES_DIS;ENCER;DIF'


fwrite(z,q,len(q))
q:= chr(13)+chr(10);fwrite(z,q,len(q))


//-- DISTRIBUIDORA X GUARAREMA

cConsulta+= " SELECT FILIND,PED_IND,ITEM_IND,QTDVEN_IND,QTDENT_IND,SALDO_ENT_IND,ENCER,SALDO_REC_DIS ,SUM(SD2I.D2_QUANT) QTDFATQUANT "
cConsulta+= " FROM ( "
cConsulta+= " SELECT SC6I.C6_FILIAL FILIND, SC6I.C6_NUM PED_IND,SC6I.C6_ITEM ITEM_IND,SC6I.C6_QTDVEN QTDVEN_IND,SC6I.C6_QTDENT QTDENT_IND,SC6I.C6_QTDVEN-SC6I.C6_QTDENT SALDO_ENT_IND, "
cConsulta+= " SC7D.C7_ENCER ENCER, "
cConsulta+= " CASE WHEN SC7D.C7_ENCER<>'E' THEN ( SC7D.C7_QUANT-SC7D.C7_QUJE) ELSE 0 END SALDO_REC_DIS "
cConsulta+= " FROM UDBP12.SC6010 SC6I "
cConsulta+= " LEFT JOIN UDBD11.SC7110 SC7D ON SC7D.C7_FILIAL = '01'  AND SC7D.C7_FORNECE = '005764'  AND SC7D.C7_LOJA = '05' AND SC6I.C6_NUMPCOM=SC7D.C7_NUM AND SC6I.C6_ITEMPC=SC7D.C7_ITEM "
cConsulta+= " AND SC7D.C7_RESIDUO<>'S'  AND SC7D.D_E_L_E_T_ = ' ' "
cConsulta+= " WHERE SC6I.C6_FILIAL  = '05' "
cConsulta+= " AND SC6I.C6_CLI = '033467'  "
cConsulta+= " AND SC6I.C6_LOJA = '06' "
//cConsulta+= " AND SC6I.C6_NUM = '007140' " // Retirar este tratamento. 
cConsulta+= " AND SC6I.D_E_L_E_T_ = ' ' " 
cConsulta+= " AND ( ( SC6I.C6_DATFAT >= '"+dDataf+"') OR ( SC6I.C6_QTDENT < SC6I.C6_QTDVEN ) ) "
cConsulta+= " AND SC6I.C6_BLQ=' '  "
 cConsulta+= " )  SC6IND  "
cConsulta+= " LEFT JOIN UDBP12.SD2010 SD2I ON SD2I.D2_FILIAL = SC6IND.FILIND AND SD2I.D2_PEDIDO = SC6IND.PED_IND AND SD2I.D2_ITEMPV = SC6IND.ITEM_IND AND SD2I.D_E_L_E_T_ = ' '  "
cConsulta+= " GROUP BY FILIND,PED_IND,ITEM_IND,QTDVEN_IND,QTDENT_IND,SALDO_ENT_IND,ENCER,SALDO_REC_DIS "

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cConsulta),cAlias,.T.,.T.)
DbSelectArea(cAlias)
nTotRegTMP := Contar(cAlias,"!Eof()")
(cAlias)->(DbGoTop())
ProcRegua(nTotRegTMP)
While ! (cAlias)->(Eof()) 
   IncProc(' Gravando dados na planilha CSV ')
	aRet1:={}
   aRet1:=BUSCAD1((cAlias)->PED_IND,(cAlias)->ITEM_IND,cEmp)
   
   _nDif:= ((cAlias)->SALDO_REC_DIS-((cAlias)->QTDFATQUANT-aRet1[1,2]))-(cAlias)->SALDO_ENT_IND
   iF _nDif > 0
   
      q:="'"+(cAlias)->FILIND+';';fwrite(z,q,len(q)) 
	   q:="'"+(cAlias)->PED_IND+';';fwrite(z,q,len(q)) 
	   q:="'"+(cAlias)->ITEM_IND+';';fwrite(z,q,len(q)) 
      q:=replace(alltrim(str((cAlias)->QTDVEN_IND,12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:=replace(alltrim(str((cAlias)->QTDENT_IND,12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:=replace(alltrim(str((cAlias)->SALDO_ENT_IND,12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:=replace(alltrim(str((cAlias)->SALDO_REC_DIS,12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:=replace(alltrim(str((cAlias)->QTDFATQUANT,12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:=replace(alltrim(str(aRet1[1,2],12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:=replace(alltrim(str(aRet1[1,3],12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:="'"+(cAlias)->ENCER+';';fwrite(z,q,len(q)) 
      
      q:=replace(alltrim(str(_nDif,12,2)),'.',',')+';';fwrite(z,q,len(q))  
      
      q:= chr(13)+chr(10);fwrite(z,q,len(q))
      lDif:=.T.
      
   ENDIF
   (cAlias)->(DBSKIP())
ENDDO


Fclose(z)
(cAlias)->( DbcloseArea())

IF lDif 
   cAssunto:='ERRO - Divergências Guararema - Saldos Pedidos Industria X Pc´s Distribuidora '
ELSE 
   cAssunto:='OK NÃO existem -Divergências Guararema - Saldos Pedido Industria X Pc´s Distribuidora '
ENDIF
_cMsg   :='Arquivo com as diferenças nas movimentações  PV´S industria x PC´S distribuidora'

cEmail1 := SuperGetMV("ST_MAILDIF",," ")

aadd(aFiles,'VERDIFGUA.CSV')

IF !Empty(cEmail1)
   U_STMAILTES(cEmail1,' ',cAssunto,_cMsg,aFiles,'\arquivos\')
ENDIF   
//XEMAIL(cAssunto,cMens,cEmail1,aFiles)

Return()





/*/{Protheus.doc} User Function VERDIF 
	Ver divergências entre pedidos Industria Manus x Distribuidora 
    @type  Function
    @author Antonio Moura
    @since 10/11/2022
////////////////////////////////////////////////////////////////////////////////////////////////////
/*/


User Function VERDIFMAN()

Local cAlias   :=""
Local cConsulta:=""
Local z:=""
Local q:=""
Local nTotRegTmp:=0
Local _cArquivo:=""
Local aRet1:={}
Local cDirTemp    := ""
Local aFiles:={}
Local lDif    :=.F.
Local cEmp:='03'
Private aItem:={}

Default dDataf:=DTOS(DATE()-30)


RpcClearEnv()
RpcSetType(3)
RpcSetEnv("11","01",,,"FAT")	


cDirTemp    := '\arquivos\'
_cArquivo:='VERDIFMAN.CSV'
_cArquivo:=cDirTemp+_cArquivo

AddItem()

cAlias   := GetNextAlias()
z := fcreate(_cArquivo)

If z <= 0
   MsgBox('Nao foi possível criar o arquivo!!! Revisar diretório de destino','Atenção','Info')
   Return()
ENDIF


 
 q:='FILIND;PED_IND;ITEM_IND;QTDVEN_IND;QTDENT_IND;SALDO_ENT_IND;SALDO_REC_DIS;QTD_FAT;D1_DIS;D1_SEMTES_DIS;ENCER;DIF'


fwrite(z,q,len(q))
q:= chr(13)+chr(10);fwrite(z,q,len(q))


//-- DISTRIBUIDORA X MANAUS 

cConsulta+= " SELECT FILIND,PED_IND,ITEM_IND,QTDVEN_IND,QTDENT_IND,SALDO_ENT_IND,SALDO_REC_DIS,ENCER ,SUM(SD2I.D2_QUANT) QTDFATQUANT "
cConsulta+= " FROM ( "
cConsulta+= " SELECT SC6I.C6_FILIAL FILIND, SC6I.C6_NUM PED_IND,SC6I.C6_ITEM ITEM_IND,SC6I.C6_QTDVEN QTDVEN_IND,SC6I.C6_QTDENT QTDENT_IND,SC6I.C6_QTDVEN-SC6I.C6_QTDENT SALDO_ENT_IND, "
cConsulta+= " SC7D.C7_ENCER ENCER, "
cConsulta+= " CASE WHEN SC7D.C7_ENCER<>'E' THEN ( SC7D.C7_QUANT-SC7D.C7_QUJE) ELSE 0 END SALDO_REC_DIS "
cConsulta+= " FROM UDBP12.SC6030 SC6I "
cConsulta+= " LEFT JOIN UDBD11.SC7110 SC7D ON SC7D.C7_FILIAL = '01'  AND SC7D.C7_FORNECE = '005866'  AND SC7D.C7_LOJA = '01' AND SC6I.C6_NUMPCOM=SC7D.C7_NUM AND SC6I.C6_ITEMPC=SC7D.C7_ITEM "
cConsulta+= " AND SC7D.C7_RESIDUO<>'S'  AND SC7D.D_E_L_E_T_ = ' ' "
cConsulta+= " WHERE SC6I.C6_FILIAL  = '01' "
cConsulta+= " AND SC6I.C6_CLI = '033467'  "
cConsulta+= " AND SC6I.C6_LOJA = '06' "
cConsulta+= " AND SC6I.D_E_L_E_T_ = ' ' " 
//cConsulta+= " AND SC6I.C6_NUM = '910800' " // Retirar este tratamento. 
cConsulta+= " AND ( ( SC6I.C6_DATFAT >= '"+dDataf+"') OR ( SC6I.C6_QTDENT < SC6I.C6_QTDVEN ) ) "
cConsulta+= " AND SC6I.C6_BLQ=' '  "
 cConsulta+= " )  SC6IND  "
cConsulta+= " LEFT JOIN UDBP12.SD2030 SD2I ON SD2I.D2_FILIAL = SC6IND.FILIND AND SD2I.D2_PEDIDO = SC6IND.PED_IND AND SD2I.D2_ITEMPV = SC6IND.ITEM_IND AND SD2I.D_E_L_E_T_ = ' '  "
cConsulta+= " GROUP BY FILIND,PED_IND,ITEM_IND,QTDVEN_IND,QTDENT_IND,SALDO_ENT_IND,SALDO_REC_DIS,ENCER "
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cConsulta),cAlias,.T.,.T.)
DbSelectArea(cAlias)
nTotRegTMP := Contar(cAlias,"!Eof()")
(cAlias)->(DbGoTop())
ProcRegua(nTotRegTMP)
While ! (cAlias)->(Eof()) 

   aRet1:={}
   aRet1:=BUSCAD1((cAlias)->PED_IND,(cAlias)->ITEM_IND,cEmp)

   
   _nDif:= ((cAlias)->SALDO_REC_DIS-((cAlias)->QTDFATQUANT-aRet1[1,2]))-(cAlias)->SALDO_ENT_IND
   iF _nDif > 0
      lDif:=.T. 
      IncProc(' Gravando dados na planilha CSV ')
	   q:="'"+(cAlias)->FILIND+';';fwrite(z,q,len(q)) 
	   q:="'"+(cAlias)->PED_IND+';';fwrite(z,q,len(q)) 
	   q:="'"+(cAlias)->ITEM_IND+';';fwrite(z,q,len(q)) 
 
      q:=replace(alltrim(str((cAlias)->QTDVEN_IND,12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:=replace(alltrim(str((cAlias)->QTDENT_IND,12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:=replace(alltrim(str((cAlias)->SALDO_ENT_IND,12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:=replace(alltrim(str((cAlias)->SALDO_REC_DIS,12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:=replace(alltrim(str((cAlias)->QTDFATQUANT,12,2)),'.',',')+';';fwrite(z,q,len(q))  

      q:=replace(alltrim(str(aRet1[1,2],12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:=replace(alltrim(str(aRet1[1,3],12,2)),'.',',')+';';fwrite(z,q,len(q))  
      q:="'"+(cAlias)->ENCER+';';fwrite(z,q,len(q)) 
      q:=replace(alltrim(str(_nDif,12,2)),'.',',')+';';fwrite(z,q,len(q))  

      q:= chr(13)+chr(10);fwrite(z,q,len(q))
  ENDIF
  (cAlias)->(DBSKIP())
ENDDO


Fclose(z)
(cAlias)->( DbcloseArea())


IF lDif 
   cAssunto:='ERRO - Divergências Manaus - Saldos Pedido Industria X Pc´s Distribuidora '
ELSE 
   cAssunto:='OK NÃO existem -Divergências Manaus - Saldos Pedidos Industria X Pc´s Distribuidora '
ENDIF
_cMsg   :='Arquivo com as diferenças nas movimentações  PV´S industria x PC´S distribuidora'

cEmail1 := SuperGetMV("ST_MAILDIF",," ")
aadd(aFiles,'VERDIFMAN.CSV')

IF !Empty(cEmail1)
   U_STMAILTES(cEmail1,' ',cAssunto,_cMsg,aFiles,'\arquivos\')
ENDIF   

Return()


STATIC FUNCTION BUSCAD1(PvInd,ItemInd,cEmp1) 

Local cAlias:=""
Local aRet  :={}
Local nPos:=0


cAlias := GetNextAlias()

cQuery := " SELECT SC6I.C6_QTDVEN QTDVENC6_IND,SC6I.C6_QTDENT QTDENTC6_IND,SD2I.D2_QUANT D2_IND,SD2I.D2_ITEM D2ITEM,SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_ITEM,SD1.D1_QUANT,SD1.D1_DOC,SD1.D1_PEDIDO ,SD2I.D2_ITEM ITEMD2 ,SD1.D1_TES TES "
cQuery += " ,SD1.D1_SERIE , SD2I.D2_SERIE,SUBSTR(SD1.D1_ITEM,3,2) SUBITEMD1 "
cQuery += " FROM  UDBP12.SC6"+cEmp1+"0 SC6I "
cQuery += " INNER JOIN UDBP12.SD2"+cEmp1+"0 SD2I ON SD2I.D2_FILIAL = SC6I.C6_FILIAL AND SD2I.D2_PEDIDO = SC6I.C6_NUM AND SD2I.D2_ITEMPV = SC6I.C6_ITEM AND SD2I.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN UDBD11.SD1110 SD1 ON SD1.D1_FILIAL = '01' AND SD1.D1_DOC  = SD2I.D2_DOC  AND SD1.D1_COD = SD2I.D2_COD AND SD1.D1_QUANT = SD2I.D2_QUANT  AND SD1.D_E_L_E_T_ = ' ' "
cQuery += " AND SD1.D_E_L_E_T_ = ' ' "
cQuery += " WHERE SC6I.C6_NUM  ='"+PvInd+"' "
cQuery += "   AND SC6I.C6_FILIAL = '05'  "
cQuery += "   AND SC6I.C6_ITEM ='"+ITemInd+"' "
cQuery += "   AND SC6I.D_E_L_E_T_ = ' ' "


DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
(cAlias)->(DBGOTOP())

IF (cAlias)->( ! Eof())
   AADD(aRet,{D2_IND,0,0})
   While (cAlias)->( ! Eof())
      nPos:= aScan(aItem,{|x| x[1] == ITEMD2})
      IF nPos<>0
         IF aItem[nPos,2]==D1_ITEM
            IF !Empty(TES)
               aRet[1,2]:=aRet[1,2]+D1_QUANT 
            ELSE 
               aRet[1,3]:=aRet[1,3]+D1_QUANT 
            ENDIF   
         ENDIF   
      ENDIF   
      (cAlias)->(DBSKIP())
   ENDDO
ELSE 
   AADD(aRet,{0,0,0})
ENDIF   

(cAlias)->( DbcloseArea())



Return(aRet)






Return()


Static Function AddItem()

//d2_item = 2 digitos 

aItem:={}

AADD(aItem,{'01','0001'})
AADD(aItem,{'02','0002'})
AADD(aItem,{'03','0003'})
AADD(aItem,{'04','0004'})
AADD(aItem,{'05','0005'})
AADD(aItem,{'06','0006'})
AADD(aItem,{'07','0007'})
AADD(aItem,{'08','0008'})
AADD(aItem,{'09','0009'})
AADD(aItem,{'10','0010'})
AADD(aItem,{'11','0011'})
AADD(aItem,{'12','0012'})
AADD(aItem,{'13','0013'})
AADD(aItem,{'14','0014'})
AADD(aItem,{'15','0015'})
AADD(aItem,{'16','0016'})
AADD(aItem,{'17','0017'})
AADD(aItem,{'18','0018'})
AADD(aItem,{'19','0019'})
AADD(aItem,{'20','0020'})
AADD(aItem,{'21','0021'})
AADD(aItem,{'22','0022'})
AADD(aItem,{'23','0023'})
AADD(aItem,{'24','0024'})
AADD(aItem,{'25','0025'})
AADD(aItem,{'26','0026'})
AADD(aItem,{'27','0027'})
AADD(aItem,{'28','0028'})
AADD(aItem,{'29','0029'})
AADD(aItem,{'30','0030'})
AADD(aItem,{'31','0031'})
AADD(aItem,{'32','0032'})
AADD(aItem,{'33','0033'})
AADD(aItem,{'34','0034'})
AADD(aItem,{'35','0035'})
AADD(aItem,{'36','0036'})
AADD(aItem,{'37','0037'})
AADD(aItem,{'38','0038'})
AADD(aItem,{'39','0039'})
AADD(aItem,{'40','0040'})
AADD(aItem,{'41','0041'})
AADD(aItem,{'42','0042'})
AADD(aItem,{'43','0043'})
AADD(aItem,{'44','0044'})
AADD(aItem,{'45','0045'})
AADD(aItem,{'46','0046'})
AADD(aItem,{'47','0047'})
AADD(aItem,{'48','0048'})
AADD(aItem,{'49','0049'})
AADD(aItem,{'50','0050'})
AADD(aItem,{'51','0051'})
AADD(aItem,{'52','0052'})
AADD(aItem,{'53','0053'})
AADD(aItem,{'54','0054'})
AADD(aItem,{'55','0055'})
AADD(aItem,{'56','0056'})
AADD(aItem,{'57','0057'})
AADD(aItem,{'58','0058'})
AADD(aItem,{'59','0059'})
AADD(aItem,{'60','0060'})
AADD(aItem,{'61','0061'})
AADD(aItem,{'62','0062'})
AADD(aItem,{'63','0063'})
AADD(aItem,{'64','0064'})
AADD(aItem,{'65','0065'})
AADD(aItem,{'66','0066'})
AADD(aItem,{'67','0067'})
AADD(aItem,{'68','0068'})
AADD(aItem,{'69','0069'})
AADD(aItem,{'70','0070'})
AADD(aItem,{'71','0071'})
AADD(aItem,{'72','0072'})
AADD(aItem,{'73','0073'})
AADD(aItem,{'74','0074'})
AADD(aItem,{'75','0075'})
AADD(aItem,{'76','0076'})
AADD(aItem,{'77','0077'})
AADD(aItem,{'78','0078'})
AADD(aItem,{'79','0079'})
AADD(aItem,{'80','0080'})
AADD(aItem,{'81','0081'})
AADD(aItem,{'82','0082'})
AADD(aItem,{'83','0083'})
AADD(aItem,{'84','0084'})
AADD(aItem,{'85','0085'})
AADD(aItem,{'86','0086'})
AADD(aItem,{'87','0087'})
AADD(aItem,{'88','0088'})
AADD(aItem,{'89','0089'})
AADD(aItem,{'90','0090'})
AADD(aItem,{'91','0091'})
AADD(aItem,{'92','0092'})
AADD(aItem,{'93','0093'})
AADD(aItem,{'94','0094'})
AADD(aItem,{'95','0095'})
AADD(aItem,{'96','0096'})
AADD(aItem,{'97','0097'})
AADD(aItem,{'98','0098'})
AADD(aItem,{'99','0099'})
AADD(aItem,{'9A','0100'})
AADD(aItem,{'9B','0101'})
AADD(aItem,{'9C','0102'})
AADD(aItem,{'9D','0103'})
AADD(aItem,{'9E','0104'})
AADD(aItem,{'9F','0105'})
AADD(aItem,{'9G','0106'})
AADD(aItem,{'9H','0107'})
AADD(aItem,{'9I','0108'})
AADD(aItem,{'9J','0109'})
AADD(aItem,{'9K','0110'})
AADD(aItem,{'9L','0111'})
AADD(aItem,{'9M','0112'})
AADD(aItem,{'9N','0113'})
AADD(aItem,{'9O','0114'})
AADD(aItem,{'9P','0115'})
AADD(aItem,{'9Q','0116'})
AADD(aItem,{'9R','0117'})
AADD(aItem,{'9S','0118'})
AADD(aItem,{'9T','0119'})
AADD(aItem,{'9U','0120'})
AADD(aItem,{'9V','0121'})
AADD(aItem,{'9W','0122'})
AADD(aItem,{'9X','0123'})
AADD(aItem,{'9Y','0124'})
AADD(aItem,{'9Z','0125'})
AADD(aItem,{'A0','0126'})
AADD(aItem,{'A1','0127'})
AADD(aItem,{'A2','0128'})
AADD(aItem,{'A3','0129'})
AADD(aItem,{'A4','0130'})
AADD(aItem,{'A5','0131'})
AADD(aItem,{'A6','0132'})
AADD(aItem,{'A7','0133'})
AADD(aItem,{'A8','0134'})
AADD(aItem,{'A9','0135'})
AADD(aItem,{'AA','0136'})
AADD(aItem,{'AB','0137'})
AADD(aItem,{'AC','0138'})
AADD(aItem,{'AD','0139'})
AADD(aItem,{'AE','0140'})
AADD(aItem,{'AF','0141'})
AADD(aItem,{'AG','0142'})
AADD(aItem,{'AH','0143'})
AADD(aItem,{'AI','0144'})
AADD(aItem,{'AJ','0145'})
AADD(aItem,{'AK','0146'})
AADD(aItem,{'AL','0147'})
AADD(aItem,{'AM','0148'})
AADD(aItem,{'AN','0149'})
AADD(aItem,{'AO','0150'})
AADD(aItem,{'AP','0151'})
AADD(aItem,{'AQ','0152'})
AADD(aItem,{'AR','0153'})
AADD(aItem,{'AS','0154'})
AADD(aItem,{'AT','0155'})
AADD(aItem,{'AU','0156'})
AADD(aItem,{'AV','0157'})
AADD(aItem,{'AW','0158'})
AADD(aItem,{'AX','0159'})
AADD(aItem,{'AY','0160'})
AADD(aItem,{'AZ','0161'})
AADD(aItem,{'B0','0162'})
AADD(aItem,{'B1','0163'})
AADD(aItem,{'B2','0164'})
AADD(aItem,{'B3','0165'})
AADD(aItem,{'B4','0166'})
AADD(aItem,{'B5','0167'})
AADD(aItem,{'B6','0168'})
AADD(aItem,{'B7','0169'})
AADD(aItem,{'B8','0170'})
AADD(aItem,{'B9','0171'})
AADD(aItem,{'BA','0172'})
AADD(aItem,{'BB','0173'})
AADD(aItem,{'BC','0174'})
AADD(aItem,{'BD','0175'})
AADD(aItem,{'BE','0176'})
AADD(aItem,{'BF','0177'})
AADD(aItem,{'BG','0178'})
AADD(aItem,{'BH','0179'})
AADD(aItem,{'BI','0180'})
AADD(aItem,{'BJ','0181'})
AADD(aItem,{'BK','0182'})
AADD(aItem,{'BL','0183'})
AADD(aItem,{'BM','0184'})
AADD(aItem,{'BN','0185'})
AADD(aItem,{'BO','0186'})
AADD(aItem,{'BP','0187'})
AADD(aItem,{'BQ','0188'})
AADD(aItem,{'BR','0189'})
AADD(aItem,{'BS','0190'})
AADD(aItem,{'BT','0191'})
AADD(aItem,{'BU','0192'})
AADD(aItem,{'BV','0193'})
AADD(aItem,{'BW','0194'})
AADD(aItem,{'BX','0195'})
AADD(aItem,{'BY','0196'})
AADD(aItem,{'BZ','0197'})
AADD(aItem,{'C0','0198'})
AADD(aItem,{'C1','0199'})
AADD(aItem,{'C2','0200'})
AADD(aItem,{'C3','0201'})
AADD(aItem,{'C4','0202'})
AADD(aItem,{'C5','0203'})
AADD(aItem,{'C6','0204'})
AADD(aItem,{'C7','0205'})
AADD(aItem,{'C8','0206'})
AADD(aItem,{'C9','0207'})
AADD(aItem,{'CA','0208'})
AADD(aItem,{'CB','0209'})
AADD(aItem,{'CC','0210'})
AADD(aItem,{'CD','0211'})
AADD(aItem,{'CE','0212'})
AADD(aItem,{'CF','0213'})
AADD(aItem,{'CG','0214'})
AADD(aItem,{'CH','0215'})
AADD(aItem,{'CI','0216'})
AADD(aItem,{'CJ','0217'})
AADD(aItem,{'CK','0218'})
AADD(aItem,{'CL','0219'})
AADD(aItem,{'CM','0220'})
AADD(aItem,{'CN','0221'})
AADD(aItem,{'CO','0222'})
AADD(aItem,{'CP','0223'})
AADD(aItem,{'CQ','0224'})
AADD(aItem,{'CR','0225'})
AADD(aItem,{'CS','0226'})
AADD(aItem,{'CT','0227'})
AADD(aItem,{'CU','0228'})
AADD(aItem,{'CV','0229'})
AADD(aItem,{'CW','0230'})
AADD(aItem,{'CX','0231'})
AADD(aItem,{'CY','0232'})
AADD(aItem,{'CZ','0233'})
AADD(aItem,{'D0','0234'})
AADD(aItem,{'D1','0235'})
AADD(aItem,{'D2','0236'})
AADD(aItem,{'D3','0237'})
AADD(aItem,{'D4','0238'})
AADD(aItem,{'D5','0239'})
AADD(aItem,{'D6','0240'})
AADD(aItem,{'D7','0241'})
AADD(aItem,{'D8','0242'})
AADD(aItem,{'D9','0243'})

Return()


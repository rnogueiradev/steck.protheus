#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

/*====================================================================================\
|Programa  | STREST11        | Autor | ANTONIO.CORDEIRO          | Data | 06/09/2023  |
|=====================================================================================|
|Descrição | ROTINA PARA CONSULTAR POSSIVEIS DATAS DE ENTREGA                         |
|=====================================================================================|
|Sintaxe   | 		                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSRESTFUL DtEntrega DESCRIPTION "Consultar Datas Entrega"

WSDATA _cProd    As String
WSDATA _cQuant   As String

WSMETHOD GET DESCRIPTION "Consultar Datas Entrega" WSSYNTAX "/html-protheus/rest"

END WSRESTFUL



/*====================================================================================\
|Programa  | DtEntrega       | Autor | ANTONIO.CORDEIRO          | Data | 27/08/2018  |
|=====================================================================================|
|Descrição | ROTINA POSSIVEIS DATAS DE ENTREGA      	                                |
|=====================================================================================|
|Sintaxe   | 		                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSMETHOD GET WSRECEIVE _cProd,_cQuant WSSERVICE DtEntrega

Local nSaldo  :=0
Local cProd   :=""
Local _nQuant :=0
Local cNum    :=""
Local cItem   :="XX"
Local aRetorno:={}
Local nx      :=0
Local dPrazoEnt:=CTOD('  /  /  ')
Local fr:=0
Local _nSldDisp:=0
Private _cEndereco:= ""

::SetContentType("text/html")

RpcClearEnv()
RpcSetType(3)
RpcSetEnv("11","01",,,"FAT")	

cProd   :=ALLTRIM(Self:_cProd)
_nQuant :=val(ALLTRIM(Self:_cQuant))

_cEndereco := GetMv("ST_WSPRT01",,"https://protheusportal.000webhostapp.com")

aRetorno:=U_STREST11(cProd,_nQuant)

IF ValType(aRetorno)=='A'
   IF LEN(aRetorno)>0
      cArqHtm:=ArqHtm(aRetorno,cProd)
      ::SetResponse(cArqHtm)
   ELSE 
	   ::SetResponse(" Datas não localizadas ")
	   Return .T.
   ENDIF
 
ELSE 
   ::SetResponse(" Datas não localizadas ")
   Return .T.
ENDIF

RETURN(.T.)



/*/{Protheus.doc} STREST11
Calcular os dias para entrega
@type function
@author Antonio Cordeiro. 
@since 06/09/23
@version Protheus
/*/

//User Function STREST11(cProd,nQuant,cCliente,cLoja)
User Function STREST11(cProd,nQuant)

Local aRet2:= {}
Local aRetorno:={}
Local cItem:='XX'
Local cArqHtm:=""

nSaldo   :=  u_versaldo(alltrim(cProd))
aRetorno:=U_atudtentre(nSaldo,cProd,nQuant,'999999',cItem) 
IF ValType(aRetorno)== "A" 
   IF LEN(aRetorno)<>0
      aSort(aRetorno,,,{|x,y| x[3]+dtos(x[1])< y[3]+dtos(y[1]) })
      aRet2:=aRetorno
   ENDIF      
ENDIF

RETURN(aRet2)



/*/{Protheus.doc} ArqHtm 
Monta HTML referente as datas de entrega. 
@type function
@author Antonio Cordeiro. 
@since 06/09/23
@version Protheus
/*/

Static Function ArqHtm(aRet1,cProd)

Local cMsg:=""
Local _cEndereco := GetMv("ST_WSPRT01",,"https://protheusportal.000webhostapp.com")
Local cProduto:=""


SB1->(DBSETORDER(1))
IF SB1->(DBSEEK(XFILIAL('SB1')+cProd))
   cProduto:=ALLTRIM(cProd)+' - '+ALLTRIM(SB1->B1_DESC)
ELSE 
   cProduto:=ALLTRIM(cProd)
ENDIF

IF LEN(aRet1)>0

   cMsg := "<HTML> "
   cMsg += "<HEAD> "
   cMsg += "<TITLE> "
   cMsg += " <img src='https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42' width='300' height='49'> </td> "
   cMsg += "</TITLE> "
   cMsg += "</HEAD> "
   cMsg += " <br> <br>"

   cMsg += " <table width='350' border='2'> "
   cMsg += " <tr> "
   cMsg += " <td><div align='center'><font face='Verdana' size='3'><B>Datas Previstas Recebimento</B></font></div></td> "
   cMsg += " </tr> "
   cMsg += " </table> "

   cMsg += " <table width='350' border='2'> "
   cMsg += " <tr> "
   cMsg += " <td><div align='center'><font face='Verdana' size='2'><B>Produto: "+cProduto+"</B></font></div></td> "
   cMsg += " </tr> "
   cMsg += " </table> "


   cMsg += " <table width='350' border='2' cellspacing='0' cellpadding='0'> "
   cMsg += "   <tr> "
   cMsg += "    <td><div align='center'><font face='Verdana' size='2'>Data</font></div></td> "
   cMsg += "    <td><div align='center'><font face='Verdana' size='2'>Quantidade</font></div></td> "
   cMsg += "    <td><div align='center'><font face='Verdana' size='2'>Origem</font></div></td> "
   cMsg += "   </tr> "

   FOR NX:=1 TO LEN(aRet1)
      cMsg += "   <tr> "
      cMsg += "    <td><div align='center'><font face='Verdana' size='3'>"+dtoc(aRet1[NX,1])+"</font></div></td> "
      cMsg += "    <td><div align='center'><font face='Verdana' size='3'>"+ALLTRIM(STR(aRet1[NX,2],8))+"</font></div></td> "
      IF aRet1[NX,3]=='1SD'
         cMsg += "    <td><div align='center'><font face='Verdana' size='3'>"+"Estoque Disponivel"+"</font></div></td> "
      ELSEIF aRet1[NX,3]=='2PO'
         cMsg += "    <td><div align='center'><font face='Verdana' size='3'>"+"Ped.Compra"+"</font></div></td> "
      ELSE 
         cMsg += "    <td><div align='center'><font face='Verdana' size='3'>"+"Lead Time"+"</font></div></td> "
      ENDIF
      cMsg += "   </tr> "
   NEXT 
   cMsg += " </table> "
   cMsg += " <br> <br> "
   cMsg += "</HTML> "

ENDIF


Return(cMsg)



/*/{Protheus.doc} 
Mostra dela com as disponibilidades. 
@type function
@author Antonio Cordeiro. 
@since 06/09/23
@version Protheus
/*/


USER FUNCTION TQUEBRA()


Local aSitua  := {}
Local oBTOK
Local oLbx
Local nLbx    := 1
Local aColun  := {05,20,50}
Local nx      :=0
Local cProduto:=""
Local nPosProd:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_PRODUTO"})
Local nPosQtd := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_QUANT"})
Private oOk   := LoadBitmap(GetResources(), "LBOK")
Private oNo   := LoadBitmap(GetResources(), "LBNO")
Static oDlgStatus

DEFINE FONT oBold   NAME "Arial" SIZE 0, -10 BOLD

cProd   :=alltrim(aCols[n,nPosProd])
_nQuant :=aCols[n,nPosQtd]

//cProd   :='CA4016A'
//_nQuant :=2000

SB1->(DBSETORDER(1))
IF SB1->(DBSEEK(XFILIAL('SB1')+cProd))
   cProduto:=ALLTRIM(cProd)+' - '+ALLTRIM(SB1->B1_DESC)
ELSE 
   cProduto:=ALLTRIM(cProd)
ENDIF

aSitua:=U_STREST11(cProd,_nQuant)

FOR NX:=1 TO LEN(aSitua)
   IF aSitua[NX,3]=='1SD'
      aSitua[NX,3]:='Estoque Disponível'
   ELSEIF aSitua[NX,3]=='2PO'
      aSitua[NX,3]:='Pedido Compra'
   ELSE 
      aSitua[NX,3]:='Lead Time'
   ENDIF
NEXT      


DEFINE MSDIALOG oDlgStatus TITLE "Datas Previstas Recebimento: " FROM 000, 000  TO 330, 450 COLORS 0, 16777215 PIXEL

	@ 005,005 SAY "Produto:" PIXEL OF oDlgStatus
	@ 004,030 MSGet cProduto  Size 180,10 FONT oBold COLOR CLR_HBLUE PIXEL OF oDlgStatus
	
   @ 020, 005 LISTBOX oLbx  VAR nLbx FIELDS Header "Data Entrega", "Quantidade","Origem" SIZE 200, 115 Of oDlgStatus PIXEL 
   oLbx:SetArray(aSitua)
	oLbx:bLine := {|| { DTOC(aSitua[oLbx:nAt,1]) , '  '+ALLTRIM(STR(aSitua[oLbx:nAt,2])), aSitua[oLbx:nAt,3] }}
	@ 140, 150 BUTTON oBTOK PROMPT "OK" ACTION (PROCESSA({|| oDlgStatus:End() }, "Filtrando itens...","Aguarde!",.F.), oDlgStatus:End()) SIZE 037, 012 OF oDlgStatus PIXEL


ACTIVATE MSDIALOG oDlgStatus CENTERED

RETURN(.T.)




/*/{Protheus.doc} 
Valida se tem varias datas 
@type function
@author Antonio Cordeiro. 
@since 10/09/23
@version Protheus
/*/

USER FUNCTION XVLDQUEBRA()

Local nPosProd:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_PRODUTO"  })
Local nPosQtd := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="UB_QUANT"  })
Local cRet    :='N'
Local aSitua  :={}

cProd   :=alltrim(aCols[n,nPosProd])
_nQuant :=aCols[n,nPosQtd]

aSitua:=U_STREST11(cProd,_nQuant)

IF LEN(aSitua) > 1 
   cRet :='S'
ENDIF 


Return(cRet)




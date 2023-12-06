#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

#DEFINE SnTipo      1
#DEFINE _CODPROD     1
#DEFINE A_QTDCAMPOS  3 	
#DEFINE _GRILLA      2 
#DEFINE _SHOW_LEYEND "OBROWSE:ALEGENDS[1][2]:VIEW()"
#DEFINE _MESES {"ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"}

#DEFINE _NCC         4


/*/{Protheus.doc} User Function STACO302
    (Detalles de Ventas por Periodo)

    @type  Function
    @author user
    @since 07/05/2021
    @version version
/*/

User Function STACO302()

Local cTitulo := "Descuentos Sell Out"

Private aRotina     := MenuDef()  
Private _aPosFields := {}
Private _aProds     := {}

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("ZD6")
oBrowse:SetDescription(cTitulo)
oBrowse:DisableDetails() 

oBrowse:AddLegend( "ZD6_STATUS=='P'", "WHITE",  "Pendiente") 
oBrowse:AddLegend( "ZD6_STATUS=='C'", "GREEN",  "Calculo Efectuado") 
oBrowse:AddLegend( "ZD6_STATUS=='F'", "RED",    "Finalizado (NCC)") 

oBrowse:Activate() 

Return()


//===================================================================================================================================
/*/{Protheus.doc} MenuDef
   Definición del menú de acciones
   
   @type    Static Function
   @author  Alejandro Perret
   @since   05/02/21
   @version 1.0
/*/
//===================================================================================================================================


Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar'              Action 'VIEWDEF.STACO302'     OPERATION 1 ACCESS 0
ADD OPTION aRotina Title 'Incluir'                 Action 'VIEWDEF.STACO302'     OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Eliminar'                Action 'U_STCO302I()'  	      OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Leyenda'                 Action _SHOW_LEYEND           OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Calcular Descuentos'     Action  'U_STCO302E()'        OPERATION 4 ACCESS 0


Return(aRotina) 

//===================================================================================================================================
/*/{Protheus.doc} ModelDef
   Definición del modelo de datos  
   
   @type    Static Function
   @author  Alejandro Perret
   @since   05/02/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function ModelDef()
Local oStruZD6 := FWFormStruct(1, 'ZD6')
Local oStruZD5 := FWFormStruct(1, 'ZD5')
Local oModel := MPFormModel():New("STCO302M") 

oModel:AddFields("ZD6MASTER", /*cOwner*/, oStruZD6) 
oModel:AddGrid("ZD5DETAIL", "ZD6MASTER", oStruZD5 )
oModel:SetRelation("ZD5DETAIL", {{"ZD5_FILIAL", "xFilial('ZD5')"}, { "ZD5_NUMPER", "ZD6_NUMPER" }, { "ZD5_CLIENT", "ZD6_CLIENT" }, { "ZD5_LOJA", "ZD6_LOJA" }}, ZD5->(IndexKey(1))) 

oModel:SetDescription('Descuentos Sell Out')
oModel:GetModel("ZD6MASTER"):SetDescription('Periodos de Descuentos')
oModel:GetModel("ZD5DETAIL"):SetDescription('Detalles de Ventas')
oModel:SetPrimaryKey({"ZD6_FILIAL", "ZD6_NUMPER", "ZD6_CLIENT", "ZD6_LOJA"})

oModel:AddCalc('STCO302M2', 'ZD6MASTER', 'ZD5DETAIL', 'ZD5_QUANT', 'ZD5__TOT01', 'SUM',,,'Cantidad Total')
oModel:AddCalc('STCO302M2', 'ZD6MASTER', 'ZD5DETAIL', 'ZD5_DESCTO', 'ZD5__TOT02', 'SUM',,,'Descuento Total')

Return(oModel)

//===================================================================================================================================
/*/{Protheus.doc} ViewDef
   Definición de la vista
    
   @type    Static Function
   @author  Alejandro Perret
   @since   05/02/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function ViewDef()
Local oModel   := FWLoadModel("STACO302")
Local oView    := FWFormView():New()
Local oStruZD6 := FWFormStruct(2, "ZD6")
Local oStruZD5 := FWFormStruct(2, "ZD5")

oView:SetModel(oModel) 
oView:AddField("VIEW_ZD6", oStruZD6, "ZD6MASTER")
oView:AddGrid("VIEW_ZD5" , oStruZD5, "ZD5DETAIL") 

oStr3:= FWCalcStruct( oModel:GetModel('STCO302M2') )
oView:AddField('CALC', oStr3, 'STCO302M2')

//oView:AddIncrementField("VIEW_ZD5", "ZD5_ITEM")
oView:AddUserButton("Importar CSV", "Importar", {|oView| CargaCsv()})
oView:AddUserButton("Importar Excel", "Importar", {|oView|  CExcel()})

oView:CreateHorizontalBox("ENCAB"  , 22)
oView:SetOwnerView("VIEW_ZD6", "ENCAB")


oView:CreateHorizontalBox("DETALLE", 70)
oView:SetOwnerView("VIEW_ZD5", "DETALLE")

oView:CreateHorizontalBox("TOTALES", 8)
oView:SetOwnerView('CALC','TOTALES')

Return(oView)


/*/{Protheus.doc} User Function STCO302C
	Funcion que sugiere el periodo de calculo de Descuentoss
	@type  Function
	@author user
	@since 10/05/2021
	@version version
/*/

User Function STCO302C() 
Local cRet 		:= ""
Local cAño 		:= ""
Local cMes 		:= ""
Local dPeriodo := FirstDay(dDatabase)
Local nX

For nX:= 1 to 4 
	dPeriodo := FirstDay(dPeriodo)-1   //
Next

For nX:= 1 to 6
	
	dPeriodo := LastDay(dPeriodo)+1
	cAño := CValToChar(Year(dPeriodo))
	cMes := PadL(Month(dPeriodo),2,"0")
	cRet += cAño + cMes + "=" + _MESES[Month(dPeriodo)] + " " + cAño + ";"  

Next
 
Return(cRet)
//==========================================================================//

/*/{Protheus.doc} User Function STCO302D
	Disparador de periodo en inicializador de encabezado
	@type  Function
	@author user
	@since 10/05/2021
	@version version
	/*/	    
User Function STCO302D()
Local dPer 		:= FirstDay(dDatabase)-1

Return(CValToChar(Year(dPer)) + PadL(Month(dPer),2,"0"))


//==========================================================================//

User Function ExPeriod(cNumPer, cClient, cLoja )

Local lExist := .T.
Local aArea := GetArea()

DbSelectArea("ZD6")
DbSetOrder(1)

If DbSeek(xFilial("ZD6") + cNumPer + cClient + cLoja)

	Help(NIL, NIL, "Periodo ya existente", NIL,; 
	"Ya existe un periodo informado para el cliente : " + cClient ,;
	1, 0, , , , , , {"Verifique los periodos existentes para este cliente y modifíquelos."})
	lExist := .F.

EndIf

RestArea(aArea)
Return(lExist)

//==========================================================================//


//==========================================================================//
/*/{Protheus.doc} CargaCsv
   Funcion para realizar la carga de un documento .csv y asociarlo al periodo de descuento
   @type  Static Function
   @author Nico
   @since 08/04/2021
   @version version
   @param param_name, param_type, param_descr
   @return return_var, return_type, return_description
   @example
   (examples)
   @see (links_or_references)
   /*/
Static Function CargaCsv()

Local cFile       := ""
Local nHandle     := 0
Local cLinha      := ""
Local cMsgError   := ""
Local lPrim       := .T.
Local aCampos     := {}
Local aDados      := {}
Local nNumLin     := 0
Local nAux        := 0
Local lRet        := .T.
Local nTamProd	   := TamSx3("B1_COD")[1]
Local cFilSB1	   := xFilial("SB1")
Local cCod        := 0
Local aItems      :={}
Local oModel      := FWModelActive() 
Local oGrid       := oModel:GetModel(oModel:GetModelIds()[_GRILLA]) //FWFormGridModel
Local nOperation  := oModel:GetOperation()
Local Msg         := ""
Local nX

oView := FwViewActive()
oView:AddIncrementField( 'VIEW_ZD5', 'ZD5_ITEM' )

If !Empty(M->ZD6_CLIENT)

   cFile := cGetFile( "Files CSV|*.csv", "Seleccionar Archivo CSV", 0, , .F., GETF_LOCALHARD, .T., .T.)

   nHandle := FT_FUSE(cFile)

   If nHandle = -1
      Return
   Endif

   FT_FGoTop()

   While !FT_FEOF()
      cLinha := FT_FREADLN()
      If lPrim
         aCampos := Separa(cLinha, ";", .T.)       
         lPrim   := .F.    
      Else  
         If !Empty(cLinha)      
            AADD(aDados, Separa(cLinha, ";", .T.))
         EndIf
      EndIf

      FT_FSKIP()
   End

   FT_FUSE()
   
   If !Empty(aDados) .And. oGrid:Length() > 1
      If MsgNoYes("Desea cargar un nuevo archivo?") .And. nOperation == 3
         oGrid:ClearData()
      EndIf  
   EndIf
   
   oGrid:SetNoInsertLine(.F.)
   oGrid:SetNoUpdateLine(.F.)
  
   For nX := 1 to Len(aDados)
      nNumLin ++
      If Len(aDados[nX]) < A_QTDCAMPOS 
         lRet := .F.
         cMsgError := "Línea: " + StrZero(nNumLin, 4) + ;
   		" - Estructura de registro incorrecta. Cantidad de campos menor a: " + CValToChar(A_QTDCAMPOS)
         Msg:= AutoGrLog(cMsgError + CRLF)
   	Else
         
   		aDados[nX][_CODPROD]:= PadR(aDados[nX][_CODPROD],nTamProd) 

         If !Empty(Posicione("SB1", 1, cFilSB1 + aDados[nX][_CODPROD], "B1_COD"))
            oGrid:AddLine()
         	FWFldPut('ZD5_PRODUC',  aDados[nX][_CODPROD])
         	FWFldPut('ZD5_QUANT',   Val(aDados[nX][2]))
         	FWFldPut('ZD5_FECHA',   CToD(aDados[nX][3]))
         Else
   			lRet := .F.
   			cMsgError := "Línea: " + StrZero(nNumLin, 4) + ;
   			" - No se encontró el Producto: '" + aDados[nX][_CODPROD] + "' en el maestro de productos (SB1)."
            Msg:= AutoGrLog(cMsgError + CRLF)
         EndIf


      EndIf
   Next

   oGrid:GoLine(1)
   oGrid:SetNoInsertLine()
   oGrid:SetNoUpdateLine()

   LogError(Msg, lRet)

Else
   
   MsgInfo("Debe rellenar el campo Cliente antes de la carga de un archivo CSV")

EndIf

Return()


//==========================================================================//

/*/{Protheus.doc} LogError
   (long_description)
   @type  Static Function
   @author Nico
   @since 14/04/2021
   @version version
   @param param_name, param_type, param_descr
   @return return_var, return_type, return_description
   @example
   (examples)
   @see (links_or_references)
   /*/
Static Function LogError(Msg, lRet)

If !lRet
	AutoGrLog( "Fecha Fin..........: " + Dtoc(MsDate()) )
	AutoGrLog( "Hora  Fin..........: " + Time() )

	cPath    := ""
	cFileLog := NomeAutoLog()

	If cFileLog <> ""
		nX := 1
		While .t.
			If File( Lower( Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
				nX++
				If nX == 999
					Exit
				EndIf
				Loop
			Else
				Exit
			EndIf
		EndDo
		__CopyFile( cPath + Alltrim( cFileLog ), Lower( Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
		MostraErro(cPath,cFileLog)
		FErase( cFileLog )
	Endif
EndIf

Return()



//==========================================================================//
/*/{Protheus.doc} CExcel
   (long_description)
   @type  Static Function
   @author Nico
   @since 08/04/2021
   @version version
   @param param_name, param_type, param_descr
   @return return_var, return_type, return_description
   @example
   (examples)
   @see (links_or_references)
   /*/
Static Function CExcel()

Local cFile       := ""
Local nHandle     := 0
Local cLinha      := ""
Local cMsgError   := ""
Local lPrim       := .T.
Local aCampos     := {}
Local aDados      := {}
Local nNumLin     := 0
Local nAux        := 0
Local lRet        := .T.
Local nTamProd	   := TamSx3("B1_COD")[1]
Local cFilSB1	   := xFilial("SB1")
Local cCod        := 0
Local aItems      :={}
Local oModel      := FWModelActive() 
Local oGrid       := oModel:GetModel(oModel:GetModelIds()[_GRILLA]) //FWFormGridModel
Local nOperation  := oModel:GetOperation()
Local Msg         := ""
Local nX

oView := FwViewActive()
oView:AddIncrementField( 'VIEW_ZD5', 'ZD5_ITEM' )

If !Empty(M->ZD6_CLIENT)

   cFile := cGetFile( "Files XLSX|*.xlsx", "Seleccionar Archivo CSV", 0, , .F., GETF_LOCALHARD, .T., .T.)

   nHandle := FT_FUSE(cFile)

   If nHandle = -1
      Return
   Endif

   aDados := RExcel(cFile)
   
   If !Empty(aDados) .And. oGrid:Length() > 1
      If MsgNoYes("Desea cargar un nuevo archivo?") .And. nOperation == 3
         oGrid:ClearData()
      EndIf  
   EndIf
   
   oGrid:SetNoInsertLine(.F.)
   oGrid:SetNoUpdateLine(.F.)
  
   For nX := 1 to Len(aDados)

      nNumLin ++

      If Len(aDados[nX]) < A_QTDCAMPOS 

         lRet := .F.
         cMsgError := "Línea: " + StrZero(nNumLin, 4) + ;
   		" - Estructura de registro incorrecta. Cantidad de campos menor a: " + CValToChar(A_QTDCAMPOS)
         Msg:= AutoGrLog(cMsgError + CRLF)

   	Else

   		aDados[nX][_CODPROD]:= PadR(aDados[nX][_CODPROD],nTamProd) 

         If !Empty(Posicione("SB1", 1, cFilSB1 + aDados[nX][_CODPROD], "B1_COD"))
            oGrid:AddLine()
         	FWFldPut('ZD5_PRODUC',  aDados[nX][_CODPROD])
         	FWFldPut('ZD5_QUANT',   aDados[nX][2])
         	FWFldPut('ZD5_FECHA',   aDados[nX][3])
         Else
   			lRet := .F.
   			cMsgError := "Línea: " + StrZero(nNumLin, 4) + ;
   			" - No se encontró el Producto: '" + aDados[nX][_CODPROD] + "' en el maestro de productos (SB1)."
            Msg:= AutoGrLog(cMsgError + CRLF)
         EndIf
      EndIf
   Next

   oGrid:GoLine(1)
   oGrid:SetNoInsertLine()
   oGrid:SetNoUpdateLine()

   LogError(Msg, lRet)

Else
   
   MsgInfo("Debe rellenar el campo Cliente antes de la carga de un archivo CSV")

EndIf

Return()

/*/{Protheus.doc} RExcel
   (long_description)
   @type  Function
   @author MicroSiga
   @since 10/05/2021
   @see (links_or_references)
   /*/
Static Function RExcel(cPath)

Local aTamLin
Local nContP,nContL,nContC
Local xValor
Local oExcel	:= YExcel():new(,cPath)
Local aDadosAux := {}
Local aDados    := {}


For nContP:=1 to oExcel:LenPlanAt()	//Ler as Planilhas
	oExcel:SetPlanAt(nContP)	//Informa qual a planilha atual

	aTamLin	:= oExcel:LinTam() 			//Linha inicio e fim da linha
	For nContL:=aTamLin[1]+1 to aTamLin[2]
		aTamCol	:= oExcel:ColTam(nContL)	 //Coluna inicio e fim
		If aTamCol[1]>0	//Se a linha tem algum valor
			For nContC:=aTamCol[1] to aTamCol[2]
				xValor := oExcel:GetValue(nContL,nContC)	//Conteúdo 
				If ValType(xValor) == "O"
					ConOut(oExcel:Ref(nContL,nContC)+"["+cValToChar(xValor:GetDate())+"]["+cValToChar(xValor:GetTime())+"]")
				Else
               If nContC =aTamCol[1] .AND. VALTYPE(xValor) != "C"
                  xValor := cValToChar(xValor)
               EndIf

               AADD(aDadosAux, xValor)

				EndIf
			Next
		EndIf

      AADD(aDados, aDadosAux)
      aDadosAux := {}
	Next
Next
oExcel:Close()

Return(aDados)





/*/{Protheus.doc} User Function STCO302E
   Funcion llamada desde el boton Calcular descuento que realiza validaciones y llama a la vista asociada.
   @type  Function
   @author Cesar Angeloff
   @since 12/05/2021
   @version version
/*/

User Function STCO302E()
Local cStatus := ""


Private _aDiscont  := {}
Private _lCalcDesc := .T.
Private _lFind     := .F.
Private _cCliGen   := AllTrim(GetMV("ST_CLIGEND", , ""))
Private _nDesc     := 0


If ZD6->ZD6_STATUS == 'P'  // Solo permite realizar calculo de descuento para un período que áun esta pendiente


   If !DescExist(ZD6->ZD6_CLIENT,ZD6->ZD6_LOJA)
       Help(NIL, NIL, "No se puede realizar esta acción", NIL,; 
      "El Cliente no posee un rango de descuento informado " , 1, 0, , , , , , {"Informe un porcentaje de descuento para el cliente o añada por parametro un codigo de Cliente Generico"})
   Else
      FWExecView("Calculo de Descuentos", 'VIEWDEF.STACO302', 4, , {|| .T. })
   EndIf

Else
   cStatus := ZD6->ZD6_STATUS

   If cStatus == 'C'
      cStatus := 'Calculo Efectuado'
   Else
      cStatus := 'Finalizado'
   EndIf
   
   Help(NIL, NIL, "No se puede realizar esta acción", NIL,; 
   "El estado actual es: " + cStatus, ;
	1, 0, , , , , , {"Solo está permitido la acción en Periodos Pendientes"})
EndIf

Return()


/*/{Protheus.doc} User Function STCO302F
   Efectua la búsqueda de precios en la ventas realizadas al cliente y luego aplica el descuento correspondiente

   @type  Function
   @author user
   @since 12/05/2021
   @version version
/*/

User Function STCO302F() 

Processa({|| CalcDesc()}, "Aguarde por favor...", "Efectuando cálculos de descuento...", .F.)

Return()


//===================================================================================================================================
/*/{Protheus.doc} CalcDesc
   Efectúa el cálculo de descuentos para un período obteniendo precios de compra FIFO.
   
   @type    Static Function
   @author  Alejandro Perret
   @since   12/05/21
   @version 1.0
/*/
//===================================================================================================================================

Static Function CalcDesc() 
Local aAreaZD6		:= ZD6->(GetArea())
Local aAreaZD5    := ZD5->(GetArea())
Local cQryTrb 	   := GetNextAlias()
Local cQry1 	   := ""
Local cCliente    := " "
Local cLoja       := " "
Local cProduc     := " "
Local oModel      := FWModelActive() 
Local oGrid       := oModel:GetModel("ZD5DETAIL") //FWFormGridModel
Local nX          := 0
Local nQtde       := 0
Local nDescUnit   := 0
Local nPrecio     := 0
Local nMoeda      := (GetMV("ST_MOSELL", , 2)) 
Local cGruPro     := ""
Local nExample    := 0

Local nExample2    := 0

Private _nPosIt      := GdFieldPos("ZD5_ITEM",     oGrid:aHeader)
Private _nPosPro     := GdFieldPos("ZD5_PRODUC",   oGrid:aHeader)
Private _nPosQtd     := GdFieldPos("ZD5_QUANT",    oGrid:aHeader)
Private _nPosCli     := GdFieldPos("ZD5_CLIENT",   oGrid:aHeader)
Private _nPosLoj     := GdFieldPos("ZD5_LOJA",     oGrid:aHeader) //buscar definir estas variables de posiciones como provadas, para usarlas adentro de asignarprecio
Private _nPosPrc     := GdFieldPos("ZD5_PRCUNI",   oGrid:aHeader) 
Private _nPosFec     := GdFieldPos("ZD5_FECHA",   oGrid:aHeader)
Private _aGridAux    := AClone(oGrid:GetData())

Private _cA1Tabel    := ""
Private _cA1GrVen    := ""
Private _nPerdes     := 0

cCliente := _aGridAux[1][1][1][_nPosCli]
cLoja    := _aGridAux[1][1][1][_nPosLoj]
_cA1Tabel    := Posicione("SA1", 1, xFilial("SA1") + cCliente + cLoja, "A1_TABELA")
_cA1GrVen    := Posicione("SA1", 1, xFilial("SA1") + cCliente + cLoja, "A1_GRPVEN")

_aProds              :={}


   ProcRegua(oGrid:Length())  
   


   For nX := 1 to Len(_aGridAux)

      IncProc()   
      cProduc  := _aGridAux[nX][1][1][_nPosPro]
      cGruPro  := Posicione("SB1", 1, xFilial("SB1") + cProduc, "B1_GRUPO")
      cCliente := _aGridAux[nX][1][1][_nPosCli]
      cLoja    := _aGridAux[nX][1][1][_nPosLoj]
      nQtde    := _aGridAux[nX][1][1][_nPosQtd]


      cQry1 := "SELECT COALESCE(Q.ACP_PERDES, R.ACP_PERDES, P.ACP_PERDES, 0) AS PERDES  "
      cQry1 += "FROM " + RetSqlName("ACY") + " Y "
      cQry1 += "INNER JOIN " + RetSqlName("ACO") + " O ON ACO_GRPVEN=ACY_GRPVEN AND O.D_E_L_E_T_ = ' ' "

      cQry1 += "LEFT JOIN " + RetSqlName("ACP") + " Q ON Q.ACP_CODREG=ACO_CODREG AND Q.ACP_CODPRO= '" + cProduc + "' AND Q.D_E_L_E_T_ = ' ' "
      cQry1 += "LEFT JOIN " + RetSqlName("ACP") + " R ON R.ACP_CODREG=ACO_CODREG AND R.ACP_GRUPO='" + cGruPro + "'  AND R.D_E_L_E_T_ = ' ' "
      cQry1 += "LEFT JOIN " + RetSqlName("ACP") + " P ON P.ACP_CODREG=ACO_CODREG AND P.ACP_GRUPO=' '  AND P.ACP_CODPRO= ' ' AND P.D_E_L_E_T_ = ' ' "
      
      cQry1 += "WHERE ACY_FILIAL = '" + xFilial("ACY") + "' "
      cQry1 += "AND ACY_GRPVEN =  '" + _cA1GrVen + "' "
      cQry1 += "AND Y.D_E_L_E_T_ = ' ' "


      DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry1), cQryTrb, .F., .T.)

      DbSelectArea(cQryTrb)
      DbGoTop()

      M->C5_CLIENTE := cCliente
      _nPerdes := U_STGAP01() // Con esta funcin se obtiene el porcentaje de descuento standarizado para el producto (usado tambien en pedido de ventas)

      oGrid:GoLine(nX)

      nPrecio := MaTabPrVen(_cA1Tabel,cProduc,nQtde,cCliente,cLoja,nMoeda)
      nDescUnit := ROUND(((nPrecio * _nPerdes) / 100), 2)
      nPrecio -= nDescUnit 
      FWFldPut("ZD5_PRCUNI", nPrecio)

      nDescUnit := Discont(nPrecio,nQtde)

      FWFldPut("ZD5_DESC",   nDescUnit)    
      FWFldPut("ZD5_DESCTO", nDescUnit*nQtde) 

      (cQryTrb)->(DbCloseArea())
   Next

   oGrid:GoLine(1)
   oView := FwViewActive()
   oView:Refresh()

   RestArea(aAreaZD5)
   RestArea(aAreaZD6)

Return()


//==========================================================================//

/*/{Protheus.doc} DescExist
   Funcion que verifica la existencia de un descuento existente para el cliente solicitado
   @type  Static Function
   @author Cesar Angeloff
   @since 18/05/2021
   @version version
/*/

Static Function DescExist(cCliente,cLoja)

Local aArea    := GetArea()
Local aAreaZD7 := GetArea("ZD7")
Local cQryTrb  := GetNextAlias()
Local cQry 	   := ""
Local lRet     := .F.

cQry := "SELECT ZD7_CDESD AS DESDE, ZD7_CHAST AS HASTA, ZD7_DESCU AS DESCUENTO "
cQry += "FROM " + RetSqlName("ZD7") + " "
cQry += "WHERE ZD7_FILIAL = '" + xFilial("ZD7") + "' "
cQry += "AND ZD7_CLIENT = '" + cCliente + "' "
cQry += "AND ZD7_LOJA = '" + cLoja + "' "
cQry += "AND D_E_L_E_T_ = ' ' "

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), cQryTrb, .F., .T.)

DbSelectArea(cQryTrb)
DbGoTop()

If !Eof()
   lRet := .T.
   _lFind := .T.
   While !Eof()
      Aadd(_aDiscont, {DESDE, HASTA, DESCUENTO})
      DbSkip()
   EndDo
Else
   DbSelectArea("ZD7")
   DbSetOrder(1)
   DbGoTop()

   If DbSeek(xFilial("ZD7") + _cCliGen)
      _lFind  := .F.
      lRet := .T.
   Else
      lRet := .F.
   EndIf
EndIf

RestArea(aAreaZD7)
RestArea(aArea)
Return(lRet)
//==========================================================================//

/*/{Protheus.doc} Discont
   Funcion que calcula el valor numerico del descuento , buscando su correspondencia en la tabla de rango descuentos
   @type  Static Function
   @author Cesar Angeloff
   @since 18/05/2021
   @version version
/*/

Static Function Discont(nPrecio,nQtd) 

Local aArea    := GetArea()
Local nRet     := 0
Local nX       := 0

If _lFind 
   For nX:= 1 To Len(_aDiscont)
      If (_aDiscont[nX][1] < nQtd) .And. (_aDiscont[nX][2] > nQtd)
         _nDesc := _aDiscont[nX][3]
      EndIf   
   Next
Else
   _nDesc := Posicione("ZD7", 1, xFilial("ZD7") + _cCliGen , "ZD7_DESCU")
EndIf

nRet := ROUND(((nPrecio * _nDesc) / 100), 2)

RestArea(aArea)
Return(nRet)




/*/{Protheus.doc} User Function STCO302G
   funcion que realiza la grabacion para la tabla SD2 y actualizacion del estado del periodo (Calculo efectuado)
   @type  Function
   @author Cesar Angeloff
   @since 21/05/2021
   @version version

/*/

User Function STCO302G()

Local aArea    := GetArea()

Reclock("ZD6",.F.)
   ZD6_STATUS := 'C'
MsUnlock()


RestArea(aArea)

Return 

/*/{Protheus.doc} User Function STCO302I
   Funcion de usuario para eliminar un periodo de descuento
   @type  Function
   @author Cesar Angeloff
   @since 21/05/2021
   @version version
/*/
User Function STCO302I()
   Private _lDeleta  := .T.
   Private _lExist   := .F.

   If ZD6->ZD6_STATUS == "F"
      Help(NIL, NIL, "Periodo Ya Asociado con NCC", NIL,; 
      "No se permite eliminar un periodo que ya posee una NCC asociada" ,;
      1, 0, , , , , , {"Solo puede eliminar periodos con estado Pendiente o Calculo Efectuado "})
   Else
      IF ZD6->ZD6_STATUS == "C"
         _lExist := .T.
      EndIf
      FWExecView("Calculo de Descuentos", 'VIEWDEF.STACO302', 5, , {|| .T. })
   EndIf
Return 


//==========================================================================//
/*/{Protheus.doc} User Function STCO302H
   Pantalla para visualizar y vincular Solicitudes de devolución en la NCC
   @type  Function
   @author Nico Vallejos
   @since 21/05/2021
   @version version
/*/
//==========================================================================//
User Function STCO302H()

Local oMS 	
Local cTit			:= "Consulta Descuentos Calculados"
Local cQry1 		:= ""
Local lMark2		:= .F.
Local cCampoRet	:= "ZD6_NUMPER"
Local nAncho		:= 550
Local nAlto			:= 600
Local lUnoSolo		:= .T.
Local aCposDev		:= {} 
Local aIndBusq		:= {} //El primer 'indice' ordena los resultados al inicio
Local nScrollTp	:= 0
Local aEstruEsp	:= {}
Local aSolicitud	:= {}

Private _cTESImp:= ""

If ValidIni()

   cQry1 := "SELECT ZD6_NUMPER, ZD6_CLIENT, ZD6_LOJA, ZD6_FECHA " 
   cQry1 += "FROM " + RetSqlName("ZD6") + " "
   cQry1 += "WHERE ZD6_FILIAL = '" + xFilial("ZD6") + "' "
   cQry1 += "AND ZD6_STATUS = 'C' "
   cQry1 += "AND ZD6_CLIENT = '" + M->F1_FORNECE + "' "
   cQry1 += "AND ZD6_LOJA = '" + M->F1_LOJA + "' "
   cQry1 += "AND D_E_L_E_T_ = ' ' "

	oMS := MultiSel():New(cTit,cQry1,lMark2,cCampoRet,nAlto,nAncho,,,lUnoSolo, aCposDev, aIndBusq, nScrollTp, aEstruEsp)
	aSolicitud := oMS:Show() 

	If !Empty(aSolicitud) 
		Processa({|| CargaItems(aSolicitud)}, "Aguarde por favor", "Cargando ítems...", .F.)
	EndIf

EndIf

Return()


//===================================================================================================================================
/*/{Protheus.doc} ValidIni
    Validaciones iniciales.

    @type  Static Function
    @author Alejandro Perret
    @since 22/01/2020
    @version 1.0
/*/
//===================================================================================================================================

Static Function ValidIni()
Local lRet 		:= .T.
Local cMsgCli	:= "Informe Cliente y Tienda para poder continuar."

If Empty(M->F1_FORNECE) .Or. Empty(M->F1_LOJA)
	lRet := .F.
	MsgInfo(cMsgCli)
EndIf

Return(lRet)


//===================================================================================================================================
/*/{Protheus.doc} CargaItems
    Carga los items en el documento.

    @type  Static Function
    @author Alejandro Perret
    @since 22/01/2020
    @version 1.0
/*/
//===================================================================================================================================

Static Function CargaItems(aSolDev)
Local aArea		:= GetArea()
Local aAreaSF4	:= SF4->(GetArea())
Local cQryTrb 	:= GetNextAlias()
Local cQry1 	:= ""
Local nTot		:= 0
Local cLotes	:= ""
Local cFilSF4	:= xFilial("SF4")
Local aLinTemp	:= {}
Local cItem		:= ""
Local cCF		:= ""
Local aItIni	:= {}
Local cTesEnt	:= AllTrim(GetMV("ST_TESELL", , "001"))
Local cPeriodo := aSolDev[1][1]
Local nMoeda      := (GetMV("ST_MOSELL", , 2))
Local nMoeFat     := M->F1_MOEDA
Local nTotal      := 0

Default aSolDev := {}

DbSelectArea("ZD5")
DbSetOrder(1)

cQry1 := "SELECT ZD5_PRODUC, ZD5_CLIENT, ZD5_LOJA, SUM( ZD5_DESC * ZD5_QUANT) AS TOTAL, B1_DESC, B1_SEGUM , B1_UM , B1_CONTA "	
cQry1 += "FROM " + RetSqlName("ZD5") + " ZD5 " 
cQry1 += "	INNER JOIN " + RetSqlName("SB1") + " B1 ON B1_FILIAL = '" + xFilial("SB1") + "' AND ZD5_PRODUC = B1_COD AND B1.D_E_L_E_T_ = ' ' "
cQry1 += "WHERE ZD5_FILIAL = '" + xFilial("ZD5") + "' "
cQry1 += "AND ZD5_CLIENT = '" + M->F1_FORNECE + "' "
cQry1 += "AND ZD5_LOJA = '" + M->F1_LOJA + "' "
cQry1 += "AND B1_FILIAL = '" + xFilial("SB1") + "' "
cQry1 += "AND ZD5_NUMPER = " + cPeriodo + " "
cQry1 += "AND ZD5.D_E_L_E_T_ = ' ' "
cQry1 += "AND B1.D_E_L_E_T_ = ' ' "
cQry1 += "GROUP BY ZD5_PRODUC, ZD5_CLIENT, ZD5_LOJA, B1_DESC, B1_SEGUM , B1_UM , B1_CONTA "  


DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry1), cQryTrb, .F., .T.)

DbSelectArea(cQryTrb)
Count To nTot
ProcRegua(nTot)  
DbGoTop()

If !(cQryTrb)->(Eof())

   cItem := StrZero(0, TamSx3('D1_ITEM')[1])
   nHItem	:= GdFieldPos("D1_ITEM")			
   nHProd   := GdFieldPos("D1_COD")			
   nHDscr   := GdFieldPos("D1_XDESCRI")   
   nHUniM   := GdFieldPos("D1_UM")        
   nHSeUM   := GdFieldPos("D1_SEGUM")     
   nHCant   := GdFieldPos("D1_QUANT")
   nHPrec   := GdFieldPos("D1_VUNIT")
   nHTot_   := GdFieldPos("D1_TOTAL")
   nHTES_   := GdFieldPos("D1_TES")
   nHCF__   := GdFieldPos("D1_CF")
   nHLoca	:= GdFieldPos("D1_LOCAL")			
   nPrEnt   := GdFieldPos("D1_PROVENT")
   nHCtac	:= GdFieldPos("D1_CONTA")	               
   
   aCols := {}
   oGetDados:Enable()  // Vuelve a habilitar la grilla para poder agregar los ítems de la Solicitud.
   oGetDados:AddLine(.F., .F.)
   aItIni := AClone(aCols[1])
   aCols := {}
   oGetDados:obrowse:refresh()
   MaFisClear()
      
   While !(cQryTrb)->(Eof())
      
      SF4->(DbSeek(cFilSF4 + cTesEnt))
      cCF := SF4->F4_CF   
      
      cItem := Soma1(cItem)
      aLinTemp := AClone(aItIni)

      nTotal :=  xMoeda((cQryTrb)->TOTAL,nMoeda,nMoeFat,dDatabase,2)  
      Iif(nHItem > 0, aLinTemp[nHItem] := cItem								   ,)
      Iif(nHProd > 0, aLinTemp[nHProd] := (cQryTrb)->ZD5_PRODUC			,)
      Iif(nHSeUM > 0, aLinTemp[nHSeUM] := (cQryTrb)->B1_SEGUM				,) 
      Iif(nHDscr > 0, aLinTemp[nHDscr] := (cQryTrb)->B1_DESC				,)
      Iif(nHUniM > 0, aLinTemp[nHUniM] := (cQryTrb)->B1_UM					,)
      Iif(nHCant > 0, aLinTemp[nHCant] := 1			                  	,)
      Iif(nHPrec > 0, aLinTemp[nHPrec] := nTotal		      	         ,)
      Iif(nHTot_ > 0, aLinTemp[nHTot_] := nTotal		                  ,)
      Iif(nHTES_ > 0, aLinTemp[nHTES_] := cTesEnt				            ,)
      Iif(nHCF__ > 0, aLinTemp[nHCF__] := cCF									,)
      Iif(nHLoca > 0, aLinTemp[nHLoca] := (cQryTrb)->ZD5_LOJA				,)
      Iif(nPrEnt > 0, aLinTemp[nPrEnt] := M->F1_PROVENT         			,) 
      Iif(nHCtac > 0, aLinTemp[nHCtac] := (cQryTrb)->B1_CONTA				,)


      Aadd(aCols, aLinTemp)
      MaColsToFis(aHeader,aCols,Len(aCols),"MT100",.T.)
      
      IncProc()
      (cQryTrb)->(DbSkip())
   EndDo
   //MaColsToFis(aHeader,aCols,,"MT100",.T.)

   Eval(bDoRefresh) //Atualiza o folder financeiro.
   Eval(bListRefresh)
   ModxAtuObj()
   
   oGetDados:obrowse:nAt := 1
   oGetDados:obrowse:refresh()
   oGetDados:Refresh()
   AtuLoadQt(.T.)
   oGetDados:Disable()  // Deshabilita la grilla para impedir que se modifiquen o agreguen ítems luego de vinculada con una Solicitud.

   

  
   
Else	
   MsgInfo("No se encontraron items para la solicitud seleccionada.")
EndIf


(cQryTrb)->(DbCloseArea())
RestArea(aAreaSF4)
RestArea(aArea)

 M->F1_XSELOUT := cPeriodo //-Luego de cargar los ítems, cargar en M->F1_XSELOUT el período seleccionado.

Return()



//===================================================================================================================================
/*/{Protheus.doc} STCO302S
Actualiza el estado de SELL OUT (ZD6) vinculada la NCC. (Inclu)
   Usada en LOCXPE08 
   
   @type    User Function
   @author  Lucas Frias
   @since   02/05/28
   @version 1.0
/*/
//===================================================================================================================================

User Function STCO302S(cEstado, cSerie, cDoc, cPeriodo)

Local nS       := 0
Local nPosNSol := 0
Default cSerie := ""
Default cDoc   := ""

    If !Empty(cPeriodo)
      DbSelectArea("ZD6")
      DbSetOrder(1) //ZD6 (ZD6_FILIAL+ZD6_NUMPER+ZD6_CLIENT+ZD6_LOJA) 
      If DbSeek(xFilial("ZD6") + cPeriodo + SF1->F1_FORNECE + SF1->F1_LOJA)
         Reclock("ZD6", .F.)
            ZD6_STATUS := cEstado
            ZD6_SERNCC := cSerie
            ZD6_NUMNCC := cDoc
         MsUnlock()
      EndIf
   EndIf



 Return()


//===================================================================================================================================
/*/{Protheus.doc} STCO302T
   //Actualiza el estado Periodo de venta SELL OUT (ZD6) inculada a la NCC. (Eliminación)
   Usada en LOCXPE29
   @type    User Function
   @author  Lucas Frias
   @since   02/05/28
   @version 1.0
/*/
//===================================================================================================================================

User Function STCO302T(cEstado, cSerie, cDoc, cPeriodo )

Local nS       := 0
Local nPosNSol := 0
Default cSerie := ""
Default cDoc   := ""

    If !Empty(cPeriodo)
      DbSelectArea("ZD6")
      DbSetOrder(1) //ZD6 (ZD6_FILIAL+ZD6_NUMPER+ZD6_CLIENT+ZD6_LOJA) 
      If DbSeek(xFilial("ZD6") + cPeriodo + SF1->F1_FORNECE + SF1->F1_LOJA)
         Reclock("ZD6", .F.)
            ZD6_STATUS := cEstado
            ZD6_SERNCC := cSerie
            ZD6_NUMNCC := cDoc
         MsUnlock()
      EndIf
   EndIf

Return()

//===================================================================================================================================
/*/{Protheus.doc} STCO302U
   Elimina los items de la grilla al cargar un nuevo cliente en la NCC si esta tenía ítems relacionados a una solicitud de devolución 
   de un cliente que no es el actual. También habilita la grilla en estos casos, porque podria haberse deshabilitado al vincular una 
   devolución. 
   (ejecutada desde gatillos en F1_FORNECE Y F1_LOJA)
   
   @type    User Function
   @author  Alejandro Perret
   @since   30/03/21
   @version 1.0
/*/
//===================================================================================================================================

User Function STCO302U()
		
If (aCfgNF[SnTipo] == _NCC) .And. !Empty(M->F1_FORNECE) .And. !Empty(M->F1_LOJA) .And. !Empty(M->F1_XSELOUT)// Nota de crédito cliente (NCC)
   
   M->F1_XSELOUT := ""
   aCols := {}
   oGetDados:Enable()   
   oGetDados:AddLine(.F., .F.)
   oGetDados:oBrowse:Refresh()
   MaFisClear()

EndIf

Return()





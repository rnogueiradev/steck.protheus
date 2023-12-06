#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OBTNIT   ºAutor  ³EJM                       º Data ³  2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion usadas para Contabilizar las Orden de Pago /proveedorº±±
±±º          ³ LP: 570 /571 - obteniendo el NIT segun Codigo prov +Tienda  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Colombia\                                         		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ObCtNIT(cProve,cTienda,nOpc,cPref,cNum,cParc,cTipo)
Local aArea:= GetArea()
Local cTemp 
Local cQry 		:= GetNextAlias()
Local cQry1 	:= GetNextAlias()
Local cSQL
Local cSQL1

 
IF nOpc=='CTA'
  IF cPref$'INT|AMT|SEG'

    cSQL1 :=" SELECT E2_CREDIT FROM " + RETSQLNAME("SE2") +" SE2 "
    cSQL1 +=" WHERE E2_FORNECE='"+cProve+"' "
    cSQL1 +=" AND E2_LOJA ='"+cTienda+"' "
    cSQL1 +=" AND E2_TIPO ='"+cTipo+"' "
    cSQL1 +=" AND E2_PARCELA ='"+cParc+"' "
    cSQL1 +=" AND E2_PREFIXO ='"+cPref+"' "
    cSQL1 +=" AND E2_NUM ='"+cNum+"' "
    cSQL1 +=" AND SE2.D_E_L_E_T_=' ' "
    

    If Select(cQry1) > 0  //Abierto ? cerrar..
        dbSelectArea(cQry1)
        dbCloseArea()
    EndIf

    dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL1), cQry1 , .F., .T.)
    DbSelectArea(cQry1)
    dbGoTop()
    If !(cQry1)->(Eof())
        cTemp	:=	(cQry1)->E2_CREDIT
    EndIf
    (cQry1)->(dbCloseArea())

  ELSE
    cSQL :=" SELECT A2_CONTA FROM " + RETSQLNAME("SA2") +" SA2 "
    cSQL +=" WHERE A2_COD='"+cProve+"' "
    cSQL +=" AND A2_LOJA ='"+cTienda+"' "
    cSQL +=" AND SA2.D_E_L_E_T_=' ' "
    

    If Select(cQry) > 0  //Abierto ? cerrar..
        dbSelectArea(cQry)
        dbCloseArea()
    EndIf

    dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL), cQry , .F., .T.)
    DbSelectArea(cQry)
    dbGoTop()
    If !(cQry)->(Eof())
        cTemp	:=	(cQry)->A2_CONTA
    EndIf
    (cQry)->(dbCloseArea())
  ENDIF                                                                                                                                                                                   
ELSEIF nOpc=='NIT'
    cTemp := cProve
Endif

RestArea(aArea)


Return (cTemp)

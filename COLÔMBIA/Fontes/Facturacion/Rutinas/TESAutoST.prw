/*/{Protheus.doc} TESAutoST
Este rutina se agrega en X3_Valid para C6_PRODUTO Y CJ_PRODUTO
@type function
@version  
@author AxelDiaz
@since 25/5/2021
@return return_type, return_description
/*/
User Function TESAutoST()
	/* Descripcion de Rutinas:
	 *
	 * MATA410	-> Pedido de Venta/Salida
	 * MATA467N	-> Factura de Venta/Salida
	 * MATA462N	-> Remision de Venta/Salida
	 * MATA465N	-> Nota de Debito/Credito Clientes (Ventas)
	 * MATA121	-> Pedido de Compra/Entrada
	 * MATA101N	-> Factura de Compra/Entrada
	 * MATA102N	-> Remision de Compra/Entrada
	 * MATA466N	-> Nota de Debito/Credito Proveedores (Compras)
	 *
	 */
    Local cCfEquiv := SuperGetMV("ST_CODFISC",.T., "{{ '601' , '601SB' }, { '101' , '101SB' } }" )
    Local cTSEqB2B := SuperGetMV("ST_TESB2B" ,.T., "{{ '501' , '650'   }, { '   ' , '650'   } }" )
    Local cTSEqEXP := SuperGetMV("ST_TESEXP" ,.T., "{{ '501' , '650'   }, { '   ' , '650'   } }" )
    Local cTSEqOBS := SuperGetMV("ST_TESOBS" ,.T., "{{ '501' , '652'   }, { '   ' , '652'   } }" )
    Local cBodgEXP := SuperGetMV("ST_BODGEX" ,.T., "01" )
    Local cBodgNAC := SuperGetMV("ST_BODGNC" ,.T., "03" )

    Local cFunName := FunName()
    Local aCfEquiv := &(" "+cCfEquiv+" ")
    Local aTSEqAll := {}
    Local nX       := 0
    Local nRecno   := 0
    Local nPosTes  := 0
    Local nPosAlm  := 0
    Local nPosCF   := 0
    Local cCFa     := ''
    Local cCFb     := '' 

	If cFunName == 'MATA410' // Si se accede desde la rutina Pedido de Venta/Salida
        IF EMPTY(C5_FECENT)
            MSGINFO( "Digite la fecha de entrega antes de diligenciar los productos", "Campo fecha entrega vacio" )
            Return .F.
        ENDIF
        IF EMPTY(C5_NATUREZ)
            MSGINFO( "Digite la Modalidad de la operación antes de diligenciar los productos", "Campo Modalidad entrega vacio" )  
            Return .F.
        ENDIF
        IF EMPTY(C5_XTPED)
            MSGINFO( "Seleccione el tipo de Pedido (Exportación, Nacional, BtoB, Obsequio) antes de diligenciar los productos", "Campo Tipo Pedido entrega vacio" )  
            Return .F.
        ELSE
            IF C5_XTPED=='B' 
                IF EMPTY(C5_XFORNEC) .OR. EMPTY(C5_XDOC) .OR. EMPTY(C5_XLOJA)
                    MSGINFO( "Los Pedidos Back to Back deben tener diligenciado los campos de la carpeta BackToBack", "Campo(s) vacios(s)" )  
                    Return .F.
                ENDIF
            ENDIF
        ENDIF

        IF Alltrim(SA1->A1_EST)<>"EX" .AND.  C5_XTPED $'BxE' // Exportacion con cliente Nacional 
            MSGINFO( "El cliente seleccionado no es del exterior", "Pedido BtoB o Exportación" )  
            Return .F.
        EndIf

        IF SA1->A1_XFULLRT=='2' // Full Retenciones sin base y cambia el Codigo Fiscal
            nPosCF := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
            FOR nX:=1 to Len(aCfEquiv)
                cCFa:=aCfEquiv[nX][1]
                cCFb:=aCols[n][nPosCF]
                IF ALLTRIM(aCfEquiv[nX][1])==ALLTRIM(aCols[n][nPosCF]) .AND. !EMPTY(ALLTRIM(aCfEquiv[nX][2]))
                    aCols[n][nPosCF]:= LEFT(ALLTRIM(aCfEquiv[nX][2])+SPACE(5),5)
                    Exit
                EndIf
            NEXT
        EndIf

        nPosTes := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
        nPosAlm := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
        If C5_XTPED=='B'
            aTSEqAll:= &(" "+cTSEqB2B+" ")
            FOR nX:=1 to Len(aTSEqAll)
                cCFa:=aTSEqAll[nX][1]
                cCFb:=aCols[n][nPosTes]
                IF ALLTRIM(aTSEqAll[nX][1])==ALLTRIM(aCols[n][nPosTes]) .AND. !EMPTY(ALLTRIM(aTSEqAll[nX][2]))
                    aCols[n][nPosTes]:= SUBSTR(ALLTRIM(aTSEqAll[nX][2])+SPACE(3),1,3)
                    Exit
                EndIf
            NEXT
            aCols[n][nPosAlm]:= cBodgEXP         
        ElseIf C5_XTPED=='O'
            aTSEqAll:= &(" "+cTSEqOBS+" ")
            FOR nX:=1 to Len(aTSEqAll)
                cCFa:=aTSEqAll[nX][1]
                cCFb:=aCols[n][nPosTes]
                IF ALLTRIM(aTSEqAll[nX][1])==ALLTRIM(aCols[n][nPosTes]) .AND. !EMPTY(ALLTRIM(aTSEqAll[nX][2]))
                    aCols[n][nPosTes]:= SUBSTR(ALLTRIM(aTSEqAll[nX][2])+SPACE(3),1,3)
                    Exit
                EndIf
            NEXT  
            aCols[n][nPosAlm]:=cBodgNAC
        ElseIf C5_XTPED=='E'
            aTSEqAll:= &(" "+cTSEqEXP+" ")
            FOR nX:=1 to Len(aTSEqAll)
                cCFa:=aTSEqAll[nX][1]
                cCFb:=aCols[n][nPosTes]
                IF ALLTRIM(aTSEqAll[nX][1])==ALLTRIM(aCols[n][nPosTes]) .AND. !EMPTY(ALLTRIM(aTSEqAll[nX][2]))
                    aCols[n][nPosTes]:= SUBSTR(ALLTRIM(aTSEqAll[nX][2])+SPACE(3),1,3)
                    Exit
                EndIf
            NEXT 
            aCols[n][nPosAlm]:= cBodgEXP 
        Else
           aCols[n][nPosAlm]:=cBodgNAC 
        EndIf

        Return .T.
	EndIf
	
    If cFunName == "MATA415"  // Presupesto
        IF EMPTY(CJ_XNATURE)
            MSGINFO( "Digite la Modalidad de la operación antes de diligenciar los productos", "Campo Modalidad entrega vacio" )  
            Return .F.
        ENDIF
        IF EMPTY(CJ_XTPED)
            MSGINFO( "Seleccione el tipo de Pedido (Exportación, Nacional, BtoB, Obsequio) antes de diligenciar los productos", "Campo Tipo Pedido entrega vacio" )  
            Return .F.
        /*/ No se validara Campos de Factura BackToBack en Presupuesto
        ELSE
            IF CJ_XTPED=='B' 
                IF EMPTY(CJ_XFORNEC) .OR. EMPTY(CJ_XDOC) .OR. EMPTY(CJ_XLOJA)
                    MSGINFO( "Los Pedidos Back to Back deben tener diligenciado los campos de la carpeta BackToBack", "Campo(s) vacios(s)" )  
                    Return .F.
                ENDIF
            ENDIF
        /*/
        ENDIF
        IF Alltrim(SA1->A1_EST)<>"EX" .AND.  CJ_XTPED $'BxE' // Exportacion con cliente Nacional 
            MSGINFO( "El cliente seleccionado no es del exterior", "Pedido B2B o Exportación" )  
            Return .F.
        ENDiF
        /*/
        IF SA1->A1_XFULLRT=='2' // Full Retenciones sin base y cambia el Codigo Fiscal
            FOR nX:=1 to Len(aCfEquiv)
                IF ALLTRIM(aCfEquiv[nX][1])==ALLTRIM(TMP1->CK_CF) .AND. !EMPTY(ALLTRIM(aCfEquiv[nX][2]))
                    TMP1->CK_CF:= SUBSTR(ALLTRIM(aCfEquiv[nX][2])+SPACE(3),1,3)
                    Exit
                EndIf
            NEXT
        EndIf
        /*/
        If CJ_XTPED=='B'
            aTSEqAll:= &(" "+cTSEqB2B+" ")
            FOR nX:=1 to Len(aTSEqAll)
                IF ALLTRIM(aTSEqAll[nX][1])==ALLTRIM(TMP1->CK_TES) .AND. !EMPTY(ALLTRIM(aTSEqAll[nX][2]))
                    TMP1->CK_TES:= SUBSTR(ALLTRIM(aTSEqAll[nX][2])+SPACE(3),1,3)
                    Exit
                EndIf
            NEXT
            TMP1->CK_LOCAL:= cBodgEXP  
        ElseIf CJ_XTPED=='O'
            aTSEqAll:= &(" "+cTSEqOBS+" ")
            FOR nX:=1 to Len(aTSEqAll)
                IF ALLTRIM(aTSEqAll[nX][1])==ALLTRIM(TMP1->CK_TES) .AND. !EMPTY(ALLTRIM(aTSEqAll[nX][2]))
                    TMP1->CK_TES:= SUBSTR(ALLTRIM(aTSEqAll[nX][2])+SPACE(3),1,3)
                    Exit
                EndIf
            NEXT
            TMP1->CK_LOCAL:= cBodgNAC
        ElseIf CJ_XTPED=='E'
            aTSEqAll:= &(" "+cTSEqEXP+" ")
            FOR nX:=1 to Len(aTSEqAll)
                IF ALLTRIM(aTSEqAll[nX][1])==ALLTRIM(TMP1->CK_TES) .AND. !EMPTY(ALLTRIM(aTSEqAll[nX][2]))
                    TMP1->CK_TES:= SUBSTR(ALLTRIM(aTSEqAll[nX][2])+SPACE(3),1,3)
                    Exit
                EndIf
            NEXT
            TMP1->CK_LOCAL:= cBodgEXP
        Else
            TMP1->CK_LOCAL:= cBodgNAC
        EndIf

        Return .T.
    EndIf

	If cFunName == "MATA467N" // Si se accede desde la rutina Factura de Venta/Salida
        Return .T.
	EndIf
	
	If CFunName == 'MATA462N' // Si se accede desde la rutina Remision de Venta/Salida
        Return .T.
	EndIf
	
	If CFunName == 'MATA465N' // Si se accede desde la rutina Nota de Debito/Credito Clientes (Ventas)
        /*/
        cTE :=SB1->B1_TE
        cTE2:=SB1->B1_TE2
        cTS :=SB1->B1_TS
        CTS2:=SB1->B1_TS2

        IF cEspecDoc=='NDC'  //nota Debito

            IF SA1->A1_XFULLRT=='2' 
                nPosCF := aScan(aHeader,{|x| AllTrim(x[2])=="D2_CF"})   
                FOR nX:=1 to Len(aCfEquiv)
                    cCFa:=aCfEquiv[nX][1]
                    cCFb:=aCols[n][nPosCF]
                    IF ALLTRIM(aCfEquiv[nX][1])==ALLTRIM(aCols[n][nPosCF]) .AND. !EMPTY(ALLTRIM(aCfEquiv[nX][2]))
                        aCols[n][nPosCF]:= SUBSTR(ALLTRIM(aCfEquiv[nX][2])+SPACE(3),1,3)
                        Exit
                    EndIf
                NEXT
            EndIf
        ElseIf cEspecDoc=='NCC'
            IF EMPTY(F1_FORNECE)
                MSGINFO( "Digite los datos del cliente antes de diligenciar los productos", "Campos emcabezados vacios" )
                Return .F.
            ENDIF
            /*/
            /*/
            nPosCOD:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
            nPosPRC:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_VUNIT"})
			IF empty(SA1->A1_TABELA) .AND. !EMPTY(SA1->A1_XCVCOD)
				cPrvLst:=POSICIONE("ZCV",1,xfilial("ZCV")+SA1->A1_XCVCOD,"ZCV_LSTPRC")
			ENDIF
            If EMPTY(cPrvLst)
                aCols[n][nPosPRC]:=POSICIONE("DA1",1,XFILIAL('DA1')+SA1->A1_TABELA+aCols[n][nPosCOD],"DA1_PRCVEN")
            else
                aCols[n][nPosPRC]:=POSICIONE("DA1",1,XFILIAL('DA1')+cPrvLst+aCols[n][nPosCOD],"DA1_PRCVEN")
            EndIf
            /*/
            /*/
            nPosTES:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
            IF SA1->A1_TPESSOA=='1' //Regimen comun
                cTesDev:=POSICIONE("SF4",1,XFILIAL("SF4")+cTS ,"F4_TESDV")
                IF !EMPTY(cTesDev)
                    aCols[n][nPosTES]:=cTesDev
                EndIf
            ELSE
                cTesDev:=POSICIONE("SF4",1,XFILIAL("SF4")+cTS2,"F4_TESDV") 
                IF !EMPTY(cTesDev)
                    aCols[n][nPosTES]:=cTesDev
                EndIf          
            ENDIF
            IF SA1->A1_XFULLRT=='2' 
                nPosCF := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CF"})   
                FOR nX:=1 to Len(aCfEquiv)
                    cCFa:=aCfEquiv[nX][1]
                    cCFb:=aCols[n][nPosCF]
                    IF ALLTRIM(aCfEquiv[nX][1])==ALLTRIM(aCols[n][nPosCF]) .AND. !EMPTY(ALLTRIM(aCfEquiv[nX][2]))
                        aCols[n][nPosCF]:= SUBSTR(ALLTRIM(aCfEquiv[nX][2])+SPACE(3),1,3)
                        Exit
                    EndIf
                NEXT
            EndIf
           
        EndIF
        /*/
        Return .T.
	EndIf
	
	If CFunName == "MATA121" // Si se accede desde la rutina Pedido de Compra/Entrada
	EndIf
	
	If CFunName == "MATA101N" // Si se accede desde la rutina Factura de Compra/Entrada
	EndIf
	
	If CFunName == 'MATA102N' // Si se accede a la rutina Remision de Compra/Entrada
    EndIf
	
	If CFunName == 'MATA466N' // Si se accede desde la rutina Nota de Credito/Debito Proveedor (Compras)

	EndIf
    If CFunName=='MATA143'  // Factura de Despacho

    EndIf

Return .T.
/*/{Protheus.doc} ActiField
sE COLOCA EN EL X3_vALID DE C5_XTPED Y CJ_XTPED
@type function
@version  
@author AxelDiaz
@since 25/5/2021
@param ctped, character, param_description
@return return_type, return_description
/*/
User Function ActiField(ctped)
    Local lRet     := .T.
    Local cFunName := FunName()
    Local nPosPro  := 0
    Local nX       := 0
    Local nRecno   := 0

    If cFunName == 'MATA410'
        nPosPro       := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
        For nX:=1 to Len(aCols)
            If !aCols[nX,Len(aHeader)+1] .and. !EMPTY(aCols[nX,nPosPro])
                MSGINFO("En este punto ya no puede modificar el tipo de Pedido "+C5_XTPED+ctped,"No modifique Tipo Pedido")
                lRet := .F.
                EXit
            EndIf
        Next 
    ElseIf cFunName == 'MATA415' // Presupuesto
        nRecno:=TMP1->(RECNO())
        TMP1->(dbGoTop())
        While !TMP1->(EOF())
            If !TMP1->CK_FLAG .and. !EMPTY(TMP1->CK_PRODUTO) //TMP1->CK_PRODUTO + TMP1->CK_FLAG
                lRet := .F.
                EXIT
            EndIf
            TMP1->(DbSkip())
        End
        TMP1->(dbGoto(nRecno))
    EndIf

Return lRet
/*/{Protheus.doc} ActiWhen
eSTA FUNCION VA EN x3_When para c5_xtped y cj_xtped
@type function
@version  
@author AxelDiaz
@since 25/5/2021
@return return_type, return_description
/*/
User Function ActiWhen()
    Local lRet     := .T.
    Local cFunName := FunName()
    Local nPosPro  := 0
    Local nX       := 0
    Local nRecno   := 0
    If cFunName == 'MATA410'
        nPosPro       := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
        For nX:=1 to Len(aCols)
            If !aCols[nX,Len(aHeader)+1] .and. !EMPTY(aCols[nX,nPosPro])
                lRet := .F.
                EXIT
            EndIf
        Next
    ElseIf cFunName == 'MATA415' // Presupuesto
        nRecno:=TMP1->(RECNO())
        TMP1->(dbGoTop())
        While !TMP1->(EOF())
            If !TMP1->CK_FLAG .and. !EMPTY(TMP1->CK_PRODUTO) //TMP1->CK_PRODUTO + TMP1->CK_FLAG
                lRet := .F.
                EXIT
            EndIf
            TMP1->(DbSkip())
        End
        TMP1->(dbGoto(nRecno))
    EndIf
Return lRet

User Function DescuST
    Local lRet     := .T.
    Local cFunName := FunName()
    Local nPosPro  := 0
    Local nPosPru  := 0
    Local nPosVen  := 0
    Local nPosVal  := 0
    Local nPosCan  := 0
    Local nPosDes1 := 0
    Local nPosDes2 := 0
    Local nX       := 0
    Local nRecno   := 0
    dbSelectarea("DA1")
    DA1->(dbSetOrder(1))
                                                              
    If cFunName == 'MATA410'
        If M->C5_XTPED$'NO'   // Nacional o Obsequio  
            nPosPro := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
            nPosPru := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"  })
            nPosVen := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"  })
            nPosVal := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"   })
            nPosCan := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"  })
            nPosDes1:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT" })
            nPosDes2:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_XDESCUE" })
            For nX:=1 to Len(aCols)
                If !aCols[nX,Len(aHeader)+1] .and. !EMPTY(aCols[nX,nPosPro])
                    DA1->(dbSeek(XFILIAL( 'DA1' )+M->C5_TABELA+aCols[nX,nPosPro]))
                    aCols[nX,nPosPru] := DA1->DA1_PRCVEN * ((100-M->C5_XDESCUE)/100) * ((100-aCols[nX,nPosDes2])/100)
                    aCols[nX,nPosVen] :=  (DA1->DA1_PRCVEN * ;
                                        ((100-M->C5_DESC1)/100) *;
                                        ((100-M->C5_DESC2)/100) *;
                                        ((100-M->C5_DESC3)/100) *;
                                        ((100-M->C5_DESC4)/100) *;
                                        ((100-aCols[nX,nPosDes1])/100) *;
                                        ((100-aCols[nX,nPosDes2])/100) *;
                                        ((100-M->C5_XDESCUE)/100))
                    aCols[nX,nPosVal] := aCols[nX,nPosVen]*aCols[nX,nPosCan]
                EndIf
            Next 
            //oGetDad:oBrowse:Refresh()
            //oGetDad:oBrowse:SetFocus()
            GETDREFRESH()
            SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
            oGetDad:Refresh()
            A410LinOk(oGetDad)
        Else
            Alert("Campo descuento interno solo es funcional para pedidos Nacionales u Obsequios")
        EndIf
    ElseIf cFunName == 'MATA415' // Presupuesto
        If M->CJ_XTPED$'NO'   // Nacional o Obsequio  
            nRecno := TMP1->(RECNO())
            TMP1->(dbGoTop())
            While !TMP1->(EOF())
                If !TMP1->CK_FLAG .and. !EMPTY(TMP1->CK_PRODUTO) //TMP1->CK_PRODUTO + TMP1->CK_FLAG
                    DA1->(dbSeek(XFILIAL('DA1')+M->CJ_TABELA+TMP1->CK_PRODUTO))
                    TMP1->CK_PRUNIT := DA1->DA1_PRCVEN * ( (100-M->CJ_XDESCUE)/100) * ( (100-TMP1->CK_XDESCUE)/100 )
                    TMP1->CK_PRCVEN := (DA1->DA1_PRCVEN*;
                                        ((100-M->CJ_DESC1)/100)*;
                                        ((100-M->CJ_DESC2)/100)*;
                                        ((100-M->CJ_DESC3)/100)*;
                                        ((100-M->CJ_DESC4)/100)*;
                                        ((100-TMP1->CK_DESCONT)/100)*;
                                        ((100-TMP1->CK_XDESCUE)/100)*;
                                        ((100-M->CJ_XDESCUE)/100))
                    TMP1->CK_VALOR  := (TMP1->CK_QTDVEN*TMP1->CK_PRCVEN)          
                EndIf
                TMP1->(DbSkip())
            End
            TMP1->(DBGOTOP()) 
            GETDREFRESH()
            SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
            oGetDad:Refresh()
            oGetDad:ForceRefresh()
            A415LinOk(oGetDad)
                
            //TMP1->(dbGoto(nRecno))
        Else
            Alert("Campo descuento interno solo es funcional para presupuestos Nacionales u Obsequios")
        EndIf
    EndIf
Return lRet








#INCLUDE "rwmake.ch" 
/*/{Protheus.doc} GenCV0
Rutina para resincronizar la tabla CV0 con los terceros
@type function
@version  
@author AxelDiaz
@since 7/7/2021
@return variant, return_description
/*/
User Function GenCV0()
Private cPerg       := "ACTCV0"
Private oLeTxt

@ 200,1 TO 380,580 DIALOG oLeTxt TITLE OemToAnsi("Actualizacion de Ente Contable 05-NIT")
@ 02,10 TO 080,380
@ 10,018 Say " Este programa procesará la Tabla de Clientes/Proveedores,"
@ 18,018 Say " para agregar dentro de la tabla"  
@ 25,018 Say " 05- NIT (CV0), los terceros. " 

@ 55,128 BMPBUTTON TYPE 01 ACTION ActCV0() //ActCV0(Close(oLeTxt))
@ 55,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
//@ 70,188 BMPBUTTON TYPE 05 ACTION Parametros(cPerg)

Activate Dialog oLeTxt Centered

Return Nil

Static Function ActCV0
	//Local lClte:=IIF(MV_PAR01=1,.T.,.F.)
	//Local cTdoc:= MV_PAR02
	//Local cAlias:=IIF(lClte,"SA1","SA2")
	Local cQry:=""
	Local aTablas:={"SA1","SA2"}
	Local aDocs:={'11','12','13','21','22','31','41','42','43','91'}
	Local nX, ny
	Private cTRBQry		:=	GetNextAlias() //criatrab(nil,.f.)

	For ny:=1 to LEN(aTablas)
		cAlias:=aTablas[ny]
		lClte:=IIF(cAlias="SA1",.T.,.F.)
		For nX:=1 to len(aDocs)   
			cTdoc:=aDocs[nX]
			If lClte
				cQry :=	" SELECT A1_FILIAL FILIAL,A1_CGC NIT,A1_PFISICA CED,A1_NOME RAZON,A1_TIPDOC TPD,A1_COD COD, A1_LOJA LOJA, TBLR.R_E_C_N_O_ CODREC "
			Else
				cQry :=	" SELECT A2_FILIAL FILIAL,A2_CGC NIT,A2_PFISICA CED,A2_NOME RAZON,A2_TIPDOC TPD,A2_COD COD, A2_LOJA LOJA, TBLR.R_E_C_N_O_ CODREC "
			Endif

			cQry +=	"  FROM "+RetSqlName(cAlias)+" TBLR  "
			cQry += "  WHERE NOT EXISTS (SELECT * FROM "+RetSqlName("CV0")+" CV0  "

			If lClte                //Verifica si se trata de la Tabla de Clientes SA1
				cQry += "  WHERE A1_TIPDOC=CV0_TIPO01 AND CV0_TIPO00='01'"
				if cTdoc=="31"      //Verifica si se trata del campo NIT
					cQry += " AND A1_CGC=CV0_CODIGO AND D_E_L_E_T_ = ' ' )"
				Else                   //De lo contrario verifica contra el  campo de Cedula de Extranjeria
					cQry += " AND A1_PFISICA=CV0_CODIGO AND D_E_L_E_T_ = ' ' ) "
				Endif
				cQry += "  AND A1_TIPDOC='"+alltrim(cTdoc)+"' "
			else
				cQry += "  WHERE A2_TIPDOC=CV0_TIPO01  AND CV0_TIPO00='02'"
				if cTdoc=="31"
					cQry += " AND A2_CGC=CV0_CODIGO  AND D_E_L_E_T_ = ' ' )"
				Else
					cQry += " AND A2_PFISICA=CV0_CODIGO AND D_E_L_E_T_ = ' ') "
				Endif
				cQry += "  AND A2_TIPDOC='"+alltrim(cTdoc)+"' "
			Endif

			cQry += "  AND D_E_L_E_T_<>'*' "

			cQry := ChangeQuery(cQry)
			//dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL), cQry , .F., .T.)
	
			DbUseArea(.T.,  "TOPCONN", TcGenQry(,,cQry ),cTRBQry,.T.,.T.)

			cQryI :="SELECT MAX(CV0_ITEM) Itm"
			cQryI +=" FROM "+RetSqlName("CV0")
			cQryI +=" WHERE  D_E_L_E_T_<>'*' "

			cQryI  := ChangeQuery(cQryI )
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryI),"QRYITM",.F.,.T.)

			if !QRYITM->(EOF())
				cItm:=IIF(VAL(QRYITM->Itm)>0,soma1(QRYITM->Itm),"000001")
				QRYITM->(dbCloseArea())
				While (cTRBQry)->(!eof())
					cChave:= IIF((cTRBQry)->TPD=="31",(cTRBQry)->NIT+(cTRBQry)->LOJA,(cTRBQry)->CED)
					dbselectarea("CV0")
					dbsetorder(1)
					//if !(dbseek(xfilial("CV0")+"01"+Padr(cChave,15)))
					Reclock("CV0",.T.)
					CV0->CV0_FILIAL :=(cTRBQry)->FILIAL//xFilial("CV0")
					CV0->CV0_PLANO  :="01"
					CV0->CV0_ITEM   :=cItm
					CV0->CV0_CODIGO := IIF((cTRBQry)->TPD=="31",(cTRBQry)->NIT,(cTRBQry)->CED)
					CV0->CV0_DESC   := (cTRBQry)->RAZON
					CV0->CV0_CLASSE  := "2"
					CV0->CV0_NORMAL := IIF(lClte,"1","2")
					CV0->CV0_ENTSUP := IIF(lClte,"13","22")
					CV0->CV0_DTIEXI := stod("20120101") // fecha predefinida
					CV0->CV0_TIPO00 := IIF(lClte,"01","02")
					CV0->CV0_TIPO01 := (cTRBQry)->TPD
					CV0->CV0_COD   := (cTRBQry)->COD
					CV0->CV0_LOJA  := (cTRBQry)->LOJA
					cItm:=soma1(cItm)
					MsUnlock()
					//	Endif
					(cTRBQry)->(DbSkip())
				EndDo
				(cTRBQry)->(dbCloseArea()) 
			Else
				MsgAlert("Verifique la Tabla CV0, debido a que no se logro resolver el numero de Item Los Terceros no Fueron Actualizados")
				QRYITM->(dbCloseArea())
			Endif
		next nX
	next nY
	msgalert("CV0 Atualizada com sucesso!!")
Return           
                                                

Static Function AjustaSX1(cPreg)
Local _sAlias := Alias()
Local i := 0
Local j:= 0
Local ni
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd(aRegs,{cPreg,"01","Indica la Tabla?"  ,"Indica la Tabla?"  ,"Indica la Tabla?"   ,"mv_par01"	,"C"	,01,0,0	,"C"	,""	,"MV_PAR01"	,"Clientes","Clientes","Clientes","","","Proveedores","Proveedores","Proveedores","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPreg,"02","Tipo de Doc.?"     ,"Tipo de Doc.?"     ,"Tipo de Doc.?"      ,"mv_par02"	,"C"	,02,0,0	,"G"	,""	,"MV_PAR02"	,"","","","","","","","","","","","","","","","","","","","","","","","","TB",""})


For ni:=1 to Len(aRegs)
	If !DbSeek(cPreg+aRegs[ni,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[ni])
				FieldPut(j,aRegs[ni,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return


Static Function Parametros(cSx1)                   
Private cPerg := Padr(cSx1,10)
	   AjustaSX1(cPerg)
	   If ( ! Pergunte(cPerg,.T.) )
		  Return
	   EndIf
Return

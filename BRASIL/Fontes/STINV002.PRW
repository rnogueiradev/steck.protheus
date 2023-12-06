#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO35    บAutor  ณMicrosiga           บ Data ณ  29/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STINV002

	Local aTelaAux3
	Local aTelaAux4
	Local aTelaAux5

	Private _ntoler := supergetmv('ST_TLBALAN',,2)

	aTelaAux3 := VTSave()
	aReceiver := {}
	VtClear()
	VtClearBuffer()

	VtClear()
	_cArmazem := space(2)
	_cRotativo := space(1)// Chamado 001223 - Inventario rotativo - Robson Mazzarotto

	aTelaAux4 := VTSave()
	@ 0,0 VTSay '[Qual armazem ira contar]'
	@ 2,0 VTsay 'Armazem: ' vtget _cArmazem
	@ 4,0 VTSay '[Inventario Rotatitvo]'
	@ 6,0 VTsay 'Rotativo: ' vtget _cRotativo
	VtRead
	VTRestore(,,,,aTelaAux4)

	If VtLastKey() == 27
		return .f.
	EndIf

	Dbselectarea('PPF')
	Dbseek(xfilial('PPF')+__cUserID)

	if  PPF->PPF_3cont <> 'S' .and.  PPF->PPF_1cont <> 'S' .and.  PPF->PPF_2cont <> 'S'

		VTAlert("a.Usuario sem acesso ao Processo de invetario!!!","Aviso",.T.,3000,2)
		VTKeyBoard(chr(20))
		Return

	endif

	if  PPF->PPF_3cont = 'S' .and.  PPF->PPF_1cont ='S' .and.  PPF->PPF_2cont = 'S'

		VTAlert("a.Usuario nao pode fazer as 3 contagens!!!","Aviso",.T.,3000,2)
		VTKeyBoard(chr(20))
		Return

	endif

	if  PPF->PPF_3cont == 'S'

		IF PPF->PPF_1cont <> 'S' .OR.  PPF->PPF_2cont <> 'S'

			VTAlert("b.Este Usuario esta direcionado para a 3a Contagem!!!","Aviso",.T.,3000,2)
			VTKeyBoard(chr(20))
		Endif

		IF PPF->PPF_ROTATI <> '1' .AND.  _cRotativo == "S"

			VTAlert("b.Este Usuario nao pode fazer inventario Rotativo!!!","Aviso",.T.,3000,2)
			VTKeyBoard(chr(20))

		ELSE

			if _cRotativo == "S"

				_cQuery := "SELECT COUNT(*) AS REG FROM " + RetSqlName("CBA")+ "  WHERE CBA_LOCAL = '"+_cArmazem+"' AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND   CBA_STATUS  IN ( 1 , 3 )     AND CBA_XUSCT2  <> ' ' AND CBA_XROTAT = '1'  AND D_E_L_E_T_ = ' '  "

			else

				_cQuery := "SELECT COUNT(*) AS REG FROM " + RetSqlName("CBA")+ "  WHERE CBA_LOCAL = '"+_cArmazem+"' AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND   CBA_STATUS  IN ( 1 , 3 )    AND CBA_XUSCT2  <> ' ' AND CBA_XROTAT <> '1'  AND D_E_L_E_T_ = ' '  "

			endif

			_cQuery := ChangeQuery(_cQuery)

			If Select("QR1") > 0
				QR1->(DbCloseArea())
			EndIf

			TcQuery _cQuery New Alias "QR1"

			if QR1->REG = 0

				VTAlert("1.Nao Existem 3a contagens a serem efetudadas !!!","Aviso",.T.,3000,2)
				VTKeyBoard(chr(20))
				QR1->(DbCloseArea())
				Return

			endif
			QR1->(DbCloseArea())
			_nOpc:= 3

		Endif

	else

		IF PPF->PPF_ROTATI <> '1' .AND.  _cRotativo == "S"

			VTAlert("b.Este Usuario nao pode fazer inventario Rotativo!!!","Aviso",.T.,3000,2)
			VTKeyBoard(chr(20))

			_nOpc := 0

		ELSE

			if _cRotativo == "S"

				_cQuery := "SELECT COUNT(*) AS REG FROM " + RetSqlName("CBA")+ "  WHERE CBA_LOCAL = '"+_cArmazem+"' AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND CBA_STATUS  IN ( 0 , 1 ) AND CBA_XROTAT = '1' AND  CBA_XUSCT2 = ''  AND D_E_L_E_T_ = ' ' "

			else

				_cQuery := "SELECT COUNT(*) AS REG FROM " + RetSqlName("CBA")+ "  WHERE CBA_LOCAL = '"+_cArmazem+"' AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND CBA_STATUS  IN ( 0 , 1 ) AND CBA_XROTAT <> '1' AND CBA_XUSCT2 = '' AND D_E_L_E_T_ = ' ' "

			endif

			_cQuery := ChangeQuery(_cQuery)

			If Select("QR1") > 0
				QR1->(DbCloseArea())
			EndIf

			TcQuery _cQuery New Alias "QR1"

			if QR1->REG <> 0

				if PPF->PPF_1cont == 'S'

					_nOpc := 1


				else

					if PPF->PPF_2cont == 'S'

						_nOpc := 2

					else

						VTAlert("1.Nao exitem mais produtos para contagem !!!","Aviso",.T.,3000,2)
						VTKeyBoard(chr(20))
						Return

					endif

				endif

			Else

				if PPF->PPF_2cont == 'S'

					_nOpc := 2


				else

					VTAlert("2. Nao existem mais produtos para contagem!!!","Aviso",.T.,3000,2)
					VTKeyBoard(chr(20))
					Return

				endif

			Endif

			DbSelectArea('QR1')
			QR1->(DbCloseArea())

		Endif

	ENDIF

	Do while .t.

		if !sti002ct(   _nOpc, _cArmazem, _cRotativo  )
			Return
		Endif

	Enddo



/*/  Rotina antiga

if !eof()
if  PPF->PPF_1cont == 'S'
aadd(aReceiver ,'1a Contagem')
endif

if  PPF->PPF_2cont == 'S'
aadd(aReceiver ,'2a Contagem')
endif

if  PPF->PPF_3cont == 'S'
aadd(aReceiver ,'3a Contagem')
endif

Else
VTAlert("Usuario sem acesso ao Processo de invetario sucesso!!!","Aviso",.T.,3000,2)
VTKeyBoard(chr(20))
Return
Endif

if len(aReceiver) == 0
VTAlert("Usuario sem contagens planejadas!!!","Aviso",.T.,3000,2)
VTKeyBoard(chr(20))
Return
Endif


do While .t.
@ 0,0 VTSay '[Selecao de Contagens]'
@ 1,0 VTSay 'Usuario: ' + retfullname(__cUserID)
nOpc:=VTaChoice(3,0,VTMaxRow(),VTMaxCol(),aReceiver)
VTRestore(,,,,aTelaAux3)
If VtLastKey() == 27
Return
else

VtClear()
_cArmazem := space(2)

aTelaAux4 := VTSave()
@ 0,0 VTSay '[Qual ararmazem ira contar]'
@ 2,0 VTsay 'Armazem: ' vtget _cArmazem
VtRead
VTRestore(,,,,aTelaAux4)

If VtLastKey() == 27
return .f.
EndIf

Do while .t.
if !sti002ct(   nOpc, _cArmazem  )
Return
Endif

Enddo

EndIf

Enddo
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO36    บAutor  ณMicrosiga           บ Data ณ  09/29/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function  sti002ct(_nOpcao,_cArmazem, _cRotativo )

	Local _nCount:= 0
	Local _nXQSEP:= 0
	Local _nXQATU:= 0
	_aLe_Sint := {}
	_nOpcao_old := ''
	_nQtdSep := 0


	if _nOpcao == 1

		if _cRotativo == "S"

			_cQuery := "SELECT NVL(R_E_C_N_O_,0)   AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS IN ('1')  AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND CBA_LOCAL = '"+_cArmazem+"'AND (  CBA_XUSCT1 ='"+__cUserID+"'    )  AND CBA_XROTAT = '1' AND D_E_L_E_T_ = ' '  ORDER BY R_E_C_N_O_ " // em sql


		else

			_cQuery := "SELECT NVL(R_E_C_N_O_,0)   AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS IN ('1')  AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND CBA_LOCAL = '"+_cArmazem+"'AND (  CBA_XUSCT1 ='"+__cUserID+"'    )  AND CBA_XROTAT <> '1' AND D_E_L_E_T_ = ' '  ORDER BY R_E_C_N_O_ " // em sql

		endif

	elseif _nOpcao == 2

		if _cRotativo == "S"

			_cQuery := "SELECT NVL(R_E_C_N_O_,0)   AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS IN ('1')  AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND CBA_LOCAL = '"+_cArmazem+"'AND (  CBA_XUSCT2 ='"+__cUserID+"'    ) AND CBA_XROTAT = '1'  AND D_E_L_E_T_ = ' '  ORDER BY R_E_C_N_O_ " // em sql


		else

			_cQuery := "SELECT NVL(R_E_C_N_O_,0)   AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS IN ('1')  AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND CBA_LOCAL = '"+_cArmazem+"'AND (  CBA_XUSCT2 ='"+__cUserID+"'    ) AND CBA_XROTAT <> '1' AND D_E_L_E_T_ = ' '  ORDER BY R_E_C_N_O_ " // em sql

		endif

	else

		if _cRotativo == "S"

			_cQuery := "SELECT NVL(R_E_C_N_O_,0)   AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS IN ('1')  AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND CBA_LOCAL = '"+_cArmazem+"'AND (  CBA_XUSCT3 ='"+__cUserID+"'    )   AND CBA_XROTAT = '1' AND D_E_L_E_T_ = ' '  ORDER BY R_E_C_N_O_ " // em sql

		else

			_cQuery := "SELECT NVL(R_E_C_N_O_,0)   AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS IN ('1')  AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND CBA_LOCAL = '"+_cArmazem+"'AND (  CBA_XUSCT3 ='"+__cUserID+"'    )   AND CBA_XROTAT <> '1' AND D_E_L_E_T_ = ' '  ORDER BY R_E_C_N_O_ " // em sql

		endif

	endif

	_cQuery := ChangeQuery(_cQuery)

	If Select("QR1") > 0
		QR1->(DbCloseArea())
	EndIf

	TcQuery _cQuery New Alias "QR1"

	if QR1->REG <> 0

		VTAlert("Existem contagens Abertas, voce tera que conclui-las !!!","Aviso",.T.,3000,2)
		VTKeyBoard(chr(20))

		Dbselectarea('CBA')
		DbGoto(QR1->REG)

		_nOpcao_old :=_nOpcao

		DO CASE
			CASE EMPTY(CBA_XUSCT1) .AND. CBA_XQTCT1 = 0
			_nOpcao = 1
			CASE !EMPTY(CBA_XUSCT1) .AND. CBA_STATUS = "1" .AND. CBA_XQTCT1 = 0
			_nOpcao = 1
			CASE EMPTY(CBA_XUSCT2) .AND. CBA_XQTCT2 = 0
			_nOpcao = 2
			CASE !EMPTY(CBA_XUSCT2) .AND. CBA_STATUS = "1" .AND. CBA_XQTCT2 = 0
			_nOpcao = 2
			CASE EMPTY(CBA_XUSCT3) .AND. CBA_XQTCT3 = 0
			_nOpcao = 3
			CASE !EMPTY(CBA_XUSCT3) .AND. CBA_STATUS = "1" .AND. CBA_XQTCT3 = 0
			_nOpcao = 3
			OTHERWISE
			_nOpcao = 0
		ENDCASE

	Else


		Dbselectarea("QR1")
		DbClosearea('QR1')

		if _nOpcao == 1

			if _cRotativo == "S"

				_cQuery := "SELECT NVL(R_E_C_N_O_,0)   AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS = '0'  AND CBA_FILIAL = '"+XFILIAL('CBA')+"'  AND CBA_LOCAL = '"+_cArmazem+"' AND CBA_LOCALI BETWEEN '"+PPF->PPF_LOCDE+"' AND '"+PPF->PPF_LOCATE+"'  AND CBA_XROTAT = '1'  AND D_E_L_E_T_ = ' '  ORDER BY CBA_PROD,R_E_C_N_O_ " // em sql

			else

				_cQuery := "SELECT NVL(R_E_C_N_O_,0)   AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS = '0'  AND CBA_FILIAL = '"+XFILIAL('CBA')+"'  AND CBA_LOCAL = '"+_cArmazem+"' AND CBA_LOCALI BETWEEN '"+PPF->PPF_LOCDE+"' AND '"+PPF->PPF_LOCATE+"'  AND CBA_XROTAT <> '1' AND D_E_L_E_T_ = ' '  ORDER BY CBA_PROD,R_E_C_N_O_ " // em sql

			endif
		elseif _nOpcao == 2

			if _cRotativo == "S"

				_cQuery := "SELECT NVL(R_E_C_N_O_,0)  AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS = '3'  AND CBA_XUSCT2 = ' ' AND CBA_XUSCT1 <>'"+__cUserID+"' AND CBA_XUSCT1 <>' ' AND CBA_FILIAL = '"+XFILIAL('CBA')+"'  AND CBA_LOCAL = '"+_cArmazem+"' AND CBA_LOCALI BETWEEN '"+PPF->PPF_LOCDE+"' AND '"+PPF->PPF_LOCATE+"'  AND CBA_XROTAT = '1' AND D_E_L_E_T_ = ' '   ORDER BY CBA_PROD,R_E_C_N_O_ " // em sql


			else

				_cQuery := "SELECT NVL(R_E_C_N_O_,0)  AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS = '3'  AND CBA_XUSCT2 = ' ' AND CBA_XUSCT1 <>'"+__cUserID+"' AND CBA_XUSCT1 <>' ' AND CBA_FILIAL = '"+XFILIAL('CBA')+"'  AND CBA_LOCAL = '"+_cArmazem+"' AND CBA_LOCALI BETWEEN '"+PPF->PPF_LOCDE+"' AND '"+PPF->PPF_LOCATE+"'  AND CBA_XROTAT <> '1' AND D_E_L_E_T_ = ' '   ORDER BY CBA_PROD,R_E_C_N_O_ " // em sql

			endif

		else

			if _cRotativo == "S"

				_cQuery := "SELECT NVL(R_E_C_N_O_,0)  AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS = '3' AND CBA_XUSCT3= ' ' AND CBA_XUSCT1 <>'"+__cUserID+"' AND CBA_XUSCT2 <>'"+__cUserID+"' AND CBA_XUSCT1 <>' ' AND CBA_XUSCT2 <>' ' "
				_cQuery += " AND CBA_FILIAL = '"+XFILIAL('CBA')+"'  AND CBA_LOCAL = '"+_cArmazem+"' AND CBA_LOCALI BETWEEN '"+PPF->PPF_LOCDE+"' AND '"+PPF->PPF_LOCATE+"' AND CBA_XROTAT = '1' AND D_E_L_E_T_ = ' '  ORDER BY CBA_PROD,R_E_C_N_O_ " // em sql


			else

				_cQuery := "SELECT NVL(R_E_C_N_O_,0)  AS REG FROM "+retsqlname('CBA')+" WHERE CBA_STATUS = '3' AND CBA_XUSCT3= ' ' AND CBA_XUSCT1 <>'"+__cUserID+"' AND CBA_XUSCT2 <>'"+__cUserID+"' AND CBA_XUSCT1 <>' ' AND CBA_XUSCT2 <>' ' "
				_cQuery += " AND CBA_FILIAL = '"+XFILIAL('CBA')+"'  AND CBA_LOCAL = '"+_cArmazem+"' AND CBA_LOCALI BETWEEN '"+PPF->PPF_LOCDE+"' AND '"+PPF->PPF_LOCATE+"'  AND CBA_XROTAT <> '1' AND D_E_L_E_T_ = ' '  ORDER BY CBA_PROD,R_E_C_N_O_ " // em sql


			endif

		endif

		_cQuery := ChangeQuery(_cQuery)

		TcQuery _cQuery New Alias "QR1"


		if QR1->REG <> 0

			Do while QR1->(!eof())

				Dbselectarea('CBA')
				DbGoto(QR1->REG)

				if _nOpcao == 1
					IF CBA_STATUS <> '0'
						Dbselectarea('CBA')
						Dbskip()
						LOOP
					EndIF
				Else

					IF CBA_STATUS <> '3'
						Dbselectarea('QR1')
						Dbskip()
						LOOP
					Endif

				Endif

				if eof()

					VTAlert("3.Nao existem mais produtos nesta contagem !!!","Aviso",.T.,3000,2)
					VTKeyBoard(chr(20))
					Dbselectarea("QR1")
					DbClosearea('QR1')
					Return .f.

				endif

				VtClear()
				DbSelectarea("SB1")
				Dbseek(Xfilial("SB1")+cba->cba_prod)

				DbSelectarea("CBA")

				_cEnder := space(len(cba->cba_localiz))

				_cConfirma := 'S'

				If VtLastKey() == 27
					Dbselectarea('QR1')
					DbClosearea('QR1')
				Endif

				if _cConfirma ==  'S'
					Dbselectarea('QR1')
					DbClosearea('QR1')
					Exit
				Endif

			Enddo

		else

			VTAlert("4.Nao existem mais produtos nesta contagem !!!","Aviso",.T.,3000,2)
			VTKeyBoard(chr(20))
			Dbselectarea('QR1')
			DbClosearea('QR1')
			Return .f.

		endif

	Endif

	DbSelectarea("SB1")
	Dbseek(Xfilial("SB1")+cba->cba_prod)

	DbSelectarea("CBA")
	_cxprod := cba->cba_prod

	Do While !eof()  .and. cba->cba_prod == _cxprod

		IF ALLTRIM(CBA_LOCAL) == ALLTRIM(_cArmazem)  .AND. CBA->CBA_LOCALI >=  PPF->PPF_LOCDE  .AND. CBA->CBA_LOCALI <=  PPF->PPF_LOCATE

			IF CBA->CBA_STATUS <> '4' .and. CBA->CBA_STATUS <> '5'

				//if _cRotativo == "S" .AND. _nOpcao == 1

				if _cRotativo == "S"

					dbSelectArea("SDC")
					DbOrderNickName("STIVEN02")
					dbGoTop()

					if dbSeek(xFilial("SDC")+CBA->CBA_LOCAL+CBA->CBA_LOCALI+CBA->CBA_PROD)

						WHILE !EOF() .AND. SDC->DC_LOCAL+SDC->DC_LOCALIZ+SDC->DC_PRODUTO == CBA->CBA_LOCAL+CBA->CBA_LOCALI+CBA->CBA_PROD

							dbSelectArea("CB8")
							dbSetOrder(2)
							dbGoTop()

							if dbSeek(xFilial("CB8")+SDC->DC_PEDIDO+SDC->DC_ITEM+SDC->DC_SEQ+SDC->DC_PRODUTO)

								While !eof() .and. CB8->CB8_PEDIDO+CB8->CB8_ITEM+CB8->CB8_SEQUEN+CB8->CB8_PROD == SDC->DC_PEDIDO+SDC->DC_ITEM+SDC->DC_SEQ+SDC->DC_PRODUTO

									if Posicione("CB7",1,xFilial("CB7")+CB8->CB8_ORDSEP,"CB7_STATUS") < "5" .AND. CB8->CB8_LCALIZ = CBA->CBA_LOCALI

										if CB8->CB8_SALDOS = 0
											_nQtdSep += CB8->CB8_QTDORI
										ELSEIF CB8->CB8_SALDOS <> 0
											_nQtdSep += CB8->CB8_QTDORI - CB8->CB8_SALDOS
										ENDIF

									Endif

									dbSelectArea("CB8")
									dbSkip()
								End

							Endif

							dbSelectArea("SDC")
							dbSkip()
						End


					Endif

				Endif

				DbSelectarea("CBA")
				Reclock('CBA',.f.)
				if _nOpcao = 1
					CBA_STATUS := '1'
					CBA->CBA_XUSCT1 := __cUserId
					CBA_XHRIN1		:= Time()
					IF _cRotativo == "S"
						CBA_XQSEP := _nQtdSep
						CBA_XQATU := Posicione("SBF",1,xFilial("SBF")+CBA->CBA_LOCAL+CBA->CBA_LOCALI+CBA->CBA_PROD,"BF_QUANT") - _nQtdSep
						_nQtdSep := 0 //ZERA A VARIAVEL PARA PEGAR O VALOR DO PROXIMO ENDEREวO.
						U_STTRAINV(CBA->CBA_LOCAL,CBA->CBA_LOCALI,"1")
					ENDIF
				elseif _nOpcao = 2
					CBA_STATUS := '1'
					CBA->CBA_XUSCT2 := __cUserId
					CBA->CBA_XHRIN2	:= Time()
					IF _cRotativo == "S"
						CBA_XQSEP2 := _nQtdSep
						CBA_XQATU2 := Posicione("SBF",1,xFilial("SBF")+CBA->CBA_LOCAL+CBA->CBA_LOCALI+CBA->CBA_PROD,"BF_QUANT") - _nQtdSep
						_nQtdSep := 0 //ZERA A VARIAVEL PARA PEGAR O VALOR DO PROXIMO ENDEREวO.
						U_STTRAINV(CBA->CBA_LOCAL,CBA->CBA_LOCALI,"1")
					ENDIF
				else
					CBA_STATUS := '1'
					CBA->CBA_XUSCT3 := __cUserId
					CBA->CBA_XHRIN3	:= Time()
					IF _cRotativo == "S"
						CBA_XQSEP3 := _nQtdSep
						CBA_XQATU3 := Posicione("SBF",1,xFilial("SBF")+CBA->CBA_LOCAL+CBA->CBA_LOCALI+CBA->CBA_PROD,"BF_QUANT") - _nQtdSep
						_nQtdSep   := 0 //ZERA A VARIAVEL PARA PEGAR O VALOR DO PROXIMO ENDEREวO.
						U_STTRAINV(CBA->CBA_LOCAL,CBA->CBA_LOCALI,"1")
					ENDIF
				endif
				Msunlock()



				dbSelectArea('SBF')
				dbSetOrder(1)
				dbSeek(xFilial('SBF')+CBA->CBA_LOCAL+CBA->CBA_LOCALI+CBA->CBA_PROD )

				aadd(_aLe_Sint,{_cxprod,cba->cba_localiz,sbf->bf_quant,cba->(recno()),sbf->(recno())} )

			Endif

		Endif

		dbSelectArea('CBA')
		Dbskip()

	EndDo

	aTelaAux4 := VTSave()

	For _nCount := 1 to len(_aLe_Sint)
		_cProduto 	:= space(48)
		_cEndereco 	:= space(18)
		_nQuant 	:= 0
		_cBalanca 	:= ' '
		_cConfirma	:= ' '
		Do while .t.

			VtClear()

			@ 0,0 VTSay str(_nOpcao,1)+".: " + _aLe_Sint[_ncount,1]
			@ 1,0 VTSay  substr(sb1->B1_desc,01,20)
			//	@ 2,0 VTSay  substr(sb1->B1_desc,21,20) + " Unidade.: " + SB1->B1_UM
			@ 2,0 VTSay  "Unidade.: " + SB1->B1_UM


			@ 3,0 VTSay "Endereco:"  +  _aLe_Sint[_ncount,2]

			@ 4,0 VTSay  "Endereco"
			@ 4,9 VTGet _cEndereco Picture "@!" Valid vldEnd(_aLe_Sint[_ncount,2]) //.OR. VtLastKey() == 27 //alltrim(substr(_cEndereco,3)) == alltrim(_aLe_Sint[_ncount,2])  .or.  alltrim(_cEndereco) == alltrim(_aLe_Sint[_ncount,2])

			@ 5,00 VTSay "Produto"
			@ 5,9 VTGet _cProduto Picture "@!" Valid VldProd(_aLe_Sint[_ncount,1]) //.OR. VtLastKey() == 27

			@ 6,00 VTSay "Qtde: "
			@ 6,8 VTGet _nQuant Picture "@e 99999999.99" //Valid _lok := vldqtde(_aLe_Sint[_ncount,3])
			if alltrim(cFilAnt) <> '02'
				@ 7,00 VTSay "Balanca(S/N):"
				@ 7,15 VTGet _cBalanca Picture "@!" Valid upper(_cBalanca) $ 'SN' //.OR. VtLastKey() == 27
				_cConfirma:='S'
			Else
				@ 7,00 VTSay "Confirma(S/N):"
				@ 7,15 VTGet _cConfirma Picture "@!" Valid upper(_cConfirma) $ 'SN' ///.OR. VtLastKey() == 27
			endif

			VtRead

			If VtLastKey() == 27
				return .f.
			EndIf

			if _cConfirma = 'S'
				exit
			else
				loop
			endif


		Enddo

		VTRestore(,,,,aTelaAux4)

		If VtLastKey() == 27
			return .f.
		EndIf

		dbSelectArea('CBA')
		DbGoto(_aLe_Sint[_ncount,4])

		_cNextDoc := CBProxCod('MV_USUINV')


		// Aglutinar as quantidade pela chave
		_nquant1ct := 0
		if _nopcao == 2
			CBC->(dbSetOrder(1))
			CBC->(dbSeek(xFilial('CBC')+CBB->CBB_NUM))
			_nquant1ct := CBC->CBC_QUANT
		endif

		_nQuant_ok := _nquant

		_lok := .f.
		if _nopcao = 3      // terceira contagem sempre = ok

			_lok := .t.

			if _cBalanca == 'S' .and. _nquant >= _aLe_Sint[_ncount,3] *( 1-(_ntoler/100)) .and. _nquant <= _aLe_Sint[_ncount,3] *( 1+(_ntoler/100))   //1 e 2 -  2% do saldo em endereco pra cima ou pra baixo = ok
				_nQuant_ok := _aLe_Sint[_ncount,3]
			else
				_nQuant_ok := _nquant

			endif

		endif

		If _nopcao = 1
			_nXQSEP := CBA->CBA_XQSEP
		ElseIF _nopcao = 2
			_nXQSEP := CBA->CBA_XQSEP2
		ElseIf _nopcao = 3
			_nXQSEP := CBA->CBA_XQSEP3
		EndiF

		if _nquant == _aLe_Sint[_ncount,3] - _nXQSEP //CBA->CBA_XQSEP // se 1 ou 2 contagem baterem com o estoque por endereco = ok
			_lok := .t.
			_nQuant_ok := _nquant
		endif


		if _cBalanca == 'S' .and. _nquant >= _aLe_Sint[_ncount,3] *( 1-(_ntoler/100)) .and. _nquant <= _aLe_Sint[_ncount,3] *( 1+(_ntoler/100))   //1 e 2 -  2% do saldo em endereco pra cima ou pra baixo = ok
			_lok := .t.
			if _cRotativo == "S"
				_nQuant_ok := _aLe_Sint[_ncount,3]
			ELSE
				_nQuant_ok := _nquant
			Endif
		endif

		if _cBalanca == 'S' .and. _nquant >= CBA->CBA_XQTCT1  *( 1-(_ntoler/100)) .and. _nquant <= CBA->CBA_XQTCT1  *( 1+(_ntoler/100))   // 1 e 2 entre si - 2% pra cima op pra baixo = ok
			_lok := .t.
			_nQuant_ok := iif(_nquant>CBA->CBA_XQTCT1,_nquant,CBA->CBA_XQTCT1)
		endif

		if _nopcao = 2 .and. _nquant == CBA->CBA_XQTCT1 // 1 e 2 contagem batem uma com a outra = ok
			_lok := .t.
			_nQuant_ok := _nquant
		ENDIF

		If _nopcao = 1
			_nXQATU := CBA->CBA_XQATU
		ElseIF _nopcao = 2
			_nXQATU := CBA->CBA_XQATU2
		ElseIf _nopcao = 3
			_nXQATU := CBA->CBA_XQATU3
		EndiF

		IF _cRotativo == "S" .and. _nopcao >= 1 .and. _nopcao <= 2 .and. _nquant == _nXQATU// CBA->CBA_XQATU
			_lok := .t.
			_nQuant_ok := _nquant
		Endif


		dbSelectArea('CBA')
		DbGoto(_aLe_Sint[_ncount,4])

		Reclock("CBB",.T.)
		CBB->CBB_FILIAL := xFilial("CBB")
		CBB->CBB_NUM    := _cNextDoc
		CBB->CBB_CODINV := CBA->CBA_CODINV
		CBB->CBB_USU    := __cUserId
		CBB->CBB_STATUS := "1"
		CBB->(MsUnlock())


		RecLock("CBC",.T.)
		CBC->CBC_FILIAL := xFilial("CBC")
		CBC->CBC_NUM    :=  _cNextDoc
		CBC->CBC_CODINV := CBA->CBA_CODINV
		CBC->CBC_LOCAL  := cba->cba_local
		CBC->CBC_LOCALI := _aLe_Sint[_ncount,2]
		CBC->CBC_COD    := _cProduto
		CBC->CBC_QUANT  := _nQuant
		CBC->CBC_XBALAN := _cBalanca
		if _lok
			CBC->CBC_CONTOK	:= 'S'
		Endif
		CBC->(MsUnlock())


		dbSelectArea('CBA')
		DbGoto(_aLe_Sint[_ncount,4])
		RecLock("CBA",.f.)
		if _lok
			CBA_XBALAN := iif(_cBalanca=='S','1',' ')
			CBA->CBA_STATUS =  '4'
			CBA_XQTOK := _nQuant_ok

			CBA_XQTDAJ := _nQuant_ok - _nXQATU //CBA->CBA_XQATU // Chamado 006515. Robson Mazzarotto
			IF CBA_XROTAT = '1'
				IF CBA_XQTOK = _nXQATU //CBA_XQATU
					CBA->CBA_STATUS =  '5'
				ENDIF
			ENDIF
			IF CBA->CBA_XROTAT = '1'
				IF !U_GeraSB7(CBA->CBA_CODINV,CBA->CBA_PROD) // Chamada da rotina para gerar o SB7 automatico conforme inventario Rotitavo - Robson Mazzarotto
					CBA->CBA_STATUS =  '6'
				ENDIF
			ENDIF
			//U_AcertoInv(CBA->CBA_CODINV) // Chamada da rotina para realizar o ajuste de inventario.

			//StartJob("U_STAINV(CBA->CBA_CODINV)",GetEnvServer(), .F.,,)

		else
			CBA->CBA_STATUS =  '3'
			U_STTRAINV(CBA->CBA_LOCAL,CBA->CBA_LOCALI,"2")
		endif


		DO CASE
			CASE  _NOPCAO == 1

			CBA->CBA_XUSCT1 := __cUserId
			CBA->CBA_XQTCT1 := _nQuant
			CBA->CBA_XHRFI1	:= Time()
			CASE _NOPCAO == 2
			CBA->CBA_XUSCT2 := __cUserId
			CBA->CBA_XQTCT2 := _nQuant
			CBA->CBA_XHRFI2 := Time()
			OTHERWISE
			CBA->CBA_XUSCT3 := __cUserId
			CBA->CBA_XQTCT3 := _nQuant
			CBA->CBA_XHRFI3 := Time()
		ENDCASE
		CBA->(MsUnlock())


	Next _nCount

	VTAlert("Produto inventariado com sucesso!!!","Aviso",.T.,3000,2)
	VTKeyBoard(chr(20))
	If !empty(_nOpcao_old)
		_nOpcao:=_nOpcao_old
		_nOpcao_old:=''
	Endif

Return VtYESNO('Continua Contando?','Aviso',.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPCMEXP12  บAutor  ณMicrosiga           บ Data ณ  29/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function vldprod(_cProd)
	//Local aEti 			:= CBRetEtiEan(_cproduto)

	//_cProduto := aEti[1]

	if  At("|",_cproduto) > 0
		_cProduto := substr(_cproduto,1,At("|",_cproduto)-1)
	endif


	if  At("=",_cproduto) > 0
		_cProduto := substr(_cproduto,1,At("=",_cproduto)-1)
	endif

	if   alltrim(_cProd)  $ _cproduto
		_cProduto := _cProd
	endif


	if   alltrim(SB1->B1_XCODSTE)  $ _cproduto
		_cProduto := _cProd
	endif



	if alltrim(_cproduto) <> alltrim(_cprod)

		VTAlert("Produto Errado!","Aviso",.T.,3000,2)
		_cProduto 	:= space(48)
		VTKeyBoard(chr(20))
		Return .f.

	EndIf
	//@ 5,9 VTSay _cProduto

Return .t.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPCMEXP12  บAutor  ณMicrosiga           บ Data ณ  09/29/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function vldqtde(_nQt)

	if _nquant <> _nqt
		VTAlert("Quantidade Errada!","Aviso",.T.,3000,2)
		VTKeyBoard(chr(20))
		Return .f.
	EndIf

Return .t.





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPCMEXP12  บAutor  ณMicrosiga           บ Data ณ  29/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function vldEnd(_cEnd)


	if alltrim(substr(_cEndereco,3)) <> alltrim(_cEnd)  .AND.  alltrim(_cEndereco) <> alltrim(_cEnd)

		VTAlert("Endereco Errado!","Aviso",.T.,3000,2)
		VTKeyBoard(chr(20))
		_cEndereco 	:= space(18)
		Return .f.

	EndIf

Return .t.





#INCLUDE 'RWMAKE.CH' 
#Include "TbiConn.ch"
#INCLUDE 'APVT100.CH'
#Include "Protheus.ch"
#INCLUDE "Topconn.ch"

/*/{Protheus.doc} ACDINVEX

Inventario Exepedição de Volumes Embalados

@type function
@author Everson Santana
@since 03/12/18
@version Protheus 12 - SigaAcd

@history ,Chamado 008247 ,

/*/

USER FUNCTION ACDINVEX()
	Local aVetor 	:= {}
	Local aCab   	:= {}
	Local aItem  	:= {}
	Local cOrdSep 	:= ""
	Local cVolume 	:= ""
	Local _nQtdVol 	:= 0
	Local _cQry		:= ""

	//VTSIZE 12,30

	do while .t.
		VTCLEAR()
		@ 00,01 VTSAY "Inventario de Volumes       "
		//aTela := VTSave(0,0,2,30)
		aTela := VTSave()
		DO while .t.

			cEti1 := space(34)
			_nQtdVol := 0
			@ 02,01 VTSAY "Volume      "
			@ 03,07 VTGET cEti1 PICTURE "@!"
			@ 04,01 VTSAY "Qtd Volume      "
			@ 05,07 VTGET _nQtdVol PICTURE "@!"

			VTREAD

			if VTLastkey()==27
				IF VTYESNO("Encerra Apontamento?","Atencao!",.T.)
					RETURN .F.
				ENDIF
				VTClear()
				VTRestore(,,,,aTela)
				LOOP
			endif

			/*
			_cQry := " SELECT COUNT(*) QTDVOL FROM "+RetSqlName("CB6")+" CB6 "
			_cQry += " WHERE CB6_XORDSE = '"+cEti1+"' "
			_cQry += " AND CB6_FILIAL = '"+xFilial("CB6")+"' "
			_cQry += " AND D_E_L_E_T_ = ' ' "

			If Select("QRY") > 0
			Dbselectarea("QRY")
			QRY->(DbClosearea())
			EndIf

			TcQuery _cQry New Alias "QRY"

			_nQtdVol := QRY->
			*/
			cEti1:= Alltrim(cEti1)
			If Len(cEti1) > 10 // giovani zago ajuste para a etiqueta tnt 20/02/2020 ticket 20200218000598
				cOrdSep   := SUBSTR(cEti1,11,6)
				cVolume   := SUBSTR(cEti1,11,6)+SUBSTR(cEti1,17,4)
			Else
				cOrdSep   := SUBSTR(cEti1,1,6)
				cVolume   := cEti1
			EndIf

			DBSELECTAREA("CB6")
			DBSETORDER(1)
			DBGOTOP()

			IF !DBSEEK(XFILIAL("CB6")+cVolume)
				VTClear()
				VTALERT("Volume nao Encontrado")
				VTClear()
				exit
			ENDIF

			@ 05,01 VTSAY "    Aguarde Processamento     "

			DBSELECTAREA("Z14")
			DBSETORDER(2)
			DBGOTOP()
			If !DbSeek(xFilial("Z14")+Alltrim(cOrdSep)+Dtos(dDatabase))

				RECLOCK("Z14",.T.)
				FIELD->Z14_FILIAL  := xFilial("Z14")
				FIELD->Z14_ORDSEP  := cOrdSep
				FIELD->Z14_VOLUME  := cVolume
				FIELD->Z14_DTINV   := dDatabase
				FIELD->Z14_QTDVOL  := _nQtdVol
				FIELD->Z14_USR     := RetCodUsr()
				FIELD->Z14_HRINV   := Time()
				MSUNLOCK()

				VTClear()
				VTALERT("Entrada Confirmada")
				VTClear()

				exit

			Else

				VTClear()
				VTALERT("Volume ja registrado!")
				VTClear()
				exit

			EndIf

		end

		VTClear()
		VTRestore(,,,,aTela)

		if VTLastkey()==27
			IF !VTYESNO("Finalizar ?","Atencao!",.T.)
				RETURN .F.
			ENDIF
		endif


	enddo


RETURN .T.




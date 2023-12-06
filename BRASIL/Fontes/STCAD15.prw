#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STCADWF       | Autor | GIOVANI.ZAGO             | Data | 04/10/2018    |
|=====================================================================================|
|Sintaxe   | STCADWF                                                                 |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================
*/
*----------------------------------*
User Function STCADWF()
*----------------------------------*
	Local _aHeader		:= {}
	Local _aCols		:= {}
	Local lSaida   		:= .T.
	Local lConfirma 	:= .F.
	Local nY			:= 0
	Local _nX			:= 0
	Local cAliasSuper	:= 'STWF15'
	Local cQuery     	:= ' '
	Local oDlgEmail
	Local _cVal       	:=  ddatabase
	Local _cCod       	:=  Space(6)
	Local lSaida      	:= .F.
	Local nOpca       	:=  0
 
	
	Local _oWindow,;
		oFontWin,;
		_bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,_oWindow:End()) },;
		_bCancel 	    	:= {||(	lSaida:=.f.,_oWindow:End()) },;
		_aButtons	    	:= {},_oGet

	_cRetorno := ""

	Aadd(_aHeader,{"Mar/Des"							,"MARKBROW"			    ,"@BMP"				,2	  ,0    ,"",,"C",""})
	Aadd(_aHeader,{"Pedido"								,"SEQ"			    	,"@!"				,6	  ,0    ,"",,"C",""})
	Aadd(_aHeader,{"Nome	"							,"ROT"			    	,"@!"				,55	  ,0    ,"",,"C",""})
	Aadd(_aHeader,{"Agendamento	"						,"AGD"			    	,""					,8	  ,0    ,"",,"D",""})
	Aadd(_aHeader,{"Cliente	"							,"COD"			    	,"@!"				,6	  ,0    ,"",,"C",""})


	Do While !lSaida
		nOpca := 0
		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Cliente:") From  1,0 To 80,200 Pixel OF oMainWnd
		
		@ 02,04 SAY "Cliente:" PIXEL OF oDlgEmail
		@ 12,04 MSGet _cCod    Size 55,013    f3 'SA1' PIXEL OF oDlgEmail
		@ 12,62 Button "Ok"      Size 28,13 Action   Iif(!(Empty(Alltrim(_cCod))),Eval({||lSaida:=.T.,nOpca:=1,oDlgEmail:End()}),MsgInfo("Selecione o Cliente!!!!"))  Pixel
		
		ACTIVATE MSDIALOG oDlgEmail CENTERED
	EndDo

	lSaida      	:= .F.
	nOpca       	:=  0
 
	cQuery := " SELECT
	cQuery += " DISTINCT
	cQuery += " C5_XAGENDA,C5_CLIENTE,
	cQuery += "  C5_NUM,C5_XNOME

	cQuery += " FROM SC5010 SC5
	cQuery += " INNER JOIN(SELECT * FROM SA1010)SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " AND A1_COD = C5_CLIENTE
	cQuery += " AND A1_LOJA = C5_LOJACLI
 
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_CLIENTE = '"+_cCod+"'
	cQuery += " AND C5_FILIAL = '02'
	cQuery += " AND EXISTS (SELECT * FROM SC6010 SC6
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_NUM = C5_NUM
	cQuery += " AND C6_QTDVEN > C6_QTDENT
	cQuery += " AND C6_BLQ <> 'R'
	cQuery += " AND C6_FILIAL = C5_FILIAL
	cQuery += " )
	cQuery += " AND NOT EXISTS(SELECT * FROM SD2010 SD2
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND D2_PEDIDO = C5_NUM
	cQuery += " AND D2_FILIAL = C5_FILIAL)

	cQuery += " ORDER BY C5_NUM


	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)
	
	
	
	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
	
		While 	(cAliasSuper)->(!Eof())
		
			AADD(_aCols,Array(Len(_aHeader)+1))

			For nY := 1 To Len(_aHeader)

				DO CASE
				CASE AllTrim(_aHeader[nY][2]) =  "MARKBROW"
					_aCols[Len(_aCols)][nY] := "LBNO"
				CASE AllTrim(_aHeader[nY][2]) =  "SEQ"
					_aCols[Len(_aCols)][nY] := (cAliasSuper)->C5_NUM
				CASE AllTrim(_aHeader[nY][2]) =  "ROT"
					_aCols[Len(_aCols)][nY] := (cAliasSuper)->C5_XNOME
				CASE AllTrim(_aHeader[nY][2]) =  "AGD"
					_aCols[Len(_aCols)][nY] := Stod((cAliasSuper)->C5_XAGENDA)
				CASE AllTrim(_aHeader[nY][2]) =  "COD"
					_aCols[Len(_aCols)][nY] := (cAliasSuper)->C5_CLIENTE
				ENDCASE

			Next

			_aCols[Len(_aCols)][Len(_aHeader)+1] := .F.

			(cAliasSuper)->(dbskip())
			
		End
	 
	EndIf
		
	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf
	

	
	

	DEFINE MSDIALOG _oWindow FROM 0,0 TO 300,800/*500,1200*/ TITLE Alltrim(OemToAnsi('Selecionar Agendamento')) Pixel //430,531
	_oGet1	:= MsNewGetDados():New(030,000,_oWindow:nClientHeight/2-5,_oWindow:nClientWidth/2-5,GD_UPDATE,,,,{'MARKBROW'},,Len(_aCols),,,,_oWindow,_aHeader,_aCols)
	bDbClick := _oGet1:oBrowse:bLDblClick
	_oGet1:oBrowse:bLDblClick := {|| (Iif(_oGet1:aCols[_oGet1:nAt,1]=="LBNO",_oGet1:aCols[_oGet1:nAt,1]:="LBOK",_oGet1:aCols[_oGet1:nAt,1]:="LBNO"),_oGet1:oBrowse:Refresh(),"")}
	_oGet1:SetArray(_aCols)
	ACTIVATE MSDIALOG _oWindow CENTERED ON INIT EnchoiceBar(_oWindow,_bOk,_bCancel,,_aButtons)

	If lConfirma
 
	
		Do While !lSaida
			nOpca := 0
			DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Data Agendamento") From  1,0 To 80,200 Pixel OF oMainWnd
		
			@ 02,04 SAY "Data:" PIXEL OF oDlgEmail
			@ 12,04 MSGet _cVal    Size 55,013  PIXEL OF oDlgEmail
			@ 12,62 Button "Ok"      Size 28,13 Action  Eval({||lSaida:=.T.,nOpca:=1,oDlgEmail:End()})  Pixel
		
			ACTIVATE MSDIALOG oDlgEmail CENTERED
		EndDo
	
		For _nX:=1 To Len(_oGet1:aCols)
			If _oGet1:aCols[_nX][1]=="LBOK"
			
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				SC5->(DbSeek(xFilial("SC5")+_oGet1:aCols[_nX][2]))
				
				Reclock("SC5",.F.)
				SC5->C5_XAGENDA:= _cVal
				SC5->(MsUnLock())
				SC5->( DbCommit() )
				
			EndIf
		Next _nX

		MsgInfo("Alteração Finalizada......!!!!!!")
	EndIf

 

Return

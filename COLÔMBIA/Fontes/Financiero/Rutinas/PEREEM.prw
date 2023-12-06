#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "color.ch"

#IFNDEF CRLF
#DEFINE CRLF (Chr(13)+Chr(10))
#ENDIF 

/*---------------------------------------------------------------------------------------------------------------------------*
| P.E.:  MATA070                                                                                                            |
| Desc:  Ponto de entrada MVC no cadastro de Bancos                                                                         |
| Obs.:  Ao criar um P.E. em MVC com o mesmo nome do ModelDef, deixe o nome do prw com outro nome, por exemplo,             |
|        MATAXXX_pe.prw                                                                                                     |
| Ref.:  http://tdn.totvs.com/display/public/mp/Pontos+de+Entrada+para+fontes+Advpl+desenvolvidos+utilizando+o+conceito+MVC |
*---------------------------------------------------------------------------------------------------------------------------*/


User Function PEREEM(oModel)

	Local xRet      := .T.
	Local _lCont	:= .F.
	Local _cQry 	:= ""
	Local _stru		:={}
	Local aCpoBro 	:= {}
	Local oDlg
	Local aCores 	:= {}
	Local nOpcA 	:= 0
	Local _nVlrAdan := 0 
	Local _cTitulo  := ""
	Private lInverte := .F.
	Private cMark   := GetMark()   
	Private oMark

	If INCLUI

		If Select("TRD") > 0
			TRD->(DbCloseArea())
		Endif

		_cQry := " "
		_cQry += " SELECT SE2.E2_PREFIXO,SE2.E2_TIPO,SE2.E2_NUM,SE2.E2_VALOR,SE2.E2_SALDO,Z1O_USER,SE2.E2_NUM,Z1O.Z1O_NUM,Z1O_STATUS,E2_FILIAL "
		_cQry += " FROM "+RetSqlName("Z1O")+" Z1O "
		_cQry += " INNER JOIN "+RetSqlName("SE2")+" SE2 "
		_cQry += " ON SE2.E2_NUM = Z1O.Z1O_NUM "   
		_cQry += " AND SE2.E2_SALDO > 0 "
		_cQry += " AND SE2.E2_TIPO = 'PA' "
		_cQry += " AND SE2.D_E_L_E_T_ = ' ' "
		_cQry += " WHERE Z1O_USER = '"+__cUserId+"' "
		_cQry += " AND Z1O.D_E_L_E_T_ = ' ' "

		TcQuery _cQry New Alias "TRD"

		DbSelectArea("TRD")
		DbGotop()

		If !Empty(TRD->Z1O_NUM)

			_lCont := MSGYESNO( "Existem Adiantamentos em aberto."+CRLF+CRLF+" Deseja fazer a prestação de contas?",'Atenção' )


		EndIf 

		If _lCont

			oModel:SetValue( 'Z1O', 'Z1O_PC', '1' )

			//Cria um arquivo de Apoio

			AADD(_stru,{"OK"     ,"C"	,2		,0		})
			AADD(_stru,{"PREFIXO","C"	,3		,0		})
			AADD(_stru,{"TIPO"   ,"C"	,2		,0		})
			AADD(_stru,{"TITULO" ,"C"	,9		,0		})
			AADD(_stru,{"VALOR"  ,"N"	,17		,2		})
			AADD(_stru,{"SALDO"  ,"N"	,17		,2		})

			cArq:=Criatrab(_stru,.T.)
			DBUSEAREA(.t.,,carq,"TTRB")//Alimenta o arquivo de apoio com os registros do cadastro de clientes (SA1)

			DbSelectArea("TRD")
			DbGotop()

			While !EOF()

				DbSelectArea("TTRB")	
				RecLock("TTRB",.T.)		

				TTRB->PREFIXO := TRD->E2_PREFIXO		
				TTRB->TIPO    := TRD->E2_TIPO		
				TTRB->TITULO  := TRD->E2_NUM		
				TTRB->VALOR	  := TRD->E2_VALOR		
				TTRB->SALDO   := TRD->E2_SALDO

				MsunLock()

				DbSelectArea("TRD")
				DbSkip()

			End

			aCpoBro	:= {{ "OK"			,, "Mark"       ,"@!"},;			
			{ "PREFIXO"		,, "Prefixo"    ,"@!"},;			
			{ "TIPO"		,, "Tipo"       ,"@!"},;			
			{ "TITULO"		,, "Titulo"     ,"@!"},;			
			{ "VALOR"		,, "Valor"   	,"@E 999,999,999.99"},;			
			{ "SALDO"		,, "Saldo"      ,"@E 999,999,999.99"}}

			DEFINE MSDIALOG oDlg TITLE "MarkBrowse c/Refresh" From 9,0 To 315,800 PIXEL
			DbSelectArea("TTRB")
			DbGotop()
			//Cria a MsSelect

			oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{37,1,150,400},,,,,)
			oMark:bMark := {| | Disp()} 
			//Exibe a Dialog

			ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA := 1 , oDlg:End()},{|| oDlg:End()})

			//Fecha a Area e elimina os arquivos de apoio criados em disco.

			If  nOpcA == 1

				DbSelectArea("TTRB")
				DbGotop()

				_nVlrAdan := 0 
				_cTitulo  := ""
				
				While !EOF() .and. !Empty(TTRB->OK)

					_nVlrAdan += TTRB->SALDO
					_cTitulo  += TTRB->TITULO+"/"
					
					
					DbSelectArea("TTRB")
					DbSkip()

				End

				oModel:SetValue( 'Z1O', 'Z1O_NUMPC', SubStr(_cTitulo,1,50) )
				oModel:SetValue( 'Z1O', 'Z1O_VALOR', _nVlrAdan )
				
			EndIF

			TTRB->(DbCloseArea())
			Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)

		EndIf

	EndIF

Return xRet

//Funcao executada ao Marcar/Desmarcar um registro.   

Static Function Disp()

	RecLock("TTRB",.F.)

	If Marked("OK")	
		TTRB->OK := cMark

	Else	
		TTRB->OK := ""

	Endif             

	MSUNLOCK()

	oMark:oBrowse:Refresh()

Return()

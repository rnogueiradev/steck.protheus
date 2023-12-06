#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT230        | Autor | RENATO.OLIVEIRA           | Data | 14/10/2019  |
|=====================================================================================|
|Descrição | Tela para cadastro de recursos				                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT230()

	Local oBrowse
	Private aRotina 	:= MenuDef()
	Private _cQuery1 := ""
	Private _cAlias1 := GetNextAlias()

	DbSelectArea("Z50")
	Z50->(DbSetOrder(1))

	U_STFAT232()

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Cadastro de recursos")
	oBrowse1:SetAlias("Z50")

	oBrowse1:SetUseCursor(.F.)

	oBrowse1:Activate()

Return()

/*/{Protheus.doc} MenuDef
@name MenuDef
@type Static Function
@desc monta menu principal
@author Renato Nogueira
@since 09/01/2017
/*/

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar"  				ACTION "AxPesqui"        	OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STFAT230" 	OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    				ACTION "VIEWDEF.STFAT230" 	OPERATION 4  ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    				ACTION "VIEWDEF.STFAT230" 	OPERATION 5  ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    				ACTION "VIEWDEF.STFAT230" 	OPERATION 3  ACCESS 0
	ADD OPTION aRotina TITLE "Alocar"    				ACTION "U_STFAT233" 		OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Atualizar"				ACTION "U_STFAT235" 		OPERATION 3  ACCESS 0
	ADD OPTION aRotina TITLE "Ajuste hora final"		ACTION "U_STFAT236" 		OPERATION 3  ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc montar model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'Z50')
	Local _aRel	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)

	oModel:SetPrimaryKey({})

	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')

Return oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc montar view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView:= NIL
	Local oStr1:= FWFormStruct(2, 'Z50')
	Local oModel     := FWLoadModel("STFAT230")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )

	oView:CreateHorizontalBox( 'BOXFORM1', 100)

	oView:SetOwnerView('FORM1','BOXFORM1')

	oView:EnableTitleView('FORM1','Cabeçalho')

	oView:EnableControlBar(.T.)

	oView:SetCloseOnOk({|| .T.})

Return oView

/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc validar alteração do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet				:= .T.
	Local nOp         		:= oModel:GetOperation()

Return(_lRet)

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc validar tudo ok do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet				:= .T.
	Local nOp         		:= oModel:GetOperation()

	If nOp==3 .Or. nOp==4
	
		_cUltHr := U_STFAT238(M->Z50_FUNC,M->Z50_DATA)
		
		If _cUltHr>M->Z50_HRINI
			MsgAlert("Atenção, a última hora final deste funcionário nesta data foi "+_cUltHr+" não será possível cadastrar essa hora inicial, verifique!")
			_lRet := .F.
		EndIf
	
	EndIf

Return(_lRet)

/*/{Protheus.doc} VLDLIN
@name VLDLIN
@type Static Function
@desc validar troca de linha do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDLIN(oModel,nLine)

	Local _lRet	:= .T.

Return(_lRet)

/*/{Protheus.doc} GrvTOK
@name GrvTOK
@type Static Function
@desc realiza gravação dos dados
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GrvTOK( oModel )

	Local lGrv				:= .T.
	Local nOp         		:= oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv

/*/{Protheus.doc} STFAT231
@name STFAT231
@type User Function
@desc consulta padrao func
@author Renato Nogueira
@since 14/10/2019
/*/

User Function STFAT231()

	Local aGetArea 	:= GetArea()
	Local oBrowCons
	Local aCampos 	:= {}
	Local lOpc		:= .F.
	Local aInd		:= {}
	Local cGet		:= Space(30)

	Aadd(aCampos,{"RA_MAT"  , "Código" 	, "@!" , "C", 06, 0})
	Aadd(aCampos,{"RA_NOME" , "Nome" 	, "@!" , "C", 30, 0})

	cCondicao:= "Empty(SRA->RA_DEMISSA) .And. SRA->RA_DEPTO $ '"+GetMv("ST_DEPCD",,"000000205")+"' "

	bFiltraBrw := {|| FilBrowse("SRA",@aInd,@cCondicao) }
	Eval(bFiltraBrw)

	@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Funcionários"
	@ 006, 005 TO 190, 370 BROWSE "SRA" FIELDS aCampos OBJECT oBrowCons

	@ 200, 120 GET cGet picture "@!" SIZE 60,30
	@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
	@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)

	oDlgPrd:lCentered := .t.
	oDlgPrd:Activate()

	SRA->(DbClearFilter())

Return(lOpc)

/*/{Protheus.doc} STFAT232
@name STFAT232
@type User Function
@desc inicia alocações do dia e mata os que estiverem em aberto de dias anteriores
@author Renato Nogueira
@since 14/10/2019
/*/

User Function STFAT232()

	Local _cHrIni1 	:= "07:00"
	Local _cHrFim1 	:= "12:00"
	Local _cHrAlmI 	:= "12:00"
	Local _cHrAlmF 	:= "13:00"	
	Local _cHrIni2 	:= "13:00"
	Local _cHrFim2 	:= "17:00"
	Local _cQuery3  := ""
	Local _cAlias3  := GetNextAlias()
	Local _cQuery4  := ""
	Local _cAlias4  := GetNextAlias()

	DbSelectArea("Z53")
	Z53->(DbSetOrder(1))
	If Z53->(DbSeek(xFilial("Z53")+DTOS(dDataBase)))
		_cHrIni2 := Z53->Z53_HRINI
		_cHrFim2 := Z53->Z53_HRFIM
	EndIf
	
	If Val(SubStr(_cHrIni2,1,2))<7
		_cHrIni2 := "07:00"
	EndIf

	U_STFAT234()
	
	//2 - Z50_FILIAL+Z50_FUNC+Z50_DATA+Z50_HRINI
	//3 - Z50_FILIAL+Z50_FUNC+Z50_DATA+Z50_HRFIM

	While (_cAlias1)->(!Eof())
	
		_lFaltou := .F.
	
		_cQuery4 := " SELECT *
		_cQuery4 += " FROM "+RetSqlName("Z50")+" Z50
		_cQuery4 += " WHERE Z50.D_E_L_E_T_=' ' AND Z50_FILIAL='"+xFilial("Z50")+"'
		_cQuery4 += " AND Z50_DATA='"+DTOS(dDataBase)+"' AND Z50_NSETOR IN ('FALTOU','FERIAS','AFASTADO')
		_cQuery4 += " AND Z50_FUNC='"+(_cAlias1)->RA_MAT+"'
		
		If !Empty(Select(_cAlias4))
			DbSelectArea(_cAlias4)
			(_cAlias4)->(dbCloseArea())
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery4),_cAlias4,.T.,.T.)
		
		dbSelectArea(_cAlias4)
		(_cAlias4)->(dbGoTop())
		
		If (_cAlias4)->(!Eof())
			_lFaltou := .T.
		EndIf

		If Val(SubStr(Time(),1,2))>=12
		
			//Finalizar alocações antes do almoço que estivem abertas
			_cQuery3 := " SELECT *
			_cQuery3 += " FROM "+RetSqlName("Z50")+" Z50
			_cQuery3 += " WHERE Z50.D_E_L_E_T_=' ' AND Z50_FILIAL='"+xFilial("Z50")+"'
			_cQuery3 += " AND Z50_DATA='"+DTOS(dDataBase)+"' AND Z50_HRINI<'"+_cHrAlmI+"' AND Z50_HRFIM=' '
			_cQuery3 += " AND Z50_FUNC='"+(_cAlias1)->RA_MAT+"'
		
			If !Empty(Select(_cAlias3))
				DbSelectArea(_cAlias3)
				(_cAlias3)->(dbCloseArea())
			Endif
		
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)
		
			dbSelectArea(_cAlias3)
			(_cAlias3)->(dbGoTop())
		
			While (_cAlias3)->(!Eof())
			
				Z50->(DbGoTo((_cAlias3)->R_E_C_N_O_))
				If Z50->(!Eof())
					Z50->(RecLock("Z50",.F.))
					Z50->Z50_HRFIM := "12:00"
					Z50->Z50_TOTHR := ElapTime(Z50->Z50_HRINI+":00",Z50->Z50_HRFIM+":00")
					If _lFaltou
						Z50->Z50_HRFIM := "17:00"
						Z50->Z50_TOTHR := ElapTime(Z50->Z50_HRINI+":00",Z50->Z50_HRFIM+":00")
					EndIf
					Z50->(MsUnLock())
				EndIf
			
				(_cAlias3)->(DbSkip())
			EndDo
			
			Z50->(DbSetOrder(2))
			If !_lFaltou				
				If !Z50->(DbSeek(xFilial("Z50")+(_cAlias1)->RA_MAT+DTOS(dDataBase)+_cHrAlmI))
					Z50->(RecLock("Z50",.T.))
					Z50->Z50_FILIAL := xFilial("Z50")
					Z50->Z50_FUNC   := (_cAlias1)->RA_MAT
					Z50->Z50_NFUNC  := (_cAlias1)->RA_NOME
					Z50->Z50_SETOR  := "016"
					Z50->Z50_NSETOR := "ALMOCO"
					Z50->Z50_DATA   := dDataBase
					Z50->Z50_HRINI	:= _cHrAlmI
					Z50->Z50_HRFIM	:= _cHrAlmF
					Z50->Z50_TOTHR	:= "01:00"
					Z50->(MsUnLock())
					
					Z50->(RecLock("Z50",.F.))
					Z50->Z50_USERGI	:= ""
					Z50->(MsUnLock())
					
				EndIf		
				If !Z50->(DbSeek(xFilial("Z50")+(_cAlias1)->RA_MAT+DTOS(dDataBase)+_cHrAlmF))
					Z50->(RecLock("Z50",.T.))
					Z50->Z50_FILIAL := xFilial("Z50")
					Z50->Z50_FUNC   := (_cAlias1)->RA_MAT
					Z50->Z50_NFUNC  := (_cAlias1)->RA_NOME
					Z50->Z50_SETOR  := "000"
					Z50->Z50_NSETOR := "SEM SETOR"
					Z50->Z50_DATA   := dDataBase
					Z50->Z50_HRINI	:= _cHrAlmF
					Z50->(MsUnLock())

					Z50->(RecLock("Z50",.F.))
					Z50->Z50_USERGI	:= ""
					Z50->(MsUnLock())

				EndIf
			EndIf
		Else
			Z50->(DbSetOrder(2))
			If !Z50->(DbSeek(xFilial("Z50")+(_cAlias1)->RA_MAT+DTOS(dDataBase)+_cHrIni1))
				Z50->(RecLock("Z50",.T.))
				Z50->Z50_FILIAL := xFilial("Z50")
				Z50->Z50_FUNC   := (_cAlias1)->RA_MAT
				Z50->Z50_NFUNC  := (_cAlias1)->RA_NOME
				Z50->Z50_SETOR  := "000"
				Z50->Z50_NSETOR := "SEM SETOR"
				Z50->Z50_DATA   := dDataBase
				Z50->Z50_HRINI	:= _cHrIni1
				Z50->(MsUnLock())

				Z50->(RecLock("Z50",.F.))
				Z50->Z50_USERGI	:= ""
				Z50->(MsUnLock())

			EndIf
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo 

	//Finalizar os dias anteriores em aberto
	_cQuery3 := " SELECT *
	_cQuery3 += " FROM "+RetSqlName("Z50")+" Z50
	_cQuery3 += " WHERE Z50.D_E_L_E_T_=' ' AND Z50_FILIAL='"+xFilial("Z50")+"'
	_cQuery3 += " AND Z50_DATA<'"+DTOS(dDataBase)+"' AND Z50_HRFIM=' '

	If !Empty(Select(_cAlias3))
		DbSelectArea(_cAlias3)
		(_cAlias3)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

	dbSelectArea(_cAlias3)
	(_cAlias3)->(dbGoTop())

	While (_cAlias3)->(!Eof())

		Z50->(DbGoTo((_cAlias3)->R_E_C_N_O_))
		If Z50->(!Eof())

			Z50->(RecLock("Z50",.F.))
			If Z53->(DbSeek(xFilial("Z53")+DTOS(Z50->Z50_DATA)))
				Z50->Z50_HRFIM := Z53->Z53_HRFIM
			Else
				Z50->Z50_HRFIM := "17:00"
			EndIf
			Z50->Z50_TOTHR := ElapTime(Z50->Z50_HRINI+":00",Z50->Z50_HRFIM+":00")
			Z50->(MsUnLock())

		EndIf

		(_cAlias3)->(DbSkip())
	EndDo	

Return()

/*/{Protheus.doc} STFAT233
@name STFAT233
@type User Function
@desc realiza alocações manualmente
@author Renato Nogueira
@since 14/10/2019
/*/

User Function STFAT233()

	Local _aCampos 	:={}
	Local oDlg
	Local aButtons  := {}
	Local _aRet 	:= {}
	Local _aParamBox:= {}
	Local _cQuery2  := ""
	Local _cAlias2  := GetNextAlias()
	Local cAlias 	:= ""
	Local oTable
	Local cArq 		:= ""
	Private lInverte:= .F.
	Private oMark
	Private cMark   := GetMark()

	AADD(_aCampos,{"OK"     		,"C"	,02		,0		})
	AADD(_aCampos,{"MATRICULA" 	,"C"	,06		,0		})
	AADD(_aCampos,{"NOME"			,"C"	,30		,0		})
	
	If !Empty(Select("TRB"))
		DbSelectArea("TRB")
		("TRB")->(dbCloseArea())
		oTable:Delete()
	Endif

	//cArq := Criatrab(_aCampos,.T.) //Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("TRB") //adicionado\Ajustado
	oTable:SetFields(_aCampos)				//adicionado\Ajustado
	oTable:Create()							//adicionado\Ajustado
	cAlias	:= oTable:GetAlias()			//adicionado\Ajustado
	cArq	:= oTable:GetRealName()			//adicionado\Ajustado
	DbUseArea(.t.,"topconn",cArq,cAlias)

	U_STFAT234()

	DbSelectArea("TRB")

	While (_cAlias1)->(!Eof())

		TRB->(RecLock("TRB",.T.))
		TRB->MATRICULA 	:= (_cAlias1)->RA_MAT
		TRB->NOME 		:= (_cAlias1)->RA_NOME
		TRB->(MsUnLock())

		(_cAlias1)->(DbSkip())
	EndDo

	aCores := {}

	aCpoBro	:= {{ "OK"				,, ""           ,"@!"},;
	{ 			  "MATRICULA"		,, "Matricula"  ,"@!"},;
	{ 			  "NOME"			,, "Nome" 		,"@!"}}

	DEFINE MSDIALOG oDlg TITLE "Selecione os funcionários" From 09,0 To 315,800 PIXEL

	DbSelectArea("TRB")
	TRB->(DbGotop())

	oMark := MsSelect():New("TRB","OK","",aCpoBro,@lInverte,@cMark,{37,1,150,400},,,,,aCores)
	oMark:bMark := {|| STMARK() }
	oMark:oBrowse:lCanAllmark := .T.  
	oMark:oBrowse:bAllMark := { || Inverte(cMark)}

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()},,@aButtons)

	DbSelectArea("TRB")
	TRB->(DbGotop())

	AADD(_aParamBox,{1,"Setor",Space(3) ,"","","X5_H","",0,.T.})

	If !ParamBox(_aParamBox,"Definição de setor",@_aRet,,,.T.,,500)
		Return
	EndIf

	Z50->(DbSetOrder(2))

	While TRB->(!Eof())

		If !Empty(TRB->OK)

			_cQuery2 := " SELECT *
			_cQuery2 += " FROM "+RetSqlName("Z50")+" Z50
			_cQuery2 += " WHERE Z50.D_E_L_E_T_=' ' AND Z50_FILIAL='"+xFilial("Z50")+"'
			_cQuery2 += " AND Z50_FUNC='"+TRB->MATRICULA+"' AND Z50_DATA='"+DTOS(dDataBase)+"'
			_cQuery2 += " AND Z50_HRFIM=' ' AND Z50_HRINI<'"+SubStr(Time(),1,6)+"'

			If !Empty(Select(_cAlias2))
				DbSelectArea(_cAlias2)
				(_cAlias2)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

			dbSelectArea(_cAlias2)
			(_cAlias2)->(dbGoTop())

			While (_cAlias2)->(!Eof())

				Z50->(DbGoTo((_cAlias2)->R_E_C_N_O_))
				If Z50->(!Eof())
					Z50->(RecLock("Z50",.F.))
					Z50->Z50_HRFIM := Time()
					Z50->Z50_TOTHR := ElapTime(Z50->Z50_HRINI+":00",Z50->Z50_HRFIM+":00")
					Z50->(MsUnLock())
				EndIf

				_cHrIniM := SubStr(Time(),1,5)
				If Val(SubStr(_cHrIniM,1,2))<7
					_cHrIniM := "07:00"
				EndIf
				
				If U_STFAT237(TRB->MATRICULA,dDataBase,_cHrIniM)
				
					Z50->(RecLock("Z50",.T.))
					Z50->Z50_FILIAL := xFilial("Z50")
					Z50->Z50_FUNC   := TRB->MATRICULA
					Z50->Z50_NFUNC  := TRB->NOME
					Z50->Z50_SETOR  := MV_PAR01
					Z50->Z50_NSETOR := Posicione("SX5",1,xFilial("SX5")+"_H"+MV_PAR01,"X5_DESCRI")
					Z50->Z50_DATA   := dDataBase
					Z50->Z50_HRINI	:= _cHrIniM
					Z50->(MsUnLock())
				
				EndIf

				(_cAlias2)->(DbSkip())
			EndDo

		EndIf

		TRB->(DbSkip())
	Enddo

	//Fecha a Area e elimina os arquivos de apoio criados em disco.
	TRB->(DbCloseArea())

	Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)

Return()

/*/{Protheus.doc} STFAT234
@name STFAT234
@type User Function
@desc carrega funcionarios
@author Renato Nogueira
@since 14/10/2019
/*/

User Function STFAT234()

	Local _aDeptos	:= {}
	Local _nX 		:= 0

	_aDeptos := StrTokArr(GetMv("ST_DEPCD",,"000000205"),"#")

	_cQuery1 := " SELECT RA_MAT, RA_NOME
	_cQuery1 += " FROM "+RetSqlName("SRA")+" RA
	_cQuery1 += " LEFT JOIN "+RetSqlName("Z57")+" Z57
	_cQuery1 += " ON RA_FILIAL=Z57_FILIAL AND RA_NOME=Z57_NOME AND Z57.D_E_L_E_T_=' ' 
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RA_DEMISSA=' ' AND Z57_NOME IS NULL AND RA_FILIAL='"+xFilial("SRA")+"'
	_cQuery1 += " AND (

	For _nX:=1 To Len(_aDeptos)
		_cQuery1 += " RA_DEPTO='"+_aDeptos[_nX]+"'
		If !(_nX==Len(_aDeptos))
			_cQuery1 += " OR
		EndIf
	Next

	_cQuery1 += " )
	_cQuery1 += " ORDER BY RA_MAT

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

Return()

/*/{Protheus.doc} STMARK
@name STMARK
@type User Function
@desc marcar
@author Renato Nogueira
@since 14/10/2019
/*/

Static Function STMARK()

	TRB->(RecLock("TRB",.F.))

	If Marked("OK")
		TRB->OK := cMark
	Else
		TRB->OK := ""
	Endif
	TRB->(MsUnLock())

	oMark:oBrowse:Refresh()

Return()


/*/{Protheus.doc} Inverte
@name Inverte
@type Static Function
@desc marcar
@author Renato Nogueira
@since 14/10/2019
/*/

Static Function Inverte(cMark)

	TRB->(DbGoTop())
	While TRB->(!Eof())

		TRB->(RecLock("TRB",.F.))

		If TRB->OK == cMark
			TRB->OK := ""
		Else
			TRB->OK := cMark
		Endif
		
		TRB->(MsUnLock())

		TRB->(DbSkip())
	EndDo

	oMark:oBrowse:Refresh()

Return()

/*/{Protheus.doc} STFAT235
@name STFAT235
@type User Function
@desc atualizar
@author Renato Nogueira
@since 14/10/2019
/*/

User Function STFAT235()

	U_STFAT232()
	
	MsgAlert("Atualização finalizada!")

Return()

/*/{Protheus.doc} STFAT236
@name STFAT236
@type User Function
@desc ajuste massivo
@author Renato Nogueira
@since 14/10/2019
/*/

User Function STFAT236()

	Local _aCampos 	:={}
	Local oDlg
	Local aButtons  := {}
	Local _aRet 	:= {}
	Local _aParamBox:= {}
	Local _cQuery2  := ""
	Local _cAlias2  := GetNextAlias()
	Local oTable
	Local cAlias 	:= ""
	Local cArq 		:= ""
	Private lInverte:= .F.
	Private oMark
	Private cMark   := GetMark()

	AADD(_aCampos,{"OK"     		,"C"	,02		,0		})
	AADD(_aCampos,{"MATRICULA" 	,"C"	,06		,0		})
	AADD(_aCampos,{"NOME"			,"C"	,30		,0		})
	
	If !Empty(Select("TRB"))
		DbSelectArea("TRB")
		("TRB")->(dbCloseArea())
		oTable:Delete()
	Endif

	//cArq := Criatrab(_aCampos,.T.) 		//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("TRB") //adicionado\Ajustado
	oTable:SetFields(_aCampos)				//adicionado\Ajustado
	oTable:Create()							//adicionado\Ajustado
	cAlias	:= oTable:GetAlias()			//adicionado\Ajustado
	cArq	:= oTable:GetRealName()			//adicionado\Ajustado
	DbUseArea(.t.,"topconn",cArq,cAlias)

	U_STFAT234()

	DbSelectArea("TRB")

	While (_cAlias1)->(!Eof())

		TRB->(RecLock("TRB",.T.))
		TRB->MATRICULA 	:= (_cAlias1)->RA_MAT
		TRB->NOME 		:= (_cAlias1)->RA_NOME
		TRB->(MsUnLock())

		(_cAlias1)->(DbSkip())
	EndDo

	aCores := {}

	aCpoBro	:= {{ "OK"				,, ""           ,"@!"},;
	{ 			  "MATRICULA"		,, "Matricula"  ,"@!"},;
	{ 			  "NOME"			,, "Nome" 		,"@!"}}

	DEFINE MSDIALOG oDlg TITLE "Selecione os funcionários" From 09,0 To 315,800 PIXEL

	DbSelectArea("TRB")
	TRB->(DbGotop())

	oMark := MsSelect():New("TRB","OK","",aCpoBro,@lInverte,@cMark,{37,1,150,400},,,,,aCores)
	oMark:bMark := {|| STMARK() }
	oMark:oBrowse:lCanAllmark := .T.  
	oMark:oBrowse:bAllMark := { || Inverte(cMark)}

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()},,@aButtons)

	DbSelectArea("TRB")
	TRB->(DbGotop())

	AADD(_aParamBox,{1,"Data",Date() ,"@D","","","",0,.T.})
	AADD(_aParamBox,{1,"Hr final atual",Space(5) ,"99:99","","","",0,.T.})
	AADD(_aParamBox,{1,"Hr final nova" ,Space(5) ,"99:99","","","",0,.T.})

	If !ParamBox(_aParamBox,"Ajustar",@_aRet,,,.T.,,500)
		Return
	EndIf

	Z50->(DbSetOrder(2))
	
	While TRB->(!Eof())

		If !Empty(TRB->OK)

			_cQuery2 := " SELECT *
			_cQuery2 += " FROM "+RetSqlName("Z50")+" Z50
			_cQuery2 += " WHERE Z50.D_E_L_E_T_=' ' AND Z50_FILIAL='"+xFilial("Z50")+"'
			_cQuery2 += " AND Z50_FUNC='"+TRB->MATRICULA+"' AND Z50_DATA='"+DTOS(MV_PAR01)+"'
			_cQuery2 += " AND Z50_HRFIM='"+MV_PAR02+"'

			If !Empty(Select(_cAlias2))
				DbSelectArea(_cAlias2)
				(_cAlias2)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

			dbSelectArea(_cAlias2)
			(_cAlias2)->(dbGoTop())

			While (_cAlias2)->(!Eof())

				Z50->(DbGoTo((_cAlias2)->R_E_C_N_O_))
				If Z50->(!Eof())
					Z50->(RecLock("Z50",.F.))
					Z50->Z50_HRFIM := MV_PAR03
					Z50->Z50_TOTHR := ElapTime(Z50->Z50_HRINI+":00",Z50->Z50_HRFIM+":00")
					Z50->(MsUnLock())
				EndIf

				(_cAlias2)->(DbSkip())
			EndDo

		EndIf

		TRB->(DbSkip())
	Enddo

	//Fecha a Area e elimina os arquivos de apoio criados em disco.
	TRB->(DbCloseArea())

	Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)
	
	MsgAlert("Ajustes finalizados com sucesso!")

Return

/*/{Protheus.doc} STFAT237
@name STFAT237
@type User Function
@desc 
@author Renato Nogueira
@since 14/10/2019
/*/

User Function STFAT237(_cMat,_dData,_cHrIni)

	Local _lRet 	:= .T.
	Local _cQuery5 	:= ""
	Local _cAlias5	:= GetNextAlias()

	_cQuery5 := " SELECT COUNT(*) QTD
	_cQuery5 += " FROM "+RetSqlName("Z50")+" Z50
	_cQuery5 += " WHERE Z50.D_E_L_E_T_=' ' AND Z50_FILIAL='"+xFilial("Z50")+"'
	_cQuery5 += " AND Z50_FUNC='"+_cMat+"' AND Z50_DATA='"+DTOS(_dData)+"'
	_cQuery5 += " AND Z50_HRFIM>'"+_cHrIni+"'

	If !Empty(Select(_cAlias5))
		DbSelectArea(_cAlias5)
		(_cAlias5)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery5),_cAlias5,.T.,.T.)

	dbSelectArea(_cAlias5)
	(_cAlias5)->(dbGoTop())

	If (_cAlias5)->QTD>0
		_lRet := .F.
	EndIf

Return(_lRet)

/*/{Protheus.doc} STFAT238
@name STFAT238
@type User Function
@desc 
@author Renato Nogueira
@since 14/10/2019
/*/

User Function STFAT238(_cMat,_dData)

	Local _cUltHr:= ""
	Local _cQuery6 	:= ""
	Local _cAlias6	:= GetNextAlias()
	
	_cQuery6 := " SELECT Z50_HRFIM
	_cQuery6 += " FROM "+RetSqlName("Z50")+" Z50
	_cQuery6 += " WHERE Z50.D_E_L_E_T_=' ' AND Z50_FILIAL='"+xFilial("Z50")+"' 
	_cQuery6 += " AND Z50_FUNC='"+_cMat+"' AND Z50_DATA='"+DTOS(_dData)+"' AND Z50_HRFIM<>' '
	_cQuery6 += " ORDER BY Z50_HRFIM DESC
	
	If !Empty(Select(_cAlias6))
		DbSelectArea(_cAlias6)
		(_cAlias6)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery6),_cAlias6,.T.,.T.)

	dbSelectArea(_cAlias6)
	(_cAlias6)->(dbGoTop())

	If (_cAlias6)->(!Eof())
		_cUltHr := (_cAlias6)->Z50_HRFIM
	EndIf

Return(_cUltHr)

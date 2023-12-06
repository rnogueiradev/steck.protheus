#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		   	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4

/*====================================================================================\
|Programa  | STCOM220        | Autor | RENATO.OLIVEIRA           | Data | 20/09/2020  |
|=====================================================================================|
|Descrição | ROTINA PARA INSERIR PEDIDO DE COMPRA	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM220()

	Local _aCabec 	:= {}
	Local _aItens 	:= {}
	Local _aItem  	:= {}
	Local cArquivo	:= {}
	Local aExcel    := {}
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()
	Local _cQuery2  := ""
	Local _cAlias2  := GetNextAlias()
	Local _cQuery3  := ""
	Local _cAlias3  := GetNextAlias()
	Local _nX 		:= 0
	Local _nY		:= 0
	Local cArq    := "pc_col.csv"
	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local cDir	  := "C:\arquivos\"
	Local _aParamBox 	:= {}
	Local _aRet 			:= {}
	Private lMsErroAuto := .F.

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		IncProc("Lendo arquivo texto...")

		cLinha := FT_FREADLN()           // lendo a linha

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))

	DbSelectArea("SA5")
	SA5->(DbSetOrder(1)) //A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO

	If Len(aDados)=0
		MsgAlert('Não foi possível importar o arquivo!')
		Return
	EndIf

	_cNumPc := ""
	_cLog   := "Pedido;Status"+CHR(10)+CHR(13)

	For _nX:=1 To Len(aDados)

		_cQuery1 := " SELECT A2_COD, A2_LOJA
		_cQuery1 += " FROM "+RetSqlName("SA2")+" A2
		//_cQuery1 += " WHERE A2.D_E_L_E_T_=' ' AND A2_XVENDOR='"+aDados[_nX][4]+"'
		_cQuery1 += " WHERE A2.D_E_L_E_T_=' ' AND A2_COD='"+aDados[_nX][5]+"'
		_cQuery1 += " AND A2_LOJA='"+aDados[_nX][6]+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->(Eof())
			_cLog += aDados[_nX][1]+";Fornecedor não encontrado"+CHR(10)+CHR(13)
			Loop
		EndIf

		_cQuery2 := " SELECT C7_NUM
		_cQuery2 += " FROM "+RetSqlName("SC7")+" C7
		_cQuery2 += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+cFilAnt+"' AND C7_XPEDSE='"+aDados[_nX][1]+"'

		If !Empty(Select(_cAlias2))
			DbSelectArea(_cAlias2)
			(_cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

		dbSelectArea(_cAlias2)
		(_cAlias2)->(dbGoTop())

		If (_cAlias2)->(!Eof())
			_cLog += aDados[_nX][1]+";Pedido já inserido"+CHR(10)+CHR(13)
			Loop
		EndIf

		If Empty(_cNumPc)

			_cItem  	:= "0000"
			_aCabec 	:= {}
			_aItens 	:= {}

			While .T.
				_cNumPc := GetSXENum("SC7","C7_NUM")
				If SC7->(DbSeek(xFilial("SC7")+_cNumPc))
					SC7->(ConfirmSX8())
				Else
					Exit
				EndIf
			EndDo
		EndIf

		_cProxNum	:= ""
		_cAtuNum 	:= aDados[_nX][1]
		_lInsere    := .F.

		If _nX==Len(aDados)
			_lInsere := .T.
		Else
			_cProxNum	:= aDados[_nX+1][1]
			If !_cProxNum==_cAtuNum
				_lInsere := .T.
			EndIf
		EndIf

		_aCabec:= {{"C7_NUM"            ,_cNumPc 													,nil},;
		{"C7_EMISSAO"                   ,CTOD(aDados[_nX][4])										,nil},;
		{"C7_FORNECE"                   ,(_cAlias1)->A2_COD											,nil},;
		{"C7_LOJA"                      ,(_cAlias1)->A2_LOJA										,nil},;
		{"C7_COND"                   	,PADL(AllTrim(aDados[_nX][8]),TamSx3("E4_CODIGO")[1],"0")	,nil},;
		{"C7_MOEDA"                   	,1															,nil},;
		{"C7_TXMOEDA"                  	,0															,nil},;
		{"C7_TPFRETE"                  	,SubStr(aDados[_nX][14],1,1)								,nil},;
		{"C7_MOTIVO"                  	,AllTrim(aDados[_nX][9])									,nil},;
		{"C7_COMPSTK"                  	,PADL(AllTrim(aDados[_nX][17]),TamSx3("C7_COMPSTK")[1],"0")	,nil}}

		_aItem := {}
		_cItem 		:= Soma1(_cItem)

		If !SA5->(DbSeek(xFilial("SA5")+(_cAlias1)->A2_COD+(_cAlias1)->A2_LOJA+PADR(AllTrim(aDados[_nX][10]),TamSx3("C7_PRODUTO")[1])))
			SA5->(RecLock("SA5",.T.))
			SA5->A5_FORNECE := (_cAlias1)->A2_COD
			SA5->A5_LOJA	:= (_cAlias1)->A2_LOJA
			SA5->A5_PRODUTO := aDados[_nX][10]
			SA5->A5_SITU	:= "A"
			SA5->A5_SKPLOT	:= "01"
			SA5->A5_TEMPLIM := 12
			SA5->A5_FABREV  := "V"
			SA5->(MsUnLock())
		EndIf

		_cQuery3 := " SELECT C7_CC
		_cQuery3 += " FROM "+RetSqlName("SC7")+" C7
		_cQuery3 += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='04' AND C7_NUM='"+AllTrim(aDados[_nX][1])+"'
		_cQuery3 += " AND C7_ITEM='"+AllTrim(aDados[_nX][2])+"'

		If !Empty(Select(_cAlias3))
			DbSelectArea(_cAlias3)
			(_cAlias3)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

		dbSelectArea(_cAlias3)
		(_cAlias3)->(dbGoTop())

		_cCusto := ""

		If (_cAlias3)->(!Eof())
			_cCusto := (_cAlias3)->C7_CC
		EndIf

		_aItem :=   {	{"C7_ITEM"   		,_cItem    																									,nil},;
		{"C7_PRODUTO"	,aDados[_nX][10] 																												,nil},;
		{"C7_QUANT" 	,Val(StrTran(StrTran(aDados[_nX][13],".",""),",",".")) 																			,nil},;
		{"C7_PRECO" 	,Val(StrTran(StrTran(aDados[_nX][11],".",""),",",".")) 																			,nil},;
		{"C7_DATPRF" 	,IIf( CTOD(aDados[_nX][7])<Date(),Date(),CTOD(aDados[_nX][7]) )																	,nil},;
		{"C7_XPEDSE" 	,AllTrim(aDados[_nX][1])										 																,nil},;
		{"C7_IPI" 		,Val(StrTran(StrTran(aDados[_nX][16],".",""),",",".")) 																			,nil},;
		{"C7_PICM" 		,Val(StrTran(StrTran(aDados[_nX][15],".",""),",",".")) 																			,nil},;
		{"C7_CC" 		,_cCusto 																			,nil}}

		aadd(_aItens,_aItem)

		lMsErroAuto := .F.

		If _lInsere

			MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)},1,_aCabec,_aItens,3)

			If lMsErroAuto
				_cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")
				SC7->(RollBackSX8())
				_cLog += aDados[_nX][1]+";"+_cErro+CHR(10)+CHR(13)
			Else
				SC7->(ConfirmSX8())
				_cLog += aDados[_nX][1]+";Inserido com sucesso"+CHR(10)+CHR(13)
			EndIf

			_cNumPc := ""

		EndIf

	Next

Return

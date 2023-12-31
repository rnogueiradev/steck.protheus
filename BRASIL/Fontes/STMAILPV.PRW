#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STMAILPV      �Autor  �Joao Rinaldi    � Data �  28/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para envio de e-mail de acordo com os tipos         ���
���          � existentes                                                 ���
�������������������������������������������������������������������������͹��
��� _nTipo   � 1 - Altera��o de Pedido de Venda (U_MT410TOK)              ���
���          � 2 - Monitor de Prioridade (U_STAltSc5)                     ���
���          � 3 - Eliminar Res�duo - Itens de Unicom (U_M410VRES)        ���
���          � 4 - Eliminar Res�duo - Itens Clas FMR B1_XFMR (U_M410VRES) ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    �                                                            ���
���Nome      �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STMAILPV (_nTipo,_aDados1,_aDados2)

	Local aArea        := GetArea()
	Local aArea1       := SC6->(GetArea())
	Local aArea2       := SC5->(GetArea())
	Local aArea3       := SX3->(GetArea())
	Local _lUnicom     := .F.
	Local _lGrupo      := .F.
	Local _lFMR        := .F.
	Local _cAlias1     := "SC6"
	Local _cStatus     := ""
	Local _cNumPV      := SC5->C5_NUM
	Local _cGrupo      := ""
	Local _cCodGrupo   := ""
	Local _cOperFalRes := GetMv("ST_OPRESFA",,"94/74")
	Local _nI
	Local _nJ
	Private _aCampos  := {}

 	//������������������������������������������������������������������������Ŀ
	//�_nTipo 1 - Altera��o de Pedido de Venda (U_MT410TOK)
	//��������������������������������������������������������������������������
	If _nTipo == 1

		_nPosProd    := aScan(_aDados2, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO" })
		_nPosQtdven  := aScan(_aDados2, {|x| Upper(AllTrim(x[2])) == "C6_QTDVEN"  })
		_nPosOper    := aScan(_aDados2, {|x| Upper(AllTrim(x[2])) == "C6_OPER"    })
		_nPosLocal   := aScan(_aDados2, {|x| Upper(AllTrim(x[2])) == "C6_LOCAL"   })
		_nPosRecno   := aScan(_aDados2, {|x| Upper(AllTrim(x[2])) == "C6_REC_WT"  })
		_cNumPV      := SC5->C5_NUM

		For _nI := 1 to Len(_aDados1)
			_lUnicom   := U_STUNICOM(_aDados1[_nI][_nPosProd])
			_lGrupo    := STVLDGRUPO(_aDados1[_nI][_nPosProd])

			If (_lUnicom .OR. _lGrupo) .And. !((_aDados1[_nI][_nPosOper]) $ _cOperFalRes)
				SC6->(DbGoto(_aDados1[_nI][_nPosRecno]))//Recno

				DbSelectArea("SX3")
				SX3->(DbGoTop())
				SX3->(DbSetOrder(1))
				SX3->(DbSeek(_cAlias1))

				While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)==_cAlias1
					For _nJ := 1 to Len(_aDados2)
						If ((_aDados2[_nJ][2]) == (SX3->X3_CAMPO)) .And. Alltrim((_aDados2[_nJ][2])) == "C6_QTDVEN"
							If  _aDados1[_nI][_nJ]  <  &(_cAlias1+"->"+SX3->X3_CAMPO) .Or. (_aDados1[_nI][Len(_aDados1[_nI])])//Conte�do

								DO CASE
								CASE (_aDados1[_nI][_nPosRecno]) = 0
									_cStatus := "Novo Registro"
								CASE (_aDados1[_nI][Len(_aDados1[_nI])])
									_cStatus := "Registro Deletado"
								CASE !(_aDados1[_nI][_nJ]  ==  &((_cAlias1+"->"+SX3->X3_CAMPO)))
									_cStatus := "Registro Alterado"
								ENDCASE

								DO CASE
								CASE _lUnicom
									_cGrupo := "Unicom"
								CASE _lGrupo
									_cGrupo := "Bloqueio"
								ENDCASE

								_cCodGrupo := Posicione("SB1",1,xFilial('SB1')+(_aDados1[_nI][_nPosProd]),"B1_GRUPO")

								Aadd(_aCampos,{(_aDados1[_nI][_nPosRecno]),; //01-Recno
								(_aDados1[_nI][_nPosProd]),;               //02-C�d do Produto
								(_aDados2[_nJ][2]),;                       //03-Campo SX3
								(_aDados2[_nJ][1]),;                       //04-Descri��o SX3
								(&(_cAlias1+"->"+SX3->X3_CAMPO)),;         //05-Conte�do Antigo
								IIF(!(_aDados1[_nI][Len(_aDados1[_nI])]),(_aDados1[_nI][_nJ]),""),;//06-Novo Conte�do
								(SC6->C6_QTDENT),;                         //07-Quantidade Entregue
								((_aDados1[_nI][_nJ])-(SC6->C6_QTDENT)),;  //08-Saldo Item
								_cStatus,;                                 //09-Status
								_cGrupo,;                                  //10-Grupo de Produto
								_cCodGrupo,;                               //11-C�digo Grupo de Produto
								(_aDados1[_nI][_nPosOper])})               //12-Tipo de Opera��o

							EndIf
						Endif
					Next _nJ
					SX3->(DbSkip())
				EndDo
			Endif
		Next _nI

 	//������������������������������������������������������������������������Ŀ
	//�_nTipo 2 - Monitor de Prioridade (U_STAltSc5)
	//��������������������������������������������������������������������������
	ElseIf _nTipo == 2

		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		SC6->(DbGoTop())
		If SC6->(DbSeek(xFilial("SC6")+(_cNumPV)))
			While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+(_cNumPV)
				_lUnicom   := U_STUNICOM(SC6->C6_PRODUTO)
				_lGrupo    := STVLDGRUPO(SC6->C6_PRODUTO)
				If _lUnicom .Or. _lGrupo
					Exit
				Endif
				SC6->(DbSkip())
			EndDo

			If _lUnicom .Or. _lGrupo
				_nPosDiaDe  := aScan(_aDados1, {|x| (AllTrim(x[2])) == "Dia De"  })
				_nPosDiaAte := aScan(_aDados1, {|x| (AllTrim(x[2])) == "Dia Ate" })
				_nPosMesDe  := aScan(_aDados1, {|x| (AllTrim(x[2])) == "Mes De"  })
				_nPosMesAte := aScan(_aDados1, {|x| (AllTrim(x[2])) == "Mes Ate" })
				_nPosAnoDe  := aScan(_aDados1, {|x| (AllTrim(x[2])) == "Ano de"  })
				_nPosAnoAte := aScan(_aDados1, {|x| (AllTrim(x[2])) == "Ano Ate" })

				If    (_nPosDiaDe  > 0);
						.And. (_nPosDiaAte > 0);
						.And. (_nPosMesDe  > 0);
						.And. (_nPosMesAte > 0);
						.And. (_nPosAnoDe  > 0);
						.And. (_nPosAnoAte > 0)

					IF ((_aDados1[_nPosDiaDe][1]) <> (_aDados2[_nPosDiaDe][1]));
							.Or. ((_aDados1[_nPosDiaAte][1]) <> (_aDados2[_nPosDiaAte][1]));
							.Or. ((_aDados1[_nPosMesDe] [1]) <> (_aDados2[_nPosMesDe] [1]));
							.Or. ((_aDados1[_nPosMesAte][1]) <> (_aDados2[_nPosMesAte][1]));
							.Or. ((_aDados1[_nPosAnoDe] [1]) <> (_aDados2[_nPosAnoDe] [1]));
							.Or. ((_aDados1[_nPosAnoAte][1]) <> (_aDados2[_nPosAnoAte][1]))

						Aadd(_aCampos,{"C5_XDE"   ,(_aDados1[_nPosDiaDe] [2]),(_aDados1[_nPosDiaDe] [1]),(_aDados2[_nPosDiaDe] [1]), IIF((_aDados1[_nPosDiaDe] [1])==(_aDados2[_nPosDiaDe] [1]),"Sem Altera��o","Registro Alterado")  })
						Aadd(_aCampos,{"C5_XATE"  ,(_aDados1[_nPosDiaAte][2]),(_aDados1[_nPosDiaAte][1]),(_aDados2[_nPosDiaAte][1]), IIF((_aDados1[_nPosDiaAte][1])==(_aDados2[_nPosDiaAte][1]),"Sem Altera��o","Registro Alterado")  })
						Aadd(_aCampos,{"C5_XMDE"  ,(_aDados1[_nPosMesDe] [2]),(_aDados1[_nPosMesDe] [1]),(_aDados2[_nPosMesDe] [1]), IIF((_aDados1[_nPosMesDe] [1])==(_aDados2[_nPosMesDe] [1]),"Sem Altera��o","Registro Alterado")  })
						Aadd(_aCampos,{"C5_XMATE" ,(_aDados1[_nPosMesAte][2]),(_aDados1[_nPosMesAte][1]),(_aDados2[_nPosMesAte][1]), IIF((_aDados1[_nPosMesAte][1])==(_aDados2[_nPosMesAte][1]),"Sem Altera��o","Registro Alterado")  })
						Aadd(_aCampos,{"C5_XDANO" ,(_aDados1[_nPosAnoDe] [2]),(_aDados1[_nPosAnoDe] [1]),(_aDados2[_nPosAnoDe] [1]), IIF((_aDados1[_nPosAnoDe] [1])==(_aDados2[_nPosAnoDe] [1]),"Sem Altera��o","Registro Alterado")  })
						Aadd(_aCampos,{"C5_XAANO" ,(_aDados1[_nPosAnoAte][2]),(_aDados1[_nPosAnoAte][1]),(_aDados2[_nPosAnoAte][1]), IIF((_aDados1[_nPosAnoAte][1])==(_aDados2[_nPosAnoAte][1]),"Sem Altera��o","Registro Alterado")  })
					Endif
				Else
					MSGALERT("Os campos de Altera��o Data (Gera��o de O.S.) est�o divergentes ...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor entrar em contato com o T.I. ...!!!"+ Chr(10) + Chr(13),;
						"Altera��o Data (Gera��o de O.S.)")
				Endif
			Endif
		Endif

 	//������������������������������������������������������������������������Ŀ
	//�_nTipo 3 - Eliminar Res�duo - Itens de Unicom (U_M410VRES)
	//��������������������������������������������������������������������������
	ElseIf _nTipo == 3

		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		SC6->(DbGoTop())
		If SC6->(DbSeek(xFilial("SC6")+(_cNumPV)))
			While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+(_cNumPV)
				_lUnicom   := U_STUNICOM(SC6->C6_PRODUTO)
				_lGrupo    := STVLDGRUPO(SC6->C6_PRODUTO)

				If (_lUnicom .Or. _lGrupo) .And. !(SC6->C6_OPER $ _cOperFalRes)

					DO CASE
					CASE _lUnicom
						_cGrupo := "Unicom"
					CASE _lGrupo
						_cGrupo := "Bloqueio"
					ENDCASE

					_cStatus   := "Eliminado Res�duo"
					_cCodGrupo := Posicione("SB1",1,xFilial('SB1')+(SC6->C6_PRODUTO),"B1_GRUPO")

					Aadd(_aCampos,;
						{Recno(),;                              //01-Recno
					SC6->C6_PRODUTO,;                          //02-C�d do Produto
					(SC6->C6_QTDVEN)-(SC6->C6_QTDENT),;        //03-Saldo Item
					_cStatus,;                                 //04-Status
					_cGrupo,;                                  //05-Grupo de Produto
					_cCodGrupo,;                               //06-C�digo Grupo de Produto
					SC6->C6_OPER})                             //07-Tipo de Opera��o

				Endif
				SC6->(DbSkip())
			EndDo
		Endif
 	//������������������������������������������������������������������������Ŀ
	//�_nTipo 4 - Eliminar Res�duo - Itens Clas FMR B1_XFMR (U_M410VRES)
	//��������������������������������������������������������������������������
	ElseIf _nTipo == 4

		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		SC6->(DbGoTop())
		If SC6->(DbSeek(xFilial("SC6")+(_cNumPV)))
			While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+(_cNumPV)
				_lUnicom   := U_STUNICOM(SC6->C6_PRODUTO)
				_lFMR      :=   STVLDFMR(SC6->C6_PRODUTO)

				If !(_lUnicom)
					If _lFMR .And. !(SC6->C6_OPER $ _cOperFalRes)

						_cGrupo    := Posicione("SB1",1,xFilial('SB1')+(SC6->C6_PRODUTO),"B1_XFMR")
						_cStatus   := "Eliminado Res�duo"
						_cCodGrupo := Posicione("SB1",1,xFilial('SB1')+(SC6->C6_PRODUTO),"B1_GRUPO")

						Aadd(_aCampos,;
							{Recno(),;                              //01-Recno
						SC6->C6_PRODUTO,;                          //02-C�d do Produto
						(SC6->C6_QTDVEN)-(SC6->C6_QTDENT),;        //03-Saldo Item
						_cStatus,;                                 //04-Status
						_cGrupo,;                                  //05-Classifica��o FMR
						_cCodGrupo,;                               //06-C�digo Grupo de Produto
						SC6->C6_OPER})                             //07-Tipo de Opera��o
					Endif
				Endif
				SC6->(DbSkip())
			EndDo
		Endif
	Endif

	If Len(_aCampos) > 0
		Processa({||STMAILALTPV(cusername,dtoc(date()),time(),_aCampos,_cNumPV,_nTipo),"Enviando E-mail ...!!!" })
	Endif

	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	RestArea(aArea)

Return




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STMAILALTPV   �Autor  �Joao Rinaldi    � Data �  28/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para envio de e-mail                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STMAILPV.PRW                                               ���
���Nome      �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function STMAILALTPV (_cName,_cDat,_cHora,_aCampos,_cNumPV,_nTipo)

	Local aArea 	  := GetArea()
	Local _cAssunto := ""
	Local cFuncSent := "STMAILALTPV"
	Local _aMsg     := {}
	Local cMsg      := ""
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local cAttach   := ''
	Local _nLin
	Local _nItens
	Local _nMsg

	If _nTipo == 1
		_cEmail   := "paulo.filho@steck.com.br;richely.lima@steck.com.br;marcelo.galera@steck.com.br;maurilio.francisquet@steck.com.br;ulisses.almeida@steck.com.br;alex.lourenco@steck.com.br"
		_cAssunto := 'Altera��o de Produto (Qtde a Menor) no Pedido de Venda n� '+_cNumPV+' na Empresa: '+ cEmpAnt+' - Filial: '+ cFilAnt+' - Usu�rio: '+_cName + ' - Dia: '+_cDat+' �s: '+_cHora
		Aadd( _aMsg , {"Registro","Produto","Campo","Descri��o","Alterado De","Alterado Para","Qtde Entregue","Saldo","Status","Grupo","C�digo Grupo","Opera��o"} )
	ElseIf _nTipo == 2
		_cEmail   := "ulisses.almeida@steck.com.br;alex.lourenco@steck.com.br "
		_cAssunto := 'Altera��o Data (Gera��o de O.S.) - Monitor de Prioridade - Pedido de Venda n� '+_cNumPV+' na Empresa: '+ cEmpAnt+' - Filial: '+ cFilAnt+' - Usu�rio: '+_cName + ' - Dia: '+_cDat+' �s: '+_cHora
		Aadd( _aMsg , {"Campo","Descri��o","Alterado De","Alterado Para","Status"} )
	ElseIf _nTipo == 3
		_cEmail   := "paulo.filho@steck.com.br;richely.lima@steck.com.br;marcelo.galera@steck.com.br;maurilio.francisquet@steck.com.br;ulisses.almeida@steck.com.br;alex.lourenco@steck.com.br"
		_cAssunto := 'Res�duo Eliminado no Pedido de Venda n� '+_cNumPV+' na Empresa: '+ cEmpAnt+' - Filial: '+ cFilAnt+' - Usu�rio: '+_cName + ' - Dia: '+_cDat+' �s: '+_cHora
		Aadd( _aMsg , {"Registro","Produto","Saldo","Status","Grupo","C�digo Grupo","Opera��o"} )
	ElseIf _nTipo == 4
		_cEmail   := "paulo.filho@steck.com.br;richely.lima@steck.com.br"
		_cAssunto := 'Res�duo Eliminado no Pedido de Venda n� '+_cNumPV+' na Empresa: '+ cEmpAnt+' - Filial: '+ cFilAnt+' - Usu�rio: '+_cName + ' - Dia: '+_cDat+' �s: '+_cHora
		Aadd( _aMsg , {"Registro","Produto","Saldo","Status","FMR","C�digo Grupo","Opera��o"} )
	Endif

	//�����������������������������������������������������������������������������Ŀ
	//� Definicao do cabecalho do email                                             �
	//�������������������������������������������������������������������������������
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + '</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +'</FONT> </Caption>'
	//cMsg += '<TR>'
	//cMsg += '<TH><FONT COLOR=#000000 FACE= "ARIAL" SIZE=5 Align=Centered>'+_cAssunto+'</FONT></TH>'
	//cMsg += '</TR>'
	//cMsg += '</Table>'
	//�����������������������������������������������������������������������������Ŀ
	//� Definicao do texto/detalhe do email                                         �
	//�������������������������������������������������������������������������������
	//cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<TR BgColor=#FFFFFF>'
	For _nMsg := 1 to Len(_aMsg[1])
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,_nMsg] + ' </Font></B></TD>'
	Next _nMsg

	For _nLin := 1 to Len(_aCampos)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#FFFFFF>'
		Else
			cMsg += '<TR BgColor=#66FF66>'
		EndIF

		For _nItens := 1 to Len(_aCampos[1])
			If     ValType(_aCampos[_nLin,_nItens]) = "C"
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aCampos[_nLin,_nItens]             + ' </Font></TD>'
			ElseIf ValType(_aCampos[_nLin,_nItens]) = "N"
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cvaltochar(_aCampos[_nLin,_nItens]) + ' </Font></TD>'
			ElseIf ValType(_aCampos[_nLin,_nItens]) = "D"
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + DTOC(_aCampos[_nLin,_nItens])       + ' </Font></TD>'
			Endif
		Next _nItens

		cMsg += '</TR>'
	Next _nLin
	//�����������������������������������������������������������������������������Ŀ
	//� Definicao do rodape do email                                                �
	//�������������������������������������������������������������������������������
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	RestArea(aArea)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLDGRUPO    �Autor  �Joao Rinaldi    � Data �  28/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que retorna se o produto pertence a determinado     ���
���          � grupo de produtos                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STMAILPV.PRW                                               ���
���Nome      �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function STVLDGRUPO(_cCod)

	Local _lGrupo        := .F.
	Local _cQuery1       := ''
	Local _cGrp1         := "('005')"
	Private cPerg 		:= "GRUPO"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
	Private _cAlias1     := cAliasLif

	_cQuery1 := " SELECT
	_cQuery1 += " B1_COD   AS A1_CODIGO
	_cQuery1 += ",B1_DESC  AS A2_DESCRICAO
	_cQuery1 += ",B1_GRUPO AS A3_GRUPO

	_cQuery1 += ",CASE WHEN B1_GRUPO IN "+_cGrp1"
	_cQuery1 += " THEN 'REGRA' ELSE
	_cQuery1 += " 'FORA_REGRA' END AS A4_DESCGRUPO

	_cQuery1 += " FROM "+RetSqlName("SB1")+" SB1"
	_cQuery1 += " WHERE SB1.D_E_L_E_T_ = ' '
	_cQuery1 += " AND B1_COD    = '"+_cCod+"' "
	_cQuery1 += " AND B1_FILIAL = '"+xFilial("SB1")+"'"

	_cQuery1 := ChangeQuery(_cQuery1)

	If Select(_cAlias1) > 0
		(_cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery1),_cAlias1)

	DbSelectArea(_cAlias1)
	(_cAlias1)->(DbGoTop())
	If  Select(_cAlias1) > 0
		While 	(_cAlias1)->(!Eof())
			If Alltrim((_cAlias1)->A4_DESCGRUPO) == 'REGRA'
				_lGrupo := .T.
			ElseIf Alltrim((_cAlias1)->A4_DESCGRUPO) == 'FORA_REGRA'
				_lGrupo := .F.
			Else
				_lGrupo := .F.
			Endif
			(_cAlias1)->(dbskip())
		End
		(_cAlias1)->(dbCloseArea())
	Endif

Return (_lGrupo)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLDGRUPO    �Autor  �Joao Rinaldi    � Data �  28/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que retorna se o produto pertence a determinado     ���
���          � grupo de produtos                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STMAILPV.PRW                                               ���
���Nome      �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function STVLDFMR(_cCod)

	Local _lFMR          := .F.
	Local _cQuery2       := ''
	Local _cFMR          := "('R','RR','O')"
	Private cPerg 		:= "FMR"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
	Private _cAlias2     := cAliasLif

	_cQuery2 := " SELECT
	_cQuery2 += " B1_COD   AS A1_CODIGO
	_cQuery2 += ",B1_DESC  AS A2_DESCRICAO
	_cQuery2 += ",B1_XFMR  AS A3_FMR

	_cQuery2 += ",CASE WHEN B1_XFMR IN "+_cFMR"
	_cQuery2 += " THEN 'REGRA' ELSE
	_cQuery2 += " 'FORA_REGRA' END AS A4_DESCFMR

	_cQuery2 += " FROM "+RetSqlName("SB1")+" SB1"
	_cQuery2 += " WHERE SB1.D_E_L_E_T_ = ' '
	_cQuery2 += " AND B1_COD    = '"+_cCod+"' "
	_cQuery2 += " AND B1_FILIAL = '"+xFilial("SB1")+"'"

	_cQuery2 := ChangeQuery(_cQuery2)

	If Select(_cAlias2) > 0
		(_cAlias2)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery2),_cAlias2)

	DbSelectArea(_cAlias2)
	(_cAlias2)->(DbGoTop())
	If  Select(_cAlias2) > 0
		While 	(_cAlias2)->(!Eof())
			If Alltrim((_cAlias2)->A4_DESCFMR) == 'REGRA'
				_lFMR := .T.
			ElseIf Alltrim((_cAlias2)->A4_DESCFMR) == 'FORA_REGRA'
				_lFMR := .F.
			Else
				_lFMR := .F.
			Endif
			(_cAlias2)->(dbskip())
		End
		(_cAlias2)->(dbCloseArea())
	Endif

Return (_lFMR)

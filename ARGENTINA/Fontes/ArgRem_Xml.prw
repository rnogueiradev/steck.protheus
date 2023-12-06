#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �NfdsXml001� Autor � Roberto Souza         � Data �21/05/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exemplo de geracao da Nota Fiscal Digital de Servi�os       ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Xml para envio                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Tipo da NF                                           ���
���          �       [0] Entrada                                          ���
���          �       [1] Saida                                            ���
���          �ExpC2: Serie da NF                                          ���
���          �ExpC3: Numero da nota fiscal                                ���
���          �ExpC4: Codigo do cliente ou fornecedor                      ���
���          �ExpC5: Loja do cliente ou fornecedor                        ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ArgRemCotXml(cTipo,cSerie,cNota,cClieFor,cLoja)

Local cString    	:= ""
Local cWhere	 	:= ""
Local cMVREPROD	:= Alltrim(GetNewPar("MV_REPROD","B1_COD"))
Local cCampo		:= ""
Local cCodUnProd	:= ""
Local cCodUm		:= ""
Local cCodTransp	:= ""

Local nX        	:= 0

Local lQuery    	:= .F.
Local lConsFin 		:= .F.
Local lTransPed		:= .F.

Local aNota     	:= {}
Local aDest     	:= {}
Local aEntrega  	:= {}
Local aProd     	:= {}
Local acabNF 		:= {}
Local aInfRemto	:= {}
Local aInfDstari	:= {}
Local aInfDest	:= {}
Local aInfOrig	:= {}
Local aInfRecor	:= {}
Local aMVREUN 	:=  &( GetNewPar("MV_REUN",'{ {"KG","1"},{"L","2"},{"UN","3"},{"M2","4"},{"MT","5"},{"M3","6"},{"P","7"}}') )
Local aEndDest	:= {}
Local aEndOrig	:= {}
Local nValCot		:= 0

Private aColIB	:={}
Private aColIVA	:={}
Private aIB:={}
Private aIVA:={}
Private _cSerie := ""

DEFAULT cTipo   := PARAMIXB[1]
DEFAULT cSerie  := PARAMIXB[2]
DEFAULT cNota   := PARAMIXB[3]
DEFAULT cClieFor:= PARAMIXB[4]
DEFAULT cLoja   := PARAMIXB[5]


If cTipo == "1"
	//������������������������������������������������������������������������Ŀ
	//�Posiciona Remito                                                            �
	//��������������������������������������������������������������������������
	SF2->( dbSetOrder(1) )
	SF2->( DbGoTop() )
	If SF2->( DbSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja) )

		//Dados do grupo infremito

		aadd(aInfRemto,SF2->F2_EMISSAO) //fecha_emision
		//aadd(aInfRemto,"91 "+Left(Alltrim(SF2->F2_SERIE),1)+If(len(SF2->F2_DOC)>11,SF2->F2_DOC,"0"+SF2->F2_DOC))//codigo_unico
		aadd(aInfRemto,"091"+If(len(SF2->F2_DOC)>12,SF2->F2_DOC,"0"+SF2->F2_DOC))//codigo_unico
		aadd(aInfRemto,SF2->F2_EMISSAO)//fecha_salida_transporte
		aadd(aInfRemto,"")//hora_salida_transporte
		aadd(aInfRemto,"E")//sujeto_generador


		//Dados do grupo infdestinatario
		SA1->(dbSetOrder(1) )
		SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))


		if alltrim(SA1->A1_TIPO) == 'F'
			lConsFin := .T.
		endif


		aadd(aInfDstari,iif(lConsFin,"1","2")) //destinatario_consumidor_final

		nValCot:= 0
		// Calcula Importe Remito

		If (SF2->(FieldPos("F2_VALCOT")) > 0 .And. !Empty(SF2->F2_VALCOT))
			nValCot := SF2->F2_VALCOT
		Else
			nValCot := SF2->F2_VALMERC
		Endif

		If SF2->F2_MOEDA<>1
			SM2->(dbSetORder(1))
			cCampo := "M2_MOEDA"+SubStr(Alltrim(Str(SF2->F2_MOEDA)),1,1)
			if SM2->(dbSeek(Date())) .And. SM2->(FieldPos(cCampo)) > 0 .And. SM2->(&(cCampo)) > 0
				nValCot:=nValCot * SM2->(&(cCampo))  //importe Convertido
			endif
		endif
//Compara valor consumidor final
		If lConsFin .and.  nValCot >= 5000
			aAreaAtu:=GetArea()
			aAreaSX5 := SX5->(GetArea())

			SX5->( dbSetOrder(1) )
			cCodAfip:="1"
			If SA1->(ColumnPos("A1_AFIP")) > 0
				cCodAfip:=SA1->A1_AFIP
			EndIf
			If SX5->( MsSeek(xFilial("SX5")+"OC"+cCodAfip) )
				cAfipCode := SubStr(X5DESCRI(),4,3)
			endIf

			RestArea(aAreaSX5)
			RestArea(aAreaAtu)

			aadd(aInfDstari,cAfipCode) //destinatario_tipo_documento
			aadd(aInfDstari,Alltrim(SA1->A1_CGC)) //destinatario_documento
		Else
			aadd(aInfDstari,"") //destinatario_tipo_documento
			aadd(aInfDstari,"") //destinatario_documento
		EndIf
		aadd(aInfDstari,iif( lConsFin,"",Alltrim(SA1->A1_CGC) )) //destinatario_cuit
		aadd(aInfDstari,iif( lConsFin ,"",Alltrim(SA1->A1_NOME) )) //destinatario_razon_social
		aadd(aInfDstari,iif( lConsFin,"2","1") ) //destinatario_tenedor


		//Dados do grupo de infdestino
		aEndDest := MyGetEnd(SA1->A1_END,"SA1")

		aadd(aInfDest, aEndDest[1]) //destino_domicilio_calle
		aadd(aInfDest, aEndDest[2]) //destino_domicilio_numero
		aadd(aInfDest, "") //destino_domicilio_comple
		aadd(aInfDest, "") //destino_domicilio_piso
		aadd(aInfDest, "") //destino_domicilio_dto
		aadd(aInfDest, "") //destino_domicilio_barrio
		aadd(aInfDest, SA1->A1_CEP ) //destino_domicilio_codigopostal
		aadd(aInfDest, SA1->A1_MUN) //destino_domicilio_localidad
		//aadd(aInfDest, "B") //destino_domicilio_provincia
		aadd(aInfDest, cCodPr(SA1->A1_EST )) //destino_domicilio_provincia  // STECK
		aadd(aInfDest, "") //proprio_destino_domicilio_codigo

		//Dados do grupo inforigem
		aEndOrig := MyGetEnd(SM0->M0_ENDENT,"SM0")

		aadd(aInfOrig,iif(SA1->A1_MUN $ SM0->M0_CIDENT,"1","2")) //entrega_domicilio_origen
		aadd(aInfOrig,StrZero( Val(SM0->M0_CGC), 11 )) //origen_cuit
		aadd(aInfOrig,SM0->M0_NOMECOM) //origen_razon_social
		aadd(aInfOrig,"1") //emisor_tenedor
		aadd(aInfOrig,aEndOrig[1]) //origen_domicilio_calle
		aadd(aInfOrig,aEndOrig[2]) //origen_domicilio_numero
		aadd(aInfOrig,"") //origen_domicilio_comple
		aadd(aInfOrig,"") //origen_domicilio_piso
		aadd(aInfOrig,"") //origen_domicilio_dto
		aadd(aInfOrig,"") //origen_domicilio_barrio
		aadd(aInfOrig,SM0->M0_CEPENT) //origen_domicilio_codigopostal
		aadd(aInfOrig,SM0->M0_CIDENT) //origen_domicilio_localidad
		aadd(aInfOrig,'C') //origen_domicilio_provincia

		//Dados do grupo infrecorrido
		if !empty(SF2->F2_TRANSP)
			SA4->(dbSetorder(1))
			if SA4->(dbSeek(xFilial("SA4")+SF2->F2_TRANSP))
				aadd(aInfRecor,SA4->A4_CGC) //transportista_cuit
			else
				aadd(aInfRecor,"00000000000") //transportista_cuit
			endif
		else
			lTransPed := .T.
			aadd(aInfRecor,"00000000000")
		endif

		aadd(aInfRecor,"") //tipo_recorrido
		aadd(aInfRecor,"") //recorrido_localidad
		aadd(aInfRecor,"") //recorrido_calle
		aadd(aInfRecor,"") //recorrido_ruta
		If ((SF2->(FieldPos("F2_VEHICL")) > 0 ) .And. !Empty(SF2->F2_VEHICL))
			DbSelectArea("DA3")
			DbSetOrder (1)
			If dbSeek(xFilial("DA3")+SF2->F2_VEHICL)
				aadd(aInfRecor,Alltrim(DA3->DA3_PLACA)) //patente_vehiculo
			Else
				aadd(aInfRecor,"") //patente_vehiculo
			Endif
		Else
			aadd(aInfRecor,"") //patente_vehiculo
		Endif
		If (SF2->(FieldPos("F2_VEHICL")) > 0 .And. !Empty(SF2->F2_ACOPLA))
			DbSelectArea("DA3")
			DbSetOrder (1)
			If dbSeek(xFilial("DA3")+SF2->F2_ACOPLA)
				aadd(aInfRecor,Alltrim(DA3->DA3_PLACA)) //patente_acoplado
			Else
				aadd(aInfRecor,"") //patente_acoplado
			Endif
		Else
			aadd(aInfRecor,"") //patente_acoplado
		Endif
		aadd(aInfRecor,"2") //producto_no_term_dev


		aadd(aInfRecor,nValCot) //importe Remito


		//Dados do grupo infprod

		dbSelectArea("SD2")
		dbSetOrder(3)

		#IFDEF TOP
			lQuery  := .T.
			cAliasSD2 := GetNextAlias()
			BeginSql Alias cAliasSD2
				SELECT * FROM %Table:SD2% SD2
				WHERE
				SD2.D2_FILIAL = %xFilial:SD2% AND
				SD2.D2_SERIE = %Exp:SF2->F2_SERIE% AND
				SD2.D2_DOC = %Exp:SF2->F2_DOC% AND
				SD2.D2_CLIENTE = %Exp:SF2->F2_CLIENTE% AND
				SD2.D2_LOJA = %Exp:SF2->F2_LOJA% AND
				SD2.%NotDel%
				ORDER BY %Order:SD2%
			EndSql

		#ELSE
			DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		#ENDIF

		(cAliasSD2)->(dbgotop())

		While (cAliasSD2)->(!EOF()) .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
			SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
			SF2->F2_DOC == (cAliasSD2)->D2_DOC


			//codigo_unico_producto
			if Left(cMVREPROD,2) == "B5"

				if SB5->(FieldPos(cMVREPROD)) > 0
					cCodUnPrd := Left(Posicione("SB5",1,xFilial("SB5")+(cAliasSD2)->D2_COD,cMVREPROD),6)
				else
					CodUnPrd := Left(Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_COD"),6)
				endif

			else

				if SB1->(FieldPos(cMVREPROD)) > 0
					cCodUnPrd := Left(Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,cMVREPROD),6)
				else
					cCodUnPrd := Left(Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_COD"),6)
				endif

			endif

			//rentas_codigo_unidad_medida
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD))


			If ( nX := aScan(aMVREUN,{|x| Alltrim(x[1])==SB1->B1_SEGUM})  ) > 0//Steck 06082019.
				cCodUm	:= 	aMVREUN[nX][2]
			else
				cCodUm	:= 	SB1->B1_UM
			endif

			//proprio_descripcion_unidad_medida

			SAH->(dbSetOrder(1))
			SAH->(dbSeek(xFilial("SAH")+(cAliasSD2)->D2_UM))

			cDescUm := SAH->AH_DESCES


			//Adiciona no Array de pordutos

			aadd( aProd,  {Len(aProd)+1 ,;
					cCodUnPrd,; //codigo_unico_producto
					cCodUm,;//rentas_codigo_unidad_medida
					(cAliasSD2)->D2_QUANT,;//cantidad
					(cAliasSD2)->D2_COD,;//proprio_codigo_producto
					SB1->B1_DESC,;//proprio_descripcion_producto
					cDescUm,;//proprio_descripcion_unidad_medida
					(cAliasSD2)->D2_QUANT})//cantidad_ajustada

			//Pega o codigo da transportadora
			if lTransPed
				SC5->(dbSetOrder(1))
				if SC5->( dbSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO) ) .and. !empty(SC5->C5_TRANSP)
					cCodTransp := SC5->C5_TRANSP
				endif
			endif

		(cAliasSD2)->(dbSkip())

		Enddo
		(cAliasSD2)->(dbCloseArea())

		if lTransPed .and. !empty( cCodTransp )
			SA4->(dbSetorder(1))
			if SA4->(dbSeek(xFilial("SA4")+cCodTransp))
				aInfRecor[1] := SA4->A4_CGC
			endif
		endif
	endIf

endif

//Faz a chamado das fun��es que gera o XML Padr�o TSS do COT
//Lembrando que este XML ser� convertindo no TSS no Arquivo .TXT
//aceito pelo portal do COT.


cString := '<remito>'

cString += XmlInfRemito(aInfRemto)
cString += XmlInfDstario(aInfDstari)
cString += XmlInfDestino(aInfDest)
cString += XmlInfOrigem(aInfOrig)
cString += XmlInfRecorri(aInfRecor)


cString += '<productos>'

For nX := 1 to Len(aProd)
	cString += XmlInfProd(aProd[nX])
Next nX

cString += '</productos>'

cString += '</remito>'

Return(cString)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XmlInfRemito �Autor  �Rafael Iaquinto  � Data �  09/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera string com conte�do XML, com os dados principais do   ���
���          � Remito                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Remito Eletronico da Argentia - COT                		    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function XmlInfRemito(aInfRemto)

local cString    := ""

local dFchEmiss		:= aInfRemto[1] //fecha_emision
local cChvRem 		:= aInfRemto[2] //codigo_unico
local dFchSaida		:= aInfRemto[3] //fecha_salida_transporte
local chrSaida		:= aInfRemto[4] //hora_salida_transporte
local cGerador		:= aInfRemto[5] //sujeto_generador

cString    += '<infremito>'
cString    += '<fecha_emision>'+ConvType(dFchEmiss)+'</fecha_emision>'
cString    += '<codigo_unico>'+cChvRem+'</codigo_unico>'
cString    += '<fecha_salida_transporte>'+ConvType(dFchSaida)+'</fecha_salida_transporte>'
cString    += NfeTag('<hora_salida_transporte>',ConvType(chrSaida,10) )
cString    += '<sujeto_generador>'+cGerador+'</sujeto_generador>'
cString    += '</infremito>'

Return cString
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XmlInfDstario  �Autor Rafae Iaquinto  �Data �  09/01/12     ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera string com conte�do do XML, com os dados do            ���
���          �destinatario                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Remito Eletronico da Argentia - COT                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function XmlInfDstario(aInfDstari)

Local cString := ""

local cConsFinal		:= aInfDstari[1] //destinatario_consumidor_final
local cTpDoc 			:= aInfDstari[2] //destinatario_tipo_documento
local cDocumento 		:= aInfDstari[3] //destinatario_documento
local cCuit   		:= aInfDstari[4] //destinatario_cuit
local cRazao  		:= aInfDstari[5] //destinatario_razon_social
local cTenedor		:= aInfDstari[6] //destinatario_tenedor

cString := '<infdestinatario>'
cString += '<destinatario_consumidor_final>'+cConsFinal+'</destinatario_consumidor_final>'
cString += NfeTag( '<destinatario_tipo_documento>',ConvType(cTpDoc,3) )
cString += NfeTag( '<destinatario_documento>',ConvType(cDocumento,11) )
cString += NfeTag( '<destinatario_cuit>',cCuit)
cString += NfeTag( '<destinatario_razon_social>',ConvType(cRazao,50) )
cString += NfeTag( '<destinatario_tenedor>',cTenedor )

cString += '</infdestinatario>'

Return(cString)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XmlInfDestino  �Autor Rafae Iaquinto  �Data �  09/01/12     ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera string com conte�do do XML, com os dados do            ���
���          �destinatario                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Remito Eletronico da Argentia - COT                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function XmlInfDestino(aInfDest)

local cString := ""

local cCalle		:= aInfDest[1] //destino_domicilio_calle
local cNum	 		:= aInfDest[2] //destino_domicilio_numero
local cCpl	 		:= aInfDest[3] //destino_domicilio_comple
local cPiso 		:= aInfDest[4] //destino_domicilio_piso
local cDto  		:= aInfDest[5] //destino_domicilio_dto
local cBarrio		:= aInfDest[6] //destino_domicilio_barrio
local cCodPost	:= aInfDest[7] //destino_domicilio_codigopostal
local cLocalidad	:= aInfDest[8] //destino_domicilio_localidad
local cProvinc	:= aInfDest[9] //destino_domicilio_provincia
local cPropCod	:= aInfDest[10] //proprio_destino_domicilio_codigo

cString := '<infdestino>'
cString += '<destino_domicilio_calle>'+ConvType(cCalle,40)+'</destino_domicilio_calle>'
cString += Nfetag('<destino_domicilio_numero>',ConvType(cNum,5),.T.)
cString += Nfetag('<destino_domicilio_comple>',ConvType(cCpl,5))
cString += NfeTag('<destino_domicilio_piso>',ConvType(cPiso,3))
cString += NfeTag('<destino_domicilio_dto>',ConvType(cDto,4))
cString += NfeTag('<destino_domicilio_barrio>',ConvType(cBarrio,30))
cString += NfeTag('<destino_domicilio_codigopostal>',ConvType(cCodPost,8))
cString += NfeTag('<destino_domicilio_localidad>',ConvType(cLocalidad,50))
cString += NfeTag('<destino_domicilio_provincia>',ConvType(cProvinc,1))
cString += NfeTag('<proprio_destino_domicilio_codigo>',ConvType(cPropCod,20))
cString += '</infdestino>'

Return(cString)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XmlInfOrigem  �Autor Rafae Iaquinto  �Data �  09/01/12     ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera string com conte�do do XML, com os dados da Origem     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Remito Eletronico da Argentia - COT                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function XmlInfOrigem(aInfOrig)

Local cString := ""

local cEntOrigen	:= aInfOrig[1] //entrega_domicilio_origen
local cOrigCuit	:= aInfOrig[2] //origen_cuit
local cRazon 		:= aInfOrig[3] //origen_razon_social
local cEmiTenedor	:= aInfOrig[4] //emisor_tenedor
local cCalle  	:= aInfOrig[5] //origen_domicilio_calle
local cNum  		:= aInfOrig[6] //origen_domicilio_numero
local cCpl			:= aInfOrig[7] //origen_domicilio_comple
local cPiso		:= aInfOrig[8] //origen_domicilio_piso
local cDto			:= aInfOrig[9] //origen_domicilio_dto
local cBarrio		:= aInfOrig[10] //origen_domicilio_barrio
local cCodPost	:= aInfOrig[11] //origen_domicilio_codigopostal
local cLocalidad	:= aInfOrig[12] //origen_domicilio_localidad
local cProvinc	:= aInfOrig[13] //origen_domicilio_provincia

cString := '<inforigen>'
cString += '<entrega_domicilio_origen>'+cEntOrigen+'</entrega_domicilio_origen>'
cString += '<origen_cuit>'+cOrigCuit+'</origen_cuit>'
cString += '<origen_razon_social>'+ConvType(cRazon,50)+'</origen_razon_social>'
cString += '<emisor_tenedor>'+cEmiTenedor+'</emisor_tenedor>'
cString += '<origen_domicilio_calle>'+ConvType(cCalle,40)+'</origen_domicilio_calle>'
cString += NfeTag('<origen_domicilio_numero>',ConvType(cNum,5),.T.)
cString += NfeTag('<origen_domicilio_comple>',ConvType(cCpl,5))
cString += NfeTag('<origen_domicilio_piso>',ConvType(cPiso,3))
cString += NfeTag('<origen_domicilio_dto>',ConvType(cDto,4))
cString += NfeTag('<origen_domicilio_barrio>',ConvType(cBarrio,30))
cString += '<origen_domicilio_codigopostal>'+cCodPost+'</origen_domicilio_codigopostal>'
cString += '<origen_domicilio_localidad>'+ConvType(cLocalidad,50)+'</origen_domicilio_localidad>'
cString += '<origen_domicilio_provincia>'+cProvinc+'</origen_domicilio_provincia>'
cString += '</inforigen>'

Return(cString)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XmlInfRecorri  �Autor Rafae Iaquinto  �Data �  09/01/12     ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera string com conte�do do XML, com os dados do Recorrido  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Remito Eletronico da Argentia - COT                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function XmlInfRecorri(aInfRecor)

Local cString := ""

local cTransCuit	:= aInfRecor[1] //transportista_cuit
local cTpRecorri	:= aInfRecor[2] //tipo_recorrido
local cLocalidad	:= aInfRecor[3] //recorrido_localidad
local cCalle		:= aInfRecor[4] //recorrido_calle
local cRuta  		:= aInfRecor[5] //recorrido_ruta
local cVeicPatent	:= aInfRecor[6] //patente_vehiculo
local cAcopPatent	:= aInfRecor[7] //patente_acoplado
local cPrdNoTerm	:= aInfRecor[8] //producto_no_term_dev
local nImport		:= aInfRecor[9] //importe

cString := '<infrecorrido>'
cString += '<transportista_cuit>'+Convtype(cTransCuit)+'</transportista_cuit>'
cString += NfeTag('<tipo_recorrido>',ConvType(cTpRecorri))
cString += NfeTag('<recorrido_localidad>',ConvType(cLocalidad,50))
cString += NfeTag('<recorrido_calle>',ConvType(cCalle,40))
cString += NfeTag('<recorrido_ruta>',ConvType(cRuta,40))
cString += NfeTag('<patente_vehiculo>',ConvType(Alltrim(cVeicPatent),7))
cString += NfeTag('<patente_acoplado>',ConvType(Alltrim(cAcopPatent),7))
cString += '<producto_no_term_dev>'+cPrdNoTerm+'</producto_no_term_dev>'
cString += NfeTag('<importe>',Alltrim(ConvType(nImport,12,2)))  //alterar
cString += '</infrecorrido>'

Return(cString)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XmlInfProd  �Autor Rafae Iaquinto  �Data �  09/01/12        ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera string com conte�do do XML, com os dados do Produto    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Remito Eletronico da Argentia - COT                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function XmlInfProd(aProd)

Local cString := ""

local cCdUniProd	:= aProd[2] //codigo_unico_producto
local cUnidMed  	:= aProd[3] //rentas_codigo_unidad_medida
local nCantidad 	:= aProd[4] //cantidad
local cPropCdPrd	:= aProd[5] //proprio_codigo_producto
local cDescProd 	:= aProd[6] //proprio_descripcion_producto
local cPrpDescUM	:= aProd[7] //proprio_descripcion_unidad_medida
local nCtdAjust	:= aProd[8] //cantidad_ajustada

cString := '<producto>'
cString += '<codigo_unico_producto>'+ConvType(cCdUniProd,6)+'</codigo_unico_producto>'
cString += '<rentas_codigo_unidad_medida>'+ConvType(cUnidMed,1)+'</rentas_codigo_unidad_medida>'
cString += '<cantidad>'+Alltrim(ConvType(nCantidad,13,2))+'</cantidad>'
cString += '<proprio_codigo_producto>'+ConvType(cPropCdPrd,25)+'</proprio_codigo_producto>'
cString += '<proprio_descripcion_producto>'+ConvType(cDescProd,40)+'</proprio_descripcion_producto>'
cString += '<proprio_descripcion_unidad_medida>'+ConvType(cPrpDescUM,20)+'</proprio_descripcion_unidad_medida>'
cString += '<cantidad_ajustada>'+Alltrim(ConvType(nCtdAjust,13,2))+'</cantidad_ajustada>'
cString += '</producto>'

Return(cString)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ConvType �Autor  �Microsiga           � Data �              ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Converte tipos                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ConvType(xValor,nTam,nDec)
Local cNovo := ""
DEFAULT nDec := 0
Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))
			cNovo := StrTran(cNovo,",",".")
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 60
		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))
EndCase
Return(cNovo)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NoAcento �Autor  �Microsiga           � Data �              ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Valida acentos                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "�����"+"�����"
Local cCircu := "�����"+"�����"
Local cTrema := "�����"+"�����"
Local cCrase := "�����"+"�����"
Local cTio   := "��"
Local cCecid := "��"
Local cEComer:= "&"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase+cEComer
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	 	nY:= At(cChar,cEComer)
	 	If nY > 0
			cString := StrTran(cString,cChar,SubStr("y",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
cString := _NoTags(cString)
Return cString

/*����������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������Ŀ��
���Fun��o    �MyGetEnd  � Autor � Liber De Esteban             � Data � 19/03/09 ���
��������������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se o participante e do DF, ou se tem um tipo de endereco ���
���          � que nao se enquadra na regra padrao de preenchimento de endereco  ���
���          � por exemplo: Enderecos de Area Rural (essa verific��o e feita     ���
���          � atraves do campo ENDNOT).                                         ���
���          � Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ���
���          � Endereco (sem numero ou complemento). Caso contrario ira retornar ���
���          � o padrao do FisGetEnd                                             ���
��������������������������������������������������������������������������������Ĵ��
��� Obs.     � Esta funcao so pode ser usada quando ha um posicionamento de      ���
���          � registro, pois ser� verificado o ENDNOT do registro corrente      ���
��������������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAFIS                                                           ���
���������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������
����������������������������������������������������������������������������������*/
Static Function MyGetEnd(cEndereco,cAlias)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}
Local nIb		:=0
Local nIv		:=0

if cAlias == "SM0"
	cCmpEst	:= SubStr(cAlias,2,2)+"_ESTENT"
endif

//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
	aRet[1] := cEndereco
	aRet[3] := "SN"
Else
	aRet := FisGetEnd(cEndereco)
EndIf

Return aRet


Static Function NfeTag(cTag,cConteudo,lBranco)

Local cRetorno := ""
DEFAULT lbranco := .F.
If (!Empty(AllTrim(cConteudo)) .And. IsAlpha(AllTrim(cConteudo))) .Or. Val(AllTrim(cConteudo))<>0 .Or. lBranco
	cRetorno := cTag+AllTrim(cConteudo)+SubStr(cTag,1,1)+"/"+SubStr(cTag,2)
EndIf
Return(cRetorno)


Static Function cCodPr(cCodPR)   //steck abre
Local cCod:="  "  
Default cCodPR:=" "

       
cCodPR:=Alltrim(cCodPR)

If cCodPR== "SA"
	cCod:="A"	
ElseIf cCodPR==  "BA"
	cCod:="B"	
ElseIf cCodPR==  "CF"
	cCod:="C"	
ElseIf cCodPR==  "SL"
	cCod:="D"	
ElseIf cCodPR==  "ER"
	cCod:="E"
ElseIf cCodPR==  "LR"
	cCod:="F"	
ElseIf cCodPR==  "SE"
	cCod:="G"	
ElseIf cCodPR==  "CH"
	cCod:="H"	
ElseIf cCodPR==  "SJ"
	cCod:="J"	
ElseIf cCodPR==  "CA"
	cCod:="K"	
ElseIf cCodPR==  "LP"
	cCod:="L"	
ElseIf cCodPR==  "ME"
	cCod:="M"	
ElseIf cCodPR==  "MI"
	cCod:="N"	
ElseIf cCodPR==  "FO"
	cCod:="P"	
ElseIf cCodPR==  "NE"
	cCod:="Q"	
ElseIf cCodPR==  "RN"
	cCod:="R"	
ElseIf cCodPR==  "SF"
	cCod:="S"	
ElseIf cCodPR==  "TU"
	cCod:="T"	
ElseIf cCodPR==  "CB"
	cCod:="U"	
ElseIf cCodPR==  "TF"
	cCod:="V"	
ElseIf cCodPR==  "CR"
	cCod:="W"	
ElseIf cCodPR==  "CO"
	cCod:="X"	
ElseIf cCodPR==  "JU"
	cCod:="Y"	
ElseIf cCodPR==  "SC"
	cCod:="Z"	
EndIf

Return(cCod)    //steck fecha

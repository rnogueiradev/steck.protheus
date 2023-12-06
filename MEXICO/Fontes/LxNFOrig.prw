#INCLUDE "fwmvcdef.CH"
#INCLUDE "protheus.CH"
#INCLUDE "fwmvcdef.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �           �Autor  �                   � Data �  01/04/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pantalla para ligar los UUID de la factura de Anticipo      ���
���          �     														  ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1: "P" - Pedido - "F" - Notas Fiscais                   ���
�������������������������������������������������������������������������͹��
���Uso       � Desde Gatillo en C5_TIPREL                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
//FUNCION SI DEBE UTILIZARSE, LA HICE PARA KINETIC
User Function LxNFOrig(_cTipo)

Local	_cAlias:= GetArea()

Local cQuery   	:= ""
Local cUUID		:= ""
Local aPedidos := {}
Local cCliFor		:= ""
Local cLoja  		:= ""

IF _cTipo	==	"P"			//Viene desde Pedidos
	cCliFor		:= M->C5_CLIENTE            
	cLoja  		:= M->C5_LOJACLI
Else
	cCliFor		:= M->F2_CLIENTE            
	cLoja  		:= M->F2_LOJA
Endif

#IFDEF TOP
	If Empty(cCliFor) .OR. Empty(cLoja)
		Aviso("Indique los Campos","Cliente y Tienda",{"OK"}) //"Preencha os dados do Cliente e Loja"###"OK"
		Return cUUID
	EndIf
		cQuery := "SELECT 'LBNO' OK,CONCAT(F2_DOC,F2_SERIE) DOC,F2_CLIENTE CLIENTE, F2_LOJA LOJA,F2_UUID UUID"
		cQuery += " FROM "+RetSQLName("SF2")+" SF2 JOIN "+RetSQLName("SD2")+" SD2 ON (SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE) "
		cQuery += " AND SD2.D2_FILIAL=SF2.F2_FILIAL AND (SD2.D2_COD = '84111506       ') "
		cQuery += " WHERE F2_CLIENTE='"+cCliFor+"' AND F2_LOJA='"+cLoja+"' AND F2_FILIAL='"+XFilial("SF2")+"' AND F2_TIPODOC IN ('01','18') "
		cQuery += " GROUP BY F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA, F2_UUID 	"
		cQuery := ChangeQuery(cQuery)
		aPedidos := LxNFBrow(cQuery)
	If Len(aPedidos) > 0
		For x:=1 to Len(aPedidos)
		    cUUID += aPedidos[x]
		    cUUID += chr(13)+chr(10)
		End for
	EndIf
#ELSE
	Aviso("Esta Funcionalidad esta","disponible solo para TopConnect",{"OK"}) //"Essa funcionalidade est� dispon�vel apenas para TOPCONNECT",{"OK"}
#ENDIF
RestArea(_cAlias)

Return  cUUID



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LxNFBrow   �Autor  �Vendas/CRM         � Data �  13/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �View para Dialog de Marca��o dos Pedidos                    ���
�������������������������������������������������������������������������͹��
���Parametros�ExpC1: "P" - Pedido, "NF" - Notas Fiscais de Venda          ���
���          �ExpC2: Query utilizada para popular browse                  ���
�������������������������������������������������������������������������͹��
���Uso       � LxNFOrig                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LxNFBrow(cQuery)

Local aPedidos	:= {}
Local aSize		:= MsAdvSize( .F. )
Local aPosObj	:= {}
Local aObjects	:= {}
Local cAliasTRB	:= GetNextAlias()
Local aIndex	:= {}
Local nOpcA		:= 0
Local oDlgPd
Local oBrowsePd


//���������������������������������������������������������������������Ŀ
//� Calcula as coordenadas da interface                                 �
//�����������������������������������������������������������������������
aSize[1] /= 1.5
aSize[2] /= 1.5
aSize[3] /= 1.5
aSize[4] /= 1.3
aSize[5] /= 1.5
aSize[6] /= 1.3
aSize[7] /= 1.5

AAdd( aObjects, { 100, 020,.T.,.F.,.T.} )
AAdd( aObjects, { 100, 060,.T.,.T.} )
AAdd( aObjects, { 100, 020,.T.,.F.} )
aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects,.T.)

DEFINE MSDIALOG oDlgPd TITLE "Documentos" FROM aSize[7],000 TO aSize[6],aSize[5] OF oMainWnd PIXEL	//"Pedido","Nota Fiscal"

	DEFINE FWFORMBROWSE oBrowsePd DATA QUERY ALIAS cAliasTRB QUERY cQuery OF oDlgPd
		oBrowsePd:SetCacheView(.F.)	
		ADD MARKCOLUMN oColumn DATA { || OK } DOUBLECLICK { |oBrowsePd| LxNFBrMark(oBrowsePd,@aPedidos) } OF oBrowsePd

		ADD BUTTON oButton TITLE "OK" ACTION { || nOpcA := 1 , oDlgPd:End() } OF oBrowsePd	// "OK"

		ADD COLUMN oColumn DATA { || LOJA   	} TITLE "Cliente"							SIZE 10 OF oBrowsePd //"Cliente"
		ADD COLUMN oColumn DATA { || CLIENTE	} TITLE RetTitle("A1_LOJA")				SIZE 4  OF oBrowsePd //"Loja"
		ADD COLUMN oColumn DATA { || DOC		} TITLE "DOCUMENTO"	SIZE 10 OF oBrowsePd //"Nota Fiscal"
 //		oColumn:SetTitle("FACTURAS DE ANTICIPO")
		ADD COLUMN oColumn DATA { || UUID        } TITLE RetTitle("F2_UUID")		SIZE 20 OF oBrowsePd //uuid
//		ADD COLUMN oColumn DATA { || FECHA 		 } TITLE RetTitle("F2_FECTIMB")		SIZE 20 OF oBrowsePd //Fecha Timbrado

	ACTIVATE FWFORMBROWSE oBrowsePd

oDlgPd:Activate(NIL,NIL,NIL,.T.,NIL, NIL,{|| Iif((cAliasTRB)->(Eof() .AND. Aviso("Atencion","No hay informacion de documentos de Salida",{"OK"})==1),oDlgPd:End(),NIL)}) //"Aten��o","N�o h� informa��es de documentos de sa�da conforme pesquisa para este cliente.",{"OK"}


Return Iif(nOpca == 1,aPedidos,{})

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LxNFBrMark �Autor  �Vendas/CRM         � Data �  13/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Marcacao de Pedidos da LxPedBrow                            ���
�������������������������������������������������������������������������͹��
���Parametros�ExpO1: Objeto do Browse                                     ���
���          �ExpA2: Array dos pedidos passada por referencia p/ atualizar���
�������������������������������������������������������������������������͹��
���Uso       � LxNFBrow                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LxNFBrMark(oBrowsePd,aPedidos)

Local nPos

If &(oBrowsePd:Alias()+"->OK") == 'LBOK'
	nPos := aScan(aPedidos, &(oBrowsePd:Alias()+"->UUID"))
	aDel(aPedidos, nPos)
	aSize(aPedidos, Len(aPedidos)-1)
	&(oBrowsePd:Alias()+"->OK") := 'LBNO'
Else
	&(oBrowsePd:Alias()+"->OK") := 'LBOK'
	aAdd(aPedidos,&(oBrowsePd:Alias()+"->UUID"))
EndIf

Return

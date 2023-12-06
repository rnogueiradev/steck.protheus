#INCLUDE "PROTHEUS.CH"

#define  OPEN_FILE_ERROR -1
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ITAWMS12  �Autor  �Robson William      � Data �  23/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Geracao de pedido de venda a partir dos dados das solicita_ ���
���          �coes de compra                                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function IMPGRUPO()

Local _aArea	:= GetArea()
Local oWnd

Processa ( {|| FRUN() })

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ITAWMS12  �Autor  �Robson William      � Data �  23/09/05   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function frun()

Local _cArquivo := "c:\siga\steck\prexrgru"
Local nQtdReg   := 0
Local nPed      := ""
Local _bExist   := .F.
Private cEOL    := Chr(13) + Chr(10)

/*
���������������������������������������������������Ŀ
�Ira verificar se pedidos de venda ja foram gerados �
�baseados no pedido de compra informado no parametro�
�����������������������������������������������������
*/

If File(_cArquivo)
	
	FT_FUse(_cArquivo)
	FT_FGotop()
	
	While !FT_FEOF()
		
		xLinha := FT_FREADLN()
		
		cVend   := Substr(xLinha,1,6)
		cgrupo  := Substr(xLinha,8,3)
		nPercen := val(substr(xLinha,17,5))
		nVend   := Posicione("SA3",1,xFilial("SA3") + cVend ,"A3_NOME")
		ngrupo  := Posicione("SBM",1,xFilial("SBM") + cGRUPO,"BM_DESC")
		
		Reclock("SZ3",.T.)
		Replace  Z3_GRUPO    with  cgrupo
		Replace  Z3_VENDEDO  with  cVend
		Replace  Z3_NOMVEND  with  nVend
		Replace  Z3_NOMGRUP  with  nGrupo
		Replace  Z3_COMIS    with  nPercen
		msunlock()
		
		FT_FSKIP()
	EndDo
endif

RETURN()

//////////// VENDEDOR /  PRODUTO


User Function IMPPROD()

Local _aArea	:= GetArea()
Local oWnd

Processa ( {|| FRUN1() })

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ITAWMS12  �Autor  �Robson William      � Data �  23/09/05   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function frun1()

Local _cArquivo := "c:\siga\steck\prexrpro"
Local nQtdReg   := 0
Local nPed      := ""
Local _bExist   := .F.
Private cEOL    := Chr(13) + Chr(10)

/*
���������������������������������������������������Ŀ
�Ira verificar se pedidos de venda ja foram gerados �
�baseados no pedido de compra informado no parametro�
�����������������������������������������������������
*/

If File(_cArquivo)
	
	FT_FUse(_cArquivo)
	FT_FGotop()
	
	While !FT_FEOF()
		
		xLinha := FT_FREADLN()
		
		cVend   := Substr(xLinha,1,6)
		cPROD   := Substr(xLinha,8,12)
		nPercen := val(substr(xLinha,24,5))
		nVend   := Posicione("SA3",1,xFilial("SA3") + cVend ,"A3_NOME")
		nprod   := Posicione("SB1",1,xFilial("SB1") + cPROD,"B1_DESC")
		
		Reclock("SZ2",.T.)
		Replace  Z2_PRODUTO  with  cprod
		Replace  Z2_VENDEDO  with  cVend
		Replace  Z2_NOMVEND  with  nVend
		Replace  Z2_NOMPROD  with  nProd
		Replace  Z2_COMIS    with  nPercen
		msunlock()
		
		FT_FSKIP()
	EndDo
endif

RETURN()

#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA415BUT  �Autor  �RGV Solcuoes        � Data �  03/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA PARA INCLUIR BOTAO NA ENCHOICE BAR DO     ���
���          � ORCAMENTO.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//--------------------------------------------------------------------------//
//Altera��es Realizadas:
//FR - 30/11/2021 - #20211130025600 - Habilitar tela markup Protheus Andina
//--------------------------------------------------------------------------//

User Function MA415BUT()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local aButtons  := {}      

//Aadd(aButtons,{ "LINE"	, { || U_STFTPE01(.F.)	}, OemtoAnsi("Carrega Estrutura") })    
Aadd(aButtons   ,  { "line"	  , { || U_STHST01(.F.)	}   , OemtoAnsi("Historico Unicom") }) 

//FR - 30/11/2021 - #20211130025600 - Habilitar tela markup Protheus Andina
aAdd( aButtons  ,  {'PRECO'   , { || U_COTMKSCK(.T.) }  , 'Tela MarkUp'  } )  
// Valdemir Rabelo 31/10/2022 - Importar/Exportar
aAdd( aButtons  ,  {'Importar/Exportar'   , { || U_STEXPIMP('SCK') }  , 'Importar/Exportar'  } )  

Return(aButtons)  
                                                                                

  /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFTA001  �Autor  �Microsiga           � Data �  02/20/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STHST01()
 
Dbselectarea("PP8")
PP8->(dbsetorder(1))
PP8->(dbseek(xfilial("PP8")+SCJ->CJ_XUNICOM))

@ 000, 000 TO 430, 550 DIALOG oDlgX1 TITLE 'Historico de Unicom'
@ 005,005 Get PP8->PP8_HIST  Size 267,180 MEMO Object oMemo  //WHEN .F.
@ 192,235 BMPBUTTON TYPE 1 ACTION Close(oDlgX1)

ACTIVATE DIALOG oDlgX1 CENTERED

return
                                            
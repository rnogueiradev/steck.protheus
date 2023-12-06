#INCLUDE "rwmake.ch"

/*/{Protheus.doc} A710PAR
(Altera��o de parametros configura��es basicas do MRP Steck)

@author jefferson.carlos
@since 19/11/2019
@version 1.0
@return ${return}, ${return_description}

@history ,,

/*/

User Function ARMRPA01


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Configuracoes de MRP "

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

Private cDelFunc := ".T."  

Private cString := "PPB"

dbSelectArea("PPB")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return
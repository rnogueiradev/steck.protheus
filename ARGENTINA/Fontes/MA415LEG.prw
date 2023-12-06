#include 'protheus.ch'
#include 'parmtype.ch'

User Function MA415LEG()

Local aCores := {	{ 'ENABLE'    , "Abierto" },;
					{ 'DISABLE'   , "Aprobado" },;
					{ 'BR_PRETO'  , "Anulado" },; 
					{ 'BR_AMARELO', "No Presupuestado" },;
					{ 'BR_AZUL', 	"Fecha de Retorno proximo" },;
					{ 'BR_LARANJA',	"Fecha de Retorno en retraso" },;
					{ 'BR_MARROM' , "Bloqueado" }}
	
Return(aCores)
from tir import Webapp
import unittest

class PROCESSOVENDA(unittest.TestCase):

	@classmethod
	def setUpClass(inst):
		inst.oHelper = Webapp()
		inst.oHelper.Setup('sigamdi','24/07/23','11','01','13')
		#inst.oHelper.Program('MATA030')
		inst.oHelper.SetLateralMenu("Especificos Fsw > Atendimento > Call Steck")
	
	def test_TMKA271_001(self):

		#inclusão do orçamento com bloqueio de valor e desconto
		self.oHelper.SetButton('Confirmar')
		self.oHelper.SetButton('x') #Tela de aviso da 2310
		self.oHelper.SetButton("Incluir")
		self.oHelper.SetButton('OK')

		Filial = "01"
		cOrcamento = self.oHelper.GetValue("UA_NUM")
		cValor = "27,93"

		self.oHelper.SetValue("UA_CLIENTE","000224")
		self.oHelper.SetValue("UA_CODCONT","001508")
		self.oHelper.SetValue("UA_XCONDPG","501")
		self.oHelper.SetValue("UA_TPFRETE","C")
		self.oHelper.SetValue("UA_TRANSP","004064")
		self.oHelper.SetValue("UA_XTIPFAT","2")
		self.oHelper.SetValue("UA_XORDEM",".")
		
		self.oHelper.SetValue("UB_PRODUTO", "N3076", grid=True)
		self.oHelper.SetValue("UB_QUANT", "1,00", grid=True)
		#self.oHelper.SetValue("% Desconto", "1,00", grid=True)

		self.oHelper.LoadGrid()

		self.oHelper.SetButton("Salvar")

		#self.oHelper.SetValue("Motivo: ","TESTE DE DESCONTO UTILIZANDO O TIR")
		#self.oHelper.SetButton("Ok")
		
		self.oHelper.SetButton("Ok")
		self.oHelper.SetButton("Cancelar")
		self.oHelper.SetButton("Cancelar")
		self.oHelper.SetButton("Sim")

		#conferencia de valor
		self.oHelper.SearchBrowse(Filial+cOrcamento, key=1, index=True)
		self.oHelper.SetButton('Visualizar')
		self.oHelper.CheckResult("UB_VRUNIT", cValor , grid=True, line=1)  
		self.oHelper.LoadGrid()
		self.oHelper.SetButton('Cancelar')
		self.oHelper.SetButton('x')

		#liberação alçada de desconto
		#self.oHelper.SetLateralMenu("Especificos Fsw > Atendimento > Alçada Comercial")
		#self.oHelper.SetButton('Confirmar')
		#self.oHelper.SetButton('x')
		#self.oHelper.SearchBrowse(cOrcamento, key=3, index=True)
		#self.oHelper.SetButton('Aprovar')
		#self.oHelper.SetButton('Salvar')
		#self.oHelper.SetButton('Ok')
		#self.oHelper.SetButton('Sim')
		#self.oHelper.SetButton('x')

		#virar orçamento para pedido - vai bloquear por valor
		self.oHelper.SetLateralMenu("Especificos Fsw > Atendimento > Call Steck")
		self.oHelper.SetButton('Confirmar')
		self.oHelper.SetButton('x')
		self.oHelper.SearchBrowse(Filial+cOrcamento, key=1, index=True)
		self.oHelper.SetButton('Alterar')
		self.oHelper.SetValue("UA_OPER", "1 - Faturamento")
		self.oHelper.SetButton('Salvar')
		self.oHelper.SetButton('Fechar')
		self.oHelper.SetButton('Cancelar')
		self.oHelper.SetButton('Cancelar')
		self.oHelper.SetButton('Sim')
		self.oHelper.SetButton('x')

		#aprovar por valor
		self.oHelper.SetLateralMenu("Especificos Fsw > Atendimento > Aprovação orçamento")
		self.oHelper.SetButton('Confirmar')
		self.oHelper.SetButton('x')
		self.oHelper.SearchBrowse(Filial+cOrcamento, key=1, index=True)
		self.oHelper.SetButton('Liberar')
		self.oHelper.SetButton('Salvar')
		self.oHelper.SetButton('Ok')
		self.oHelper.SetButton('Cancelar')
		self.oHelper.SetButton('Cancelar')
		self.oHelper.SetButton('Sim')
		self.oHelper.SetButton('x')

		#virar orçamento para pedido
		self.oHelper.SetLateralMenu("Especificos Fsw > Atendimento > Call Steck")
		self.oHelper.SetButton('Confirmar')
		self.oHelper.SetButton('x')
		self.oHelper.SearchBrowse(Filial+cOrcamento, key=1, index=True)
		self.oHelper.SetButton('Alterar')
		self.oHelper.SetValue("UA_OPER", "1 - Faturamento")
		self.oHelper.SetButton('Salvar')
		self.oHelper.SetButton('Sim')
		self.oHelper.SetButton('OK')
		self.oHelper.SetButton('OK')
		self.oHelper.SetButton('Cancelar')
		self.oHelper.SetButton('Sim')
		self.oHelper.SearchBrowse(Filial+cOrcamento, key=1, index=True)
		self.oHelper.SetButton('Visualizar')
		self.oHelper.SetButton('Continuar')
		cPedido = self.oHelper.GetValue("UA_NUMSC5")
		self.oHelper.SetButton('Cancelar')
		self.oHelper.SetButton('x')

		#liberar pedido no financeiro
		self.oHelper.Setup('sigamdi','24/07/23','11','01','05')
		self.oHelper.SetLateralMenu("Atualizações > Pedidos > An.credito pedido")
		self.oHelper.SetButton('Confirmar')
		self.oHelper.SetButton('x')
		self.oHelper.SetValue("Somente Bloqueados ?", "Nao")
		self.oHelper.SetButton('Ok')
		self.oHelper.SearchBrowse(Filial+cPedido, key=1, index=True)
		self.oHelper.SetButton('Manual')
		self.oHelper.SetButton('Sim')
		self.oHelper.SetButton('Ok')
		self.oHelper.SetButton('x')

		#rodar rotina de reserva/falta
		self.oHelper.Setup('sigamdi','24/07/23','11','01','78')
		self.oHelper.SetLateralMenu("Miscelanea > Executar Programas")
		self.oHelper.SetButton('Confirmar')
		self.oHelper.SetButton('x')
		self.oHelper.SetValue("Nome da Função", "U_MSTECK16")
		self.oHelper.SetButton('Confirmar')

		#gerar OS e alocar
		self.oHelper.Setup('sigamdi','24/07/23','11','01','05')
		self.oHelper.SetLateralMenu("Especificos Fsw > Faturamento > Prioridade Exp")
		self.oHelper.SetButton('Confirmar')
		self.oHelper.SetButton('x')
		self.oHelper.ClickFolder("Ordem de Separação - Expedição (03)")
		self.oHelper.SetButton('Gera Ordem de Separação')

		self.oHelper.AssertTrue()

	@classmethod
	def tearDownClass(inst):
		inst.oHelper.TearDown()

if __name__ == '__main__':
	unittest.main()
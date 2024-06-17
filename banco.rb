# Variáveis globais
$saldo = 0.0          # Inicializa o saldo do banco como 0.0.
$historico = []       # Inicializa uma lista vazia para armazenar o histórico de transações.

# Função para realizar depósitos:
def depositar(valor)
  if valor <= 0
    puts "Valor inválido para depósito!"
    return
  end

  # Adiciona o valor do depósito ao saldo
  $saldo += valor
  # Adiciona a transação ao histórico
  $historico << "Depósito de R$#{'%.2f' % valor}"
  puts "Depósito realizado com sucesso!"
end

# Função para realizar saques:
def sacar(valor)
  if valor <= 0
    puts "Valor inválido para saque!"
    return
  end

  # Verifica se há saldo suficiente para realizar o saque
  if $saldo < valor
    puts "Saldo insuficiente para saque!"
    return
  end

  # Subtrai o valor do saque do saldo
  $saldo -= valor
  # Adiciona a transação ao histórico
  $historico << "Saque de R$#{'%.2f' % valor}"
  puts "Saque realizado com sucesso!"
end

# Função para mostrar o histórico de transações:
def mostrar_historico
  puts "Histórico de Transações:"
  for transacao in $historico
    puts transacao
  end
end

loop do
  # Mostra o menu de opções ao usuário
  puts "\nBem-vindo ao Banco Softex!"
  puts "Escolha uma opção:"
  puts "1. Depósito"
  puts "2. Saque"
  puts "3. Histórico"
  puts "4. Sair"
  print "Opção: "
  opcao = gets.chomp.to_i

  # Executa a ação com base na opção escolhida
  case opcao
  when 1
    print "Digite o valor do depósito: R$"
    valor = gets.chomp.to_f
    depositar(valor)
  when 2
    print "Digite o valor do saque: R$"
    valor = gets.chomp.to_f
    sacar(valor)
  when 3
    mostrar_historico
  when 4
    puts "Obrigado por usar o Banco Softex! Até logo!"
    break                    # Sai do loop e encerra o programa
  else
    puts "Opção inválida! Tente novamente."
  end

  puts "Seu saldo atual é: R$#{'%.2f' % $saldo}"
end

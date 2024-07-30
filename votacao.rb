# Função para validar CPF
def valida_cpf(cpf)
    cpf = cpf.to_s
    return false if cpf.length != 11
  
    # Calcula o primeiro dígito verificador
    soma = (0..8).map { |i| cpf[i].to_i * (10 - i) }.reduce(:+)
    primeiro_dv = 11 - soma % 11
    primeiro_dv = 0 if primeiro_dv >= 10
  
    # Calcula o segundo dígito verificador
    soma = (0..9).map { |i| cpf[i].to_i * (11 - i) }.reduce(:+)
    segundo_dv = 11 - soma % 11
    segundo_dv = 0 if segundo_dv >= 10
  
    # Verifica os dígitos calculados com os dígitos informados
    cpf[-2].to_i == primeiro_dv && cpf[-1].to_i == segundo_dv
  end
  
  # Função para coletar voto do eleitor
  def coleta_voto
    loop do
      system("cls")
      puts "Digite o número do candidato (0 - Branco, 1 - João, 2 - Maria, 3 - Luciana):"
      voto = gets.chomp.to_i
      case voto
      when 0 then return 'Branco'
      when 1 then return 'João'
      when 2 then return 'Maria'
      when 3 then return 'Luciana'
      else
        return 'Nulo'
      end
    end
  end
  
  # Função para confirmação do voto
  def confirma_voto(candidato)
    loop do
      puts "Voto computado para o candidato #{candidato}. Deseja confirmar? (s/n):"
      confirmacao = gets.chomp.downcase
      return true if confirmacao == 's'
      return false if confirmacao == 'n'
      puts "Entrada inválida. Por favor, digite 's' para sim ou 'n' para não."
    end
  end
  
  # Inicialização de variáveis
  votos = { 'João' => 0, 'Maria' => 0, 'Luciana' => 0, 'Branco' => 0, 'Nulo' => 0 }
  eleitores = {}
  
  # Loop principal para o processo de votação
  loop do
    puts "Digite seu CPF (ou 010101 para terminar):"
    cpf = gets.chomp
  
    # Verifica se o CPF digitado é o código para terminar a votação
    break if cpf == '010101'
  
    # Valida o CPF digitado
    if valida_cpf(cpf)
      # Verifica se o eleitor já votou
      if eleitores[cpf]
        puts "CPF já utilizado para votar. Por favor, tente novamente."
      else
        # Loop para coleta e confirmação do voto
        loop do
          candidato = coleta_voto
          if confirma_voto(candidato)
            votos[candidato] += 1
            eleitores[cpf] = true
            puts "Voto confirmado para o candidato #{candidato}."
            break
          else
            puts "Voto não confirmado. Reiniciando processo de votação."
          end
        end
      end
    else
      puts "CPF inválido. Por favor, digite novamente."
    end
  end
  
  # Calcula o total de votos
  total_votos = votos.values.reduce(:+)
  
  # Determina o vencedor da eleição
  vencedor, votos_vencedor = votos.max_by { |_, qtd_votos| qtd_votos }
  
  # Exibe o total de votos apurados, o vencedor e a quantidade de votos que ele obteve
  system("cls")
  puts "Total de votos apurados: #{total_votos}"
  puts "Vencedor da eleição: #{vencedor} com #{votos_vencedor} votos"
  
  # Ordena os candidatos por número de votos (decrescente) e, em caso de empate, por nome (alfabética)
  resultado_ordenado = votos.sort_by { |candidato, qtd_votos| [-qtd_votos, candidato] }
  
  # Determina a colocação de cada candidato
  colocacao = 1
  votos_anteriores = -1
  puts "Relação dos candidatos por ordem de votos:"
  resultado_ordenado.each_with_index do |(candidato, qtd_votos), index|
    # Atualiza a colocação apenas se o número de votos for diferente do anterior
    if qtd_votos != votos_anteriores
      colocacao = index + 1
    end
    puts "#{colocacao}. #{candidato}: #{qtd_votos} votos"
    votos_anteriores = qtd_votos
  end
  
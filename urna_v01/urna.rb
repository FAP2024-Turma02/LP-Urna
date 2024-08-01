require 'csv'

candX = 0
candY = 0
candZ = 0
brancos = 0
nulos = 0

clear_command = Gem.win_platform? ? 'cls' : 'clear'

system(clear_command)
puts 'Bem Vindo ao sistema de Urna Eletronica do grupo 5 da Softex'

print "Digite a quantidade de eleitores para essa votação: "
voter_number = gets.chomp.to_i

# Loop principal para cada eleitor
for voter_count in 1..voter_number
  system(clear_command)
  puts "******* Menu: *******"
  puts "====================="
  puts "1 - Votar."
  puts "2 - Encerrar votação."

  escolha = gets.chomp.to_i

  case escolha
  when 1
    system(clear_command)
    loop do
      puts "Escolha o(a) seu(sua) candidato(a): \n 89 - Pedro \n 47 - José \n 51 - Maria \n 0 - Branco"

      print "Digite o número do(a) candidato(a): "
      voto = gets.chomp

      if voto.match?(/\A\d+\z/) # Verifica se o input é um número
        voto = voto.to_i

        case voto
        when 89
          candidato = 'Candidato(a) Pedro'
        when 47
          candidato = 'Candidato(a) José'
        when 51
          candidato = 'Candidata Maria'
        when 0
          candidato = 'Branco'
        else
          candidato = 'Nulo'
        end

        system(clear_command)

        puts "Confirma voto para #{candidato}? (S/N)"
        confirmacao = gets.chomp.upcase

        if confirmacao == 'S'
          if voto == 89
            candX += 1
          elsif voto == 47
            candY += 1
          elsif voto == 51
            candZ += 1
          elsif voto == 0
            brancos += 1
          else
            nulos += 1
          end
          break
        else
          system(clear_command)
          puts "Opção inválida. Digite S para confirmar ou N para corrigir o voto."
          sleep(2)
        end
      else
        puts "Entrada inválida. Por favor, digite apenas números."
        sleep(2)
      end
    end

  when 2
    break
  else
    system(clear_command)
    puts "Opção inválida. Escolha 1 para votar ou 2 para encerrar a votação."
    sleep(2)
  end
end

# Determina o vencedor
if candX > candY && candX > candZ
  vitorioso = 'Candidato(a) Pedro'
elsif candY > candX && candY > candZ
  vitorioso = 'Candidato(a) José'
elsif candZ > candX && candZ > candY
  vitorioso = 'Candidata Maria'
else
  vitorioso = 'Aconteceu um Empate'
end

system(clear_command)

# Exibe os resultados
total_votos = candX + candY + candZ + brancos + nulos
puts "O ganhador desta eleição é:\n\n ***** #{vitorioso} *****\n"
puts "\n#{total_votos} votos totalizados, sendo:"
puts "\n Candidato(a) Pedro: #{candX} votos."
puts " Candidato(a) José: #{candY} votos."
puts " Candidata Maria: #{candZ} votos."
puts " Brancos e nulos: #{brancos + nulos} votos.\n Sendo:"
puts " Brancos: #{brancos}"
puts " Nulos: #{nulos}"


# Verifica se o arquivo já existe e trata de acordo
arquivo_existente = "resultados_votacao.csv"
if File.exist?(arquivo_existente)
  puts "\nO arquivo 'resultados_votacao.csv' já existe. Deseja sobrescrever? (S/N)"
  resposta = gets.chomp.upcase
  if resposta == 'N'
    puts "Digite um novo nome para o arquivo (sem extensão):"
    novo_nome = gets.chomp
    arquivo_existente = "#{novo_nome}.csv"
  end
end

# Cria o arquivo CSV com os resultados da votação
CSV.open(arquivo_existente, "w") do |csv|
  csv << ["Candidato", "Votos"]
  csv << ["Pedro", candX]
  csv << ["José", candY]
  csv << ["Maria", candZ]
  csv << ["Brancos", brancos]
  csv << ["Nulos", nulos]
end

puts "Os resultados foram salvos no arquivo '#{arquivo_existente}'."

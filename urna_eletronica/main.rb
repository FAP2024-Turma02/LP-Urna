require_relative 'urna'
require_relative 'validacao_cpf'

urna = UrnaEletronica.new

loop do
  puts "Digite seu CPF (ou 'sair' para encerrar):"
  input_cpf = gets.chomp
  break if input_cpf.downcase == 'sair'

  if validar_cpf(input_cpf)
    if urna.eleitores.include?(input_cpf)
      puts "Este CPF já votou!"
    else
      loop do
        urna.mostrar_candidatos
        puts "Digite o número do candidato desejado (ou '1' para Branco, '0' para Nulo):"
        input_candidato = gets.chomp

        if urna.votar(input_cpf, input_candidato)
          puts "Voto registrado com sucesso. Obrigado por votar!"
          break
        end
      end
    end
  else
    puts "CPF inválido. Por favor, tente novamente."
  end
end

puts "Obrigado por usar a urna eletrônica!"
urna.mostrar_resultados
urna.salvar_resultados

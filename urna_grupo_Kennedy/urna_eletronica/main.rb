require_relative 'urna'

urna = UrnaEletronica.new

loop do
  puts "Digite seu CPF (ou 'sair' para encerrar):"
  input_cpf = gets.chomp
  break if input_cpf.downcase == 'sair'

  if urna.eleitores.include?(input_cpf)
    puts "Este CPF já votou!"
  else
    # Tentar votar e verificar se o CPF é válido dentro do método votar
    loop do
      urna.mostrar_candidatos
      puts "Digite o número do candidato desejado (ou '1' para Branco, '0' para Nulo):"
      input_candidato = gets.chomp

      # Tentar votar e verificar se o CPF é válido dentro do método votar
      if urna.votar(input_cpf, input_candidato)
        puts "Voto registrado com sucesso. Obrigado por votar!"
        break
      elsif !ValidacaoCpf.validar(input_cpf)
        puts "CPF inválido. Por favor, tente novamente."
        break
      end
    end
  end
end

puts "Obrigado por usar a urna eletrônica!"
urna.mostrar_resultados
urna.salvar_resultados

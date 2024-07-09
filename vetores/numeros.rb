numeros = []

loop do
  puts "Digite um número inteiro (ou digite 'sair' para finalizar):"
  input = gets.chomp

  break if input.downcase == 'sair'

  begin
    numero = Integer(input)
    numeros << numero
  rescue ArgumentError
    puts "Por favor, digite um número inteiro válido."
  end
end

numeros.sort!

puts "Números digitados (em ordem):"
puts numeros

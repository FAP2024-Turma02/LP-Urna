require 'cpf_cnpj'

module ValidacaoCpf
  def self.validar(cpf)
    CPF.valid?(cpf)
  end
end

# def validar_cpf(cpf)
#   cpf = cpf.gsub(/[^\d]/, '')

#   return false if cpf.length != 11
#   return false if cpf.chars.uniq.length == 1 # CPFs com todos os dígitos iguais são inválidos

#   [9, 10].each do |i| # Verifica os dois dígitos verificadores
#     soma = 0
#     cpf.chars.first(i).each_with_index do |char, index|
#       soma += char.to_i * ((i + 1) - index)
#     end

#     digito_verificador = (soma * 10) % 11
#     digito_verificador = 0 if digito_verificador == 10

#     return false if digito_verificador != cpf[i].to_i
#   end

#   true
# end

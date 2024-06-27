require_relative 'validacao_cpf'
require 'csv'

class UrnaEletronica
  attr_reader :eleitores  # Método de leitura para @eleitores

  def initialize
    @eleitores = []
    @candidatos = {
      "13" => "Pedro",
      "22" => "Paulo",
      "15" => "Maria",
      "1" => "Branco",
      "0" => "Nulo"
    }
  end

  def votar(cpf, candidato)
    if @eleitores.include?(cpf)
      puts "Este CPF já votou."
      return false
    elsif @candidatos.key?(candidato)
      salvar_voto(cpf, candidato)
      @eleitores << cpf unless candidato == "-0"  # Não adiciona eleitores em caso de voto nulo
      puts "Voto registrado para #{@candidatos[candidato]}."
      return true
    else
      puts "Opção inválida. Por favor, escolha uma opção válida."
      return false
    end
  end

  def mostrar_candidatos
    @candidatos.each { |numero, nome| puts "#{numero}: #{nome}" }
  end

  def salvar_voto(cpf, candidato)
    CSV.open("votos.csv", "a") do |csv|
      csv << [cpf, @candidatos[candidato]]
    end
  end

  def calcular_resultados
    resultados = Hash.new(0)

    CSV.foreach("votos.csv", headers: false) do |row|
      voto = row[1]
      resultados[voto] += 1
    end

    resultados
  end

  def mostrar_resultados
    resultados = calcular_resultados

    puts "Resultados Finais:"
    resultados.each do |candidato, votos|
      puts "#{candidato}: #{votos} voto(s)"
    end
  end

  def salvar_resultados
    resultados = calcular_resultados

    CSV.open("resultados.csv", "w") do |csv|
      csv << ["Candidato", "Votos"]
      resultados.each do |candidato, votos|
        csv << [candidato, votos]
      end
    end
  end
end

require_relative 'validacao_cpf'
require 'csv'

class UrnaEletronica
  attr_reader :eleitores

  def initialize
    @eleitores = []
    @candidatos = {
      "13" => "Pedro",
      "22" => "Paulo",
      "15" => "Maria",
      "1" => "Branco",
      "0" => "Nulo"
    }
    @votos = Hash.new(0)
  end

  def votar(cpf, candidato)
    unless ValidacaoCpf.validar(cpf)
      puts "CPF inválido."
      return false
    end

    if @eleitores.include?(cpf)
      puts "Este CPF já votou."
      return false
    elsif @candidatos.key?(candidato)
      salvar_voto(cpf)
      registrar_voto(candidato)
      @eleitores << cpf  # Adiciona CPF à lista de eleitores.
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

  #salva o cpf do eleito para garantir que nao haverà duplicidade
  def salvar_voto(cpf)
    CSV.open("urna_grupo_Kennedy/urna_eletronica/votos.csv", "a") do |csv|
      csv << [cpf]
    end
  end

  def registrar_voto(candidato)
    @votos[@candidatos[candidato]] += 1
  end

  def calcular_resultados
    @votos
  end

  def mostrar_resultados
    resultados = calcular_resultados

    puts "Resultados Finais:"
    resultados.each do |candidato, votos|
      puts "#{candidato}: #{votos} voto(s)"
    end

    # mostra o ranking dos candidatos
    vencedor, votos_vencedor = resultados.max_by { |_, votos| votos }
    perdedor, votos_perdedor = resultados.min_by { |_, votos| votos }

    puts "Vencedor: #{vencedor} com #{votos_vencedor} voto(s)"
    puts "Último colocado: #{perdedor} com #{votos_perdedor} voto(s)"
  end

  def salvar_resultados
    resultados = calcular_resultados

    CSV.open("urna_grupo_Kennedy/urna_eletronica/resultados.csv", "w") do |csv|
      csv << ["Candidato", "Votos"]
      resultados.each do |candidato, votos|
        csv << [candidato, votos]
      end
    end
  end
end

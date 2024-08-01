# Classe que representa um candidato
class Candidato
    attr_reader :numero, :nome, :votos
  
    # Inicializa um candidato com número, nome e votos
    def initialize(numero, nome)
      @numero = numero
      @nome = nome
      @votos = 0
    end
  
    # Adiciona um voto ao candidato
    def adicionar_voto
      @votos += 1
    end
  end
  
  # Classe que representa a urna eletrônica
  class UrnaEletronica
    def initialize
      # Lista de candidatos para Prefeito de Recife 2020
      @candidatos = [
        Candidato.new(10, "Marília Arraes"),
        Candidato.new(25, "Mendonça Filho"),
        Candidato.new(45, "Carlos Andrade Lima"),
        Candidato.new(50, "João Campos")
      ]
      # Hash para armazenar eleitores (cpf => nome)
      @eleitores = {}
      # Hash para armazenar votos dos eleitores (cpf => voto)
      @votos = {}
      # Contadores para votos nulos e brancos
      @votos_nulos_brancos = 0
    end
  
    # Método principal que inicia a votação
    def iniciar_votacao
      limpar_tela # Limpa o terminal
      puts "Bem-vindo à Urna Eletrônica!" # Mensagem de boas-vindas
      loop do
        puts "\nDigite seu CPF para votar (ou 'fim' para encerrar):"
        cpf = gets.chomp # Lê o CPF do usuário
        break if cpf.downcase == 'fim' # Sai do loop se o usuário digitar 'fim'
  
        cpf = cpf.gsub(/[.\-]/, '') # Remove pontos e traços do CPF
  
        if cpf_valido?(cpf) # Verifica se o CPF é válido
          if @eleitores.key?(cpf)
            puts "Você já votou!" # Informa ao eleitor que ele já votou
          else
            puts "Digite seu nome:"
            nome = gets.chomp # Lê o nome do usuário
            votar_para_prefeito(cpf, nome) # Permite o eleitor votar para prefeito
          end
        else
          puts "CPF inválido! Tente novamente." # Informa que o CPF é inválido
        end
      end
      exibir_resultados # Exibe os resultados finais da votação
    end
  
    private
  
    # Limpa o terminal
    def limpar_tela
      system("clear") || system("cls")
    end
  
    # Verifica se o CPF é válido usando o cálculo dos dígitos verificadores
    def cpf_valido?(cpf)
      return false unless cpf.match?(/^\d{11}$/) # Verifica se o CPF tem 11 dígitos
  
      numeros = cpf.chars.map(&:to_i) # Converte os caracteres do CPF em números
      return false if numeros.uniq.size == 1 # Verifica se todos os dígitos não são iguais
  
      # Cálculo do primeiro dígito verificador
      soma = (0..8).map { |i| numeros[i] * (10 - i) }.reduce(:+)
      primeiro_digito = (soma * 10 % 11) % 10
      return false unless primeiro_digito == numeros[9]
  
      # Cálculo do segundo dígito verificador
      soma = (0..9).map { |i| numeros[i] * (11 - i) }.reduce(:+)
      segundo_digito = (soma * 10 % 11) % 10
      segundo_digito == numeros[10]
    end
  
    # Realiza a votação para o cargo de Prefeito
    def votar_para_prefeito(cpf, nome)
      puts "\nEscolha seu candidato para Prefeito:"
      
      # Usando um loop for para iterar sobre os candidatos
      for i in 0...@candidatos.length
        candidato = @candidatos[i]
        puts "#{candidato.numero} - #{candidato.nome}"
      end
      
      puts "Digite '0' para voto NULO ou BRANCO."
      voto = gets.chomp.to_i
  
      if voto == 0
        @votos_nulos_brancos += 1 # Incrementa o contador de votos nulos e brancos
        puts "Voto NULO ou BRANCO registrado para Prefeito."
      else
        candidato_encontrado = nil
        for i in 0...@candidatos.length
          if @candidatos[i].numero == voto
            candidato_encontrado = @candidatos[i]
            break
          end
        end
  
        if candidato_encontrado
          candidato_encontrado.adicionar_voto
          @eleitores[cpf] = nome # Registra o nome e o CPF do eleitor
          @votos[cpf] = voto # Registra o voto do eleitor
          puts "Voto registrado com sucesso para Prefeito!"
        else
          @votos_nulos_brancos += 1 # Incrementa o contador de votos nulos e brancos
          puts "Número inválido! Voto NULO ou BRANCO registrado para Prefeito."
        end
      end
    end
  
    # Exibe os resultados finais da votação
    def exibir_resultados
      limpar_tela # Limpa o terminal
      puts "\nResultados da votação para Prefeito:"
      for i in 0...@candidatos.length
        candidato = @candidatos[i]
        puts "#{candidato.nome}: #{candidato.votos} votos" # Exibe os votos de cada candidato
      end
      puts "Votos NULOS ou BRANCOS: #{@votos_nulos_brancos}" # Exibe a quantidade de votos nulos ou brancos
    end
  end
  
  # Inicia a votação instanciando a classe UrnaEletronica e chamando o método iniciar_votacao
  urna = UrnaEletronica.new
  urna.iniciar_votacao
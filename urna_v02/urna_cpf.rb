require 'csv'

def start_urna
    loop do
        clear_screen
        display_menu # melhorar o nome das variaveis, colocar um nome que seja mais correto com o que é feito, adicionar n˘ da linha

        option = gets.chomp.to_i

        case option
        when 1
            start_voting
        when 2
            finish_session
            break
        else
            puts "Opção inválida. Tente novamente."
        end
    end
end

def display_menu
    puts "------------------URNA-ELETRONICA------------------"
    puts "1 - INICIAR VOTACAO"
    puts "2 - ENCERRAR SESSAO"
    print "Digite: "
end

def start_voting
    cpf = get_cpf
    if cpf && check_cpf(cpf)
        show_candidates
        validate_vote(cpf)
    else
        puts "ESSE CPF É INVALIDO OU JA FOI USADO NESTA VOTACAO!\nTENTE NOVAMENTE"
        start_voting
    end
end

def get_cpf
    print "Digite seu CPF (apenas números): "
    cpf = gets.chomp
    if valid_cpf?(cpf)
        cpf
    else
        puts "CPF inválido."
        nil
    end
end

def check_cpf(cpf)
    !$voters.include?(cpf)
end

def valid_cpf?(cpf)
    return false unless cpf.match?(/^\d{11}$/)

    digits = cpf.chars.map(&:to_i)
    first_verifier = calculate_verifier(digits, 9)
    second_verifier = calculate_verifier(digits, 10)

    first_verifier == digits[9] && second_verifier == digits[10]
end

def calculate_verifier(digits, length)
    sum = digits[0...length].each_with_index.reduce(0) do |acc, (digit, index)|
        acc + digit * (length + 1 - index)
    end

    remainder = sum % 11
    remainder < 2 ? 0 : 11 - remainder
end

def show_candidates
    clear_screen
    puts "|----------LISTA DE CANDIDATOS----------|"
    puts "|    DIGITO    |          NOME          |"
    puts "|---------------------------------------|"
    puts "|      21      |          JOAO          |"
    puts "|      23      |          MARIA         |"
    puts "|      10      |          PEDRO         |"
    puts "|       0      |          BRANCO        |"
    puts "|---------------------------------------|\n\n"
    print "DIGITE O NUMERO DO CANDIDATO QUE DESEJA VOTAR: "
end

def validate_vote(cpf)
    vote = gets.chomp
    if vote.match?(/^\d+$/) # apenas dígitos
        vote = vote.to_i
        if $candidates.key?(vote) || vote == 0
            confirm_vote(vote, cpf)
        else
            puts "Número inválido. Voto considerado como nulo."
            confirm_vote(1, cpf) # Voto nulo
        end
    else
        puts "Entrada inválida. Por favor, digite apenas números."
        validate_vote(cpf)
    end
end

def confirm_vote(vote, cpf)
    candidate = $candidates[vote] || "NULO"
    print "CONFIRMAR VOTO EM #{candidate}? (S/N): "

    confirm = gets.chomp.upcase
    if confirm == 'S'
        compute_vote(candidate, cpf)
        puts "VOTO FEITO COM SUCESSO!"
    else
        puts "Voto não confirmado. Iniciando novamente."
        validate_vote(cpf)
    end
end

def compute_vote(candidate, cpf)
    $votes[candidate] += 1
    $voters << cpf
    $total_votes += 1
end

def clear_screen
    clear_command = Gem.win_platform? ? 'cls' : 'clear'
    sleep(1)
    system(clear_command)
end

def finish_session
    clear_screen
    puts "Votação encerrada. Resultados finais:"
    display_results
    save_results
end

def display_results
    puts "\nResultado da votação:"
    $votes.each do |candidate, votes|
        puts "#{candidate}: #{votes} votos"
    end
    puts "Total de votos: #{$total_votes}"
    #adicionar aqui quem foi mais votado e quem foi menos votado
    # Adicionar aqui quem foi o vencedor.
end

def save_results
    arquivo_existente = "resultados_votacao.csv"
    if File.exist?(arquivo_existente)
        puts "O arquivo 'resultados_votacao.csv' já existe. Deseja sobrescrever? (S/N)"
        resposta = gets.chomp.upcase
        if resposta == 'N'
            puts "Digite um novo nome para o arquivo (sem extensão):"
            novo_nome = gets.chomp
            arquivo_existente = "#{novo_nome}.csv"
        end
    end

    CSV.open(arquivo_existente, "w") do |csv|
        csv << ["Candidato", "Votos"]
        $votes.each do |candidate, votes|
            csv << [candidate, votes]
        end
    end

    puts "Os resultados foram salvos no arquivo '#{arquivo_existente}'."
end

# VARIÁVEIS GLOBAIS

# Votos totais
$total_votes = 0

# Eleitores = CPFs que já votaram
$voters = []

# Votos por candidatos
$votes = {
  "JOAO" => 0,
  "MARIA" => 0,
  "PEDRO" => 0,
  "BRANCO" => 0,
  "NULO" => 0
}

# Candidatos
$candidates = {
  21 => "JOAO",
  23 => "MARIA",
  10 => "PEDRO",
  0 => "BRANCO"
}

# Inicia a urna eletrônica
start_urna

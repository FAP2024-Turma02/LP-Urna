CREATE TABLE Autores (
    AutorID INT PRIMARY KEY,
    Nome VARCHAR(100)
);

CREATE TABLE Livros (
    LivroID INT PRIMARY KEY,
    Título VARCHAR(100),
    AutorID INT,
    Gênero VARCHAR(50),
    Preço DECIMAL(5, 2),
    FOREIGN KEY (AutorID) REFERENCES Autores(AutorID)
);


-- insert
INSERT INTO Autores (AutorID, Nome) VALUES
(1, 'Paulo Coelho'),
(2, 'Machado de Assis'),
(3, 'Albert Einstein'),
(4, 'Sun Tzu');

-- Inserindo dados na tabela Livros
INSERT INTO Livros (LivroID, Título, AutorID, Gênero, Preço) VALUES
(1, 'O Alquimista', 1, 'Ficção', 19.90),
(2, 'Dom Casmurro', 2, 'Ficção', 25.00),
(3, 'Introdução à Física', 3, 'Não Ficção', 45.50),
(4, 'A Arte da Guerra', 4, 'Não Ficção', 29.90);


-- fetch 
SELECT Livros.Título, Autores.Nome
FROM Livros
JOIN Autores ON Livros.AutorID = Autores.AutorID;

SELECT Título
FROM Livros
WHERE Título LIKE '%A%';


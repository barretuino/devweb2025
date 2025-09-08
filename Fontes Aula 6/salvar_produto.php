<?php
// Inclui o arquivo de conexão
require_once 'conexao.php';

// Verifica se a requisição é do tipo POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Pega os dados do formulário e sanitiza (protege contra códigos maliciosos)
    $nome = $conn->real_escape_string($_POST['nome']);
    $descricao = $conn->real_escape_string($_POST['descricao']);
    $preco = filter_var($_POST['preco'], FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION);
    $quantidade = filter_var($_POST['quantidade'], FILTER_SANITIZE_NUMBER_INT);

    // SQL para inserir os dados no banco de dados
    $sql = "INSERT INTO produtos (nome, descricao, preco, quantidade) VALUES (?, ?, ?, ?)";

    // Prepara a declaração para evitar injeção de SQL
    $stmt = $conn->prepare($sql);

    if ($stmt) {
        // Vincula os parâmetros aos valores
        // 's' para string, 'd' para double/decimal, 'i' para integer
        $stmt->bind_param("ssdi", $nome, $descricao, $preco, $quantidade);

        // Executa a declaração
        if ($stmt->execute()) {
            // Redireciona de volta para a página inicial com mensagem de sucesso
            header("Location: index.php?status=sucesso");
        } else {
            // Redireciona com mensagem de erro
            header("Location: index.php?status=erro");
        }
        $stmt->close();
    } else {
        // Erro na preparação do statement
        header("Location: index.php?status=erro");
    }
} else {
    // Se a requisição não for POST, redireciona para a página inicial
    header("Location: index.php");
}

$conn->close();
?>
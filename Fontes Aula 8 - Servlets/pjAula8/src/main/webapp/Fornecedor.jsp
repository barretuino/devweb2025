<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Fornecedor</title>
</head>
<body>
    <h1>
        <% 
            if (request.getAttribute("fornecedor") != null) {
                out.print("Editar");
            } else {
                out.print("Novo");
            }
        %> 
        Fornecedor
    </h1>

    <form action="FornecedorServlet?acao=salvar" method="post">
        <% 
            if (request.getAttribute("fornecedor") != null) { 
        %>
            <input type="hidden" name="id" value="${fornecedor.id}">
        <% 
            } 
        %>

        <label for="nome">Nome:</label><br>
        <input type="text" id="nome" name="nome" value="${fornecedor.nome}" required><br><br>

        <label for="email">E-mail:</label><br>
        <input type="email" id="email" name="email" value="${fornecedor.email}" required><br><br>

        <label for="telefone">Telefone:</label><br>
        <input type="text" id="telefone" name="telefone" value="${fornecedor.telefone}"><br><br>

        <button type="submit">Salvar</button>
    </form>
    <p><a href="FornecedorServlet">Voltar para a lista</a></p>
</body>
</html>
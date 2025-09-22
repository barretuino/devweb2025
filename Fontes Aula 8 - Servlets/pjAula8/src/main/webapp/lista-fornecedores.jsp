<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.com.unisal.model.Fornecedor" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lista de Fornecedores</title>
    <style>
        table, th, td { border: 1px solid black; border-collapse: collapse; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>Lista de Fornecedores</h1>
    <p><a href="FornecedorServlet?acao=novo">Adicionar Novo Fornecedor</a></p>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>E-mail</th>
                <th>Telefone</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Fornecedor> fornecedores = (List<Fornecedor>) request.getAttribute("fornecedores");
                if (fornecedores != null && !fornecedores.isEmpty()) {
                    for (Fornecedor fornecedor : fornecedores) {
            %>
                        <tr>
                            <td><%= fornecedor.getId() %></td>
                            <td><%= fornecedor.getNome() %></td>
                            <td><%= fornecedor.getEmail() %></td>
                            <td><%= fornecedor.getTelefone() %></td>
                            <td>
                                <a href="FornecedorServlet?acao=editar&id=<%= fornecedor.getId() %>">Editar</a> |
                                <a href="FornecedorServlet?acao=deletar&id=<%= fornecedor.getId() %>" onclick="return confirm('Tem certeza que deseja deletar?');">Deletar</a>
                            </td>
                        </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="5">Nenhum fornecedor cadastrado.</td>
                </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
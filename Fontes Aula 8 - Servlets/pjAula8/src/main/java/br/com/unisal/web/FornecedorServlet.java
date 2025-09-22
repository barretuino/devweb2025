package br.com.unisal.web;

import java.io.IOException;
import java.util.List;

import br.com.unisal.jdbc.FornecedorDAO;
import br.com.unisal.model.Fornecedor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class FornecedorServlet
 */
@WebServlet("/FornecedorServlet")
public class FornecedorServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private FornecedorDAO fornecedorDAO;

	@Override
	public void init() {
		fornecedorDAO = new FornecedorDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String acao = request.getParameter("acao");
		if (acao == null) {
			acao = "listar";
		}

		switch (acao) {
		case "novo":
			mostrarFormulario(request, response);
			break;
		case "editar":
			mostrarFormularioEdicao(request, response);
			break;
		case "deletar":
			deletarFornecedor(request, response);
			break;
		case "listar":
		default:
			listarFornecedores(request, response);
			break;
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String acao = request.getParameter("acao");
		if ("salvar".equals(acao)) {
			salvarFornecedor(request, response);
		} else {
			// Outras ações POST podem ser adicionadas aqui
			doGet(request, response);
		}
	}

	private void listarFornecedores(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Fornecedor> lista = fornecedorDAO.listarTodos();
		request.setAttribute("fornecedores", lista);
		request.getRequestDispatcher("lista-fornecedores.jsp").forward(request, response);
	}

	private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("Fornecedor.jsp").forward(request, response);
	}

	private void mostrarFormularioEdicao(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));
		Fornecedor fornecedor = fornecedorDAO.buscarPorId(id);
		request.setAttribute("fornecedor", fornecedor);
		request.getRequestDispatcher("Fornecedor.jsp").forward(request, response);
	}

	private void salvarFornecedor(HttpServletRequest request, HttpServletResponse response) throws IOException {
		// Obter dados do formulário
		String idStr = request.getParameter("id");
		String nome = request.getParameter("nome");
		String email = request.getParameter("email");
		String telefone = request.getParameter("telefone");

		Fornecedor fornecedor = new Fornecedor(nome, email, telefone);

		if (idStr != null && !idStr.isEmpty()) {
			int id = Integer.parseInt(idStr);
			fornecedor.setId(id);
			fornecedorDAO.atualizar(fornecedor);
		} else {
			fornecedorDAO.inserir(fornecedor);
		}

		response.sendRedirect("FornecedorServlet?acao=listar");
	}

	private void deletarFornecedor(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int id = Integer.parseInt(request.getParameter("id"));
		fornecedorDAO.deletar(id);
		response.sendRedirect("fornecedores?acao=listar");
	}
}

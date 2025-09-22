package br.com.unisal.jdbc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import br.com.unisal.model.Fornecedor;

public class FornecedorDAO {

	public void inserir(Fornecedor fornecedor) {
		String sql = "INSERT INTO fornecedores (nome, email, telefone) VALUES (?, ?, ?)";
		try (Connection conn = ConnectionFactory.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, fornecedor.getNome());
			ps.setString(2, fornecedor.getEmail());
			ps.setString(3, fornecedor.getTelefone());
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void atualizar(Fornecedor fornecedor) {
		String sql = "UPDATE fornecedores SET nome = ?, email = ?, telefone = ? WHERE id = ?";
		try (Connection conn = ConnectionFactory.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, fornecedor.getNome());
			ps.setString(2, fornecedor.getEmail());
			ps.setString(3, fornecedor.getTelefone());
			ps.setInt(4, fornecedor.getId());
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void deletar(int id) {
		String sql = "DELETE FROM fornecedores WHERE id = ?";
		try (Connection conn = ConnectionFactory.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public Fornecedor buscarPorId(int id) {
		Fornecedor fornecedor = null;
		String sql = "SELECT * FROM fornecedores WHERE id = ?";
		try (Connection conn = ConnectionFactory.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					fornecedor = new Fornecedor();
					fornecedor.setId(rs.getInt("id"));
					fornecedor.setNome(rs.getString("nome"));
					fornecedor.setEmail(rs.getString("email"));
					fornecedor.setTelefone(rs.getString("telefone"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return fornecedor;
	}

	public List<Fornecedor> listarTodos() {
		List<Fornecedor> lista = new ArrayList<>();
		String sql = "SELECT * FROM fornecedores ORDER BY nome";
		try (Connection conn = ConnectionFactory.getConnection();
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(sql)) {
			while (rs.next()) {
				Fornecedor fornecedor = new Fornecedor();
				fornecedor.setId(rs.getInt("id"));
				fornecedor.setNome(rs.getString("nome"));
				fornecedor.setEmail(rs.getString("email"));
				fornecedor.setTelefone(rs.getString("telefone"));
				lista.add(fornecedor);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return lista;
	}
}
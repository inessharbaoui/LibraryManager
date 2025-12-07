package servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String login = request.getParameter("login");
        String pass = request.getParameter("pass");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/biblio", "root", "")) {

                String sql = "SELECT * FROM personne WHERE LOGIN=? AND PASS=?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, login);
                    ps.setString(2, pass);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (rs.next()) {

                            HttpSession session = request.getSession();

                            // Store username & type
                            session.setAttribute("user", rs.getString("NOM"));
                            session.setAttribute("typeUtilisateur", rs.getString("typeUtilisateur"));

                            // ⭐ IMPORTANT FIX: store the user ID for reservations
                            session.setAttribute("userId", rs.getInt("IDPERS"));

                            String type = rs.getString("typeUtilisateur");

                            // Redirect based on role
                            if ("admin".equals(type)) {
                                response.sendRedirect(request.getContextPath() + "/jsp/dashboardAdmin.jsp");

                            } else if ("bibliothecaire".equals(type)) {
                                response.sendRedirect(request.getContextPath() + "/jsp/home.jsp");

                            } else if ("etudiant".equals(type) || "enseignant".equals(type)) {
                                response.sendRedirect(request.getContextPath() + "/LivreServlet");

                            } else {
                                response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=1");
                            }

                        } else {
                            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=1");
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=1");
        }
    }
}

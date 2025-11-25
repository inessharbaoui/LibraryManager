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
            // Connexion à la base
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/biblio", "root", ""); // user/pass WAMP

            String sql = "SELECT * FROM personne WHERE LOGIN=? AND PASS=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, login);
            ps.setString(2, pass);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                // Utilisateur trouvé
                HttpSession session = request.getSession();
                session.setAttribute("user", rs.getString("NOM"));
                response.sendRedirect(request.getContextPath() + "/jsp/home.jsp"); // page d'accueil après login
            } else {
                // Utilisateur non trouvé
                response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=1");
            }

            rs.close();
            ps.close();
            con.close();

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=1");
        }
    }
}

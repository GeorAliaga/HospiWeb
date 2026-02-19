import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // DEMO: para tu ejemplo
    private static final String DEMO_PASS = "123456";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String p = req.getParameter("password");

        if (DEMO_PASS.equals(p)) {
            HttpSession session = req.getSession(true);
            session.setAttribute("authUser", "GENERAL");
            session.setMaxInactiveInterval(15 * 60); // 15 min

            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
            return;
        }

        req.setAttribute("error", "Clave inválida.");
        try {
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(500, "Error interno");
        }
    }
}

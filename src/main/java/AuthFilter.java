import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/dashboard.jsp", "/api/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Headers básicos anti-cache (confidencial)
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");
        resp.setHeader("X-Frame-Options", "DENY");
        resp.setHeader("X-Content-Type-Options", "nosniff");

        HttpSession session = req.getSession(false);
        boolean logged = (session != null && session.getAttribute("authUser") != null);

        if (!logged) {
            String uri = req.getRequestURI();
            boolean isApi = uri != null && uri.contains("/api/");

            if (isApi) {
                // IMPORTANTE: para que el frontend NO intente parsear HTML
                resp.setStatus(401);
                resp.setContentType("application/json; charset=UTF-8");
                resp.getWriter().write("{\"error\":\"unauthorized\"}");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}
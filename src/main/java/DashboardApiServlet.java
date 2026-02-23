import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/api/dashboard")
public class DashboardApiServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        // Datos MOCK (seguros): estado plataforma / seguridad / integridad
        resp.getWriter().print("""
        {
          "meta": {
            "title": "Consola de Supervisión Operativa",
            "subtitle": "Monitoreo confidencial - entorno interno",
            "securityLevel": "NIVEL IV",
            "dataSource": "Nodo Interno (DEMO)",
            "lastSync": "09:31:28",
            "latencyMs": 14,
            "userLabel": "GENERAL"
          },
          "kpis": [
            {"id":"availability","label":"Disponibilidad","value":"99.2%","note":"+0.2% vs semana"},
            {"id":"backups","label":"Último backup","value":"Hace 3h","note":"Integridad OK"},
            {"id":"failedLogins","label":"Fallos de acceso (24h)","value":"17","note":"Bloqueos: 2"},
            {"id":"alerts","label":"Alertas activas","value":"03","note":"1 alta prioridad"}
          ],
          "modules": [
            {"name":"Citas","status":"OK","score":92},
            {"name":"Emergencia","status":"DEGRADED","score":78},
            {"name":"Laboratorio","status":"OK","score":88},
            {"name":"Imágenes","status":"OK","score":90},
            {"name":"RRHH","status":"OK","score":84},
            {"name":"Auditoría","status":"OK","score":95}
          ],
          "series": {
            "label":"Intentos fallidos (7 días)",
            "points":[
              {"d":"Lun","v":3},
              {"d":"Mar","v":5},
              {"d":"Mié","v":2},
              {"d":"Jue","v":6},
              {"d":"Vie","v":4},
              {"d":"Sáb","v":1},
              {"d":"Dom","v":7}
            ]
          },
          "events": [
            {"level":"HIGH","title":"Pico de intentos fallidos","time":"08:10","detail":"Protección temporal aplicada (rate-limit)."},
            {"level":"MED","title":"Cambio de configuración","time":"07:40","detail":"Ajuste de tiempo de sesión (15 min)."},
            {"level":"LOW","title":"Backup completado","time":"06:20","detail":"Verificación de integridad OK."}
          ]
        }
        """);
    }
}
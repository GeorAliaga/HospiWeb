import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet("/api/dashboard")
public class DashboardApiServlet extends HttpServlet {

    private static final DateTimeFormatter ISO = DateTimeFormatter.ISO_LOCAL_DATE;

    private static LocalDate parseDate(String s, LocalDate fallback){
        try{
            if(s == null || s.isBlank()) return fallback;
            return LocalDate.parse(s, ISO);
        }catch(Exception e){
            return fallback;
        }
    }

    private static int clamp(int v, int a, int b){
        return Math.max(a, Math.min(b, v));
    }

    private static String jsonEscape(String s){
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"");
    }

    private static String arrInts(List<Integer> xs){
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for(int i=0;i<xs.size();i++){
            if(i>0) sb.append(",");
            sb.append(xs.get(i));
        }
        sb.append("]");
        return sb.toString();
    }

    private static String arrStrings(List<String> xs){
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for(int i=0;i<xs.size();i++){
            if(i>0) sb.append(",");
            sb.append("\"").append(jsonEscape(xs.get(i))).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        try{
            LocalDate today = LocalDate.now();
            LocalDate defTo = today;
            LocalDate defFrom = today.minusDays(13);

            LocalDate from = parseDate(req.getParameter("from"), defFrom);
            LocalDate to = parseDate(req.getParameter("to"), defTo);

            if(to.isBefore(from)){
                LocalDate tmp = from; from = to; to = tmp;
            }

            long daysLong = java.time.temporal.ChronoUnit.DAYS.between(from, to) + 1;
            int days = clamp((int)daysLong, 1, 60);

            // recorta si pidieron más de 60 días (para no matar UI)
            if(daysLong > 60){
                to = from.plusDays(59);
                days = 60;
            }

            // random determinístico según rango
            long seed = Objects.hash(from.toString(), to.toString(), days);
            Random r = new Random(seed);

            List<String> labels = new ArrayList<>();
            List<Integer> outpatient = new ArrayList<>();
            List<Integer> emergency = new ArrayList<>();
            List<Integer> admissions = new ArrayList<>();
            List<Integer> discharges = new ArrayList<>();

            int outBase = 320 + r.nextInt(80);
            int emBase = 120 + r.nextInt(50);

            int inBase = 35 + r.nextInt(10);
            int outHospBase = 32 + r.nextInt(10);

            for(int i=0;i<days;i++){
                LocalDate d = from.plusDays(i);
                labels.add(d.getDayOfMonth()+"/"+String.format("%02d", d.getMonthValue()));

                int outV = outBase + (int)(20*Math.sin(i/2.0)) + r.nextInt(35);
                int emV  = emBase  + (int)(10*Math.cos(i/2.4)) + r.nextInt(25);

                outpatient.add(Math.max(0, outV));
                emergency.add(Math.max(0, emV));

                admissions.add(Math.max(0, inBase + r.nextInt(10)));
                discharges.add(Math.max(0, outHospBase + r.nextInt(10)));
            }

            // Beds by service (avg in range)
            List<String> bedServices = Arrays.asList("Medicina", "Cirugía", "Pediatría", "UCI", "Gineco");
            List<Integer> bedOper = new ArrayList<>();
            List<Integer> bedOcc = new ArrayList<>();
            for(String s : bedServices){
                int op = 18 + r.nextInt(18);
                int oc = clamp((int)(op * (0.55 + r.nextDouble()*0.4)), 0, op);
                bedOper.add(op);
                bedOcc.add(oc);
            }

            // Surgeries
            List<Integer> surgDone = new ArrayList<>();
            List<Integer> surgCancel = new ArrayList<>();
            int sBase = 8 + r.nextInt(5);
            for(int i=0;i<days;i++){
                int done = Math.max(0, sBase + r.nextInt(6));
                int can = r.nextInt(3); // 0..2
                surgDone.add(done);
                surgCancel.add(can);
            }

            // Lab & Imaging
            List<Integer> lab = new ArrayList<>();
            List<Integer> img = new ArrayList<>();
            int labBase = 420 + r.nextInt(130);
            int imgBase = 95 + r.nextInt(35);
            for(int i=0;i<days;i++){
                lab.add(Math.max(0, labBase + r.nextInt(90) - 35));
                img.add(Math.max(0, imgBase + r.nextInt(30) - 10));
            }

            // Specialties top
            String[] sp = {"Medicina Interna","Traumatología","Pediatría","Ginecología","Odontología","Cardiología","Dermatología","Oftalmología"};
            List<Map<String,Object>> spList = new ArrayList<>();
            for(String name : sp){
                int total = 120 + r.nextInt(520);
                Map<String,Object> m = new HashMap<>();
                m.put("name", name);
                m.put("total", total);
                spList.add(m);
            }
            spList.sort((a,b)-> Integer.compare((int)b.get("total"), (int)a.get("total")));
            spList = spList.subList(0, 6);

            // Logistics: stockouts daily + top consumption + purchases + list
            List<Integer> stockouts = new ArrayList<>();
            int soBase = 2 + r.nextInt(5);
            for(int i=0;i<days;i++){
                stockouts.add(Math.max(0, soBase + r.nextInt(5) - 2));
            }

            String[] cons = {"Paracetamol","Ceftriaxona","Suero Fisiológico","Guantes Nitrilo","Jeringas 5ml","Gasas","Ketorolaco","Mascarillas"};
            List<String> consLabels = new ArrayList<>();
            List<Integer> consVals = new ArrayList<>();
            for(String c: cons){
                consLabels.add(c);
                consVals.add(50 + r.nextInt(250));
            }

            List<Map<String,Object>> purchases = new ArrayList<>();
            String[] states = {"Pendiente","En aprobación","En proceso","Observado"};
            for(int i=1;i<=6;i++){
                Map<String,Object> m = new HashMap<>();
                m.put("code", "OC-" + (1200 + i));
                m.put("status", states[r.nextInt(states.length)]);
                m.put("amount", 15000 + r.nextInt(85000));
                m.put("date", today.minusDays(r.nextInt(25)).format(ISO));
                purchases.add(m);
            }

            List<Map<String,String>> stockList = new ArrayList<>();
            String[] items = {"Adrenalina ampolla","Cloruro de sodio","Sutura Nylon 3-0","Guantes estériles","Amoxicilina 500mg"};
            String[] levels = {"CRÍTICO","BAJO","CRÍTICO","BAJO","CRÍTICO"};
            for(int i=0;i<items.length;i++){
                Map<String,String> m = new HashMap<>();
                m.put("item", items[i]);
                m.put("level", levels[i]);
                m.put("note", (levels[i].equals("CRÍTICO") ? "Reponer inmediato" : "Revisar mínimo"));
                stockList.add(m);
            }

            // Personal (DEMO)
            List<String> shifts = Arrays.asList("Mañana","Tarde","Noche");
            List<Integer> scheduled = new ArrayList<>();
            List<Integer> effective = new ArrayList<>();
            for(int i=0;i<shifts.size();i++){
                int sch = 40 + r.nextInt(25);
                int eff = clamp(sch - r.nextInt(8), 0, sch);
                scheduled.add(sch);
                effective.add(eff);
            }
            int absenteeismMonthly = 12 + r.nextInt(25);
            int extraGuardsMonthly = 6 + r.nextInt(12);
            int overtimeHoursMonthly = 80 + r.nextInt(160);

            // Finance (DEMO) last 6 months
            List<String> mLabels = new ArrayList<>();
            List<Integer> execPct = new ArrayList<>();
            List<String> spendLabels = Arrays.asList("Personal","Medicamentos","Servicios","Mantenimiento","Otros");
            List<Integer> spendVals = new ArrayList<>();

            LocalDate baseM = today.withDayOfMonth(1).minusMonths(5);
            for(int i=0;i<6;i++){
                LocalDate mm = baseM.plusMonths(i);
                String labM = mm.getMonth().toString().substring(0,3) + " " + mm.getYear();
                mLabels.add(labM.substring(0,1).toUpperCase() + labM.substring(1).toLowerCase());
                execPct.add(45 + r.nextInt(45)); // 45..89
            }

            for(int i=0;i<spendLabels.size();i++){
                spendVals.add(200000 + r.nextInt(650000));
            }

            int PIA = 12_000_000 + r.nextInt(4_000_000);
            int PIM = PIA + r.nextInt(1_800_000);
            int exec = execPct.get(execPct.size()-1);

            List<Map<String,Object>> pendingPayments = new ArrayList<>();
            String[] payStates = {"En trámite","Observado","Pendiente de firma","Pendiente de pago"};
            for(int i=1;i<=6;i++){
                Map<String,Object> m = new HashMap<>();
                m.put("code","EXP-" + (8300 + i));
                m.put("status", payStates[r.nextInt(payStates.length)]);
                m.put("amount", 8000 + r.nextInt(90000));
                m.put("date", today.minusDays(r.nextInt(35)).format(ISO));
                pendingPayments.add(m);
            }

            // Quality (DEMO)
            List<Integer> claims = new ArrayList<>();
            for(int i=0;i<mLabels.size();i++){
                claims.add(8 + r.nextInt(25));
            }
            String[] reasons = {"Demora en atención","Información insuficiente","Trato percibido","Medicamento no disponible","Derivación"};
            List<Map<String,Object>> topReasons = new ArrayList<>();
            for(String rr: reasons){
                Map<String,Object> m = new HashMap<>();
                m.put("reason", rr);
                m.put("total", 5 + r.nextInt(25));
                topReasons.add(m);
            }
            topReasons.sort((a,b)-> Integer.compare((int)b.get("total"), (int)a.get("total")));

            // KPIs (resumen)
            int sumOut = outpatient.stream().mapToInt(Integer::intValue).sum();
            int sumEm = emergency.stream().mapToInt(Integer::intValue).sum();
            int sumAdm = admissions.stream().mapToInt(Integer::intValue).sum();
            int sumDis = discharges.stream().mapToInt(Integer::intValue).sum();
            int sumSurg = surgDone.stream().mapToInt(Integer::intValue).sum();
            int sumLab = lab.stream().mapToInt(Integer::intValue).sum();
            int sumImg = img.stream().mapToInt(Integer::intValue).sum();

            int totalBeds = bedOper.stream().mapToInt(Integer::intValue).sum();
            int occBeds = bedOcc.stream().mapToInt(Integer::intValue).sum();
            int occPct = totalBeds == 0 ? 0 : (int)Math.round(occBeds * 100.0 / totalBeds);

            // JSON build
            StringBuilder sb = new StringBuilder();
            sb.append("{");

            sb.append("\"meta\":{");
            sb.append("\"title\":\"Panel Operativo\",");
            sb.append("\"subtitle\":\"DEMO — reemplazar por consultas autorizadas\",");
            sb.append("\"securityLevel\":\"NIVEL IV\",");
            sb.append("\"dataSource\":\"Nodo Interno (DEMO)\",");
            sb.append("\"lastSync\":\"").append(jsonEscape(java.time.LocalTime.now().withNano(0).toString())).append("\",");
            sb.append("\"latencyMs\":").append(10 + r.nextInt(20)).append(",");
            sb.append("\"userLabel\":\"GENERAL\",");
            sb.append("\"from\":\"").append(from.format(ISO)).append("\",");
            sb.append("\"to\":\"").append(to.format(ISO)).append("\"");
            sb.append("},");

            sb.append("\"kpis\":[");
            sb.append("{\"label\":\"Consulta externa (rango)\",\"value\":\"").append(sumOut).append("\",\"note\":\"Total\"},");
            sb.append("{\"label\":\"Emergencia (rango)\",\"value\":\"").append(sumEm).append("\",\"note\":\"Total\"},");
            sb.append("{\"label\":\"Ocupación de camas\",\"value\":\"").append(occPct).append("%\",\"note\":\"Promedio por servicio\"},");
            sb.append("{\"label\":\"Cirugías (rango)\",\"value\":\"").append(sumSurg).append("\",\"note\":\"Realizadas\"}");
            sb.append("],");

            // Monitoreo
            sb.append("\"monitoreo\":{");

            sb.append("\"outEmergency\":{");
            sb.append("\"labels\":").append(arrStrings(labels)).append(",");
            sb.append("\"outpatient\":").append(arrInts(outpatient)).append(",");
            sb.append("\"emergency\":").append(arrInts(emergency));
            sb.append("},");

            sb.append("\"hosp\":{");
            sb.append("\"labels\":").append(arrStrings(labels)).append(",");
            sb.append("\"admissions\":").append(arrInts(admissions)).append(",");
            sb.append("\"discharges\":").append(arrInts(discharges));
            sb.append("},");

            sb.append("\"beds\":{");
            sb.append("\"labels\":").append(arrStrings(bedServices)).append(",");
            sb.append("\"operational\":").append(arrInts(bedOper)).append(",");
            sb.append("\"occupied\":").append(arrInts(bedOcc));
            sb.append("},");

            sb.append("\"surgeries\":{");
            sb.append("\"labels\":").append(arrStrings(labels)).append(",");
            sb.append("\"done\":").append(arrInts(surgDone)).append(",");
            sb.append("\"canceled\":").append(arrInts(surgCancel));
            sb.append("},");

            sb.append("\"labImg\":{");
            sb.append("\"labels\":").append(arrStrings(labels)).append(",");
            sb.append("\"lab\":").append(arrInts(lab)).append(",");
            sb.append("\"img\":").append(arrInts(img));
            sb.append("},");

            sb.append("\"specialties\":[");
            for(int i=0;i<spList.size();i++){
                Map<String,Object> m = spList.get(i);
                if(i>0) sb.append(",");
                sb.append("{\"name\":\"").append(jsonEscape((String)m.get("name"))).append("\",");
                sb.append("\"total\":").append((int)m.get("total")).append("}");
            }
            sb.append("]");

            sb.append("},");

            // Logística
            sb.append("\"logistica\":{");

            sb.append("\"stockouts\":{");
            sb.append("\"labels\":").append(arrStrings(labels)).append(",");
            sb.append("\"counts\":").append(arrInts(stockouts));
            sb.append("},");

            sb.append("\"consumption\":{");
            sb.append("\"labels\":").append(arrStrings(consLabels)).append(",");
            sb.append("\"values\":").append(arrInts(consVals));
            sb.append("},");

            sb.append("\"purchases\":[");
            for(int i=0;i<purchases.size();i++){
                Map<String,Object> m = purchases.get(i);
                if(i>0) sb.append(",");
                sb.append("{\"code\":\"").append(jsonEscape((String)m.get("code"))).append("\",");
                sb.append("\"status\":\"").append(jsonEscape((String)m.get("status"))).append("\",");
                sb.append("\"amount\":").append((int)m.get("amount")).append(",");
                sb.append("\"date\":\"").append(jsonEscape((String)m.get("date"))).append("\"}");
            }
            sb.append("],");

            sb.append("\"stockList\":[");
            for(int i=0;i<stockList.size();i++){
                Map<String,String> m = stockList.get(i);
                if(i>0) sb.append(",");
                sb.append("{\"item\":\"").append(jsonEscape(m.get("item"))).append("\",");
                sb.append("\"level\":\"").append(jsonEscape(m.get("level"))).append("\",");
                sb.append("\"note\":\"").append(jsonEscape(m.get("note"))).append("\"}");
            }
            sb.append("]");

            sb.append("},");

            // Personal
            sb.append("\"personal\":{");
            sb.append("\"staff\":{");
            sb.append("\"labels\":").append(arrStrings(shifts)).append(",");
            sb.append("\"scheduled\":").append(arrInts(scheduled)).append(",");
            sb.append("\"effective\":").append(arrInts(effective));
            sb.append("},");
            sb.append("\"absenteeismMonthly\":").append(absenteeismMonthly).append(",");
            sb.append("\"extraGuardsMonthly\":").append(extraGuardsMonthly).append(",");
            sb.append("\"overtimeHoursMonthly\":").append(overtimeHoursMonthly);
            sb.append("},");

            // Finanzas
            sb.append("\"finanzas\":{");

            sb.append("\"execution\":{");
            sb.append("\"labels\":").append(arrStrings(mLabels)).append(",");
            sb.append("\"values\":").append(arrInts(execPct));
            sb.append("},");

            sb.append("\"spend\":{");
            sb.append("\"labels\":").append(arrStrings(spendLabels)).append(",");
            sb.append("\"values\":").append(arrInts(spendVals));
            sb.append("},");

            sb.append("\"budget\":{");
            sb.append("\"PIA\":").append(PIA).append(",");
            sb.append("\"PIM\":").append(PIM).append(",");
            sb.append("\"execPct\":").append(exec);
            sb.append("},");

            sb.append("\"pending\":[");
            for(int i=0;i<pendingPayments.size();i++){
                Map<String,Object> m = pendingPayments.get(i);
                if(i>0) sb.append(",");
                sb.append("{\"code\":\"").append(jsonEscape((String)m.get("code"))).append("\",");
                sb.append("\"status\":\"").append(jsonEscape((String)m.get("status"))).append("\",");
                sb.append("\"amount\":").append((int)m.get("amount")).append(",");
                sb.append("\"date\":\"").append(jsonEscape((String)m.get("date"))).append("\"}");
            }
            sb.append("]");

            sb.append("},");

            // Calidad
            sb.append("\"calidad\":{");
            sb.append("\"claims\":{");
            sb.append("\"labels\":").append(arrStrings(mLabels)).append(",");
            sb.append("\"values\":").append(arrInts(claims));
            sb.append("},");
            sb.append("\"reasons\":[");
            int top = Math.min(5, topReasons.size());
            for(int i=0;i<top;i++){
                Map<String,Object> m = topReasons.get(i);
                if(i>0) sb.append(",");
                sb.append("{\"reason\":\"").append(jsonEscape((String)m.get("reason"))).append("\",");
                sb.append("\"total\":").append((int)m.get("total")).append("}");
            }
            sb.append("]");
            sb.append("}");

            sb.append("}");

            resp.getWriter().write(sb.toString());

        }catch(Exception ex){
            resp.setStatus(500);
            resp.setContentType("application/json; charset=UTF-8");
            String msg = ex.getClass().getSimpleName() + ": " + (ex.getMessage() == null ? "error" : ex.getMessage());
            resp.getWriter().write("{\"error\":\"" + jsonEscape(msg) + "\"}");
        }
    }
}
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String user = (String) session.getAttribute("authUser");
%>
<html>
<head><meta charset="UTF-8"><title>Dashboard</title></head>
<body style="font-family:Arial; margin:24px;">
<h2>Dashboard Confidencial</h2>
<div>Bienvenido: <b><%= user %></b> | <a href="logout">Cerrar sesión</a></div>
<hr/>
<p>Aquí irán tus KPIs mock (seguridad / integridad / estado de sistemas).</p>
</body>
</html>

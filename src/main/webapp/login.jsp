<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if (session != null && session.getAttribute("authUser") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }
    String err = (String) request.getAttribute("error");
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Workload Analyzer - Login</title>
    <style>
        * { box-sizing: border-box; }

        body{
            margin:0;
            font-family: Arial, sans-serif;
            background:#f3f6fb;
            min-height:100vh;
            display:flex;
            align-items:center;
            justify-content:center;
            padding: 24px;
        }

        .card{
            width: 460px;
            background:#fff;
            border-radius:16px;
            box-shadow:0 18px 50px rgba(0,0,0,.12);
            padding: 28px 28px 22px;
            border:1px solid #e7eef9;
        }

        .inner{
            max-width: 360px;       /* <- esto centra y evita que “se vaya” */
            margin: 0 auto;
        }

        .logoWrap{
            width:92px; height:92px; border-radius:50%;
            margin:0 auto 12px auto;
            border:4px solid #eef3fb;
            display:flex; align-items:center; justify-content:center;
            overflow:hidden;
            background:#fff;
        }
        .logoWrap img{ width:76px; height:76px; object-fit:contain; }

        h1{
            margin:10px 0 6px;
            text-align:center;
            font-size:26px;
            color:#0d2a57;
        }
        .sub{
            text-align:center;
            color:#6b7a90;
            font-size:13px;
            margin-bottom:20px;
            line-height: 1.35;
        }

        .err{
            margin: 0 auto 12px;
            background:#ffecec;
            border:1px solid #ffb9b9;
            color:#7a1010;
            padding:10px;
            border-radius:10px;
            font-size:13px;
        }

        label{
            font-size:13px;
            color:#0d2a57;
            font-weight:bold;
            display:block;
            margin:12px 0 6px;
        }

        /* “Usuario” como bloque NO editable */
        .roleBox{
            width:100%;
            padding: 12px 12px;
            border-radius:10px;
            border:1px solid #dbe6f7;
            background:#f3f7ff;
            color:#2a3a55;
            font-size:14px;
            display:flex;
            align-items:center;
            gap:10px;
            user-select: none;
            cursor: default; /* <- no parece editable */
        }
        .roleBadge{
            font-size:12px;
            font-weight:bold;
            color:#0d2a57;
            background:#e7f0ff;
            border:1px solid #cfe0ff;
            padding:4px 8px;
            border-radius:999px;
        }
        .roleText{
            font-weight:bold;
            letter-spacing:.04em;
        }

        input[type="password"]{
            width:100%;
            padding:12px 12px;
            border-radius:10px;
            border:1px solid #dbe6f7;
            outline:none;
            font-size:14px;
            background:#f9fbff;
        }
        input[type="password"]:focus{
            border-color:#2c66c3;
            background:#fff;
        }

        .btn{
            margin-top:16px;
            width:100%;
            background:#123a74;
            color:#fff;
            border:0;
            padding:12px;
            border-radius:10px;
            font-weight:bold;
            cursor:pointer;
            font-size:14px;
        }
        .btn:hover{ filter:brightness(1.05); }

        .foot{
            text-align:center;
            margin-top:14px;
            font-size:12px;
            color:#93a3bd;
            letter-spacing:.12em;
        }
    </style>
</head>
<body>
<div class="card">
    <div class="logoWrap">
        <img src="https://scontent.flim38-1.fna.fbcdn.net/v/t1.6435-9/90062941_104134844562973_2202055627017027584_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=53a332&_nc_eui2=AeH1PtGppX5h1FWMIXeuMZ4aqT5aa-G5x8-pPlpr4bnHz66r2Rlst4mJ70V00YreS_gC520EJ6IH1JDqNmSX_Pk3&_nc_ohc=KxEuJTASVKQQ7kNvwHjRfd1&_nc_oc=AdnhlYqK1rk1a_WLR76tYAAT3wcqF5dkiGU_XZjdXeBv0SgkmfA3NjCDgh4Bor09c60&_nc_zt=23&_nc_ht=scontent.flim38-1.fna&_nc_gid=b5n1_pue_Pp7pytyvagXJQ&oh=00_AfvtjNhSIprlyk6ZLk9aeUcdl5qykQtR6HlNKnmksTVzgQ&oe=69BF0509"
             alt="Hospital Logo"/>
    </div>

    <h1>Workload Analyzer</h1>
    <div class="sub">Dashboard Confidencial de Monitoreo - Hospital Militar</div>

    <div class="inner">
        <% if (err != null) { %>
        <div class="err"><%= err %></div>
        <% } %>

        <form method="post" action="login">
            <label>Usuario Autorizado</label>
            <div class="roleBox" aria-label="Usuario Autorizado">
                <span class="roleBadge">ROL</span>
                <span class="roleText">GENERAL</span>
            </div>

            <label>Contraseña</label>
            <input name="password" type="password" placeholder="Ingrese clave de acceso"
                   autocomplete="current-password" required />

            <button class="btn" type="submit">Ingresar al Dashboard</button>
        </form>

        <div class="foot">ACCESO RESTRINGIDO — USO EXCLUSIVO DE LA AUTORIDAD COMPETENTE</div>
    </div>
</div>
</body>
</html>

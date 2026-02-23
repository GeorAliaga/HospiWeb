<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String user = (String) session.getAttribute("authUser");
%>
<!doctype html>
<html>
<head>
  <meta charset="UTF-8"/>
  <title>Dashboard</title>
  <style>
    * { box-sizing: border-box; }
    body { margin:0; font-family: Arial, sans-serif; background:#f3f6fb; color:#0d2a57; }

    .topbar{
      background:#fff; border-bottom:1px solid #e8eef8;
      padding:14px 22px; display:flex; align-items:center; gap:16px;
    }
    .brand{ display:flex; align-items:center; gap:12px; min-width: 340px; }
    .brand img{ width:34px; height:34px; object-fit:contain; }
    .brandTitle{ font-size:22px; font-weight:800; }
    .brandSub{ font-size:12px; color:#6b7a90; margin-top:2px; letter-spacing:.14em; }

    .pill{
      font-size:12px; font-weight:700; color:#123a74;
      border:1px solid #cfe0ff; background:#eaf2ff;
      padding:6px 10px; border-radius:999px; white-space:nowrap;
    }

    .metaRow{ display:flex; gap:12px; flex:1; justify-content:center; }
    .metaBox{
      background:#f8fbff; border:1px solid #e7eef9;
      border-radius:12px; padding:10px 12px; min-width: 220px;
    }
    .metaLabel{ font-size:11px; color:#6b7a90; letter-spacing:.14em; }
    .metaValue{ font-weight:800; margin-top:4px; }

    .userBox{ margin-left:auto; display:flex; align-items:center; gap:12px; }
    .userName{ font-weight:800; }
    .userRole{ font-size:12px; color:#6b7a90; }
    .logoutBtn{
      width:36px; height:36px; border-radius:50%;
      border:1px solid #dbe6f7; background:#fff; cursor:pointer;
      display:flex; align-items:center; justify-content:center;
    }
    .logoutBtn:hover{ background:#f3f7ff; }

    .wrap{ padding:20px; max-width: 1200px; margin: 0 auto; }

    .grid{
      display:grid;
      grid-template-columns: 2fr 1fr;
      gap:18px;
      align-items:start;
    }

    .card{
      background:#fff;
      border:1px solid #e7eef9;
      border-radius:18px;
      box-shadow:0 14px 40px rgba(0,0,0,.08);
      padding:18px;
    }
    .hero{
      padding:22px;
      display:flex;
      justify-content:space-between;
      align-items:center;
      min-height: 190px;
    }
    .hero h2{ margin: 8px 0; font-size:38px; line-height:1.05; }
    .hero p{ margin:0; color:#6b7a90; font-size:14px; max-width: 520px; line-height:1.5; }
    .heroIcon{
      width:120px; height:120px; border-radius:24px;
      background:linear-gradient(180deg,#f4f7ff,#fff);
      border:1px solid #e7eef9;
      display:flex; align-items:center; justify-content:center;
      color:#c8d3ea; font-weight:900; font-size:42px;
    }

    .kpiCol{ display:flex; flex-direction:column; gap:14px; }
    .kpi{
      padding:18px;
      position:relative;
      overflow:hidden;
      min-height: 110px;
    }
    .kpi .kLabel{ font-size:12px; color:#d9e6ff; letter-spacing:.14em; }
    .kpi .kValue{ font-size:34px; font-weight:900; margin-top:6px; color:#fff; }
    .kpi .kNote{ margin-top:6px; font-size:12px; color:#d9e6ff; }
    .kpi.blue{ background:#123a74; }
    .kpi.green{ background:#3b8d5f; }
    .kpi.red{ background:#b54a4a; }
    .kpi.gray{ background:#3c4b66; }

    .tabs{
      margin-top:18px;
      background:#fff;
      border:1px solid #e7eef9;
      border-radius:999px;
      padding:8px;
      display:flex;
      gap:8px;
      overflow:auto;
    }
    .tab{
      padding:10px 14px;
      border-radius:999px;
      border:1px solid transparent;
      background:transparent;
      cursor:pointer;
      font-weight:800;
      color:#6b7a90;
      white-space:nowrap;
    }
    .tab.active{
      background:#123a74;
      color:#fff;
    }

    .twoCards{
      margin-top:18px;
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap:18px;
    }
    .cardTitle{ font-weight:900; font-size:18px; margin-bottom:6px; }
    .cardSub{ color:#6b7a90; font-size:13px; margin-bottom:14px; }

    /* Bars (módulos) */
    .row{ display:flex; align-items:center; gap:12px; margin:10px 0; }
    .row label{ width:110px; font-size:13px; color:#2a3a55; }
    .barWrap{ flex:1; background:#eef3fb; border-radius:999px; height:14px; overflow:hidden; }
    .bar{ height:100%; border-radius:999px; }
    .score{ width:40px; text-align:right; font-weight:800; color:#2a3a55; font-size:13px; }

    .bar.ok{ background:#3b8d5f; }
    .bar.deg{ background:#d0a22f; }
    .bar.down{ background:#b54a4a; }

    /* Mini line chart via SVG */
    .chartBox{ background:#f8fbff; border:1px solid #e7eef9; border-radius:14px; padding:12px; }
    .legend{ display:flex; justify-content:space-between; font-size:12px; color:#6b7a90; margin-top:8px; }

    /* Events */
    .event{ border:1px solid #e7eef9; border-radius:14px; padding:12px; margin-top:10px; background:#fff; }
    .badge{ font-size:11px; font-weight:900; padding:4px 8px; border-radius:999px; display:inline-block; }
    .bHigh{ background:#ffecec; color:#7a1010; border:1px solid #ffb9b9; }
    .bMed{ background:#fff7e6; color:#7a5a10; border:1px solid #ffe1a6; }
    .bLow{ background:#eaf7ff; color:#104b7a; border:1px solid #b7dcff; }
    .eventTitle{ font-weight:900; margin:8px 0 4px; }
    .eventMeta{ font-size:12px; color:#6b7a90; }
  </style>
</head>

<body>
<div class="topbar">
  <div class="brand">
    <img src="https://scontent.flim38-1.fna.fbcdn.net/v/t1.6435-9/90062941_104134844562973_2202055627017027584_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=53a332&_nc_eui2=AeH1PtGppX5h1FWMIXeuMZ4aqT5aa-G5x8-pPlpr4bnHz66r2Rlst4mJ70V00YreS_gC520EJ6IH1JDqNmSX_Pk3&_nc_ohc=KxEuJTASVKQQ7kNvwHjRfd1&_nc_oc=AdnhlYqK1rk1a_WLR76tYAAT3wcqF5dkiGU_XZjdXeBv0SgkmfA3NjCDgh4Bor09c60&_nc_zt=23&_nc_ht=scontent.flim38-1.fna&_nc_gid=b5n1_pue_Pp7pytyvagXJQ&oh=00_AfvtjNhSIprlyk6ZLk9aeUcdl5qykQtR6HlNKnmksTVzgQ&oe=69BF0509" />
    <div>
      <div class="brandTitle" id="appName">Consola</div>
      <div class="brandSub">CENTRO DE MONITOREO OPERATIVO</div>
    </div>
  </div>

  <div class="pill" id="secLevel">NIVEL IV</div>

  <div class="metaRow">
    <div class="metaBox">
      <div class="metaLabel">FUENTE DE DATOS</div>
      <div class="metaValue" id="dataSource">-</div>
    </div>
    <div class="metaBox">
      <div class="metaLabel">SINCRONIZACIÓN</div>
      <div class="metaValue" id="lastSync">-</div>
    </div>
    <div class="metaBox">
      <div class="metaLabel">LATENCIA</div>
      <div class="metaValue" id="latency">-</div>
    </div>
  </div>

  <div class="userBox">
    <div>
      <div class="userName" id="userLabel"><%= (user != null ? user : "GENERAL") %></div>
      <div class="userRole">ACCESO AUTORIZADO</div>
    </div>
    <button class="logoutBtn" title="Salir" onclick="location.href='logout'">⎋</button>
  </div>
</div>

<div class="wrap">
  <div class="grid">
    <!-- Left main -->
    <div>
      <div class="card hero">
        <div>
          <div style="font-weight:900; color:#6b7a90; letter-spacing:.14em; font-size:12px;">
            MÓDULO DE SUPERVISIÓN
          </div>
          <h2 id="heroTitle">Panel de Supervisión</h2>
          <p id="heroSub">Capa de presentación con datos simulados (seguros). Se reemplaza luego por métricas permitidas.</p>
        </div>
        <div class="heroIcon">!</div>
      </div>

      <div class="tabs">
        <button class="tab active">MONITOREO</button>
        <button class="tab">SEGURIDAD</button>
        <button class="tab">INTEGRIDAD</button>
        <button class="tab">AUDITORÍA</button>
      </div>

      <div class="twoCards">
        <div class="card">
          <div class="cardTitle">Estado por Módulos</div>
          <div class="cardSub">Indicadores simulados (OK / Degradado / Caído).</div>
          <div id="modules"></div>
        </div>

        <div class="card">
          <div class="cardTitle" id="seriesTitle">Serie</div>
          <div class="cardSub">Tendencia simulada para pruebas de UI.</div>
          <div class="chartBox">
            <svg id="lineSvg" viewBox="0 0 300 120" width="100%" height="120" aria-label="chart">
              <polyline id="linePoly" fill="none" stroke="#123a74" stroke-width="3" points=""></polyline>
              <circle id="dot0" r="4" fill="#123a74"></circle>
            </svg>
            <div class="legend" id="seriesLegend"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Right KPI column -->
    <div class="kpiCol" id="kpiCol"></div>
  </div>

  <div class="card" style="margin-top:18px;">
    <div class="cardTitle">Eventos Recientes</div>
    <div class="cardSub">Auditoría operativa simulada (sin datos clínicos).</div>
    <div id="events"></div>
  </div>
</div>

<script>
  function statusClass(s){
    if(s === "OK") return "ok";
    if(s === "DEGRADED") return "deg";
    return "down";
  }
  function badgeClass(level){
    if(level === "HIGH") return "bHigh";
    if(level === "MED") return "bMed";
    return "bLow";
  }

  function buildLine(points){
    // points: [{d, v}]
    const W = 300, H = 120, pad = 12;
    const vals = points.map(p => p.v);
    const min = Math.min(...vals), max = Math.max(...vals);
    const dx = (W - pad*2) / (points.length - 1 || 1);

    const norm = v => {
      if(max === min) return H/2;
      return (H - pad) - ((v - min) / (max - min)) * (H - pad*2);
    };

    const pts = points.map((p,i) => {
      const x = pad + i*dx;
      const y = norm(p.v);
      return `${x.toFixed(1)},${y.toFixed(1)}`;
    }).join(" ");

    document.getElementById("linePoly").setAttribute("points", pts);

    // legend
    const legend = points.map(p => `${p.d}:${p.v}`).join("  •  ");
    document.getElementById("seriesLegend").textContent = legend;
  }

  async function load(){
    const data = await (await fetch("api/dashboard")).json();

    document.getElementById("appName").textContent = "Workload Analyzer"; // cámbialo si decides renombrar
    document.getElementById("secLevel").textContent = data.meta.securityLevel;
    document.getElementById("dataSource").textContent = data.meta.dataSource;
    document.getElementById("lastSync").textContent = "Última: " + data.meta.lastSync;
    document.getElementById("latency").textContent = data.meta.latencyMs + "ms (Óptimo)";
    document.getElementById("userLabel").textContent = data.meta.userLabel;

    document.getElementById("heroTitle").textContent = data.meta.title;
    document.getElementById("heroSub").textContent = data.meta.subtitle;

    // KPIs (columna derecha)
    const kpiCol = document.getElementById("kpiCol");
    const colors = ["blue","green","gray","red"];
    kpiCol.innerHTML = data.kpis.map((k,i)=>`
    <div class="card kpi ${colors[i % colors.length]}">
      <div class="kLabel">${k.label.toUpperCase()}</div>
      <div class="kValue">${k.value}</div>
      <div class="kNote">${k.note || ""}</div>
    </div>
  `).join("");

    // Módulos (barras)
    const modules = document.getElementById("modules");
    modules.innerHTML = data.modules.map(m=>`
    <div class="row">
      <label>${m.name}</label>
      <div class="barWrap">
        <div class="bar ${statusClass(m.status)}" style="width:${m.score}%;"></div>
      </div>
      <div class="score">${m.score}</div>
    </div>
  `).join("");

    // Serie (línea simple)
    document.getElementById("seriesTitle").textContent = data.series.label;
    buildLine(data.series.points);

    // Eventos
    const events = document.getElementById("events");
    events.innerHTML = data.events.map(e=>`
    <div class="event">
      <span class="badge ${badgeClass(e.level)}">${e.level}</span>
      <div class="eventTitle">${e.title}</div>
      <div class="eventMeta">${e.time} — ${e.detail}</div>
    </div>
  `).join("");
  }
  load();
</script>

</body>
</html>
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
      position: sticky; top: 0; z-index: 30;
    }
    .brand{ display:flex; align-items:center; gap:12px; min-width: 320px; }
    .brand img{ width:34px; height:34px; object-fit:contain; }
    .brandTitle{ font-size:22px; font-weight:800; line-height:1.1; }
    .brandSub{ font-size:12px; color:#6b7a90; margin-top:2px; letter-spacing:.14em; }

    .pill{
      font-size:12px; font-weight:700; color:#123a74;
      border:1px solid #cfe0ff; background:#eaf2ff;
      padding:6px 10px; border-radius:999px; white-space:nowrap;
    }

    .metaRow{ display:flex; gap:12px; flex:1; justify-content:center; }
    .metaBox{
      background:#f8fbff; border:1px solid #e7eef9;
      border-radius:12px; padding:10px 12px; min-width: 230px;
    }
    .metaLabel{ font-size:11px; color:#6b7a90; letter-spacing:.14em; }
    .metaValue{ font-weight:800; margin-top:4px; }

    .userBox{ margin-left:auto; display:flex; align-items:center; gap:12px; }
    .userName{ font-weight:900; }
    .userRole{ font-size:12px; color:#6b7a90; }
    .logoutBtn{
      width:36px; height:36px; border-radius:50%;
      border:1px solid #dbe6f7; background:#fff; cursor:pointer;
      display:flex; align-items:center; justify-content:center;
    }
    .logoutBtn:hover{ background:#f3f7ff; }

    .wrap{ padding:20px; max-width: 1280px; margin: 0 auto; }

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
      min-height: 160px;
      gap: 18px;
    }
    .hero h2{ margin: 8px 0; font-size:38px; line-height:1.05; }
    .hero p{ margin:0; color:#6b7a90; font-size:14px; max-width: 650px; line-height:1.5; }
    .heroIcon{
      width:96px; height:96px; border-radius:22px;
      background:linear-gradient(180deg,#f4f7ff,#fff);
      border:1px solid #e7eef9;
      display:flex; align-items:center; justify-content:center;
      font-size:44px;
    }

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
      font-weight:900;
      color:#6b7a90;
      white-space:nowrap;
    }
    .tab.active{
      background:#123a74;
      color:#fff;
    }

    .filters{
      margin-top:14px;
      display:flex;
      gap:12px;
      align-items:end;
      flex-wrap: wrap;
    }
    .fGroup label{ display:block; font-size:11px; color:#6b7a90; letter-spacing:.14em; margin-bottom:6px; }
    .fGroup input{
      height: 42px;
      border:1px solid #dbe6f7;
      border-radius:12px;
      padding: 0 12px;
      font-weight:800;
      background:#fff;
      color:#0d2a57;
    }
    .btn{
      height:42px;
      border-radius:12px;
      border:1px solid #dbe6f7;
      background:#fff;
      font-weight:900;
      padding:0 14px;
      cursor:pointer;
    }
    .btn.primary{
      background:#123a74;
      border-color:#123a74;
      color:#fff;
    }
    .btn:hover{ filter:brightness(1.03); }

    .grid2{
      margin-top:18px;
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap: 18px;
      align-items:start;
    }
    .grid3{
      margin-top:18px;
      display:grid;
      grid-template-columns: 1fr 1fr 1fr;
      gap: 18px;
      align-items:start;
    }

    .kpiRow{
      margin-top:18px;
      display:grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 14px;
    }
    .kpi{
      padding:16px;
      border-radius:16px;
      border:1px solid #e7eef9;
      background:#fff;
      box-shadow:0 10px 26px rgba(0,0,0,.06);
    }
    .kLabel{ font-size:11px; color:#6b7a90; letter-spacing:.14em; font-weight:900; }
    .kValue{ margin-top:6px; font-size:28px; font-weight:900; }
    .kNote{ margin-top:6px; font-size:12px; color:#6b7a90; }

    .cardTitle{ font-weight:900; font-size:18px; margin-bottom:6px; }
    .cardSub{ color:#6b7a90; font-size:13px; margin-bottom:14px; line-height:1.4; }
    canvas{ width:100%; height: 220px; display:block; background:#f8fbff; border:1px solid #e7eef9; border-radius:14px; }

    table{ width:100%; border-collapse:collapse; overflow:hidden; border-radius:14px; border:1px solid #e7eef9; }
    th, td{ padding:10px 10px; font-size:13px; border-bottom:1px solid #eef3fb; text-align:left; }
    th{ background:#f8fbff; font-size:11px; color:#6b7a90; letter-spacing:.12em; }
    tr:last-child td{ border-bottom:none; }

    .pane{ display:none; }
    .pane.active{ display:block; }

    .alert{
      margin-top: 14px;
      background:#ffecec;
      border:1px solid #ffb9b9;
      color:#7a1010;
      padding:10px 12px;
      border-radius:12px;
      display:none;
      font-size:13px;
      font-weight:700;
    }

    @media (max-width: 1100px){
      .metaRow{ display:none; }
      .kpiRow{ grid-template-columns: repeat(2, 1fr); }
      .grid3{ grid-template-columns: 1fr; }
      .grid2{ grid-template-columns: 1fr; }
      .brand{ min-width:auto; }
    }
  </style>
</head>

<body>
<div class="topbar">
  <div class="brand">
    <img src="https://scontent.flim38-1.fna.fbcdn.net/v/t1.6435-9/90062941_104134844562973_2202055627017027584_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=53a332&_nc_eui2=AeH1PtGppX5h1FWMIXeuMZ4aqT5aa-G5x8-pPlpr4bnHz66r2Rlst4mJ70V00YreS_gC520EJ6IH1JDqNmSX_Pk3&_nc_ohc=KxEuJTASVKQQ7kNvwHjRfd1&_nc_oc=AdnhlYqK1rk1a_WLR76tYAAT3wcqF5dkiGU_XZjdXeBv0SgkmfA3NjCDgh4Bor09c60&_nc_zt=23&_nc_ht=scontent.flim38-1.fna&_nc_gid=b5n1_pue_Pp7pytyvagXJQ&oh=00_AfvtjNhSIprlyk6ZLk9aeUcdl5qykQtR6HlNKnmksTVzgQ&oe=69BF0509" />
    <div>
      <div class="brandTitle" id="appName">Consola de Supervisión</div>
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
      <div class="metaLabel">RANGO</div>
      <div class="metaValue" id="rangeLabel">-</div>
    </div>
  </div>

  <div class="userBox">
    <div>
      <div class="userName" id="userLabel"><%= (user != null ? user : "GENERAL") %></div>
      <div class="userRole">ACCESO AUTORIZADO</div>
    </div>
    <button class="logoutBtn" title="Salir" onclick="location.href='<%=request.getContextPath()%>/logout'">⎋</button>
  </div>
</div>

<div class="wrap">

  <div class="card hero">
    <div>
      <div style="font-weight:900; color:#6b7a90; letter-spacing:.14em; font-size:12px;">
        INDICADORES AGREGADOS
      </div>
      <h2 id="heroTitle">Panel Operativo</h2>
      <p id="heroSub">Estadísticas DEMO por día/mes. Luego reemplazables por vistas/consultas autorizadas de BD.</p>
    </div>
    <div class="heroIcon">📊</div>
  </div>

  <div class="tabs" id="tabs">
    <button class="tab active" data-tab="monitoreo">MONITOREO</button>
    <button class="tab" data-tab="logistica">LOGÍSTICA</button>
    <button class="tab" data-tab="personal">PERSONAL</button>
    <button class="tab" data-tab="finanzas">FINANZAS</button>
    <button class="tab" data-tab="calidad">CALIDAD</button>
  </div>

  <div class="filters">
    <div class="fGroup">
      <label>DESDE</label>
      <input id="from" type="date"/>
    </div>
    <div class="fGroup">
      <label>HASTA</label>
      <input id="to" type="date"/>
    </div>
    <button class="btn" id="b7">Últimos 7</button>
    <button class="btn" id="b14">Últimos 14</button>
    <button class="btn" id="b30">Últimos 30</button>
    <button class="btn primary" id="apply">Aplicar</button>
  </div>

  <div class="alert" id="errBox"></div>

  <div class="kpiRow" id="kpiRow"></div>

  <!-- PANES -->
  <div class="pane active" id="pane-monitoreo">
    <div class="grid2">
      <div class="card">
        <div class="cardTitle">Atenciones (Consulta Externa vs Emergencia)</div>
        <div class="cardSub">Serie diaria según el rango seleccionado.</div>
        <canvas id="c_out_em"></canvas>
      </div>
      <div class="card">
        <div class="cardTitle">Hospitalización (Ingresos vs Egresos)</div>
        <div class="cardSub">Serie diaria según el rango seleccionado.</div>
        <canvas id="c_in_out"></canvas>
      </div>
    </div>

    <div class="grid2">
      <div class="card">
        <div class="cardTitle">Camas (Operativas vs Ocupadas)</div>
        <div class="cardSub">Comparativo por servicio/sala (promedio del rango).</div>
        <canvas id="c_beds"></canvas>
      </div>
      <div class="card">
        <div class="cardTitle">Cirugías (Realizadas vs Canceladas)</div>
        <div class="cardSub">Conteo diario; canceladas con motivo DEMO.</div>
        <canvas id="c_surg"></canvas>
      </div>
    </div>

    <div class="grid2">
      <div class="card">
        <div class="cardTitle">Consulta externa por especialidad (Top)</div>
        <div class="cardSub">Totales del rango (DEMO).</div>
        <table>
          <thead><tr><th>ESPECIALIDAD</th><th>TOTAL</th></tr></thead>
          <tbody id="t_specialties"></tbody>
        </table>
      </div>

      <div class="card">
        <div class="cardTitle">Laboratorio e Imágenes</div>
        <div class="cardSub">Procesados por día (DEMO).</div>
        <canvas id="c_lab_img"></canvas>
      </div>
    </div>
  </div>

  <div class="pane" id="pane-logistica">
    <div class="grid2">
      <div class="card">
        <div class="cardTitle">Quiebre de stock (ítems críticos)</div>
        <div class="cardSub">Conteo diario de ítems en cero/bajo mínimo (DEMO).</div>
        <canvas id="c_stockouts"></canvas>
      </div>
      <div class="card">
        <div class="cardTitle">Top consumo (medicamentos/insumos)</div>
        <div class="cardSub">Top ítems del rango (DEMO).</div>
        <canvas id="c_consumption"></canvas>
      </div>
    </div>

    <div class="grid2">
      <div class="card">
        <div class="cardTitle">Órdenes/Compras pendientes</div>
        <div class="cardSub">Cantidad / monto / estado (DEMO).</div>
        <table>
          <thead><tr><th>OC</th><th>ESTADO</th><th>MONTO</th><th>FECHA</th></tr></thead>
          <tbody id="t_purchases"></tbody>
        </table>
      </div>
      <div class="card">
        <div class="cardTitle">Ítems en quiebre (lista)</div>
        <div class="cardSub">Listado crítico DEMO.</div>
        <table>
          <thead><tr><th>ÍTEM</th><th>NIVEL</th><th>OBS</th></tr></thead>
          <tbody id="t_stock_list"></tbody>
        </table>
      </div>
    </div>
  </div>

  <div class="pane" id="pane-personal">
    <div class="grid2">
      <div class="card">
        <div class="cardTitle">Personal (Programado vs Efectivo)</div>
        <div class="cardSub">Por turno (DEMO; si no se registra, se elimina).</div>
        <canvas id="c_staff"></canvas>
      </div>
      <div class="card">
        <div class="cardTitle">Ausentismo y guardias adicionales</div>
        <div class="cardSub">Resumen mensual DEMO.</div>
        <table>
          <thead><tr><th>MÉTRICA</th><th>VALOR</th></tr></thead>
          <tbody id="t_staff_summary"></tbody>
        </table>
      </div>
    </div>
  </div>

  <div class="pane" id="pane-finanzas">
    <div class="grid2">
      <div class="card">
        <div class="cardTitle">Ejecución presupuestal (mensual)</div>
        <div class="cardSub">% ejecución por mes (DEMO).</div>
        <canvas id="c_exec"></canvas>
      </div>
      <div class="card">
        <div class="cardTitle">Gasto por rubro</div>
        <div class="cardSub">Distribución mensual (DEMO).</div>
        <canvas id="c_spend"></canvas>
      </div>
    </div>

    <div class="grid2">
      <div class="card">
        <div class="cardTitle">Pagos pendientes / expedientes</div>
        <div class="cardSub">Conteo y monto (DEMO).</div>
        <table>
          <thead><tr><th>EXP</th><th>ESTADO</th><th>MONTO</th><th>FECHA</th></tr></thead>
          <tbody id="t_payments"></tbody>
        </table>
      </div>
      <div class="card">
        <div class="cardTitle">Resumen presupuestal</div>
        <div class="cardSub">PIA/PIM y ejecución (DEMO).</div>
        <table>
          <thead><tr><th>CONCEPTO</th><th>VALOR</th></tr></thead>
          <tbody id="t_budget"></tbody>
        </table>
      </div>
    </div>
  </div>

  <div class="pane" id="pane-calidad">
    <div class="grid2">
      <div class="card">
        <div class="cardTitle">Reclamos/quejas</div>
        <div class="cardSub">Total por mes (DEMO).</div>
        <canvas id="c_claims"></canvas>
      </div>
      <div class="card">
        <div class="cardTitle">Motivos principales (Top 5)</div>
        <div class="cardSub">Ranking mensual (DEMO).</div>
        <table>
          <thead><tr><th>MOTIVO</th><th>TOTAL</th></tr></thead>
          <tbody id="t_claim_reasons"></tbody>
        </table>
      </div>
    </div>
  </div>

</div>

<script>
  const CTX = "<%=request.getContextPath()%>";

  // ---------- Utils ----------
  function pad2(n){ return String(n).padStart(2,'0'); }
  function fmtISO(d){ return d.getFullYear()+"-"+pad2(d.getMonth()+1)+"-"+pad2(d.getDate()); }
  function parseISO(s){
    const [y,m,d] = (s||"").split("-").map(Number);
    if(!y||!m||!d) return null;
    const dt = new Date(y, m-1, d);
    if(isNaN(dt.getTime())) return null;
    return dt;
  }
  function addDays(dt, days){
    const c = new Date(dt.getTime());
    c.setDate(c.getDate() + days);
    return c;
  }
  function qs(){
    return new URLSearchParams(location.search);
  }
  function setParam(k,v){
    const p = qs();
    p.set(k,v);
    const url = location.pathname + "?" + p.toString();
    history.replaceState(null,"",url);
  }
  function showErr(msg){
    const box = document.getElementById("errBox");
    box.style.display = "block";
    box.textContent = msg;
  }
  function hideErr(){
    const box = document.getElementById("errBox");
    box.style.display = "none";
    box.textContent = "";
  }

  // ---------- Simple charts (Canvas) ----------
  function clearCanvas(c){
    const ctx = c.getContext("2d");
    const dpr = window.devicePixelRatio || 1;
    const rect = c.getBoundingClientRect();
    c.width = Math.round(rect.width * dpr);
    c.height = Math.round(rect.height * dpr);
    ctx.setTransform(dpr,0,0,dpr,0,0);
    ctx.clearRect(0,0,rect.width,rect.height);
    return {ctx, w: rect.width, h: rect.height};
  }

  function drawAxes(ctx, w, h, pad){
    ctx.strokeStyle = "#dbe6f7";
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(pad, pad);
    ctx.lineTo(pad, h-pad);
    ctx.lineTo(w-pad, h-pad);
    ctx.stroke();
  }

  function drawLineChart(canvas, labels, series){
    const {ctx,w,h} = clearCanvas(canvas);
    const pad = 14;
    drawAxes(ctx,w,h,pad);

    const all = series.flatMap(s => s.values);
    const min = Math.min(...all);
    const max = Math.max(...all);
    const span = (max - min) || 1;

    const x0 = pad, y0 = h - pad;
    const x1 = w - pad, y1 = pad;

    const dx = (x1 - x0) / Math.max(1, labels.length - 1);

    function y(v){
      return y0 - ((v - min)/span) * (y0 - y1);
    }

    // grid
    ctx.strokeStyle = "#eef3fb";
    ctx.lineWidth = 1;
    for(let i=1;i<=3;i++){
      const yy = y0 - i*(y0-y1)/4;
      ctx.beginPath();
      ctx.moveTo(x0, yy);
      ctx.lineTo(x1, yy);
      ctx.stroke();
    }

    // lines
    series.forEach(s=>{
      ctx.strokeStyle = s.color;
      ctx.lineWidth = 2.5;
      ctx.beginPath();
      s.values.forEach((v,i)=>{
        const xx = x0 + i*dx;
        const yy = y(v);
        if(i===0) ctx.moveTo(xx,yy);
        else ctx.lineTo(xx,yy);
      });
      ctx.stroke();
    });

    // legend
    let lx = pad, ly = pad + 2;
    series.forEach(s=>{
      ctx.fillStyle = s.color;
      ctx.fillRect(lx, ly, 10, 10);
      ctx.fillStyle = "#2a3a55";
      ctx.font = "12px Arial";
      ctx.fillText(" " + s.name, lx + 12, ly + 10);
      lx += 120;
    });
  }

  function drawBarChart(canvas, labels, values, color){
    const {ctx,w,h} = clearCanvas(canvas);
    const pad = 14;
    drawAxes(ctx,w,h,pad);

    const max = Math.max(...values, 1);
    const x0 = pad, y0 = h - pad;
    const x1 = w - pad, y1 = pad;

    const bw = (x1-x0) / Math.max(1, labels.length);
    values.forEach((v,i)=>{
      const bh = ((v/max) * (y0-y1));
      const x = x0 + i*bw + bw*0.18;
      const y = y0 - bh;
      const ww = bw*0.64;

      ctx.fillStyle = color;
      ctx.fillRect(x, y, ww, bh);
    });

    // small labels (not all)
    ctx.fillStyle = "#6b7a90";
    ctx.font = "11px Arial";
    const step = Math.max(1, Math.floor(labels.length/6));
    for(let i=0;i<labels.length;i+=step){
      const x = x0 + i*bw + bw*0.18;
      ctx.fillText(labels[i], x, h-2);
    }
  }

  function drawGroupedBars(canvas, labels, aName, aVals, bName, bVals, aColor, bColor){
    const {ctx,w,h} = clearCanvas(canvas);
    const pad = 14;
    drawAxes(ctx,w,h,pad);

    const max = Math.max(...aVals, ...bVals, 1);
    const x0 = pad, y0 = h - pad;
    const x1 = w - pad, y1 = pad;

    const bw = (x1-x0) / Math.max(1, labels.length);
    labels.forEach((_,i)=>{
      const groupX = x0 + i*bw + bw*0.18;
      const ww = bw*0.64;
      const half = ww/2;

      const bhA = (aVals[i]/max) * (y0-y1);
      const bhB = (bVals[i]/max) * (y0-y1);

      ctx.fillStyle = aColor;
      ctx.fillRect(groupX, y0 - bhA, half-2, bhA);

      ctx.fillStyle = bColor;
      ctx.fillRect(groupX + half+2, y0 - bhB, half-2, bhB);
    });

    // legend
    ctx.fillStyle = aColor; ctx.fillRect(pad, pad+2, 10,10);
    ctx.fillStyle = "#2a3a55"; ctx.font="12px Arial"; ctx.fillText(" "+aName, pad+12, pad+12);
    ctx.fillStyle = bColor; ctx.fillRect(pad+140, pad+2, 10,10);
    ctx.fillStyle = "#2a3a55"; ctx.fillText(" "+bName, pad+152, pad+12);
  }

  // ---------- UI ----------
  function setActiveTab(tab){
    document.querySelectorAll(".tab").forEach(b=>{
      b.classList.toggle("active", b.dataset.tab === tab);
    });
    document.querySelectorAll(".pane").forEach(p=>{
      p.classList.toggle("active", p.id === "pane-"+tab);
    });
    setParam("tab", tab);
  }

  function fillTable(tbodyId, rowsHtml){
    document.getElementById(tbodyId).innerHTML = rowsHtml;
  }

  function money(n){
    return "S/ " + n.toLocaleString("es-PE", {maximumFractionDigits:0});
  }

  async function load(){
    hideErr();

    const p = qs();
    const tab = p.get("tab") || "monitoreo";
    setActiveTab(tab);

    // default range: last 14 days
    const today = new Date();
    const defTo = fmtISO(today);
    const defFrom = fmtISO(addDays(today, -13));

    const from = p.get("from") || defFrom;
    const to = p.get("to") || defTo;

    document.getElementById("from").value = from;
    document.getElementById("to").value = to;

    try{
      const url = CTX + "/api/dashboard?from=" + encodeURIComponent(from) + "&to=" + encodeURIComponent(to);
      const r = await fetch(url, {headers: {"Accept":"application/json"}});
      const ct = (r.headers.get("content-type") || "");

      if(!r.ok){
        const txt = await r.text();
        showErr("API error ("+r.status+"). Revisa Tomcat log. Respuesta: " + txt.slice(0,140));
        return;
      }
      if(!ct.includes("application/json")){
        const txt = await r.text();
        showErr("La API no devolvió JSON. Primeros caracteres: " + txt.slice(0,80));
        return;
      }

      const data = await r.json();

      // top meta
      document.getElementById("secLevel").textContent = data.meta.securityLevel;
      document.getElementById("dataSource").textContent = data.meta.dataSource;
      document.getElementById("lastSync").textContent = "Última: " + data.meta.lastSync + " • " + data.meta.latencyMs + "ms";
      document.getElementById("rangeLabel").textContent = data.meta.from + " → " + data.meta.to;
      document.getElementById("userLabel").textContent = data.meta.userLabel;
      document.getElementById("heroTitle").textContent = data.meta.title;
      document.getElementById("heroSub").textContent = data.meta.subtitle;

      // KPIs
      const kpiRow = document.getElementById("kpiRow");
      kpiRow.innerHTML = data.kpis.map(k=>`
        <div class="kpi">
          <div class="kLabel">${k.label.toUpperCase()}</div>
          <div class="kValue">${k.value}</div>
          <div class="kNote">${k.note || ""}</div>
        </div>
      `).join("");

      // Charts (monitoreo)
      drawLineChart(document.getElementById("c_out_em"),
              data.monitoreo.outEmergency.labels,
              [
                {name:"Consulta externa", values:data.monitoreo.outEmergency.outpatient, color:"#123a74"},
                {name:"Emergencia", values:data.monitoreo.outEmergency.emergency, color:"#3b8d5f"}
              ]
      );

      drawLineChart(document.getElementById("c_in_out"),
              data.monitoreo.hosp.labels,
              [
                {name:"Ingresos", values:data.monitoreo.hosp.admissions, color:"#123a74"},
                {name:"Egresos", values:data.monitoreo.hosp.discharges, color:"#b54a4a"}
              ]
      );

      drawGroupedBars(document.getElementById("c_beds"),
              data.monitoreo.beds.labels,
              "Operativas", data.monitoreo.beds.operational,
              "Ocupadas", data.monitoreo.beds.occupied,
              "#123a74", "#3b8d5f"
      );

      drawGroupedBars(document.getElementById("c_surg"),
              data.monitoreo.surgeries.labels,
              "Realizadas", data.monitoreo.surgeries.done,
              "Canceladas", data.monitoreo.surgeries.canceled,
              "#123a74", "#b54a4a"
      );

      drawGroupedBars(document.getElementById("c_lab_img"),
              data.monitoreo.labImg.labels,
              "Laboratorio", data.monitoreo.labImg.lab,
              "Imágenes", data.monitoreo.labImg.img,
              "#123a74", "#3b8d5f"
      );

      fillTable("t_specialties",
              data.monitoreo.specialties.map(s=>`<tr><td>${s.name}</td><td><b>${s.total}</b></td></tr>`).join("")
      );

      // Logística
      drawLineChart(document.getElementById("c_stockouts"),
              data.logistica.stockouts.labels,
              [{name:"Ítems críticos", values:data.logistica.stockouts.counts, color:"#b54a4a"}]
      );

      drawBarChart(document.getElementById("c_consumption"),
              data.logistica.consumption.labels,
              data.logistica.consumption.values,
              "#123a74"
      );

      fillTable("t_purchases",
              data.logistica.purchases.map(p=>`
          <tr><td>${p.code}</td><td>${p.status}</td><td><b>${money(p.amount)}</b></td><td>${p.date}</td></tr>
        `).join("")
      );

      fillTable("t_stock_list",
              data.logistica.stockList.map(it=>`
          <tr><td>${it.item}</td><td><b>${it.level}</b></td><td>${it.note}</td></tr>
        `).join("")
      );

      // Personal
      drawGroupedBars(document.getElementById("c_staff"),
              data.personal.staff.labels,
              "Programado", data.personal.staff.scheduled,
              "Efectivo", data.personal.staff.effective,
              "#123a74", "#3b8d5f"
      );

      fillTable("t_staff_summary",
              `
          <tr><td>Ausentismo mensual (DEMO)</td><td><b>${data.personal.absenteeismMonthly}</b></td></tr>
          <tr><td>Guardias adicionales (DEMO)</td><td><b>${data.personal.extraGuardsMonthly}</b></td></tr>
          <tr><td>Horas extra mensuales (DEMO)</td><td><b>${data.personal.overtimeHoursMonthly}</b></td></tr>
        `
      );

      // Finanzas
      drawLineChart(document.getElementById("c_exec"),
              data.finanzas.execution.labels,
              [{name:"Ejecución %", values:data.finanzas.execution.values, color:"#123a74"}]
      );

      drawBarChart(document.getElementById("c_spend"),
              data.finanzas.spend.labels,
              data.finanzas.spend.values,
              "#3b8d5f"
      );

      fillTable("t_payments",
              data.finanzas.pending.map(p=>`
          <tr><td>${p.code}</td><td>${p.status}</td><td><b>${money(p.amount)}</b></td><td>${p.date}</td></tr>
        `).join("")
      );

      fillTable("t_budget",
              `
          <tr><td>PIA</td><td><b>${money(data.finanzas.budget.PIA)}</b></td></tr>
          <tr><td>PIM</td><td><b>${money(data.finanzas.budget.PIM)}</b></td></tr>
          <tr><td>Ejecución acumulada</td><td><b>${data.finanzas.budget.execPct}%</b></td></tr>
        `
      );

      // Calidad
      drawLineChart(document.getElementById("c_claims"),
              data.calidad.claims.labels,
              [{name:"Reclamos", values:data.calidad.claims.values, color:"#b54a4a"}]
      );

      fillTable("t_claim_reasons",
              data.calidad.reasons.map(r=>`<tr><td>${r.reason}</td><td><b>${r.total}</b></td></tr>`).join("")
      );

    }catch(e){
      showErr("Error en frontend: " + (e && e.message ? e.message : e));
    }
  }

  // events
  document.getElementById("tabs").addEventListener("click",(ev)=>{
    const b = ev.target.closest(".tab");
    if(!b) return;
    setActiveTab(b.dataset.tab);
  });

  function setRange(days){
    const to = new Date();
    const from = addDays(to, -(days-1));
    document.getElementById("from").value = fmtISO(from);
    document.getElementById("to").value = fmtISO(to);
  }

  document.getElementById("b7").onclick = ()=> setRange(7);
  document.getElementById("b14").onclick = ()=> setRange(14);
  document.getElementById("b30").onclick = ()=> setRange(30);

  document.getElementById("apply").onclick = ()=>{
    const f = document.getElementById("from").value;
    const t = document.getElementById("to").value;
    setParam("from", f);
    setParam("to", t);
    // recargar para mantener URL "limpia" y que se pueda compartir el rango
    location.reload();
  };

  // init
  window.addEventListener("resize", ()=>load());
  load();
</script>

</body>
</html>
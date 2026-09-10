/* ---------- floating particles background ---------- */

const canvas = document.getElementById("particles");

if (canvas) {
  const ctx = canvas.getContext("2d");

  let w, h;
  const particles = [];
  const COUNT = 40;

  // resize canvas to fill the window
  function resize() {
    w = canvas.width = window.innerWidth;
    h = canvas.height = window.innerHeight;
  }
  resize();
  window.addEventListener("resize", resize);

  // create particles with random position, size, speed, and opacity
  for (let i = 0; i < COUNT; i++) {
    particles.push({
      x: Math.random() * w,
      y: Math.random() * h,
      r: Math.random() * 2 + 1.5, // radius: 1.5–3.5px
      dx: (Math.random() - 0.5) * 0.3, // horizontal drift
      dy: (Math.random() - 0.5) * 0.3, // vertical drift
      o: Math.random() * 0.15 + 0.1, // opacity: 0.1–0.25
    });
  }

  // animation loop clear, move, draw each particle
  function draw() {
    ctx.clearRect(0, 0, w, h);
    for (const p of particles) {
      // drift
      p.x += p.dx;
      p.y += p.dy;

      // wrap around edges
      if (p.x < 0) p.x = w;
      if (p.x > w) p.x = 0;
      if (p.y < 0) p.y = h;
      if (p.y > h) p.y = 0;

      // draw dot
      ctx.beginPath();
      ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(215,153,33,${p.o})`;
      ctx.fill();
    }
    requestAnimationFrame(draw);
  }
  draw();
}

/* ---------- screenshots ---------- */

// add new shots here
const SHOT_DIR = "resjar/shotbin";
const SHOTS = [
  { file: "basic screen with jn script.png" },
  { file: "basicTile.png" },
  { file: "wallpapercarosel.png" },
];

// strip the final extension for display names
function displayName(filename) {
  return filename.replace(/\.[^.]+$/, "");
}

function srcOf(shot) {
  return `${SHOT_DIR}/${encodeURIComponent(shot.file)}`;
}

const gridEl = document.getElementById("grid-shots");
const countEl = document.getElementById("count-shots");

// mini thumb, click pops open the lightbox
function buildGrid(shot) {
  const card = document.createElement("figure");
  card.className = "card";

  const img = document.createElement("img");
  img.src = srcOf(shot);
  img.alt = displayName(shot.file);
  img.loading = "lazy";

  const cap = document.createElement("figcaption");
  cap.className = "card-cap";
  cap.textContent = displayName(shot.file);

  card.appendChild(img);
  card.appendChild(cap);
  card.addEventListener("click", () => openLightbox(shot));
  return card;
}

if (gridEl) {
  for (const shot of SHOTS) gridEl.appendChild(buildGrid(shot));
  if (countEl) countEl.textContent = `· ${SHOTS.length}`;
}

/* ---------- lightbox ---------- */

const lightbox = document.getElementById("lightbox");
const lightboxImg = document.getElementById("lightbox-img");
const lightboxName = document.getElementById("lightbox-name");
const lightboxDl = document.getElementById("lightbox-dl");

function openLightbox(shot) {
  if (!lightbox) return;
  lightboxName.textContent = displayName(shot.file);
  lightboxImg.src = srcOf(shot);
  lightboxDl.href = srcOf(shot);
  lightboxDl.download = shot.file;
  lightbox.classList.add("open");
  document.body.style.overflow = "hidden";
}

function closeLightbox() {
  if (!lightbox) return;
  lightbox.classList.remove("open");
  document.body.style.overflow = "";
}

if (lightbox) {
  document
    .getElementById("lightbox-close")
    .addEventListener("click", closeLightbox);
  lightbox.addEventListener("click", (ev) => {
    if (ev.target === lightbox) closeLightbox();
  });
  window.addEventListener("keydown", (ev) => {
    if (ev.key === "Escape" && lightbox.classList.contains("open"))
      closeLightbox();
  });
}

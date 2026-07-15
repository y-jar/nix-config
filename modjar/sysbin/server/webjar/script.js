// floating particles background
// draws small amber dots that drift slowly across the viewport

const canvas = document.getElementById("particles");
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
        r: Math.random() * 2 + 1.5,       // radius: 1.5–3.5px
        dx: (Math.random() - 0.5) * 0.3,   // horizontal drift
        dy: (Math.random() - 0.5) * 0.3,   // vertical drift
        o: Math.random() * 0.15 + 0.1,     // opacity: 0.1–0.25
    });
}

// animation loop — clear, move, draw each particle
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

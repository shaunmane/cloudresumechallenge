/*
TemplateMo 621 Luminary
https://templatemo.com/tm-621-luminary
*/

// ── Smooth Scroll (JS-driven, overrides CSS) ──
document.querySelectorAll('a[href^="#"]').forEach(link => {
  link.addEventListener('click', e => {
    const href = link.getAttribute('href');
    if (href === '#') {
      e.preventDefault();
      window.scrollTo({ top: 0, behavior: 'smooth' });
    } else {
      const target = document.querySelector(href);
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth' });
      }
    }
  });
});

// ── Reveal ──
const reveals = document.querySelectorAll('.reveal');
const io = new IntersectionObserver(entries => {
  entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('visible'); io.unobserve(e.target); } });
}, { threshold: 0.12, rootMargin: '0px 0px -30px 0px' });
reveals.forEach(el => io.observe(el));

// ── Counters ──

document.querySelectorAll('.counter:not(#visitorCount)').forEach(el => {
  new IntersectionObserver(([e]) => {
    if (!e.isIntersecting) return;

    const t = parseFloat(el.dataset.target);
    const d = parseInt(el.dataset.decimals) || 0;
    const dur = 1800;
    const s = performance.now();

    const ease = x =>
      x < 0.5
        ? 4 * x * x * x
        : 1 - Math.pow(-2 * x + 2, 3) / 2;

    (function u(n) {
      const p = Math.min((n - s) / dur, 1);
      el.textContent = (t * ease(p)).toFixed(d);

      if (p < 1) requestAnimationFrame(u);
    })(s);

    e.target._counted = true;
  }, { threshold: 0.5 }).observe(el);
});

// ── Nav scroll ──
const topNav = document.getElementById('topNav');
window.addEventListener('scroll', () => topNav.classList.toggle('scrolled', scrollY > 60), { passive: true });

// ── Hero grid spotlight ──
const heroGrid = document.querySelector('.hero-grid');
const heroEl = document.getElementById('hero');
let gx = 0, gy = 0, tx = 0, ty = 0;
let mouseInHero = false;

document.addEventListener('mousemove', e => {
  const heroRect = heroEl.getBoundingClientRect();
  const gridRect = heroGrid.getBoundingClientRect();
  const activeTop = heroRect.top + heroRect.height * 0.3;
  // Only track in the bottom 70% of hero
  if (e.clientY >= activeTop && e.clientY <= heroRect.bottom) {
    mouseInHero = true;
    tx = e.clientX - gridRect.left;
    ty = e.clientY - gridRect.top;
  } else {
    mouseInHero = false;
    tx = gridRect.width / 2;
    ty = gridRect.height * 0.3;
  }
});

(function lerpGrid() {
  gx += (tx - gx) * 0.08;
  gy += (ty - gy) * 0.08;
  heroGrid.style.setProperty('--mx', gx + 'px');
  heroGrid.style.setProperty('--my', gy + 'px');
  requestAnimationFrame(lerpGrid);
})();

// ── Active nav + Side panels ──
const navAnchors = document.querySelectorAll('.nav-links a');
const sectionEls = document.querySelectorAll('section[id]');
const leftDots = document.querySelectorAll('.side-panel.left .side-dot');
const rightDots = document.querySelectorAll('.side-panel.right .side-dot');
const leftTrack = document.getElementById('leftTrack');
const rightTrack = document.getElementById('rightTrack');
const scrollPctEl = document.getElementById('scrollPct');

function updateNavAndPanels() {
  const y = scrollY + innerHeight * 0.4;
  const maxScroll = document.documentElement.scrollHeight - innerHeight;
  const pct = Math.min(scrollY / maxScroll, 1);

  // Active nav link
  let id = '', activeIndex = 0;
  sectionEls.forEach((s, i) => { if (y >= s.offsetTop) { id = s.id; activeIndex = i; } });
  navAnchors.forEach(a => a.classList.toggle('active', a.getAttribute('href') === '#' + id));

  // Side panel tracks
  const trackPct = (pct * 100).toFixed(0);
  if (leftTrack) leftTrack.style.height = trackPct + '%';
  if (rightTrack) rightTrack.style.height = trackPct + '%';
  if (scrollPctEl) scrollPctEl.textContent = String(trackPct).padStart(2, '0');

  // Side panel dots
  const leftIdx = Math.min(activeIndex, leftDots.length - 1);
  const rightIdx = Math.min(activeIndex, rightDots.length - 1);
  leftDots.forEach((d, i) => d.classList.toggle('active', i === leftIdx));
  rightDots.forEach((d, i) => d.classList.toggle('active', i === rightIdx));
}

window.addEventListener('scroll', updateNavAndPanels, { passive: true });
updateNavAndPanels();

// -- Time ---
function updateDateTime() {
    const now = new Date();

    // Get the user's timezone (e.g. Africa/Johannesburg)
    const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const formatter = new Intl.DateTimeFormat(undefined, {
    weekday: 'short',
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    timeZoneName: 'short'
    });

    document.getElementById("navDateTimeDesktop").textContent =
        formatter.format(now);
}

updateDateTime();
setInterval(updateDateTime, 1000);

// ── Mobile menu ──
const toggle = document.getElementById('navToggle'), menu = document.getElementById('mobileMenu');
const menuLinks = menu.querySelectorAll('.mobile-menu-link');
let menuOpen = false;
function openMenu() { menuOpen=true; toggle.classList.add('active'); toggle.setAttribute('aria-expanded','true'); menu.classList.add('open'); document.body.classList.add('menu-open'); }
function closeMenu() { if(!menuOpen) return; menuOpen=false; toggle.classList.remove('active'); toggle.setAttribute('aria-expanded','false'); menu.classList.remove('open'); document.body.classList.remove('menu-open'); }
toggle.addEventListener('click', () => menuOpen ? closeMenu() : openMenu());
menuLinks.forEach(l => l.addEventListener('click', closeMenu));
document.addEventListener('keydown', e => { if (e.key === 'Escape') closeMenu(); });
window.addEventListener('resize', () => { if (innerWidth > 1024) closeMenu(); });

// Visitor Counter
async function updateVisitorCount() {
    const visitorCount = document.getElementById("visitorCount");

    if (!visitorCount) return;

    try {
        const response = await fetch(
            "https://0uxn3h1vej.execute-api.us-east-1.amazonaws.com/visitors"
        );
        const data = await response.json();
        visitorCount.textContent = Number(data.views).toLocaleString();
    } catch (error) {
        console.error("Visitor count error:", error);
        visitorCount.textContent = "—";
    }
}

updateVisitorCount();

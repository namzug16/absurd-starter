function initBasecoat() {
  if (window.basecoat) window.basecoat.initAll()
}

document.addEventListener("DOMContentLoaded", initBasecoat)
document.addEventListener("htmx:load", initBasecoat)
document.addEventListener("htmx:historyRestore", initBasecoat)

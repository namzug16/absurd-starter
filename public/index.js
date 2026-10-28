function initUi() {
  if (window.lucide) window.lucide.createIcons()
  if (window.basecoat) window.basecoat.initAll()
  document.querySelectorAll('dialog[data-temporary-dialog]:not([open])').forEach((dialog) => {
    dialog.addEventListener('close', () => dialog.remove(), { once: true })
    dialog.showModal()
  })
}

document.addEventListener("DOMContentLoaded", initUi)
document.addEventListener("htmx:after:swap", initUi)

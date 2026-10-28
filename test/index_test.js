const assert = require('node:assert/strict')
const { readFileSync } = require('node:fs')
const { test } = require('node:test')
const { runInNewContext } = require('node:vm')

test('initializes local icons and Basecoat on load and HTMX 4 swaps', () => {
  const listeners = {}
  let icons = 0
  let basecoat = 0
  runInNewContext(readFileSync('public/index.js', 'utf8'), {
    window: {
      lucide: { createIcons() { icons++ } },
      basecoat: { initAll() { basecoat++ } },
    },
    document: {
      addEventListener(event, listener) { listeners[event] = listener },
      querySelectorAll() { return [] },
    },
  })
  listeners.DOMContentLoaded()
  listeners['htmx:after:swap']()
  assert.equal(icons, 2)
  assert.equal(basecoat, 2)
  assert.equal(listeners['htmx:afterSwap'], undefined)
})

test('opens a temporary dialog once and removes it after closing', () => {
  const listeners = {}
  let close
  let opened = 0
  let removed = false
  const dialog = {
    open: false,
    addEventListener(event, listener, options) {
      assert.equal(event, 'close')
      assert.equal(options.once, true)
      close = listener
    },
    showModal() { this.open = true; opened++ },
    remove() { removed = true },
  }
  runInNewContext(readFileSync('public/index.js', 'utf8'), {
    window: {},
    document: {
      addEventListener(event, listener) { listeners[event] = listener },
      querySelectorAll(selector) {
        assert.equal(selector, 'dialog[data-temporary-dialog]:not([open])')
        return dialog.open ? [] : [dialog]
      },
    },
  })
  listeners['htmx:after:swap']()
  listeners['htmx:after:swap']()
  assert.equal(opened, 1)
  close()
  assert.equal(removed, true)
})

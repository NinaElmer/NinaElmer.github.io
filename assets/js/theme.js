(function () {
  'use strict';

  var root = document.documentElement;
  var control = document.querySelector('.theme-control');
  if (!control) return;
  var buttons = control.querySelectorAll('.theme-option');

  var systemTheme = window.matchMedia('(prefers-color-scheme: dark)');

  function applyPreference(preference) {
    root.dataset.themePreference = preference;
    root.dataset.theme = preference === 'system'
      ? (systemTheme.matches ? 'dark' : 'light')
      : preference;
    buttons.forEach(function (button) {
      button.setAttribute('aria-pressed', String(button.dataset.preference === preference));
    });
  }

  buttons.forEach(function (button) {
    button.addEventListener('click', function () {
      var preference = button.dataset.preference;
      applyPreference(preference);
      try {
        if (preference === 'system') localStorage.removeItem('color-theme');
        else localStorage.setItem('color-theme', preference);
      } catch (error) {}
    });
  });

  systemTheme.addEventListener('change', function () {
    if (root.dataset.themePreference === 'system') applyPreference('system');
  });

  window.addEventListener('storage', function (event) {
    if (event.key !== 'color-theme' && event.key !== null) return;
    var next = event.newValue;
    applyPreference(next === 'light' || next === 'dark' ? next : 'system');
  });

  applyPreference(root.dataset.themePreference || 'system');
  control.hidden = false;
})();

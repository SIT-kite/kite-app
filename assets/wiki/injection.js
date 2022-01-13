if (typeof(runFlag) === 'undefined') {
  runFlag = true;

  document.addEventListener("DOMContentLoaded", (function () {
    let index = 'https://kite.sunnysab.cn/wiki/';

    console.info('Initializing injection.js');
    if (window.location.toString().startsWith(index)) {
      // Hide navigation bar.
      document.head.appendChild(document.createElement("style")).textContent = ".md-header { display: none; }";
      // Set theme color.
      var attr = 'blue';
      document.body.setAttribute("data-md-color-primary", attr);
    }
  }));
}

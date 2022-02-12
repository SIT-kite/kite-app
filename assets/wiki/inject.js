if (typeof runFlag === 'undefined') {

  runFlag = true;
  console.info('Initializing wiki/inject.js');

  const index = 'https://cdn.kite.sunnysab.cn/wiki/';
  const primaryColor = 'blue';

  if (window.location.href.startsWith(index)) {

    const onDOM = () => {

      const style = document.head.appendChild(document.createElement("style"));

      // Hide navigation bar.
      style.textContent = ".md-header { display: none; }";

      // Set theme color.
      document.body.setAttribute("data-md-color-primary", primaryColor);

    }

    document.addEventListener("DOMContentLoaded", onDOM);

  };

}

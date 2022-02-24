if (typeof runFlag === "undefined") {

var runFlag = true;
console.info('Initializing report/inject.js on:', location.href);

// templates
const userName = '{{username}}'.trim();
const css = `{{injectCSS}}`.trim();

// const prefix = 'http://xgfy.sit.edu.cn/h5/';
// const routes = [ 'guide', 'news', 'index', 'studentReport', 'jksb', 'yimiaon', 'view' ];

const getRoute = name => name === 'guide' ? '#/' : `#/pages/index/${name}`;

const route = {
  is: name => location.hash === getRoute(name),
  go: name => location.assign(getRoute(name))
};

// visibilitychange
Document.prototype.addEventListener = new Proxy(
  Document.prototype.addEventListener, {
    apply: (target, _this, args) => (
      args[0] === 'visibilitychange'
      ? undefined
      : Reflect.apply(target, _this, args)
    )
  }
);

// load
window.addEventListener('load', () => {

// login
if (route.is('guide') && userName !== '') {
  localStorage.setItem('userInfo', JSON.stringify({ code: userName }));
  route.go('index');
}

// allowReport
const userInfo = JSON.parse(localStorage.getItem('userInfo'));
if ( // if userInfo matches { allowReport: 0 }
  typeof userInfo === 'object' &&
  userInfo !== null &&
  userInfo.allowReport === 0
) {
  userInfo.allowReport = 1;
  localStorage.setItem('userInfo', JSON.stringify(userInfo));
}

// checklist
const intervalId = setInterval(() => {
  if (route.is('jksb')) {
    const checklist = document.querySelector('.checklist-box');
    if (
      checklist !== null &&
      checklist.textContent.trim() === '本人承诺:上述填写内容真实、准确、无误！'
    ) {
      checklist.click();
      clearInterval(intervalId);
    }
  }
}, 500);

// css
const style = document.head.appendChild(document.createElement('style'));
style.textContent = css;

});


}

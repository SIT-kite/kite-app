if (typeof runFlag === 'undefined') {

runFlag = true;
console.info('Initializing inject.js');

const userName = '{username}';

// const prefix = 'http://xgfy.sit.edu.cn/h5/';
const routes = {
  login:  '#/',
  home:   '#/pages/index/index',
  report: '#/pages/index/jksb',
  studentReport: '#/pages/index/studentReport',
  yimiaon:       '#/pages/index/yimiaon'
};

const route = {
  is: route => location.hash === route,
  go: route => location.reload(route)
};

// login
if (
  route.is(routes.login) &&
  localStorage.getItem('loginIn') === '1'
) {
  const userInfo = JSON.stringify({ code: userName });
  localStorage.setItem('userInfo', userInfo);
  localStorage.setItem('loginIn', '1');
  console.info('LocalStorage login set');
  route.go(routes.home);
}

// visibilitychange
Document.prototype.addEventListener = new Proxy(
  Document.prototype.addEventListener, {
    apply: (target, _this, args) => (
      args[0] === "visibilitychange"
      ? undefined
      : Reflect.apply(target, _this, args)
    )
  }
);

// allowReport
const userInfo = JSON.parse(localStorage.getItem("userInfo"));
if ( // if userInfo matches { allowReport: 0 }
  typeof userInfo === "object" &&
  userInfo !== null &&
  userInfo.allowReport === 0
) {
  userInfo.allowReport = 1;
  localStorage.setItem("userInfo", JSON.stringify(userInfo));
}

// checklist
route.is(routes.report) &&
window.addEventListener("load", () => {
  const checklist = document.querySelector('.checklist-box');
  checklist !== null &&
  checklist.textContent === "本人承诺:上述填写内容真实、准确、无误！" &&
  checklist.click();
});

// css
const style = document.head.appendChild(document.createElement("style"));
style.textContent =
`/* Global */


/* font */
uni-input, uni-textarea { font-size: inherit; }

/* user-select */
html, body { -webkit-user-select: initial; user-select: initial; }

/* uni-image */
uni-image > div { background-size: contain !important; background-position: center !important; }
uni-image > img { object-fit: contain; }

/* .uni-textarea-textarea */
.uni-textarea-textarea, .uni-textarea-placeholder { box-sizing: border-box; padding: .5em; }
/* shadow */
.shadow, .shadow-blur {
	box-shadow:
		0 3px 1px -2px rgba(0, 0, 0, 0.2),
		0 2px 2px  0   rgba(0, 0, 0, 0.14),
		0 1px 5px  0   rgba(0, 0, 0, 0.12) !important;
}

.shadow-blur::before { content: unset; display: none; }

/* solid */
.solid::after, .solid-top::after, .solid-right::after, .solid-bottom::after, .solid-left::after,
.solids::after, .solids-top::after, .solids-right::after, .solids-bottom::after, .solids-left::after,
.dashed::after, .dashed-top::after, .dashed-right::after, .dashed-bottom::after, .dashed-left::after {
	z-index: 1;
}


/* layout */


uni-page-body,
uni-page-body > uni-view:only-child,
.nav + uni-scroll-view {
	height: 100%;
}
.nav + uni-scroll-view,
.nav + uni-scroll-view .uni-scroll-view-content > uni-view,
.cu-bar ~ .cu-list.menu-avatar,
.cu-list:only-child {
	overflow-y: auto;
}
uni-page-body > uni-view:only-child,
.nav + uni-scroll-view .uni-scroll-view-content,
.nav + uni-scroll-view .uni-scroll-view-content > uni-view {
	display: flex;
	flex-direction: column;
}


/* sticky report button */


.nav + uni-scroll-view .uni-scroll-view-content > uni-view:first-child {
	position: relative;
}
.nav + uni-scroll-view .uni-scroll-view-content > uni-view:first-child > .cu-list.menu:only-child {
	height: 100%;
}
.nav + uni-scroll-view .uni-scroll-view-content > uni-view:first-child > .cu-list.menu:only-child > uni-view[style="margin-left: 5%;"],
.nav + uni-scroll-view .uni-scroll-view-content > uni-view:first-child > .cu-list.menu:only-child > .foot,
.nav + uni-scroll-view .uni-scroll-view-content > uni-view:first-child > .foot {
	position: sticky;
	z-index: 1000;
	box-sizing: border-box;
	width: 100%;
	background-color: white;
}
.nav + uni-scroll-view .uni-scroll-view-content > uni-view:first-child > .cu-list.menu:only-child > .foot,
.nav + uni-scroll-view .uni-scroll-view-content > uni-view:first-child > .foot {
	bottom: 0;
	height: 4em;
}
.nav + uni-scroll-view .uni-scroll-view-content > uni-view:first-child > .cu-list.menu:only-child > uni-view[style="margin-left: 5%;"] {
	bottom: 4em;
	margin-left: 0 !important;
	padding: .25em .5em 0;
}

/* border-top */
.nav + uni-scroll-view .uni-scroll-view-content > uni-view:first-child > .cu-list.menu:only-child > uni-view[style="margin-left: 5%;"],
.nav + uni-scroll-view .uni-scroll-view-content > uni-view:first-child > .foot {
	border-top: 1px solid rgba(0, 0, 0, .1);
	box-shadow:
		0 2px 4px -1px rgba(0, 0, 0, .2),
		0 4px 5px  0   rgba(0, 0, 0, .14),
		0 1px 10px 0   rgba(0, 0, 0, .12);
}`;

}

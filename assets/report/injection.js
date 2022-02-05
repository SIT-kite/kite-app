if (typeof runFlag === 'undefined') {

  runFlag = true;
  console.info('Initializing injection.js');

  const userName = '{username}';

  // const prefix = 'http://xgfy.sit.edu.cn/h5/';
  const routes = {
    login: '#/',
    home:  '#/pages/index/index'
  }; /*
    report:        "#/pages/index/jksb",
    studentReport: "#/pages/index/studentReport",
    yimiaon:       "#/pages/index/yimiaon",
  */

  const goHome = () => location.hash = routes.home;
  const isLoginPage = () => location.hash === routes.login;
  const isLogin = () => localStorage.getItem('loginIn') === '1';
  const login = () => {
      const userInfo = JSON.stringify({ code: userName });
      localStorage.setItem('userInfo', userInfo);
      localStorage.setItem('loginIn', '1');
      console.info('LocalStorage login set');
  };

  if (isLoginPage() && !isLogin()) {
    login();
    goHome();
  }

}

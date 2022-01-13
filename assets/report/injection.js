if (typeof(runFlag) === 'undefined') {
  runFlag = true;

  (function () {
    let userName = '{username}';
    let loginPage = 'http://xgfy.sit.edu.cn/h5/#/';
    let homePage = 'http://xgfy.sit.edu.cn/h5/#/pages/index/index';

    const goHome = () => window.location.href = homePage;
    const isLogin = () => localStorage.getItem('loginIn') === '1';
    const login = () => {
        const info = {'code': userName};
        localStorage.setItem('userInfo', JSON.stringify(info));
        localStorage.setItem('loginIn', '1');
        console.info('LocalStorage is set.');
    };

    console.info('Initializing injection.js');
    if (window.location == loginPage && !isLogin()) {
      login();
      goHome();
    }
  })();
}

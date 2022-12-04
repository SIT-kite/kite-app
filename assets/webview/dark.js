function loadScript(url, callback) {
     callback = typeof callback === 'function' ? callback : function() {};
     let head = document.getElementsByTagName('head')[0];
     let script = document.createElement('script');
     script.type = 'text/javascript';
     script.src = url;
     script.onreadystatechange = function() {
     if(this.readyState == "loaded" || this.readyState == "complete"){
        callback();
     }
     }
     script.onload = callback;
     head.appendChild(script);
}
loadScript('https://cdn.jsdelivr.net/npm/darkmode-js@1.4.0/lib/darkmode-js.min.js', ()=>{
    new Darkmode().toggle();
});

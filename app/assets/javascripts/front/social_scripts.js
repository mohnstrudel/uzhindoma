// Crisp chat app

window.$crisp=[];window.CRISP_WEBSITE_ID="61b20a93-08f7-4e85-a440-23f27b0fcd89";
(function(){d=document;s=d.createElement("script");
  s.src="https://client.crisp.im/l.js";
  s.async=1;d.getElementsByTagName("head")[0].appendChild(s);
})();

// Facebook Pixel Code

!function(f,b,e,v,n,t,s){
  if(f.fbq)return;
  n=f.fbq=function(){
    n.callMethod?
    n.callMethod.apply(n,arguments):n.queue.push(arguments)};
    if(!f._fbq)f._fbq=n;
    n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,
document,'script','https://connect.facebook.net/en_US/fbevents.js');
fbq('init', '455068191353750'); // Insert your pixel ID here.
fbq('track', 'PageView');
//End Facebook Pixel Code


// roistat

(function(w, d, s, h, id) {
    w.roistatProjectId = id; w.roistatHost = h;
    var p = d.location.protocol == "https:" ? "https://" : "http://";
    var u = /^.*roistat_visit=[^;]+(.*)?$/.test(d.cookie) ? "/dist/module.js" : "/api/site/1.0/"+id+"/init";
    var js = d.createElement(s); js.async = 1; js.src = p+h+u; var js2 = d.getElementsByTagName(s)[0]; js2.parentNode.insertBefore(js, js2);
})(window, document, 'script', 'cloud.roistat.com', 'a6da58db9cb636a28dd43ef27eb050fd');
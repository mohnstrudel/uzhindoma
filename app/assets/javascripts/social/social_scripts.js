// VK Pixel
!function(){
  var t=document.createElement("script");
  t.type="text/javascript",t.async=!0,t.src="https://vk.com/js/api/openapi.js?159",t.onload=function(){
    VK.Retargeting.Init("VK-RTRG-273138-cpiZa"),VK.Retargeting.Hit()
  },document.head.appendChild(t)}();


// Yandex Metrika Counter

// New Yandex Metrika
   (function (d, w, c) {
       (w[c] = w[c] || []).push(function() {
           try {
               w.yaCounter49229887 = new Ya.Metrika2({
                   id:49229887,
                   clickmap:true,
                   trackLinks:true,
                   accurateTrackBounce:true,
                   webvisor:true
               });
           } catch(e) { }
       });

       var n = d.getElementsByTagName("script")[0],
           s = d.createElement("script"),
           f = function () { n.parentNode.insertBefore(s, n); };
       s.type = "text/javascript";
       s.async = true;
       s.src = "https://mc.yandex.ru/metrika/tag.js";

       if (w.opera == "[object Opera]") {
           d.addEventListener("DOMContentLoaded", f, false);
       } else { f(); }
   })(document, window, "yandex_metrika_callbacks2");


// Google Analytics

(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-52944792-1', 'auto');
ga('send', 'pageview');



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
// Отключаем ройстат 03/07/2017 по запросу Н.Брагина
// (function(w, d, s, h, id) {
//     w.roistatProjectId = id; w.roistatHost = h;
//     var p = d.location.protocol == "https:" ? "https://" : "http://";
//     var u = /^.*roistat_visit=[^;]+(.*)?$/.test(d.cookie) ? "/dist/module.js" : "/api/site/1.0/"+id+"/init";
//     var js = d.createElement(s); js.async = 1; js.src = p+h+u; var js2 = d.getElementsByTagName(s)[0]; js2.parentNode.insertBefore(js, js2);
// })(window, document, 'script', 'cloud.roistat.com', 'a6da58db9cb636a28dd43ef27eb050fd');


// Mail.ru Rating
var _tmr = window._tmr || (window._tmr = []);
_tmr.push({id: "2910667", type: "pageView", start: (new Date()).getTime()});
(function (d, w, id) {
  if (d.getElementById(id)) return;
  var ts = d.createElement("script"); ts.type = "text/javascript"; ts.async = true; ts.id = id;
  ts.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//top-fwz1.mail.ru/js/code.js";
  var f = function () {var s = d.getElementsByTagName("script")[0]; s.parentNode.insertBefore(ts, s);};
  if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); }
})(document, window, "topmailru-code");

//Rating@Mail.ru counter


// Google Remarketing

/* <![CDATA[ */
var google_conversion_id = 875449528;
var google_custom_params = window.google_tag_params;
var google_remarketing_only = true;
/* ]]> */


// Google Tag Manager
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());
gtag('config', 'UA-122153150-1');




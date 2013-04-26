<!DOCTYPE html>
<html lang="de">
  <head>
    <meta charset="utf-8">
    <title>Satzgenerator: {{get('titel', 'kein titel')}}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Der beste deutsche Satzgenerator im Internet. Erzeugt zufällige Sätze, die zum Teil lustig sind.">
    <meta name="keywords" content="Satz generieren, Sätze, Fakten, Satzgenerator, deutsch, Open Source, Python, Statistik, absurd, lustig, bewerten, download" />
    <meta name="author" content="davidak">
    <meta name="robots" content="index,follow">
    <link href="assets/css/bootstrap.css" rel="stylesheet">
    <style>
      body { padding-top: 60px; /* 60px to make the container go all the way
      to the bottom of the topbar */ }
    </style>
    <link href="assets/css/bootstrap-responsive.css" rel="stylesheet">
    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js">
      </script>
    <![endif]-->
    <!-- fav and touch icons -->
    <link rel="shortcut icon" href="assets/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="assets/ico/apple-touch-icon-57-precomposed.png">
    <style>
      body { background-image: url(http://images.apple.com/euro/ipod/images/gradient_texture20100901.jpg);
      background-repeat:repeat-x; background-color: #F5F6F7; } .alert { display:none }
    </style>
  </head>
  
  <body>
    <div class="navbar navbar-fixed-top navbar-inverse">
      <div class="navbar-inner">
        <div class="container">
          <a class="brand" href="http://satzgenerator.net/">Satzgenerator</a>
          <ul class="nav">
            <li><a href="/beste-bewertung">Beste Bewertung</a></li>
            <li><a href="/schlechteste-bewertung">Schlechte Bewertung</a></li>
            <li><a href="/meiste-bewertungen">Meiste Bewertungen</a></li>
            <li><a href="/neuste-saetze">Neuste Sätze</a></li>
            <li><a href="http://davidak.de/impressum">Impressum</a></li>
          </ul>
        </div>
      </div>
    </div>
    
    <div id="content" class="container-fluid">
    
	<h3>{{get('titel', 'kein titel')}}</h3><br>
    
%for dsatz in satze:
	%id, pos, neg, satz = dsatz[0], dsatz[1], dsatz[2], dsatz[4]
    
    <blockquote>
      <h4><a href="http://satzgenerator.net/{{id}}">{{satz}}</a></h4>
      <i class="icon-thumbs-up"></i> {{str(pos)}} 
      <i class="icon-thumbs-down"></i> {{str(neg)}}
    </blockquote>
%end
    </div>

     </div></div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script src="assets/js/bootstrap.js"></script>
    
<!-- Piwik --> 
<script type="text/javascript">
var pkBaseURL = (("https:" == document.location.protocol) ? "https://davidak.de/stats/" : "http://davidak.de/stats/");
document.write(unescape("%3Cscript src='" + pkBaseURL + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
</script><script type="text/javascript">
try {
var piwikTracker = Piwik.getTracker(pkBaseURL + "piwik.php", 9);
piwikTracker.trackPageView();
piwikTracker.enableLinkTracking();
} catch( err ) {}
</script><noscript><p><img src="http://davidak.de/stats/piwik.php?idsite=9" style="border:0" alt="" /></p></noscript>
<!-- End Piwik Tracking Code -->

  </body>
</html>
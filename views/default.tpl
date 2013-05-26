<!DOCTYPE html>
<html lang="de">
  <head>
    <meta charset="utf-8">
%try:
	%satz_uid
    <title>Satzgenerator: {{get('satz', '')}}</title>
%except:
	<title>Satzgenerator</title>
%end
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="description" content="Der beste deutsche Satzgenerator im Internet. Erzeugt zufällige Sätze, die zum Teil lustig sind.">
    <meta name="keywords" content="Satz generieren, Sätze, Fakten, Satzgenerator, deutsch, Open Source, Python, absurd, lustig, bewerten, download" />
    <meta name="author" content="davidak">
    <meta name="robots" content="index,follow">
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet">
    <style>
      body {
      padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
      background-image: url(http://images.apple.com/euro/ipod/images/gradient_texture20100901.jpg);
      background-repeat:repeat-x; background-color: #F5F6F7;
      }
      #content { text-align: center; margin-top: 100px; }
      #permalink, #warnung { display:none; }
      .btn-toolbar { margin-top: 40px; }

      /* Responsive */
      .progress { max-width:344px; margin-left:auto; margin-right:auto; }
      .input-block-level { max-width:344px; margin-left:auto; margin-right:auto; }
      #warnung { max-width:291px; margin-left:auto; margin-right:auto; }
      /* Landscape phones and down */
      @media (max-width: 480px) {
      .progress { max-width:273px; }
      .input-block-level { max-width:273px; }
      #warnung { max-width:220px; }
      #content { margin-top: 0px; }
      .btn-toolbar { margin-top: 20px; }
      }
    </style>
    <link href="bootstrap/css/bootstrap-responsive.css" rel="stylesheet">
    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js">
      </script>
    <![endif]-->
    <!-- fav and touch icons
    <link rel="shortcut icon" href="bootstrap/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="bootstrap/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="bootstrap/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="bootstrap/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="bootstrap/ico/apple-touch-icon-57-precomposed.png">
    -->

  </head>
  <body>

<!-- Menü -->
<div class="navbar navbar-fixed-top navbar-inverse">
<div class="navbar-inner">
<div class="container-fluid">

<a class="brand" href="/">Satzgenerator</a>

<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
 <span class="icon-bar"></span>
 <span class="icon-bar"></span>
 <span class="icon-bar"></span>
</a>

<div class="nav-collapse collapse">

<ul class="nav">
<li><a href="/beste-bewertung">Beste Bewertung</a></li>
<li><a href="/schlechteste-bewertung">Schlechte Bewertung</a></li>
<li><a href="/meiste-bewertungen">Meiste Bewertungen</a></li>
<li><a href="/neuste-saetze">Neuste Sätze</a></li>
<li><a href="http://davidak.de/impressum">Impressum</a></li>
</ul>

</div><!-- /.nav-collapse -->
</div><!-- /.container -->
</div><!-- /.navbar-inner -->
</div><!-- /.navbar -->
    
    <div id="content" class="container-fluid">
      <h3>{{get('satz', 'Fehler beim generieren des Satzes.')}}</h3>
      
      <form id="bewerten" action="#" method="POST">
      <div class="btn-toolbar">
      <button id="pos" type="submit" name="pro" class="btn btn-success"><i class="icon-thumbs-up icon-white"></i><span class="hidden-phone"> Gefällt mir</span></button> <!--disabled-->
      <button id="neg" type="submit" name="kontra" class="btn btn-danger"><i class="icon-thumbs-down icon-white"></i></button>
      <button id="per" type="submit" name="permalink" onclick="show_permalink()" class="btn btn-primary">Teilen</button>

      <a class="btn btn-inverse" href="/"><i class="icon-refresh icon-white"></i> Neuer Satz</a>
      </div>
      </form>

      <div class="alert alert-error" id="warnung">
       <a type="button" class="close" href="#" onclick="hide_warning()">&times;</a>
       Du hast diesen Satz heute schon bewertet.
      </div>

<div id="bewertung" class="progress"><!-- Bewertung anzeigen -->
<div id="positiv_prozent_balken" class="bar bar-success" style="width: 0%;">1</div>
<div id="negativ_prozent_balken" class="bar bar-danger" style="width: 0%;">1</div>
</div>

    <input class="input-block-level" id="permalink" type="text" value="http://satzgenerator.net/{{get('satz_uid')}}">

    </div>

    <!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script> -->
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script src="bootstrap/js/bootstrap.js"></script>

    <script>function show_permalink() {document.getElementById('permalink').style.display='block'; document.getElementById('permalink').select();}</script>
    <script>function show_warning() {document.getElementById('warnung').style.display='block';}</script>
    <script>function hide_warning() {document.getElementById('warnung').style.display='none';}</script>
    {{!get('permalink', '')}}
    {{!get('fehler', '')}}

<script type="text/javascript">
// Bewertung abschicken
$("#pos, #neg, #per").click(function() {
    $.ajax({
           type: "POST",
           url: "#",
           dataType: 'text',
           data : { text: $(this).attr("name") },
           success: function(data)
           {
              if (data)
              {
              var vars = data.split(",");
              bewertung_anzeigen(vars[0], vars[1]);
              }
           }
         });

    event.preventDefault();
});

// Bewertung anzeigen
positiv = {{get('positiv', '0')}};
negativ = {{get('negativ', '0')}};

if (positiv == 0 && negativ == 0)
{
  document.getElementById('bewertung').style.display='none';
}
else
{
  bewertung_anzeigen(positiv, negativ);
}

function bewertung_anzeigen(positiv, negativ)
{
    document.getElementById('bewertung').style.display='block';

    var gesamt = parseInt(positiv) + parseInt(negativ);
    positiv_prozent = parseInt(positiv / gesamt * 100);
    negativ_prozent = parseInt(100 - positiv_prozent);

    document.getElementById('positiv_prozent_balken').style.width = positiv_prozent + "%";
    document.getElementById('positiv_prozent_balken').innerHTML = positiv;

    document.getElementById('negativ_prozent_balken').style.width = negativ_prozent + "%";
    document.getElementById('negativ_prozent_balken').innerHTML = negativ;
}
</script>

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
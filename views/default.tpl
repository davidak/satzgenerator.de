<!DOCTYPE html>
<html lang="de">
  <head>
    <meta charset="utf-8">
%try:
	%satz_id
    <title>Satzgenerator: {{get('satz', '')}}</title>
%except:
	<title>Satzgenerator</title>
%end
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="description" content="Der beste deutsche Satzgenerator im Internet. Erzeugt zufällige Sätze, die zum Teil lustig sind.">
    <meta name="keywords" content="Satz generieren, Sätze, Fakten, Satzgenerator, deutsch, Open Source, Python, absurd, lustig, bewerten, download" />
    <meta name="author" content="davidak">
    <meta name="robots" content="index,follow">
    <link href="assets/css/bootstrap.css" rel="stylesheet">
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
      
      <form action="/" method="POST">
      <input name='satz' type='hidden' value='{{get('satz', '')}}'>
      <div class="btn-toolbar">
      <button type="submit" name="pro" value='1' class="btn btn-success"><i class="icon-thumbs-up icon-white"></i><span class="hidden-phone"> Gefällt mir</span></button> <!--disabled-->
      <button type="submit" name="contra" value='1' class="btn btn-danger"><i class="icon-thumbs-down icon-white"></i></button>
%try:
	%satz_id
	<a class="btn btn-primary" href="#" onclick="show_permalink()">Teilen</a>
%except:
	<button type="submit" name="permalink" value='1' class="btn btn-primary">Teilen</button>
%end
      <a class="btn btn-inverse" href="/{{get('randb_satz', '')}}"><i class="icon-refresh icon-white"></i> Neuer Satz</a>
      </div>
      </form>

      <div class="alert alert-error" id="warnung">
       <a type="button" class="close" href="#" onclick="hide_warning()">&times;</a>
       Du hast diesen Satz heute schon bewertet.
      </div>

%try:
%	ges = pos + neg
%	pos_proz = float(pos)/ges * 100
%	pos_proz = int(pos_proz)
%	neg_proz = 100-pos_proz
	<div class="progress">
	<div class="bar bar-success" style="width: {{str(pos_proz)}}%;">{{str(pos)}}</div>
	<div class="bar bar-danger" style="width: {{str(neg_proz)}}%;">{{str(neg)}}</div>
	</div>
%except:
%	pass
%#	print("Fehler: Keine Bewertungsdaten übergeben.")
%end

    <input class="input-block-level" id="permalink" type="text" value="http://satzgenerator.net/{{get('satz_id', 'satz_id')}}">

    </div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script src="assets/js/bootstrap.js"></script>
    <script>function show_permalink() {document.getElementById('permalink').style.display='block'; document.getElementById('permalink').select();}</script>
    <script>function show_warning() {document.getElementById('warnung').style.display='block';}</script>
    <script>function hide_warning() {document.getElementById('warnung').style.display='none';}</script>
    {{!get('permalink', '')}}
    {{!get('fehler', '')}}
    
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
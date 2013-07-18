<!DOCTYPE html>
<html lang="de">
<head>
%include head titel=titel
<link href="style/satz.css" rel="stylesheet">
</head>
<body>

%include menu

<div id="content" class="container-fluid">

<h1>{{get('satz', 'Fehler beim generieren des Satzes.')}}</h1>

<noscript>
<h2>Warnung!</h2>
<p>Bitte aktiviere JavaScript, um Sätze bewerten und teilen zu können.</p>
</noscript>

<form id="bewerten" action="#" method="POST">
<div class="btn-toolbar">
<button id="pos" type="button" name="pro" class="btn btn-success"><i class="icon-thumbs-up-alt"></i><span class="hidden-480"> Gefällt mir</span></button> <!--disabled-->
<button id="neg" type="button" name="kontra" class="btn btn-danger"><i class="icon-thumbs-down-alt"></i></button>
<button id="per" type="button" name="permalink" onclick="show_permalink()" class="btn btn-primary">Teilen</button>
<a class="btn btn-inverse" href="/"><i class="icon-refresh"></i> Neuer Satz</a>
</div>
</form>

<div id="bewertung" class="progress"><!-- Bewertung anzeigen -->
<div id="positiv_prozent_balken" class="bar bar-success" style="width: 0%;">1</div>
<div id="negativ_prozent_balken" class="bar bar-danger" style="width: 0%;">1</div>
</div>

<input class="input-block-level" id="permalink" type="text" value="http://satzgenerator.de/{{get('satz_uid')}}">

<div class="alert alert-error" id="warnung">
 <a type="button" class="close" href="#" onclick="hide_warning()">&times;</a>
Du darfst diesen Satz nur einmal in 24 Stunden bewerten.
</div>

</div> <!-- /content -->

%include footer

%include satzjs

</body>
</html>
<!DOCTYPE html>
<html lang="de">
<head>
%include head titel=titel
</head>
<body>

<div id="wrap">

%include menu

<div id="content" class="container">

<div class="row">

<div class="col-md-8">
<p class="lead">Der Satzgenerator erzeugt absurde Sätze, indem zufällige Worte anhand von Satzschemata zusammengefügt werden.</p>
</div>

<div class="col-md-4">

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Statistik</h3>
  </div>
  <div class="panel-body">
  	<ul class="list-unstyled">
    <li>{{anzahl_saetze}} Sätze in der Datenbank</li>
	<li>{{gesamt}} Bewertungen insgesamt,</li>
	<li>davon {{gute}} gute und {{schlechte}} schlechte</li>
	</ul>
  </div>
</div>

</div>

</div> <!-- .row -->

<div class="row">

<div class="col-md-12">
<p>Die oft lustigen Sätze können bewertet und per Link z.B. über soziale Netzwerke, Instant-Messanger oder E-Mail geteilt werden. Auch eine Rangliste mit den besten, schlechtesten oder neusten Sätzen ist vorhanden. Für jede Art von Lob und Kritik gibt es das Feedback-Formular. Wenn dir z.B. ein grammatikalischer Fehler bei einem Satz auffällt, kannst du ihn schnell an den Entwickler weiterleiten und damit zur Verbesserung des Satzgenerators beitragen.</p>
</div>
</div> <!-- .row -->

<div class="row">

<div class="col-md-6">
<h2>Beste Bewertung</h2>
<ol>
%for satz in beste:
<li><a href="{{satz.uid}}">{{satz.satz}}</a></li>
%end
</ol>
</div>

<div class="col-md-6">
<h2>Neuste Sätze</h2>
<ol>
%for satz in neuste:
<li><a href="{{satz.uid}}">{{satz.satz}}</a></li>
%end
</ol>
</div>

</div> <!-- .row -->

<div class="text-center">
<a class="btn btn-default btn-fehler-404" role="button" href="/neu"><i class="fa fa-refresh"></i> Neuer Satz</a>
</div>

</div> <!-- #content -->

</div> <!-- #wrap -->

%include footer
%include piwik

</body>
</html>
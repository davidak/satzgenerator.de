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
<p class="lead">Der Satzgenerator erzeugt zufällige Sätze, die zum Teil lustig sind. Lorem ipsum dolor sit amet, consetetur sadipscing elitr,  sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.</p>
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
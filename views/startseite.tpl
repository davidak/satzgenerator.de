<!DOCTYPE html>
<html lang="de">
<head>
%include head titel=titel
</head>
<body>

<div id="wrap">

%include menu

<div id="content" class="container">

<p>Der Satzgenerator erzeugt zufällige Sätze, die zum Teil lustig sind. Sieh dir <a href="/beste-bewertung">die Sätze mit den besten Bewertungen</a>, <a href="/schlechte-bewertung">den schlechtesten Bewertungen</a>, <a href="/meiste-bewertung">den meisten Bewertungen</a> oder <a href="/neue-saetze">die neusten Sätze</a> an. Du kannst auch <a href="/neu">einen neuen Satz generieren</a> oder <a href="/zufaelliger-satz">einen zufälligen Satz aus der Datenbank aufrufen</a>.</p>

<div class="row">

<div class="col-md-4">
<h2>Beste Bewertung</h2>
<ol>
%for satz in beste:
<li><a href="{{satz.uid}}">{{satz.satz}}</a></li>
%end
</ol>
</div>

<div class="col-md-4">
<h2>Meiste Bewertung</h2>
<ol>
%for satz in meiste:
<li><a href="{{satz.uid}}">{{satz.satz}}</a></li>
%end
</ol>
</div>

<div class="col-md-4">
<h2>Neue Sätze</h2>
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

</body>
</html>
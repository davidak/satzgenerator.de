<!DOCTYPE html>
<html lang="de">
<head>
%include head titel='Satzgenerator: ' + titel
<link href="/style/rangliste.css" rel="stylesheet">
</head>
<body>

<div id="wrap">

%include menu

<div class="container">

<h2>{{get('titel')}}</h2>

%if satze == '':
	<form class="form-inline" role="search" method="POST" action="/suche">
	   	<input type="text" name="suchbegriff" class="form-control" placeholder="Suchbegriff eingeben">
	    <button type="submit" class="btn btn-default">Suchen</button>
	</form>
%end

%i = 0
%for satz in satze:
  %i += 1
<div class="satz">

<span class="div-line" style="margin-bottom:0;"></span>
<div class="divider">{{i}}</div>
<span class="div-line" style="margin-bottom:0;"></span>

<h3><a class="hyphenate" href="/{{satz.uid}}">{{satz.satz}}</a></h3>

<p class="bewertung">
%if 'neusten' in titel:
	% datum = satz.created.strftime('%d.%m.%Y')
	% zeit = satz.created.strftime('%H:%M:%S')
	<i class="fa fa-calendar"></i> {{datum}} 
	<i class="fa fa-clock-o"></i> {{zeit}} 
%end
<i class="fa fa-thumbs-o-up"></i> {{str(satz.pro)}} 
<i class="fa fa-thumbs-o-down"></i> {{str(satz.kontra)}}
</p>

</div> <!-- .satz -->
%end

</div> <!-- .container -->

</div> <!-- #wrap -->

%include footer

<script type="text/javascript">

// Silbentrennung per JS
Hyphenator.config({ minwordlength: 14 });
Hyphenator.run();

</script>

</body>
</html>

<!DOCTYPE html>
<html lang="de">
<head>
%include head titel='Satzgenerator: ' + titel
<link href="style/satz-liste.css" rel="stylesheet">
</head>
<body>

<div id="wrap">

%include menu

<div id="content" class="container">

<h2>{{get('titel')}}</h2>


%i = 0
%for satz in satze:
  %i += 1
<div class="satz">

<span class="div-line" style="margin-bottom:0;"></span>
<div class="divider">{{i}}</div>
<span class="div-line" style="margin-bottom:0;"></span>

<h3><a href="/{{satz.uid}}">{{satz.satz}}</a></h3>

<p class="bewertung">
<i class="fa fa-thumbs-o-up"></i> {{str(satz.pro)}} 
<i class="fa fa-thumbs-o-down"></i> {{str(satz.kontra)}}
</p>

</div> <!-- .satz -->
%end

</div> <!-- #content -->

</div> <!-- #wrap -->

%include footer

<script type="text/javascript">

// Satz so groß wie möglich, aber nicht mehr als 4 Zeilen
if ( $(window).width() <= 768 ) {
  $("h2").fitText(1.2)
  $("h3").fitText(1.0);
} else {
  $("h2").fitText(1.4)
  $("h3").fitText(1.5);
}

</script>

</body>
</html>
<!DOCTYPE html>
<html lang="de">
<head>
%include head titel='Satzgenerator: ' + titel
<link href="style/satz-liste.css" rel="stylesheet">
</head>
<body>

<div id="wrap">

%include menu

<div class="container">

<h2>{{get('titel')}}</h2>


%i = 0
%for satz in satze:
  %i += 1
<div class="satz">

<span class="div-line" style="margin-bottom:0;"></span>
<div class="divider">{{i}}</div>
<span class="div-line" style="margin-bottom:0;"></span>

<h3><a class="hyphenate" href="/{{satz.uid}}">{{satz.satz}}</a></h3>

<p class="bewertung">
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
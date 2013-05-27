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

<form id="bewerten" action="#" method="POST">
<div class="btn-toolbar">
<button id="pos" type="submit" name="pro" class="btn btn-success"><i class="icon-thumbs-up icon-white"></i><span class="hidden-480"> Gefällt mir</span></button> <!--disabled-->
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

</div> <!-- /content -->

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

<script>function show_permalink() {document.getElementById('permalink').style.display='block'; document.getElementById('permalink').select();}</script>
<script>function show_warning() {document.getElementById('warnung').style.display='block';}</script>
<script>function hide_warning() {document.getElementById('warnung').style.display='none';}</script>

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

%include footer

</body>
</html>
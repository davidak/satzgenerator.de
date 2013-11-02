<!DOCTYPE html>
<html lang="de">
<head>
%include head titel=titel
<link href="style/satz.css" rel="stylesheet">
</head>
<body>

<!-- Wrap all page content here -->
<div id="wrap">

%include menu

<div id="content" class="container">

<div class="satz_bereich">
<div class="satz">
<h1 id="satz">{{get('satz', 'Fehler beim generieren des Satzes.')}}</h1>
</div>
</div>

<form id="bewerten" action="#" method="POST">
<div class="btn-toolbar" role="toolbar">
<button id="pos" type="button" name="pro" class="btn btn-success"><i class="icon-thumbs-up-alt"></i><span class="hidden-480"> Gefällt mir</span></button> <!--disabled-->
<button id="neg" type="button" name="kontra" class="btn btn-danger"><i class="icon-thumbs-down-alt"></i></button>
<button id="per" type="button" name="permalink" onclick="show_permalink()" class="btn btn-primary">Teilen</button>
<a id="satz_neu" class="btn btn-default" role="button" href="/"><i class="icon-refresh"></i> Neuer Satz</a>
</div>
</form>

<noscript>
<div class="alert alert-warning">
Bitte aktiviere JavaScript, um Sätze bewerten und teilen zu können.
</div>
</noscript>

<div id="bewertung" class="progress"><!-- Bewertung anzeigen -->
<div id="positiv_prozent_balken" class="progress-bar progress-bar-success" style="width: 0%;">0</div>
<div id="negativ_prozent_balken" class="progress-bar progress-bar-danger" style="width: 0%;">0</div>
</div>

<input class="input-block-level" id="permalink" type="text" value="http://satzgenerator.de/{{get('satz_uid')}}">

<div class="alert alert-danger" id="warnung">
 <button type="button" class="close" onclick="hide_warning()" aria-hidden="true">&times;</button>
Du darfst jeden Satz nur einmal in 24 Stunden bewerten.
</div>

</div> <!-- #content -->

</div> <!-- #wrap -->

%include footer

<script type="text/javascript">

// Satz so groß wie möglich, aber nicht mehr als 4 Zeilen
if ( $("#satz").html().length < 40 ) {
  $("#satz").fitText()
}
else if ( $("#satz").html().length < 80 ) {
  $("#satz").fitText(1.2)
}
else {
  $("#satz").fitText(1.6);
}

// auf mobilen geräten kleiner als 480 kleine Buttons anzeigen
function smallButtons() {
  if ( $(window).width() <= 768 ) {
    $("#pos").addClass("btn-sm");
    $("#neg").addClass("btn-sm");
    $("#per").addClass("btn-sm");
    $("#satz_neu").addClass("btn-sm");
  }
}
smallButtons();

// Permalink anzeigen
function show_permalink() {
  $("#permalink").css("display", "block");
  $("#permalink").select();
}

// Fehlermeldung anzeigen oder verbergen
function show_warning() { $("#warnung").css("display", "block"); }
function hide_warning() { $("#warnung").css("display", "none"); }

// Bewertung abschicken
$("#pos, #neg, #per").click(function() {
    $.ajax({
           type: "POST",
           url: "#",
           dataType: 'text',
           data : { text: $(this).attr("name") },
           success: function(data) {
              if (data) {
                if (data == "nein") {
                  show_warning();
                  bewertung_deaktivieren();
                }
                else {
                var vars = data.split(",");
                bewertung_anzeigen(vars[0], vars[1]);
                bewertung_deaktivieren();
                }
              }
          }
    });
    event.preventDefault();
});

// Bewertung anzeigen
positiv = {{get('positiv', '0')}};
negativ = {{get('negativ', '0')}};

// wenn Bewertung vorhanden -> anzeigen
if (positiv > 0 || negativ > 0) { bewertung_anzeigen(positiv, negativ); }

function bewertung_anzeigen(positiv, negativ) {
  $("#bewertung").css("display", "block");

  var gesamt = parseInt(positiv) + parseInt(negativ);
  positiv_prozent = parseInt(positiv / gesamt * 100);
  negativ_prozent = parseInt(100 - positiv_prozent);

  $("#positiv_prozent_balken").css("width", positiv_prozent + "%");
  $("#positiv_prozent_balken").html(positiv);

  $("#negativ_prozent_balken").css("width", negativ_prozent + "%");
  $("#negativ_prozent_balken").html(negativ);
}

function bewertung_deaktivieren() {
  $("#pos").addClass("disabled");
  $("#neg").addClass("disabled");
}
</script>

</body>
</html>
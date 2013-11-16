<!DOCTYPE html>
<html lang="de">
<head>
%include head titel=titel
<link href="/style/satz.css" rel="stylesheet">
</head>
<body>

<!-- Wrap all page content here -->
<div id="wrap">

%include menu

<div class="container">

<div class="satz_bereich">
<div class="satz">
<h1 class="hyphenate" id="satz">{{get('satz', 'Fehler beim generieren des Satzes.')}}</h1>
</div>
</div>

<form id="bewerten" action="#" method="POST">
<div class="btn-toolbar" role="toolbar">
<button id="pos" type="button" name="pro" class="btn btn-success"><i class="fa fa-thumbs-o-up"></i><span class="hidden-480"> Gefällt mir</span></button>
<button id="neg" type="button" name="kontra" class="btn btn-danger"><i class="fa fa-thumbs-o-down"></i></button>
<button id="per" type="button" name="permalink" onclick="show_permalink()" class="btn btn-primary">Teilen</button>
<a id="satz_neu" class="btn btn-default" role="button" href="/neu"><i class="fa fa-refresh"></i> Neuer Satz</a>
</div>
</form>

<noscript>
<div id="js-warn" class="alert alert-warning">
Bitte aktiviere JavaScript, um Sätze bewerten und teilen zu können.
</div>
<!-- Satz wird sonst per JS eingefadet -->
<style>
  .satz_bereich { opacity: 1; }
  .satz_bereich h1 { font-size: 500%; }
</style>
</noscript>

<!-- Bewertung -->
<div id="bewertung" class="progress">
<div id="positiv_prozent_balken" class="progress-bar progress-bar-success" style="width: 0%;">0</div>
<div id="negativ_prozent_balken" class="progress-bar progress-bar-danger" style="width: 0%;">0</div>
</div>

<!-- Permalink -->
<input class="input-block-level" id="permalink" type="text" value="http://satzgenerator.de/{{get('satz_uid')}}">

<div class="alert alert-danger alert-dismissable" id="warnung">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
Du darfst jeden Satz nur einmal in 24 Stunden bewerten.
</div>

</div> <!-- .container -->

</div> <!-- #wrap -->

%include footer

<script src="style/Hyphenator.js"></script>
<script src="style/textFit.min.js"></script>

<script type="text/javascript">

// Silbentrennung per JS
Hyphenator.config({ minwordlength: 14 });
Hyphenator.run();

// Satz so groß wie möglich machen
textFit($(".satz_bereich")[0], {alignHoriz: true, alignVert: true, multiLine: true, minFontSize: 20, maxFontSize: 200,});

// auf dem Desktop den Satz einfaden:
// per CSS unsichtbar gemacht
// hier hochschieben
if ( $(window).width() >= 768 ) {
  $(".satz").css({ marginTop: "-100px" });
}

// auf mobilen geräten kleiner als 480 kleine Buttons anzeigen
if ( $(window).width() <= 768 ) {
  $("#pos, #neg, #per, #satz_neu").addClass("btn-sm");
}

// auf dem Desktop den Satz einfaden
$(".satz").animate({ marginTop: "0", opacity: 1 }, 500);

// Permalink anzeigen
function show_permalink() {
  $("#permalink").css("display", "block");
  $("#permalink").select();
}

// Fehlermeldung anzeigen
function show_warning() { $("#warnung").show(); }

// Bewertung abschicken
$("#pos, #neg, #per").click(function(event) {
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
  // Prozente berechnen
  var gesamt = parseInt(positiv) + parseInt(negativ);
  positiv_prozent = parseInt(positiv / gesamt * 100);
  negativ_prozent = parseInt(100 - positiv_prozent);

  $("#positiv_prozent_balken").css("width", positiv_prozent + "%");
  $("#positiv_prozent_balken").html(positiv);

  $("#negativ_prozent_balken").css("width", negativ_prozent + "%");
  $("#negativ_prozent_balken").html(negativ);

  $("#bewertung").show();
}

function bewertung_deaktivieren() {
  $("#pos, #neg").addClass("disabled");
}

</script>

%include piwik

</body>
</html>
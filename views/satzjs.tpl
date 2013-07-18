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

function bewertung_deaktivieren() {
  var poss = document.getElementById("pos")
  poss.className = poss.className + " disabled";
  poss.setAttribute("disabled", true);
  var nega = document.getElementById("neg")
  nega.className = nega.className + " disabled";
  nega.setAttribute("disabled", true);
}
</script>

<div id="footer">
<p class="text-muted credit">Entwickelt 2013 von <a href="http://davidak.de/">davidak</a> mit <a href="http://python.org/">Python</a>, <a href="http://bottlepy.org/">Bottle</a>, <a href="http://jquery.com/">jQuery</a> und <a href="http://getbootstrap.com/">Bootstrap</a>. Die Sätze werden von <a href="http://pyzufall.readthedocs.org/de/latest/">PyZufall</a> generiert.</p><p class="text-muted credit text-right"><a href="/impressum">Impressum</a></p>
</div>

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.1/js/bootstrap.min.js"></script>
<script src="style/jquery.fittext.js"></script>
<script src="style/Hyphenator.js"></script>
<script src="style/textFit.min.js"></script>

<!-- Feedback-Formular -->
<script type="text/javascript">

// die Checkbox nur auf Satz-Seiten anzeigen
$( document ).ready(function() {
  if ( $("#satz").html() ) {
    $('.modal .checkbox').show();
  }
});

// wenn die Checkbox aktiviert wird, den Satz in das hidden field kopieren, um ihn mitzuschicken
$('.modal .checkbox input').change(function() {
  $("input[name='satz']").val($("#satz").html());
});

// Feedback-Formular abschicken
$(".modal #feedback-btn").click(function(event) {
    $.ajax({
           type: "POST",
           url: "/feedback",
           dataType: 'text',
           data : $(".modal form").serialize(),
           success: function(data) {
              if (data) {
                if (data == "erfolgreich") {
                  $(".modal-footer .text-success").fadeIn();
                  setTimeout(function() {
					$('.modal').modal('hide')
				}, 1500);
                }
                else {
                $(".modal-footer .text-danger").fadeIn();
                }
              }
          }
    });
    event.preventDefault();
});
</script>


<!-- Piwik -->
<!--<script type="text/javascript">
  var _paq = _paq || [];
  _paq.push(["trackPageView"]);
  _paq.push(["enableLinkTracking"]);

  (function() {
    var u=(("https:" == document.location.protocol) ? "https" : "http") + "://davidak.de/stats/";
    _paq.push(["setTrackerUrl", u+"piwik.php"]);
    _paq.push(["setSiteId", "9"]);
    var d=document, g=d.createElement("script"), s=d.getElementsByTagName("script")[0]; g.type="text/javascript";
    g.defer=true; g.async=true; g.src=u+"piwik.js"; s.parentNode.insertBefore(g,s);
  })();
</script>-->
<!-- End Piwik Code -->

<noscript>
<!-- Piwik Image Tracker -->
<img src="http://davidak.de/stats/piwik.php?idsite=9&amp;rec=1" style="border:0" alt="" />
<!-- End Piwik -->
</noscript>

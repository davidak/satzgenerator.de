<div id="footer">
<p class="text-muted credit">Entwickelt 2013 von <a href="http://davidak.de/">davidak</a> mit <a href="http://python.org/">Python</a>, <a href="http://bottlepy.org/">Bottle</a>, <a href="http://jquery.com/">jQuery</a> und <a href="http://getbootstrap.com/">Bootstrap</a>. Die Sätze werden von <a href="http://pyzufall.readthedocs.org/de/latest/">PyZufall</a> generiert.</p><p class="text-muted credit text-right"><a href="http://davidak.de/impressum">Impressum</a></p>
</div>

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.1/js/bootstrap.min.js"></script>
<script src="style/jquery.fittext.js"></script>
<script src="style/Hyphenator.js"></script>

<script type="text/javascript">

$('.modal .checkbox input').change(function() {
    if ( $("#satz").html() ) {
      $("input[name='satz']").val($("#satz").html());
    } else {
      $("#checkbox-error").fadeIn();
      setTimeout(function() {
          $("#checkbox-error").fadeOut();
          $('.modal .checkbox input').prop('checked',false);
          $('.modal .checkbox input').prop("disabled", true);
        }, 4500);
    }
});

// Feedback-Formular abschicken
$(".modal form").submit(function() {

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
var pkBaseURL = (("https:" == document.location.protocol) ? "https://davidak.de/stats/" : "http://davidak.de/stats/");
document.write(unescape("%3Cscript src='" + pkBaseURL + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
</script><script type="text/javascript">
try {
var piwikTracker = Piwik.getTracker(pkBaseURL + "piwik.php", 9);
piwikTracker.trackPageView();
piwikTracker.enableLinkTracking();
} catch( err ) {}
</script><noscript><p><img src="http://davidak.de/stats/piwik.php?idsite=9" style="border:0" alt="" /></p></noscript>-->
<!-- End Piwik Tracking Code -->

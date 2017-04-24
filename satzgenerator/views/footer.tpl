<div id="footer">
<p class="text-muted credit">Entwickelt seit 2013 von <a href="http://davidak.de/">davidak</a> mit <a href="http://python.org/">Python</a>, <a href="http://bottlepy.org/">Bottle</a>, <a href="http://jquery.com/">jQuery</a> und <a href="http://getbootstrap.com/">Bootstrap</a>. Die Sätze werden von <a href="http://pyzufall.readthedocs.org/de/latest/">PyZufall</a> generiert.</p><p class="text-muted credit text-right"><a href="/impressum">Impressum</a></p>
</div>

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.1/js/bootstrap.min.js"></script>

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

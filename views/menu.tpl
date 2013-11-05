<!-- Menü -->
<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
  <!-- Brand and toggle get grouped for better mobile display -->
  <div class="navbar-header">
    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#mehr">
      <span class="sr-only">mehr</span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
    </button>
    <a class="navbar-brand" href="/">Satzgenerator</a>
  </div>

  <div class="collapse navbar-collapse" id="mehr">

 <ul class="nav navbar-nav navbar-left hidden-xs">
  	<li><a data-toggle="modal" data-target="#feedback" href="#">Feedback</a></li>
  </ul>

    <ul class="nav navbar-nav navbar-right">
     	<li><a href="/beste-bewertung">Beste Bewertung</a></li>
		<li><a href="/schlechte-bewertung">Schlechte Bewertung</a></li>
		<li><a href="/meiste-bewertung">Meiste Bewertung</a></li>
		<li><a href="/neue-saetze">Neue Sätze</a></li>
		<li class="visible-xs"><a href="http://davidak.de/impressum">Impressum</a></li> <!-- nur mobil, sonst Footer -->
    </ul>
  </div><!-- /.navbar-collapse -->
</nav>

<!-- Feedback-Formular -->
<div class="modal fade" id="feedback" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
<div class="modal-dialog">
<div class="modal-content">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
<h4 class="modal-title" id="myModalLabel">Feedback zum Satzgenerator geben</h4>
</div>
<div class="modal-body">
      
<form role="form">

<div class="radio">
  <label><input type="radio" id="1" name="art" value="Lob" checked>Lob</label>
</div>
<div class="radio">
  <label><input type="radio" id="2" name="art" value="Kritik">Kritik</label>
</div>
<div class="radio">
  <label><input type="radio" id="3" name="art" value="Fehler">Fehler melden</label>
</div>

<div class="checkbox">
  <label><input type="checkbox" name="current"> Es geht um den aktuellen Satz. (mitschicken)</label>
</div>
<input type="hidden" name="satz" value="">

<textarea id="name" name="text" class="form-control" rows="6"></textarea>
<br>
Bitte gib noch deinen Namen und eine gültige E-Mail-Adresse an.
<br><br>
<div class="row">
<div class="col-xs-6">
<input type="text" class="form-control" name="name" placeholder="Max Mustermann">
</div>
<div class="col-xs-6">
<input type="email" class="form-control" name="email" placeholder="name@beispiel.de">
</div>
</div>
</div>
<div class="modal-footer">
<div class="text-success pull-left">Nachricht erfolgreich verschickt.</div>
<div class="text-danger pull-left">Nachricht konnte nicht verschickt werden.</div>
<button id="feedback-btn" type="submit" class="btn btn-primary pull-right">Abschicken</button>
<div class="clearfix"></div>

</form>

</div>
</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
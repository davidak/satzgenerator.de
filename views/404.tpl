<!DOCTYPE html>
<html lang="de">
<head>
%include head titel=titel
</head>
<body>

<div id="wrap">

%include menu

<div class="container" style="text-align: center;">

<h1>404</h1>

<h2>{{text}}</h2>

<a id="satz_neu" class="btn btn-default btn-fehler-404" role="button" href="/neu"><i class="fa fa-refresh"></i> Neuer Satz</a>

</div> <!-- .container -->

</div> <!-- #wrap -->

%include footer

<script src="style/jquery.fittext.js"></script>

<script type="text/javascript">
$("h1").fitText(0.25);
$("h2").fitText(2);
</script>

</body>
</html>
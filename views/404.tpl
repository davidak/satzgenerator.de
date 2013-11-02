<!DOCTYPE html>
<html lang="de">
<head>
%include head titel=titel
</head>
<body>

<div id="wrap">

%include menu

<div id="content" class="container" style="text-align: center;">

<h1>404</h1>

<h2>{{text}}</h2>

<a id="satz_neu" class="btn btn-default" role="button" href="/"><i class="icon-refresh"></i> Neuer Satz</a>

</div> <!-- /content -->

</div> <!-- #wrap -->

%include footer

<script type="text/javascript">
  $("h1").fitText(0.25);
  $("h2").fitText(2);
</script>

</body>
</html>
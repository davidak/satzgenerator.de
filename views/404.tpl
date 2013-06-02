<!DOCTYPE html>
<html lang="de">
<head>
%include head titel=titel
<style type="text/css">
@media all {
  h1 { font-size: 350px; line-height: 300px; }
}

@media (max-width: 480px) {
  h1 { font-size: 160px; line-height: 120px; }
  h2 { font-size: 20px; line-height: 30px; }
}
</style>
</head>
<body>

%include menu

<div id="content" class="container-fluid" style="text-align: center;">

<h1>404</h1>

<h2>{{text}}</h2>

<a class="btn btn-inverse" href="/"><i class="icon-refresh icon-white"></i> Neuer Satz</a>

</div> <!-- /content -->

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

%include footer

</body>
</html>
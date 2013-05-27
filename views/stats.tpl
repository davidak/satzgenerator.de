<!DOCTYPE html>
<html lang="de">
<head>
%include head titel=titel
</head>
<body>

%include menu

<div id="content" class="container-fluid">

<h3>{{get('titel')}}</h3><br>

%i = 0
%for satz in satze:
  %i += 1
    
    <blockquote>
      <h4>{{i}}. <a href="/{{satz.uid}}">{{satz.satz}}</a></h4>
      <i class="icon-thumbs-up"></i> {{str(satz.pro)}} 
      <i class="icon-thumbs-down"></i> {{str(satz.kontra)}}
    </blockquote>
%end

</div> <!-- /content -->

%include footer

</body>
</html>
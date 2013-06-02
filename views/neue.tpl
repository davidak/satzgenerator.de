<!DOCTYPE html>
<html lang="de">
<head>
%include head titel='Satzgenerator: ' + titel
</head>
<body>

%include menu

<div id="content" class="container-fluid">

<h2>{{get('titel')}}</h2>

%i = 0
%for satz in satze:
  %i += 1
  % datum = satz.created.strftime('%d.%m.%Y')
  % zeit = satz.created.strftime('%H:%M:%S')
    
    <blockquote>
      <h3>{{i}}. <a href="/{{satz.uid}}">{{satz.satz}}</a></h3>
      <i class="icon-calendar"></i> {{datum}}
      <i class="icon-time"></i> {{zeit}}
      <i class="icon-thumbs-up"></i> {{str(satz.pro)}}
      <i class="icon-thumbs-down"></i> {{str(satz.kontra)}}
    </blockquote>
%end

</div> <!-- /content -->

%include footer

</body>
</html>
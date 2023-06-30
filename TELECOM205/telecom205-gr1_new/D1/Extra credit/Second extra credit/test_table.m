for ii = 0:5;
  display(['Je suis au début de la boucle ', num2str(ii)]);
  if(ii==3)
    display('Je suis DANS LE IF');
    break;
  endif;
  display(['Je suis à la fin de la boucle ', num2str(ii)]);
endfor
display('Fini.');
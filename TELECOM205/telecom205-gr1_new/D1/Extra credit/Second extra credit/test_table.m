for ii = 0:5;
  display(['Je suis au d�but de la boucle ', num2str(ii)]);
  if(ii==3)
    display('Je suis DANS LE IF');
    break;
  endif;
  display(['Je suis � la fin de la boucle ', num2str(ii)]);
endfor
display('Fini.');
clear all;


%% mode = ['40k', '400k', '4M', '40M']
%% rx = ['zf', 'dfe']

nb_of_average = 10;
averaging = zeros(1, nb_of_average);

figure(1)
subplot(2,2,1)
[K, rej] = d4_perfs('40k', 'zf')
plot(K,rej,'r--');
grid
title('40k ZF)')

subplot(2,2,2)
[K, rej] = d4_perfs('400k', 'zf')
plot(K,rej,'r--');
grid
title('400k ZF')

subplot(2,2,3)
[K, rej] = d4_perfs('4M', 'zf')
plot(K,rej,'r--');
grid
title('4M ZF')

subplot(2,2,4)
[K, rej] = d4_perfs('40M', 'zf')
plot(K,rej,'r--');
grid
title('40M ZF')

%%

figure(2)
subplot(2,2,1)
[K, rej] = d4_perfs('40k', 'dfe')
plot(K,rej,'r--');
grid
title('40k DFE)')

subplot(2,2,2)
[K, rej] = d4_perfs('400k', 'dfe')
plot(K,rej,'r--');
grid
title('400k DFE')

subplot(2,2,3)
[K, rej] = d4_perfs('4M', 'dfe')
plot(K,rej,'r--');
grid
title('4M DFE')

subplot(2,2,4)
[K, rej] = d4_perfs('40M', 'dfe')
plot(K,rej,'r--');
grid
title('40M DFE')
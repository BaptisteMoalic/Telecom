clear all;

N = 100;
bits = [zeros(1, N/2), ones(1, 20), zeros(1, N/2)];

after_fiber = fiber_model_new(bits, 10e9, 100);

figure(1)
plot(bits)
hold on;
plot(after_fiber)
legend('Original pulse', 'Pulse after the fiber');
grid on;
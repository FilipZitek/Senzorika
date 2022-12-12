function [fitresult, gof] = createFit(ttsec, signal)
%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( ttsec, signal );

% Set up fittype and options.
ft = fittype( 'exp(-b.*((w)./(sqrt(1-(b.^2)))).*t).*A.*sin((w).*t+p)', 'independent', 't', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf 0 -7 0];
opts.StartPoint = [0.381558457093008 0.254282178971531 0.814284826068816 0.929263623187228];
opts.Upper = [Inf Inf 7 Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'Fitting curve' );
h = plot( fitresult, xData, yData );
% legend( h, 'gg vs. ttsec', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Time [s]', 'Interpreter', 'none' );
ylabel( 'AngularVelocity [rad/s]', 'Interpreter', 'none' );
title('Fitting curve');
legend('Data', 'Fitted curve');
grid on



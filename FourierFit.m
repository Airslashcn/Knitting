function [fitresult, gof] = FourierFit(tcq, scq,plotflag,ws)
[xData, yData] = prepareCurveData( tcq, scq );

% Set up fittype and options.
ft = fittype( 'a*sin(w*x+b)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [1 0.6 ws];
opts.lower = [0.7 -inf ws*0.8];
opts.Upper = [1.5 Inf  ws*1.2];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );


if (plotflag)
% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 's vs. t', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 't', 'Interpreter', 'none' );
ylabel( 's', 'Interpreter', 'none' );
grid on
end

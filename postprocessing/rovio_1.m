

% import results of different rovio sessions
rovio05 = importdata('./log/euroc_lucas_equidistant_5features/SAVE');
rovio15 = importdata('./log/euroc_lucas_equidistant_15features/SAVE');
rovio25 = importdata('./log/euroc_lucas_equidistant_25features/SAVE');
rovio30 = importdata('./log/euroc_lucas_equidistant_30features/SAVE');
rovio40 = importdata('./log/euroc_lucas_equidistant_40features/SAVE');


x = [5 15 25 30 40];
cpu_min = [19 26 33 40 60];
cpu_max = [27 33 45 60 95];
ate_mean = [0.35 0.217 0.258 0.163 0.25];
ate_std = [0.153 0.13 0.11 0.08 0.101];

%plotyy(x,ate_mean,x,(cpu_min+cpu_min)/2)


plot(rovio30(:,1),rovio30(:,4))
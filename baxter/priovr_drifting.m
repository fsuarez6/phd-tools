% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;
% Get the files that include the pattern
home_dir = getuserdir();
dropbox_space = [home_dir '/Dropbox/doctorado/baxter/benchmark/'];
home_space = [home_dir '/benchmark/'];
if exist(dropbox_space, 'dir') == 7
  data_folder = dropbox_space;
elseif exist(home_space, 'dir') == 7
  data_folder = home_space;
else
  error('benchmark folder not found')
end
% Plots configuration
ColorSet = distinguishable_colors(3);
set(0,'DefaultAxesColorOrder', ColorSet);
set(0,'defaulttextinterpreter','latex');
bar_width = 0.4;
sensors = {'chest','r_upper_arm','r_lower_arm','r_hand'};
xyz_names = {'X','Y','Z'};
filename = 'priovr_drift-2014-09-16-16-07-18.mat';
load([data_folder filename]);
time = time - min(time);
data_points = length(time);
rpy_chest = zeros(data_points, 3);
rpy_upper = zeros(data_points, 3);
rpy_lower = zeros(data_points, 3);
rpy_hand = zeros(data_points, 3);
for i = 1:data_points
  q_chest = Quaternion([chest(i,4) chest(i,1) chest(i,2) chest(i,3)]);
  q_upper = Quaternion([r_upper_arm(i,4) r_upper_arm(i,1) r_upper_arm(i,2) r_upper_arm(i,3)]);
  q_lower = Quaternion([r_lower_arm(i,4) r_lower_arm(i,1) r_lower_arm(i,2) r_lower_arm(i,3)]);
  q_hand = Quaternion([r_hand(i,4) r_hand(i,1) r_hand(i,2) r_hand(i,3)]);
  rpy_chest(i,:) = tr2rpy(q_chest.R);
  rpy_upper(i,:) = tr2rpy(q_upper.R);
  rpy_lower(i,:) = tr2rpy(q_lower.R);
  rpy_hand(i,:) = tr2rpy(q_hand.R);
end
x_limits = [0 600];
y_limits = [-0.25 0.25];
x_dyn = [0 180];
x_sta = [180 600];
y_ticks = [-0.5:0.1:0.5];
decimation = 10;
height = '45mm';
width = '55mm';
extra_opts = {'tick label style={font=\scriptsize}', 'label style={font=\small}', 'legend style={font=\small}'};
legend_names = {'roll', 'pitch', 'yaw'};

tikz_folder = [getuserdir() '/git/phd-thesis/tikz/'];

close all;
figure, hold on, grid on; box on;
plot(time(1:decimation:end), rpy_chest(1:decimation:end, 1), ':b');
plot(time(1:decimation:end), rpy_chest(1:decimation:end, 2), '-r');
plot(time(1:decimation:end), rpy_chest(1:decimation:end, 3), '--g');
legend(legend_names);
fill([x_dyn(1) x_dyn(1) x_dyn(2) x_dyn(2)], [fliplr(y_limits) y_limits], 'k', 'EdgeColor','None', 'FaceAlpha', 0.2);
idx = find(time >= 200 & time <= 600);
y_change = [min(rpy_chest(idx,2)) max(rpy_chest(idx,2))];
fill([x_sta(1) x_sta(1) x_sta(2) x_sta(2)], [fliplr(y_change) y_change], 'b', 'EdgeColor','None', 'FaceAlpha', 0.2);
text(x_sta(1)-10, y_change(2)+0.012,['\small{ Range: ' num2str(diff(y_change), '%.3f') ' rad.}']);
xlim(x_limits);
ylim(y_limits);
set(gca,'YTick',y_ticks);
ylabel('Drifting [rad]');
xlabel('Time [s]');
matlab2tikz([tikz_folder 'bax_drift_chest.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',extra_opts);

figure, hold on, grid on; box on;
plot(time(1:decimation:end), rpy_upper(1:decimation:end, 1), ':b');
plot(time(1:decimation:end), rpy_upper(1:decimation:end, 2), '-r');
plot(time(1:decimation:end), rpy_upper(1:decimation:end, 3), '--g');
legend(legend_names);
fill([x_dyn(1) x_dyn(1) x_dyn(2) x_dyn(2)], [fliplr(y_limits) y_limits], 'k', 'EdgeColor','None', 'FaceAlpha', 0.2);
idx = find(time >= 200 & time <= 600);
y_change = [min(rpy_upper(idx,2)) max(rpy_upper(idx,2))];
fill([x_sta(1) x_sta(1) x_sta(2) x_sta(2)], [fliplr(y_change) y_change], 'b', 'EdgeColor','None', 'FaceAlpha', 0.2);
text(x_sta(1)-10, y_change(2)+0.012,['\small{ Range: ' num2str(diff(y_change), '%.3f') ' rad.}']);
xlim(x_limits);
ylim(y_limits);
set(gca,'YTick',y_ticks);
xlabel('Time [s]');
set(gca, 'YTickLabel', [])
matlab2tikz([tikz_folder 'bax_drift_upper.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',extra_opts);

figure, hold on, grid on; box on;
plot(time(1:decimation:end), rpy_lower(1:decimation:end, 1), ':b');
plot(time(1:decimation:end), rpy_lower(1:decimation:end, 2), '-r');
plot(time(1:decimation:end), rpy_lower(1:decimation:end, 3), '--g');
legend(legend_names);
fill([x_dyn(1) x_dyn(1) x_dyn(2) x_dyn(2)], [fliplr(y_limits) y_limits], 'k', 'EdgeColor','None', 'FaceAlpha', 0.2);
idx = find(time >= 200 & time <= 600);
y_change = [min(rpy_lower(idx,2)) max(rpy_lower(idx,2))];
fill([x_sta(1) x_sta(1) x_sta(2) x_sta(2)], [fliplr(y_change) y_change], 'b', 'EdgeColor','None', 'FaceAlpha', 0.2);
text(x_sta(1)-10, y_change(2)+0.012,['\small{ Range: ' num2str(diff(y_change), '%.3f') ' rad.}']);
xlim(x_limits);
ylim(y_limits);
set(gca,'YTick',y_ticks);
ylabel('Drifting [rad]');
xlabel('Time [s]');
matlab2tikz([tikz_folder 'bax_drift_lower.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',extra_opts);
        
figure, hold on, grid on; box on;
plot(time(1:decimation:end), rpy_hand(1:decimation:end, 1), ':b');
plot(time(1:decimation:end), rpy_hand(1:decimation:end, 2), '-r');
plot(time(1:decimation:end), rpy_hand(1:decimation:end, 3), '--g');
legend(legend_names);
fill([x_dyn(1) x_dyn(1) x_dyn(2) x_dyn(2)], [fliplr(y_limits) y_limits], 'k', 'EdgeColor','None', 'FaceAlpha', 0.2);
idx = find(time >= 200 & time <= 600);
y_change = [min(rpy_hand(idx,2)) max(rpy_hand(idx,2))];
fill([x_sta(1) x_sta(1) x_sta(2) x_sta(2)], [fliplr(y_change) y_change], 'b', 'EdgeColor','None', 'FaceAlpha', 0.2);
text(x_sta(1)-10, y_change(2)+0.012,['\small{ Range: ' num2str(diff(y_change), '%.3f') ' rad.}']);
xlim(x_limits);
ylim(y_limits);
set(gca,'YTick',y_ticks);
xlabel('Time [s]');
set(gca, 'YTickLabel', [])
matlab2tikz([tikz_folder 'bax_drift_hand.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',extra_opts);

tilefigs;
close all;

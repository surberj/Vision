%% Main Postprocessing routine
% Oktober 2015
% author: Julian Surber, ETH Zurich

% This file loads data from a csv file of a ros session to analyse the
% performance of a SLAM algorithm like ROVIO, PTAM, OKVIS, ...
%
% The csv file must provide a header row describing the different signals
% 
% The following signals must be provided by the csv file
%       timestamp
%       

% add subfolders to matlab path
clear all
close all
clc
file=which('main.m');
[scriptPath] = fileparts(file);
cd(scriptPath);
addpath(genpath(scriptPath))

% load data
filename = uigetfile('*.csv','Select the .csv file containing ground_truth pose');
ground_truth = readtable(filename);
filename = uigetfile('*.csv','Select the .csv file containing the rovio estimated pose');
rovio = readtable(filename);

%% convert and time-align
ground_truth_first = (ground_truth.rosbagTimestamp(1) < rovio.rosbagTimestamp(1));

if ground_truth_first
    ind_start = find(ground_truth.rosbagTimestamp>=rovio.rosbagTimestamp(1),1,'first');
    ind_end = find(ground_truth.rosbagTimestamp>=rovio.rosbagTimestamp(end),1,'first');
    if ind_end == []
        ind_end = length(ground_truth.rosbagTimestamp);
    end
end

%% quaternion to euler convertion
% ground_truth
gt_q = [ground_truth.x_1, ground_truth.y_1, ground_truth.z_1, ground_truth.w];
[gt_r1,gt_r2,gt_r3] = quat2angle(gt_q);

% rovio
ro_q = [rovio.x_1, rovio.y_1, rovio.z_1, rovio.w];
[ro_r1,ro_r2,ro_r3] = quat2angle(ro_q);

%% plot
time_gt = ground_truth.rosbagTimestamp;
time_ro = rovio.rosbagTimestamp;
%
% init figure
scrsz = get(groot,'ScreenSize');
figure('Name','Rovio analysis','NumberTitle','off', ...
    'Position',[1 1 scrsz(3) scrsz(4)]);
% 
ha(1) = subplot(321);
plot(time_gt,ground_truth.x)
hold on
plot(time_ro,-rovio.x)
title('x tracking','FontSize',12)
h_legend = legend('ground truth', '- rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[m]','FontSize',12)
grid on

ha(2) = subplot(323);
plot(time_gt,ground_truth.y)
hold on
plot(time_ro,-rovio.y)
title('y tracking','FontSize',12)
h_legend = legend('ground truth', '- rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[m]','FontSize',12)
grid on

ha(3) = subplot(325);
plot(time_gt,ground_truth.z)
hold on
plot(time_ro,rovio.z)
title('z tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[m]','FontSize',12)
grid on

ha(4) = subplot(322);
plot(time_gt,gt_r1)
hold on
plot(time_ro,ro_r1)
title('euler r1 tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[rad]','FontSize',12)
grid on

ha(4) = subplot(324);
plot(time_gt,gt_r2)
hold on
plot(time_ro,ro_r2)
title('euler r2 tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[rad]','FontSize',12)
grid on

ha(4) = subplot(326);
plot(time_gt,gt_r3)
hold on
plot(time_ro,ro_r3)
title('euler r3 tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[rad]','FontSize',12)
grid on


linkaxes(ha,'x')

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

% convert and time-align

%% quaternion to euler convertion
% ground_truth
gt_q = [ground_truth.x_1, ground_truth.y_1, ground_truth.z_1, ground_truth.w];
[gt_r1,gt_r2,gt_r3] = quat2angle(gt_q);

% rovio
ro_q = [rovio.x_1, rovio.y_1, rovio.z_1, rovio.w];
[ro_r1,ro_r2,ro_r3] = quat2angle(ro_q);

% % ground_truth
gt_q = [ground_truth.x_1, ground_truth.y_1, ground_truth.z_1, ground_truth.w];
R_vb = quat2dcm(gt_q(1,:)); % index v for vicon, b for body
r_vicon = [ground_truth.x,ground_truth.y,ground_truth.z];

% rovio
ro_q = [rovio.x_1, rovio.y_1, rovio.z_1, rovio.w];
R_rb = quat2dcm(ro_q(1,:)); % index r for rovio
r_rovio = [rovio.x,rovio.y,rovio.z];

% rovio wrt vicon
R_vr = R_vb*R_rb';

% describe all signals wrt vicon frame
% rovio: position:    r_rovio_in_vicon = R_vr * r_rovio
%        orientation: ang_rovio_in_vicon = dcm3angle(R_vr * R_rb)
% vicon: position:    r_vicon
%        orientation: ang_vicon = dcm3angle(R_vb)

r_rovio_in_vicon = zeros(length(r_rovio),3);
ang_rovio_in_vicon = zeros(length(r_rovio),3);
for i=1:length(r_rovio)
    r_rovio_in_vicon(i,:) = R_vr*r_rovio(i,:)';
    ang_rovio_in_vicon(i,:) = dcm2angle(R_vr*quat2dcm(ro_q(i,:)));
end

ang_vicon = zeros(length(r_vicon),3);
[ang_vicon(:,1),ang_vicon(:,2),ang_vicon(:,3)] = quat2angle(gt_q);

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
plot(time_gt,r_vicon(:,1))
hold on
plot(time_ro,r_rovio_in_vicon(:,1))
title('x tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[m]','FontSize',12)
grid on

ha(2) = subplot(323);
plot(time_gt,r_vicon(:,2))
hold on
plot(time_ro,r_rovio_in_vicon(:,2))
title('y tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[m]','FontSize',12)
grid on

ha(3) = subplot(325);
plot(time_gt,r_vicon(:,3))
hold on
plot(time_ro,r_rovio_in_vicon(:,3))
title('z tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[m]','FontSize',12)
grid on

ha(4) = subplot(322);
plot(time_gt,ang_vicon(:,1))
hold on
plot(time_ro,ang_rovio_in_vicon(:,1))
title('euler r1 tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[rad]','FontSize',12)
grid on

ha(4) = subplot(324);
plot(time_gt,ang_vicon(:,2))
hold on
plot(time_ro,ang_rovio_in_vicon(:,2))
title('euler r2 tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[rad]','FontSize',12)
grid on

ha(4) = subplot(326);
plot(time_gt,ang_vicon(:,3))
hold on
plot(time_ro,ang_rovio_in_vicon(:,3))
title('euler r3 tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[rad]','FontSize',12)
grid on


linkaxes(ha,'x')

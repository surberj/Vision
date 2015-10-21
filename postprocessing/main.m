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
quat_vicon = [ground_truth.x_1, ground_truth.y_1, ground_truth.z_1, ground_truth.w];
r_vicon = [ground_truth.x,ground_truth.y,ground_truth.z];

% rovio
quat_rovio = [rovio.x_1, rovio.y_1, rovio.z_1, rovio.w];
r_rovio = [rovio.x,rovio.y,rovio.z];

% time vectors
time_vicon = ground_truth.rosbagTimestamp;
time_rovio = rovio.rosbagTimestamp;

% rotation matrix between rovio and vicon
if time_vicon(1) < time_rovio(1)
    ind_align_vicon = find(time_vicon >= time_rovio(1),1);
    ind_align_rovio = 1;
else
    ind_align_vicon = 1;
    ind_align_rovio = find(time_rovio >= time_vicon(1),1);
end

R_vb = quat2dcm(quat_vicon(ind_align_vicon,:));
R_rb = quat2dcm(quat_rovio(ind_align_rovio,:));
r_vb_in_v = r_vicon(ind_align_vicon,:)';
r_rb_in_r = r_rovio(ind_align_rovio,:)';

% constant rotation and translation between vicon and rovio frame
R_vr = R_vb*R_rb';
r_vr_in_v = r_vb_in_v - R_vr*r_rb_in_r;

% check
if norm(r_vr_in_v + R_vr*r_rb_in_r - r_vb_in_v) > 0.01
    print('there seems to be something wrong with the rotations')
end

% describe all signals wrt vicon frame
% rovio: position:    r_vb_in_vicon_rovio = r_vr_in_vicon + R_vr * r_rb_in_rovio
%        orientation: ang_vb_in_vicon_rovio = dcm2angle(R_vr * R_rb)
% vicon: position:    r_vb_in_vicon_vicon = r_vicon
%        orientation: ang_vb_in_vicon_vicon = dcm3angle(R_vb)

r_vb_in_vicon_rovio = zeros(length(r_rovio),3);
ang_vb_in_vicon_rovio = zeros(length(r_rovio),3);
for i=1:length(r_rovio)
    r_vb_in_vicon_rovio(i,:) = r_vr_in_v + R_vr*r_rovio(i,:)';
    R_rb_tmp = quat2dcm(quat_rovio(i,:));
    ang_vb_in_vicon_rovio(i,:) = dcm2angle(R_vr*R_rb_tmp);
end

r_vb_in_vicon_vicon = r_vicon;
ang_vb_in_vicon_vicon = zeros(length(r_vicon),3);
[ang_vb_in_vicon_vicon(:,1),ang_vb_in_vicon_vicon(:,2),ang_vb_in_vicon_vicon(:,3)] = quat2angle(quat_vicon);

%% plot
%
% init figure
scrsz = get(groot,'ScreenSize');
figure('Name','Rovio analysis','NumberTitle','off', ...
    'Position',[1 1 scrsz(3) scrsz(4)]);
% 
ha(1) = subplot(321);
plot(time_vicon,r_vb_in_vicon_vicon(:,1))
hold on
plot(time_rovio,r_vb_in_vicon_rovio(:,1))
title('x tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[m]','FontSize',12)
grid on

ha(2) = subplot(323);
plot(time_vicon,r_vb_in_vicon_vicon(:,2))
hold on
plot(time_rovio,r_vb_in_vicon_rovio(:,2))
title('y tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[m]','FontSize',12)
grid on

ha(3) = subplot(325);
plot(time_vicon,r_vb_in_vicon_vicon(:,3))
hold on
plot(time_rovio,r_vb_in_vicon_rovio(:,3))
title('z tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[m]','FontSize',12)
grid on

ha(4) = subplot(322);
plot(time_vicon,ang_vb_in_vicon_vicon(:,1))
hold on
plot(time_rovio,ang_vb_in_vicon_rovio(:,1))
title('euler r1 tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[rad]','FontSize',12)
grid on

ha(4) = subplot(324);
plot(time_vicon,ang_vb_in_vicon_vicon(:,2))
hold on
plot(time_rovio,ang_vb_in_vicon_rovio(:,2))
title('euler r2 tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[rad]','FontSize',12)
grid on

ha(4) = subplot(326);
plot(time_vicon,ang_vb_in_vicon_vicon(:,3))
hold on
plot(time_rovio,ang_vb_in_vicon_rovio(:,3))
title('euler r3 tracking','FontSize',12)
h_legend = legend('ground truth', 'rovio');
set(h_legend,'FontSize',8)
xlabel('[s]','FontSize',12)
ylabel('[rad]','FontSize',12)
grid on


linkaxes(ha,'x')

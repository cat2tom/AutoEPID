% This script will generate the pseudo data files defined within. Make
% modifications as needed

% if debug is true then this script will imshow the dose arrays generated.
debug = false;

debug=true;
%% Set the output params
% The directory structure will be composed of these values to match the
% structure expected by AutoEPID

outputPath = 'U:\Patient_QA'; % Set this to the appropriate folder to output to.
%outputPath = 'U:\Patient_QA'; % To create directly in Patient_QA dir

patientID = '0000001';
patientName = 'PSEUDO_1';
% Directory name will be 'outputPath\patientID_patientName'

%% Generate dose
% This section shows some examples showing how to generate dose arrays

% Export a 1024 x 1024 HIS file with a cone shape in the centre. The
% dose is at 2 gray and is increased by 20% to the centre of the cone.
width = 1024;
height = 1024;

minDose = 200;
radius = 300;

%minDose=2.0/8.2004e-05;
doseConeLinear = generatePseudoDose(width, height, minDose, minDose * 1.2, ...
    'shape', 'cone', ...
    'radius', radius, ...
    'interpolation', 'linear',...
    'center', [width/2, height/2]);

% if debug
%     figure;
%     imshow(doseConeLinear, []);
%     title([num2str(width) 'x' num2str(height) ' cone, linear interpolation']);
% end

% Same as above but make the cone have discrete layers rather than linearly
% interpolated. Also shift the cone to the top left.
doseConeDiscrete = generatePseudoDose(width, height, minDose, minDose * 1.2, ...
    'shape', 'cone', ...
    'radius', radius, ...
    'interpolation', 'discrete',...
    'levels',8,...
    'center', [514, 514]);

if debug
    figure;
    imshow(doseConeDiscrete, []);
    title([num2str(width) 'x' num2str(height) ' cone, discrete interpolation']);
end
% Next, write a 230x170 Pinnacle dose file, with 2 gray and a rectangle
% with 2 + 20% in it.
width = 230;
height = 170;
minDose = 2;
rectWidth = 150;
rectHeight = 100;
doseRect = generatePseudoDose(width, height, minDose, minDose * 1.2, ...
    'shape', 'rectangle', ...
    'rectWidth', rectWidth, ...
    'rectHeight', rectHeight, ...
    'center', [width/2, height/2]);
if debug
    figure;
    imshow(doseRect, []);
    title([num2str(width) 'x' num2str(height) ' rectangle']);
end

%% Save Data
% The function saveData takes one dose array as the EPID dose and one as
% the TPS dose. These are then saved in the given outputPath with the
% correct folder structure and file naming convention
epidDose = doseConeDiscrete;
tpsDose = doseRect;
saveData(outputPath, patientID, patientName, epidDose, tpsDose);

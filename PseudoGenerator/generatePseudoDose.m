function dose = generatePseudoDose(width, height, minDose, varargin)
%GENERATEPSEUDODOSE Returns a pseudo 2d dose plane with the given params
%   w: width of the dose plane
%   h: heght of the dose plane
%   minDose: the minimum dose
%   maxDose: the maximum dose
%   shape: how to shape the dose, 'cone' or 'rect'
%   radius: radius of the cone
%   interpolation: 'linear' or 'discrete' (for cone)
%   levels: How many discrete levels to use (for discrete cone)
%   center: center postion of the shape
%   rectWidth: width of the rectangle
%   rectHeight: height of the rectangle
%
%   Cone must have radius and center set, rectangle must have rectWidth,
%   rectHeight and center set.
%

expectedShapes = {'cone','rectangle'};

p = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(p,'width',validScalarPosNum);
addRequired(p,'height',validScalarPosNum);
addRequired(p,'minDose',validScalarPosNum);
addOptional(p,'maxDose',minDose, validScalarPosNum);
addParameter(p,'shape', '', @(x) any(validatestring(x,expectedShapes)));
addParameter(p,'radius',width*0.3);
addParameter(p,'interpolation','linear');
addParameter(p,'levels',10);
addParameter(p,'center',[width height] / 2);
addParameter(p,'rectWidth',width*0.3);
addParameter(p,'rectHeight',height*0.3);
parse(p,width, height, minDose, varargin{:});

w = p.Results.width;
h = p.Results.height;
minDose = p.Results.minDose;
maxDose = p.Results.maxDose;

dose = ones(h,w) * minDose;

if strcmp(p.Results.shape,'cone')
    c = p.Results.center;
    r = p.Results.radius;
    doseDiff = maxDose - minDose;
    
    BW = zeros(h,w);
    BW(c(2), c(1)) = 1;
    dists = double(bwdist(BW));
    
    if strcmp(p.Results.interpolation,'discrete')
        
        discreteStep = doseDiff/p.Results.levels;
        discreteBins = (minDose + discreteStep/2):discreteStep:maxDose - discreteStep/2;
        discreteValues = (minDose + discreteStep):discreteStep:maxDose;
    
        [~, inds] = arrayfun(@(x) min(abs(x-discreteBins)),minDose + abs(dists(dists<=r)/r-1) * doseDiff);
        dose(dists<=r) = arrayfun(@(x) discreteValues(x), inds);
    else
        dose(dists<=r) = minDose + abs(dists(dists<=r)/r-1) * doseDiff;
    end
end

if strcmp(p.Results.shape,'rectangle')
    cx = p.Results.center(1);
    cy = p.Results.center(2);
    
    xFrom = floor(cx - (p.Results.rectWidth/2) + 0.5);
    xFrom = max(1,xFrom);
    xTo = floor(cx + (p.Results.rectWidth/2) - 0.5);
    xTo = min(w,xTo);
    
    yFrom = floor(cy - (p.Results.rectHeight/2) + 0.5);
    yFrom = max(1,yFrom);
    yTo = floor(cy + (p.Results.rectHeight/2) - 0.5);
    yTo = min(h,yTo);
    
    dose(yFrom:yTo,xFrom:xTo) = maxDose;
end

dose=int16(dose);
end


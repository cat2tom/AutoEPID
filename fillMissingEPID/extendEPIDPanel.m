function [Ex,Ey,extended_epiddose]= extendEPIDPanel(tps_file,epiddose )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

tps_file_in=tps_file;


[Ex,Ey,extended_epiddose]=fillEPIDMissingPixel(tps_file_in,epiddose);




end


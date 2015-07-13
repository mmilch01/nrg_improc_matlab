function [] = test (root, varargin)
p=inputParser;
%input image root name.
p.addRequired('root',@ischar);
%ROI coordinate file name.
p.addParamValue('coords',[],@ischar);
%output image root name (default is <root>_full_<method>)
p.addParamValue('outroot',[],@ischar); 
%exclusion mask image file name
p.addParamValue('exmask',[],@ischar);
%masking method, normfilter is default.
p.addParamValue('method','normfilter',@(x)strcmpi(x,'blur') | strcmpi(x,'normfilter') | strcmpi(x,'coating'));
%object-background intensity threshold, -1 for auto threshold.
p.addParamValue('thresh',-1,@(x)isnumeric(x));
%mesh step factor, 1 is default, smaller/bigger will result in less/more
%defacing
p.addParamValue('grain',1,@(x)isnumeric(x) && (x>=.3 && x<=3));
%output more or less intermediate files. 0 - fewer (default, faster), 3 - most
%(slowest)
p.addParamValue('optimization',0,@(x)isnumeric(x) && (x==0 || x==1 || x==2 || x==3));
%pre-calculated head mask image can be supplied. 
p.addParamValue('head_mask',[],@ischar);
% all of pmin,pmax,vertical, must be either defined or undefined
% simultaneously.
%outer 3D ROI pinnacle, furthest from the face surface
p.addParamValue('p_out',[],@(x)isnumeric(x));
%inner 3D ROI pinnacle, closest to the face surface.
p.addParamValue('p_in',[],@(x)isnumeric(x)); 
%axis that is most normal to the face surface.
p.addParamValue('vertical',[],@(x)isnumeric(x) && (x==0 || x==1 || x==2));
%instead of vertical, specify a directed normal (e.g. [0 -1 0] would mean
%vertical=1 and inverse=1
p.addParamValue('normal',[],@(x)isnumeric(x)); 
%ROI label file name.
p.addParamValue('roi_label',[],@(x)ischar);

p.parse(root,varargin{:});
disp('Input arguments:');
p.Results
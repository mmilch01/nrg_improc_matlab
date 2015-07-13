function hOv = statmask(stats, thresh, cmap, clim, cbOpt, hAx)
% STATMASK  Overlay image with coloured statistical mask
%
% Overlays a mask of statistics on an image.  By default the 
%   currently displayed figure is overlain.
%
% First, the underlay is converted to RGB.  The statistical overlay
%   is upscaled if necessary (using nearest neighbour sampling) to
%   match the size of the underlay.  Then the RGB data is overlain
%   with the statmask, without rescaling of the stat values.  This
%   allows for inspection of mask values with the data cursor.
% 
% The function returns a handle to the overlay mask if requested.
%
% Notes: Requires freezeColors from the file exchange
%        Consider using getclim to help set your colormap limits
%
% Usage:
%   hOv = statmask(stats, [thresh, cmap, clim, cbOpt, hAx])
%
%     stats: matrix representing mask values
%    thresh: scalar value of threshold for transparency (default 0)
%      cmap: colour-map to use.  default flipud(autumn(256))
%      clim: limits for color display of stats overlay (default min/max of stats)
%     cbOpt: colorbar display: 'on', 'onwest', or 'hidden', else off (default 'on')
%       hAx: handle to axes on which to operate (default current axes)
%
%       hOv: handle to overlay image is returned
%
% Example:
%   I = peaks(200);
%   bwMask = eye(25).*rand(25);
%   figure;
%   imshow(I, [], 'Colormap', bone(256), 'InitialMag', 200);
%   statmask(bwMask);
%
% See also IMSHOW, COLORBAR

% v0.3 (Jan 2013) by Andrew Davis (addavis@gmail.com)


%% Check arguments
%narginchk(1,6);
assert(ismatrix(stats), 'stats should be a matrix')
if ~exist('thresh', 'var') || isempty(thresh), thresh = 0; end
assert(isscalar(thresh), 'thresh should be a scalar')
if ~exist('cmap', 'var') || isempty(cmap), cmap = flipud(autumn(256)); end
assert(ismatrix(cmap) && size(cmap, 2) == 3, 'cmap should be an n x 3 colormap')
if ~exist('clim', 'var') || isempty(clim), clim = []; end
assert((ismatrix(clim) && all(size(clim) == [1, 2])) || isempty(clim), 'clim should be a 2 value row vector')
if ~exist('cbOpt', 'var') || isempty(cbOpt), cbOpt = 'on'; end
assert(isstr(cbOpt), 'cbOpt must be a string: on, onwest, off, or hidden')
if ~exist('hAx', 'var') || isempty(hAx), hAx = gca; end
assert(ishandle(hAx), 'hAx should be a handle to axes')
%assert(exist('freezeColors','file') == 2, 'you must download freezeColors from the file exchange')

%comment it out on the first use.
%upon subsequent uses, Matlab somehow initializes and "understands" this
%feature. 

%feature('usegenericopengl',1);
%
%% Convert underlay to RGB since we care less about its values
uCmap = colormap(hAx);                 % underlay colormap
N = size(uCmap,1);                     % number of colors
himages = imhandles(hAx);              % images in hAx
assert(~isempty(himages), 'No underlay image found')
uCData = get(himages(end), 'CData');   % underlay image data

if size(uCData, 3) == 1,
   % convert grayscale data to RGB and replot
   uX = round((double(uCData)-double(min(uCData(:))))./double(range(uCData(:))).*(N-1));
   uRGB = ind2rgb(uX, uCmap);
   imshow(uRGB, 'Parent', hAx, 'InitialMag', 'fit');
end

%% Check that sizes match, upscale stats using NN if necessary
targetSize = size(uCData(:,:,1));
assert(all(size(stats) <= targetSize), 'Underlay must be at least as large as stats')
if any(size(stats) < targetSize),
   warning('scaling up stats to match underlay')
   stats = imresize(stats, targetSize, 'nearest');
end


%% Overlay
hold on
hOv = imshow(stats, clim, 'Parent', hAx, 'InitialMag', 'fit', 'Border', 'loose', 'colormap', cmap);
set(hOv, 'AlphaData', thresh)


% colorbar
if strcmp(cbOpt, 'on') || strcmp(cbOpt, 'onwest') || strcmp(cbOpt, 'hidden'),
   climits = get(gca, 'CLim');
   caxis(climits);
   if strcmp(cbOpt, 'onwest'),
      hCB = colorbar('West');
   else
      hCB = colorbar;
   end
   set(get(hCB, 'Children'), 'YData', climits)  % set color limits appropriately
   set(hCB, 'YLim', climits)                    % set axis tick limits appropriately

   if strcmp(cbOpt, 'hidden'),
      set(hCB, 'Visible', 'off')
   end      
end
hold off

% only return handle if requested
if nargout < 1
   clear hOv;
end

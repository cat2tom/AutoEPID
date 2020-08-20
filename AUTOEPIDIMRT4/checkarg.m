function varargout = checkarg(argtocheck, argtype, varargin)
% General purpose function to check arguments are the correct type. The
% function checks that the specified argument has the correct type and the
% required dimensions.
%
% Syntax:
%
%   [argok errmsg] = checkarg(argtocheck, argumenttype, dimensions)
%
% Input Arguments:
%
%   *argtocheck: the variable that should be checked.
%
%   *argumenttype: A character array containing the desired type of
%   argument. This can be a matlab built-in variable type such as double,
%   uint16 or char or a Matlab class name or one of the following strings
%
%      **numeric: Any numeric data type is acceptable
%
%       **real: Any numeric data type is acceptable as long as there is no
%       imaginary component
%
%       **integer: Any integer data type is acceptable
%
%       **string: Any cell array of strings is acceptable.
%
%   * dimensions: This can either be a single numeric array containing the
%   desired size of the variable (ie. [5 3 2]) or a series of individual
%   arguments containing the size of a single dimension (ie. 5, 3, 2). In
%   either case, a value of NaN should be used if the actual size of the
%   dimension is not relvant. For example, if 2-dimensional argument is
%   required with any number of rows and 3 columns, either [NaN 3] or NaN,
%   3 could be specified as the dimensions. If the dimensions argument(s)
%   are not supplied at all, no dimension checking will be performed.
%
% Output Arguments:
%
%   * argok: This is a logical value containing true if the argument meets
%   the criteria and false otherwise.
%
%   * errmsg: This is a character array containing a description of the
%   validation problem that was found, if any.
%
% Notes:
%
% Maintainer(s)
%
% [[Brian King]]

% Check that argtype is a single character string
if (~ischar(argtype))
    error('Argument type can not be numeric');
end
if(size(argtype,1) ~= 1)
    error('Argument type must be a single string');
end
if nargin == 3
    % dimensions in single variable
    varargs = varargin{1};
    if ndims(varargs)>2
        error('Argument dimensions can not be multi-dimensional array');
    end
    if ~isnumeric(varargs)
        error('Non-numeric values passed as dimensions');
    end
    if size(varargs,1)>1
        error('Argument dimensions can not be an array');
    end
    
    varargsnan = uint32(~isnan(varargs));
    varargs = uint32(varargs) .* varargsnan;
end
% Put varargin into an integer array (instead of cell array)
% This will round non-integer data types to the nearest integer
% varargsnan records which arguments were NaN (used to signify a dimension
% that can be any size ie. an nx1 vector)  This will be used as a mask when
% comparing to the argument dimensions later.  varargsnan will have zero in
% the places where NaN is present and 1 otherwise
if nargin > 3
    varargsnan = uint32(~isnan(cell2mat(varargin)));
    varargs = uint32(cell2mat(varargin)) .* varargsnan;

    % Check that each argument in varargin is a numeric scalar

    if(size(varargs, 1) ~= 1)
        error('Non-scalar variables passed as dimensions');
    end

end

% Check the type of the variable
argok = false;
argtypepassed = class(argtocheck);
errmsg = '';
if(strcmp(argtype,'numeric'))
    if(isnumeric(argtocheck))
        argok = true;
    else
        errmsg = ['numeric type required.  Supplied: ' argtypepassed];
    end
else
    if(strcmp(argtype,'real'))
        if(isreal(argtocheck))
            argok = true;
        else
            errmsg = 'real value required.';
        end
    else
        if(strcmp(argtype,'integer'))
            if(isinteger(argtocheck))
                argok = true;
            else
                errmsg = ['integer type required. Supplied: ' argtypepassed];
            end
        else
            if(strcmp(argtype,'string'))
                if(iscellstr(argtocheck))
                    argok = true;
                else
                    errmsg = ['string type required. Supplied: ' argtypepassed];
                end
            else
                %Default case - Match the argument to the specific type passed
                if(strcmp(argtypepassed,argtype))
                    argok = true;
                else
                    errmsg = [argtype ' type required. Supplied: ' argtypepassed];
                end
            end
        end
    end
end

% Check the dimensions of the variable
if(argok)
    if(nargin > 2)
        dimarg = uint32(size(argtocheck));
        if(size(dimarg,2) ~= size(varargs,2))
            argok = false;
            errmsg = 'Invalid dimension in argument';
        else
            dimarg = dimarg .* varargsnan;

            if(~isequal(varargs,dimarg))
                argok = false;
                errmsg = ['Dimensions required: ' mat2str(varargs) '. Supplied: ' mat2str(dimarg)];
            end
        end
    end
end

varargout{1} = argok;
if(nargout > 1)
    varargout{2} = errmsg;
end

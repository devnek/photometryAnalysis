function str = struct2str(structure)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

fieldNames = fields(structure)';
str = {};
for field = fieldNames
    fieldVal = structure.(field{1});
    if ischar(fieldVal)
        fieldStrVal = fieldVal;
    elseif isnumeric(fieldVal)
        fieldStrVal = num2str(fieldVal);
    end
    str{end+1} = sprintf('%s : %s',field{1},fieldStrVal); %#ok
end
end
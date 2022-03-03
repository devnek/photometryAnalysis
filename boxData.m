classdef boxData < handle
    %BOXDATA Summary of this class goes here
    %   Detailed explanation goes here

    properties
        epocs
        streams
        scalars
        info
        time_ranges
        dataPath
        baselineBox = box(signal = {'x405A','x465A','x560B'}, event = {'PC0_','PC2_','PC4_','PC6_'});
        box = box(signal = {'x405C','x465C','x560D'}, event = {'PC1_','PC3_','PC5_','PC7_'});
    end

    methods
        function obj = boxData(path)
            obj.dataPath = path;
        end

        function populate(obj)
            %POPULATE Summary of this method goes here
            %   Detailed explanation goes here
            data = TDTbin2mat.TDTbin2mat(obj.dataPath);
            obj.epocs       = data.epocs;
            obj.streams     = data.streams;
            obj.scalars     = data.scalars;
            obj.info        = data.info;
            obj.time_ranges = data.time_ranges;
        end

        function clear(obj)
            obj.epocs       = [];
            obj.streams     = [];
        end

        function [fig1, fig2] = plot(obj)
            obj.baselineBox.plot(obj);

            obj.box.plot(obj);

            fig1 = obj.baselineBox.fig;

            fig2 = obj.box.fig;
        end

        function tbl = table(obj)
            Field = string(fields(obj.info));

            Value = strings(length(Field),1);
            for i = 1:length(Field)
                fieldVal = obj.info.(Field(i));
                if ischar(fieldVal)
                    Value(i) = fieldVal;
                elseif isnumeric(fieldVal)
                    Value(i) = num2str(fieldVal);
                end
            end
            tbl = table(Field,Value);
        end

        %{
        function str = display(obj)
            %UNTITLED3 Summary of this function goes here
            %   Detailed explanation goes here

            fieldNames = fields(obj)';
            str = {};
            for field = fieldNames
                fieldVal = obj.(field{1});
                if ischar(fieldVal)
                    fieldStrVal = fieldVal;
                elseif isnumeric(fieldVal)
                    fieldStrVal = num2str(fieldVal);
                end
                str{end+1} = sprintf('%s : %s',field{1},fieldStrVal); %#ok
            end
        end
        %}
    end
end


classdef box < handle
    % BOX class was created in order to group the related signals and
    % events corresponding to each box.
    %
    
    properties
        signal cell {mustBeMember(signal,{'x405A','x465A','x560B','x405C','x465C','x560D'})}
        event cell {mustBeMember(event,{'Cam1','Cam2','PC4_','PC1_','PC5_','PC3_','PC0_','PC2_','PC6_','PC7_'})}
        fig
        plotActual
    end
    
    methods
        function obj = box(varargin)
            %BOX Construct an instance of this class
            %   Detailed explanation goes here
            p = inputParser;
            addParameter(p,'signal',{});
            addParameter(p,'event',{});
            parse(p,varargin{:});
            obj.signal =  p.Results.signal;
            obj.event =  p.Results.event;
            obj.plotActual = false;
        end
        
        
        function plot(obj,data)
            
            obj.fig = figure;
            
            startOffset = 20000;
            
            fs1 = data.streams.(obj.signal{1}).fs;
            fs2 = data.streams.(obj.signal{2}).fs;
            fs3 = data.streams.(obj.signal{3}).fs;
            assert(fs1 == fs2, [obj.signal{1} 'and ' obj.signal{2} ' are in different rate']);
            assert(fs1 == fs3, [obj.signal{1} 'and ' obj.signal{3} ' are in different rate']);
            
            x405 = data.streams.(obj.signal{1}).data;
            x465 = data.streams.(obj.signal{2}).data;
            x560 = data.streams.(obj.signal{3}).data;
            
            t0 = 1/fs1;
            time = t0:t0:t0*length(x405);
            
            [x465N1,x560N1] = getNormalizedSignal(x405,x465,x560);
            ax1 = subplot(3,1,1);
            customPlot(time(startOffset:end),x465N1(startOffset:end));
            legend('Normalized x465');
            if obj.plotActual
                hold on;
                plot(time(startOffset:end),x465(startOffset:end));
                legend('x465');
            end
            hold off;
            
            ax2 = subplot(3,1,2);
            customPlot(time(startOffset:end),x560N1(startOffset:end));
            legend('Normalized x560');
            if obj.plotActual
                hold on;
                customPlot(time(startOffset:end),x560(startOffset:end));
                legend('x560');
            end
            hold off;
            
            ax3 = subplot(3,1,3);
            
            hold on
            %box on;
            
            epocs = data.epocs;
            color = hsv(length(obj.event));
            for i = 1:length(obj.event)
                eventName = obj.event{i};
                len = length(epocs.(eventName).onset);
                plot([epocs.(eventName).onset epocs.(eventName).offset]', ones(2,len)*i, 'LineWidth', 9,'Color',color(i,:));
            end
            ylim([-1 length(obj.event) + 1]);
            hold off;
            set(ax3, 'YTick',1:length(obj.event), 'YTickLabel',obj.event);
            linkaxes([ax1,ax2],'x');
            linkaxes([ax1,ax3],'x');
            xlim([time(startOffset) time(end)])
            
        end
    end
end

function [x465N,x560N] = getNormalizedSignal(x405,x465,x560)
x465N = getNormalSignal(x405,x465);
x560N = getNormalSignal(x405,x560);
end

function dfByf = getNormalSignal(X,Y)
% Find relation between X control channel and Y signal channel
X1 = smooth(X);
Y1 = smooth(Y);
bls = polyfit(X1, Y1, 1);
Y_fit = bls(1).*X + bls(2);
% Delta F/F = (signal channel - Scaled control channel)/Scaled control channel
% dF/F =( F(t) - F0)/F0, F0 should be steady state value in Y_fit
dfByf = (Y - Y_fit(20000))/Y_fit(20000);
end


function customPlot(varargin)
plot(varargin{:});
xlabel( 'Time (Seconds)' );
ylabel('Normalized \Delta F/F');
grid on;
end


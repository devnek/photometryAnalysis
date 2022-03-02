function eventPlot(ax,epocs)
axes(ax)
f = fields(epocs);
events = setdiff(f, {'Cam1','Cam2'})';
hold on
%box on;

color = hsv(length(events));
for i = 1:length(events)
    event = events{i};
    len = length(epocs.(event).onset);
    plot([epocs.(event).onset epocs.(event).offset]', ones(2,len)*i, 'LineWidth', 10,'Color',color(i,:));
end
hold off;
box off;

% North = [datenum([2019 01 30]), datenum([2019 04 12]); datenum(2019,07,03) datenum(2019,08,25)];
% Central = [datenum(2019,01,08) datenum(2019,03,03)];
% figure
% plot(North', ones(2)*2, '-b', 'LineWidth', 5);
% hold on
% plot(Central, [1 1], '-r', 'LineWidth',5)
% hold off
% ylim([0 3])
% datetick('x', 'mmm')
set(ax, 'YTick',1:length(events), 'YTickLabel',events);

end
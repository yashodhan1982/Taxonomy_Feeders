function [] = set_figure_graphics(xlabels,my_name,yformat,my_leg,offset,leg_loc,pos_mod,legOffset,leg_orientation,plotHands,numCols)
    % This file formats the graphics to match in all files for the SGIG
    % analysis
    %
    % set_figure_graphics(xlabels,my_name,yformat,my_leg,offset,leg_loc,...
    %                 ...,pos_mod,legOffset,leg_orientation,plotHands,numCols)
    %
    % xlabels - an array of labels for the x-axis
    % my_name - name of the graphics file
    % yformat - 1-removes exponens, 2 set 2 decimal places, 3 sets 1
    %           decimal place
    % my_leg - lets you add a legend; set to 'none' to provide no legend
    % offset - moves the yaxis label to the left when the numbering on the
    %          yaxis is too large.
    % leg_loc - Location of the legend.
    % pos_mod - If set to 1, assumes the ylabel position is handled slightly different - defaults to 0
    % legOffset - offset to move the legend up - needed sometimes
    % leg_orientation - orientation of the legend ('horizontal' or 'vertical')
    % plotHands - handles to the various plots in a figure - needed for numCols to work
    % numCols - number of columns for a legend
    %
    %
    % started 5/1/2011 by J. Fuller
	% Updated 7/1/2011 by F. Tuffner
        
    %Set a default for pos_mod, if not used
    %Retains compatibility with other files
    if (nargin==6)
        pos_mod = 0;
        legOffset=0;
        leg_orientation=[];
        plotHands=[];
        numCols=1;
    elseif (nargin==7)
        legOffset=0;
        leg_orientation=[];
        plotHands=[];
        numCols=1;
    elseif (nargin==8)
        leg_orientation=[];
        plotHands=[];
        numCols=1;
    elseif (nargin==9)
        plotHands=[];
        numCols=1;
    elseif (nargin==10)
        numCols=1;
    end
    
    ca = gca;
    cf = gcf;

    % This rotates the x-axis labels and positions them correctly
    xticklabel_rotate(1:length(xlabels),90,xlabels);

    if (isempty(plotHands))
        if (~strcmp(char(my_leg(1,:)),'none'))
            if (isempty(leg_orientation))
                legHandle=legend(ca,my_leg,'location',leg_loc,'FontSize',10);
            else
                legHandle=legend(ca,my_leg,'location',leg_loc,'FontSize',10,'orientation',leg_orientation);
            end
            
            if (legOffset~=0)
                posLeg=(get(legHandle,'position')+[0 legOffset 0 0]);
                set(legHandle,'position',posLeg);
            end
        end
    else
        if (isempty(leg_orientation))
            legHandle=gridLegend(plotHands,numCols,my_leg,'FontSize',10,'location',leg_loc);
        else
            legHandle=gridLegend(plotHands,numCols,my_leg,'FontSize',10,'location',leg_loc,'orientation',leg_orientation);
        end
        if (legOffset~=0)
            posLeg=(get(legHandle,'position')+[0 legOffset 0 0]);
            set(legHandle,'position',posLeg);
        end
    end
    
    % turns on the y-grid lines
    set(ca,'XGrid','off','YGrid','on','ZGrid','off');
    
    % this manually moves the y-axis labels over a little so when saving to
    % a jpg, the text doesn't overlap the axis
    ylab = get(ca,'Ylabel');
    ylab_pos_orig = get(ylab,'position');
    
    if (pos_mod == 0)
        ylab_pos = ylab_pos_orig;
        set(ylab,'position',ylab_pos-offset); % Move the label when the format changes
    else %Must be 1 - modify this for TS plots - looks better for them
        ylab_pos = [ylab_pos_orig(1)-offset ylab_pos_orig(2) ylab_pos_orig(3)]; %Just move the left position
        set(ylab,'position',ylab_pos); % Move the label when the format changes
    end
    
    % This puts a border around the figure
    %  Note, this doesn't support sub-titles well
    axes('Position',[.005 .005 .99 .99],'xtick',[],'ytick',[],'box','on','handlevisibility','off','Color','none');   
    
    % This puts the "correct" no. of significant digits on the y-axis
    if (yformat == 1) % Removes the exponential foramting
        set(gca,'YTickLabel',num2str(get(gca,'YTick').','%2.0f'));
    elseif (yformat == 2)
        set(gca,'YTickLabel',num2str(get(gca,'YTick').','%2.2f'));
    elseif (yformat == 3)
        set(gca,'YTickLabel',num2str(get(gca,'YTick').','%0.1f'));
    end
    
    % Resize the print-out image to only take up half a page minus a little
    set(cf,'PaperUnits','inches');
    set(cf,'PaperSize',[8 11]);
    set(cf,'PaperPosition',[1 1 8 4.75]);
        
    print('-dpng',my_name);
end
function plotdldm(obj, color, shape)
  % Given an Experiment object and a number, plot its total change of
  % length over mass (color determines what color it is)
  
  % Plot line of best fit
  coeff = polyfit(obj.massAry(1:obj.aryLength/3),obj.totalDLDM(1:obj.aryLength/3),1);
  xFit = linspace(obj.massAry(1),obj.massAry(obj.aryLength/3));
  yFit = polyval(coeff, xFit);
  hold on;
  plot(xFit,yFit,strcat(color,'-'));
  hold on
  
  % Plot points
  plot(obj.massAry(1:obj.aryLength),obj.totalDLDM(1:obj.aryLength), strcat(color,shape))
  hold on
  
  % Labels
  xlabel('Change in Mass in Bag (kg)') 
  ylabel('Change in Bag Length (mm)')
  %set(gca,'Color','k')
  %grid on

end
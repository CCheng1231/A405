 %plot a sounding from soundings.nc
 clear all
 filename='springfield.nc';
 file_struct=nc_info(filename)
 c=constants;
 %
 % grap the first sounding pressure and temperature
 %
 sound_var = file_struct.Dataset(3).Name
 press=nc_varget(filename,sound_var,[0,0],[Inf,1]);
 temp=nc_varget(filename,sound_var,[0,2],[Inf,1]);
 dewpoint=nc_varget(filename,sound_var,[0,3],[Inf,1]);
 fh=figure(1);
 semilogy(temp,press)
 hold on;
 semilogy(dewpoint,press)
 set(gca,'yscale','log','ydir','reverse');
 ylim([400,1000]);
 ylabel('press (hPa)')
 xlabel('Temp (deg C)')
 title('sounding 1')
 hold off;
 figHandle=figure(2)
 skew=30.
 [figHandle,outputws,handlews]=makeSkew(figHandle,skew);
 xtemp=convertTempToSkew(temp,press,skew);    
 xdew=convertTempToSkew(dewpoint,press,skew);    
 semilogy(xtemp,press,'g-','linewidth',5);
 semilogy(xdew,press,'b-','linewidth',5);
 [xTemp,thePress]=ginput(1);
 Tclick=convertSkewToTemp(xTemp,thePress,skew);    
 thetaeVal=thetaes(Tclick + c.Tc,thePress*100.);
 fprintf('ready to draw moist adiabat, thetae=%8.2f\n',thetaeVal);
 ylim([400,1000.])
 
 %Code Modifications
 Pclickline=linspace(400,1000,100);
 for i=1:numel(Pclickline)
     Tclickline(i)=tinvert_thetae(thetaeVal,1,Pclickline(i)*1.e2);
     xTclickline(i)=convertTempToSkew(Tclickline(i) - c.Tc,Pclickline(i),skew);
 end
 
 semilogy(xTclickline,Pclickline,'k-','linewidth',3);
 hold off;
 
 press2=750:-1:400;
 for i=1:numel(press2)
    delta_T_v(i)=(interp1(Pclickline,Tclickline-c.Tc,press2(i)) - interp1(press(1:100),temp(1:100),press2(i)));
 end
 
 pos = delta_T_v>=0;
 delta_T_v = delta_T_v(pos);
 avg_dTv=mean(delta_T_v);
 
 
 CAPE = c.Rd*avg_dTv*log(700/450)
 
 
% $$$         double Mar-17-2011-00Z(dim_138, var_cols) ;
% $$$         double Mar-17-2011-12Z(dim_139, var_cols) ;
% $$$         double Mar-18-2011-00Z(dim_128, var_cols) ;
% $$$         double Mar-18-2011-12Z(dim_142, var_cols) ;
% $$$         double Mar-19-2011-00Z(dim_39, var_cols) ;
        
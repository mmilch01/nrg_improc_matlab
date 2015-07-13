data_dir='/data/cninds01/data2/WORK/misha/src';
[paths names nSessions]=sessions(data_dir);

lbfc=[0 1 2];
lfsl=[1 2 3];
lh=[2 3 4];
lp=[0 0 0];
for i=1:nSessions
    session_name=char(names(i));
    disp(session_name);
    session_path=char(paths(i));
    
    avw1=avw_img_read(strcat(session_path,'/BFC/',session_name,'_t88_111_bet_label'));
    Ibfc=avw1.img;
    
    avw2=avw_img_read(strcat(session_path,'/FSL/',session_name,'_t88_111_bet_seg'));
    Ifsl=avw2.img;
    
    avw3=avw_img_read(strcat(session_path,'/EM_SF/',session_name,'_t88_111_seg'));
    Ih=avw3.img;
    
%     avw4=avw_img_read(strcat(session_path,'/PARTITIOND/',session_name,'_t88_111_b10_gfc_region'));
%     Ip=avw4.img;
%     
%     bEnd=0;
%     
%     for z=int16(sz(3)/3):sz(3)/2
%         for y=int16(sz(2))/2:sz(2)/2
%             for x=int16(sz(1))/3:sz(1)/2
%                 if(bEnd==1) break; end;
%                 if(Ip(x,y,z)==0) continue;
%                 end;
%                 if(lp(1)==Ip(x,y,z) || lp(2)==Ip(x,y,z) || lp(3)==Ip(x,y,z)) continue; end;
%                 if(lp(1)==0) lp(1)=Ip(x,y,z);
%                 elseif(lp(2)==0) lp(2)=Ip(x,y,z);
%                 else
%                     lp(3)=Ip(x,y,z);
%                     bEnd=1;
%                 end;
%             end;
%             if(bEnd==1) break; end;
%         end;
%         if(bEnd==1) break; end;
%     end;
%     lp=sort(lp);
                    
    sz=size(Ih);
    R=zeros(sz(1),sz(2),sz(3));
    sz=size(Ibfc);
    for z=1:sz(3)
        for y=1:sz(2)
            for x=1:sz(1)
                for i=1:3
                    if(Ibfc(x,y,z)==lbfc(i) && Ifsl(x,y,z)==lfsl(i) && Ih(x,y,z)==lh(i))
%                    if(Ih(x,y,z)==lh(i))
%                    if(Ifsl(x,y,z)==lfsl(i))
                      R(x,y,z)=lh(i);                      
                     break;
                    end;
                end;
            end;
        end;
    end;
    avw3.img=R;
    avw_img_write(avw3,strcat(session_path,'/DSF/',session_name,'_t88_111_avg_seg'));
end
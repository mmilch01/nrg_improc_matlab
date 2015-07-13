function [percents] = test_class_diff(session_name,session_path)
cur_dir=pwd;
%cd ([session]);

%volFSL=read_vol('FSL',session,'_t88_111_bet_seg.img');
%volFSL_PARTITIOND=read_vol('FSL_PARTITIOND',session,'_bet_seg.img');

%vol1=read_vol('BFC',session,'_t88_111_bet_label.img');
vol1=read_vol('FREESURFER',session_path,session_name,'_avi_fswm.img');
vol2=read_vol('FSL_PARTITIOND',session_path,session_name,'_bet_seg.img');

%percents=class_diff(vol1,vol2,[1 2 3], [1 2 3]);
percents=class_diff(vol1,vol2,[-1], [3])

function [percents]=class_diff(A,B,classA,classB)
[dx dy dz]=size(A);
nClasses=size(classA,2);
nNorm=int32(zeros(nClasses,1));
nErr=nNorm;
for z=1:dz
	for y=1:dy
		for x=1:dx
			for n=1:nClasses
				if(InClass(A(x,y,z),classA(n)) && InClass(B(x,y,z),classB(n))) 
					nNorm(n)=nNorm(n)+1;
					continue; 
				end;
				if(InClass(A(x,y,z),classA(n)) || InClass(B(x,y,z),classB(n)))
					nErr(n)=nErr(n)+1;
					continue;
				end;
			end;
		end;
	end;
end;
percents=double(zeros(nClasses,1));
for i=1:nClasses
	percents(i)=double(nErr(i)*100)/double(nNorm(i));
end;

function [res]=InClass(val,test)
if(test>=0)
    res=(val==test);
else
    res=(val>0);
end;
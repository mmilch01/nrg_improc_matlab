function[] = wtr(fid,table)

[nrows,ncols]=size(table);

for prob=2:nrows
    if(isnan(cell2mat(table(prob,7)))) return; end;
end;

fprintf(fid,'%s,%s,%s,',table{1,1:3});
fprintf(fid,'%s,%s,%s\n',table{1,5:7});

for row=2:nrows
fprintf(fid,'%s,%f,%f,',table{row,1:3});
fprintf(fid,'%f,%f,%f\n',table{row,5:7});
end

fprintf(fid,',,,,,,\n');
fprintf(fid,',,,,,,\n');
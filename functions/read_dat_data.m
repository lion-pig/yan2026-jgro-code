function Var = read_dat_data(filename)
%READ_DAT_DATA 此处显示有关此函数的摘要
%   此处显示详细说明
Var_fileID = fopen(filename);
Var = fread(Var_fileID, 'single', 'b');
fclose(Var_fileID);


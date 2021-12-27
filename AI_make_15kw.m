

function x= AI_make_15kw()

temp = readtable('./aihub/N_1.csv',"VariableNamingRule","preserve");
x(:,1) = table2array(temp(4:end,2));

temp = readtable('./aihub/N_2.csv',"VariableNamingRule","preserve");
x(:,2) = table2array(temp(4:end,2));

temp = readtable('./aihub/N_3.csv',"VariableNamingRule","preserve");
x(:,3) = table2array(temp(4:end,2));

temp = readtable('./aihub/N_4.csv',"VariableNamingRule","preserve");
x(:,4) = table2array(temp(4:end,2));

temp = readtable('./aihub/N_5.csv',"VariableNamingRule","preserve");
x(:,5) = table2array(temp(4:end,2));

temp = readtable('./aihub/N_6.csv',"VariableNamingRule","preserve");
x(:,6) = table2array(temp(4:end,2));

temp = readtable('./aihub/N_7.csv',"VariableNamingRule","preserve");
x(:,7) = table2array(temp(4:end,2));

temp = readtable('./aihub/N_8.csv',"VariableNamingRule","preserve");
x(:,8) = table2array(temp(4:end,2));

temp = readtable('./aihub/N_9.csv',"VariableNamingRule","preserve");
x(:,9) = table2array(temp(4:end,2));

temp = readtable('./aihub/N_10.csv',"VariableNamingRule","preserve");
x(:,10) = table2array(temp(4:end,2));

temp = readtable('./aihub/M_1.csv',"VariableNamingRule","preserve");
x(:,11) = table2array(temp(4:end,2));

temp = readtable('./aihub/M_2.csv',"VariableNamingRule","preserve");
x(:,12) = table2array(temp(4:end,2));

temp = readtable('./aihub/M_3.csv',"VariableNamingRule","preserve");
x(:,13) = table2array(temp(4:end,2));

temp = readtable('./aihub/M_4.csv',"VariableNamingRule","preserve");
x(:,14) = table2array(temp(4:end,2));

temp = readtable('./aihub/M_5.csv',"VariableNamingRule","preserve");
x(:,15) = table2array(temp(4:end,2));

temp = readtable('./aihub/M_6.csv',"VariableNamingRule","preserve");
x(:,16) = table2array(temp(4:end,2));

temp = readtable('./aihub/M_7.csv',"VariableNamingRule","preserve");
x(:,17) = table2array(temp(4:end,2));

temp = readtable('./aihub/M_8.csv',"VariableNamingRule","preserve");
x(:,18) = table2array(temp(4:end,2));

temp = readtable('./aihub/M_9.csv',"VariableNamingRule","preserve");
x(:,19) = table2array(temp(4:end,2));

temp = readtable('./aihub/M_10.csv',"VariableNamingRule","preserve");
x(:,20) = table2array(temp(4:end,2));


temp = readtable('./aihub/B_1.csv',"VariableNamingRule","preserve");
x(:,21) = table2array(temp(4:end,2));

temp = readtable('./aihub/B_2.csv',"VariableNamingRule","preserve");
x(:,22) = table2array(temp(4:end,2));

temp = readtable('./aihub/B_3.csv',"VariableNamingRule","preserve");
x(:,23) = table2array(temp(4:end,2));

temp = readtable('./aihub/B_4.csv',"VariableNamingRule","preserve");
x(:,24) = table2array(temp(4:end,2));

temp = readtable('./aihub/B_5.csv',"VariableNamingRule","preserve");
x(:,25) = table2array(temp(4:end,2));

temp = readtable('./aihub/B_6.csv',"VariableNamingRule","preserve");
x(:,26) = table2array(temp(4:end,2));

temp = readtable('./aihub/B_7.csv',"VariableNamingRule","preserve");
x(:,27) = table2array(temp(4:end,2));

temp = readtable('./aihub/B_8.csv',"VariableNamingRule","preserve");
x(:,28) = table2array(temp(4:end,2));

temp = readtable('./aihub/B_9.csv',"VariableNamingRule","preserve");
x(:,29) = table2array(temp(4:end,2));

temp = readtable('./aihub/B_10.csv',"VariableNamingRule","preserve");
x(:,30) = table2array(temp(4:end,2));



end
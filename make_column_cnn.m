function col = make_column_cnn(x1,Class_Number,n) % (DE,FE,Class_Number)

temp =[];


col = make_statical_cnn(x1); %13
temp = horzcat(temp,col);

col = make_WPE_cnn(x1); % 16
temp = horzcat(temp,col);

col = make_envelope_cnn(x1); % 36
temp = horzcat(temp,col);


col =temp;

a =[1,2,3];
 
    if n ==1
        col(66) = ceil(Class_Number/50);
    elseif n ==2 
        col(66) = randi(3);
    elseif n ==3 
        col(66) =ceil(Class_Number/24) ;
    end
    
  
end 
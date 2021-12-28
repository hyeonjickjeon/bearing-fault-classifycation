function E = make_WPE_cnn(x1)

wpt = wpdec(x1,4,'db4','shannon');
E = wenergy(wpt); 


end 
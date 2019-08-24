##################################################################################
# create profile by gaussian smoothing of positions
# input parameters: 
# av=W where W is length of smoothing window
# sig=S where S is sigma of gaussian (commonly sigma is 2 or 3)
# offset=N (offset from the end to the center)
###################################################################################
{
  if(FNR==1)
  {
    for(i=-int(av/2);i<=int(av/2);i++)
    {
      arr_s[i]=exp(-((i*sig*2/av)^2)/2);
      sum+=arr_s[i];
    }
#    for(i=-int(av/2);i<=int(av/2);i++)
#      arr_s[i]/=sum;
    pos=int(($1+$2)/2);
    num_buf=int(pos/buffer);
  }
  pos=int(($1+$2)/2);
  pos_buf=int(pos/buffer);
  if(pos_buf>num_buf)
  {
    for(i=1;i<=buffer;i++)
      if(arr[i]>0)
      {
        print num_buf*buffer+i, arr[i];
        arr[i]=0;
      }
      else
        print num_buf*buffer+i, 0;
    num_buf=pos_buf;
  }
  for(i=-int(av/2);i<=int(av/2);i++)
    arr[pos-num_buf*buffer+i]+=arr_s[i]*$3;
}
END{
  for(i=1;i<=buffer;i++)
    if(arr[i]>0)
      print num_buf*buffer+i, arr[i];
    else
      print num_buf*buffer+i, 0;
}

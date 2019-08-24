###################################################################
# position of maximum
# parameters: window=W (minimal distance between two peaks)
#             buffer=N (size of buffer)
###################################################################
function max_pos_funct(min_pos, max_pos)
{
  sum=0;
    start_position=min_pos;
    for(i=min_pos+window;i<=max_pos&&sum<1000;)
    {
      sum++;
      max=arr[i];
      pos=i;
      for(j=i-window;j<=i+window&&j<=max_pos;j++)
      {
        if(arr[j]>max)
        {
          max=arr[j]
          pos=j
        }
      }
      if(arr[pos]>=arr[pos-1]&&arr[pos]>=arr[pos+1]&&arr[pos]>0)
      {
        if(pos==i)
        {
          start_position=pos+window+1
          printf("%d %f\n", pos+buffer*num_buf, arr[pos]);
          i=pos+window*2+1;
        }
        else
        {
          if(pos>=start_position&&pos>min_pos)
          {
            i=pos;
          }
          else
          {
            i+=window*2+1;
          }
        }
      }
      else
      {
        i+=window+1;
      }
      if(sum==999)
      {
        i+=window*3;
        sum=1;
      }
    }
#  printf("\n");
}
{
  if(FNR==1)
    num_buf=0;
  pos_buf=int($1/buffer);
  if(pos_buf>num_buf)
  {
    max_pos_funct(1,buffer);
    num_buf=pos_buf;
  }
  arr[$1-num_buf*buffer]=$2;
}
END{
  max_pos_funct(1,$1-num_buf*buffer);
}

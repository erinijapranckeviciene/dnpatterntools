/* Fourier_Transform.cpp : Defines the entry point for the console application. */


/* #include "stdafx.h" windows //version only*/

#include "four_norm.h"
#define LEN_ARR 32

int main(int argc, char *argv[])
{
	char * input_sequence=NULL;
	char * output_table=NULL;
	FILE * input_file=NULL;
	FILE * output_file=NULL;

	int i=0;
	int j=0;
	int k=0;
	int l=0;
	int k_type=0;
	int n_type=-1;
	int len_smooth=1;
	int size_arr=LEN_ARR;

	double sum=0;
	double sum_s=0;
	double sum_c=0;
	double sigma=0;
	double sigma_s=0;

	double sum_x=0;
	double sum_y=0;
	double sum_xy=0;
	double sum_x2=0;

	double k1=0;
	double k2=0;
	double k3=0;

	double * mat1;
	double * mat2;
	double * mat3;

	char * line_table=NULL;

	double * arr_tab=NULL;
	double * arr_tab_temp=NULL;
	double * arr_tab_smooth=NULL;
	double * arr_fur;

/* load input parameters */

	if(argc<5)
	{
		print_help();
		return 0;
	}
	for(i=1;i<argc;i++)
	{
		if(argv[i][0]=='-'&&argv[i][1]=='f')
			input_sequence=argv[i+1];
	}
	for(i=1;i<argc;i++)
	{
		if(argv[i][0]=='-'&&argv[i][1]=='o')
			output_table=argv[i+1];
	}
	for(i=1;i<argc;i++)
	{
		if(argv[i][0]=='-'&&argv[i][1]=='t')
		{
			k_type=char2int(argv[i+1]);
		}
	}
	for(i=1;i<argc;i++)
	{
		if(argv[i][0]=='-'&&argv[i][1]=='l')
		{
			len_smooth=char2int(argv[i+1]);
		}
	}
	for(i=1;i<argc;i++)
	{
		if(argv[i][0]=='-'&&argv[i][1]=='n')
		{
			n_type=char2int(argv[i+1]);
		}
	}

	input_file=fopen(input_sequence,"r");
	if(input_file==NULL)
	{
		printf("cannot open file %s \n",input_sequence);
		return -1;
	}

/* loading input table */

	input_file=fopen(input_sequence,"r");
	if(input_file==NULL)
	{
		printf("cannot open file %s \n",input_sequence);
		return -1;
	}
	arr_tab=(double*) malloc(sizeof(double)*size_arr*2);
	line_table=read_line(input_file);
	i=0;
	while(!feof(input_file))
	{
		if(line_table!=NULL)
		{
			arr_tab[i*2]= (double) (char2double(line_table));
			arr_tab[i*2+1]= (double) (char2double(word_next(line_table)));
			i++;
			if(i==size_arr)
			{
				size_arr*=2;
				arr_tab_temp=arr_tab;
				arr_tab=(double*) malloc(sizeof(double)*size_arr*2);
				for(j=0;j<size_arr;j++)
					arr_tab[j]=arr_tab_temp[j];
				free(arr_tab_temp);
			}
		}
		free(line_table);
		line_table=read_line(input_file);
	}
	size_arr=i;

	arr_fur=(double*) malloc(sizeof(double)*size_arr*10/2);
	for(i=0;i<size_arr*10/2;i++)
		arr_fur[i]=0;

	switch(n_type)
	{
	case 0:
/*   average normalization A */
		for(i=0;i<size_arr;i++)
			k1+=arr_tab[i*2+1];
		k1/=(size_arr-1);
		break;
	case 1:
/*   linear normalization A+Bx */
		for (i=0;i<size_arr;i++)
		{
			sum_x+=i;
			sum_x2+=i*i;
			sum_y+=arr_tab[i*2+1];
			sum_xy+=i*arr_tab[i*2+1];
		}
		k2=(sum_xy-sum_x*sum_y/size_arr)/(sum_x2-sum_x*sum_x/size_arr);
		k1=sum_y/size_arr-k2*sum_x/size_arr;
		break;
	case 2:
/*	square normalization Ax^2+Bx+C */

		mat1=(double*) malloc(sizeof(double)*12);
		mat2=(double*) malloc(sizeof(double)*6);
		mat3=(double*) malloc(sizeof(double)*2);
		for(i=0;i<3;i++)
		{
			for(j=0;j<3;j++)
			{
				mat1[i*4+j]=0;
				for(k=0;k<size_arr;k++)
				{
					sum=1;
					for(l=0;l<i+j;l++)
						sum*=(k+1);
					mat1[i*4+j]+=sum;
				}
			}
			mat1[i*4+j]=0;
			for(k=0;k<size_arr;k++)
			{
				sum=1;
				for(l=0;l<i;l++)
					sum*=(k+1);
				mat1[i*4+3]+=sum*arr_tab[k*2+1];
			}
		}

		mat2[0]=mat1[5]-mat1[1]*mat1[4]/mat1[0];
		mat2[1]=mat1[6]-mat1[2]*mat1[4]/mat1[0];
		mat2[2]=mat1[7]-mat1[3]*mat1[4]/mat1[0];
		mat2[3]=mat1[9]-mat1[1]*mat1[8]/mat1[0];
		mat2[4]=mat1[10]-mat1[2]*mat1[8]/mat1[0];
		mat2[5]=mat1[11]-mat1[3]*mat1[8]/mat1[0];

		mat3[0]=mat2[4]-mat2[1]*mat2[3]/mat2[0];
		mat3[1]=mat2[5]-mat2[2]*mat2[3]/mat2[0];
		k3=(float) (mat3[1]/mat3[0]);
		k2=(float) ((mat2[2]-mat2[1]*k3)/mat2[0]);
		k1=(float) ((mat1[3]-mat1[2]*k3-mat1[1]*k2)/mat1[0]);
		break;
	default:
		break;
	}

	if(output_table!=NULL)
	{
		output_file=fopen(output_table,"w");
		if(output_file==NULL)
		{
			printf("cannot create file %s\n", output_table);
			return -1;
		}
	}

	for(i=0;i<size_arr;i++)
	{
/* print incoming table */
		if(k_type==0)
		{
			if(output_file==NULL)
				printf("%d %6.6f\n", (int) (arr_tab[i*2]), arr_tab[i*2+1]);
			else
				fprintf(output_file,"%d %6.6f\n", (int) (arr_tab[i*2]), arr_tab[i*2+1]);
		}
		switch(n_type)
		{
		case 0:
			arr_tab[i*2+1]-=k1;
			break;
		case 1:
			arr_tab[i*2+1]-=k1+k2*i;
			break;
		case 2:
			arr_tab[i*2+1]-=k1+k2*i+k3*i*i;
			break;
		default:
			break;
		}
/* print normalized table */
		if(k_type==1)
		{
			if(output_file==NULL)
				printf("%d %6.6f\n", (int) (arr_tab[i*2]), arr_tab[i*2+1]);
			else
				fprintf(output_file,"%d %6.6f\n", (int) (arr_tab[i*2]), arr_tab[i*2+1]);
		}
	}

	arr_tab_smooth= (double*) malloc(sizeof(double)*size_arr-len_smooth+1);

	for(i=0;i<size_arr-len_smooth+1;i++)
	{
		sum=0;
		for(j=0;j<len_smooth;j++)
			sum+=arr_tab[(i+j)*2+1];
		arr_tab_smooth[i]=sum/len_smooth;
/* print smoothed normalized table */
		if(k_type==2)
		{
			if(output_file==NULL)
				printf("%d %6.6f\n", (int) (arr_tab[i*2]+len_smooth/2), arr_tab_smooth[i]);
			else
				fprintf(output_file,"%d %6.6f\n", (int) (arr_tab[i*2]+len_smooth/2), arr_tab_smooth[i]);
		}
	}
	if(k_type<3)
		return 0;

	sigma=0;
	for(j=0;j<(size_arr-len_smooth+1);j++)
		sigma+=arr_tab_smooth[j]*arr_tab_smooth[j];
	for(i=21;i<(size_arr-len_smooth+1)/2*10;i++)
	{
		sigma_s=0;
		sum=2*10*3.1415926/i;
		sum_s=0;
		sum_c=0;
		for(j=0;j<(size_arr-len_smooth+1);j++)
		{
			sigma_s+=sin(j*sum)*sin(j*sum);
			sum_s+=sin(j*sum)*arr_tab_smooth[j];
			sum_c+=cos(j*sum)*arr_tab_smooth[j];
		}
		sum=sqrt(sum_s*sum_s+sum_c*sum_c)/sqrt(sigma*sigma_s);
		sum_s=i/10.0;
/* print Fourier transform */
		if(output_file==NULL)
			printf("%f %f\n", sum_s, sum);
		else
			fprintf(output_file,"%f %f\n", sum_s, sum);
	}


	fclose(input_file);
	if(output_file!=NULL)
		fclose(output_file);
	free(arr_tab);
	free(arr_tab_smooth);
	free(arr_fur);
	return 0;
}

/* ///////////////////////////// Printing help ///////////////////// */
void print_help()
{
	printf("\nFourier transform and smoothing of input sequence\n");
	printf("input parameters:                               \n");
	printf("------------------------------------------------\n");
	printf("-f input sequence                               \n");
	printf("-o output table                                 \n");
	printf("-l length of window of smoothing                \n");
	printf("-n type of normalisation:                       \n");
	printf("     0 base normalization                      \n");
	printf("     1 linear normalization                     \n");
	printf("     2 quadratic normalization                  \n");
	printf("-t type of output table:                        \n");
	printf("     1 normalization                            \n");
	printf("     2 smoothing                                \n");
	printf("     3 Fourier transform                        \n");
	printf("                             S.Hosid 2008 - 2018\n");

}
/* /////////////////////////// read line from file ///////////// */
char * read_line(FILE * file_name)
{
	char * read_string;
	char * read_string_temp;
	int i;
	int length_string=1024;
	char check='\0';
	i=0;
	read_string= (char*) malloc(sizeof(char)*length_string);
	while((check>=32&&i>0||i==0)&&!feof(file_name))
	{
		check=fgetc(file_name);
		if(check>=32)
		{
			read_string[i]=check;
			i++;
			if(i==length_string)
			{
				length_string*=2;
				read_string_temp= (char*) malloc(sizeof(char)*length_string);
				for(i=0;i<length_string/2;i++)
					read_string_temp[i]=read_string[i];
				free(read_string);
				read_string=read_string_temp;
			}
		}
	}
	if(i==0)
	{
		free(read_string);
		return NULL;
	}
	read_string[i]='\0';
	return read_string;
}

////////////////////////////// next word from string ////////////////
char * word_next(char * line)
{
	int i;
	for(i=0;line[i]!=' '&&line[i]!='\0'; i++) ;
	for( ; line[i]==' '&&line[i]!='\0'; i++) ;
	return line+i;
}

////////////////////////////// Integer digit from string ////////////
int char2int(char * line)
{
	int i=0;
	int sum=0;
	int kof=1;
	for(i=0; line[i]>47&&line[i]<58; i++) ;
	i--;
	sum+=(line[i]>47&&line[i]<58) ? line[i]-48 : 0;
	for(i--; i>=0; i--)
	{
		kof*=10;
		sum+=(line[i]-48)*kof;
	}
	return sum;
}

/* ///////////////////////////// Float from string /////////////// */
double char2double(char * line)
{
	int i=0;
	int j=0;
	double sum=0;
	int kof=1;
	int sign=0;
	if(line[0]=='-'||line[0]=='+')
		sign=1;
	for(j+=sign; line[j]>47&&line[j]<58; j++) ;
	i=j-1;
	sum+=(line[i]>47&&line[i]<58) ? line[i]-48 : 0;
	for(i--; i>=sign; i--)
	{
		kof*=10;
		sum+=(line[i]-48)*kof;
	}
	i=j+1;
	for(j++; line[j]>47&&line[j]<58; j++) ;
	kof=1;
	for(; i<j ; i++)
	{
		kof*=10;
		sum+=((float)line[i]-48)/kof;
	}
	if(line[0]=='-')
		sum*=-1.0;
	return sum;
}

/* What it does. 
   Computes correlation between the forward and reversed
   dinucleotide profiles. 

   Input file contains
   two columns. First is dinucleotide frequencies
   in given sequences , the second is frequencies 
   on complementary sequences.

   Correlation is computed at each position
   within the sliding window between the 
   first column profile (forward) and 
   reversed second column (complementary).

   Output is sequence of correlation coefficients.
*/

#include <iostream>
#include <fstream>
#include <string>
#include <math.h>
#include <seqan/file.h>
#include <seqan/sequence.h>
#include <seqan/score.h>
#include <seqan/stream.h>
#include <seqan/modifier.h>
#include <seqan/seq_io.h>
#include <seqan/arg_parse.h>

using namespace std;
using namespace seqan;

struct corrprofileOptions
{
  CharString   profFileName;
  unsigned n;
  unsigned w;
  bool     isVerbose;

  corrprofileOptions(): 
  n(600), w(10), isVerbose(false)  
  {}
};

seqan::ArgumentParser::ParseResult
parseCommandLine(corrprofileOptions & options, int argc, char ** argv)
{
  seqan::ArgumentParser parser("corrprofile");
  
  addArgument(parser, seqan::ArgParseArgument(seqan::ArgParseArgument::STRING, "PROFILE FILE"));

  addOption(parser, seqan::ArgParseOption(
      "w", "window", "Sliding window size, < than length.", 
      seqan::ArgParseArgument::INTEGER, "INTEGER"));
  setDefaultValue(parser,"window","10");
  seqan::setMinValue(parser,"window","10");
  seqan::setMaxValue(parser,"window","146");

  addOption(parser, seqan::ArgParseOption(
      "n", "length", "Dinucleotide profile sequence length.", 
      seqan::ArgParseArgument::INTEGER, "INTEGER"));
  setDefaultValue(parser,"length","600");
  seqan::setMinValue(parser,"length","25");
  seqan::setMaxValue(parser,"length","600");

  addOption(parser, seqan::ArgParseOption(
      "v", "verbose", "Print parameters and variables. "));

  seqan::setShortDescription(parser,"Correlations between Dinucleotide Profiles");
  seqan::setVersion(parser,"1.0");
  seqan::setDate(parser,"April 2017"); 
  seqan::addUsageLine(parser,
		      "[\\fIOPTIONS\\fP] \"\\fIdinucleotideProfilesFile\\fP\"");
  seqan::addDescription(parser,
			"This program computes correlations  "
			"between the profiles of dinucleotide frequency "
                        "on forward and reverse complent sequences "
			"within a sliding window. ");
  seqan::addSection(parser, "Corrprofile Options");

  seqan::addTextSection(parser,"Examples");
  seqan::addListItem(parser,
                     "\\fBcorrprofile\\fP \\fB-w 146 -n 400\\fP \\fIpath/to/profiles/file\\fP",
  		     "Compute correlations at each position in 400bp long profile within the sliding 146bp window"); 
  
   seqan::addTextSection(parser,"Output");

    seqan::addListItem(parser,
		       "Column of correlation coefficients",
		       "between forward and reverse profile at each position");


  seqan::ArgumentParser::ParseResult res = seqan::parse(parser,argc,argv);

  if (res != seqan::ArgumentParser::PARSE_OK)
    return res;

   getOptionValue(options.w,parser,"window");
   getOptionValue(options.n,parser,"length");
   options.isVerbose    = isSet(parser, "verbose");
   getArgumentValue(options.profFileName,parser,0); 

   // window should be less that n
   if ( options.w > options.n-2 )
     { cout << "Window can't be bigger than the profile sequence. --help for the parameters. \n";
       return seqan::ArgumentParser::PARSE_ERROR;}
   else
     return seqan::ArgumentParser::PARSE_OK;
}

/*=====================================================*/
float corcoef(float x[], float y[], int n)
{
  double xy[n], xsquare[n], ysquare[n]; 
  double xsum, ysum, xysum, xsqr_sum, ysqr_sum;
  double coeff, num, deno;

  xsum= ysum = xysum = xsqr_sum = ysqr_sum =0;

  for (unsigned i = 0; i < n; ++i)
  {
    xy[i]      = x[i]*y[i];
    xsquare[i] = x[i]*x[i];
    ysquare[i] = y[i]*y[i];
    xsum = xsum   + x[i];
    ysum = ysum   + y[i];
    xysum = xysum + xy[i];
    xsqr_sum = xsqr_sum + xsquare[i];
    ysqr_sum = ysqr_sum + ysquare[i];
    // cout << x[i] << " " << y[i] << " " << xsum << " " << ysum <<" " << xysum << "\n"; 
  }

  num = 1.0*((n*xysum)-(xsum*ysum));
  deno = 1.0*(((n*xsqr_sum) - (xsum * xsum) )*((n * ysqr_sum) - (ysum * ysum) )); 
  coeff = num/sqrt(deno);

  return coeff;
}


/*=====================================================*/
int main(int argc, char *argv[]){
  
  corrprofileOptions options;
  seqan::ArgumentParser::ParseResult res = parseCommandLine(options, argc, argv);
 
  if( res != seqan::ArgumentParser::PARSE_OK)
    return res == seqan::ArgumentParser::PARSE_ERROR;

  CharString   FileName = options.profFileName;
  unsigned w  = options.w; 
  unsigned n  = options.n;


   float f1[n];
   float f2[n];
   unsigned count = 0;

   ifstream FileIn (toCString(FileName));
   
   if (! FileIn.is_open() )
    {
      std::cerr << "ERROR: Could not open the file " << FileName << "\n";
        return 1;
      }
   else
     { 
       while(!FileIn.eof() )
	 {
           FileIn >> f1[count];
	   FileIn >> f2[count];

	   //	   cout << f1[count]<< " " << f2[count] << '\n';
	   count++;
	 }
       FileIn.close();
     }

   // if count is bigger or lesser than n ? Handle. 
   /* compute correlation profile between forward and reverse within sliding window*/ 
   for(int j=0; j < n-w+1; j++)
     { 
       float fwr[w];
       float rev[w];

       //cout << "start j= " << j<< "\n";
       for(int position=0; position<w; position++) 
	 { 
	   fwr[position] = f1[ j + position ];
           rev[position] = f2[ j+ w - 1 - position ];
	   
	 }
       float cf    = corcoef(fwr,rev,w);
       //cout << "corrcoef =" << cf <<"\n\n";
       cout << cf << "\n";
     }
        
    return 0;
}




/* This program reads the fasta file and computes
   average profile of dinucleotide occurrences 
   over all sequences.

  Input parameters are file name, dinucleotide  */

#include <iostream>
#include <seqan/arg_parse.h>
//#include <seqan/basic.h>
#include <seqan/file.h>
#include <seqan/sequence.h>
#include <seqan/score.h>
#include <seqan/stream.h>
#include <seqan/modifier.h>
#include <seqan/seq_io.h>

using namespace seqan;

/*=====================================================*/
int matchPattern(String<Dna5> const & sequence, String<Dna5> const & pattern)
{
  int localScore =0;
  for (unsigned i = 0; i < length(pattern); ++i)
    if ( (sequence[i] == pattern[i]) )
      ++localScore;

  if ( localScore == length(pattern) ) return 1;

  return 0;
}
/*=====================================================*/
void printFloat(String<int> const & text, int const & n, unsigned const & count)
{
  //  for (unsigned k = 0; k < length(text); ++k)
    for (unsigned k = 0; k < n; ++k)
    printf("%f\n", (double)((double)text[k]/count) );
    //std::cout << text[k]; std::cout << std::endl;
}

struct diprofileOptions
{
  CharString   seqFileName;
  String<Dna5>   nucPattern; 
  unsigned seqLen;
  bool     isComplement;
  bool     isVerbose;

  diprofileOptions(): 
  nucPattern("AA"), seqLen(600), isComplement(false), isVerbose(false)  
  {}
};

seqan::ArgumentParser::ParseResult
parseCommandLine(diprofileOptions & options, int argc, char const ** argv)
{
  seqan::ArgumentParser parser("diprofile");
  
  addArgument(parser, seqan::ArgParseArgument(seqan::ArgParseArgument::STRING, "FASTA FILE"));

  addOption(parser, seqan::ArgParseOption(
      "di", "dinucleotide", "Dinucleotide to compute a frequency profile in fasta file.", 
      seqan::ArgParseArgument::STRING, "STRING"));
  setDefaultValue(parser,"dinucleotide","AA");
  seqan::setValidValues(parser,"dinucleotide","AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT");

  addOption(parser, seqan::ArgParseOption(
      "sl", "seqlength", "Sequence length in fasta file.", 
      seqan::ArgParseArgument::INTEGER, "INTEGER"));
  setDefaultValue(parser,"seqlength","600");
  seqan::setMinValue(parser,"sl","25");
  seqan::setMaxValue(parser,"sl","600");

  addOption(parser, seqan::ArgParseOption(
      "c", "complement", "Perform computation on COMPLEMENTARY sequences of the strings in fasta file."));

  addOption(parser, seqan::ArgParseOption(
      "v", "verbose", "Print parameters and variables. "));

  seqan::setShortDescription(parser,"Dinucleotide Frequency Profile");
  seqan::setVersion(parser,"1.0");
  seqan::setDate(parser,"April 2017"); 
  seqan::addUsageLine(parser,
		      "[\\fIOPTIONS\\fP] \"\\fIfastaFile.fa\\fP\"");
  seqan::addDescription(parser,
			"This program computes a profile of a "
			"frequency of occurrence of the dinucleotide "
			"in a batch of fasta sequences aligned "
			"by their start position.");
  seqan::addSection(parser, "Diprofile Options");

  seqan::addTextSection(parser,"Examples");
  seqan::addListItem(parser,
		     "\\fBdiprofile\\fP \\fB-sl 146 -di CT\\fP \\fIpath/to/fasta/file.fa\\fP",
		     "Compute CT profile in fasta sequences of 146bp long"); 
  seqan::addListItem(parser,
		     "\\fBdiprofile\\fP \\fB-sl 146 -di CT -c\\fP \\fIpath/to/fasta/file.fa\\fP",
		     "Compute CT profile in sequence complements of fasta sequences of 146bp long"); 
  seqan::addTextSection(parser,"Output");

  seqan::addListItem(parser,
		     "Column of relative frequencies of dinucleotide occurrences at each ",
		     "position along fasta sequences of given length \\fB--seqlength\\fP");


  seqan::ArgumentParser::ParseResult res = seqan::parse(parser,argc,argv);

  if (res != seqan::ArgumentParser::PARSE_OK)
    return res;

   getOptionValue(options.nucPattern,parser,"dinucleotide");
   getOptionValue(options.seqLen,parser,"seqlength");
   options.isComplement = isSet(parser, "complement");
   options.isVerbose    = isSet(parser, "verbose");
   getArgumentValue(options.seqFileName,parser,0); 

   // dinucleotides should be valid
   // seqlength should be 10-600

   return seqan::ArgumentParser::PARSE_OK;
}

/*=====================================================*/
int main(int argc, char const **argv){

  diprofileOptions options;
  seqan::ArgumentParser::ParseResult res = parseCommandLine(options, argc, argv);
 
  if( res != seqan::ArgumentParser::PARSE_OK)
    return res == seqan::ArgumentParser::PARSE_ERROR;

  CharString   seqFileName = options.seqFileName;
  String<Dna5> nucPattern  = options.nucPattern; 
  unsigned seqLen          = options.seqLen;


   if(options.isVerbose){
   std::cout << "dinucleotide \t" << nucPattern << '\n'
             << "complement \t" << options.isComplement << '\n'
             << "seq file name \t" << seqFileName << '\n'
             << "seq Length \t" << seqLen << '\n';
   }


   SeqFileIn seqFileIn;
    if (!open(seqFileIn, toCString(seqFileName)))
    {
        std::cerr << "ERROR: Could not open the file.\n";
        return 1;
      }
     
    StringSet<CharString> ids;
    StringSet<Dna5String> seqs;
    
    unsigned count = 0;
    String<unsigned> profile;
    resize(profile, seqLen , 0);
  //here should be a way to determine the string length in the program

    String<Dna5> seq;        
    
    while(!atEnd(seqFileIn))
    {

    try
    {
      readRecords(ids, seqs, seqFileIn,100000);
    }
    catch (Exception const & e)
    {
        std::cout << "ERROR: " << e.what() << std::endl;
        return 1;
    }

    count = count+length(ids);
    //std::cout << "batch \t" << length(ids) << "\t count \t" << count << '\n';
 
    for (unsigned i = 0; i < length(ids); ++i)
      {
          String<Dna5> sequence;
          Dna5StringComplement cpl(sequence);
   	  sequence = seqs[i];
	  seq      = sequence;
	 
	  // if flag, then sequence becomes complement
	  if(options.isComplement){ seq = cpl;}
	  
	  // print the sequence for control
	  if(options.isVerbose ){
	    std::cout << ids[i] << '\t' << seq << std::endl;
	  } 

	 // compute occurences of dinucleotide
	 // across the sequences, sum result to each position of profile 
	  for ( unsigned k = 0; k < length(seq) - length(nucPattern)+1; ++k)
	   {
	     int pfw = matchPattern(infix(seq,k,k+length(nucPattern)),nucPattern);		 
	     profile[k] = profile[k] + pfw; 
	   }	   
      } // across ids

      clear(ids);
      clear(seqs);

    }
    int n = length(seq);
    //std::cout << "length " << n<< std::endl;

    printFloat(profile,n,count);
    return 0;
}

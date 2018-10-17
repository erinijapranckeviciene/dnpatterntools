/* This program reads the fasta file and
   each sequence is transformed into 0011 form in which ones denote 
   dinucleotides and zeros are elsewhere.    
   Binary sequence is printed. The last lne 
   is the profile of the dinucleotide appearance.
   Last parameter = 0 do not match fw and reverse
                  = 1 match fw and reverse
   */

/* Input parameters are file name, dinucleotide, length of the sequences and a flag 
showing whether the profile of dinucleotide is between forward and reverse flag = 1 or it is 
general dinucleotide matching flag =0  */

#include <iostream>
#include <seqan/arg_parse.h>
#include <seqan/file.h>
#include <seqan/sequence.h>
#include <seqan/score.h>
#include <seqan/stream.h>
#include <seqan/modifier.h>
#include <seqan/seq_io.h>

using namespace seqan;
/*=====================================================*/
int matchPatternFR(String<Dna5> const & sequence, String<Dna5> const & rcsequence, String<Dna5> const & pattern)
{
  int localScore =0;
  for (unsigned i = 0; i < length(pattern); ++i)
    if ( (sequence[i] == pattern[i]) && (rcsequence[i] == pattern[i]) )
      ++localScore;

   if ( localScore == length(pattern) ) return 1;

  return 0;
}
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
void printBinary(String<int> const & text)
{
  for (unsigned k = 0; k < length(text); ++k)
      std::cout << text[k];
  //std::cout << std::endl;
}

/*=====================================================*/
void printNum(String<int> const & text)
{
  for (unsigned k = 0; k < length(text); ++k)
    std::cout << text[k] << ' ';
  std::cout << std::endl;
}

/*=====================================================*/
void printFloat(String<int> const & text, unsigned const & count)
{
  for (unsigned k = 0; k < length(text); ++k)
    printf("%f\t", (double)((double)text[k]/count) );
    //std::cout << text[k];
  std::cout << std::endl;
}

/*=====================================================*/
struct binstringsOptions
{
  CharString   seqFileName;
  String<Dna5>   nucPattern;

  binstringsOptions():
  nucPattern("CC")
  {}
};

seqan::ArgumentParser::ParseResult
parseCommandLine(binstringsOptions & options, int argc, char const ** argv)
{
  seqan::ArgumentParser parser("binstrings");

  addArgument(parser, seqan::ArgParseArgument(seqan::ArgParseArgument::STRING, "FASTA FILE"));

  addOption(parser, seqan::ArgParseOption(
      "di", "dinucleotide", "Dinucleotide that is to identify in fasta sequences",
      seqan::ArgParseArgument::STRING, "STRING"));
  setDefaultValue(parser,"dinucleotide","CC");
  seqan::setValidValues(parser,"dinucleotide","AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT");

  seqan::setShortDescription(parser,"Binary strings from fasta");
  seqan::setVersion(parser,"1.0");
  seqan::setDate(parser,"September 2018");
  seqan::addUsageLine(parser,
                      "[\\fIOPTIONS\\fP] \"\\fIfastaFile.fa\\fP\"");

  seqan::addDescription(parser,
    "This program reads the fasta file and "
   "each sequence is transformed into 0011 form in which ones denote"
   "dinucleotides and zeros are elsewhere."    
   "Binary sequence is printed. The last lne"
   "is the profile of the dinucleotide appearance.");

  seqan::addSection(parser, "binstrings Options");

  seqan::addTextSection(parser,"Examples");
  seqan::addListItem(parser,
                     "\\fBbinstrings\\fP \\fB-di CC\\fP \\fIpath/to/fasta/file.fa\\fP",
                     "Compute binary strings matching CC  in fasta sequences.");

  seqan::addTextSection(parser,"Output");
  seqan::addListItem(parser,
                     "100000000111000 CC chr9:42475963-42476182 CCAGGCAGACCCCATA 4",
                     "binary string,  CC, fasta id, DNA sequence, occurrences");

  seqan::ArgumentParser::ParseResult res = seqan::parse(parser,argc,argv);

  if (res != seqan::ArgumentParser::PARSE_OK)
    return res;

   getOptionValue(options.nucPattern,parser,"dinucleotide");
   getArgumentValue(options.seqFileName,parser,0);

   return seqan::ArgumentParser::PARSE_OK;
}

/*=====================================================*/
int main(int argc, char const **argv){

  binstringsOptions options;
  seqan::ArgumentParser::ParseResult res = parseCommandLine(options, argc, argv);

  if( res != seqan::ArgumentParser::PARSE_OK)
    return res == seqan::ArgumentParser::PARSE_ERROR;

  CharString   seqFileName = options.seqFileName;
  String<Dna5> nucPattern  = options.nucPattern;

   String<Dna5> pattern = nucPattern;
   
   SeqFileIn seqFileIn;
    if (!open(seqFileIn, toCString(seqFileName)))
    {
        std::cerr << "ERROR: Could not open the file.\n";
        return 1;
      }
    
    
    StringSet<CharString> ids;
    StringSet<Dna5String> seqs;
    unsigned count = 0;
   
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
	 String<Dna5> seq = seqs[i];
         String<int> binarystr;
	 unsigned counts = 0;
	 resize(binarystr, length(seq), 0);
           for ( unsigned k = 0; k < length(binarystr) - length(nucPattern)+1; ++k)
	     {
		 binarystr[k] = binarystr[k] + matchPattern(infix(seq,k,k+length(nucPattern)),nucPattern);
	         counts = counts + binarystr[k];
	       }
 
             printBinary(binarystr);
	     std::cout << '\t'<< nucPattern << '\t';
             std::cout << ids[i] << '\t'; 
	     std::cout << seqs[i] << '\t';
	     std::cout << counts << '\t';
   	     std::cout << std::endl;

      }

      clear(ids);
      clear(seqs);

    }
    return 0;
}

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
//#include <seqan/basic.h>
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
int main(int argc, char *argv[]){

  if ( argc <2 ) 
  { 
     std::cerr << "Call: binary fasta pattern seqlen winLen; Example: ./binary file.fa AA \n"; 
     return 1;
    }
  
   CharString   seqFileName = argv[1];
   String<Dna5> nucPattern  = argv[2];
   //unsigned     seqLen  = atoi(argv[3]);
   //unsigned     winLen  = atoi(argv[4]);
   

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

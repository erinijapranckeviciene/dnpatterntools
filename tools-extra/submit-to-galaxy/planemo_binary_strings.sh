planemo tool_init --force \
                    --id 'dnpattern_binary_strings' \
                    --name 'Transform FASTA sequences into 0/1 strings' \
                    --requirement binstrings@1.0 \
                    --example_command 'sh binary_strings.sh ../data/seq25000.fasta  'AA CC CG' ../data/seq25000.fasta.binary.tabular' \
                    --example_input ../data/seq25000.fasta \
                    --example_input "AA CC GG" \
                    --example_output ../data/seq25000.fasta.binary.tabular \
                    --test_case \
                    --cite_url 'https://github.com/erinijapranckeviciene/DNPatternTools' \
                    --help_from_command 'sh binary_strings.sh'
#
#echo "Transform the fasta into binary representation of dinucleotide occurrences for these dinucleotides AA CC GG"

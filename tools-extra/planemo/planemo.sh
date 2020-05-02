#!/bin/sh
# generate xml wrappers to tools
#########################################################################
#binary_strings.sh
#planemo tool_init --force \
#                    --id 'dnp-binary-strings' \
#                    --name 'binary_strings' \
#                    --requirement dnp-binstrings@1.0 \
#                    --example_command 'sh binary_strings.sh seq25000.fasta "AA AC" seq25000.fasta.binary.tabular' \
#                    --example_input seq25000.fasta \
#                    --example_input "AA AC" \
#                    --example_output seq25000.fasta.binary.tabular \
#                    --test_case \
#                   --cite_url 'https://github.com/erinijapranckeviciene/dnpatterntools' \
#                    --help_from_command 'sh binary_strings.sh'
###########################################################################
#compute_composite.sh
#planemo tool_init --force \
#                    --id 'dnp-compute-composite' \
#                    --name 'Composite WW SS RR YY dinucleotide profiles' \
#                    --example_command 'sh dnp-compute-composite.sh compute-composite-input.tabular compute-composite-output.tabular' \
#                    --example_input compute-composite-input.tabular \
#                    --example_output compute-composite-output.tabular \
#                    --test_case \
#                    --cite_url 'https://github.com/erinijapranckeviciene/dnpatterntools' \
#                    --help_from_command 'sh dnp-compute-composite.sh'
#####################################################################################################
#correlation_between_profiles.sh
#planemo tool_init --force \
#                    --id 'dnp-correlation-between-profiles' \
#                    --name 'Pearson correlation between dinucleotides frequency profiles' \
#                    --requirement ushuffle@1.2.2 \
#                    --example_command 'sh dnp-correlation-between-profiles.sh seq25000.di.freq.profiles 146 "AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT" seq25000.di.corr.profiles '\
#                    --example_input seq25000.di.freq.profiles \
#                    --example_input '146' \
#                    --example_input '"AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT"'  \
#                    --example_output seq25000.di.corr.profiles  \
#                    --test_case \
#                    --cite_url 'https://github.com/erinijapranckeviciene/dnpatterntools' \
#                    --help_from_command 'sh dnp-correlation-between-profiles.sh'
########################################################################################################
#fourier_transform.sh
#planemo tool_init --force \
#                    --id 'dnp-fourier-transform' \
#                    --name 'Periodogram of dinucleotide frequency profile' \
#                    --requirement dnp-fourier@1.0 \
#                    --example_command 'sh dnp-fourier-transform.sh seq25000.di.freq.selection.symmetrized.composites.profiles seq25000.di.freq.selection.symmetrized.composites.smoothed.profile 2 3 4' \
#                    --example_input seq25000.di.freq.selection.symmetrized.composites.profiles \
#                    --example_input '2' \
#                    --example_input '3' \
#                    --example_input '4' \
#                    --example_output seq25000.di.freq.selection.symmetrized.composites.smoothed.profiles \
#                    --test_case \
#                    --cite_url 'https://github.com/erinijapranckeviciene/dnpatterntools' \
#                    --help_from_command 'sh dnp-fourier-transform.sh'
############################################################################################################
#plot_selected.sh
#select_range.sh
#planemo tool_init --force \
#                    --id 'dnp-select-range' \
#                    --name 'Select a range within the profile' \
#                    --example_command 'sh dnp-select-range.sh select-range-input.tabular 20 146 "AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT" select-range-output.tabular ' \
#                    --example_input select-range-input.tabular \
#		    --example_input '20' \
#		    --example_input '146' \
#                    --example_input 'AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT' \
#                    --example_output select-range-output.tabular \
#                    --test_case \
#                    --cite_url 'https://github.com/erinijapranckeviciene/dnpatterntools' \
#                    --help_from_command 'sh dnp-select-range.sh'
##################################################################################################
#shuffle_sequences.sh NOT DOING THIS TOOL
#planemo tool_init --force \
#                    --id 'shuffle_sequences' \
#                    --name 'Shuffle nucleotides in fasta' \
#                    --requirement ushuffle@1.2.2 \
#                    --example_command 'sh shuffle_sequences.sh seq1000.fasta 2 seq100shuffled.fasta' \
#                    --example_input seq1000.fasta \
#                    --example_input '2' \
#                    --example_output seq1000shuffled.fasta \
#                    --test_case \
#                    --cite_url 'https://github.com/erinijapranckeviciene/dnpatterntools' \
#                    --help_from_command 'sh shuffle_sequences.sh'
###################################################################################################
#smooth.sh
#planemo tool_init --force \
#                    --id 'dnp-smooth' \
#                    --name 'Smoothing of dinucleotide frequency profile' \
#                    --requirement dnp-fourier@1.0 \
#                    --example_command 'sh dnp-smooth.sh smoothing-input.tabular 3 4 smoothed-output.tabular' \
#                    --example_input smoothing-input.tabular \
#                    --example_input '3' \
#                    --example_input '4' \
#                    --example_output smoothed-output.tabular \
#                    --test_case \
#                    --cite_url 'https://github.com/erinijapranckeviciene/dnpatterntools' \
#                    --help_from_command 'sh dnp-smooth.sh'

###################################################
#subset_dinuc_profile.sh
#planemo tool_init --force \
#                    --id 'dnp-subset-dinuc-profile' \
#                    --name 'Frequency profiles of all dinucleotides in fasta' \
#                    --requirement dnp-diprofile@1.0 \
#                    --example_command 'sh subset_dinuc_profile.sh diprofile-input.fasta "AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT" diprofile-output.tabular' \
#                    --example_input diprofile-input.fasta \
#                    --example_input 'AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT' \
#                    --example_output diprofile-output.tabular \
#                    --test_case \
#                    --cite_url 'https://github.com/erinijapranckeviciene/dnpatterntools' \
#                    --help_from_command 'sh dnp-subset-dinuc-profile.sh'

#symmetrize.sh
#planemo tool_init --force \
#                    --id 'dnp-symmetrize' \
#                    --name 'Symmetrize dinucleotide frequency profiles' \
#                    --example_command 'sh dnp-symmetrize.sh symmetrize-input.tabular symmetrize-output.tabular' \
#                    --example_input symmetrize-input.tabular \
#                    --example_output symmetrize-output.tabular \
#                    --test_case \
#                    --cite_url 'https://github.com/erinijapranckeviciene/dnpatterntools' \
#                    --help_from_command 'sh dnp-symmetrize.sh'

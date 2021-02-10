offset_map['jp'] = Hash[
  35,-1,
  52,1,
  54,-1,
  82,-1,
  87, 14, # BEGIN file version 3 beta
  123,1,
  243,1,
  2676,649, #skips all books

  
  # 87, 20, # BEGIN file version 2
  # 129,1,
  # 249,1,
  # 2690,654, #skips all books
  # 3382,2,
  # 3405,1,
  # 4345,1,
]
# The need for a concat map is an artifact of scummtr's binary output. 
# It was converted from the raw output pretty crappily:
#     1. Remove all control codes except for null; remove weird char 63731
#     2. Replace one or more instances of null with a single newline.
# A more attentive method would likely eliminate the need for concatenation.
#
# UPDATE:
#   The new method does the following:
#     1. cancel ACK and BEL newline: (\x07|\x06)([^\x00]?)\x00 to $^N
#     2. cancel EOT newline on word-match only: \x04(\w)\x00 to $^N
#     3. strip controls, except null, and weird symbol: (\x{f8f3}|[\x01-\x1F]) to ''
#     4. replace consecutive null with single newline: \x00+ to \r\n
#
# New version tweaks:
#  1. EOT check is now "(\w)?"
#  2. EOT-BEL is removed before #1 above to eliminate false positives on BEL-NUL

concat_map['jp'] = Hash[
  3585,1, # Em-Null. Need more examples.

  # 478,1,  # BEGIN basic method concatenations
  # 2046,1,
  # 2082,1,
  # 2095,1,
  # 2626,1,
  # 2628,1,
  # 2630,1,
  # 2632,1,
  # 3409,1,
  # 3413,1,
  # 3417,1,
  # 3421,1,
  # 3441,1,
  # 3450,1,
  # 3455,1,
  # 3461,1,
  # 3474,1,
  # 3498,1,
  # 3505,1,
  # 3524,1,
  # 3526,1,
  # 3540,1,
  # 3621,1,
  # 3627,1,
  # 3630,1,
  # 3653,1,
  # 3961,1,
  # 4630,1,
  # 4632,1,
  # 4689,1,
  # 4691,1,
  # 5764,1, # BEGIN stupid bone sequence
  # 5766,1,
  # 5768,1,
  # 5770,1,
  # 5777,1,
  # 5779,1,
  # 5781,1,
  # 5783,1,
  # 5790,1,
  # 5792,1,
  # 5794,1,
  # 5796,1,
  # 5806,1,
  # 5808,1,
  # 5810,1,
  # 5812,1,
  # 5819,1,
  # 5821,1,
  # 5823,1,
  # 5825,1,
  # 5832,1,
  # 5834,1,
  # 5836,1,
  # 5838,1,
  # 5845,1,
  # 5847,1,
  # 5849,1,
  # 5851,1,
  # 5858,1,
  # 5860,1,
  # 5862,1,
  # 5864,1,
  # 5871,1,
  # 5873,1,
  # 5875,1,
  # 5877,1,
  # 5884,1,
  # 5886,1,
  # 5888,1,
  # 5890,1,
  # 5897,1,
  # 5899,1,
  # 5901,1,
  # 5903,1,
  # 5910,1,
  # 5912,1,
  # 5914,1,
  # 5916,1, # END stupid bone sequence
]

## Here's all the russian stuff.

def find_russian(cleaned_line, pre_cleaned_line,searcher_hash,searcher)
  if cleaned_line === ''
    puts "ru[]:"
  elsif pre_cleaned_line.include? '\255\003'
    searchable_array = pre_cleaned_line.split('\255\003')
    combined_line = searchable_array.inject('') do |all_lines,line|
      searchable_line = line
                        .gsub('"','`')
                        .gsub(' -- ','-- ')
      # puts "--#{searchable_line}"
      found = searcher_hash[searchable_line]
      if found
        all_lines += searcher[found+1].to_s + ' '
      end
    end
    puts "ru[]: " + combined_line.to_s.strip.gsub('`','"')
  else
    searchable_line = cleaned_line
                    .gsub('"','`')
                    .gsub(' -- ','-- ')

    found = searcher_hash[searchable_line] ||
            searcher_hash[searchable_line.downcase] 
    if found
      puts "ru[]: #{searcher[found+1].gsub('`','"')}"
    else
      puts "ru[]: (line omitted in locale)"
    end
  end
end

#-- POTENTIAL Non-code fixes
#Line 2635: removed extraneous "Xa!"

# The following maps the lines from MI2SE to a hash for fast

ru_fn = "#{script_loc}/#{game}_ru.txt"
searcher = File.readlines(ru_fn, encoding: 'bom|utf-8').map { |line| line.chomp }
searcher_hash = Hash[searcher.map.with_index.to_a]


# Pre-cleaned line is used for Russian search (removed from ScummSync):
        # pre_cleaned_line = @files[locale][pos].to_s
        #                 .gsub(/@+/,'')
        #                 .gsub('^','...')
        # cleaned_line = pre_cleaned_line
        #                 .gsub(/(\\\w{3})+/,' ')
        #                 .gsub(/\s+/,' ')
        #                 .gsub(/^\u00a0/,'') #leading non-breaking space
        #                 .strip
        # puts @files[locale][pos]
        # find_russian(cleaned_line,pre_cleaned_line,searcher_hash,searcher) if locale == 'en'

# print searcher_hash
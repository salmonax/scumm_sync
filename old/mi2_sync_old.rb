require './mi2_locales.rb'
include MI2

locales = MI2::locales
offset_map = MI2::offset_map
concat_map = MI2::concat_map

script_loc = './scumm_text'
game = 'mi2'
file = {}

offset = {}
locales.each do |locale|
  offset[locale] = offset_map[locale][0] || 0
  offset_map[locale][0] &&= nil
end

locales.each do |locale|
    fn = "#{script_loc}/#{game}_#{locale}.txt"
    file[locale] = File.readlines(fn, encoding: 'bom|utf-8')
end

start = 600
items_to_show = 1


locales.each do |locale|
  pos = 0
  stretch_pos = start + offset[locale]
  puts "#{locale}: #{pos}, #{stretch_pos}"
  while pos < stretch_pos
    # puts "#{locale}: #{pos}, #{stretch_pos}"
    remap = offset_map[locale][pos]
    concat = concat_map[locale][pos]
    if remap || concat
      offset[locale] += remap || concat
      offset_map[locale][pos] = concat_map[locale][pos] = nil
      if remap && remap < 0
        (remap+1).abs.times do |n|
          offset_map[locale][pos+n+remap+1] = 0
        end
      end
      stretch_pos = start + offset[locale]
    end
    pos += 1
  end
  # puts "#{locale}: #{start + offset[locale]}... #{stretch_pos}"
end

# locales.each do |locale|
#   puts file[locale].size
# end

items_to_show.times do |n|
  puts "-- #{n+start} --"
  locales.each do |locale|
    pos = n+offset[locale]+start
    concat = concat_map[locale][pos]
    remap = offset_map[locale][pos] || concat
    if remap
      offset[locale] += remap
      offset_map[locale][pos] = nil
      pos = n+offset[locale]+start
      print "#{locale}[#{pos}]: "
      if remap < 0 
        puts "(line omitted in locale)"
        (remap+1).abs.times do |n|
          # puts offset_map[locale][pos+n+1]
          puts pos+n+1
          offset_map[locale][pos+n+1] = 0
        end
      elsif remap == 0
        puts "(line omitted in locale)"
      else
        unless concat
          print file[locale][pos]
        else
          #umm.. should maybe do a concat.times
          puts (file[locale][pos-concat] + ' ' + file[locale][pos]).tr("\r\n",'')
        end
      end
    else
      print "#{locale}[#{pos}]: "
    end
    print "\n" if pos < 0
    next if pos < 0 || remap
    pre_cleaned_line = file[locale][pos].to_s
                    .gsub(/@+/,'')
                    .gsub('^','...')
    cleaned_line = pre_cleaned_line
                    .gsub(/(\\\d{3})+/,' ')
                    .gsub(/\s+/,' ')
                    .strip
    puts cleaned_line
    # puts file[locale][pos]
    # find_russian(cleaned_line,pre_cleaned_line,searcher_hash,searcher) if locale == 'en'

  end
  puts
end

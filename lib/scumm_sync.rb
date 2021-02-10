class ScummSync
  attr_reader :offset_map, :offsets, :files, :clean, :load_xml, :synced, :build_synced_hash, :locales, :synced_by_line, :game
  def initialize (data,text_path='./public/scumm_text',speech_path='./public/scumm_speech')
    @data = data
    @game = data[:game]
    @locales = data[:locales]
    @text_path = text_path
    @speech_path = speech_path
    @files = read_lines
    @eofs = set_eofs
    @synced = @locales.inject({}) { |h,l| h[l] = {}; h }
    @synced_by_line = []
    init_offsets
  end

  def init_offsets
    # This clones the offset map
    @offset_map = Marshal.load(Marshal.dump(@data[:offset_map]))
    @concat_map = Marshal.load(Marshal.dump(@data[:concat_map]))
    @offsets = set_first_offsets
  end

  def set_eofs
    eofs = {}
    @locales.each do |locale|
      eofs[locale] = @files[locale].size
    end
    eofs
  end

  def read_lines
    files = {}
    @locales.each do |locale|
      fn = "#{@text_path}/#{@game}_#{locale}.txt"
      files[locale] = File.readlines(fn, encoding: 'bom|utf-8')
    end
    files
  end

  def set_first_offsets
    offset = {}
    @locales.each do |locale|
      offset[locale] = @offset_map[locale][0] || 0
      @offset_map[locale][0] &&= nil
    end
    offset
  end

  def adjust_unshown_offsets(start)
    @locales.each do |locale|
      pos = 0
      stretch_pos = start + @offsets[locale]
      # puts "#{locale}: #{pos}, #{stretch_pos}"
      while pos < stretch_pos
        # puts "#{locale}: #{pos}, #{stretch_pos}"
        remap = @offset_map[locale][pos]
        concat = @concat_map[locale][pos]
        if remap || concat
          @offsets[locale] += remap || concat
          @offset_map[locale][pos] = @concat_map[locale][pos] = nil
          if remap && remap < 0
            (remap+1).abs.times do |n|
              @offset_map[locale][pos+n+remap+1] = 0
            end
          end
          stretch_pos = start + @offsets[locale]
        end
        pos += 1
      end
      # puts "#{locale}: #{start + @offset[locale]}... #{stretch_pos}"
    end
  end

  def self.clean(line)
    line.to_s
      .gsub(/@+/,'')
      .gsub('^','...')
      .gsub(/(\\\w{3})+/,' ') # Hex codes to one space
      .gsub(/\s+/,' ')
      .gsub(/^\u00a0/,'') #leading non-breaking space
      .strip
  end

  def clean(line)
    line.to_s
      .gsub(/@+/,'')
      .gsub('^','...')
      .gsub(/(\\\w{3})+/,' ') # Hex codes to one spac
      .gsub(/\s+/,' ')
      .gsub(/^\u00a0/,'') #leading non-breaking spacee
      .strip
  end

  def load_xml
    print "Loading XML from files..."
    @locales.each do |locale|
      # puts "#{@speech_path}/#{@game}_#{@locale}/*.xml"
      next if locale == 'ru'
      Dir.glob("#{@speech_path}/#{@game}_#{locale}/*.xml") do |file_path|
        if file_path.split('/').last !~ /^unused.*/
          # puts file_path
          positions = grab_positions_from_xml(file_path)
          positions.each do |pos|
            ogg_file_path = file_path.sub(/.xml\Z/,'.ogg').sub(/\A\.\/public/,'.')
            @synced[locale][pos] ||= {}
            @synced[locale][pos].merge!({ speech: ogg_file_path })
          end

        end
      end
    end
    puts "Done!"
  end

  def grab_positions_from_xml(file_path)
    return File.readlines(file_path)[6]
            .sub(/[^>]*>/,'')
            .sub(/<.*/,'')
            .split(',')
            .map(&:to_i)
  end

  def alt_xml
    puts "--- XML slurping ---"
    xml_lines = []
    @locales.each do |locale|
      next if (locale != 'en' && locale != 'ru')
      n = 0
      files = Dir.glob("#{@speech_path}/#{@game}_#{locale}/*.xml").sort
      files.each do |file_path|
        if file_path.split('/').last !~ /^unused.*/
          xml_lines[n] ||= {}
          pos = File.readlines(file_path)[6]
            .sub(/[^>]*>/,'')
            .sub(/<.*/,'')
            .split(',')

          # xml_lines[n][locale] = clean(@files[locale][pos])
          xml_lines[n][locale] = file_path
          ogg_file_path = file_path.sub(/.xml\z/,'.ogg')
          n += 1
        end
      end
    end
    pp xml_lines
  end

  def ft_en_ru_kludge
    # puts "--- XML slurping ---"
    print "Loading en_ru kludge for Full Throttle..."
    files = {}
    %w{en ru}.each do |locale|
      files[locale] = Dir.glob("#{@speech_path}/#{@game}_#{locale}/*.xml").sort
    end

    files['en'].each_with_index do |file_path,i|
      ru_path = files['ru'][i]
      if file_path.split('/').last !~ /^unused.*/
        # xml_lines[n] ||= {}
        pos_array = File.readlines(file_path)[6]
          .sub(/[^>]*>/,'')
          .sub(/<.*/,'')
          .split(',')
          .map(&:to_i)
        # pp pos_array

        pos_array.each do |pos|
          sync_pos = @synced['en'][pos][:sync_pos]
          ogg_ru_path = ru_path.sub(/.xml\Z/,'.ogg').sub(/\A\.\/public/,'.')
          @synced_by_line[sync_pos]['ru'].merge!({ speech: ogg_ru_path })

          # @synced[locale][pos] ||= {}
          # @synced[locale][pos].merge!({ speech: ogg_file_path })
        end
        # puts files['ru'][i]
      end
    end
    puts "Done!"
  end


  def build_synced_hash
    eof_count = 0
    n = 0
    while eof_count < @locales.size do
      @locales.each do |locale|
        line_content = ''
        pos = n+@offsets[locale]
        eof_count += 1 if @eofs[locale] == pos
        concat = @concat_map[locale][pos]
        remap = @offset_map[locale][pos] || concat
        if remap
          @offsets[locale] += remap
          @offset_map[locale][pos] = nil
          pos = n+@offsets[locale]
          # print "#{locale}[#{pos}]: "
          if remap < 0
            (remap+1).abs.times do |n|
              @offset_map[locale][pos+n+1] = 0
            end
          end
          if remap <= 0
            line_content = "(line omitted in locale)"
          elsif concat
            line_content = (@files[locale][pos-concat] + ' ' + @files[locale][pos]).tr("\r\n",'')
          else
            line_content = clean(@files[locale][pos])
          end
        elsif pos < 0
            line_content = "(before start of file)"
        else
          line_content = clean(@files[locale][pos])
        end
        @synced[locale][pos] ||= {}
        @synced[locale][pos].merge!({ line: line_content, sync_pos: n })

        @synced_by_line[n] ||= {}
        # @synced_by_line[n][locale] = { line: line_content }
        @synced_by_line[n][locale] = @synced[locale][pos]
      end
      n += 1
    end
  end

  def print_synced(start, items_to_show)
    adjust_unshown_offsets(start)
    eof_count = 0
    items_to_show.times do |n|
      if @locales.size == eof_count
        puts "---- END OF FILE FOR ALL LOCALES --"
        return
      end
      puts "-- #{n+start} --"
      @locales.each do |locale|
        pos = n+@offsets[locale]+start
        eof_count += 1 if @eofs[locale] == pos
        concat = @concat_map[locale][pos]
        remap = @offset_map[locale][pos] || concat
        if remap
          @offsets[locale] += remap
          @offset_map[locale][pos] = nil
          pos = n+@offsets[locale]+start
          print "#{locale}[#{pos}]: "
          if remap < 0
            (remap+1).abs.times do |n|
              @offset_map[locale][pos+n+1] = 0
            end
          end
          if remap <= 0
            puts "(line omitted in locale)"
          elsif concat
            puts (@files[locale][pos-concat] + ' ' + @files[locale][pos]).tr("\r\n",'')
          else
            puts clean(@files[locale][pos])
          end
        else
          print "#{locale}[#{pos}]: "
        end
        print "\n" if pos < 0
        next if pos < 0 || remap
        puts clean(@files[locale][pos])
      end
      puts
    end
    init_offsets
  end
end
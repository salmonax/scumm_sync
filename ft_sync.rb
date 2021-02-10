require './lib/ft_offsets.rb'
require './lib/scumm_sync.rb'
require 'pp'
require 'yaml'


ft_data = FT::data
ft_sync = ScummSync.new(ft_data)
ft_sync.load_xml
ft_sync.build_synced_hash
ft_sync.ft_en_ru_kludge

# File.open("./data/#{ft_sync.game}.yaml","w") do |f|
#   f.write(YAML.dump(ft_sync))
# end



# pp ft_sync.synced_by_line




# mi2_sync.print_synced start, items_to_show
# ft_sync.print_synced 3981,10

# ft_sync.alt_xml

# pp ft_sync.synced

## UGH.. remember that there are multiple XML lines that need to be accounted for
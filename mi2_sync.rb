require './mi2_offsets.rb'
require './lib/scumm_sync.rb'
include MI2

mi2_data = MI2::data
mi2_sync = ScummSync.new(mi2_data)
# mi2_sync.print_synced start, items_to_show

mi2_sync.print_synced 6903,7000
# mi2_sync.print_synced 1,7000
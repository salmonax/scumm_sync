module MI2
  def self.game; 'mi2' end
  def self.locales; %w{en de fr it jp} end

  def self.offset_map(offset_map={})
    # Book are on lines 2662-3639
    # Their translations aren't consistent
    #   Italian and French are in order, German and Japanese aren't.
    #   But really, they're all over the place
    offset_map['en'] = Hash[
      0,-1,
      88,5,
      2171,-1,  # Chapter 1 title
      2665,978, # Skips all books
      4666,3,
      6233,-1,  # Chapter 2 title
      6586,8,
      6727,-1,  # Chapter 3 title
      7519,16,
      7667,2,
      7685,32,
    ]
    offset_map['de'] = Hash[
      0,1,
      90,16,
      346,1,
      1790,2,
      1996,3,
      2190,1,
      2199,1,
      2512,1,
      2688,1067, #skips all books
      3768,1,
      4085,1,
      4114,1,
      4160,1,
      4782,3,
      6046,4,
      6080,2,
      6355,1,
      6603,2,
      6712,8,
      6793,2,
      6855,1,
      7131,1,
      7394,2,
      7412,1,
      7653,16,
      7730, 18,
      7819,22,
      7857,32,
    ]
    offset_map['fr'] = Hash[
      0,1,
      90, 26,
      356,1,
      1800,2,
      2006,3,
      2200,1,
      2209,1,
      2522,1,
      2698, 1001, #skips all books
      3712,1,
      3758,1,
      3922,1,
      4031,1,
      4060,1,
      4106,1,
      4728,3,
      5992,4,
      6026,2,
      6301,1,
      6424,2,
      6551,2,
      6660,8,
      6725,1,
      6742,2,
      6804,1,
      7080,1,
      7343,2,
      7360,1,
      7362,1,
      7603,16,
      7680,18,
      7769,22,
      7807,32,
    ]

    offset_map['it'] = Hash[
      0,1,
      90, 26,
      356,1,
      1800,2,
      2006,3,
      2200,1,
      2209,1,
      2522,1,
      2698, 1001, #skips all books
      3712,1,
      4029,1,
      4058,1,
      4104,1,
      4726,3,
      5990,4,
      6024,2,
      6299,1,
      6547,2,
      6656,8,
      6737,2,
      6799,1,
      7075,1,
      7338,2,
      7357,1,
      7597,16,
      7674,18,
      7763,22,
      7801,32,
    ]

    offset_map['jp'] = Hash[
      0,0,
      35,-1,
      52,1,
      54,-1,
      82,-1,

      87, 14, # BEGIN file version 3 beta
      126,-1,
      123,1,
      243,1,
      2676,649, #skips all books
      4305,1,
      6268,5,
      6464,1,
      7199,-3,
      7218,2,
      7259,1, #skips jpn-only Monkey Island title line
      7301,2, #skips FM-towns only credit, sorry James Leiterman!
      7330,4, #more credit skippage, sorry guys!
      7336,1,
      7354,31,
      7555,4
    ]
    offset_map
  end

  def self.concat_map(concat_map={})

    concat_map['jp'] = Hash[
      3584,1, # Em-Null
    ]
    concat_map
  end

  def self.data
    data = {}
    data[:game] = game
    data[:locales] = locales
    data[:offset_map] = prep_empty_locales(offset_map)
    data[:concat_map] = prep_empty_locales(concat_map)
    data
  end

  def self.prep_empty_locales(hash,empty={})
    locales.each { |locale| empty[locale] = [] }
    empty.merge(hash)
  end

end

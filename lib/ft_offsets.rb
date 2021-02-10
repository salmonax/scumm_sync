module FT
  def self.game; 'ft' end
  def self.locales; %w{en de fr it ru} end

  def self.offset_map(offset_map={})
    offset_map['en'] = Hash[
      30,13,
      68,1
    ]
    offset_map['de'] = Hash[
      30,27,
      82,1,
      3204,27, #skip localized credits
      3346,2,  #skip separate de-only Wendy credit
      3353,-2, #no sizable Bill credit
    ]
    offset_map['fr'] = Hash[
      30,27,
      82,1,
      3204,23, #skip localized credits
      # 3250,1, #skip fr only Gone Jackals on extra line
    ]

    offset_map['it'] = Hash[
      30,27,
      82,1
    ]

    offset_map['ru'] = Hash[
      2,1,
      31,13,
      65,1,
      67,1,
      71,1,
      144,2,
      522,2,
      529,1,
      551,1,
      599,1,
      1125,1,
      1235,1,
      1247,1,
      1249,1,
      1251,1,
      1253,1,
      1257,1,
      1513,1,
      1612,2,
      1801,1,
      1848,1,
      1872,1,
      1874,1,
      2113,2,
      2737,1,
    ]
    offset_map
  end

  def self.concat_map(concat_map={})
    concat_map['ru'] = Hash[
    ]
    concat_map['fr'] = Hash[
      3249,1, # concat fr-only Gone Jackals on extra line
      3279,1, # pointless "Whiskey & Skirt" concat

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
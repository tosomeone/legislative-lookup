# == Schema Information
#
# Table name: districts
#
#  gid           :integer         not null
#  state         :string(2)
#  cd            :string(3)
#  lsad          :string(2)
#  name          :string(90)
#  lsad_trans    :string(50)
#  the_geom      :geometry        multi_polygon, -1
#  state_name    :string(255)
#  level         :string(255)
#  census_geo_id :string(255)
#

class District < ActiveRecord::Base
  
  def self.lookup(lat, lng)
    all(:conditions => ["ST_Contains(the_geom, GeometryFromText('POINT(? ?)', -1))",lng.to_f,lat.to_f])
  end
  
  def polygon
    @polygon ||= the_geom[0]
  end
  
  def display_name
    if /^[0-9]*$/ =~ name
      "#{state_name} #{name.to_i.ordinalize}"
    else
      "#{state_name} #{name}"
    end
  end
  
  def title
    "#{display_name} #{level_name} District"
  end
  
  def level_name
    LEVELS[level]
  end
  
  LEVELS = {
    "state_upper" => "State Upper Legislative",
    "state_lower" => "State Lower Legislative",
    "federal" => "Congressional"
  }
  
  FIPS_CODES = { 
    "01" => "AL",
    "02" => "AK",
    "04" => "AZ",
    "05" => "AR",
    "06" => "CA",
    "08" => "CO",
    "09" => "CT",
    "10" => "DE",
    "11" => "DC",
    "12" => "FL",
    "13" => "GA",
    "15" => "HI",
    "16" => "ID",
    "17" => "IL",
    "18" => "IN",
    "19" => "IA",
    "20" => "KS",
    "21" => "KY",
    "22" => "LA",
    "23" => "ME",
    "24" => "MD",
    "25" => "MA",
    "26" => "MI",
    "27" => "MN",
    "28" => "MS",
    "29" => "MO",
    "30" => "MT",
    "31" => "NE",
    "32" => "NV",
    "33" => "NH",
    "34" => "NJ",
    "35" => "NM",
    "36" => "NY",
    "37" => "NC",
    "38" => "ND",
    "39" => "OH",
    "40" => "OK",
    "41" => "OR",
    "42" => "PA",
    "44" => "RI",
    "45" => "SC",
    "46" => "SD",
    "47" => "TN",
    "48" => "TX",
    "49" => "UT",
    "50" => "VT",
    "51" => "VA",
    "53" => "WA",
    "54" => "WV",
    "55" => "WI",
    "56" => "WY",
    "60" => "AS",
    "64" => "FM",
    "66" => "GU",
    "68" => "MH",
    "69" => "MP",
    "70" => "PW",
    "72" => "PR",
    "74" => "UM",
    "78" => "VI"
    
    }
  STATES = FIPS_CODES.invert.freeze
end


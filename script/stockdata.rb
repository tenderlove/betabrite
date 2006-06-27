require 'open-uri'
require 'ostruct'
require 'csv'
require 'uri'

class StockData
  include Enumerable
  
  SOURCE_URL = "http://finance.yahoo.com/d/quotes.csv"
  
  #These are the symbols I understand, which are limited
  OPTIONS = {
    :symbol=>"s",
    :name=>"n",
    :change=>"c1",
    :last_trade=>"l1",
    :last_trade_date=>"d1",
    :last_trade_time=>"t1",
    :open=>"o",
    :high=>"h",
    :low=>"g",
    :high_52_week=>"k",
    :low_52_week=>"j"
  }
  
  def initialize(symbols, options = [ :symbol,
                                      :name,
                                      :last_trade,
                                      :last_trade_date,
                                      :last_trade_time,
                                      :change])
    @symbols = symbols
    @options = options
    @data = nil
  end
  
  def each
    data.each do |row|
      struct = OpenStruct.new(Hash[*(@options.zip(row).flatten)])
      yield struct
    end
  end
  
  def each_hash
    data.each do |row|
      hash = Hash[*(@options.zip(row).flatten)]
      yield hash
    end
  end
  
  def refresh
    symbol_fragment = @symbols.join "+"
    option_fragment = @options.map{|s| OPTIONS[s] }.join ""
    url = SOURCE_URL + "?s=#{URI.escape(symbol_fragment)}&f=#{option_fragment}"
    @data = []
    CSV.parse open(url).read do |row|
      @data << row
    end
  end
  
  def data
    refresh unless @data
    @data
  end
end

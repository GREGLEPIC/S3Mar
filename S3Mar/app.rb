require 'bundler'
Bundler.require
$:.unshift File.expand_path("./../lib/app", __FILE__)
require 'get_townhall'



scrapper = Scrapper.new
scrapper.get_townhall_email(scrapper.get_townhall_url_complete)
scrapper.convert_to_json
scrapper.save_as_spreadsheet
scrapper.save_as_csv
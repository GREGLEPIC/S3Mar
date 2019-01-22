require 'nokogiri'
require 'open-uri'
require 'json'
require 'google_drive'
require 'csv'

#Liste de tout les require nécessaire


#Déclaratation de la classe Scrapper
class Scrapper

#déclaration de la variable de classe, qui est ici un array	
@@townhall_hash = []

#Dès le départ on veut que les méthodes suivantes s'éxcutent pour chaque instance	
def initialize 
	get_townhall_email(get_townhall_url)
	convert_to_json
	save_as_spreadsheet
	save_as_csv
end

# Cette méthode récupère les urls et les mets toutes au même format
def get_townhall_url
	townhall_url = []
	townhall_url_complete = []
	doc = Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html'))
	doc.css('a').css('.lientxt').each do |node|

		townhall_url << node['href'][1..-1]
	end

	townhall_url.each do |townhall_url|

		townhall_url_complete << "https://www.annuaire-des-mairies.com#{townhall_url}"
	end	
	return townhall_url_complete
end

#Cette méthode récupère les url aux bons formats et va chercher les emails des mairies
#Puis les stoques dans hash
def get_townhall_email(townhall_url_complete)
	town = []
	email_adress = []

	townhall_url_complete.each do |townhall_url_complete|
		doc = Nokogiri::HTML(open(townhall_url_complete))
		doc.xpath('//html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').each do |node|

			email_adress << node.text
		end
	end

	doc = Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html'))
	doc.css('a').css('.lientxt').each do |node|

		town << node.text
	end

	@@townhall_hash = Hash[town.zip(email_adress)]
end

#Cette méthode converti au format json les données récupéré
def convert_to_json
	File.open("/home/julien/S3Mar/db/townhall_hash.json","w") do |f|
		f.write(@@townhall_hash.to_json)
	end

#Cette méthode converti au format spreadsheet les données récupéré
	def save_as_spreadsheet
		session = GoogleDrive::Session.from_config("config.json")
		ws = session.spreadsheet_by_key("1sIO1C2d-xMglrGwMW4pJsszQhdVrW5a-VfljtaE3-3s").worksheets[0]
		@@townhall_hash.each.with_index do |body, i| 
			ws[i + 1, 1] = body[0]
			ws[i + 1, 2] = body[1]
			sleep(1)
			ws.save
		end
	end
end


#Cette méthode converti au format CSV les données récupéré
def save_as_csv
	CSV.open("/home/julien/S3Mar/db/towhn_hall.csv", "w") do |csv|
		@@townhall_hash.each do |k|
			csv << [k[0], k[1]]
		end
	end
end
end


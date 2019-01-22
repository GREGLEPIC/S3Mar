
def menu
	puts "Bienvenue sur ce magnifique programme qui extrait des données et les ressort au format de votre choix : "
	puts "1 - Crééra un fichier .json"
	puts "2 - Crééra un google spread sheet"
	puts "3 - Crééra un fichier .csv"
	puts "4 - JESUISGOURMANDJEVEUXTOUT"
	puts "5 - Me suis planté, je veux rien en fait. Lol déso pas déso."
	choix = gets.chomp.to_i
end

def selection(menu)
	case
	when 1 scrapper = Scrapper.new
		scrapper.convert_to_json
	when 2 scrapper = Scrapper.new
		scrapper.save_as_spreadsheet
	when 3 scrapper = Scrapper.new
		scrapper.save_as_csv
	when 4 scrapper = Scrapper.new
		scrapper.convert_to_json
		scrapper.save_as_spreadsheet
		scrapper.save_as_csv
	when 5 puts "Nope, il faut quand même faire un choix ! "
	else return 
	end
end
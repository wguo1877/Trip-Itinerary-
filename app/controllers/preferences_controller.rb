require 'net/http'

class PreferencesController < ApplicationController
	
	CONSUMER_KEY = "amEkK6sGLXqfjenxefspjQ"
	SECRET = "rBwPXjfYITNUFxB6A1L4_YWp0ug"
	TOKEN = "dBXdYpzF9pRe6ML4EqnAtrvkEWxcGxq2"
	TOKEN_SECRET = "tOE-UZfaD58RfJwgOrKkevN-2hY"

	def index
	end
	
	def show_results


		Location.destroy_all
		#iterate over keys in map, if preference is in map, append key to list 'activities'
		categories = {"airsoft" => ["shooting", "action", "airsoft"], "amusementparks" => ["action", "amusement parks", "family activities"], "aquariums" => ["fish", "family activities"], "archery" => ["Archery"], "beaches" => ["fish", "beaches", "family activities", "water activities"], "bicyclepaths" => ["biking", "exercise"], "boating" => ["boating", "exercise", "water activities"], "climbing" => ["exercise", "climbing", "action"], "scuba" => ["water activities", "exercise", "fish", "action", "scuba diving", "nature"], "fishing" => ["water activities", "fish", "family activities", "fishing", "nature"], "golf" => ["golf"], "hiking" => ["hiking", "nature"], "nudist" => ["adult activities", "nudist"], "parasailing" => ["parasailing", "action", "water activities"], "rafting" => ["exercise", "water activities", "rafting/kayaking"], "skiing" => ["action", "winter activities", "skiing"], "skydiving" => ["action"], "waterparks" => ["action", "amusement parks", "family activities", "water activities"], "museums" => ["family activities", "museums"], "sportsteams" => ["professional sports", "family activities"], "eroticmassage" => ["adult activities"], "weddingchappels" => ["wedding"], "venues" => ["wedding"], "cannabisdispensaries" => ["recreational marijuana"], "adultentertainment" => ["adult activities"], "riceshop" => ["rice"]}
		activities = Set.new []
		category1 = params['p1']
		category2 = params['p2']
		category3 = params['p3']

		categories.keys.each do |category|
			
			if categories[category].include? category1  
				activities.add(category)

			elsif categories[category].include? category2 
				activities.add(category)

			elsif categories[category].include? category3 
				activities.add(category) 
			end

		end 

		activities.each do |activity|

			if activities.length > 12
				limit = 1
			else 
				limit = 12 / activities.length
			end
			
		#uri = URI("https://api.yelp.com/v2/search/?oauth_consumer_key=amEkK6sGLXqfjenxefspjQ&oauth_token=JiU_ckw_JBoRtjsD6c12enZrvvgYDuV5&oauth_signature_method=HMAC-SHA1&oauth_signature=GPJ842OeLIbiY-kvMJKQ56KVBlQ&oauth_timestamp=1476549110&oauth_nonce&location=Houston&sort=2&limit=5&category_filter=food")			
		#uri = URI("https://api.yelp.com/v2/search/?oauth_nonce=kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg&oauth_consumer_key=amEkK6sGLXqfjenxefspjQ&oauth_token=_iZ4KaMzE1dWZx3N4_l2ULyFu8M-Bh_6&oauth_signature_method=HMAC-SHA1&oauth_signature=Ve-G1qysc3ip9XdAzA8vH9durBI&oauth_timestamp=1476551697&location=Houston&category_filter=food")
		#response = Net::HTTP.get(uri) 

		#hash = JSON.parse response
		
		

		consumer = OAuth::Consumer.new( CONSUMER_KEY,SECRET, {:site => "http://api.yelp.com", :signature_method => "HMAC-SHA1", :scheme => :query_string})

		access_token = OAuth::AccessToken.new( consumer, TOKEN,TOKEN_SECRET)

		#hash = access_token.get("/v2/search?location=new+york").

		hash = JSON.parse(access_token.get("/v2/search?location=new+york").body)

		businesses = hash["businesses"]

			businesses.each do |business|

				name = business["name"]
				url = business["url"]
				rating = business["rating"]
				city = business["location"]["city"]
				description = business["snippet_text"]

				Location.create(title:name, url: url, yelp_rating:rating, city:city, description:description)


			end	


		end

		#load locations in database
		@locations = Location.all

	end
end

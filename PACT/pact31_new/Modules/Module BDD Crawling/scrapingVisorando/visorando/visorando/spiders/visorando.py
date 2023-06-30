import scrapy

class Visorando(scrapy.Spider):
	name="Visorando"
	start_urls=["https://www.visorando.com/itineraires-randonnees.html"]
	links=list()

	count=0

	def parse(self, response):
		for link in response.css("div.search-block-content > table a::attr(href)"):
			yield response.follow(link, callback=self.parseLink)
				

	def parseLink(self, response):
		for link in response.css("div.search-block-content > table a::attr(href)"):	
			self.count+=1
			yield response.follow(link, callback=self.parseLink)

		for link in response.css(".rando-title-sansDetail a::attr(href)"):
			if link.get() not in self.links:
				self.links.append(link.get())
				yield {"link": link.get().strip()}
import requests, bs4, json, os
import xml.dom.minidom as minidom

def getGPX(url):
	email="alexandre.riabtsev@telecom-paris.fr"
	password="ImGonnaScrapeTheWholeSite!12"
	session=requests.Session()
	data={"email":email, "passwd":password}
	session.post("https://www.visorando.com/index.php?component=user&task=login", data=data)
	randoPage=session.get(url)
	soup=bs4.BeautifulSoup(randoPage.text,"html.parser")
	duration=str(soup.find(text="Durée moyenne: ").parent.next_sibling)
	convertedDuration="-"+"{0:0=2d}".format(int(duration.split('h')[0]))+"-"+duration.split('h')[1]
	downloadPage=session.get(soup.find("a",string="trace GPX")["href"])
	soup=bs4.BeautifulSoup(downloadPage.text,"html.parser")
	gpx=session.get(soup.find("a",string="cliquez-ici")["href"])
	with open(url.split("/")[-2]+convertedDuration+".gpx","w",encoding="utf-8") as f:
		f.write(gpx.text)

def parseGPX(file):
	fileName=os.path.basename(file)
	duration=fileName.split("-")[-2]+":"+fileName.split("-")[-1].split(".")[0]
	tree = minidom.parse(file)
	route=list()
	name=tree.getElementsByTagName("name")[0].firstChild.nodeValue
	description=tree.getElementsByTagName("link")[0].attributes["href"].value
	for trkpt in tree.getElementsByTagName("trkpt"):
		route.append([float(trkpt.attributes['lat'].value),float(trkpt.attributes['lon'].value)])
	JSONObject={"type":"Feature","id":None,"geometry":{"type":"LineString", "coordinates":route}, "geometry_name":None, "properties":{"name":name, "route":"hiking", "duration":duration, "description":description}}
	print(JSONObject)
	return json.dumps(JSONObject)

#getGPX("https://www.visorando.com/randonnee-a-la-decouverte-de-marsanne/")
parseGPX("D:\\OneDrive - telecom-paristech.fr\\TETECH\\PACT\\pact31\\scrapingVisorando\\randonnee-grand-tour-de-thunimont-par-le-vallon-de-04-00.gpx")
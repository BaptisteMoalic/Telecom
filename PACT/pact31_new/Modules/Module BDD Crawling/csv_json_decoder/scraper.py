import requests
import bs4
import json
import os
import xml.dom.minidom as minidom
from xml.parsers.expat import ExpatError
from json_decoder import insertmultiple_to_db


def get_gpx(url):
    """
    Deprecated function
    """

    email = "alexandre.riabtsev@telecom-paris.fr"
    password = "ImGonnaScrapeTheWholeSite!12"
    session = requests.Session()
    data = {"email": email, "passwd": password}
    session.post("https://www.visorando.com/index.php?component=user&task=login", data=data)
    rando_page = session.get(url)
    soup = bs4.BeautifulSoup(rando_page.text, "html.parser")
    duration = str(soup.find(text="Durée moyenne: ").parent.next_sibling)
    converted_duration = "-"+"{0:0=2d}".format(int(duration.split('h')[0]))+"-"+duration.split('h')[1]
    download_page = session.get(soup.find("a", string="trace GPX")["href"])
    soup = bs4.BeautifulSoup(download_page.text, "html.parser")
    gpx = session.get(soup.find("a", string="cliquez-ici")["href"])
    with open(url.split("/")[-2]+converted_duration+".gpx", "w", encoding="utf-8") as f:
        f.write(gpx.text)


def parse_gpx(file):
    """
    Deprecated function
    """
    filename = os.path.basename(file)
    duration = filename.split("-")[-2]+":"+filename.split("-")[-1].split(".")[0]
    tree = minidom.parse(file)
    route = list()
    name = tree.getElementsByTagName("name")[0].firstChild.nodeValue
    description = tree.getElementsByTagName("link")[0].attributes["href"].value
    for trkpt in tree.getElementsByTagName("trkpt"):
        route.append([float(trkpt.attributes['lat'].value), float(trkpt.attributes['lon'].value)])
    json_object = {"type": "Feature", "id": None, "geometry": {"type": "LineString", "coordinates": route},
                   "geometry_name": None, "properties": {"name": name, "route": "hiking", "duration": duration,
                                                         "description": description
                                                         }
                   }

    return json.dumps(json_object)


def get_gpx_to_list(session, url):
    """
    Function that downloads the GPX file from a visorando webpage
    :param session: object containing all the connection information mandatory to download the gpx file
    :param url: link to the webpage to get the gpx from
    :return: list containing the name of the file (with the track duration) and the whole file content as a string
    """

    rando_page = session.get(url)
    soup = bs4.BeautifulSoup(rando_page.text, "html.parser")

    # if no duration field is found, it means this is not an itinerary page, thus the function returns None
    if soup.find(text="Durée moyenne: "):
        duration = str(soup.find(text="Durée moyenne: ").parent.next_sibling)
    elif soup.find(text="Durée moyenne : "):
        duration = str(soup.find(text="Durée moyenne : ").parent.next_sibling)
    elif soup.find(text="Durée de l'auteur : "):
        duration = str(soup.find(text="Durée de l'auteur : ").parent.next_sibling)
    else:
        return None

    # case disjunction for every known format of duration on visorando
    if duration == "Durée inconnue":
        converted_duration = "-00-00"
    elif duration[-1] == "h":
        converted_duration = "-" + "{0:0=2d}".format(int(duration.split('h')[0][-2:])) + "-00"
    elif duration[-3] == "h":  # match(".*[0-9][0-9]$", duration):
        converted_duration = "-" + "{0:0=2d}".format(int(duration.split('h')[0][-2:])) + "-" + duration.split('h')[1]

    elif duration[-5:] == "jours":  # match("^[0-9]* jours$", duration):
        converted_duration = "-" + f"{24*int(duration.split(' ')[0])}" + "-00"

    elif duration[-3:] == "min":  # match("^[0-9]*min", duration):
        converted_duration = "-00-" + "{0:0=2d}".format(int(duration.split('m')[0]))

    else:
        converted_duration = "-" + "{0:0=2d}".format(int(duration.split('h')[0][-2:])) + "-" + duration.split('h')[1]

    downloadlink = soup.find("a", string="trace GPX")

    # if there is no link to a download page for the gpx file, there is no point in registering the itinerary, thus
    # None is returned
    if downloadlink:
        download_page = session.get(downloadlink["href"])
    else:
        return None

    soup = bs4.BeautifulSoup(download_page.text, "html.parser")
    gpxlink = soup.find("a", string="cliquez-ici")

    # if there is no button to download the gpx file, there is no point in registering the itinerary, thus None is
    # returned
    if gpxlink:
        gpx = session.get(gpxlink["href"])
    else:
        return None

    return url.split("/")[-2] + converted_duration + ".gpx", gpx.text


def parse_gpx_to_dict(file):
    """
    Function that turns a gpx tack file into a json formated itinerary (represented in python as a dict)
    :param file: list of two elements, namely the gpx filename and the gpx file content as a string
    :return: dictionnary representing a json formated itinerary
    """

    filename = file[0]
    duration = filename.split("-")[-2]+":"+filename.split("-")[-1].split(".")[0]
    tree = minidom.parseString(file[1])
    route = list()
    name = tree.getElementsByTagName("name")[0].firstChild.nodeValue
    description = tree.getElementsByTagName("link")[0].attributes["href"].value
    for trkpt in tree.getElementsByTagName("trkpt"):
        route.append([float(trkpt.attributes['lat'].value), float(trkpt.attributes['lon'].value)])
    json_object = {"type": "Feature", "id": None, "geometry": {"type": "LineString", "coordinates": route},
                   "geometry_name": None, "properties": {"name": name, "route": "hiking", "duration": duration,
                                                         "description": description
                                                         }
                   }
    return json_object


def get_all_dict_to_list(url_list, starting_index=0, upload_delta=1000):
    """
    Function to download every gpx on visorando and upload them to the database
    :param url_list: list of string representing webpages to get all the gpx from
    :param starting_index: index of the starting point in the list (in case previous attempts failed, in order to
     not start from scratch), usually a multiple of 1000
    :param upload_delta: int indicating the max number of treatments done before uploading, to minimize damage from
     interruptions, 0 means it will only upload after everything is stacked (strongly not recommended)
    :return: number of denied links due to invalid content
    """

    # identifiers in order to be able to download the gpx files
    email = "alexandre.riabtsev@telecom-paris.fr"
    password = "ImGonnaScrapeTheWholeSite!12"
    session = requests.Session()
    data = {"email": email, "passwd": password}
    session.post("https://www.visorando.com/index.php?component=user&task=login", data=data)

    features = {"features": []}
    nonecounter = 0
    counter = 0

    # verify that the starting point is available
    if starting_index >= len(url_list):
        return None

    for url in url_list[starting_index:]:
        try:
            gpx = get_gpx_to_list(session, url)

        # every known type of error deems the gpx as unusable, thus the None value is given
        # the print parts have debug value only, in order to know which link causes which problem to occur
        except ValueError as e:
            gpx = None
            print(url)
            print(repr(e))

        except TypeError as e:
            gpx = None
            print(url)
            print(repr(e))

        except AttributeError as e:
            gpx = None
            print(url)
            print(repr(e))

        except ExpatError as e:
            gpx = None
            print(url)
            print(repr(e))

        if gpx:
            try:
                feature = parse_gpx_to_dict(gpx)
                features["features"].append(feature)
            # ExpatError occurs if the file is not well-formated due to not respected conventions, thus they are
            # corrected before trying again.
            # Somehow randomly throws errors after correction
            except ExpatError:
                feature = parse_gpx_to_dict([gpx[0], gpx[1].replace("&", "&amp;").replace("<<",
                                            "&#60;&#60;").replace(">>", "&#62;&#62;")])
                features["features"].append(feature)

        else:
            nonecounter += 1

        counter += 1

        # upload every [upload_delta] treated links in order to minimize the effects of problems, then flush all
        # already treated features
        if upload_delta:
            if counter % upload_delta == 0:
                print(counter, "done")
                print("Uploading...")
                insertmultiple_to_db(features)
                features["features"] = []
                print("Going for the next ", upload_delta)

    # insert all remaining itineraries in the database
    insertmultiple_to_db(features)

    return nonecounter

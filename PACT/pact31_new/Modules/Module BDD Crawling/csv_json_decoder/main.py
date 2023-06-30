from json_decoder import *
from scraper import *


if __name__ == '__main__':

    url_list = []

    # Optionaly, reset the database
    print("Resetting Database...")
    init_table("peuplage_bdd", True)

    # Start by collecting the government's itineraries and store them into the database
    itinlist = read_json("../itineraires.json")
    print("Uploading the first part...")
    insertmultiple_to_db(itinlist)

    # Get all the links of itinerary pages on visorando
    with open("../links.csv", "r") as f:
        f.readline()
        line = f.readline()
        while line != "":
            url_list.append(line.strip("\n"))
            line = f.readline()

    print("Stacking all itineraries")
    nonecounter = get_all_dict_to_list(url_list)

    if nonecounter is None:
        print("Wrong starting index")
    else:
        print("Done!")
        print("Number of incorrect itineraries: ", nonecounter)


import json
import mysql.connector


def read_json(filename: str):
    """
    Function that turns a JSON formated list of itineraries into an exploitable set of itineraries
    :param filename: name of the file to take the itineraries from
    :return: new dict with a "features" key pointing to a list of itineraries formated the right way for the database
    """

    with open(filename, "r", encoding="utf-8") as file:
        decode = json.load(file)

        newlist = {"type": decode["type"], "features": []}
        for itin in decode["features"]:

            properties = itin["properties"]
            duration = properties["duration"]

            if duration:

                if duration == "2h-3h":
                    duration = "2:30"

                elif duration[-1] == "H" or duration[-1] == "h":
                    duration = duration.strip("PT").replace("H",
                                                            ":").replace("h", ":") + "00"

                elif duration[-1] == "S":
                    duration = duration.strip("PT").replace("H", ":").replace("M", ":").replace("h",
                                                                                                ":").replace("m",
                                                                                                             ":").strip(
                                                                                                                    "S")

                elif duration[-1] == "M" or duration[-1] == "m":
                    duration = duration.strip("PT").replace("H",
                                                            ":").replace("M", ":").replace("h", ":").replace("m",
                                                                                                             ":") + "00"

                    if len(duration) == 4:
                        duration = "00:0"+duration
                    elif len(duration) == 5:
                        duration = "00:"+duration

                elif len(duration) == 1:
                    duration = duration+":00"

                else:
                    duration = duration.strip("PT").replace("H",
                                                            ":").replace("M",
                                                                         ":").replace("h",
                                                                                      ":").replace("m",
                                                                                                   ":").strip("S")

            new_itin = {"type": itin["type"], "geometry": itin["geometry"],
                        "properties": {"route": properties["route"],
                                       "name": properties["name"],
                                       "duration": duration,
                                       "description": properties["description"]
                                       }
                        }

            newlist["features"].append(new_itin)

#        print(newlist["features"][1])

        return newlist


def insertmultiple_to_db(features: dict, db_name: str = "peuplage_bdd"):
    """
    Function to store multiple itineraries into a local database.
    :param features: dict with a "features" key pointing towards a list of JSON formated itineraries
    :param db_name: name of the database to connect to
    :return: None
    """

    # Connect to the database (for now local)
    mydb = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database=db_name
    )
    counter = 0
    for feature in features["features"]:
        insert_to_db(feature, mydb)
        counter += 1
        if counter == 10:
            mydb.commit()
            counter = 0
    mydb.close()


def insert_to_db(feature: dict, mydb=None):
    """
    Function to store an itinerary into a local database.
    :param feature: JSON formated itinerary with all informations
    :param mydb: database to work with
    :return: None
    """

    already_init = True
    if not mydb:
        mydb = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="peuplage_bdd"
        )
        already_init = False

    mycursor = mydb.cursor()

    val = [feature["properties"]["name"], json.dumps(feature["geometry"]), feature["properties"]["route"], "foot",
           feature["properties"]["duration"], feature["properties"]["description"]]

    req = "INSERT INTO Trajet (name, trajet, type, vehicle, trajetTime, commentary,dateAdded) " \
          "VALUES (%s, %s, %s, %s, %s, %s, CURRENT_DATE)"
    mycursor.execute(req, val)

    # if db was not already initialized through parameters, close the connection
    if not already_init:
        mydb.commit()
        mydb.close()


def init_db(reset=False):
    """
    Function to create the local database if it doesn't already exist
    :param reset: boolean to indicate if we want to completely reset the table
    :return:
    """

    mydb = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
    )

    mycursor = mydb.cursor()
    mycursor.execute("SHOW DATABASES")
    db_initiated = False
    for x in mycursor:
        if x == "peuplage_bdd":
            db_initiated = True

    if not db_initiated:
        mycursor.execute("CREATE DATABASE peuplage_bdd")

    mycursor.execute("ALTER DATABASE peuplage_bdd CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci'")

    mydb.commit()
    mydb.close()
    init_table("peuplage_bdd", reset)


def init_table(db_name: str, reset=False):
    """
    Function to create the trajet table inside of the specified database
    :param db_name: name of the database to create the table in
    :param reset: boolean to indicate if we want to completely reset the already existing table
    :return:
    """

    if db_name:
        mydb = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database=db_name
        )
        table_initiated = False
        mycursor = mydb.cursor()
        mycursor.execute("SHOW TABLES")

        for x in mycursor:
            if x == ("trajet",):
                table_initiated = True

        if not table_initiated:
            mycursor.execute("CREATE TABLE Trajet (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(256)" +
                             " CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci', trajet JSON," +
                             " type VARCHAR(256) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci', " +
                             "vehicle VARCHAR(256) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci', " +
                             "trajetTime TIME, " +
                             "commentary VARCHAR(256) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci', " +
                             "dateAdded DATE)")

        else:
            mycursor.execute(
                "ALTER TABLE Trajet MODIFY COLUMN name VARCHAR(256) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci'")
            mycursor.execute(
                "ALTER TABLE Trajet MODIFY COLUMN type VARCHAR(256) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci'")
            mycursor.execute(
                "ALTER TABLE Trajet MODIFY COLUMN vehicle VARCHAR(256) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci'")
            mycursor.execute(
                "ALTER TABLE Trajet MODIFY COLUMN commentary VARCHAR(256) CHARACTER SET 'utf8' " +
                "COLLATE 'utf8_unicode_ci'")

        mycursor.execute("SET GLOBAL max_allowed_packet=16777216")

        if reset:
            mycursor.execute("DELETE FROM trajet")
            mycursor.execute("ALTER TABLE Trajet AUTO_INCREMENT = 1")

        mydb.commit()
        mydb.close()

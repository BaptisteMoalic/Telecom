import re


def save_multiline(line):

    with open("multilines.txt", "a") as file:
        treatment_list = line.strip('\n').split(",")
        track_id = treatment_list[1]
        name = treatment_list[4]
        treatment_list = line.strip('\n').split("\"")
        if len(treatment_list) == 7:
            file.write(track_id + " | " + name + " | " + treatment_list[1] + " | " +
                       treatment_list[3] + " | " + treatment_list[-2].strip("MULTILINESTRING ") + "\n")
        elif len(treatment_list) == 5:
            file.write(track_id + " | " + name + " | " + treatment_list[1] + " | " + " | " +
                       treatment_list[-2].strip("MULTILINESTRING ") + "\n")
        else:
            file.write(track_id + " | " + name + " | " + " | " + " | " +
                       treatment_list[-2].strip("MULTILINESTRING ") + "\n")


def save_line(line):

    with open("lines.txt", "a") as file:
        treatment_list = line.strip('\n').split(",")
        track_id = treatment_list[1]
        name = treatment_list[4]
        treatment_list = line.strip('\n').split("\"")
        if len(treatment_list) == 7:
            file.write(track_id+" | "+name+" | "+treatment_list[1]+" | " +
                                treatment_list[3]+" | " + treatment_list[-2].strip("LINESTRING ")+"\n")
        elif len(treatment_list) == 5:
            file.write(track_id+" | "+name+" | "+treatment_list[1]+" | "+" | " +
                       treatment_list[-2].strip("LINESTRING ")+"\n")
        else:
            file.write(track_id + " | " + name + " | "+" | "+" | " + treatment_list[-2].strip("LINESTRING ") + "\n")


def read_csv(filename):

    end_of_file = False
    linecounter = 1
    counter = 0

    with open("lines.txt", "w", encoding="utf-8") as file:
        file.write("track_id | name | from | to | LINESTRING")

    with open("multilines.txt", "w", encoding="utf-8") as file:
        file.write("track_id | name | from | to | MULTILINESTRING")

    with open(filename, "r", encoding="utf-8") as file:
        file.readline()

        while linecounter < 8000:

            ligne = file.readline()
            if linecounter == 1859:
                print(ligne)
            is_multiline = re.match("MULTILINESTRING ", ligne.strip('\n').split("\"")[-2])
            is_line = re.match("LINESTRING ", ligne.strip('\n').split("\"")[-2])
            if is_multiline:
                save_multiline(ligne)
                counter += 1
            elif is_line:
                save_line(ligne)
                counter += 1
            linecounter += 1
            print(linecounter)
        return counter, linecounter

import re
import os
import grp


def inputProcess(usrs, bad, file):
    usr = ""
    with open(file, "r") as fp:
        next(fp)
        for line in fp:
            if not len(line) > 5:
                continue

            line = line.strip()
            field = line.split(",")

            ID = re.sub('\W+', '', field[0])
            if len(field) > 1:
                lname = re.sub('\W+', '', field[1])
            else:
                lname = ""

            if len(field) > 2:
                fname = re.sub('\W+', '', field[2])
            else:
                fname = ""

            if len(field) > 3:
                office = re.sub('\W+', '', field[3])
            else:
                office = ""

            if len(field) > 4:
                phone = re.sub('\W+', '', field[4])
            else:
                phone = "unlisted"

            if len(field) > 5:
                dep = re.sub('\W+', '', field[5])
            else:
                dep = ""

            if not ID.isdigit():
                print(ID + ' is not a valid EmployeeID')
                i = input("Enter y to ignore else the program will exit")
                if i != "y":
                    exit(0)
                else:
                    bad[ID] = field

            if not lname or len(lname) < 2:
                print("ID: " + ID + " does not have a last name")
                i = input("Enter a valid user name or n to ignore: ")
                if i == "n":
                    bad[ID] = field
                else:
                    field[1] = re.sub('\W+', '', i)
                    lname = re.sub('\W+', '', field[1])

                if not lname.isalpha():
                    print(lname + ' is not a valid last name. EmployeeID: ' + ID)
                    i = input("Enter y to ignore else the program will exit")
                    if i != "y":
                        exit(0)
                    else:
                        bad[ID] = field

            if not fname or len(fname) < 2:
                print("ID: " + ID + " does not have a first name")
                i = input("Enter a valid first name or n to ignore: ")
                if i == "n":
                    bad[ID] = field

                else:
                    field[2] = re.sub('\W+', '', i)
                    fname = re.sub('\W+', '', field[2])

                if not fname.isalpha():
                    print(fname + ' is not a valid last name. EmployeeID: ' + ID)
                    i = input("Enter y to ignore else the program will exit: ")
                    if i != "y":
                        exit(0)
                    else:
                        bad[ID] = field

            if not office or not office[0].isdigit():
                print(office + ' is not a valid office number. EmployeeID: ' + ID)
                i = input("Enter y to ignore else the program will exit: ")
                if i != "y":
                    exit(0)
                else:
                    bad[ID] = field

            if not phone or not phone[0].isdigit() and phone != "unlisted":
                if len(phone) > 1:
                    print(phone + ' is not a valid phone number. EmployeeID: ' + ID)
                    i = input("Enter y to ignore else the program will exit: ")
                    if i != "y":
                        exit(0)
                    else:
                        bad[ID] = field

            if not dep or len(dep) < 2:
                print("ID: " + ID + " does not have a department")
                i = input("Enter a valid departament or n to ignore: ")
                if i == "n":
                    bad[ID] = field

                else:
                    field[5] = re.sub('\W+', '', i)
                    dep = re.sub('\W+', '', field[5])

                if not dep.isalnum():
                    print(dep + ' is not a valid department. EmployeeID: ' + ID)
                    i = input("Enter y to ignore else the program will exit: ")
                    if i != "y":
                        exit(1)

            if len(field) > 1:
                if field[2]:
                    usr = re.sub('\W+', '', field[2][0])

                    if len(field[1]) > 0:
                        usr += re.sub('\W+', '', field[1])

                elif len(field[1]) > 0:

                    usr = re.sub('\W+', '', field[1]) + field[0][0:3]

                if usr in usrs.keys():
                    usr += re.sub('\W+', '', field[0][0:3])

                if ID not in bad.keys():
                    usrs[usr] = field


def addusrs(usrs):
    for key in usrs.keys():
        ID = usrs[key][0]
        print("id: " + ID)
        lname = usrs[key][1]
        fname = usrs[key][2]
        office = usrs[key][3]
        phone = usrs[key][4]
        dep = usrs[key][5]
        group = usrs[key][6]
        groups = grp.getgrall()

        exists = True

        for g in groups:
            if g.gr_name == group:
                exists = False

        if exists:
            print("Creating the group: " + group)
            os.system("sudo groupadd -f " + group)

        print("adding the user: " + key)
        print(
            "sudo useradd -m -d /home/{" + dep + "/" + key + "} -s " + "/bin/bash" + " -u " + ID + " -g " + group + " -c \"" + fname + " " + lname + "\" " + key)

        print("changing password for: " + key)
        print("echo \"" + key + "\" | sudo passwd --stdin " + key)
        print("sudo passwd -e " + key)


def badRecords(bad):
    for key in bad.keys():
        print("BAD RECORD: " + bad[key][0])

def main():
    fp = input("Enter file name: ").strip()

    usrs = {}
    bad = {}

    inputProcess(usrs, bad, fp)

    addusrs(usrs)

    badRecords(bad)


if __name__ == '__main__':
    main()
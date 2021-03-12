import requests
import json
import time
from datetime import datetime
import pandas as pd
import numpy as np
import os


class MyError(Exception):
    def __init___(self, args):
        Exception.__init__(self, "my exception was raised with arguments {0}".format(args))
        self.args = args


def gerald(username, password, output):
    # See https://www.space-track.org/documentation for details on REST queries

    uriBase = "https://www.space-track.org"
    requestLogin = "/ajaxauth/login"
    requestCmdAction = "/basicspacedata/query"
    requestFindObjects = "/class/gp/EPOCH/>now-30"

    # Parameters to derive apoapsis and periapsis from mean motion (see https://en.wikipedia.org/wiki/Mean_motion)

    GM = 398600441800000.0
    GM13 = GM ** (1.0 / 3.0)
    MRAD = 6378.137
    PI = 3.14159265358979
    TPI86 = 2.0 * PI / 86400.0

    # ACTION REQUIRED FOR YOU:
    # =========================
    # Provide a config file in the same directory as this file, called SLTrack.ini, with this format (without the # signs)
    # [configuration]
    # username = XXX
    # password = YYY
    # output = ZZZ
    #
    # ... where XXX and YYY are your www.space-track.org credentials (https://www.space-track.org/auth/createAccount for free account)
    # ... and ZZZ is your Excel Output file

    # Use configparser package to pull in the ini file (pip install configparser)
    User = username
    Pword = password
    Out = output
    siteCred = {'identity': User, 'password': Pword}

    # write the headers on the spreadsheet
    now = datetime.now()
    nowStr = now.strftime("%m_%d_%Y_%H_%M_%S")

    satdf = pd.DataFrame(columns=['EPOCH', 'NORAD_CAT_ID', 'REV_AT_EPOCH', 'INCLINATION', 'ECCENTRICITY',
                                  'MEAN_MOTION', 'APOAPSIS', 'PERIAPSIS', 'AVERAGE_APSIS', 'RA_OF_ASC_NODE',
                                  'ARG_OF_PERICENTER', 'MEAN_ANOMALY', 'SEMI_MAJOR_AXIS', 'T', 'Vel'])

    # use requests package to drive the RESTful session with space-track.org
    with requests.Session() as session:
        # run the session in a with block to force session to close if we exit

        # need to log in first. note that we get a 200 to say the web site got the data, not that we are logged in
        resp = session.post(uriBase + requestLogin, data=siteCred)
        if resp.status_code != 200:
            raise MyError(resp, "POST fail on login")

        # this query picks up all satellites + debris from the catalog. Note - a 401 failure shows you have bad credentials
        resp = session.get(uriBase + requestCmdAction + requestFindObjects)
        if resp.status_code != 200:
            print(resp)
            raise MyError(resp, "GET fail on request for objects")

        # use the json package to break the json formatted response text into a Python structure (a list of dictionaries)
        retData = json.loads(resp.text)
        satCount = len(retData)
        satIds = []
        for e in retData:
            # each e describes the latest elements for one object. We just need the NORAD_CAT_ID
            catId = e['NORAD_CAT_ID']
            satIds.append(catId)

        # using our new list of object NORAD_CAT_IDs, we can now get the OMM message
        maxs = 1
        i = 0
        for e in retData:
            # each element is one reading of the orbital elements for one object
            print("Scanning satellite " + e['OBJECT_NAME'] + " at epoch " + e['EPOCH'])
            new_line = []
            mmoti = float(e['MEAN_MOTION'])
            ecc = float(e['ECCENTRICITY'])
            # do some ninja-fu to flip Mean Motion into Apoapsis and Periapsis, and to get the orbital period and velocity
            sma = GM13 / ((TPI86 * mmoti) ** (2.0 / 3.0))
            apo = sma * (1.0 + ecc) - MRAD
            per = sma * (1.0 - ecc) - MRAD
            smak = sma * 1000.0
            orbT = 2.0 * PI * ((smak ** 3.0) / GM) ** (0.5)
            orbV = (GM / smak) ** (0.5)
            new_line = np.append(new_line, [e['EPOCH'], int(e['NORAD_CAT_ID']), float(e['REV_AT_EPOCH']),
                                            float(e['INCLINATION']), ecc, mmoti, apo, per, (apo+per)/2.0,
                                            float(e['RA_OF_ASC_NODE']), float(e['ARG_OF_PERICENTER']),
                                            float(e['MEAN_ANOMALY']), sma, orbT, orbV])
            satdf.loc[i] = new_line
            i += 1
        maxs = maxs + 1
        if maxs > 18:
            print("Snoozing for 60 secs for rate limit reasons (max 20/min and 200/hr)...")
            time.sleep(60)
            maxs = 1
    session.close()
    satdf.loc[i + 1, 'NORAD_CAT_ID'] = 'TLE data from ' + uriBase + " on " + nowStr
    print("Completed session")
    #satmat = satdf.to_numpy()
    #satmat = np.vstack([['NORAD_CAT_ID', 'SATNAME', 'EPOCH', 'Orb', 'Inc', 'Ecc', 'MnM', 'ApA', 'PeA', 'AvA',
    #                             'LAN', 'AgP', 'MnA', 'SMa', 'T', 'Vel'], satmat])
    #satdict = satdf.to_dict()
    #return satmat
    outname = output + '_on_' + nowStr + '.csv'
    satdf.to_csv(outname, index=False)
    return outname


def brian(username, password, output):
    # See https://www.space-track.org/documentation for details on REST queries

    uriBase = "https://www.space-track.org"
    requestLogin = "/ajaxauth/login"
    requestCmdAction = "/basicspacedata/query"
    requestFindObjects = "/class/gp/EPOCH/>now-30/orderby/NORAD_CAT_ID asc/format/tle/"

    # Use configparser package to pull in the ini file (pip install configparser)
    User = username
    Pword = password
    siteCred = {'identity': User, 'password': Pword}

    now = datetime.now()
    nowStr = now.strftime("%m_%d_%Y_%H_%M_%S")

    # use requests package to drive the RESTful session with space-track.org
    with requests.Session() as session:
        # run the session in a with block to force session to close if we exit

        # need to log in first. note that we get a 200 to say the web site got the data, not that we are logged in
        resp = session.post(uriBase + requestLogin, data=siteCred)
        if resp.status_code != 200:
            raise MyError(resp, "POST fail on login")
        print('Getting response from Space-Track')
        # this query picks up all satellites + debris from the catalog. Note - a 401 failure shows you have bad credentials
        resp = session.get(uriBase + requestCmdAction + requestFindObjects)
        if resp.status_code != 200:
            print(resp)
            raise MyError(resp, "GET fail on request for objects")

        # use the json package to break the json formatted response text into a Python structure (a list of dictionaries)
        retData = resp.content
        outName = output + '_on_' + nowStr + '.inp'
        file = open(outName, 'wb')
        file.write(retData)
        file.close()
        return str(outName)


def steven(username, password):
    # See https://www.space-track.org/documentation for details on REST queries

    uriBase = "https://www.space-track.org"
    requestLogin = "/ajaxauth/login"
    requestCmdAction = "/basicspacedata/query"
    requestFindObjects = "/class/gp/EPOCH/>now-30/orderby/NORAD_CAT_ID asc/format/tle/"
    requestISS = uriBase + requestCmdAction + "/class/gp/NORAD_CAT_ID/25544/format/tle/"

    # Use configparser package to pull in the ini file (pip install configparser)
    User = username
    Pword = password
    siteCred = {'identity': User, 'password': Pword}

    now = datetime.now()
    nowStr = now.strftime("%m_%d_%Y_%H_%M_%S")
    name = nowStr + '.inp'

    # use requests package to drive the RESTful session with space-track.org
    with requests.Session() as session:
        # run the session in a with block to force session to close if we exit

        # need to log in first. note that we get a 200 to say the web site got the data, not that we are logged in
        resp = session.post(uriBase + requestLogin, data=siteCred)
        if resp.status_code != 200:
            raise MyError(resp, "POST fail on login")
        print('Getting response from Space-Track')
        # this query picks up all satellites + debris from the catalog. Note - a 401 failure shows you have bad credentials
        resp = session.get(uriBase + requestCmdAction + requestFindObjects)
        if resp.status_code != 200:
            print(resp)
            raise MyError(resp, "GET fail on request for objects")

        # use the json package to break the json formatted response text into a Python structure (a list of dictionaries)
        retData = resp.content
        outName = 'debris.inp'
        file = open(outName, 'wb')
        file.write(retData)
        file.close()

        resp2 = session.get(requestISS)
        if resp2.status_code != 200:
            print(resp2)
            raise MyError(resp2, "GET fail on request for objects")

        # use the json package to break the json formatted response text into a Python structure (a list of dictionaries)
        retData2 = resp2.content
        outName2 = 'ISS.inp'
        file = open(outName2, 'wb')
        file.write(retData2)
        file.close()
        return str(name)


def steven2(username, password):
    # See https://www.space-track.org/documentation for details on REST queries

    uriBase = "https://www.space-track.org"
    requestLogin = "/ajaxauth/login"
    requestCmdAction = "/basicspacedata/query"
    requestFindObjects = "/class/gp_history/NORAD_CAT_ID/46477/format/tle/"
    requestISS = uriBase + requestCmdAction + "/class/gp_history/EPOCH/2020-08-22--2020-09-23/orderby/EPOCH desc/NORAD_CAT_ID/25544/format/tle/"

    # Use configparser package to pull in the ini file (pip install configparser)
    User = username
    Pword = password
    siteCred = {'identity': User, 'password': Pword}

    now = datetime.now()
    nowStr = now.strftime("%m_%d_%Y_%H_%M_%S")
    name = nowStr + '.inp'

    # use requests package to drive the RESTful session with space-track.org
    with requests.Session() as session:
        # run the session in a with block to force session to close if we exit

        # need to log in first. note that we get a 200 to say the web site got the data, not that we are logged in
        resp = session.post(uriBase + requestLogin, data=siteCred)
        if resp.status_code != 200:
            raise MyError(resp, "POST fail on login")
        print('Getting response from Space-Track')
        # this query picks up all satellites + debris from the catalog. Note - a 401 failure shows you have bad credentials
        resp = session.get(uriBase + requestCmdAction + requestFindObjects)
        if resp.status_code != 200:
            print(resp)
            raise MyError(resp, "GET fail on request for objects")

        # use the json package to break the json formatted response text into a Python structure (a list of dictionaries)
        retData = resp.content
        outName = 'debris.inp'
        file = open(outName, 'wb')
        file.write(retData)
        file.close()

        resp2 = session.get(requestISS)
        if resp2.status_code != 200:
            print(resp2)
            raise MyError(resp2, "GET fail on request for objects")

        # use the json package to break the json formatted response text into a Python structure (a list of dictionaries)
        retData2 = resp2.content
        outName2 = 'ISS.inp'
        file = open(outName2, 'wb')
        file.write(retData2)
        file.close()
        return str(name)

def derek(username, password, satIDs):
    # See https://www.space-track.org/documentation for details on REST queries

    uriBase = "https://www.space-track.org"
    requestLogin = "/ajaxauth/login"
    requestCmdAction = "/basicspacedata/query"
    requestObjects1 = "/class/gp_history/EPOCH/>now-30/NORAD_CAT_ID/"
    requestObjects2 = "/orderby/EPOCH%20asc/format/tle"

    # Use configparser package to pull in the ini file (pip install configparser)
    User = username
    Pword = password
    siteCred = {'identity': User, 'password': Pword}

    name = 'historicTLE.txt'

    # use requests package to drive the RESTful session with space-track.org
    with requests.Session() as session:
        # run the session in a with block to force session to close if we exit

        # need to log in first. note that we get a 200 to say the web site got the data, not that we are logged in
        resp = session.post(uriBase + requestLogin, data=siteCred)
        if resp.status_code != 200:
            raise MyError(resp, "POST fail on login")
        print('Getting response from Space-Track')
        # this query picks up all satellites + debris from the catalog. Note - a 401 failure shows you have bad credentials
        n = 1
        if os.path.exists(name):
            os.remove(name)
            print('Found it')
        else:
            print('nothing there')

        file = open(name, 'ab')
        satIDs2 = satIDs.split(',')
        for ID in satIDs2:
            print(ID)
            resp = session.get(uriBase + requestCmdAction + requestObjects1 + ID + requestObjects2)
            if resp.status_code != 200:
                print(resp)
                raise MyError(resp, "GET fail on request for objects")

            # use the json package to break the json formatted response text into a Python structure (a list of dictionaries)
            retData = resp.content
            file.write(retData)
            n += 1
            if n > 18:
                print("Snoozing for 60 secs for rate limit reasons (max 20/min and 200/hr)...")
                time.sleep(60)
                n = 1
        file.close()
        return str(name)


def orbitType(username, password):
    # See https://www.space-track.org/documentation for details on REST queries

    uriBase = "https://www.space-track.org"
    requestLogin = "/ajaxauth/login"
    requestCmdAction = "/basicspacedata/query"
    requestObjects1 = "/class/gp_history/ECCENTRICITY/0--0.02/PERIAPSIS/300--400/EPOCH/>now-30"
    requestObjects2 = "/orderby/EPOCH asc/format/tle"

    # Use configparser package to pull in the ini file (pip install configparser)
    User = username
    Pword = password
    siteCred = {'identity': User, 'password': Pword}

    name = 'historicTLENew.txt'

    # use requests package to drive the RESTful session with space-track.org
    with requests.Session() as session:
        # run the session in a with block to force session to close if we exit

        # need to log in first. note that we get a 200 to say the web site got the data, not that we are logged in
        resp = session.post(uriBase + requestLogin, data=siteCred)
        if resp.status_code != 200:
            raise MyError(resp, "POST fail on login")
        print('Getting response from Space-Track')
        # this query picks up all satellites + debris from the catalog. Note - a 401 failure shows you have bad credentials
        n = 1
        if os.path.exists(name):
            os.remove(name)
            print('Found it')
        else:
            print('nothing there')

        file = open(name, 'wb')

        resp = session.get(uriBase + requestCmdAction + requestObjects1 + requestObjects2)
        if resp.status_code != 200:
            print(resp)
            raise MyError(resp, "GET fail on request for objects")

        # use the json package to break the json formatted response text into a Python structure (a list of dictionaries)
        retData = resp.content
        file.write(retData)
        file.close()
        return str(name)


def ali(historicTLEFile, folderPath):
    lines_per_file = 2
    smallfile = None
    newpath = folderPath
    if not os.path.exists(newpath):
        os.makedirs(newpath)
    with open(historicTLEFile) as bigfile:
        for lineno, line in enumerate(bigfile):
            if lineno % lines_per_file == 0:
                if smallfile:
                    smallfile.close()
                small_filename = newpath + '/tle_{}.inp'.format(int(lineno/2+1))
                smallfile = open(small_filename, "w")
            smallfile.write(line)
        if smallfile:
            smallfile.close()


def fileGen(passedTLEs, referenceTLE, savePath):
    passedTLEs = passedTLEs.split(',')
    if not os.path.exists(savePath + '/HistoryTLE'):
        os.makedirs(savePath + '/HistoryTLE')
    with open(savePath + '/HistoryTLE/TLEs_' + referenceTLE + '.INP', 'w') as outfile:
        for fname in passedTLEs:
            with open(savePath + '/HistoryISS/tle_' + fname + '.INP') as infile:
                outfile.write(infile.read())
    fileName = savePath + '/HistoryTLE/TLEs_' + referenceTLE + '.INP'
    return fileName


# brian('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF', 'out')
# fileName = derek('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF', ["25544"]);
# fileGen('13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41', '42', 'C:/Users/rober/Documents/MATLAB/ASTRAIOS/ASTRAIOS')
# orbitType('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF')

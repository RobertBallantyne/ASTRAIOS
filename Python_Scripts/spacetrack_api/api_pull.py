import requests
import json
import configparser
import xlsxwriter
import time
from datetime import datetime


class MyError(Exception):
    def __init___(self, args):
        Exception.__init__(self, "my exception was raised with arguments {0}".format(args))
        self.args = args


def gerald(output):
    # See https://www.space-track.org/documentation for details on REST queries

    uriBase = "https://www.space-track.org"
    requestLogin = "/ajaxauth/login"
    requestCmdAction = "/basicspacedata/query"
    requestFindObjects = "/class/gp/EPOCH/>now-30/"

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
    config = configparser.ConfigParser()
    config.read("./DebTrack.ini")
    configUsr = config.get("configuration", "username")
    configPwd = config.get("configuration", "password")
    configOut = output
    siteCred = {'identity': configUsr, 'password': configPwd}

    # User xlsxwriter package to write the xlsx file (pip install xlsxwriter)
    workbook = xlsxwriter.Workbook(configOut)
    worksheet = workbook.add_worksheet()
    z0_format = workbook.add_format({'num_format': '#,##0'})
    z1_format = workbook.add_format({'num_format': '#,##0.0'})
    z2_format = workbook.add_format({'num_format': '#,##0.00'})
    z3_format = workbook.add_format({'num_format': '#,##0.000'})

    # write the headers on the spreadsheet
    now = datetime.now()
    nowStr = now.strftime("%m/%d/%Y %H:%M:%S")
    worksheet.write('A1', 'TLE data from' + uriBase + " on " + nowStr)
    worksheet.write('A3', 'NORAD_CAT_ID')
    worksheet.write('B3', 'SATNAME')
    worksheet.write('C3', 'EPOCH')
    worksheet.write('D3', 'Orb')
    worksheet.write('E3', 'Inc')
    worksheet.write('F3', 'Ecc')
    worksheet.write('G3', 'MnM')
    worksheet.write('H3', 'ApA')
    worksheet.write('I3', 'PeA')
    worksheet.write('J3', 'AvA')
    worksheet.write('K3', 'LAN')
    worksheet.write('L3', 'AgP')
    worksheet.write('M3', 'MnA')
    worksheet.write('N3', 'SMa')
    worksheet.write('O3', 'T')
    worksheet.write('P3', 'Vel')
    wsline = 3

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

        for e in retData:
            # each element is one reading of the orbital elements for one object
            print("Scanning satellite " + e['OBJECT_NAME'] + " at epoch " + e['EPOCH'])
            mmoti = float(e['MEAN_MOTION'])
            ecc = float(e['ECCENTRICITY'])
            worksheet.write(wsline, 0, int(e['NORAD_CAT_ID']))
            worksheet.write(wsline, 1, e['OBJECT_NAME'])
            worksheet.write(wsline, 2, e['EPOCH'])
            worksheet.write(wsline, 3, float(e['REV_AT_EPOCH']))
            worksheet.write(wsline, 4, float(e['INCLINATION']), z1_format)
            worksheet.write(wsline, 5, ecc, z3_format)
            worksheet.write(wsline, 6, mmoti, z1_format)
            # do some ninja-fu to flip Mean Motion into Apoapsis and Periapsis, and to get the orbital period and velocity
            sma = GM13 / ((TPI86 * mmoti) ** (2.0 / 3.0)) / 1000.0
            apo = sma * (1.0 + ecc) - MRAD
            per = sma * (1.0 - ecc) - MRAD
            smak = sma * 1000.0
            orbT = 2.0 * PI * ((smak ** 3.0) / GM) ** (0.5)
            orbV = (GM / smak) ** (0.5)
            worksheet.write(wsline, 7, apo, z1_format)
            worksheet.write(wsline, 8, per, z1_format)
            worksheet.write(wsline, 9, (apo + per) / 2.0, z1_format)
            worksheet.write(wsline, 10, float(e['RA_OF_ASC_NODE']), z1_format)
            worksheet.write(wsline, 11, float(e['ARG_OF_PERICENTER']), z1_format)
            worksheet.write(wsline, 12, float(e['MEAN_ANOMALY']), z1_format)
            worksheet.write(wsline, 13, sma, z1_format)
            worksheet.write(wsline, 14, orbT, z0_format)
            worksheet.write(wsline, 15, orbV, z0_format)
            wsline = wsline + 1
        maxs = maxs + 1
        if maxs > 18:
            print("Snoozing for 60 secs for rate limit reasons (max 20/min and 200/hr)...")
            time.sleep(60)
            maxs = 1
    session.close()
    workbook.close()
    print("Completed session")

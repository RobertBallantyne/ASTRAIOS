%    Purpose:
%       This program shows how a MATLAB program can call the Astrodynamic Standard LAMOD and the associated dlls
%       to compute sensor viewing opportunities (look angles). Both ground and orbiting sensors can be selected.
%       Ephemeris propagation is via Sgp4 propagator, Sp propagator, and external ephemeris files.
% 
%       The program reads in user specified file and generates look angles for each sensor/satellite pair in the
%       requetested time span
% 
%    Usage: Command line format
%       Lamod(inFile, outFile, EarthConstant)
%       inFile    : File contains LAMOD related input data
%       outFile   : Name of the output file
%       EarthConst: Gavitational constants ('WGS-72', 'WGS-84', 'EGM-96' ...)
%    
%       Example:
%       >> Lamod('la_case8.inp', 'test.out', 'wgs-72') 
% 
%    Note:
%       To see this program correctly in Visual Studio set the tab size to 3 and check 
%       insert spaces in Tools/Options/Tabs
% 
% 
%    Author:
%       Dinh Nguyen AFSPC/A9AC - Sep 27, 2011
%


% Example too run this application: >>Lamod('./input/lamod_test.inp', 'test.out', 'WGS-72')
function Lamod(inFile, outFile, geoConstStr)
   % Add Astro Standards library folder to search path
   fprintf('Please specify the correct path to the Astro Standards library by modifying the default ASLIBPATH\n');
   ASLIBPATH = '../../../../Lib/Win64';

   fprintf('Current Astro Standards library folder = %s\n', ASLIBPATH);

   if ispc
      sysPath = getenv('PATH');
      setenv('PATH', [ASLIBPATH ';' sysPath]);
   elseif isunix
      sysPath = getenv('LD_LIBRARY_PATH');
      setenv('LD_LIBRARY_PATH', [ASLIBPATH ';' sysPath]);
   end

   % Add SGP4 license file path
   SGP4LICFILEPATH = [ASLIBPATH '/'];
   fprintf('SGP4_Open_License.txt file path= %s\n', SGP4LICFILEPATH);

   if(nargin < 2)
      fprintf('Error in number of parameters passed. Please see the usage.\n');
      fprintf('Usage     : Lamod(''inFile'', ''outFile'', ''EarthConstant'')\n');
      fprintf('inFile    : File contains sp related input data\n');
      fprintf('outFile   : Base name for five output files\n');
      fprintf('EarthConst: Gravitational constants (''WGS-72'', ''WGS-84'', ''EGM-96'')\n');
      error('myApp:argChk', 'Wrong number of input arguments');
   end

   fprintf('Program starts.\n');
   tStart = tic;

   % Load all the dlls being used in the program
   LoadAstroStdDlls();

   % Specify folder that contains "SGP4_Open_License.txt" file
   calllib('Sgp4Prop', 'Sgp4SetLicFilePath', SGP4LICFILEPATH);
   
   % Initialize all the dlls being used in the program
   InitAstroStdDlls();

   RunLamod(inFile, outFile, geoConstStr)

   % Free loaded AstroStd dlls
   FreeAstroStdDlls();

   tElapsed = toc(tStart);

   %Calculate the whole run time
   fprintf('Program completed successfully.\n');

   fprintf('Total run time = %10.2f seconds.\n', tElapsed );
   %fprintf(fpOutFile, 'Total run time = %10.2f seconds.\n', tElapsed);
   %fclose(fpOutFile);

   %******************************************************************************
   % Program completed successfully here
end


% Run one Lamod job at a time
function RunLamod(inFile, outFile, bConst)
   % Shared constants
   IDX_SCHED_OBS  = 'O';   % Obs schedule mode
   IDX_SCHED_PASS = 'P';   % Pass schedule mode

   MINSPERDAY   = 1440.0;
   EPSTIMEDAYS  = 0.001 / MINSPERDAY;  % This value is about 1msec

   % Indexes of Sensor data fields
   IDX_SENLOC_NUM  = 1;           % Sensor number
   IDX_SENLOC_LAT  = 2;           % Sensor astronomical latitude (deg)
   IDX_SENLOC_LON  = 3;           % Sensor astronomical longitude (deg)
   IDX_SENLOC_POSX = 4;           % Sensor position X (km)
   IDX_SENLOC_POSY = 5;           % Sensor position Y (km)
   IDX_SENLOC_POSZ = 6;           % Sensor position Z (km)
   IDX_SENLOC_DESC = 7;           % Sensor description
   IDX_SENLOC_ORBSATNUM = 8;      % Orbiting sensor's number (satnum)   
   IDX_SENLOC_SECCLASS  = 9;      % Sensor classification   

   IDX_SENLIM_VIEWTYPE  = 11;     % Sensor view type
   IDX_SENLIM_OBSTYPE   = 12;     % Sensor observation type
   IDX_SENLIM_UNIT      = 13;     % Unit on range/range rate
   IDX_SENLIM_MAXRNG    = 14;     % Max observable range (km)
   IDX_SENLIM_MINRNG    = 15;     % Min observable range (km)
   IDX_SENLIM_INTERVAL  = 16;     % Output interval (min)
   IDX_SENLIM_OPTVISFLG = 17;     % Visual pass control flag
   IDX_SENLIM_RNGLIMFLG = 18;     % Range limit control flag 
   IDX_SENLIM_PTSPERPAS = 19;     % Max number of points per pass
   IDX_SENLIM_RRLIM     = 20;     % Range rate/relative velocity limit (km/sec)

   IDX_SENLIM_ELLIM1    = 31;     % Elevation limits (deg) 1, 2, 3, 4 or Sensor off-boresight angle (deg)
   IDX_SENLIM_ELLIM2    = 32;
   IDX_SENLIM_ELLIM3    = 33;
   IDX_SENLIM_ELLIM4    = 34;
   IDX_SENLIM_AZLIM1    = 35;     % Azimuth limits (deg) 1, 2,3, 4 or Sensor clock angle (deg)
   IDX_SENLIM_AZLIM2    = 36;
   IDX_SENLIM_AZLIM3    = 37;
   IDX_SENLIM_AZLIM4    = 38;


   IDX_SENLIM_PLNTRYRES = 52;     % Orbiting sensor planetary restriction
   IDX_SENLIM_BOREVEC1  = 53;     % Orbiting sensor boresight vector 1
   IDX_SENLIM_BOREVEC2  = 54;     % Orbiting sensor boresight vector 2
   IDX_SENLIM_KEARTH    = 55;     % Allow orbiting sensor to view sat against earth background
   IDX_SENLIM_ELIMB     = 56;     % Orbiting sensor earth limb exclusion distance (km)
   IDX_SENLIM_SOLEXCANG = 57;     % Orbiting sensor solar exclusion angle (deg)   
   IDX_SENLIM_LUNEXCANG = 58;     % Orbiting sensor lunar exclusion angle (deg)


   IDX_SENLIM_MINIL     = 59;     % Orbiting sensor min illumination angle (deg)
   IDX_SENLIM_TWILIT    = 60;     % Ground site twilight offset angle (deg) 


   % Indexes of look array data
   IDX_LOOK_DS50UTC = 1;    % Look time in ds50UTC
   IDX_LOOK_MSE    = 2;     % Look time in minutes since epoch
   IDX_LOOK_ELEV = 3;       % Elevation (deg)
   IDX_LOOK_AZIM = 4;       % Azimuth (deg)
   IDX_LOOK_RNG = 5;        % Range (km) or ? for optical sensor
   IDX_LOOK_RNGRT = 6;      % Range rate (km/sec) or ? for optical sensor
   
   
   STEPMODE_CULM = 0,
   STEPMODE_STEP = 1;

   LOOK_VALID   = 0;        % Valid look 
   LOOK_HTEST   = 1;        % Failed horizon break test
   LOOK_SENLIMS = 2;        % Failed limit tests


   STEPMODE_CULM = 0,
   STEPMODE_STEP = 1;



   % Load input data from the input file
   LoadInputsFrFile(inFile);

   fp = fopen(outFile, 'w');

   % Set up geo constants via 3rd input parameter (eg 'WGS-72', 'EGM-96')
   % This will take precedence over the earth constants specified in the input file
   if (bConst(1) ~= 0)
      calllib('EnvConst', 'EnvSetGeoStr', bConst); 
   end


   % Return number of sensors and satellites being selected via 1P/2P/LAMOD free format records
   numSens = int32(0);
   numSats = int32(0);
   numSensPtr = libpointer('int32Ptr', numSens);
   numSatsPtr = libpointer('int32Ptr', numSats);
   calllib('Lamod', 'LamodGetNumOfSensSats', numSensPtr, numSatsPtr);
   numSens = numSensPtr.Value;
   numSats = numSatsPtr.Value;

   if (numSens ~= 0)
      senKeys = zeros(numSens, 1);

      % Return selected sensor numbers via 1P/2P/LAMOD free format records
      senKeysPtr = libpointer('int32Ptr', senKeys);
      calllib('Lamod', 'LamodGetSenNums', senKeysPtr);
      senKeys = senKeysPtr.Value;
   else

      % No sensors selected via 1P/2P cards, use all the loaded ones

      numSens = calllib('Sensor', 'SensorGetCount');
      senKeys = zeros(numSens, 1);
      senKeysPtr = libpointer('int32Ptr', senKeys);
      calllib('Sensor', 'SensorGetLoaded', 0, senKeysPtr);
      senKeys = senKeysPtr.Value;
   end

%    if (numSats ~= 0)
%    
%       satNums = zeros(numSats, 1);
%       satNumsPtr = libpointer('int32Ptr', satNums);
%       satKeys = int64(zeros(numSats, 1));
%    
%       % Return selected satellite numbers being selected via 1P/2P/LAMOD free format records
%       calllib('Lamod', 'LamodGetSatNums', satNumsPtr);
%       satNums = satNumsPtr.Value;
%    
%       for i= 1:numSats
%          % Convert satellite numbers to satKeys
%          satKeys(i) = uint64(calllib('SatState', 'SatStateNumToKey', satNums(i)));
%       end
%    else 
      % No satellites selected via 1P/2P cards, use all the loaded ones
      numSats = calllib('SatState', 'SatStateGetCount');
      satKeys = int64(zeros(numSats, 1));
      satKeysPtr = libpointer('int64Ptr', satKeys);
      calllib('SatState', 'SatStateGetLoaded', 0, satKeysPtr); % DHN 16May11 - Need to sort the satellite list to match the old output
      satKeys = satKeysPtr.Value;
%   end

   % Initialize all the satellites in preparation for propagation
   for j = 1:numSats
      errCode = calllib('SatState', 'SatStateInitSat', satKeys(j));
      if (errCode ~= 0)
        ShowErrMsg();
        return;
      end

   end

   % Obtain Lamod control parameters
   lamodCtrl = GetLamodCtrlPara();

   %PrintLamodCtrls(fp;lamodCtrl);


   fpObsFile = -1;

   % Retrieve output obs file if punchObs flag is on
   if(lamodCtrl.punchObs) 

      % Retrieve output obs file name
      obsFile = blanks(128);
      obsFile = calllib('Lamod', 'LamodGetObsFileName', obsFile);

      if(obsFile(0) ~= ' ') % file is available
         fpObsFile = fopen(obsFile, 'w');
      else
         printf('Warning: Punch obs flag is on but output obs file is unavailable\n');
         lamodCtrl.punchObs = 0; % file is unavailable therefore turn on punchObs flag
      end
   end

   % Retrieve processing mode
   procMode = lamodCtrl.schedMode;

   % ObsSched
   if (procMode == 'O')     

      for i = 1:numSens
         %PrintSensorData(fp, pSenKeys(i));
         for j = 1:numSats
            %satNum = callib('SatState', 'SatKeyToSatNum', satKeys(j));
            %printf('Processing sensor # %3d and sat # %5d\n', senKeys(i), satNum);
            %PrintSatelliteData(fp, pSatKeys(j));
            SenSatLamod(fp, lamodCtrl, fpObsFile, senKeys(i), satKeys(j));
         end
      end
   % PassSched 
   elseif (procMode == 'P')   
      for i = 1:numSats
         %PrintSatelliteData(fp, pSatKeys(i));
         for j = 1:numSens
            %satNum = callib('SatState', 'SatKeyToSatNum', satKeys(j));
            %printf('Processing sat # %5d and sen # %3d\n', satNum, senKeys(j));
            %PrintSensorData(fp, pSenKeys(j));
            SenSatLamod(fp, lamodCtrl, fpObsFile, senKeys(j), satKeys(i));
         end
      end
   end

   if(lamodCtrl.punchObs) 
      fclose(fpObsFile);
   end

   % Print look angles in the selected schedule mode, either culmination or step mode
   function SenSatLamod(fp, lamodCtrl, fpObsFile, senKey, satKey)

      senSatKey = calllib('Lamod', 'LamodInitSenSat', senKey, satKey);

      % Skip this sensor-satellite pair
      if (senSatKey < 0) 

         % DHN 21Jun11 - Don't terminate and continue to the next sen/sat pair 
         % ShowMsgAndTerminate();
         ShowErrMsg();
         return;
      elseif (senSatKey == 0)
         return;
      end

      % Retrieve sen/sat data
      senSatData = GetSenSatData(senSatKey);

      if (senSatData.errCode ~= 0)
         ShowErrMsg();
         return;
      end


      valueStr = blanks(512);
      [errCode, valueStr] = calllib('Sensor', 'SensorGetLimField', senKey, IDX_SENLIM_VIEWTYPE, valueStr);
      viewType = valueStr(1);

      [errCode, valueStr] = calllib('Sensor', 'SensorGetLimField', senKey, IDX_SENLIM_OBSTYPE, valueStr);
      obsType = valueStr(1);

      [errCode, valueStr] = calllib('Sensor', 'SensorGetLimField', senKey, IDX_SENLIM_PTSPERPAS, valueStr);
      maxPtsPerPass = str2num(valueStr);

      nosticFlg = lamodCtrl.diagMode;

      punchObs = lamodCtrl.punchObs;


      %PrintSenSatHeader(fp, senKey, satKey, senSatData.stepMode, viewType, obsType, senSatData.onlyVisPass);

      % Culmination mode
      if (senSatData.stepMode == STEPMODE_CULM)
         [totalLookCount, passCount] = DoCulmMode(fp, fpObsFile, senSatData, ...
            viewType, obsType, maxPtsPerPass, nosticFlg, punchObs);
         %PrintSummary(fp, senKey, SatKeyToSatNum(satKey), totalLookCount, passCount);
      else % Step mode
         %DoStepMode(fp, fpObsFile, senSatData, viewType, obsType, maxPtsPerPass, nosticFlg, punchObs;totalLookCount;passCount);
         [totalLookCount, passCount] = DoStepMode(fp, fpObsFile, senSatData, ...
            viewType, obsType, maxPtsPerPass, nosticFlg, punchObs)         
         %PrintSummary(fp, senKey, SatKeyToSatNum(satKey), totalLookCount, passCount);
      end
   end



   % Retrieve initialized sensor/satellite data
   function [senSatData] =  GetSenSatData(senSatKey)
      errCode = int32(0);
      stepMode = int32(0);
      onlyVisPass = int32(0);
      startDs50TAI = double(0);
      stopDs50TAI = double(0);
      interval = double(0);
      period = double(0);

      stepModePtr = libpointer('int32Ptr', stepMode);
      onlyVisPassPtr = libpointer('int32Ptr', onlyVisPass);
      startDs50TAIPtr = libpointer('doublePtr', startDs50TAI);
      stopDs50TAIPtr =libpointer('doublePtr', stopDs50TAI);
      intervalPtr = libpointer('doublePtr', interval);
      periodPtr = libpointer('doublePtr', period);

      % Call Lamod dll's function
      [errCode, stepMode, onlyVisPass, startDs50TAI, ...
       stopDs50TAI, interval, period] = calllib('Lamod', 'LamodGetSenSatDataAll', senSatKey, ...
         stepModePtr, onlyVisPassPtr, startDs50TAIPtr, ...
         stopDs50TAIPtr, intervalPtr, periodPtr);

      s = struct('errCode', errCode, ...
                 'senSatKey', senSatKey, ...
                 'stepMode', stepMode, ...
                 'onlyVisPass', onlyVisPass, ...
                 'startDs50TAI', startDs50TAI, ...
                 'stopDs50TAI', stopDs50TAI, ...
                 'interval', interval,...
                 'period', period);

      senSatData = s;
   end



   % Print looks obtained by a sen-sat pair (senSatKey) in Culmination step mode
   function [totalLookCount, passCount] = ...
      DoCulmMode(fp, fpObsFile, senSatData, viewType, obsType,  ...
                 maxPtsPerPass, nosticFlg, punchObs)

      passCount = 0;
      totalLookCount = 0;

      % Get the number of possible passes for this sen/sat pair during the requested time span
      numOfPasses = calllib('Lamod', 'LamodGetNumPasses', senSatData.senSatKey);
      if (numOfPasses <= 0)
         return;
      end

      % Dynamically allocate the array to store the rise/culmination/set times
      rcsTimeArr = double(zeros(3, numOfPasses)); 
      rcsTimeArrPtr = libpointer('doublePtr', rcsTimeArr);

      % Get all the rise/culmination/set times of all the passes
      errCode = calllib('Lamod', 'LamodGetRiseCulmSetTimes', senSatData.senSatKey, rcsTimeArrPtr);
      rcsTimeArr = rcsTimeArrPtr.Value;
      rcsTimeArr = rcsTimeArr';

      if (errCode ~= 0)

         ShowErrMsg();
         return;
      end

      % Loop through all the possible passes
      for k = 1:numOfPasses

         newPass = 1;

         % Get the rise/culmination/set time from the array
         riseTime = rcsTimeArr(k, 1);
         culmTime = rcsTimeArr(k, 2);
         setTime  = rcsTimeArr(k, 3);

         % Handle cases when only rise time is found in the last pass (culmination and set times 
         % pass the requested stop time). This needs to switch to step mode 
         if (culmTime == 0 && setTime == 0)
            stepMode = STEPMODE_STEP;
            %fprintf(fp, '+++++ STEP-MODE INVOKED FOR LAST PASS +++++\n\n');
         % Handle cases when multiple maximum elevations detected in the pass
         elseif(culmTime == -1.0)
            stepMode = STEPMODE_STEP;
            %fprintf(fp, '+++++ STEP-MODE INVOKED DUE TO MULTIPLE MAXIMUM ELEVATIONS +++++\n\n');
         else
            stepMode = STEPMODE_CULM;
         end

         % Adjust the start/stop time if Rise/Set time is outside of the requested time span
         passStartDs50TAI = max(riseTime, senSatData.startDs50TAI);

         % For external ephemeris, the last pass's rise time might be set to -1.0 to indicate the value is not 
         % available because the ephemeris data doesn't cover the possible rise time. 
         % This case already handle with the above max() function

         passStopDs50TAI = min(setTime, senSatData.stopDs50TAI);

         % For external ephemeris, the last pass's set time might be set to -1.0 to indicate the value is not 
         % available because the ephemeris data doesn't cover the possible set time. 
         if(k == numOfPasses - 1 && setTime == -1.0)
            passStopDs50TAI = senSatData.stopDs50TAI;
         end


         % if the user wants to print the whole pass even if the rise or set times is outside of the requested time span
         %passStartDs50TAI = riseTime;
         %passStopDs50TAI = setTime;


         currDs50TAI = passStartDs50TAI;

         emptyPass = 1;
         numLooks = 0;

         % Loop through all the time steps in each pass
         while (1)

            lookCode = int32(0);
            lookArr = double(zeros(6, 1));
            senElts = double(zeros(9, 1));
            satElts = double(zeros(9, 1));

            lookCodePtr = libpointer('int32Ptr', lookCode);
            lookArrPtr = libpointer('doublePtr', lookArr);
            senEltsPtr = libpointer('doublePtr', senElts);
            satEltsPtr = libpointer('doublePtr', satElts);

            % Compute the look angle at the specified time
            [errCode, lookCode, lookArr, senElts, satElts] = ...
               calllib('Lamod', 'LamodComputeLookAngle', senSatData.senSatKey, ...
                       currDs50TAI, lookCodePtr, lookArrPtr, senEltsPtr, satEltsPtr);

            if (errCode ~= 0)
               ShowErrMsg();
               return;
            end

            % Check to see if the look is valid
            if (lookCode == LOOK_VALID)

               %currStep = CurrPrintStep(currDs50TAI, rcs, senSatData.interval, senSatData.stopDs50TAI);

               if(numLooks == 0)
                  PrintLookHeader();
               end

               %PrintLook(fp, senSatData.senSatKey, viewType, obsType, senSatData.onlyVisPass, currStep, lookArr);
               PrintLook(fp, lookArr);
               %fprintf('%f %f %f %f %f %f\n', lookArr(1), lookArr(2), lookArr(3), ...
               %   lookArr(4), lookArr(5), lookArr(6));

               emptyPass = 0;
               totalLookCount = totalLookCount + 1;
               numLooks = numLooks + 1; 

               % Print obs if requested
               if (punchObs > 0)
                  %PrintObs(fpObsFile, senSatData.senSatKey, punchObs);
               end
            end

            % Print diagnostic data if requested
            if (nosticFlg ~= 0)
               %PrintNosticdata(fp, senSatData.senSatKey, lookArr[IDX_LOOK_DS50UTC], lookArr[IDX_LOOK_MSE], 
               %                viewType, nosticFlg, lookCode, senElts, satElts);
            end


            % After the first point, set steps at even offset (Interval) from culmination time
            if (newPass && stepMode == STEPMODE_CULM)
               newPass = 0;
               % The differen in step sizes between the pass start time and the culmination time
               deltaT = (abs(culmTime - passStartDs50TAI) / (senSatData.interval / MINSPERDAY));

               % The fraction part of the difference
               deltaT = deltaT - fix(deltaT);

               if(culmTime < passStartDs50TAI)
                  deltaT = 1.0 - deltaT;
               end

               currDs50TAI = passStartDs50TAI + (deltaT * (senSatData.interval / MINSPERDAY));

               % The second point is within 1msec of the first point, increment the second point
               if (abs(currDs50TAI - passStartDs50TAI) < EPSTIMEDAYS)
                  currDs50TAI = currDs50TAI + (senSatData.interval / MINSPERDAY);
               end

            else

               % If the current time is within ~1msec the last point then exit
               if (abs(currDs50TAI - passStopDs50TAI) < EPSTIMEDAYS)
                  break;
               end
               currDs50TAI = currDs50TAI + (senSatData.interval / MINSPERDAY);
            end

            % Implement the maximum number of points per pass check
            if (maxPtsPerPass ~= 0 && numLooks >= maxPtsPerPass)
               break;
            end

            % Handle the last point of this pass
            if (currDs50TAI > passStopDs50TAI)

               if (currDs50TAI - passStopDs50TAI < EPSTIMEDAYS)
                  % the last point is within 1msec passed the passStopDs50TAI
                  ;
               % The set time is within the previous point and the last point (currDs50TAI)
               % replace the last point with the set time
               elseif (setTime <= passStopDs50TAI && (stepMode == STEPMODE_CULM || culmTime == -1.0))
                  currDs50TAI = passStopDs50TAI;
               else
                  break;
               end
            end
         end

         % Print pass number at the end of each pass if it isn't empty
         if (~emptyPass)
            passCount = passCount + 1;
            %fprintf(fp, '%67s%7d\n', ' ', passCount);
         end

      end
   end


   % Print looks obtained by a sen-sat pair (senSatKey) in Step step mode
   function [totalLookCount, passCount] = ...
      DoStepMode(fp, fpObsFile, senSatData, viewType, obsType, ...
                 maxPtsPerPass, nosticFlg, punchObs)

      totalLookCount = 0;
      passCount = 0;
      numLooks = 0;


      % Find the time duration to separate/distiguish new passes
      deltaTimeMin = max(max(senSatData.interval, 0.4 * senSatData.period), 40.0);

      newPass = 1;
      lastValidLookTime = senSatData.startDs50TAI;

      currDs50TAI = senSatData.startDs50TAI;

      % Loop through the requested start/stop time
      while (currDs50TAI <= senSatData.stopDs50TAI + EPSTIMEDAYS)

         % Determine if this starts a new pass
         if (~newPass && abs(currDs50TAI - lastValidLookTime)  >  (deltaTimeMin / MINSPERDAY))

            newPass = 1;

            % Print pass number at the end of the previous pass
            if (numLooks > 0)

               passCount = passCount + 1;
               %fprintf(fp, '%67s%7d\n', ' ', passCount);
            end

            numLooks = 0;
         end

         lookCode = int32(0);
         lookArr = double(zeros(6, 1));
         senElts = double(zeros(9, 1));
         satElts = double(zeros(9, 1));

         lookCodePtr = libpointer('int32Ptr', lookCode);
         lookArrPtr = libpointer('doublePtr', lookArr);
         senEltsPtr = libpointer('doublePtr', senElts);
         satEltsPtr = libpointer('doublePtr', satElts);

         % Compute the look angle at the specified time
         [errCode, lookCode, lookArr, senElts, satElts] = ...
            calllib('Lamod', 'LamodComputeLookAngle', senSatData.senSatKey, ...
                    currDs50TAI, lookCodePtr, lookArrPtr, senEltsPtr, satEltsPtr);

         if (errCode ~= 0)
            ShowErrMsg();
            return;
         end


         % Check to see if the look is valid
         if (lookCode == LOOK_VALID)
            newPass = 0;

            % Implement max number of points per pass check
            if (maxPtsPerPass == 0 || numLooks < maxPtsPerPass)
               currStep = ' ';

               % The 'p' in the output means the next step size will probably be outside of the requested stop time
               if (currDs50TAI + senSatData.interval / MINSPERDAY > senSatData.stopDs50TAI)
                  currStep = 'p';
               end
               
               if(numLooks == 0)
                  PrintLookHeader();
               end
               
               %PrintLook(fp, senSatData.senSatKey, viewType, obsType, senSatData.onlyVisPass, currStep, lookArr);
               PrintLook(fp, lookArr);

               totalLookCount = totalLookCount + 1;
               numLooks = numLooks + 1;

               if (punchObs > 0)
                  %PrintObs(fpObsFile, senSatData.senSatKey, punchObs);
               end
            end

            % Record the time of the last valid look
            lastValidLookTime = currDs50TAI;
         end

         % Print diagnostic data if requested
         if (nosticFlg ~= 0)
            %PrintNosticdata(fp, senSatData.senSatKey, lookArr[IDX_LOOK_DS50UTC], lookArr[IDX_LOOK_MSE], 
            %                viewType, nosticFlg, lookCode, senElts, satElts);
         end

         currDs50TAI = currDs50TAI + (senSatData.interval / MINSPERDAY);
      end

      % This pass might not have been counted
      if (~newPass)
         % Print pass number at the end of the previous pass
         if (numLooks > 0)

            passCount = passCount + 1;
            %fprintf(fp, '%67s%7d\n', ' ', passCount);
         end
      end
   
   end

   function PrintLookHeader()
      fprintf('        TIME            ELEV    AZ         RNG      RNG-RT\n');
      fprintf('YYYY DDD HHMM SS.SSS    deg     deg        km       km/sec\n');
   end 


   function PrintLook(fpOut, lookArr)
      ds50UTC     = lookArr(IDX_LOOK_DS50UTC);
      elevation   = lookArr(IDX_LOOK_ELEV);
      azimuth     = lookArr(IDX_LOOK_AZIM);
      range       = lookArr(IDX_LOOK_RNG);
      rangeRate   = lookArr(IDX_LOOK_RNGRT);

      currTimeStr = UTCToDtg20Str(ds50UTC);
      formatStr = '%s  %7.3f  %7.3f %10.3f %8.3f\n';
      fprintf(formatStr, currTimeStr, elevation, azimuth, range, rangeRate);
   end



end % End of RunLamod


% Load all the dlls being used in the program
function LoadAstroStdDlls()
   % Get current folder
   s = pwd;

   % Add relative path to header filesLa
   addpath([s '/../wrappers'])

      % Load MainDll dll
   loadlibrary DllMain    M_DllMainDll.h

   % Load EnvConst dll and assign function pointers
   loadlibrary EnvConst   M_EnvConstDll.h

   % Load TimeFunc dll and assign function pointers
   loadlibrary TimeFunc   M_TimeFuncDll.h

   % Load AstroFunc dll and assign function pointers
   loadlibrary AstroFunc  M_AstroFuncDll.h

   % Load Tle dll and assign function pointers
   loadlibrary Tle        M_TleDll.h

   % Load Sp Vector dll and assign function pointers
   loadlibrary SpVec      M_SpVecDll.h

   % Load Vcm dll and assign function pointers
   loadlibrary Vcm        M_VcmDll.h

   % Load ExtEphem dll and assign function pointers
   loadlibrary ExtEphem   M_ExtEphemDll.h

   % Load ExtEphem dll and assign function pointers
   loadlibrary ElOps      M_ElOpsDll.h

   % Load Sgp4Prop dll and assign function pointers
   loadlibrary Sgp4Prop   M_Sgp4PropDll.h

   % Load Lamod dll and assign function pointers
   loadlibrary SpProp     M_SpPropDll.h

   % Load Lamod dll and assign function pointers
   loadlibrary SatState   M_SatStateDll.h

   % Load Lamod dll and assign function pointers
   loadlibrary Sensor     M_SensorDll.h

   % Load Lamod dll and assign function pointers
   loadlibrary Obs        M_ObsDll.h
   
   % Load Lamod dll and assign function pointers
   loadlibrary Lamod     M_LamodDll.h
end


% Initialize all the dlls being used in the program
function InitAstroStdDlls()
   % Get pointer to the global data (data pointers, function pointers, ...)
   % that will be used among the dlls in the program

   apPtr = calllib('DllMain', 'DllMainInit');

   % Initialize EnvConst & check for error
   errCode = calllib('EnvConst',  'EnvInit',       apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end
   
   % Initialize TimeFunc & check for error
   errCode = calllib('TimeFunc',  'TimeFuncInit',  apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end
   
   % Initialize AstroFunc & check for error
   errCode = calllib('AstroFunc', 'AstroFuncInit', apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end

   % Initialize Tle & check for error
   errCode = calllib('Tle',       'TleInit',       apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end

   % Initialize SpVec & check for error
   errCode = calllib('SpVec',     'SpVecInit',     apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end

   % Initialize Vcm & check for error
   errCode = calllib('Vcm',       'VcmInit',       apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end

   % Initialize ExtEphem & check for error
   errCode = calllib('ExtEphem',  'ExtEphInit',       apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end

   % Initialize ElOps & check for error
   errCode = calllib('ElOps',  'ElOpsInit',       apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end
   
   % Initialize Lamod & check for error
   errCode = calllib('Sgp4Prop',     'Sgp4Init',       apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end

   % Initialize Lamod & check for error
   errCode = calllib('SpProp',       'SpInit',         apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end

   % Initialize Lamod & check for error
   errCode = calllib('SatState', 'SatStateInit',   apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end

   % Initialize Sensor & check for error
   errCode = calllib('Sensor',   'SensorInit',     apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end

   
   % Initialize Obs & check for error
   errCode = calllib('Obs',   'ObsInit',     apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end
   
   % Initialize Lamod & check for error
   errCode = calllib('Lamod',    'LamodInit',        apPtr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end

end


% Each dll read the main input file
function LoadInputsFrFile(inFile)
   % Load environmental data from the input file
   errCode = calllib('EnvConst', 'EnvLoadFile', inFile);
   if(errCode ~= 0)
      ShowMsgAndTerminate;
   end

   % Load timing constants from the input file
   errCode = calllib('TimeFunc', 'TConLoadFile', inFile);
   if(errCode ~= 0)
      ShowMsgAndTerminate;
   end

   % Load orbital elements/propagator setup from the input file
   errCode = calllib('SatState', 'SatStateLoadFile', inFile, 3);
   if(errCode ~= 0)
      ShowMsgAndTerminate;
   end

   % Load sensor from the input file
   errCode = calllib('Sensor', 'SensorLoadFile', inFile);
   if(errCode ~= 0)
      ShowMsgAndTerminate;
   end

   % Load sensor from the input file
   errCode = calllib('Lamod', 'LamodLoadFile', inFile);
   if(errCode ~= 0)
      ShowMsgAndTerminate;
   end
end


function [lamodCtrl] = GetLamodCtrlPara()
   timeFlg = int32(0);
   startTime = double(0);
   stopTime = double(0);
   stepSize = double(0);
   prtOpt = int32(0);
   punchObs = int32(0);
   visFlg = int32(0);
   stepMode = int32(0);
   schedMode = blanks(1);
   diagMode = int32(0);
   solAspAngle = double(0);


   timeFlgPtr = libpointer('int32Ptr', timeFlg);
   startTimePtr = libpointer('doublePtr', startTime);
   stopTimePtr = libpointer('doublePtr', stopTime);
   stepSizePtr = libpointer('doublePtr', stepSize);
   prtOptPtr = libpointer('int32Ptr', prtOpt);
   punchObsPtr = libpointer('int32Ptr', punchObs);
   visFlgPtr = libpointer('int32Ptr', visFlg);
   stepModePtr = libpointer('int32Ptr', stepMode);
   schedMode = blanks(1);
   %schedModePtr = libpointer('cstring', s.schedMode);
   diagModePtr = libpointer('int32Ptr', diagMode);
   solAspAnglePtr = libpointer('doublePtr', solAspAngle);



   % Call Lamod dll's function
   [timeFlg, startTime, stopTime, stepSize, prtOpt, ...
      punchObs, visFlg, stepMode, schedMode, diagMode, ...
      solAspAngle] = ...
      calllib('Lamod', 'LamodGet1pAll', ...
      timeFlgPtr, startTimePtr, stopTimePtr, stepSizePtr, prtOptPtr, ...
      punchObsPtr, visFlgPtr, stepModePtr, schedMode, diagModePtr, ...
      solAspAnglePtr);


   s = struct('timeFlg',      timeFlg, ...
              'startTime',    startTime, ...
              'stopTime',     stopTime, ...
               'stepSize',    stepSize, ...
               'prtOpt',      prtOpt, ...
               'punchObs',    punchObs, ...
               'visFlg',      visFlg, ...
               'stepMode',    stepMode, ...
               'schedMode',   schedMode, ...
               'diagMode',    diagMode, ...
               'solAspAngle', solAspAngle);

   lamodCtrl = s;
end

   % Unload the library before leaving the program
function FreeAstroStdDlls()
   calllib('DllMain', 'CloseLogFile')
   unloadlibrary DllMain
   unloadlibrary EnvConst
   unloadlibrary TimeFunc
   unloadlibrary AstroFunc
   unloadlibrary Tle
   unloadlibrary SpVec
   unloadlibrary Vcm
   unloadlibrary ExtEphem
   unloadlibrary Sgp4Prop
   unloadlibrary SpProp
   unloadlibrary SatState
   unloadlibrary Sensor
   unloadlibrary Lamod
   close all
   clear all
end



function errMSg=ShowErrMsg()
   errMsg = blanks(128);
   errMsg = calllib('DllMain', 'GetLastErrMsg', errMsg);
   fprintf('%s\n', errMsg);
end 

function ShowMsgAndTerminate
   errMsg = ShowErrMsg();
   error(errMsg);
   UnloadDlls;
end
   

function [dtg20Str] = UTCToDtg20Str(ds50UTC)
   dtg20Str = blanks(20);
   dtg20Str = calllib('TimeFunc', 'UTCToDTG20', ds50UTC, dtg20Str);
end

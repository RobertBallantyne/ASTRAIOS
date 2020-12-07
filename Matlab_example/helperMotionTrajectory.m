classdef helperMotionTrajectory < kinematicTrajectory
    
    properties
        MotionModelFcn
    end
    
    methods
        function obj = helperMotionTrajectory(mmfcn, varargin)
            obj@kinematicTrajectory(varargin{:});
            obj.MotionModelFcn = mmfcn;
        end
    end
            
    methods (Access = protected)
        function stepImpl(obj,varargin)
            % Use the motion model function to update Position and Velocity
            dt = 1/obj.SampleRate;
            r = obj.Position;
            v = obj.Velocity; 
            state = [r(1);v(1);r(2);v(2);r(3);v(3)];
            newstate = obj.MotionModelFcn(state,dt);
            obj.Position = newstate([1 3 5])';
            obj.Velocity = newstate([2 4 6])';
        end
    end
end
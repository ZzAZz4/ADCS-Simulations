% Has to be a class to be able to import the functions to the cli

classdef Simulator
    properties
        vec_gains
        pid_params
        table_data
    end
    methods(Static)
        function [C_pi, T_pi] = make_model(sys, gain)
            [C_pi, ~] = pidtune(sys, 'PIDF', gain);
            T_pi = feedback(C_pi*sys, 1);
        end
        
        function plot(name, props)
            plot(props(:,1:1)', props(:,2:2)')
            title(name);
            xlabel("PID Gain")
        end
    end
    
    methods
        function result = settling_time(obj)
            result = [obj.vec_gains obj.table_data(:,1:1)];
        end
        
        function result = settling_min(obj)
            result = [obj.vec_gains obj.table_data(:,2:2)];
        end
        
        function result = settling_max(obj)
            result = [obj.vec_gains obj.table_data(:,3:3)];
        end
        
        function result = overshoot(obj)
            result = [obj.vec_gains obj.table_data(:,4:4)];
        end
        
        function result = undershoot(obj)
            result = [obj.vec_gains obj.table_data(:,5:5)];
        end
        
        function result = peak(obj)
            result = [obj.vec_gains obj.table_data(:,6:6)];
        end
        
        function result = peak_time(obj)
            result = [obj.vec_gains obj.table_data(:,7:7)];
        end
        
        function result = rise_time(obj)
            result = [obj.vec_gains obj.table_data(:,8:8)];
        end
        
        function dump(obj, filename)
            table = [obj.vec_gains obj.table_data];
            labels = ["PID Gain (x)", "SettlingTime", "SettlingMin", "SettlingMax", "Overshoot", "Undershoot", "Peak", "PeakTime", "RiseTime"];
            format = [labels; table];
            xlswrite(filename, format);
        end
        
        
        function obj = Simulator(system, vec_gains)
            dims = size(vec_gains);
            obj.vec_gains = vec_gains';
            
            length = dims(2);
            obj.table_data = zeros(length, 8);
            obj.pid_params = zeros(length, 8);
                        
            for i = 1:length
                gain = vec_gains(i);
                [~, T_pi] = Simulator.make_model(system, gain);
                sti = stepinfo(T_pi);
                
                obj.table_data(i:i,:) = [
                    sti.SettlingTime
                    sti.SettlingMin
                    sti.SettlingMax
                    sti.Overshoot
                    sti.Undershoot
                    sti.Peak
                    sti.PeakTime
                    sti.RiseTime
                ];
            end
       end
   end
end

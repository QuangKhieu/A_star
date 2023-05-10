vrep = remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1);
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);

if (clientID>-1)
    disp('Connected to remote API server');
    
    [~, left_motor] = vrep.simxGetObjectHandle(clientID,'motor_left', vrep.simx_opmode_blocking);
    [~, right_motor] = vrep.simxGetObjectHandle(clientID,'motor_right', vrep.simx_opmode_blocking);
    [~, front_sensor] = vrep.simxGetObjectHandle(clientID,'front_prox', vrep.simx_opmode_blocking);
    [~, RobotHandle] = vrep.simxGetObjectHandle(clientID,'Robotpose', vrep.simx_opmode_blocking);
    
    [~,OrieRobot] = vrep.simxGetObjectOrientation(clientID,RobotHandle,-1,vrep.simx_opmode_streaming);
    [~,PosiRobot] = vrep.simxGetObjectPosition(clientID,RobotHandle,-1,vrep.simx_opmode_streaming);
    pause(0.5)
    
   load('goals_A_star.mat');
 % hieu chinh goal matlab->vrep
        goals=goals/2;
  
       a = movetogoal(clientID, vrep, left_motor, right_motor, RobotHandle,goals);     
 
        
else 
    disp('Fail');
end


vrep.delete();
disp('Program ended');

function [isReached] = movetogoal(clientID, vrep, left_motor, right_motor, RobotHandle,goals)
     offset = 0.1;
     maxspeed = 5;
     R = 0.03;
     L = 0.1665;
     dt=0.05;
     prev_error = 0;
     for i=1:length(goals)
         goal = goals(:,i);
         isReached = 0;
        while(~isReached )
      
         [~,OrieRobot] = vrep.simxGetObjectOrientation(clientID,RobotHandle,-1,vrep.simx_opmode_buffer);
         [~,PosiRobot] = vrep.simxGetObjectPosition(clientID,RobotHandle,-1,vrep.simx_opmode_buffer);
        
          Pos_xy = [PosiRobot(1);PosiRobot(2)];
          Ori_z  = OrieRobot(3);       
           %check
          if(norm(Pos_xy-goal)<offset)
              isReached = 1;
         
          else
             isReached =0;
          end
          
            v_g = goal - Pos_xy;
            %chuan hoa
            v_g = 1/sqrt(v_g(1)^2+v_g(2)^2)*v_g;
     
            v = 4*sqrt(v_g(1)^2+v_g(2)^2);
            %Kp
            Kp = 30;
            %Ki
            Ki = 10;
            %Kd
            Kd = 10;

            %heading
            heading = atan2(v_g(2),v_g(1));
     
            %PID
            %tính sai s? hi?n t?i error
            error = heading - Ori_z;
            if(error > pi)
                error = error - 2*pi;
            elseif(error < -pi)
                error = error + 2*pi;
            end

            %tính toán giá tr? ki?m soát PID
            integral_error = (prev_error + error)*dt/2;
            derivative_error = (error - prev_error)*dt;
            control = Kp*error + Ki*integral_error + Kd*derivative_error;

            %gán giá tr? error cho prev_error ?? s? d?ng cho l?n tính toán ti?p theo
            prev_error = error;
            %gán giá tr? omega b?ng control ?? ??a vào robot
            omega = control;

            % cal
            vR = v + omega*L/2;
            vL = v - omega*L/2;
            if(vL>maxspeed)
                vL = maxspeed;
            elseif(vL<-maxspeed)
                vL = -maxspeed;
            end
            if(vR>maxspeed)
                vR = maxspeed;
            elseif(vR<-maxspeed)
                vR = -maxspeed;
            end
     
              [~] = vrep.simxSetJointTargetVelocity(clientID, left_motor, vL, vrep.simx_opmode_blocking);
              [~] = vrep.simxSetJointTargetVelocity(clientID, right_motor, vR, vrep.simx_opmode_blocking); 
              
        end
         if(i==length(goals))
               [~] = vrep.simxSetJointTargetVelocity(clientID, left_motor, 0, vrep.simx_opmode_blocking);
              [~] = vrep.simxSetJointTargetVelocity(clientID, right_motor, 0, vrep.simx_opmode_blocking); 
         end
             
     end  
    

end
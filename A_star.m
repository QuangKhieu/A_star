
start=[3,3];
goal=[37,34 ];
cell(1:42,1:46) = A_star_cell;
load('gridmap_46x42_scene.mat');
for m=1:42
    for n=1:46
        cell(m,n).xy_current = [n,m];
    end
end
cell(start(2),start(1)).xy_parent=start;
cell(start(2),start(1)).f_cell=0;
open_list =[cell(start(2),start(1))];
close_list =[];
generate_map();
while(true)
    %check
        if(start(1)<2||start(2)<2||start(1)>46||start(2)>42||grid_map(start(2),start(1))==inf)
        disp("Wrong start");
        return;
    end
     %check goal
    if(goal(1)<2||goal(2)<2||goal(1)>46||goal(2)>42||grid_map(goal(2),goal(1))==inf)
        disp("Wrong goal");
        return;
    end
    
    current_node = open_list(1);
    close_list = [close_list,current_node]; %add current node to close list
    open_list(1)=[]; %remove current from open
    cell(current_node.xy_current(1),current_node.xy_current(2)).pos = "close";
    
    if(current_node.xy_current==goal) %if path found: break
        disp("detected")
        break;
    end
    c_point = current_node.xy_current; %current node coor
    fill([0 ;1; 1; 0]+c_point(1),[0; 0 ;1 ;1]+c_point(2),'b')  ;
    pause(0.01);    
    % toa do tat ca cac dinh con ke current_node (dinh dang xet)
    [x,y] = meshgrid(c_point(1)-1:c_point(1)+1,...
                     c_point(2)-1:c_point(2)+1);
    x = reshape(x',1,[]);
    y = reshape(y',1,[]);
    
    %cal
    for i=1:9
        if( strcmp(cell(y(i),x(i)).pos,"close")||grid_map(y(i),x(i))==inf)         
            continue;   
        end
        
        if(isempty(cell(y(i),x(i)).pos))
            cell(y(i),x(i)).f_cell = floor(norm(cell(y(i),x(i)).xy_current-c_point)*10)+cell(c_point(2),c_point(1)).f_cell+ ...
                                     mDis(cell(y(i),x(i)).xy_current-goal);
                                    %norm(cell(y(i),x(i)).xy_current-goal); 
                                    %f(x) = g(x)+
                                    %       h(x)
            cell(y(i),x(i)).xy_parent = c_point;
            cell(y(i),x(i)).pos = "open";
            open_list=[open_list,cell(y(i),x(i))];
            
            continue;
        end
        
        new_path=floor(norm(cell(y(i),x(i)).xy_current-c_point)*10)+cell(c_point(2),c_point(1)).f_cell+ ...
                 mDis(cell(y(i),x(i)).xy_current-goal);
                 %norm(cell(y(i),x(i)).xy_current-goal); 
        if(new_path<cell(y(i),x(i)).f_cell)
            cell(y(i),x(i)).f_cell = new_path;
            cell(y(i),x(i)).xy_parent = c_point;  
        end
    end
    
    %sap xep open_list
    min = inf;
    temp = 0;
    for i=1:length(open_list)
        if(min>open_list(i).f_cell)
            min = open_list(i).f_cell;
            temp = i;
        end
    end
    open_list([1 temp])=open_list([temp 1]);
    
    
end
temp = close_list(length(close_list)).xy_parent;
goals = [goal'];
while(temp(1)~=start(1) || temp(2)~=start(2))
   goals=[temp',goals];
    temp = cell(temp(2),temp(1)).xy_parent;
     
end
goals = [start',goals];
save goals_A_star goals;

 for i=1:length(goals)
    fill([0 ;1; 1; 0]+goals(1,i),[0; 0 ;1 ;1]+goals(2,i) ,'r')  ;
     pause(0.05)
 end

function distance = mDis(vector)
    distance = abs(vector(1)) + abs(vector(2));
end
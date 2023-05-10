function [] = generate_map()

% map setting
map_size = [46, 42];%42 hang 46 cot cotxhang
%bubble map1
% %x;y                      I      L         F          T        Z 
bb_sta = [1  1    1  46     14    8 8     37 41 41    29 31   22 25 20;...
          1  1    42  1     2    31 29   3  12 7     34 26   17 22 17];
bb_sto = [1   46  46   46   19    17 12   40 45 42    36 34   24 27 21;...
          42   1  42   42   11    34 30   14 14 9     38 33   24 24 19 ];

%map1
% %x;y            bound           I        L            F           T       Z 
obs_sta = [1  1    1  46        15      9 12       38 40 40     30 32   23 21 24 ;...
           1  1    42  1        1       30 32       4  8 13     35 27   18 18 23 ];
obs_sto = [1   46  46   46      18      11 16      39 41 46     35 33   23 22 26 ;...
           42   1  42   42      10      33 33      13  8  13    37 34   23 18 23 ];

%map2
%x;y            bound           I        L      F           T       Z 
% obs_sta = [1  1    1  46        15      9        40 40     30    23 21 24 ;...
%            1  1    42  1        4       30        8 13     30    18 18 23 ];
% obs_sto = [1   46  46   46      18      17       41 46     35    23 22 26 ;...
%            42   1  42   42      10      33        8  13    37    23 18 23 ];



% create grid
  grid_map = generate_grid(map_size, bb_sta,bb_sto);
  save gridmap_46x42_scene grid_map
 [r,c] =find(grid_map==inf);
 figure(1); hold on;grid minor;

for i=1:length(r)
    fill([0 ;1; 1; 0]+c(i),[0; 0 ;1 ;1]+r(i) ,'y')  
end


  grid_map = generate_grid(map_size, obs_sta,obs_sto);
  [r,c] =find(grid_map==inf);

for i=1:length(r)
    fill([0 ;1; 1; 0]+c(i),[0; 0 ;1 ;1]+r(i) ,'g')  
end
end

function grid_map = generate_grid(size, obs_sta,obs_sto)
pos=[];
    grid_map = ones(size(2), size(1));

for i=1:length(obs_sta)
    [x,y] = meshgrid(obs_sta(1,i):obs_sto(1,i),obs_sta(2,i):obs_sto(2,i));
    x=reshape(x',1,[]);
    y=reshape(y',1,[]);
    pos=[pos,posc_cal(x,y,size)];
end
    grid_map(pos) = inf;

end   

function pos = posc_cal(x,y,map_size)%((y;x),(cot,hang))
pos=[];
    for i =1:length(x)
        pos = [pos,y(i) + (x(i)-1)*map_size(2)];
    end
end
%vi tri o chia doi bang vij tri tren mo phong

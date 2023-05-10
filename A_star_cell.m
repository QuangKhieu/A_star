classdef A_star_cell

    properties
        xy_current;
        xy_parent;
        f_cell;
        g_cell;
        pos;
    end
    
    methods     
        function obj = A_star_cell(start,f)
            if nargin == 2
                obj.xy_parent = start;
                obj.f_cell =f;
            end   
        end
    end
end


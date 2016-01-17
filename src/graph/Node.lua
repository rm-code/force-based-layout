local Node = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Node.new( x, y, radius, mass, color )
    local self = {};

    local px, py = x, y;
    local vx, vy = 0, 0;
    local ax, ay = 0, 0;
    local age    = 0;
    local maxage = love.math.random( 30, 60 );
    local dead   = false;

    radius = radius or love.math.random( 5, 15 );
    mass   = mass   or radius * 0.01;
    
    color  = color  or { r = 17 * radius, g = 17 * radius, b = 255, a = 255 };

    ---
    -- Apply the calculated acceleration to the node.
    --
    local function move()
        vx = vx + ax;
        vy = vy + ay;

        px = px + vx;
        py = py + vy;

        ax, ay = 0, 0;
    end

    function self:update( dt )
        age = age + dt;
        if age > maxage then
            color.a = color.a - 30 * dt;
            if color.a <= 0 then
                dead = true;
                color.a = 0;
            end
        end
        move( dt );
    end

    function self:draw()
        love.graphics.setColor( color.r, color.g, color.b, color.a );
        love.graphics.circle( 'line', px, py, radius );
        love.graphics.setColor( 255, 255, 255, 255 );
    end

    function self:applyForce( dx, dy )
        ax = ax + dx;
        ay = ay + dy;
    end

    function self:getX()
        return px;
    end

    function self:getY()
        return py;
    end

    function self:damp( f )
        vx, vy = vx * f, vy * f;
    end

    function self:getMass()
        return mass;
    end

    function self:setPosition( nx, ny )
        px, py = nx, ny;
    end

    function self:isDead()
        return dead;
    end

    return self;
end

return Node;

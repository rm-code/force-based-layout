local Screen = require('lib/screenmanager/Screen');
local Queue = require('src.Queue');
local Node = require('src/graph/Node');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local MainScreen = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local MAX_NODES = 300;
local spring = -0.0008;
local charge = 800;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function MainScreen.new()
    local self = Screen.new();

    local spawnDelay;

    local queue;
    local nodes;

    function self:init()
        love.mouse.setVisible( false );

        spawnDelay = 1;

        queue = Queue.new();
        local id = 1;

        for _ = 1, MAX_NODES do
            local sx, sy = love.math.random( 0, love.graphics.getWidth() ), love.math.random( 0, love.graphics.getHeight() );
            queue:enqueue( Node.new( id, sx, sy ));
            id = id + 1;
        end

        nodes = {};
    end

    local function attract( node, x1, y1, x2, y2 )
        local dx, dy = x1 - x2, y1 - y2;
        local distance = math.sqrt( dx * dx + dy * dy );
        distance = math.max( 0.001, math.min( distance, 100 ));

        -- Normalise vector.
        dx = dx / distance;
        dy = dy / distance;

        -- Calculate spring force and apply it.
        local force = spring * distance;
        node:applyForce( dx * force, dy * force );
    end

    local function repulse( a, b )
        -- Calculate distance vector.
        local dx, dy = a:getX() - b:getX(), a:getY() - b:getY();
        local distance = math.sqrt( dx * dx + dy * dy );
        distance = math.max( 0.001, math.min( distance, 1000 ));

        -- Normalise vector.
        dx = dx / distance;
        dy = dy / distance;

        -- Calculate force's strength and apply it to the vector.
        local strength = charge * (( a:getMass() * b:getMass() ) / ( distance * distance ));
        dx = dx * strength;
        dy = dy * strength;

        a:applyForce( dx, dy );
    end

    function self:update( dt )
        spawnDelay = spawnDelay + dt;
        if not ( queue:isEmpty() ) and spawnDelay > 0.2 then
            local node = queue:dequeue();
            nodes[node:getID()] = node;
            spawnDelay = 0;
        end

        for idA, nodeA in pairs( nodes ) do
            if not nodeA:isDead() then

                attract( nodeA, nodeA:getX(), nodeA:getY(), love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5 );

                for _, nodeB in pairs( nodes ) do
                    if nodeA ~= nodeB then
                        repulse( nodeA, nodeB );
                    end
                end

                nodeA:damp( 0.95 );
                nodeA:update( dt );
            else
                nodes[idA]:reset();
                queue:enqueue( nodes[idA] );
                nodes[idA] = nil;
            end
        end
    end

    function self:draw()
        for _, node in pairs( nodes ) do
            node:draw();
        end
    end

    function self:keypressed( key )
        if key == '+' then
            charge = charge + 200;
        elseif key == '-' then
            charge = charge - 200;
        elseif key == 'w' then
            spring = spring * 1.1;
        elseif key == 's' then
            spring = spring / 1.1;
        elseif key == 'escape' then
            love.event.quit();
        end
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return MainScreen;

local Screen = require('lib/screenmanager/Screen');
local Node = require('src/graph/Node');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local MainScreen = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local spring = -0.0008;
local charge = 800;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function MainScreen.new()
    local self = Screen.new();

    local nodes = {};
    local id = 0;

    local useCursor = true;
    local cursor = Node.new(love.mouse.getX(), love.mouse.getY(), 4, 5, { r = 100, g = 200, b = 0, a = 255 });
    cursor:setPosition(love.mouse.getPosition());
    love.mouse.setVisible(false);

    local function addNode(nodes, id)
        nodes[id] = Node.new(love.mouse.getX() + love.math.random(-10, 10), love.mouse.getY() + love.math.random(-10, 10));
        return id + 1;
    end

    local function attract(node, x1, y1, x2, y2)
        local dx, dy = x1 - x2, y1 - y2;
        local distance = math.sqrt(dx * dx + dy * dy);
        distance = math.max(0.001, math.min(distance, 100));

        -- Normalise vector.
        dx = dx / distance;
        dy = dy / distance;

        -- Calculate spring force and apply it.
        local force = spring * distance;
        node:applyForce(dx * force, dy * force);
    end

    local function repulse(a, b)
        -- Calculate distance vector.
        local dx, dy = a:getX() - b:getX(), a:getY() - b:getY();
        local distance = math.sqrt(dx * dx + dy * dy);
        distance = math.max(0.001, math.min(distance, 1000));

        -- Normalise vector.
        dx = dx / distance;
        dy = dy / distance;

        -- Calculate force's strength and apply it to the vector.
        local strength = charge * ((a:getMass() * b:getMass()) / (distance * distance));
        dx = dx * strength;
        dy = dy * strength;

        a:applyForce(dx, dy);
    end

    function self:update(dt)
        if useCursor then
            cursor:setPosition(love.mouse.getPosition());
        end

        if love.mouse.isDown('l') then
            id = addNode(nodes, id);
        end

        for idA, nodeA in pairs(nodes) do
            if not nodeA:isDead() then

                attract(nodeA, nodeA:getX(), nodeA:getY(), love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5);

                for idB, nodeB in pairs(nodes) do
                    if nodeA ~= nodeB then
                        repulse(nodeA, nodeB);
                    end
                end

                if useCursor then
                    repulse(nodeA, cursor);
                end
                nodeA:damp(0.95);
                nodeA:update(dt);
            else
                nodes[idA] = nil;
            end
        end
    end

    function self:draw()
        for id, node in pairs(nodes) do
            node:draw();
        end
        if useCursor then
            cursor:draw();
        end
    end

    function self:keypressed(key)
        if key == ' ' then
            useCursor = not useCursor;
        elseif key == '+' then
            charge = charge + 200;
        elseif key == '-' then
            charge = charge - 200;
        elseif key == 'w' then
            spring = spring * 1.1;
        elseif key == 's' then
            spring = spring / 1.1;
        end
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return MainScreen;

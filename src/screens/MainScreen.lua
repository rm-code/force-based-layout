--==================================================================================================
-- Copyright (C) 2014 - 2015 by Robert Machmer                                                     =
--                                                                                                 =
-- Permission is hereby granted, free of charge, to any person obtaining a copy                    =
-- of this software and associated documentation files (the "Software"), to deal                   =
-- in the Software without restriction, including without limitation the rights                    =
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell                       =
-- copies of the Software, and to permit persons to whom the Software is                           =
-- furnished to do so, subject to the following conditions:                                        =
--                                                                                                 =
-- The above copyright notice and this permission notice shall be included in                      =
-- all copies or substantial portions of the Software.                                             =
--                                                                                                 =
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR                      =
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,                        =
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE                     =
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER                          =
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,                   =
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN                       =
-- THE SOFTWARE.                                                                                   =
--==================================================================================================

local Screen = require('lib/screenmanager/Screen');
local Node = require('src/graph/Node');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local MainScreen = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local DELAY = 0.2;
local SPRING = -0.0008;
local CHARGE = 800;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function MainScreen.new()
    local self = Screen.new();

    local nodes = {};
    local id = 0;
    local timer = 0;

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
        local force = SPRING * distance;
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
        local strength = CHARGE * ((a:getMass() * b:getMass()) / (distance * distance));
        dx = dx * strength;
        dy = dy * strength;

        a:applyForce(dx, dy);
    end

    function self:update(dt)
        if love.mouse.isDown('l') then
            if timer <= 0 then
                id = addNode(nodes, id);
                timer = DELAY;
            else
                timer = timer - dt;
            end
        end

        for idA, nodeA in ipairs(nodes) do
            attract(nodeA, nodeA:getX(), nodeA:getY(), love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5);

            for idB, nodeB in ipairs(nodes) do
                if nodeA ~= nodeB then
                    repulse(nodeA, nodeB);
                end
            end

            nodeA:damp(0.95);
            nodeA:update(dt);
        end
    end

    function self:draw()
        for id, node in ipairs(nodes) do
            node:draw();
        end
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return MainScreen;

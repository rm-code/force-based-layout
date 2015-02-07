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

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function MainScreen.new()
    local self = Screen.new();

    local nodes = {};
    local id = 0;
    local timer = 0;

    local function addNode(nodes, id)
        nodes[id] = Node.new(love.mouse.getPosition());
        return id + 1;
    end

    local function gravitate(node, x1, y1, x2, y2)
        local dx, dy = x1 - x2, y1 - y2;
        local r = math.sqrt(dx * dx + dy * dy);

        -- Normalise vector.
        dx = dx / r;
        dy = dy / r;

        local force = 1000 * ((1 * 1) / math.pow(r, 2));
        force = math.min(force, 1);

        dx = dx * force;
        dy = dy * force;

        node:applyForce(-dx, -dy);
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

        for id, node in ipairs(nodes) do
            gravitate(node, node:getX(), node:getY(), love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5);
            node:update(dt);
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

--==================================================================================================
-- Copyright (C) 2015 by Robert Machmer                                                            =
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

local Node = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Node.new(x, y, radius, mass, col)
    local self = {};

    local px, py = x, y;
    local vx, vy = 0, 0;
    local ax, ay = 0, 0;
    local radius = radius or love.math.random(5, 15);
    local mass = mass or radius * 0.01;
    local color = col or { r = 17 * radius, g = 17 * radius, b = 255, a = 255 };
    local age = 0;
    local maxage = love.math.random(30, 60);
    local dead = false;

    ---
    -- Apply the calculated acceleration to the node.
    --
    local function move(dt)
        vx = vx + ax;
        vy = vy + ay;

        px = px + vx;
        py = py + vy;

        ax, ay = 0, 0;
    end

    function self:update(dt)
        age = age + dt;
        if age > maxage then
            color.a = color.a - 30 * dt;
            if color.a <= 0 then
                dead = true;
            end
        end
        move(dt);
    end

    function self:draw()
        love.graphics.setColor(color.r, color.g, color.b, color.a);
        love.graphics.circle('line', px, py, radius);
        love.graphics.setColor(255, 255, 255, 255);
    end

    function self:applyForce(dx, dy)
        ax = ax + dx;
        ay = ay + dy;
    end

    function self:getX()
        return px;
    end

    function self:getY()
        return py;
    end

    function self:damp(f)
        vx, vy = vx * f, vy * f;
    end

    function self:getMass()
        return mass;
    end

    function self:setPosition(nx, ny)
        px, py = nx, ny;
    end

    function self:isDead()
        return dead;
    end

    return self;
end

return Node;

local Queue = {};

function Queue.new()
    local self = {};

    local queue = {};

    function self:enqueue( item )
        table.insert( queue, 1, item );
    end

    function self:dequeue()
        return table.remove( queue );
    end

    function self:isEmpty()
        return #queue == 0;
    end

    return self;
end

return Queue;

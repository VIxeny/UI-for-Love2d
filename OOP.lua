Class = {}

function Class.new()
    local newClass = {}
    local class_mt = {__index = newClass}

    function newClass.new(...)
        local instance = {}
        setmetatable(instance, class_mt)

        if newClass.init then
            newClass.init(instance, ...)
        end

        return instance
    end

    function newClass.extends(parentClass)
        setmetatable(newClass, {__index = parentClass})
        return newClass
    end

    function newClass.isParent(parentClass)
        if newClass == parentClass then
            return true
        end

        if getmetatable(newClass) then
            return getmetatable(newClass).__index.isParent(parentClass)
        end
        
        return false
    end

    return newClass
end

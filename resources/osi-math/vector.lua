Vec = { x = 0, y = 0, z = 0 }

function Vec:Vec(x,y,z)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    if x ~= nil then obj.x = x end
    if y ~= nil then obj.y = y end
    if z ~= nil then obj.z = z end
    return obj
end

function Vec:tostring()
    return "("..string.format("%.2f",self.x)..", "..string.format("%.2f",self.y)..", "..string.format("%.2f",self.z)..")"
end

function Vec:cross(vec)
    return Vec:Vec(self.y * vec.z - self.z * vec.y,
                   self.x * vec.z - self.z * vec.x,
                   self.x * vec.y - self.y * vec.x)
end

function Vec:dot(vec)
    return (self.x*vec.x + self.y*vec.y + self.z*vec.z)
end

function Vec:magnitude()
    return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
end

function Vec:normalize()
    local mag = self:magnitude()
    self.x = self.x / mag
    self.y = self.y / mag
    self.z = self.z / mag
    return self
end

function Vec:scale(scale)
    self.x = self.x * scale
    self.y = self.y * scale
    self.z = self.z * scale
    return self
end

function Vec:add(vec)
    self.x = self.x + vec.x
    self.y = self.y + vec.y
    self.z = self.z + vec.z
    return self
end

function Vec:sub(vec)
    self.x = self.x - vec.x
    self.y = self.y - vec.y
    self.z = self.z - vec.z
    return self
end

function Vec.Scale(vec, scale)
    local res = vec:clone()
    res:scale(scale)
    return res
end

function Vec.Add(vec1, vec2)
    local res = vec1:clone()
    res:add(vec2)
    return res
end

function Vec.Sub(vec1, vec2)
    local res = vec1:clone()
    res:sub(vec2)
    return res
end

function Vec:clone()
    return Vec:Vec(self.x, self.y, self.z)
end

function Vec:up()
    return Vec:Vec(0,0,1)
end

function Vec:right()
    return Vec:Vec(1,0,0)
end

function Vec:forward()
    return Vec:Vec(0,1,0)
end
Matrix = { row1 = Vec:Vec(0,0,0), row2 = Vec:Vec(0,0,0), row3 = Vec:Vec(0,0,0) }

function Matrix:Matrix()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.row1 = Vec:Vec(1,0,0)
    obj.row2 = Vec:Vec(0,1,0)
    obj.row3 = Vec:Vec(0,0,1)
    return obj
end

function Matrix.RotationMatrixAsVecs(direction)
    local forward = Vec:Vec(direction.x, direction.y, direction.z)
    local right = Vec:up():cross(forward):normalize()
    local up = forward:cross(right):normalize()

    return right, forward, up
end

function Matrix:tostring()
    return self.row1:tostring() .. "\n" .. self.row2:tostring() .. "\n" .. self.row3:tostring()
end

function Matrix.MultiplyMatrix(m1, m2)
    local result = Matrix:Matrix()
    result.row1.x = m1.row1:dotOfComponents(m2.row1.x, m2.row2.x, m2.row3.x)
    result.row1.y = m1.row1:dotOfComponents(m2.row1.y, m2.row2.y, m2.row3.y)
    result.row1.z = m1.row1:dotOfComponents(m2.row1.z, m2.row2.z, m2.row3.z)

    result.row2.x = m1.row2:dotOfComponents(m2.row1.x, m2.row2.x, m2.row3.x)
    result.row2.y = m1.row2:dotOfComponents(m2.row1.y, m2.row2.y, m2.row3.y)
    result.row2.z = m1.row2:dotOfComponents(m2.row1.z, m2.row2.z, m2.row3.z)

    result.row3.x = m1.row3:dotOfComponents(m2.row1.x, m2.row2.x, m2.row3.x)
    result.row3.y = m1.row3:dotOfComponents(m2.row1.y, m2.row2.y, m2.row3.y)
    result.row3.z = m1.row3:dotOfComponents(m2.row1.z, m2.row2.z, m2.row3.z)
    return result
end

function Matrix:multiplyMatrix(matrix)
    local result = Matrix.MultiplyMatrix(self, matrix)
    self.row1 = result.row1
    self.row2 = result.row2
    self.row3 = result.row3
    return self
end

function Matrix:rotateX(degree)
    local rotM = Matrix:Matrix()
    local r = math.rad(degree)
    local c = math.cos(r)
    local s = math.sin(r)
    rotM.row2.y = c
    rotM.row2.z = s
    rotM.row3.y = -s
    rotM.row3.z = c
    return self:multiplyMatrix(rotM)
end

function Matrix:rotateY(degree)
    local rotM = Matrix:Matrix()
    local r = math.rad(degree)
    local c = math.cos(r)
    local s = math.sin(r)
    rotM.row1.x = c
    rotM.row1.z = -s
    rotM.row3.x = s
    rotM.row3.z = c
    return self:multiplyMatrix(rotM)
end

function Matrix:rotateZ(degree)
    local rotM = Matrix:Matrix()
    local r = math.rad(degree)
    local c = math.cos(r)
    local s = math.sin(r)
    rotM.row1.x = c
    rotM.row1.y = -s
    rotM.row2.x = s
    rotM.row2.y = c
    return self:multiplyMatrix(rotM)
end
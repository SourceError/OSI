Matrix = {}

function Matrix.RotationMatrixAsVecs(direction)
    local forward = Vec:Vec(direction.x, direction.y, direction.z)
    local right = Vector:up():cross(forward):normalize()
    local up = forward:cross(right):normalize()

    return right, forward, up
end
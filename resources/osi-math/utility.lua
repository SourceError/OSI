if osi == nil then osi = {} end

function osi.screenToWorld(x,y, width, height, fov, direction)
    local fov_rad = math.rad(fov)
    local u,v,w = Matrix.RotationMatrixAsVecs(direction)

    local w_p = Vec.Scale(u, -width/2)
    w_p:add(Vec.Scale(v, height/2))
    w_p:sub(Vec.Scale(w, (height/2)/math.tan(fov_rad*0.5)))

    u:scale(x)
    v:scale(-y)

    local res = Vec.Add(u, v):add(w_p):normalize()
    return Vec:Vec(res.y, res.x, -res.z)
end
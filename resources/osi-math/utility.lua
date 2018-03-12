if osi == nil then osi = {} end

function osi.screenToWorld(x,y, width, height, fov, direction)
    local fov_rad = math.rad(fov)
    local u,v,w = Matrix.RotationMatrixAsVecs(direction)

    local v_p = Vec.Scale(u, -width/2)
    v_p:sub(Vec.Scale(v, (height/2)/math.tan(fov_rad*0.5)))
    v_p:add(Vec.Scale(w, height/2))

    u:scale(x)
    w:scale(-y)

    local res = Vec.Add(u, v_p):add(w); res:normalize()
    return res
end
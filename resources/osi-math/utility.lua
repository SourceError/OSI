if osi == nil then osi = {} end

function osi.screenToWorld(x,y, width, height, fov, camMatrix)
    local fov_rad = math.rad(fov)
    local u,v,w = camMatrix.row1:clone(), camMatrix.row2:clone(), camMatrix.row3:clone()

    local v_p = Vec.Scale(u, -width/2)
    v_p:add(Vec.Scale(v, (height/2)/math.tan(fov_rad*0.5)))
    v_p:add(Vec.Scale(w, height/2))

    u:scale(x)
    w:scale(-y)

    return Vec.Add(u, v_p):add(w):normalize()
end
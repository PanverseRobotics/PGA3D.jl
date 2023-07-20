
#line_fromto(from::Point3D, to::Point3D) = unitize(Line3D(to[1] - from[1], to[2] - from[2], to[3] - from[3], cross(SA[from[1], from[2], from[3]], SA[to[1], to[2], to[3]])...))
line_fromto(from::Point3D, to::Point3D) = normalize(regressive_product(to, from))

motor_fromto(from::Point3D, to::Point3D) = Motor3D(1, 0, 0, 0, (-to[1] + from[1]) * (1 // 2), (-to[2] + from[2]) * (1 // 2), (-to[3] + from[3]) * (1 // 2), 0)

function motor_screw(axis::Line3D, angle::Real, displacement::Real)
    dispha = displacement * (1 // 2)
    angleha = angle * (1 // 2)
    cosang = cos(angleha)
    sinang = sin(angleha)
    Motor3D(
        axis[1] * sinang,
        axis[2] * sinang,
        axis[3] * sinang,
        cosang,
        dispha * axis[1] * cosang + axis[4] * sinang,
        dispha * axis[2] * cosang + axis[5] * sinang,
        dispha * axis[3] * cosang + axis[6] * sinang,
        -dispha * sinang
    )
end

function Base.log(m::Motor3D)
    # https://arxiv.org/abs/2206.07496 section 8.2
    #m = unitize(m_ununitized)
    if m[1] ≈ 1
        return Line3D(0, 0, 0, m[5], m[6], m[7])
    elseif m[1] ≈ -1
        return Line3D(0, 0, 0, -m[5], -m[6], -m[7])
    else
        a = 1 / (1 - m[1] * m[1])
        b = acos(m[1]) * sqrt(a)
        c = a * m[8] * (1 - m[1] * b)
        return Line3D(
            b * m[2],
            b * m[3],
            b * m[4],
            b * m[5] + c * m[2],
            b * m[6] + c * m[3],
            b * m[7] + c * m[4])
    end
end

function Base.exp(axis::Line3D)
    # https://arxiv.org/abs/2206.07496 section 8.2
    l = line_vector(axis) ⋅ line_vector(axis)
    if l ≈ 0
        return Motor3D(1, 0, 0, 0, axis[4], axis[5], axis[6], 0)
    else
        m = line_vector(axis) ⋅ line_moment(axis)
        a = sqrt(l)
        c = cos(a)
        s = sin(a) / a
        t = m / l * (c - s)
        return Motor3D(
            c,
            s * axis[1],
            s * axis[2],
            s * axis[3],
            s * axis[4] + t * axis[1],
            s * axis[5] + t * axis[2],
            s * axis[6] + t * axis[3],
            m * s)
    end
end





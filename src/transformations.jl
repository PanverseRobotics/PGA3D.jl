function transform(a::Motor3D, b::Point3D) # assumes that a is normalized and b is normalized
    a1a1 = a[1] * a[1]
    a2a2 = a[2] * a[2]
    a3a3 = a[3] * a[3]
    a4a4 = a[4] * a[4]
    a1a3 = a[1] * a[3]
    a1a4 = a[1] * a[4]
    a2a3 = a[2] * a[3]
    a2a4 = a[2] * a[4]
    a1a2 = a[1] * a[2]
    a3a4 = a[3] * a[4]
    return Point3D(b[1] * (a1a1 + a2a2 - a3a3 - a4a4) + 2 * (b[2] * (a1a4 + a2a3) + b[3] * (-a1a3 + a2a4) + (-a[1] * a[5] - a[2] * a[8] + a[3] * a[7] - a[4] * a[6])),
        b[2] * (a1a1 - a2a2 + a3a3 - a4a4) + 2 * (b[1] * (-a1a4 + a2a3) + b[3] * (a1a2 + a3a4) + (-a[1] * a[6] - a[2] * a[7] - a[3] * a[8] + a[4] * a[5])),
        b[3] * (a1a1 - a2a2 - a3a3 + a4a4) + 2 * (b[1] * (a1a3 + a2a4) + b[2] * (-a1a2 + a3a4) + (-a[1] * a[7] + a[2] * a[6] - a[3] * a[5] - a[4] * a[8]))
    )
end

#=
function transform(a::Point3D, b::Motor3D) # assumes that b is normalized
x = a[1] * b[1] * b[1] - a[1] * b[2] * b[2] - a[1] * b[3] * b[3] + a[1] * b[4] * b[4] + 2 * a[2] * b[1] * b[2] + 2 * a[2] * b[3] * b[4] + 2 * a[3] * b[1] * b[3] - 2 * a[3] * b[2] * b[4] - 2 * 1 * b[1] * b[8] + 2 * 1 * b[2] * b[7] - 2 * 1 * b[3] * b[6] - 2 * 1 * b[4] * b[5]
y = 2 * a[1] * b[1] * b[2] - 2 * a[1] * b[3] * b[4] - a[2] * b[1] * b[1] + a[2] * b[2] * b[2] - a[2] * b[3] * b[3] + a[2] * b[4] * b[4] + 2 * a[3] * b[1] * b[4] + 2 * a[3] * b[2] * b[3] - 2 * 1 * b[1] * b[7] - 2 * 1 * b[2] * b[8] + 2 * 1 * b[3] * b[5] - 2 * 1 * b[4] * b[6]
z = 2 * a[1] * b[1] * b[3] + 2 * a[1] * b[2] * b[4] - 2 * a[2] * b[1] * b[4] + 2 * a[2] * b[2] * b[3] - a[3] * b[1] * b[1] - a[3] * b[2] * b[2] + a[3] * b[3] * b[3] + a[3] * b[4] * b[4] + 2 * 1 * b[1] * b[6] - 2 * 1 * b[2] * b[5] - 2 * 1 * b[3] * b[8] - 2 * 1 * b[4] * b[7]
Point3D(x, y, z)
#res[4] = 1 * b[1] * b[1] + 1 * b[2] * b[2] + 1 * b[3] * b[3] + 1 * b[4] * b[4]
end
=#


function transform(a::Motor3D, b::Vector4D) # assumes that a is normalized and b is normalized
    a1a1 = a[1] * a[1]
    a2a2 = a[2] * a[2]
    a3a3 = a[3] * a[3]
    a4a4 = a[4] * a[4]
    a1a3 = a[1] * a[3]
    a1a4 = a[1] * a[4]
    a2a3 = a[2] * a[3]
    a2a4 = a[2] * a[4]
    a1a2 = a[1] * a[2]
    a3a4 = a[3] * a[4]
    return Vector4D(b[1] * (a1a1 + a2a2 - a3a3 - a4a4) + 2 * (b[2] * (a1a4 + a2a3) + b[3] * (-a1a3 + a2a4) + b[4] * (-a[1] * a[5] - a[2] * a[8] + a[3] * a[7] - a[4] * a[6])),
        b[2] * (a1a1 - a2a2 + a3a3 - a4a4) + 2 * (b[1] * (-a1a4 + a2a3) + b[3] * (a1a2 + a3a4) + b[4] * (-a[1] * a[6] - a[2] * a[7] - a[3] * a[8] + a[4] * a[5])),
        b[3] * (a1a1 - a2a2 - a3a3 + a4a4) + 2 * (b[1] * (a1a3 + a2a4) + b[2] * (-a1a2 + a3a4) + b[4] * (-a[1] * a[7] + a[2] * a[6] - a[3] * a[5] - a[4] * a[8])),
        b[4] * (a1a1 + a2a2 + a3a3 + a4a4)
    )
end

#=
function transform(a::Vector4D, b::Motor3D) # assumes that b is normalized
    x = a[1] * b[1] * b[1] - a[1] * b[2] * b[2] - a[1] * b[3] * b[3] + a[1] * b[4] * b[4] + 2 * a[2] * b[1] * b[2] + 2 * a[2] * b[3] * b[4] + 2 * a[3] * b[1] * b[3] - 2 * a[3] * b[2] * b[4] - 2 * a[4] * b[1] * b[8] + 2 * a[4] * b[2] * b[7] - 2 * a[4] * b[3] * b[6] - 2 * a[4] * b[4] * b[5]
    y = 2 * a[1] * b[1] * b[2] - 2 * a[1] * b[3] * b[4] - a[2] * b[1] * b[1] + a[2] * b[2] * b[2] - a[2] * b[3] * b[3] + a[2] * b[4] * b[4] + 2 * a[3] * b[1] * b[4] + 2 * a[3] * b[2] * b[3] - 2 * a[4] * b[1] * b[7] - 2 * a[4] * b[2] * b[8] + 2 * a[4] * b[3] * b[5] - 2 * a[4] * b[4] * b[6]
    z = 2 * a[1] * b[1] * b[3] + 2 * a[1] * b[2] * b[4] - 2 * a[2] * b[1] * b[4] + 2 * a[2] * b[2] * b[3] - a[3] * b[1] * b[1] - a[3] * b[2] * b[2] + a[3] * b[3] * b[3] + a[3] * b[4] * b[4] + 2 * a[4] * b[1] * b[6] - 2 * a[4] * b[2] * b[5] - 2 * a[4] * b[3] * b[8] - 2 * a[4] * b[4] * b[7]
    w = a[4] * b[1] * b[1] + a[4] * b[2] * b[2] + a[4] * b[3] * b[3] + a[4] * b[4] * b[4]
    Vector4D(x, y, z, w)
end
=#

#=
function transform(l_ununitized::Line3D, Q_ununitized::Motor3D)
    l = unitize(l_ununitized)
    Q = unitize(Q_ununitized)

    lv = line_vector(l)
    Qv = SA[Q[1], Q[2], Q[3]]
    Qvlv = 2cross(Qv, lv)
    result_v = lv .+ cross(Qv, Qvlv) .+ (Qvlv .* Q[4])

    lm = line_moment(l)
    Qm = SA[Q[5], Q[6], Q[7]]
    Qvlm = 2cross(Qv, lm)
    Qmlv = 2cross(Qm, lv)
    result_m = lm .+ cross(Qv, Qvlm) .+ cross(Qv, Qmlv) .+ cross(Qm, Qvlv) .+ ((Qvlm .+ Qmlv) .* Q[4]) .+ (Qvlv .* Q[8])

    Line3D(result_v[1], result_v[2], result_v[3], result_m[1], result_m[2], result_m[3])
end
=#


#=
function transform(p::Point3D, Q_ununitized::Motor3D)
    Q = unitize(Q_ununitized)
    p3 = SA[p[1], p[2], p[3]]
    Qv = SA[Q[1], Q[2], Q[3]]
    Qm = SA[Q[5], Q[6], Q[7]]
    Qvp = cross(Qv, p3)

    a = cross(Qv, Qvp) .+ ((Qvp .+ Qm) .* Q[4]) .- (Qv .* Q[8]) .+ cross(Qv, Qm)
    Point3D(p3 .+ 2a)
end
=#
#=
function transform(a::Point3D, b::Motor3D) # assumes that b is normalized
    x = -a[1] * b[1] * b[1] - a[1] * b[2] * b[2] + a[1] * b[3] * b[3] + a[1] * b[4] * b[4] - 2 * a[2] * b[1] * b[4] + 2 * a[2] * b[2] * b[3] + 2 * a[3] * b[1] * b[3] + 2 * a[3] * b[2] * b[4] + 2 * 1 * b[1] * b[6] - 2 * 1 * b[2] * b[5] - 2 * 1 * b[3] * b[8] - 2 * 1 * b[4] * b[7]
    y = 2 * a[1] * b[1] * b[4] + 2 * a[1] * b[2] * b[3] - a[2] * b[1] * b[1] + a[2] * b[2] * b[2] - a[2] * b[3] * b[3] + a[2] * b[4] * b[4] + 2 * a[3] * b[1] * b[2] - 2 * a[3] * b[3] * b[4] - 2 * 1 * b[1] * b[7] - 2 * 1 * b[2] * b[8] + 2 * 1 * b[3] * b[5] - 2 * 1 * b[4] * b[6]
    z = 2 * a[1] * b[1] * b[3] - 2 * a[1] * b[2] * b[4] + 2 * a[2] * b[1] * b[2] + 2 * a[2] * b[3] * b[4] + a[3] * b[1] * b[1] - a[3] * b[2] * b[2] - a[3] * b[3] * b[3] + a[3] * b[4] * b[4] - 2 * 1 * b[1] * b[8] + 2 * 1 * b[2] * b[7] - 2 * 1 * b[3] * b[6] - 2 * 1 * b[4] * b[5]
    #w = 1 * b[1] * b[1] + 1 * b[2] * b[2] + 1 * b[3] * b[3] + 1 * b[4] * b[4]
    Point3D(SA[x, y, z])
end
=#
function transform(a::Point3D, b::Motor3D) # assumes that b is normalized
    x = a[1] * b[1] * b[1] - a[1] * b[2] * b[2] - a[1] * b[3] * b[3] + a[1] * b[4] * b[4] + 2 * a[2] * b[1] * b[2] + 2 * a[2] * b[3] * b[4] + 2 * a[3] * b[1] * b[3] - 2 * a[3] * b[2] * b[4] - 2 * 1 * b[1] * b[8] + 2 * 1 * b[2] * b[7] - 2 * 1 * b[3] * b[6] - 2 * 1 * b[4] * b[5]
    y = 2 * a[1] * b[1] * b[2] - 2 * a[1] * b[3] * b[4] - a[2] * b[1] * b[1] + a[2] * b[2] * b[2] - a[2] * b[3] * b[3] + a[2] * b[4] * b[4] + 2 * a[3] * b[1] * b[4] + 2 * a[3] * b[2] * b[3] - 2 * 1 * b[1] * b[7] - 2 * 1 * b[2] * b[8] + 2 * 1 * b[3] * b[5] - 2 * 1 * b[4] * b[6]
    z = 2 * a[1] * b[1] * b[3] + 2 * a[1] * b[2] * b[4] - 2 * a[2] * b[1] * b[4] + 2 * a[2] * b[2] * b[3] - a[3] * b[1] * b[1] - a[3] * b[2] * b[2] + a[3] * b[3] * b[3] + a[3] * b[4] * b[4] + 2 * 1 * b[1] * b[6] - 2 * 1 * b[2] * b[5] - 2 * 1 * b[3] * b[8] - 2 * 1 * b[4] * b[7]
    Point3D(x, y, z)
    #res[4] = 1 * b[1] * b[1] + 1 * b[2] * b[2] + 1 * b[3] * b[3] + 1 * b[4] * b[4]
end

#=
function transform(a::Vector4D, b::Motor3D) # assumes that b is normalized
    x = -a[1] * b[1] * b[1] - a[1] * b[2] * b[2] + a[1] * b[3] * b[3] + a[1] * b[4] * b[4] - 2 * a[2] * b[1] * b[4] + 2 * a[2] * b[2] * b[3] + 2 * a[3] * b[1] * b[3] + 2 * a[3] * b[2] * b[4] + 2 * a[4] * b[1] * b[6] - 2 * a[4] * b[2] * b[5] - 2 * a[4] * b[3] * b[8] - 2 * a[4] * b[4] * b[7]
    y = 2 * a[1] * b[1] * b[4] + 2 * a[1] * b[2] * b[3] - a[2] * b[1] * b[1] + a[2] * b[2] * b[2] - a[2] * b[3] * b[3] + a[2] * b[4] * b[4] + 2 * a[3] * b[1] * b[2] - 2 * a[3] * b[3] * b[4] - 2 * a[4] * b[1] * b[7] - 2 * a[4] * b[2] * b[8] + 2 * a[4] * b[3] * b[5] - 2 * a[4] * b[4] * b[6]
    z = 2 * a[1] * b[1] * b[3] - 2 * a[1] * b[2] * b[4] + 2 * a[2] * b[1] * b[2] + 2 * a[2] * b[3] * b[4] + a[3] * b[1] * b[1] - a[3] * b[2] * b[2] - a[3] * b[3] * b[3] + a[3] * b[4] * b[4] - 2 * a[4] * b[1] * b[8] + 2 * a[4] * b[2] * b[7] - 2 * a[4] * b[3] * b[6] - 2 * a[4] * b[4] * b[5]
    w = a[4] * b[1] * b[1] + a[4] * b[2] * b[2] + a[4] * b[3] * b[3] + a[4] * b[4] * b[4]
    Vector4D(SA[x, y, z, w])
end
=#
function transform(a::Vector4D, b::Motor3D) # assumes that b is normalized
    x = a[1] * b[1] * b[1] - a[1] * b[2] * b[2] - a[1] * b[3] * b[3] + a[1] * b[4] * b[4] + 2 * a[2] * b[1] * b[2] + 2 * a[2] * b[3] * b[4] + 2 * a[3] * b[1] * b[3] - 2 * a[3] * b[2] * b[4] - 2 * a[4] * b[1] * b[8] + 2 * a[4] * b[2] * b[7] - 2 * a[4] * b[3] * b[6] - 2 * a[4] * b[4] * b[5]
    y = 2 * a[1] * b[1] * b[2] - 2 * a[1] * b[3] * b[4] - a[2] * b[1] * b[1] + a[2] * b[2] * b[2] - a[2] * b[3] * b[3] + a[2] * b[4] * b[4] + 2 * a[3] * b[1] * b[4] + 2 * a[3] * b[2] * b[3] - 2 * a[4] * b[1] * b[7] - 2 * a[4] * b[2] * b[8] + 2 * a[4] * b[3] * b[5] - 2 * a[4] * b[4] * b[6]
    z = 2 * a[1] * b[1] * b[3] + 2 * a[1] * b[2] * b[4] - 2 * a[2] * b[1] * b[4] + 2 * a[2] * b[2] * b[3] - a[3] * b[1] * b[1] - a[3] * b[2] * b[2] + a[3] * b[3] * b[3] + a[3] * b[4] * b[4] + 2 * a[4] * b[1] * b[6] - 2 * a[4] * b[2] * b[5] - 2 * a[4] * b[3] * b[8] - 2 * a[4] * b[4] * b[7]
    w = a[4] * b[1] * b[1] + a[4] * b[2] * b[2] + a[4] * b[3] * b[3] + a[4] * b[4] * b[4]
    Vector4D(x, y, z, w)
end

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

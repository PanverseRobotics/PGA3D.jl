
function transform(p::Point3D, Q_ununitized::Motor3D)
    Q = unitize(Q_ununitized)
    p3 = SA[p[1], p[2], p[3]]
    Qv = SA[Q[1], Q[2], Q[3]]
    Qm = SA[Q[5], Q[6], Q[7]]
    Qvp = cross(Qv, p3)

    a = cross(Qv, Qvp) .+ ((Qvp .+ Qm) .* Q[4]) .- (Qv .* Q[8]) .+ cross(Qv, Qm)
    Point3D(p3 .+ 2a)
end


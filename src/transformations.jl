function transform(a::Motor3D, b::Point3D)
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
    return Point3D(b[1] * (a1a1 + a2a2 - a3a3 - a4a4) + 2 * (b[2] * (a1a4 + a2a3) + b[3] * (-a1a3 + a2a4) + b[4] * (-a[1] * a[5] - a[2] * a[8] + a[3] * a[7] - a[4] * a[6])),
        b[2] * (a1a1 - a2a2 + a3a3 - a4a4) + 2 * (b[1] * (-a1a4 + a2a3) + b[3] * (a1a2 + a3a4) + b[4] * (-a[1] * a[6] - a[2] * a[7] - a[3] * a[8] + a[4] * a[5])),
        b[3] * (a1a1 - a2a2 - a3a3 + a4a4) + 2 * (b[1] * (a1a3 + a2a4) + b[2] * (-a1a2 + a3a4) + b[4] * (-a[1] * a[7] + a[2] * a[6] - a[3] * a[5] - a[4] * a[8])),
        b[4] * (a1a1 + a2a2 + a3a3 + a4a4)
    )
end


function transform(a::Motor3D, b::Vector4D)
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

function transform(a::Motor3D, b::Plane3D)
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
    return Plane3D(b[1] * (a1a1 + a2a2 - a3a3 - a4a4) + 2 * (b[2] * (a1a4 + a2a3) + b[3] * (-a1a3 + a2a4)),
        b[2] * (a1a1 - a2a2 + a3a3 - a4a4) + 2 * (b[1] * (-a1a4 + a2a3) + b[3] * (a1a2 + a3a4)),
        b[3] * (a1a1 - a2a2 - a3a3 + a4a4) + 2 * (b[1] * (a1a3 + a2a4) + b[2] * (-a1a2 + a3a4)),
        b[4] * (a1a1 + a2a2 + a3a3 + a4a4) + 2 * (b[1] * (a[1] * a[5] + a[2] * a[8] + a[3] * a[7] - a[4] * a[6]) + b[2] * (a[1] * a[6] - a[2] * a[7] + a[3] * a[8] + a[4] * a[5]) + b[3] * (a[1] * a[7] + a[2] * a[6] - a[3] * a[5] + a[4] * a[8])))
end


function transform(a::Motor3D, b::Line3D)
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
    a1a8 = a[1] * a[8]
    a2a5 = a[2] * a[5]
    a3a6 = a[3] * a[6]
    a4a7 = a[4] * a[7]
    a1a6 = a[1] * a[6]
    a1a7 = a[1] * a[7]
    a2a6 = a[2] * a[6]
    a2a7 = a[2] * a[7]
    a3a5 = a[3] * a[5]
    a3a8 = a[3] * a[8]
    a4a5 = a[4] * a[5]
    a4a8 = a[4] * a[8]
    a1a5 = a[1] * a[5]
    a2a8 = a[2] * a[8]
    a3a7 = a[3] * a[7]
    a4a6 = a[4] * a[6]
    return Line3D(b[1] * (a1a1 + a2a2 - a3a3 - a4a4) + 2 * (b[2] * (a1a4 + a2a3) + b[3] * (-a1a3 + a2a4)),
        b[2] * (a1a1 - a2a2 + a3a3 - a4a4) + 2 * (b[1] * (-a1a4 + a2a3) + b[3] * (a1a2 + a3a4)),
        b[3] * (a1a1 - a2a2 - a3a3 + a4a4) + 2 * (b[1] * (a1a3 + a2a4) + b[2] * (-a1a2 + a3a4)),
        b[4] * (a1a1 + a2a2 - a3a3 - a4a4) + 2 * (b[1] * (-a1a8 + a2a5 - a3a6 - a4a7) + b[2] * (a1a7 + a2a6 + a3a5 - a4a8) + b[3] * (-a1a6 + a2a7 + a3a8 + a4a5) + b[5] * (a1a4 + a2a3) + b[6] * (-a1a3 + a2a4)),
        b[5] * (a1a1 - a2a2 + a3a3 - a4a4) + 2 * (b[1] * (-a1a7 + a2a6 + a3a5 + a4a8) + b[2] * (-a1a8 - a2a5 + a3a6 - a4a7) + b[3] * (a1a5 - a2a8 + a3a7 + a4a6) + b[4] * (-a1a4 + a2a3) + b[6] * (a1a2 + a3a4)),
        b[6] * (a1a1 - a2a2 - a3a3 + a4a4) + 2 * (b[1] * (a1a6 + a2a7 - a3a8 + a4a5) + b[2] * (-a1a5 + a2a8 + a3a7 + a4a6) + b[3] * (-a1a8 - a2a5 - a3a6 + a4a7) + b[4] * (a1a3 + a2a4) + b[5] * (-a1a2 + a3a4)))
end


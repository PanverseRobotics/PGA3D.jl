
function Base.:(*)(a::Plane3D, b::Plane3D)
    return Motor3D(a[1] * b[1] + a[2] * b[2] + a[3] * b[3],
        a[2] * b[3] - a[3] * b[2],
        -a[1] * b[3] + a[3] * b[1],
        a[1] * b[2] - a[2] * b[1],
        -a[1] * b[4] + a[4] * b[1],
        -a[2] * b[4] + a[4] * b[2],
        -a[3] * b[4] + a[4] * b[3],
        0)
end

function Base.:(*)(a::Line3D, b::Line3D)
    return Motor3D(-a[1] * b[1] - a[2] * b[2] - a[3] * b[3],
        -a[2] * b[3] + a[3] * b[2],
        a[1] * b[3] - a[3] * b[1],
        -a[1] * b[2] + a[2] * b[1],
        -a[2] * b[6] + a[3] * b[5] - a[5] * b[3] + a[6] * b[2],
        a[1] * b[6] - a[3] * b[4] + a[4] * b[3] - a[6] * b[1],
        -a[1] * b[5] + a[2] * b[4] - a[4] * b[2] + a[5] * b[1],
        a[1] * b[4] + a[2] * b[5] + a[3] * b[6] + a[4] * b[1] + a[5] * b[2] + a[6] * b[3])
end

function Base.:(*)(a::Point3D, b::Point3D)
    return Motor3D(-a[4] * b[4],
        0, 0, 0,
        a[1] * b[4] - a[4] * b[1],
        a[2] * b[4] - a[4] * b[2],
        a[3] * b[4] - a[4] * b[3],
        0)
end

function Base.:(*)(a::Motor3D, b::Motor3D)
    return Motor3D(
        a[1] * b[1] - a[2] * b[2] - a[3] * b[3] - a[4] * b[4],
        a[1] * b[2] + a[2] * b[1] - a[3] * b[4] + a[4] * b[3],
        a[1] * b[3] + a[2] * b[4] + a[3] * b[1] - a[4] * b[2],
        a[1] * b[4] - a[2] * b[3] + a[3] * b[2] + a[4] * b[1],
        a[1] * b[5] - a[2] * b[8] - a[3] * b[7] + a[4] * b[6] + a[5] * b[1] - a[6] * b[4] + a[7] * b[3] - a[8] * b[2],
        a[1] * b[6] + a[2] * b[7] - a[3] * b[8] - a[4] * b[5] + a[5] * b[4] + a[6] * b[1] - a[7] * b[2] - a[8] * b[3],
        a[1] * b[7] - a[2] * b[6] + a[3] * b[5] - a[4] * b[8] - a[5] * b[3] + a[6] * b[2] + a[7] * b[1] - a[8] * b[4],
        a[1] * b[8] + a[2] * b[5] + a[3] * b[6] + a[4] * b[7] + a[5] * b[2] + a[6] * b[3] + a[7] * b[4] + a[8] * b[1]
    )
end

function Base.:(*)(a::Rotor3D, b::Rotor3D)
    return Rotor3D(
        a[1] * b[1] - a[2] * b[2] - a[3] * b[3] - a[4] * b[4],
        a[1] * b[2] + a[2] * b[1] - a[3] * b[4] + a[4] * b[3],
        a[1] * b[3] + a[2] * b[4] + a[3] * b[1] - a[4] * b[2],
        a[1] * b[4] - a[2] * b[3] + a[3] * b[2] + a[4] * b[1]
    )
end

function Base.:(*)(a::Translator3D, b::Rotor3D)
    return Motor3D(
        a[1] * b[1],
        a[1] * b[2],
        a[1] * b[3],
        a[1] * b[4],
        a[2] * b[1] + a[4] * b[3] - a[3] * b[4],
        a[2] * b[4] + a[3] * b[1] - a[4] * b[2],
        a[3] * b[2] + a[4] * b[1] - a[2] * b[3],
        a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
    )
end

function Base.:(*)(a::Rotor3D, b::Translator3D)
    return Motor3D(
        a[1] * b[1],
        a[2] * b[1],
        a[3] * b[1],
        a[4] * b[1],
        a[1] * b[2] + a[4] * b[3] - a[3] * b[4],
        a[1] * b[3] + a[2] * b[4] - a[4] * b[2],
        a[1] * b[4] + a[3] * b[2] - a[2] * b[3],
        a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
    )
end

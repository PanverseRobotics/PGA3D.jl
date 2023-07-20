
function outer_product(a::Plane3D, b::Plane3D)
    return Line3D(a[2] * b[3] - a[3] * b[2],
        -a[1] * b[3] + a[3] * b[1],
        a[1] * b[2] - a[2] * b[1],
        -a[1] * b[4] + a[4] * b[1],
        -a[2] * b[4] + a[4] * b[2],
        -a[3] * b[4] + a[4] * b[3])
end

∧(a::Plane3D, b::Plane3D) = outer_product(a, b)

function outer_product(a::Line3D, b::Plane3D)
    return Point3D(-a[1] * b[4] - a[5] * b[3] + a[6] * b[2],
        -a[2] * b[4] + a[4] * b[3] - a[6] * b[1],
        -a[3] * b[4] - a[4] * b[2] + a[5] * b[1],
        a[1] * b[1] + a[2] * b[2] + a[3] * b[3])
end

∧(a::Line3D, b::Plane3D) = outer_product(a, b)

function outer_product(a::Plane3D, b::Line3D)
    return Point3D(a[2] * b[6] - a[3] * b[5] - a[4] * b[1],
        -a[1] * b[6] + a[3] * b[4] - a[4] * b[2],
        a[1] * b[5] - a[2] * b[4] - a[4] * b[3],
        a[1] * b[1] + a[2] * b[2] + a[3] * b[3])
end

∧(a::Plane3D, b::Line3D) = outer_product(a, b)

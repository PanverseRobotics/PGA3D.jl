

function regressive_product(a::Point3D, b::Point3D)
    return Line3D(-a[1] * b[4] + a[4] * b[1],
        -a[2] * b[4] + a[4] * b[2],
        -a[3] * b[4] + a[4] * b[3],
        a[2] * b[3] - a[3] * b[2],
        -a[1] * b[3] + a[3] * b[1],
        a[1] * b[2] - a[2] * b[1])
end

∨(a::Point3D, b::Point3D) = regressive_product(a, b)

function regressive_product(a::Line3D, b::Point3D)
    return Plane3D(a[2] * b[3] - a[3] * b[2] + a[4] * b[4],
        -a[1] * b[3] + a[3] * b[1] + a[5] * b[4],
        a[1] * b[2] - a[2] * b[1] + a[6] * b[4],
        -a[4] * b[1] - a[5] * b[2] - a[6] * b[3])
end

∨(a::Line3D, b::Point3D) = regressive_product(a, b)

function regressive_product(a::Point3D, b::Line3D)
    return Plane3D(-a[2] * b[3] + a[3] * b[2] + a[4] * b[4],
        a[1] * b[3] - a[3] * b[1] + a[4] * b[5],
        -a[1] * b[2] + a[2] * b[1] + a[4] * b[6],
        -a[1] * b[4] - a[2] * b[5] - a[3] * b[6])
end

∨(a::Point3D, b::Line3D) = regressive_product(a, b)

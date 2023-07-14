
line_fromto(from::Point3D, to::Point3D) = unitize(Line3D(to[1] - from[1], to[2] - from[2], to[3] - from[3], cross(SA[from[1], from[2], from[3]], SA[to[1], to[2], to[3]])...))


motor_fromto(from::Point3D, to::Point3D) = Motor3D(0, 0, 0, 1, (to[1] - from[1]) * (1 // 2), (to[2] - from[2]) * (1 // 2), (to[3] - from[3]) * (1 // 2), 0)

motor_translation(v::Vector3D) = Motor3D(0, 0, 0, 1, v[1] * (1 // 2), v[2] * (1 // 2), v[3] * (1 // 2), 0)

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




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

#=
function motor_logarithm(m_ununitized::Motor3D)
    # calculate theta_hat 
    m = unitize(m_ununitized)
    s2 = m[1] * m[1] + m[2] * m[2] + m[3] * m[3]
    if s2 ≈ 0 # no rotation part (m[4] = +- 1)

    end
    p2 = 2 * (m[1] * m[5] + m[2] * m[6] + m[3] * m[7])
    theta_hat_vx = m[1] / s2
    theta_hat_vy = m[2] / s2
    theta_hat_vz = m[3] / s2
    theta_hat_mx = m[5] / s2 - m[1] * p2 / s2^2
    theta_hat_my = m[6] / s2 - m[2] * p2 / s2^2
    theta_hat_mz = m[7] / s2 - m[3] * p2 / s2^2

    theta_hat_perp_mx = theta_hat_vx
    theta_hat_perp_my = theta_hat_vy
    theta_hat_perp_mz = theta_hat_vz

    s1 = m[4]
    p1 = m[8]

    (; mu, nu) = if !(s1 ≈ 0)
        mu = atan(s2, s1)
        nu = p2 / s1
        (; mu, nu)
    else
        mu = atan(-p1, p2)
        nu = -p1 / s2
        (; mu, nu)
    end

    theta_hat = Line3D(theta_hat_vx, theta_hat_vy, theta_hat_vz, theta_hat_mx, theta_hat_my, theta_hat_mz)
    theta_hat_perp = Line3D(0, 0, 0, theta_hat_perp_mx, theta_hat_perp_my, theta_hat_perp_mz)
    (; theta_hat, theta_hat_perp, mu, nu)
end
=#
function Base.log(m::Motor3D)
    # https://arxiv.org/abs/2206.07496 section 8.2
    #m = unitize(m_ununitized)
    if abs(m[4]) ≈ 1
        return Line3D(0, 0, 0, m[5], m[6], m[7])
    else
        a = 1 / (1 - m[4] * m[4])
        b = acos(m[4]) * sqrt(a)
        c = a * m[8] * (1 - m[4] * b)
        return Line3D(
            b * m[1],
            b * m[2],
            b * m[3],
            c * m[1] + b * m[5],
            c * m[2] + b * m[6],
            c * m[3] + b * m[7])
    end
end

function Base.exp(axis::Line3D)
    # https://arxiv.org/abs/2206.07496 section 8.2
    l = axis[1] * axis[1] + axis[2] * axis[2] + axis[3] * axis[3]
    if l ≈ 0
        return Motor3D(0, 0, 0, 1, axis[4], axis[5], axis[6], 0)
    else
        m = axis[1] * axis[4] + axis[2] * axis[5] + axis[3] * axis[6]
        a = sqrt(l)
        c = cos(a)
        s = sin(a) / a
        t = m / l * (c - s)
        return Motor3D(
            s * axis[1],
            s * axis[2],
            s * axis[3],
            c,
            s * axis[4] + t * axis[1],
            s * axis[5] + t * axis[2],
            s * axis[6] + t * axis[3],
            m * s)
    end
end


#=
function motor_line_exp(axis::Line3D)
    angleha = weight_norm(axis)
    cosang = cos(angleha)
    sinang = sin(angleha)
    Motor3D(
        axis[1] * sinang,
        axis[2] * sinang,
        axis[3] * sinang,
        cosang,
        axis[4] * sinang,
        axis[5] * sinang,
        axis[6] * sinang,
        0
    )
end

function motor_line_exp(axis::Line3D)
    s = axis[1] * axis[1] + axis[2] * axis[2] + axis[3] * axis[3]
    if s ≈ 0 # ideal bivector, no rotation
        return Motor3D(0, 0, 0, 1, axis[4], axis[5], axis[6], 0)
    else
    end
    dispha = bulk_norm(axis)
    Motor3D(
        0,
        0,
        0,
        1,
        dispha * axis[1] * cosang + axis[4] * sinang,
        dispha * axis[2] * cosang + axis[5] * sinang,
        dispha * axis[3] * cosang + axis[6] * sinang,
        -dispha * sinang
    )
end
=#


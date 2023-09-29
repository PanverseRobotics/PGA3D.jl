
function get_transform_matrix(a::Motor3D)
    return SA[
        (a[1]^2+a[2]^2-(a[3]^2)-(a[4]^2)) (2(a[2]*a[3]+a[1]*a[4])) (2(a[2]*a[4]-a[1]*a[3])) (2(a[7]*a[3]-a[5]*a[1]-a[8]*a[2]-a[6]*a[4]))
        (2(a[2]*a[3]-a[1]*a[4])) (a[1]^2+a[3]^2-(a[2]^2)-(a[4]^2)) (2(a[1]*a[2]+a[3]*a[4])) (2(a[5]*a[4]-a[8]*a[3]-a[6]*a[1]-a[7]*a[2]))
        (2(a[1]*a[3]+a[2]*a[4])) (2(a[3]*a[4]-a[1]*a[2])) (a[1]^2+a[4]^2-(a[2]^2)-(a[3]^2)) (2(a[6]*a[2]-a[5]*a[3]-a[8]*a[4]-a[7]*a[1]))
        0 0 0 (a[1]^2+a[2]^2+a[3]^2+a[4]^2)
    ]
end

function get_inv_transform_matrix(a::Motor3D)
    return inv(get_transform_matrix(a))
end

function get_transform_and_inv_matrices(a::Motor3D)
    matrix = get_transform_matrix(a)
    inv_matrix = get_inv_transform_matrix(a)
    return (; matrix, inv_matrix)
end

function get_position(a::Motor3D)
    return Point3D((2(a[7] * a[3] - a[5] * a[1] - a[8] * a[2] - a[6] * a[4])),
        (2(a[5] * a[4] - a[8] * a[3] - a[6] * a[1] - a[7] * a[2])),
        (2(a[6] * a[2] - a[5] * a[3] - a[8] * a[4] - a[7] * a[1])),
        (a[1]^2 + a[2]^2 + a[3]^2 + a[4]^2))
end

function get_rotation_matrix(a::Rotor3D)
    return SA[
        (a[1]^2+a[2]^2-(a[3]^2)-(a[4]^2)) (2(a[2]*a[3]+a[1]*a[4])) (2(a[2]*a[4]-a[1]*a[3]))
        (2(a[2]*a[3]-a[1]*a[4])) (a[1]^2+a[3]^2-(a[2]^2)-(a[4]^2)) (2(a[1]*a[2]+a[3]*a[4]))
        (2(a[1]*a[3]+a[2]*a[4])) (2(a[3]*a[4]-a[1]*a[2])) (a[1]^2+a[4]^2-(a[2]^2)-(a[3]^2))
    ]
end

#=
# I wanted this to work but it doesn't handle the edge cases well enough and I don't know how to modify it to do so
function motor_from_transform(M::SMatrix{4,4,T}) where {T<:Number}
    # thanks to Enki for this excellent labelled script & comments
    # https://enki.ws/ganja.js/examples/coffeeshop.html#8fjqnxTot

    p1 = Plane3D(M[1, 1], M[1, 2], M[1, 3], M[1, 4])
    p2 = Plane3D(M[2, 1], M[2, 2], M[2, 3], M[2, 4])
    p3 = Plane3D(M[3, 1], M[3, 2], M[3, 3], M[3, 4])

    # our initial motor takes plane r1 to e1
    m1 = sqrt(Plane3D(1, 0, 0, 0) * inv(p1))

    # now we can only move in this plane.. so we need to compose with a motor
    # that happens in this plane, this is the one that moves our current intersection with r1 to e12
    p12 = p1 ∧ p2
    m2 = sqrt(Line3D(0, 0, 1, 0, 0, 0) * inv(transform(m1, p12))) * m1

    # now finally move along that line for the last plane.
    # this last part is a guaranteed translation that makes sure the intersection point
    # of the three input planes is at 1e123.
    # This is a translation with a distance determined by the third plane along a line
    # determined by the 2nd plane inside the first plane.
    p123 = p12 ∧ p3
    m3 = sqrt(Point3D(0, 0, 0, 1) * inv(transform(m2, p123))) * m2

    return m3
end
=#

function motor_from_rotation(M::SMatrix{3,3,T}) where {T<:Number}
    # from https://math.stackexchange.com/questions/893984/conversion-of-rotation-matrix-to-quaternion/3183435#3183435
    if M[3, 3] < 0
        if M[1, 1] > M[2, 2]
            trace = 1 + M[1, 1] - M[2, 2] - M[3, 3]
            s = 2 * sqrt(trace)
            if M[2, 3] < M[3, 2]
                s = -s
            end
            sinv = 1 / s
            q1 = (M[2, 3] - M[3, 2]) * sinv
            q2 = (1 // 4) * s
            q3 = (M[1, 2] + M[2, 1]) * sinv
            q4 = (M[3, 1] + M[1, 3]) * sinv
            if (trace ≈ 1) && (q1 ≈ 0 && q3 ≈ 0 && q4 ≈ 0)
                q2 = one(T)
            end
        else
            trace = 1 - M[1, 1] + M[2, 2] - M[3, 3]
            s = 2 * sqrt(trace)
            if M[3, 1] < M[1, 3]
                s = -s
            end
            q3 = (1 // 4) * s
            sinv = 1 / s
            q1 = (M[3, 1] - M[1, 3]) * sinv
            q2 = (M[1, 2] + M[2, 1]) * sinv
            q4 = (M[2, 3] + M[3, 2]) * sinv
            if (trace ≈ 1) && (q1 ≈ 0 && q2 ≈ 0 && q4 ≈ 0)
                q3 = one(T)
            end
        end
    else
        if M[1, 1] < -M[2, 2]
            trace = 1 - M[1, 1] - M[2, 2] + M[3, 3]
            s = 2 * sqrt(trace)
            if M[1, 2] < M[2, 1]
                s = -s
            end
            q4 = (1 // 4) * s
            sinv = 1 / s
            q1 = (M[1, 2] - M[2, 1]) * sinv
            q2 = (M[3, 1] + M[1, 3]) * sinv
            q3 = (M[2, 3] + M[3, 2]) * sinv
            if (trace ≈ 1) && (q1 ≈ 0 && q2 ≈ 0 && q3 ≈ 0)
                q4 = one(T)
            end
        else
            trace = 1 + M[1, 1] + M[2, 2] + M[3, 3]
            s = 2 * sqrt(trace)
            q1 = (1 // 4) * s
            sinv = 1 / s
            q2 = (M[2, 3] - M[3, 2]) * sinv
            q3 = (M[3, 1] - M[1, 3]) * sinv
            q4 = (M[1, 2] - M[2, 1]) * sinv
            if (trace ≈ 1) && (q2 ≈ 0 && q3 ≈ 0 && q4 ≈ 0)
                q1 = one(T)
            end
        end
    end
    @assert q1 >= 0
    return Motor3D(q1, q2, q3, q4, 0, 0, 0, 0)
end

function motor_from_transform(M::SMatrix{4,4,T}) where {T<:Number}
    rot = SA[
        M[1, 1] M[1, 2] M[1, 3]
        M[2, 1] M[2, 2] M[2, 3]
        M[3, 1] M[3, 2] M[3, 3]
    ]
    rotor = motor_from_rotation(rot)
    translator = Motor3D(1, 0, 0, 0, -(1 // 2) * M[1, 4], -(1 // 2) * M[2, 4], -(1 // 2) * M[3, 4], 0)
    return normalize(translator * rotor)
end

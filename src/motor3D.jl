struct Motor3D{T<:Number} <: AbstractPGA3DElement{T}
    vec::SVector{8,T}

    function Motor3D(scalar::Number, e23::Number, e31::Number, e12::Number, e01::Number, e02::Number, e03::Number, e0123::Number)
        T = promote_type(eltype(scalar), eltype(e23), eltype(e31), eltype(e12), eltype(e01), eltype(e02), eltype(e03), eltype(e0123))
        vec = SVector{8,T}(promote(scalar, e23, e31, e12, e01, e02, e03, e0123)...)
        return new{T}(vec)
    end

    function Motor3D(vec::SVector{8,T}) where {T<:Number}
        return new{T}(vec)
    end
end

internal_vec(a::Motor3D) = a.vec

Base.length(::Motor3D) = 8
Base.size(::Motor3D) = (8,)


get_scalar(a::Motor3D) = a[1]
get_e23(a::Motor3D) = a[2]
get_e31(a::Motor3D) = a[3]
get_e12(a::Motor3D) = a[4]
get_e01(a::Motor3D) = a[5]
get_e02(a::Motor3D) = a[6]
get_e03(a::Motor3D) = a[7]
get_e0123(a::Motor3D) = a[8]

Base.:(+)(a::Motor3D, b::Motor3D) = Motor3D(internal_vec(a) .+ internal_vec(b))
Base.:(-)(a::Motor3D, b::Motor3D) = Motor3D(internal_vec(a) .- internal_vec(b))
Base.:(-)(a::Motor3D) = Motor3D(-internal_vec(a))
Base.:(*)(a::Motor3D, b::Real) = Motor3D((internal_vec(a) .* b)) # this needs to be Real otherwise it might trigger on PGA elements oop
Base.:(*)(a::Real, b::Motor3D) = Motor3D((a .* internal_vec(b))) # this needs to be Real otherwise it might trigger on PGA elements oop

# this is the one from enki's stuff, translated

identity_motor() = Motor3D(1, 0, 0, 0, 0, 0, 0, 0)

const special_motors = SA[
    Motor3D(0, 0, 0, 0, 0, 0, 0, 0),
    identity_motor(), -identity_motor(),
    Motor3D(0, 1, 0, 0, 0, 0, 0, 0), Motor3D(0, -1, 0, 0, 0, 0, 0, 0),
    Motor3D(0, 0, 1, 0, 0, 0, 0, 0), Motor3D(0, 0, -1, 0, 0, 0, 0, 0),
    Motor3D(0, 0, 0, 1, 0, 0, 0, 0), Motor3D(0, 0, 0, -1, 0, 0, 0, 0),
    Motor3D(0, 0, 0, 0, 1, 0, 0, 0), Motor3D(0, 0, 0, 0, -1, 0, 0, 0),
    Motor3D(0, 0, 0, 0, 0, 1, 0, 0), Motor3D(0, 0, 0, 0, 0, -1, 0, 0),
    Motor3D(0, 0, 0, 0, 0, 0, 1, 0), Motor3D(0, 0, 0, 0, 0, 0, -1, 0),
    Motor3D(0, 0, 0, 0, 0, 0, 0, 1), Motor3D(0, 0, 0, 0, 0, 0, 0, -1),
    Motor3D(1, 0, 0, 0, 1, 0, 0, 0), Motor3D(1, 0, 0, 0, -1, 0, 0, 0),
    Motor3D(1, 0, 0, 0, 0, 1, 0, 0), Motor3D(1, 0, 0, 0, 0, -1, 0, 0),
    Motor3D(1, 0, 0, 0, 0, 0, 1, 0), Motor3D(1, 0, 0, 0, 0, 0, -1, 0),
    Motor3D(1, 0, 0, 0, 0, 0, 0, 1), Motor3D(1, 0, 0, 0, 0, 0, 0, -1),
    Motor3D(-1, 0, 0, 0, 1, 0, 0, 0), Motor3D(-1, 0, 0, 0, -1, 0, 0, 0),
    Motor3D(-1, 0, 0, 0, 0, 1, 0, 0), Motor3D(-1, 0, 0, 0, 0, -1, 0, 0),
    Motor3D(-1, 0, 0, 0, 0, 0, 1, 0), Motor3D(-1, 0, 0, 0, 0, 0, -1, 0),
    Motor3D(-1, 0, 0, 0, 0, 0, 0, 1), Motor3D(-1, 0, 0, 0, 0, 0, 0, -1)
]

weight_norm(a::Motor3D) = norm(SA[a[1], a[2], a[3], a[4]])
bulk_norm(a::Motor3D) = norm(SA[a[5], a[6], a[7], a[8]])

unitize(a::Motor3D) = Motor3D(internal_vec(a) .* (1 / weight_norm(a)))

function LinearAlgebra.normalize(m::Motor3D)
    wnmsq = m[1] * m[1] + m[2] * m[2] + m[3] * m[3] + m[4] * m[4]
    if wnmsq ≈ 0 || wnmsq < 0
        throw(DomainError(m, "Motor3D must have a non-zero rotational part to normalize."))
    else
        wnm = sqrt(wnmsq)
        A = 1 / wnm
        B = (m[1] * m[8] - (m[2] * m[5] + m[3] * m[6] + m[4] * m[7])) * A * A * A
        return Motor3D(
            A * m[1],
            A * m[2],
            A * m[3],
            A * m[4],
            A * m[5] + B * m[2],
            A * m[6] + B * m[3],
            A * m[7] + B * m[4],
            A * m[8] - B * m[1])
    end
end

reverse(a::Motor3D) = Motor3D(a[1], -a[2], -a[3], -a[4], -a[5], -a[6], -a[7], a[8])
anti_reverse(a::Motor3D) = reverse(a)

function Base.sqrt(m_input::Motor3D)
    if m_input[1] ≈ -1
        #@info m_input
        #@info "hit the sqrt otherpath"
        return normalize(-identity_motor() + m_input)
        #return exp((1 // 2) * log(normalize(m_input)))
    else
        return normalize(identity_motor() + m_input)
    end
end

#=
function Base.sqrt(m_input::Motor3D)
    return normalize(sign(m_input[1]) * identity_motor() + m_input)
end
=#

function Base.inv(a::Motor3D)
    a1a1 = a[1] * a[1]
    a3a3 = a[3] * a[3]
    a4a4 = a[4] * a[4]
    a2a2 = a[2] * a[2]
    D1 = a1a1 + a2a2 + a3a3 + a4a4
    if D1 ≈ 0 || D1 < 0
        throw(DomainError(a, "Motor3D must have a non-zero rotational part to invert."))
    else
        a1a1a1 = a1a1 * a[1]
        a2a2a2 = a2a2 * a[2]
        a3a3a3 = a3a3 * a[3]
        a4a4a4 = a4a4 * a[4]
        a1a1a1a1 = a1a1a1 * a[1]
        a3a6 = a[3] * a[6]
        a4a7 = a[4] * a[7]
        a2a2a2a2 = a2a2a2 * a[2]
        a1a8 = a[1] * a[8]
        a3a3a3a3 = a3a3a3 * a[3]
        a4a4a4a4 = a4a4a4 * a[4]
        a2a5 = a[2] * a[5]
        a1a1a3a3 = a1a1 * a3a3
        a2a2a4a4 = a2a2 * a4a4
        a1a1a1a8 = a1a1a1 * a[8]
        a3a3a3a6 = a3a3a3 * a[6]
        a4a4a4a7 = a4a4a4 * a[7]
        a2a2a2a5 = a2a2a2 * a[5]
        a1a1a2 = a1a1 * a[2]
        a1a1a4a4 = a1a1 * a4a4
        a1a8a2 = a1a8 * a[2]
        a3a3a4a7 = a3a3 * a4a7
        a3a6a4a4 = a3a6 * a4a4
        a3a3a4a4 = a3a3 * a4a4
        a1a1a2a2 = a1a1 * a2a2
        a1a1a2a5 = a1a1 * a2a5
        a3a4a7 = a[3] * a4a7
        a1a8a2a2 = a1a8 * a2a2
        a3a4a4 = a[3] * a4a4
        a3a6a4 = a3a6 * a[4]
        a3a3a4 = a3a3 * a[4]
        a2a2a3a3 = a2a2 * a3a3
        a1a2a2 = a[1] * a2a2
        a1a2a5 = a[1] * a2a5
        a1a1a1a1a1 = a1a1a1a1 * a[1]
        a2a2a2a2a2 = a2a2a2a2 * a[2]
        a3a3a3a3a3 = a3a3a3a3 * a[3]
        a4a4a4a4a4 = a4a4a4a4 * a[4]
        D2 = a1a1a1a1a1 * a[1] + 3 * a1a1a1a1 * a2a2 + 3 * a1a1a1a1 * a3a3 + 3 * a1a1a1a1 * a4a4 + 3 * a1a1 * a2a2a2a2 + 6 * a1a1a3a3 * a2a2 + 6 * a1a1 * a2a2a4a4 + 3 * a1a1 * a3a3a3a3 + 6 * a1a1a3a3 * a4a4 + 3 * a1a1 * a4a4a4a4 + a2a2a2a2a2 * a[2] + 3 * a2a2a2a2 * a3a3 + 3 * a2a2a2a2 * a4a4 + 3 * a2a2 * a3a3a3a3 + 6 * a2a2a4a4 * a3a3 + 3 * a2a2 * a4a4a4a4 + a3a3a3a3a3 * a[3] + 3 * a3a3a3a3 * a4a4 + 3 * a3a3 * a4a4a4a4 + a4a4a4a4a4 * a[4]
        return Motor3D((a[1]) / (D1),
            (-a[2]) / (D1),
            (-a[3]) / (D1),
            (-a[4]) / (D1),
            (-a1a1a1a1 * a[5] + a2a2a2a2 * a[5] - a3a3a3a3 * a[5] - a4a4a4a4 * a[5] + 2 * (-a1a1a1a8 * a[2] + a1a1a2 * a3a6 + a1a1a2 * a4a7 - a1a1a3a3 * a[5] - a1a1a4a4 * a[5] - a1a8 * a2a2a2 - a1a8a2 * a3a3 - a1a8a2 * a4a4 + a2a2a2 * a3a6 + a2a2a2 * a4a7 + a[2] * a3a3a3a6 + a[2] * a3a3a4a7 + a[2] * a3a6a4a4 + a[2] * a4a4a4a7 - a3a3a4a4 * a[5])) / (D2),
            (-a1a1a1a1 * a[6] - a2a2a2a2 * a[6] + a3a3a3 * a3a6 - a4a4a4a4 * a[6] + 2 * (-a1a1a1a8 * a[3] - a1a1a2a2 * a[6] + a1a1a2a5 * a[3] + a1a1 * a3a4a7 - a1a1a4a4 * a[6] - a1a8a2a2 * a[3] - a1a8 * a3a3a3 - a1a8 * a3a4a4 + a2a2a2a5 * a[3] + a2a2 * a3a4a7 - a2a2a4a4 * a[6] + a2a5 * a3a3a3 + a2a5 * a3a4a4 + a3a3a3 * a4a7 + a[3] * a4a4a4a7)) / (D2),
            (-a1a1a1a1 * a[7] - a2a2a2a2 * a[7] - a3a3a3a3 * a[7] + a4a4a4 * a4a7 + 2 * (-a1a1a1a8 * a[4] - a1a1a2a2 * a[7] + a1a1a2a5 * a[4] - a1a1a3a3 * a[7] + a1a1 * a3a6a4 - a1a8a2a2 * a[4] - a1a8 * a3a3a4 - a1a8 * a4a4a4 + a2a2a2a5 * a[4] - a2a2a3a3 * a[7] + a2a2 * a3a6a4 + a2a5 * a3a3a4 + a2a5 * a4a4a4 + a3a3a3a6 * a[4] + a3a6 * a4a4a4)) / (D2),
            (-a1a1a1a1 * a[8] + a2a2a2a2 * a[8] + a3a3a3a3 * a[8] + a4a4a4a4 * a[8] + 2 * (a1a1a1 * a2a5 + a1a1a1 * a3a6 + a1a1a1 * a4a7 + a[1] * a2a2a2a5 + a1a2a2 * a3a6 + a1a2a2 * a4a7 + a1a2a5 * a3a3 + a1a2a5 * a4a4 + a[1] * a3a3a3a6 + a[1] * a3a3a4a7 + a[1] * a3a6a4a4 + a[1] * a4a4a4a7 + a2a2a3a3 * a[8] + a2a2a4a4 * a[8] + a3a3a4a4 * a[8])) / (D2))
    end
end

function get_transform_matrix(a::Motor3D)
    return SA[
        (a[1]^2+a[2]^2-(a[3]^2)-(a[4]^2)) (2(a[2]*a[3]+a[1]*a[4])) (2(a[2]*a[4]-a[1]*a[3])) (2(a[7]*a[3]-a[5]*a[1]-a[8]*a[2]-a[6]*a[4]))
        (2(a[2]*a[3]-a[1]*a[4])) (a[1]^2+a[3]^2-(a[2]^2)-(a[4]^2)) (2(a[1]*a[2]+a[3]*a[4])) (2(a[5]*a[4]-a[8]*a[3]-a[6]*a[1]-a[7]*a[2]))
        (2(a[1]*a[3]+a[2]*a[4])) (2(a[3]*a[4]-a[1]*a[2])) (a[1]^2+a[4]^2-(a[2]^2)-(a[3]^2)) (2(a[6]*a[2]-a[5]*a[3]-a[8]*a[4]-a[7]*a[1]))
        0 0 0 1
    ]
end

function get_inv_transform_matrix(a_ununitized::Motor3D)
    inv(get_transform_matrix(a_ununitized))
end

function get_transform_and_inv_matrices(a_ununitized::Motor3D)
    matrix = get_transform_matrix(a_ununitized)
    inv_matrix = get_inv_transform_matrix(a_ununitized)
    (; matrix, inv_matrix)
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
    transpoint = Point3D(M[1, 4], M[2, 4], M[3, 4])

    translator = Motor3D(1, 0, 0, 0, -(1 // 2) * transpoint[1], -(1 // 2) * transpoint[2], -(1 // 2) * transpoint[3], 0)
    return normalize(translator * rotor)
end





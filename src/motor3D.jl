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

get_rotor(a::Motor3D) = Motor3D(a[1], a[2], a[3], a[4], 0, 0, 0, 0)

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
    if m_input[1] < 0
        return normalize(-identity_motor() + m_input)
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

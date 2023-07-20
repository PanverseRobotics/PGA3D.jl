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

identity_motor() = Motor3D(1, 0, 0, 0, 0, 0, 0, 0)

weight_norm(a::Motor3D) = norm(SA[a[1], a[2], a[3], a[4]])
bulk_norm(a::Motor3D) = norm(SA[a[5], a[6], a[7], a[8]])

unitize(a::Motor3D) = Motor3D(internal_vec(a) .* (1 / weight_norm(a)))

function LinearAlgebra.normalize(m::Motor3D)
    wnmsq = m[1] * m[1] + m[2] * m[2] + m[3] * m[3] + m[4] * m[4]
    if wnmsq ≈ 0 || wnmsq < 0
        throw(DomainError(m, "Cannot normalize a motor with zero rotational part."))
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

# not sure why this doesn't work
function Base.sqrt(m::Motor3D)
    normalize(Motor3D(1 + m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8]))
end

function get_position(a_ununitized::Motor3D)
    a = unitize(a_ununitized)
    A14 = a[2] * a[7] - a[3] * a[6]
    A24 = a[3] * a[5] - a[1] * a[7]
    A34 = a[1] * a[6] - a[2] * a[5]

    B14 = a[5] * a[4] - a[1] * a[8]
    B24 = a[6] * a[4] - a[2] * a[8]
    B34 = a[7] * a[4] - a[3] * a[8]

    return Point3D((A14 + B14) * 2, (A24 + B24) * 2, (A34 + B34) * 2)
end

#=
function get_transform_matrix(m_unnormalized::Motor3D)
    m = normalize(m_unnormalized)
    #m = m_unnormalized
    a0, a1, a2, a3, a4, a5, a6, a7 = m[4], m[5], m[6], m[7], m[2], m[1], m[3], m[8]
    _2a0 = 2a0
    _2a4 = 2a4
    _2a5 = 2a5
    a0a0 = a0 * a0
    a4a4 = a4 * a4
    a5a5 = a5 * a5
    a6a6 = a6 * a6
    _2a6 = 2 * a6
    _2a0a4 = _2a0 * a4
    _2a0a5 = _2a0 * a5
    _2a0a6 = _2a0 * a6
    _2a4a5 = _2a4 * a5
    _2a4a6 = _2a4 * a6
    _2a5a6 = _2a5 * a6
    SA[
        (a0a0+a4a4-a5a5-a6a6) (_2a4a5+_2a0a6) (_2a4a6-_2a0a5) ((_2a0*a3)+(_2a4*a7)-(_2a6*a2)-(_2a5*a1))
        (_2a4a5-_2a0a6) (a0a0-a4a4+a5a5-a6a6) (_2a0a4+_2a5a6) ((_2a4*a1)-(_2a0*a2)-(_2a6*a3)+(_2a5*a7))
        (_2a0a5+_2a4a6) (_2a5a6-_2a0a4) (a0a0-a4a4-a5a5+a6a6) ((_2a0*a1)+(_2a4*a2)+(_2a5*a3)+(_2a6*a7))
        0 0 0 (a0a0+a4a4+a5a5+a6a6)
    ]
end
=#
function get_transform_matrix(a::Motor3D)
    return SA[
        (a[1]^2+a[2]^2-(a[3]^2)-(a[4]^2)) (2(a[2]*a[3]+a[1]*a[4])) (2(a[2]*a[4]-a[1]*a[3])) (2(a[7]*a[3]-a[5]*a[1]-a[8]*a[2]-a[6]*a[4]))
        (2(a[2]*a[3]-a[1]*a[4])) (a[1]^2+a[3]^2-(a[2]^2)-(a[4]^2)) (2(a[1]*a[2]+a[3]*a[4])) (2(a[5]*a[4]-a[8]*a[3]-a[6]*a[1]-a[7]*a[2]))
        (2(a[1]*a[3]+a[2]*a[4])) (2(a[3]*a[4]-a[1]*a[2])) (a[1]^2+a[4]^2-(a[2]^2)-(a[3]^2)) (2(a[6]*a[2]-a[5]*a[3]-a[8]*a[4]-a[7]*a[1]))
        0 0 0 1
    ]
end
#=
function get_transform_matrix(b::Motor3D)
    SA[
        (b[4]^2+b[1]^2-(b[2]^2)-(b[3]^2)) (2b[1]*b[2]+2b[4]*b[3]) (2b[1]*b[3]-2b[4]*b[2]) (2b[7]*b[2]-2b[5]*b[4]-2b[8]*b[1]-2b[6]*b[3])
        (2b[1]*b[2]-2b[4]*b[3]) (b[4]^2+b[2]^2-(b[1]^2)-(b[3]^2)) (2b[4]*b[1]+2b[2]*b[3]) (2b[5]*b[3]-2b[8]*b[2]-2b[6]*b[4]-2b[7]*b[1])
        (2b[4]*b[2]+2b[1]*b[3]) (2b[2]*b[3]-2b[4]*b[1]) (b[4]^2+b[3]^2-(b[1]^2)-(b[2]^2)) (2b[6]*b[1]-2b[5]*b[2]-2b[8]*b[3]-2b[7]*b[4])
        0 0 0 (b[4]^2+b[1]^2+b[2]^2+b[3]^2)
    ]
end
=#

#=
function get_transform_matrix_2(a_ununitized::Motor3D)
    a = unitize(a_ununitized)
    vx2 = a[1] * a[1]
    vy2 = a[2] * a[2]
    vz2 = a[3] * a[3]

    A11 = 1 - (vy2 + vz2) * 2
    A22 = 1 - (vz2 + vx2) * 2
    A33 = 1 - (vx2 + vy2) * 2
    A12 = a[1] * a[2]
    A13 = a[3] * a[1]
    A23 = a[2] * a[3]
    A14 = a[2] * a[7] - a[3] * a[6]
    A24 = a[3] * a[5] - a[1] * a[7]
    A34 = a[1] * a[6] - a[2] * a[5]

    B12 = a[3] * a[4]
    B31 = a[2] * a[4]
    B23 = a[1] * a[4]
    B14 = a[5] * a[4] - a[1] * a[8]
    B24 = a[6] * a[4] - a[2] * a[8]
    B34 = a[7] * a[4] - a[3] * a[8]

    return SA[A11 (A12-B12)*2 (A13+B31)*2 (A14+B14)*2
        (A12+B12)*2 A22 (A23-B23)*2 (A24+B24)*2
        (A13-B31)*2 (A23+B23)*2 A33 (A34+B34)*2
        0 0 0 1
    ]
end
=#

function get_inv_transform_matrix(a_ununitized::Motor3D)
    Base.inv(get_transform_matrix(a_ununitized))
end
#=
function get_inv_transform_matrix(a_ununitized::Motor3D)
    a = unitize(a_ununitized)
    vx2 = a[1] * a[1]
    vy2 = a[2] * a[2]
    vz2 = a[3] * a[3]

    A11 = 1 - (vy2 + vz2) * 2
    A22 = 1 - (vz2 + vx2) * 2
    A33 = 1 - (vx2 + vy2) * 2
    A12 = a[1] * a[2]
    A13 = a[3] * a[1]
    A23 = a[2] * a[3]
    A14 = a[2] * a[7] - a[3] * a[6]
    A24 = a[3] * a[5] - a[1] * a[7]
    A34 = a[1] * a[6] - a[2] * a[5]

    B12 = a[3] * a[4]
    B31 = a[2] * a[4]
    B23 = a[1] * a[4]
    B14 = a[5] * a[4] - a[1] * a[8]
    B24 = a[6] * a[4] - a[2] * a[8]
    B34 = a[7] * a[4] - a[3] * a[8]


    return SA[A11 (A12+B12)*2 (A13-B31)*2 (A14-B14)*2
        (A12-B12)*2 A22 (A23+B23)*2 (A24-B24)*2
        (A13+B31)*2 (A23-B23)*2 A33 (A34-B34)*2
        0 0 0 1
    ]
end
=#

function get_transform_and_inv_matrices(a_ununitized::Motor3D)
    matrix = get_transform_matrix(a_ununitized)
    inv_matrix = get_inv_transform_matrix(a_ununitized)
    (; matrix, inv_matrix)
end
#=
function get_transform_and_inv_matrices(a_ununitized::Motor3D)
    a = unitize(a_ununitized)
    vx2 = a[1] * a[1]
    vy2 = a[2] * a[2]
    vz2 = a[3] * a[3]

    A11 = 1 - (vy2 + vz2) * 2
    A22 = 1 - (vz2 + vx2) * 2
    A33 = 1 - (vx2 + vy2) * 2
    A12 = a[1] * a[2]
    A13 = a[3] * a[1]
    A23 = a[2] * a[3]
    A14 = a[2] * a[7] - a[3] * a[6]
    A24 = a[3] * a[5] - a[1] * a[7]
    A34 = a[1] * a[6] - a[2] * a[5]

    B12 = a[3] * a[4]
    B31 = a[2] * a[4]
    B23 = a[1] * a[4]
    B14 = a[5] * a[4] - a[1] * a[8]
    B24 = a[6] * a[4] - a[2] * a[8]
    B34 = a[7] * a[4] - a[3] * a[8]

    matrix = SA[A11 (A12-B12)*2 (A13+B31)*2 (A14+B14)*2
        (A12+B12)*2 A22 (A23-B23)*2 (A24+B24)*2
        (A13-B31)*2 (A23+B23)*2 A33 (A34+B34)*2
        0 0 0 1
    ]
    inv_matrix = SA[A11 (A12+B12)*2 (A13-B31)*2 (A14-B14)*2
        (A12-B12)*2 A22 (A23+B23)*2 (A24-B24)*2
        (A13+B31)*2 (A23-B23)*2 A33 (A34-B34)*2
        0 0 0 1
    ]
    return (; matrix, inv_matrix)
end
=#


function motor_from_transform(M::SMatrix{4,4,T}) where {T<:Number}
    # rotation stuff first
    M11 = M[1, 1]
    M22 = M[2, 2]
    M33 = M[3, 3]
    sum = M11 + M22 + M33

    (; vx, vy, vz, vw) = if sum > 0
        vw = sqrt(sum + 1) * (1 // 2)
        f = (1 // 4) / vw

        vx = (M[3, 2] - M[2, 3]) * f
        vy = (M[1, 3] - M[3, 1]) * f
        vz = (M[2, 1] - M[1, 2]) * f

        (; vx, vy, vz, vw)
    elseif M11 > M22 && M11 > M33
        vx = sqrt(M11 - M22 - M33 + 1) * (1 // 2)
        f = (1 // 4) / vx

        vy = (M[2, 1] + M[1, 2]) * f
        vz = (M[1, 3] + M[3, 1]) * f
        vw = (M[3, 2] - M[2, 3]) * f

        (; vx, vy, vz, vw)
    elseif M22 > M33
        vy = sqrt(M22 - M33 - M11 + 1) * (1 // 2)
        f = (1 // 4) / vy

        vx = (M[2, 1] + M[1, 2]) * f
        vz = (M[3, 2] + M[2, 3]) * f
        vw = (M[1, 3] - M[3, 1]) * f

        (; vx, vy, vz, vw)
    else
        vz = sqrt(M33 - M11 - M22 + 1) * (1 // 2)
        f = (1 // 4) / vz

        vx = (M[1, 3] + M[3, 1]) * f
        vy = (M[3, 2] + M[2, 3]) * f
        vw = (M[2, 1] - M[1, 2]) * f

        (; vx, vy, vz, vw)
    end

    # ok so now we have the rotational part, let's do the translational part
    tx = M[1, 4] * (1 // 2)
    ty = M[2, 4] * (1 // 2)
    tz = M[3, 4] * (1 // 2)

    mx = vw * tx + vz * ty - vy * tz
    my = vw * ty + vx * tz - vz * tx
    mz = vw * tz + vy * tx - vx * ty
    mw = -vx * tx - vy * ty - vz * tz

    unitize(Motor3D(vx, vy, vz, vw, mx, my, mz, mw))
end



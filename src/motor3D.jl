struct Motor3D{T<:Real} <: AbstractPGA3DElement{T}
    vec::SVector{8,T}

    function Motor3D(vx::Real, vy::Real, vz::Real, vw::Real, mx::Real, my::Real, mz::Real, mw::Real)
        T = promote_type(eltype(vx), eltype(vy), eltype(vz), eltype(vw), eltype(mx), eltype(my), eltype(mz), eltype(mw))
        vec = SVector{8,T}(promote(vx, vy, vz, vw, mx, my, mz, mw)...)
        new{T}(vec)
    end

    function Motor3D(vec::SVector{8,T}) where {T<:Real}
        new{T}(vec)
    end
end

internal_vec(a::Motor3D) = a.vec

Base.length(::Motor3D) = 8
Base.size(::Motor3D) = (8,)


get_vx(a::Motor3D) = a[1]
get_vy(a::Motor3D) = a[2]
get_vz(a::Motor3D) = a[3]
get_vw(a::Motor3D) = a[4]
get_mx(a::Motor3D) = a[5]
get_my(a::Motor3D) = a[6]
get_mz(a::Motor3D) = a[7]
get_mw(a::Motor3D) = a[8]

Base.:(+)(a::Motor3D, b::Motor3D) = Motor3D(internal_vec(a) .+ internal_vec(b))
Base.:(-)(a::Motor3D, b::Motor3D) = Motor3D(internal_vec(a) .- internal_vec(b))
#⋅(a::Motor3D, b::Motor3D) = internal_vec(a) ⋅ internal_vec(b)
#dot(a::Motor3D, b::Motor3D) = a ⋅ b

function Base.:(*)(a::Motor3D, b::Motor3D)
    Motor3D(
        a[4] * b[1] + a[1] * b[4] + a[2] * b[3] - a[3] * b[2],
        a[4] * b[2] + a[2] * b[4] + a[3] * b[1] - a[1] * b[3],
        a[4] * b[3] + a[3] * b[4] + a[1] * b[2] - a[2] * b[1],
        a[4] * b[4] - a[1] * b[1] - a[2] * b[2] - a[3] * b[3],
        a[8] * b[1] + a[5] * b[4] + a[6] * b[3] - a[7] * b[2] + a[4] * b[5] + a[1] * b[8] + a[2] * b[7] - a[3] * b[6],
        a[8] * b[2] + a[6] * b[4] + a[7] * b[1] - a[5] * b[3] + a[4] * b[6] + a[2] * b[8] + a[3] * b[5] - a[1] * b[7],
        a[8] * b[3] + a[7] * b[4] + a[5] * b[2] - a[6] * b[1] + a[4] * b[7] + a[3] * b[8] + a[1] * b[6] - a[2] * b[5],
        a[8] * b[4] - a[5] * b[1] - a[6] * b[2] - a[7] * b[3] + a[4] * b[8] - a[1] * b[5] - a[2] * b[6] - a[3] * b[7]
    )
end
#=
 old
        a[8] * b[3] + a[5] * b[2] - a[6] * b[1] + a[7] * b[4] + b[8] * a[3] - b[5] * a[2] + b[6] * a[1] + b[7] * a[4],
        a[8] * b[1] + a[5] * b[4] + a[6] * b[3] - a[7] * b[2] + b[8] * a[1] + b[5] * a[4] - b[6] * a[3] + b[7] * a[2],
        a[8] * b[2] - a[5] * b[3] + a[6] * b[4] + a[7] * b[1] + b[8] * a[2] + b[5] * a[3] + b[6] * a[4] - b[7] * a[1],
        a[8] * b[4] - a[5] * b[1] - a[6] * b[2] - a[7] * b[3] + b[8] * a[4] - b[5] * a[1] - b[6] * a[2] - b[7] * a[3]
        =#

identity_motor() = Motor3D(0, 0, 0, 1, 0, 0, 0, 0)

weight_norm(a::Motor3D) = norm(SA[a[1], a[2], a[3], a[4]])
bulk_norm(a::Motor3D) = norm(SA[a[5], a[6], a[7], a[8]])

unitize(a::Motor3D) = Motor3D(internal_vec(a) .* (1 / weight_norm(a)))

reverse(a::Motor3D) = Motor3D(-a[1], -a[2], -a[3], a[4], -a[5], -a[6], -a[7], a[8])
anti_reverse(a::Motor3D) = reverse(a)

#=
Motor3D Terathon::Sqrt(const Motor3D& Q)
{
	float b = InverseSqrt(Q.v.w * 2.0F + 2.0F);
	float a = -Q.m.w * (b * b);

	return (Motor3D(Q.v.x * b, Q.v.y * b, Q.v.z * b, Q.v.w * b + b, (Q.v.x * a + Q.m.x) * b, (Q.v.y * a + Q.m.y) * b, (Q.v.z * a + Q.m.z) * b, Q.m.w * (b * 0.5F)));
}
=#

function Base.sqrt(q::Motor3D)
    if q[4] < 0
        q = Motor3D(-internal_vec(q)) # they represent the same transform
    end
    b = 1 / sqrt(q[4] * 2 + 2)
    a = -q[8] * (b * b)
    Motor3D(q[1] * b, q[2] * b, q[3] * b, q[4] * b + b, (q[1] * a + q[5]) * b, (q[2] * a + q[6]) * b, (q[3] * a + q[7]) * b, q[8] * (b * (1 // 2)))
end

function get_transform_matrix(a_ununitized::Motor3D)
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





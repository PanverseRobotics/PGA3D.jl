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
Base.:(-)(a::Motor3D) = Motor3D(-internal_vec(a))
Base.:(*)(a::Motor3D, b::Real) = Motor3D((internal_vec(a) .* b))
Base.:(*)(a::Real, b::Motor3D) = Motor3D((a .* internal_vec(b)))
#⋅(a::Motor3D, b::Motor3D) = internal_vec(a) ⋅ internal_vec(b)
#dot(a::Motor3D, b::Motor3D) = a ⋅ b

# this is the product from the terathon math library but it doesn't do what I think it should
#=
function Base.:(*)(b::Motor3D, a::Motor3D) # dual quernion geometric product
    Motor3D(
        a[4] * b[1] + a[1] * b[4] + a[2] * b[3] - a[3] * b[2],
        a[4] * b[2] + a[2] * b[4] + a[3] * b[1] - a[1] * b[3],
        a[4] * b[3] + a[3] * b[4] + a[1] * b[2] - a[2] * b[1],
        a[4] * b[4] - a[1] * b[1] - a[2] * b[2] - a[3] * b[3],
        a[8] * b[1] + a[5] * b[2] - a[6] * b[1] + a[7] * b[4] + b[8] * a[3] - b[5] * a[2] + b[6] * a[1] + b[7] * a[4],
        a[8] * b[2] + a[5] * b[4] + a[6] * b[3] - a[7] * b[2] + b[8] * a[1] + b[5] * a[4] - b[6] * a[3] + b[7] * a[2],
        a[8] * b[3] - a[5] * b[3] + a[6] * b[4] + a[7] * b[1] + b[8] * a[2] + b[5] * a[3] + b[6] * a[4] - b[7] * a[1],
        a[8] * b[4] - a[5] * b[1] - a[6] * b[2] - a[7] * b[3] + b[8] * a[4] - b[5] * a[1] - b[6] * a[2] - b[7] * a[3]
    )
end
=#
# this is the one from enki's stuff, translated
function Base.:(*)(a::Motor3D, b::Motor3D)
    Motor3D(
        b[1] * a[4] + b[2] * a[3] - b[3] * a[2] + b[4] * a[1],
        b[2] * a[4] - b[1] * a[3] + b[4] * a[2] + b[3] * a[1],
        b[3] * a[4] + b[4] * a[3] + b[1] * a[2] - b[2] * a[1],
        b[4] * a[4] - b[3] * a[3] - b[2] * a[2] - b[1] * a[1],
        b[5] * a[4] + b[4] * a[5] - b[3] * a[6] + b[2] * a[7] + b[6] * a[3] - b[7] * a[2] - b[8] * a[1] - b[1] * a[8],
        b[6] * a[4] + b[3] * a[5] + b[4] * a[6] - b[1] * a[7] - b[5] * a[3] - b[8] * a[2] + b[7] * a[1] - b[2] * a[8],
        b[7] * a[4] - b[2] * a[5] + b[1] * a[6] + b[4] * a[7] - b[8] * a[3] + b[5] * a[2] - b[6] * a[1] - b[3] * a[8],
        b[8] * a[4] + b[1] * a[5] + b[2] * a[6] + b[3] * a[7] + b[7] * a[3] + b[6] * a[2] + b[5] * a[1] + b[4] * a[8]
    )
end
# res[10]=b[10]*a[0]+b[9]*a[8]-b[8]*a[9]+b[0]*a[10];
# res[1]=b[1]*a[4]+b[2]*a[3]-b[3]*a[2]+b[4]*a[1];
# res[9]=b[9]*a[0]-b[10]*a[8]+b[0]*a[9]+b[8]*a[10];
# res[2]=b[2]*a[4]-b[1]*a[3]+b[4]*a[2]+b[3]*a[1];
# res[8]=b[8]*a[0]+b[0]*a[8]+b[10]*a[9]-b[9]*a[10];
# res[3]=b[3]*a[4]+b[4]*a[3]+b[1]*a[2]-b[2]*a[1];
# res[0]=b[0]*a[0]-b[8]*a[8]-b[9]*a[9]-b[10]*a[10];
# res[4]=b[4]*a[4]-b[3]*a[3]-b[2]*a[2]-b[1]*a[1];
# res[5]=b[5]*a[0]+b[0]*a[5]-b[8]*a[6]+b[9]*a[7]+b[6]*a[8]-b[7]*a[9]-b[15]*a[10]-b[10]*a[15];
# res[5]=b[5]*a[4]+b[4]*a[5]-b[3]*a[6]+b[2]*a[7]+b[6]*a[3]-b[7]*a[2]-b[8]*a[1]-b[1]*a[8];
# res[6]=b[6]*a[0]+b[8]*a[5]+b[0]*a[6]-b[10]*a[7]-b[5]*a[8]-b[15]*a[9]+b[7]*a[10]-b[9]*a[15];
# res[6]=b[6]*a[4]+b[3]*a[5]+b[4]*a[6]-b[1]*a[7]-b[5]*a[3]-b[8]*a[2]+b[7]*a[1]-b[2]*a[8];
# res[7]=b[7]*a[0]-b[9]*a[5]+b[10]*a[6]+b[0]*a[7]-b[15]*a[8]+b[5]*a[9]-b[6]*a[10]-b[8]*a[15];
# res[7]=b[7]*a[4]-b[2]*a[5]+b[1]*a[6]+b[4]*a[7]-b[8]*a[3]+b[5]*a[2]-b[6]*a[1]-b[3]*a[8];
# res[15]=b[15]*a[0]+b[10]*a[5]+b[9]*a[6]+b[8]*a[7]+b[7]*a[8]+b[6]*a[9]+b[5]*a[10]+b[0]*a[15];
# res[8]=b[8]*a[4]+b[1]*a[5]+b[2]*a[6]+b[3]*a[7]+b[7]*a[3]+b[6]*a[2]+b[5]*a[1]+b[4]*a[8];
# mapping: 0 -> 4, 5->5, 6->6, 7->7, 8 -> 3, 9 -> 2, 10 -> 1, 15 -> 8
#=
res[0]=b[0]*a[0]-b[8]*a[8]-b[9]*a[9]-b[10]*a[10]
res[5]=b[5]*a[0]+b[0]*a[5]-b[8]*a[6]+b[9]*a[7]+b[6]*a[8]-b[7]*a[9]-b[15]*a[10]-b[10]*a[15]
res[6]=b[6]*a[0]+b[8]*a[5]+b[0]*a[6]-b[10]*a[7]-b[5]*a[8]-b[15]*a[9]+b[7]*a[10]-b[9]*a[15]
res[7]=b[7]*a[0]-b[9]*a[5]+b[10]*a[6]+b[0]*a[7]-b[15]*a[8]+b[5]*a[9]-b[6]*a[10]-b[8]*a[15]
res[8]=b[8]*a[0]+b[0]*a[8]+b[10]*a[9]-b[9]*a[10]
res[9]=b[9]*a[0]-b[10]*a[8]+b[0]*a[9]+b[8]*a[10]
res[10]=b[10]*a[0]+b[9]*a[8]-b[8]*a[9]+b[0]*a[10]
res[15]=b[15]*a[0]+b[10]*a[5]+b[9]*a[6]+b[8]*a[7]+b[7]*a[8]+b[6]*a[9]+b[5]*a[10]+b[0]*a[15]
=#
#=
# this is the one that I used to have which is just dual quaternion math
function Base.:(*)(a::Motor3D, b::Motor3D) # dual quernion geometric product
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
=#

identity_motor() = Motor3D(0, 0, 0, 1, 0, 0, 0, 0)

weight_norm(a::Motor3D) = norm(SA[a[1], a[2], a[3], a[4]])
bulk_norm(a::Motor3D) = norm(SA[a[5], a[6], a[7], a[8]])

unitize(a::Motor3D) = Motor3D(internal_vec(a) .* (1 / weight_norm(a)))
#=
function LinearAlgebra.normalize(m::Motor3D)
    # this is inefficient but correct, will want to move to something like the formula below with the algebra worked out already
    mmrev = m * reverse(m)
    s, t = mmrev[4], mmrev[8]
    s2 = sqrt(s)
    study_inv_sqrt = Motor3D(0, 0, 0, 1 / s2, 0, 0, 0, t / (2 * s2^3))
    return m * study_inv_sqrt
end
=#
#=
function LinearAlgebra.normalize(m::Motor3D)
    A = 1 / weight_norm(m)
    B = (m[4] * m[8] + m[1] * m[5] + m[2] * m[6] + m[3] * m[7]) * A * A * A / 2
    Motor3D(
        A * m[1],
        A * m[2],
        A * m[3],
        A * m[4],
        A * m[5] - B * m[1],
        A * m[6] - B * m[2],
        A * m[7] - B * m[3],
        A * m[8] + B * m[4])
end
=#

function LinearAlgebra.normalize(m::Motor3D)
    A = 1 / weight_norm(m)
    B = (m[4] * m[8] - (m[1] * m[5] + m[2] * m[6] + m[3] * m[7])) * A * A * A
    Motor3D(
        A * m[1],
        A * m[2],
        A * m[3],
        A * m[4],
        A * m[5] + B * m[1],
        A * m[6] + B * m[2],
        A * m[7] + B * m[3],
        A * m[8] - B * m[4])
end

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
#= # not sure why this doesn't work
function Base.sqrt(m::Motor3D)
    normalize(Motor3D(m[1], m[2], m[3], m[4] + 1, m[5], m[6], m[7], m[8]))
end
=#

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


function motor_from_transform(M::SMatrix{4,4,T}) where {T<:Real}
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



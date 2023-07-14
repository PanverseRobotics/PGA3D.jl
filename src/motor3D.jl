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
length(::Motor3D) = 8
size(::Motor3D) = (8,)

+(a::Motor3D, b::Motor3D) = Motor3D((internal_vec(a) .+ internal_vec(b))...)
-(a::Motor3D, b::Motor3D) = Motor3D((internal_vec(a) .- internal_vec(b))...)
#⋅(a::Motor3D, b::Motor3D) = internal_vec(a) ⋅ internal_vec(b)
#dot(a::Motor3D, b::Motor3D) = a ⋅ b

function *(a::Motor3D, b::Motor3D)
    Motor3D(
        a[4] * b[1] + a[1] * b[4] + a[2] * b[3] - a[3] * b[2],
        a[4] * b[2] + a[2] * b[4] + a[3] * b[1] - a[1] * b[3],
        a[4] * b[3] + a[3] * b[4] + a[1] * b[2] - a[2] * b[1],
        a[4] * b[4] - a[1] * b[1] - a[2] * b[2] - a[3] * b[3],
        a[8] * b[3] + a[5] * b[2] - a[6] * b[1] + a[7] * b[4] + b[8] * a[3] - b[5] * a[2] + b[6] * a[1] + b[7] * a[4],
        a[8] * b[1] + a[5] * b[4] + a[6] * b[3] - a[7] * b[2] + b[8] * a[1] + b[5] * a[4] + b[6] * a[3] - b[7] * a[2],
        a[8] * b[2] - a[5] * b[3] + a[6] * b[4] + a[7] * b[1] + b[8] * a[2] - b[5] * a[3] + b[6] * a[4] + b[7] * a[1],
        a[8] * b[4] - a[5] * b[1] - a[6] * b[2] - a[7] * b[3] + b[8] * a[4] - b[5] * a[1] - b[6] * a[2] - b[7] * a[3]
    )
end

weight_norm(a::Motor3D) = norm((internal_vec(a)[1:4]))
bulk_norm(a::Motor3D) = norm((internal_vec(a)[5:8]))

unitize(a::Motor3D) = Motor3D(internal_vec(a) .* (1 / weight_norm(a)))






struct Vector3D{T<:Real} <: AbstractVector3D{T}
    vec::SVector{3,T}

    function Vector3D(x::Real, y::Real, z::Real)
        T = promote_type(eltype(x), eltype(y), eltype(z))
        vec = SVector{3,T}(promote(x, y, z)...)
        new{T}(vec)
    end

    function Vector3D(vec::SVector{3,T}) where {T<:Real}
        new{T}(vec)
    end
end

internal_vec(v::Vector3D) = v.vec

get_x(v::Vector3D) = v[1]
get_y(v::Vector3D) = v[2]
get_z(v::Vector3D) = v[3]

# Define the basic arithmetic operations for Vector3D
# I think this interface prevents broadcast fusion from happening but we can fix that later if we need the extra performance.
Base.:(+)(v::Vector3D, w::Vector3D) = Vector3D(v.vec .+ w.vec)
Base.:(-)(v::Vector3D, w::Vector3D) = Vector3D(v.vec .- w.vec)
LinearAlgebra.:(⋅)(v::Vector3D, w::Vector3D) = v.vec ⋅ w.vec
#LinearAlgebra.dot(v::Vector3D, w::Vector3D) = v ⋅ w
Base.:(-)(a::Vector3D) = Vector3D(-internal_vec(a))
Base.:(*)(a::Vector3D, b::Real) = Vector3D((internal_vec(a) .* b))
Base.:(*)(a::Real, b::Vector3D) = Vector3D((a .* internal_vec(b)))

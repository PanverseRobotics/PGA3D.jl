
struct Vector3D{T<:Real} <: AbstractVector3D{T}
    vec::SVector{3,T}

    function Vector3D(x::Real, y::Real, z::Real)
        T = promote_type(eltype(x), eltype(y), eltype(z))
        vec = SVector{3,T}(promote(x, y, z)...)
        new{T}(vec)
    end
end

internal_vec(v::Vector3D) = v.vec

get_x(v::Vector3D) = internal_vec(v)[1]
get_y(v::Vector3D) = internal_vec(v)[2]
get_z(v::Vector3D) = internal_vec(v)[3]

# Provide an AbstractArray interface even though we're not subtyping it. 

# Define the basic arithmetic operations for Vector3D
+(v::Vector3D, w::Vector3D) = Vector3D((v.vec .+ w.vec)...)
-(v::Vector3D, w::Vector3D) = Vector3D((v.vec .- w.vec)...)
⋅(v::Vector3D, w::Vector3D) = sum(v.vec .* w.vec)
dot(v::Vector3D, w::Vector3D) = v ⋅ w

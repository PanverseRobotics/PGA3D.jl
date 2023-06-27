
struct Vector4D{T<:Real} <: AbstractVector4D{T}
    vec::SVector{4,T}

    function Vector4D(x::Real, y::Real, z::Real, w::Real)
        T = promote_type(eltype(x), eltype(y), eltype(z), eltype(w))
        vec = SVector{4,T}(promote(x, y, z, w)...)
        new{T}(vec)
    end

end

internal_vec(v::Vector4D) = v.vec

get_x(v::Vector4D) = internal_vec(v)[1]
get_y(v::Vector4D) = internal_vec(v)[2]
get_z(v::Vector4D) = internal_vec(v)[3]
get_w(v::Vector4D) = internal_vec(v)[4]

Vector4D(el::AbstractPGA3Element{T}) where {T<:Real} = convert(Vector4D{T}, el)

# Define the basic arithmetic operations for Vector4D
# I think this interface prevents broadcast fusion from happening but we can fix that later if we need the extra performance.
+(v::Vector4D, w::Vector4D) = Vector4D((v.vec .+ w.vec)...)
-(v::Vector4D, w::Vector4D) = Vector4D((v.vec .- w.vec)...)
⋅(v::Vector4D, w::Vector4D) = sum(v.vec .* w.vec)
dot(v::Vector4D, w::Vector4D) = v ⋅ w


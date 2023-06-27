
struct Vector4D{T<:Real} <: AbstractVector4D{T}
    x::T
    y::T
    z::T
    w::T
end

Vector4D(x::Real, y::Real, z::Real, w::Real) = Vector4D(promote(x, y, z, w)...)

get_x(v::Vector4D) = v.x
get_y(v::Vector4D) = v.y
get_z(v::Vector4D) = v.z
get_w(v::Vector4D) = v.w


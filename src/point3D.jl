struct Point3D{T<:Real} <: AbstractVector4D{T}
    vec::SVector{4,T}

    function Point3D(x::Real, y::Real, z::Real)
        T = promote_type(eltype(x), eltype(y), eltype(z))
        vec = SVector{4,T}(promote(x, y, z, one(T))...)
        new{T}(vec)
    end
end

internal_vec(p::Point3D) = p.vec

get_x(p::Point3D) = internal_vec(p)[1]
get_y(p::Point3D) = internal_vec(p)[2]
get_z(p::Point3D) = internal_vec(p)[3]
get_w(p::Point3D) = internal_vec(p)[4]



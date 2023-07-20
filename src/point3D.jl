struct Point3D{T<:Number} <: AbstractVector4D{T}
    vec::SVector{4,T}

    function Point3D(e032::Number, e013::Number, e021::Number)
        T = promote_type(eltype(e032), eltype(e013), eltype(e021))
        vec = SVector{4,T}(promote(e032, e013, e021, one(T))...)
        new{T}(vec)
    end

    function Point3D(e032::Number, e013::Number, e021::Number, e123::Number)
        T = promote_type(eltype(e032), eltype(e013), eltype(e021), eltype(e123))
        vec = SVector{4,T}(promote(e032, e013, e021, e123)...)
        new{T}(vec)
    end

    function Point3D(vec::SVector{4,T}) where {T<:Number}
        new{T}(vec)
    end

    function Point3D(vec::SVector{3,T}) where {T<:Number}
        new{T}(SA[vec[1], vec[2], vec[3], one(T)])
    end
end

internal_vec(p::Point3D) = p.vec


get_e032(p::Point3D) = p[1]
get_e013(p::Point3D) = p[2]
get_e021(p::Point3D) = p[3]
get_e123(p::Point3D) = p[4]

Base.:(+)(a::Point3D, b::Point3D) = Point3D((internal_vec(a) .+ internal_vec(b)))
Base.:(-)(a::Point3D, b::Point3D) = Point3D((internal_vec(a) .- internal_vec(b)))
Base.:(-)(a::Point3D) = Point3D(-internal_vec(a))
Base.:(*)(a::Point3D, b::Real) = Point3D((internal_vec(a) .* b))
Base.:(*)(a::Real, b::Point3D) = Point3D((a .* internal_vec(b)))


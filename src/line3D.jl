struct Line3D{T<:Real} <: AbstractPGA3DElement{T}
    vec::SVector{6,T}

    function Line3D(vx::Real, vy::Real, vz::Real, mx::Real, my::Real, mz::Real)
        T = promote_type(eltype(vx), eltype(vy), eltype(vz), eltype(mx), eltype(my), eltype(mz))
        vec = SVector{6,T}(promote(vx, vy, vz, mx, my, mz)...)
        new{T}(vec)
    end

    function Line3D(vec::SVector{6,T}) where {T<:Real}
        new{T}(vec)
    end
end

internal_vec(a::Line3D) = a.vec
length(::Line3D) = 6
size(::Line3D) = (6,)

+(a::Line3D, b::Line3D) = Line3D((internal_vec(a) .+ internal_vec(b))...)
-(a::Line3D, b::Line3D) = Line3D((internal_vec(a) .- internal_vec(b))...)


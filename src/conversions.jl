# by default, disallow conversions between types unless we explicitly allow them
function Base.convert(T_to::Type{<:AbstractPGA3DElement}, from::T_from) where {T_from<:AbstractPGA3DElement}
    throw(error("Conversion not implemented from $(T_from) to $(T_to)."))
end

# convert a Vector3D to a Vector4D with a 0 in the w component
Base.convert(::Type{<:Vector4D{T}}, v::AbstractVector3D{T}) where {T<:Real} = Vector4D(internal_vec(v)..., zero(T))

# convert a Point3D to a Vector4D by essentially recasting
Base.convert(::Type{<:Vector4D{T}}, p::Point3D{T}) where {T<:Real} = Vector4D(internal_vec(p))

# convert a Vector4D to a Point3D by unitizing and recasting
Base.convert(::Type{<:Point3D{T}}, v::Vector4D{T}) where {T<:Real} = Point3D(internal_vec(unitize(v)))


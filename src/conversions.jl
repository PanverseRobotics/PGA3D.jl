# by default, disallow conversions between types unless we explicitly allow them
Base.convert(::Type{<:AbstractPGA3Element}, ::Type{<:AbstractPGA3Element}) = error("conversion not allowed")

# convert a Vector3D to a Vector4D with a 0 in the w component
convert(::Type{<:Vector4D{T}}, v::AbstractVector3D{T}) where {T<:Real} = Vector4D(internal_vec(v)..., zero(T))

# convert a Point3D to a Vector4D by essentially recasting
convert(::Type{<:Vector4D{T}}, p::Point3D{T}) where {T<:Real} = Vector4D(internal_vec(p)...)

# convert a Vector4D to a Point3D by unitizing and recasting
convert(::Type{<:Point3D{T}}, v::Vector4D{T}) where {T<:Real} = Point3D(internal_vec(unitize(v))...)


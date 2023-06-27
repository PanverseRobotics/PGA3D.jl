using PGA3D
using Test, SafeTestsets

@safetestset "PGA3D.jl" begin

    @safetestset "Point3D.jl" begin
        include("test_Point3D.jl")
    end
    @safetestset "Line3D.jl" begin
        include("test_Line3D.jl")
    end
    @safetestset "Motor3D.jl" begin
        include("test_Motor3D.jl")
    end

end

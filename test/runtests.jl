using Test, SafeTestsets, Logging, PrettyPrinting

@info "Starting tests"

fulltestset = @testset "PGA3D.jl" begin

    @safetestset "vector3D.jl" begin
        include("test_vector3D.jl")
    end
    @safetestset "vector4D.jl" begin
        include("test_vector4D.jl")
    end
    @safetestset "point3D.jl" begin
        include("test_point3D.jl")
    end
    @safetestset "line3D.jl" begin
        include("test_line3D.jl")
    end
    @safetestset "plane3D.jl" begin
        include("test_plane3D.jl")
    end
    @safetestset "motor3D.jl" begin
        include("test_motor3D.jl")
    end
    @safetestset "regressive_product.jl and outer_product.jl" begin
        include("test_regressive_outer_products.jl")
    end
    @safetestset "conversions.jl" begin
        include("test_conversions.jl")
    end
    @safetestset "transformations.jl" begin
        include("test_transformations.jl")
    end

end

@info "Testing finished executing."

#@info "Test Results:"
#@info pprint(fulltestset.results)
#@info "Done with runtest."

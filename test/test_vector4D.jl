using Test, SafeTestsets

@safetestset "Constructor" begin
    using Test, SafeTestsets

    @safetestset "Default Constructor" begin
        using PGA3D
        using Test, SafeTestsets

        @testset "Vector Int" begin
            vectorint = Vector4D(1, 2, 3, 4)
            @test vectorint isa Vector4D{Int}
            @test get_x(vectorint) === 1
            @test get_y(vectorint) === 2
            @test get_z(vectorint) === 3
            @test get_w(vectorint) === 4
        end

        @testset "Vector Double" begin
            vectordouble = Vector4D(1.0, 2.0, 3.0, 4.0)
            @test vectordouble isa Vector4D{Float64}
            @test get_x(vectordouble) === 1.0
            @test get_y(vectordouble) === 2.0
            @test get_z(vectordouble) === 3.0
            @test get_w(vectordouble) === 4.0
        end

        @testset "Vector Float" begin
            vectorfloat = Vector4D(1.0f0, 2.0f0, 3.0f0, 4.0f0)
            @test vectorfloat isa Vector4D{Float32}
            @test get_x(vectorfloat) === 1.0f0
            @test get_y(vectorfloat) === 2.0f0
            @test get_z(vectorfloat) === 3.0f0
            @test get_w(vectorfloat) === 4.0f0
        end

        @testset "Vector Promoted" begin
            vectorpromoted = Vector4D(1, 2.0f0, 3.0, 4.0)
            @test vectorpromoted isa Vector4D{Float64}
            @test get_x(vectorpromoted) === 1.0
            @test get_y(vectorpromoted) === 2.0
            @test get_z(vectorpromoted) === 3.0
            @test get_w(vectorpromoted) === 4.0
        end

    end

end
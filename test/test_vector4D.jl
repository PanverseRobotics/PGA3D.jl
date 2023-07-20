using Test, SafeTestsets, Logging, PrettyPrinting

@safetestset "Constructor" begin
    using Test, SafeTestsets, Logging, PrettyPrinting

    @safetestset "Default Constructor" begin
        using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra

        @testset "Vector4D Int" begin
            testvector = Vector4D(1, 2, 3, 4)
            @test testvector isa Vector4D{Int}
            @test get_e032(testvector) === 1
            @test get_e013(testvector) === 2
            @test get_e021(testvector) === 3
            @test get_e123(testvector) === 4
        end

        @testset "Vector4D Double" begin
            testvector = Vector4D(1.0, 2.0, 3.0, 4.0)
            @test testvector isa Vector4D{Float64}
            @test get_e032(testvector) === 1.0
            @test get_e013(testvector) === 2.0
            @test get_e021(testvector) === 3.0
            @test get_e123(testvector) === 4.0
        end

        @testset "Vector4D Float" begin
            testvector = Vector4D(1.0f0, 2.0f0, 3.0f0, 4.0f0)
            @test testvector isa Vector4D{Float32}
            @test get_e032(testvector) === 1.0f0
            @test get_e013(testvector) === 2.0f0
            @test get_e021(testvector) === 3.0f0
            @test get_e123(testvector) === 4.0f0
        end

        @testset "Vector4D Promoted" begin
            testvector = Vector4D(1, 2.0f0, 3.0, 4)
            @test testvector isa Vector4D{Float64}
            @test get_e032(testvector) === 1.0
            @test get_e013(testvector) === 2.0
            @test get_e021(testvector) === 3.0
            @test get_e123(testvector) === 4.0
        end

        @testset "Vector4D StaticArray" begin
            testvector = Vector4D(SA[1, 2.0f0, 3.0, 4])
            @test testvector isa Vector4D{Float64}
            @test get_e032(testvector) === 1.0
            @test get_e013(testvector) === 2.0
            @test get_e021(testvector) === 3.0
            @test get_e123(testvector) === 4.0
        end

    end

end
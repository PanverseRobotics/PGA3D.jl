using SafeTestsets, Test, Logging, PrettyPrinting

@safetestset "Constructor" begin
    using Test, SafeTestsets, Logging, PrettyPrinting

    @safetestset "Default Constructor" begin
        using PGA3D
        using Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays

        @testset "Motor Int" begin
            motorint = Motor3D(1, 2, 3, 4, 5, 6, 7, 8)
            @test motorint isa Motor3D{Int}
            @test get_vx(motorint) === 1
            @test get_vy(motorint) === 2
            @test get_vz(motorint) === 3
            @test get_vw(motorint) === 4
            @test get_mx(motorint) === 5
            @test get_my(motorint) === 6
            @test get_mz(motorint) === 7
            @test get_mw(motorint) === 8
        end

        @testset "Motor Double" begin
            motordouble = Motor3D(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0)
            @test motordouble isa Motor3D{Float64}
            @test get_vx(motordouble) === 1.0
            @test get_vy(motordouble) === 2.0
            @test get_vz(motordouble) === 3.0
            @test get_vw(motordouble) === 4.0
            @test get_mx(motordouble) === 5.0
            @test get_my(motordouble) === 6.0
            @test get_mz(motordouble) === 7.0
            @test get_mw(motordouble) === 8.0
        end

        @testset "Motor Float" begin
            motorfloat = Motor3D(1.0f0, 2.0f0, 3.0f0, 4.0f0, 5.0f0, 6.0f0, 7.0f0, 8.0f0)
            @test motorfloat isa Motor3D{Float32}
            @test get_vx(motorfloat) === 1.0f0
            @test get_vy(motorfloat) === 2.0f0
            @test get_vz(motorfloat) === 3.0f0
            @test get_vw(motorfloat) === 4.0f0
            @test get_mx(motorfloat) === 5.0f0
            @test get_my(motorfloat) === 6.0f0
            @test get_mz(motorfloat) === 7.0f0
            @test get_mw(motorfloat) === 8.0f0
        end

        @testset "Motor Promoted" begin
            motorpromoted = Motor3D(1, 2.0, 3.0f0, 4.0, 5.0, 6.0, 7, 8.0f0)
            @test motorpromoted isa Motor3D{Float64}
            @test get_vx(motorpromoted) === 1.0
            @test get_vy(motorpromoted) === 2.0
            @test get_vz(motorpromoted) === 3.0
            @test get_vw(motorpromoted) === 4.0
            @test get_mx(motorpromoted) === 5.0
            @test get_my(motorpromoted) === 6.0
            @test get_mz(motorpromoted) === 7.0
            @test get_mw(motorpromoted) === 8.0
        end

        @testset "Motor StaticArray" begin
            motorstaticarray = Motor3D(SA[1, 2, 3, 4, 5, 6, 7, 8])
            @test motorstaticarray isa Motor3D{Int64}
            @test get_vx(motorstaticarray) === 1
            @test get_vy(motorstaticarray) === 2
            @test get_vz(motorstaticarray) === 3
            @test get_vw(motorstaticarray) === 4
            @test get_mx(motorstaticarray) === 5
            @test get_my(motorstaticarray) === 6
            @test get_mz(motorstaticarray) === 7
            @test get_mw(motorstaticarray) === 8
        end

        @testset "Motor Identity" begin
            motoridentity = identity_motor()
            @test motoridentity isa Motor3D{Int64}
            @test get_vx(motoridentity) === 0
            @test get_vy(motoridentity) === 0
            @test get_vz(motoridentity) === 0
            @test get_vw(motoridentity) === 1
            @test get_mx(motoridentity) === 0
            @test get_my(motoridentity) === 0
            @test get_mz(motoridentity) === 0
            @test get_mw(motoridentity) === 0
        end

    end
end

@safetestset "Operations" begin
    using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
    @safetestset "Multiplication" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        @safetestset "Motor Identity" begin
            using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
            motoridentity = identity_motor()
            for i in 1:100
                testfrom = Point3D(randn(3)...)
                testto = Point3D(randn(3)...)
                testline = line_fromto(testfrom, testto)
                testangle = randn()
                testdisp = randn()
                testmotor = motor_screw(testline, testangle, testdisp)

                @test testmotor * motoridentity ≈ testmotor
                @test motoridentity * testmotor ≈ testmotor
            end
        end

        @safetestset "Compare to transform matrix" begin
            using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
            motoridentity = identity_motor()
            for i in 1:100
                testfrom = Point3D(randn(3)...)
                testto = Point3D(randn(3)...)
                testline = line_fromto(testfrom, testto)
                testangle = rand() * 0.5
                testdisp = rand()
                testmotor = motor_screw(testline, testangle, testdisp)
                testmatrix, testmatrixinv = get_transform_and_inv_matrices(testmotor)

                testfrom2 = Point3D(randn(3)...)
                testto2 = Point3D(randn(3)...)
                testline2 = line_fromto(testfrom2, testto2)
                testangle2 = rand() * 0.5
                testdisp2 = rand()
                testmotor2 = motor_screw(testline2, testangle2, testdisp2)
                testmatrix2, testmatrixinv2 = get_transform_and_inv_matrices(testmotor2)

                # test that matrix multiplication and inversion are the same as motor multiplication and reversion, respectively
                @test testmatrix * testmatrix2 ≈ get_transform_matrix(testmotor * testmotor2)
                @test testmatrix * testmatrixinv2 ≈ get_transform_matrix(testmotor * PGA3D.reverse(testmotor2))
                @test testmatrixinv * testmatrix2 ≈ get_transform_matrix(PGA3D.reverse(testmotor) * testmotor2)
                @test testmatrixinv * testmatrixinv2 ≈ get_transform_matrix(PGA3D.reverse(testmotor) * PGA3D.reverse(testmotor2))

                # test that motor reverse is motor inverse for unitized motors
                @test motoridentity ≈ testmotor * PGA3D.reverse(testmotor)
                @test motoridentity ≈ PGA3D.reverse(testmotor) * testmotor

            end
        end
    end
    @safetestset "Normalization" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        for i in 1:1000
            testfrom = Point3D(randn(3)...)
            testto = Point3D(randn(3)...)
            testline = line_fromto(testfrom, testto)
            testangle = rand() * 0.5
            testdisp = rand()
            testmotor = motor_screw(testline, testangle, testdisp)

            testmotornormed = normalize(testmotor)
            @test isapprox(weight_norm(testmotornormed), 1.0; atol=0.0001)
            #@info testmotornormed
            #@test isapprox(dot(testmotornormed[1:4], testmotornormed[5:8]), 0.0; atol=0.0001)
        end

    end
end
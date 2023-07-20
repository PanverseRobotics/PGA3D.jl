using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra, IterTools

@safetestset "Constructor" begin
    using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra, IterTools

    @safetestset "Default Constructor" begin
        using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra, IterTools

        @testset "Motor Int" begin
            testmotor = Motor3D(1, 2, 3, 4, 5, 6, 7, 8)
            @test testmotor isa Motor3D{Int}
            @test get_scalar(testmotor) === 1
            @test get_e23(testmotor) === 2
            @test get_e31(testmotor) === 3
            @test get_e12(testmotor) === 4
            @test get_e01(testmotor) === 5
            @test get_e02(testmotor) === 6
            @test get_e03(testmotor) === 7
            @test get_e0123(testmotor) === 8
        end

        @testset "Motor Double" begin
            testmotor = Motor3D(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0)
            @test testmotor isa Motor3D{Float64}
            @test get_scalar(testmotor) === 1.0
            @test get_e23(testmotor) === 2.0
            @test get_e31(testmotor) === 3.0
            @test get_e12(testmotor) === 4.0
            @test get_e01(testmotor) === 5.0
            @test get_e02(testmotor) === 6.0
            @test get_e03(testmotor) === 7.0
            @test get_e0123(testmotor) === 8.0
        end

        @testset "Motor Float" begin
            testmotor = Motor3D(1.0f0, 2.0f0, 3.0f0, 4.0f0, 5.0f0, 6.0f0, 7.0f0, 8.0f0)
            @test testmotor isa Motor3D{Float32}
            @test get_scalar(testmotor) === 1.0f0
            @test get_e23(testmotor) === 2.0f0
            @test get_e31(testmotor) === 3.0f0
            @test get_e12(testmotor) === 4.0f0
            @test get_e01(testmotor) === 5.0f0
            @test get_e02(testmotor) === 6.0f0
            @test get_e03(testmotor) === 7.0f0
            @test get_e0123(testmotor) === 8.0f0
        end

        @testset "Motor Promoted" begin
            testmotor = Motor3D(1, 2.0, 3.0f0, 4.0, 5.0, 6.0, 7, 8.0f0)
            @test testmotor isa Motor3D{Float64}
            @test get_scalar(testmotor) === 1.0
            @test get_e23(testmotor) === 2.0
            @test get_e31(testmotor) === 3.0
            @test get_e12(testmotor) === 4.0
            @test get_e01(testmotor) === 5.0
            @test get_e02(testmotor) === 6.0
            @test get_e03(testmotor) === 7.0
            @test get_e0123(testmotor) === 8.0
        end

        @testset "Motor StaticArray" begin
            testmotor = Motor3D(SA[1, 2, 3, 4, 5, 6, 7, 8])
            @test testmotor isa Motor3D{Int64}
            @test get_scalar(testmotor) === 1
            @test get_e23(testmotor) === 2
            @test get_e31(testmotor) === 3
            @test get_e12(testmotor) === 4
            @test get_e01(testmotor) === 5
            @test get_e02(testmotor) === 6
            @test get_e03(testmotor) === 7
            @test get_e0123(testmotor) === 8
        end

        @testset "Motor Identity" begin
            testmotor = identity_motor()
            @test testmotor isa Motor3D{Int64}
            @test get_scalar(testmotor) === 1
            @test get_e23(testmotor) === 0
            @test get_e31(testmotor) === 0
            @test get_e12(testmotor) === 0
            @test get_e01(testmotor) === 0
            @test get_e02(testmotor) === 0
            @test get_e03(testmotor) === 0
            @test get_e0123(testmotor) === 0
        end

    end
end

@safetestset "Operations" begin
    using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra, IterTools

    @safetestset "Normalization" begin
        using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra, IterTools
        Random.seed!(1)
        special_motor_test_list = PGA3D.special_motors
        for i in 1:1000
            testmotor = if i <= length(special_motor_test_list)
                special_motor_test_list[i]
            else
                Motor3D(randn(8)...)
            end

            tmwn = testmotor[1:4] ⋅ testmotor[1:4]
            if tmwn ≈ 0 || tmwn < 0
                try
                    normalize(testmotor)
                catch e
                    @test isa(e, DomainError)
                    @test isa(e.val, Motor3D)
                    @test e.msg == "Motor3D must have a non-zero rotational part to normalize."
                end
            else
                testmotornormed = normalize(testmotor)
                atol = 1e-6
                @test isapprox(weight_norm(testmotornormed), 1.0; atol=atol)
                testmotornormedsq = testmotornormed * PGA3D.reverse(testmotornormed)
                @test isapprox(testmotornormedsq, identity_motor(); atol=atol)
                #@test get_transform_matrix(testmotor) ≈ get_transform_matrix(testmotornormed)
                testmotorsq = testmotor * PGA3D.reverse(testmotor)

                # test against the cheat sheet formula for normalizing that's inefficient
                m = testmotor
                mmrev = m * PGA3D.reverse(m)
                s, t = mmrev[1], mmrev[8]
                s2 = sqrt(s)
                study_inv_sqrt = Motor3D(1 / s2, 0, 0, 0, 0, 0, 0, -t / (2 * s2^3))
                new_normed = m * study_inv_sqrt
                @test isapprox(new_normed, testmotornormed; atol=atol)
                @test isapprox(new_normed * PGA3D.reverse(new_normed), identity_motor(); atol=atol)
            end
        end

    end

    @safetestset "Multiplication" begin
        using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra, IterTools
        @safetestset "Motor Identity" begin
            using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra, IterTools
            motoridentity = identity_motor()
            special_motor_test_list = PGA3D.special_motors
            Random.seed!(1)
            for i in 1:1000
                testmotor = if i <= length(special_motor_test_list)
                    special_motor_test_list[i]
                else
                    Motor3D(randn(8)...)
                end

                @test testmotor * motoridentity ≈ testmotor
                @test motoridentity * testmotor ≈ testmotor
            end
        end

        @safetestset "Motor Sqrt" begin
            using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra, IterTools
            special_motor_test_list = PGA3D.special_motors
            Random.seed!(1)
            atol = 1e-10
            for i in 1:1000
                testmotor = if i <= length(special_motor_test_list)
                    special_motor_test_list[i]
                else
                    Motor3D(randn(8)...)
                end
                tmwn = testmotor[1:4] ⋅ testmotor[1:4]
                if tmwn ≈ 0 || tmwn < 0
                    try
                        normalize(testmotor)
                    catch e
                        @test isa(e, DomainError)
                        @test isa(e.val, Motor3D)
                        @test e.msg == "Motor3D must have a non-zero rotational part to normalize."
                    end
                else
                    testmotor = normalize(testmotor)
                    testmotorsqrt = sqrt(testmotor)
                    @test isapprox(testmotorsqrt * testmotorsqrt, testmotor; atol=atol) || isapprox(testmotorsqrt * testmotorsqrt, -testmotor; atol=atol)
                end
            end
        end

        @safetestset "Compare to transform matrix" begin
            using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra, IterTools
            motoridentity = identity_motor()
            special_motor_test_list = collect(Iterators.product(PGA3D.special_motors, PGA3D.special_motors))
            Random.seed!(1)
            for i in 1:1000
                (; testmotorprenorm, testmotorprenorm2) = if i <= length(special_motor_test_list)
                    testmotorprenorm = special_motor_test_list[i][1]
                    testmotorprenorm2 = special_motor_test_list[i][2]
                    (; testmotorprenorm, testmotorprenorm2)
                else
                    testmotorprenorm = Motor3D(randn(8)...)
                    testmotorprenorm2 = Motor3D(randn(8)...)
                    (; testmotorprenorm, testmotorprenorm2)
                end

                (; testmotor, testmotor2) = try
                    testmotor = normalize(testmotorprenorm)
                    testmotor2 = normalize(testmotorprenorm2)
                    (; testmotor, testmotor2)
                catch e
                    @test isa(e, DomainError)
                    @test isa(e.val, Motor3D)
                    @test e.msg == "Motor3D must have a non-zero rotational part to normalize."
                    continue
                end

                testmatrix, testmatrixinv = get_transform_and_inv_matrices(testmotor)
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
end
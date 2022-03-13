include("WildBootTests.jl")

using StatFiles, StatsModels, DataFrames, DataFramesMeta, BenchmarkTools, Plots, CategoricalArrays, Random, StableRNGs
df = DataFrame(load(raw"d:\OneDrive\Documents\Macros\nlsw88.dta"))
df = df[:, [:wage, :ttl_exp, :collgrad, :tenure, :age, :industry, :occupation, :hours]]
dropmissing!(df)
f = @formula(wage ~ ttl_exp + collgrad + tenure)  # constant unneeded in FE model
f = apply_schema(f, schema(f, df))
resp, predexog = modelcols(f, df)
test

# using JLD
# @load "C:/Users/drood/Downloads/tmp.jld"
# test=WildBootTests.wildboottest(Main.Float64, R, r, resp=Ynames, predexog=Xnames_exog, predendog=Xnames_endog, inst=ZExclnames, obswt=wtname, clustid=allclustvars, feid=FEname, scores=scnames, R1=R1, r1=r1, nbootclustvar=1, nerrclustvar=1, issorted=true, hetrobust=Bool(1), fedfadj=Bool(1), fweights = ""=="fweight", maxmatsize=0, ptype="symmetric", bootstrapc = "t"=="c", LIML=Bool(1), Fuller=0,  ARubin=Bool(0), small=Bool(0), scorebs=Bool(0), reps=9, imposenull=Bool(1), level=95/100, auxwttype="rademacher", rtol=1.00000000000e-06, madjtype="none", NH0=1, ML=Bool(0), beta=b', A=V, gridmin=gridminvec, gridmax=gridmaxvec, gridpoints=gridpointsvec, diststat = "nodist", getCI = false, getplot = false, getauxweights = ""!="");println(test.b, test.V)
# test=WildBootTests.wildboottest(Main.Float64, R, r, resp=Ynames, predexog=Xnames_exog, predendog=Xnames_endog, inst=ZExclnames, obswt=wtname, clustid=allclustvars, feid=FEname, scores=scnames, R1=R1, r1=r1, nbootclustvar=1, nerrclustvar=1, issorted=true, hetrobust=Bool(1), fedfadj=Bool(1), fweights = ""=="fweight", maxmatsize=0, ptype="symmetric", bootstrapc = "t"=="c", LIML=Bool(1), Fuller=0,  ARubin=Bool(0), small=Bool(0), scorebs=Bool(0), reps=9, imposenull=Bool(1), level=95/100, auxwttype="rademacher", rtol=1.00000000000e-06, madjtype="none", NH0=1, ML=Bool(0), beta=b', A=V, gridmin=gridminvec, gridmax=gridmaxvec, gridpoints=gridpointsvec, diststat = "nodist", getCI = false, getplot = false, getauxweights = ""!="");println(test.b, test.V)
# test=WildBootTests.wildboottest(Main.Float64, R, r, resp=Ynames, predexog=Xnames_exog, predendog=Xnames_endog, inst=ZExclnames, obswt=wtname, clustid=allclustvars, feid=FEname, scores=scnames, R1=R1, r1=r1, nbootclustvar=1, nerrclustvar=1, issorted=true, hetrobust=Bool(1), fedfadj=Bool(1), fweights = ""=="fweight", maxmatsize=0, ptype="symmetric", bootstrapc = "t"=="c", LIML=Bool(1), Fuller=0,  ARubin=Bool(0), small=Bool(0), scorebs=Bool(0), reps=9, imposenull=Bool(1), level=95/100, auxwttype="rademacher", rtol=1.00000000000e-06, madjtype="none", NH0=1, ML=Bool(0), beta=b', A=V, gridmin=gridminvec, gridmax=gridmaxvec, gridpoints=gridpointsvec, diststat = "nodist", getCI = false, getplot = false, getauxweights = ""!="");println(test.b, test.V)
# test=WildBootTests.wildboottest(Main.Float64, R, r, resp=Ynames, predexog=Xnames_exog, predendog=Xnames_endog, inst=ZExclnames, obswt=wtname, clustid=allclustvars, feid=FEname, scores=scnames, R1=R1, r1=r1, nbootclustvar=1, nerrclustvar=1, issorted=true, hetrobust=Bool(1), fedfadj=Bool(1), fweights = ""=="fweight", maxmatsize=0, ptype="symmetric", bootstrapc = "t"=="c", LIML=Bool(1), Fuller=0,  ARubin=Bool(0), small=Bool(0), scorebs=Bool(0), reps=9, imposenull=Bool(1), level=95/100, auxwttype="rademacher", rtol=1.00000000000e-06, madjtype="none", NH0=1, ML=Bool(0), beta=b', A=V, gridmin=gridminvec, gridmax=gridmaxvec, gridpoints=gridpointsvec, diststat = "nodist", getCI = false, getplot = false, getauxweights = ""!="");println(test.b, test.V)



using StableRNGs, Random, BenchmarkTools
# N=1_00_000; G=40; k=2; l=4
# Random.seed!(1231)
# β=rand(); γ=rand(k); Π=rand(l)
# W = rand(N,l)
# u₂ = randn(N)
# y₂ = W * Π + u₂
# u₁ = u₂ + randn(N)
# Z = rand(N,k)
# y₁ = y₂ * β + Z * γ + u₁
# ID = floor.(Int8, collect(0:N-1) / (N/G))
# R = [zeros(1,k) 1]; r = [0]
# FEID = rand([1,2,3,4,5],N)
# test = WildBootTests.wildboottest(Float32, R, .36; R1 = [1 zeros(1,k)], r1=[0], resp=y₁, predexog=Z, predendog=y₂, inst=W, clustid=ID, reps=999, issorted=true, rng=StableRNG(1231), LIML=true, feid=FEID)
# test
# # # WildBootTests.wildboottest(Float64, R,#=.46=#.36; R1 = [1 zeros(1,k)], r1=[0], resp=y₁, predexog=Z, predendog=y₂, inst=W, clustid=ID, reps=999, issorted=true, rng=StableRNG(1231), LIML=true, feid=FEID)

N=1_000_000; G=40; k=12; l=40
Random.seed!(1231)
β=rand(); γ=rand(k); Π=rand(l)
W = rand(N,l)
u₂ = randn(N)
y₂ = W * Π + u₂
u₁ = u₂ + randn(N)
Z = rand(N,k)
y₁ = y₂ * β + Z * γ + u₁
ID = floor.(Int8, collect(0:N-1) / (N/G))
R = [zeros(1,k) 1]; r = [0]
WildBootTests.wildboottest(Float32, R,r; resp=y₁, predexog=Z, predendog=y₂, inst=W, clustid=ID, reps=9999, issorted=true, getCI=false)
WildBootTests.wildboottest(Float64, R,r; resp=y₁, predexog=Z, predendog=y₂, inst=W, clustid=ID, reps=9999, issorted=true, getCI=false)
@btime WildBootTests.wildboottest(Float32, R,r; resp=y₁, predexog=Z, predendog=y₂, inst=W, clustid=ID, reps=9999, issorted=true, getCI=false)
@btime WildBootTests.wildboottest(Float64, R,r; resp=y₁, predexog=Z, predendog=y₂, inst=W, clustid=ID, reps=9999, issorted=true, getCI=false)

# @btime WildBootTests.wildboottest(Float32, R,.4; resp=y₁, predexog=Z, predendog=y₂, inst=W, clustid=ID, reps=9999, issorted=true, getCI=true);
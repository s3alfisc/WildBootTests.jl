push!(LOAD_PATH, ".")
using WildBootTests
using StatFiles, StatsModels, DataFrames, DataFramesMeta, BenchmarkTools, Plots, CategoricalArrays, Random, StableRNGs

open("unittests.log", "w") do log  # use Github Desktop to detect changes in output

df = DataFrame(load(raw"d:\OneDrive\Documents\Macros\collapsed.dta"))
dropmissing!(df)
f = @formula(hasinsurance ~ 1 + selfemployed + post + post_self)
f = apply_schema(f, schema(f, df, Dict(:hasinsurance => ContinuousTerm)))
resp, predexog = modelcols(f, df)

println(log, "\nregress hasinsurance selfemployed post post_self, cluster(year)")
println(log, "\nboottest post_self=.04, weight(webb)")
test = wildboottest([0 0 0 1], [.04]; resp, predexog, clustid=Int32.(df.year), auxwttype=:webb, rng=StableRNG(1231))
println(log, test)

test = wildboottest([0 0 0 1], [.04]; resp, predexog, clustid=Int32.(df.year), auxwttype=:webb, rng=StableRNG(1231), issorted=true)
println(log, test)

println(log, "\nboottest post_self=.04, weight(webb) reps(9999999) noci")
test = wildboottest([0 0 0 1], [.04]; resp, predexog, clustid=Int32.(df.year), reps=9999999, auxwttype=:webb, getci=false, rng=StableRNG(1231))
println(log, test)

println(log, "\nboottest post_self=.04, weight(normal) reps(9999) noci")
test = wildboottest([0 0 0 1], [.04]; resp, predexog, clustid=Int32.(df.year), reps=9999, auxwttype=:normal, getci=false, rng=StableRNG(1231))
println(log, test)

println(log, "\nboottest post_self=.04, weight(gamma) reps(9999) noci svv")
test = wildboottest([0 0 0 1], [.04]; resp, predexog, clustid=Int32.(df.year), reps=9999, auxwttype=:gamma, getci=false, rng=StableRNG(1231), getauxweights=true)
println(log, test)

println(log, "\nboottest post_self=.04, weight(mammen) reps(9999) noci")
test = wildboottest([0 0 0 1], [.04]; resp, predexog, clustid=Int32.(df.year), reps=9999, auxwttype=:mammen, getci=false, rng=StableRNG(1231))
println(log, test)

println(log, "\nboottest post_self=.04, weight(mammen) reps(9999) boottype(score)")
test = wildboottest([0 0 0 1], [.04]; resp, predexog, clustid=Int32.(df.year), reps=9999, auxwttype=:mammen, scorebs=true, rng=StableRNG(1231))
println(log, test)

println(log, "\nregress hasinsurance selfemployed post post_self, robust")
println(log, "\nboottest post_self=.04, weight(webb)")
test = wildboottest([0 0 0 1], [.04]; resp, predexog, auxwttype=:webb, rng=StableRNG(1231))
println(log, test)

println(log, "\nregress hasinsurance selfemployed post post_self, cluster(year)")
println(log, "boottest (post_self=.05) (post=-.02), reps(9999) weight(webb)")
test = wildboottest([0 0 0 1; 0 0 1 0], [.05; -.02]; resp, predexog, clustid=Int32.(df.year), reps=9999, auxwttype=:webb, rng=StableRNG(1231))
println(log, test)

test = wildboottest([0 0 0 1; 0 0 1 0], [.05; -.02]; resp, predexog, clustid=Int32.(df.year), reps=9999, auxwttype=:webb, rng=StableRNG(1231), bootstrapc=true)
println(log, test)

println(log, "boottest (post_self=.05) (post=-.02) (selfemployed=-.15), reps(9999) weight(webb)")
test = wildboottest([0 0 0 1; 0 0 1 0; 0 1 0 0], [.05; -.02; -.15]; resp, predexog, clustid=Int32.(df.year), reps=9999, auxwttype=:webb, rng=StableRNG(1231))
println(log, test)

println(log, "\nregress hasinsurance selfemployed post post_self")
println(log, "\nboottest post_self=.04, weight(webb)")
test = wildboottest([0 0 0 1], [.04]               ; resp, predexog, hetrobust=false, auxwttype=:webb, rng=StableRNG(1231))
println(log, test)
println(log, "boottest (post_self=.05) (post=-.02), reps(999) weight(webb)")  # bad
test = wildboottest([0 0 0 1; 0 0 1 0], [.05; -.02]; resp, predexog, hetrobust=false, auxwttype=:webb, rng=StableRNG(1231))
println(log, test)
println(log, "scoretest (post_self=.05)")
test = wildboottest([0 0 0 1], [.05]; resp, predexog, hetrobust=false, scorebs=true, reps=0)
println(log, test)
println(log, "scoretest (post_self=.05) (post=-.02)")
test = wildboottest([0 0 0 1; 0 0 1 0], [.05; -.02]; resp, predexog, hetrobust=false, scorebs=true, reps=0)
println(log, test)
println(log, "boottest (post_self=.08), boottype(score)")
test = wildboottest([0 0 0 1], [.08]; resp, predexog, hetrobust=false, scorebs=true, rng=StableRNG(1231))
println(log, test)
println(log, "boottest (post_self=.05) (post=-.02), boottype(score)")
test = wildboottest([0 0 0 1; 0 0 1 0], [.05; -.02]; resp, predexog, hetrobust=false, scorebs=true, rng=StableRNG(1231))
println(log, test)

df = DataFrame(load(raw"d:\OneDrive\Documents\Macros\nlsw88.dta"))[:,[:wage; :tenure; :ttl_exp; :collgrad; :industry]]
dropmissing!(df)
desc = describe(df, :eltype)
f = @formula(wage ~ 1 + tenure + ttl_exp + collgrad)
f = apply_schema(f, schema(f, df))
resp, predexog = modelcols(f, df)

println(log, "\nconstraint 1 ttl_exp = .2")
println(log, "cnsreg wage tenure ttl_exp collgrad, constr(1) cluster(industry)")
println(log, "boottest tenure")
test = wildboottest([0 1 0 0], [0]; R1=[0 0 1 0], r1=[.2], resp, predexog, clustid=df.industry, rng=StableRNG(1231))
println(log, test)

test = wildboottest([0 1 0 0], [0]; R1=[0 0 1 0], r1=[.2], resp, predexog, clustid=[collect(1:1000); collect(1:1217)], reps=9999, rng=StableRNG(1231))  # granular but not pure robust
println(log, test)

test = wildboottest([0 1 0 0], [0]; resp, predexog, clustid=[collect(1:1000); collect(1:1217)], feid=df.industry, reps=9999, rng=StableRNG(1231))
println(log, test)

println(log, "\nivregress liml wage ttl_exp collgrad (tenure = union), cluster(industry)")
println(log, "boottest tenure, ptype(equaltail) reps(9999)")

df = DataFrame(load(raw"d:\OneDrive\Documents\Macros\nlsw88.dta"))
df = df[:, [:wage; :tenure; :ttl_exp; :collgrad; :industry; :union]]
dropmissing!(df)
f = @formula(wage ~ 1 + ttl_exp + collgrad)
f = apply_schema(f, schema(f, df))
resp, predexog = modelcols(f, df)
ivf = @formula(tenure ~ union)
ivf = apply_schema(ivf, schema(ivf, df))
predendog, inst = modelcols(ivf, df)
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, small=false, reps=9999, ptype=:equaltail, rng=StableRNG(1231))
println(log, test)

println(log, "boottest tenure, nonull reps(9999) matsize(.1)")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, small=false, reps=99999, imposenull=false, rng=StableRNG(1231), maxmatsize=.1)
println(log, test)

println(log, "boottest tenure, ptype(upper) svmat(t) reps(9999)")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, small=false, reps=9999, ptype=:upper, diststat=:t, rng=StableRNG(1231))
println(log, test)

println(log, "boottest tenure, ptype(lower) svmat(numer) reps(9999)")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, small=false, reps=9999, ptype=:lower, diststat=:numer, rng=StableRNG(1231))
println(log, test)

println(log, "\nivregress liml wage ttl_exp collgrad (tenure = union), cluster(industry)")
println(log, "boottest tenure, ptype(equaltail) reps(9999)")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, small=false, liml=true, reps=9999, ptype=:equaltail, rng=StableRNG(1231))
println(log, test)

println(log, "\nivregress liml wage ttl_exp collgrad (tenure = union) if industry<., robust")
println(log, "boottest tenure, ptype(equaltail) reps(99) noci")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, small=false, liml=true, reps=99, ptype=:equaltail, getci=false, rng=StableRNG(1231))
println(log, test)

println(log, "\nivregress 2sls wage ttl_exp collgrad (tenure = union) if industry<., robust")
println(log, "boottest tenure, ptype(equaltail) reps(99) noci")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, small=false, reps=99, ptype=:equaltail, getci=false, rng=StableRNG(1231))
println(log, test)

println(log, "boottest collgrad tenure, ptype(equaltail) reps(99) noci")
test = wildboottest([0 0 0 1; 0 0 1 0], [0;0]; resp, predexog, predendog, inst, small=false, reps=99, ptype=:equaltail, getci=false, rng=StableRNG(1231))
println(log, test)

println(log, "\nivregress 2sls wage ttl_exp collgrad (tenure = union) if industry<.")
println(log, "boottest tenure, ptype(equaltail) reps(99) noci")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, hetrobust=false, small=false, reps=99, ptype=:equaltail, getci=false, rng=StableRNG(1231))
println(log, test)

println(log, "boottest tenure collgrad, ptype(equaltail) reps(99) noci")
test = wildboottest([0 0 0 1; 0 0 1 0], [0;0]; resp, predexog, predendog, inst, hetrobust=false, small=false, reps=99, ptype=:equaltail, getci=false, rng=StableRNG(1231))
println(log, test)

println(log, "\nivregress 2sls wage ttl_exp collgrad (tenure = union), cluster(industry)")
println(log, "\nboottest tenure, ptype(equaltail) weight(webb) stat(c) gridmin(-5) gridmax(5) gridpoints(100)")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, small=false, auxwttype=:webb, bootstrapc=true, ptype=:equaltail, rng=StableRNG(1231), gridmin=[-5], gridmax=[5], gridpoints=[100])
println(log, test)

println(log, "\nboottest tenure, ptype(equaltail) weight(webb) stat(c) gridmin(-5) gridmax(5) gridpoints(100) maxmatsize(.01)")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, small=false, auxwttype=:webb, bootstrapc=true, ptype=:equaltail, rng=StableRNG(1231), gridmin=[-5], gridmax=[5], gridpoints=[100], maxmatsize=.01)
println(log, test)

println(log, "\nivregress 2sls wage ttl_exp collgrad (tenure = union) if industry<., robust")
println(log, "\nboottest tenure, ptype(equaltail) maxmatsize(0.005) noci weight(webb) ptype(equaltail)")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, small=false, auxwttype=:webb, ptype=:equaltail, rng=StableRNG(1231), getci=false, maxmatsize=.005)
println(log, test)

test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=[collect(1:1000); collect(1:855)], small=false, auxwttype=:webb, ptype=:equaltail, getci=false, rng=StableRNG(1231), maxmatsize=.005)
println(log, test)

println(log, "\nivregress 2sls wage ttl_exp collgrad (tenure = union), cluster(industry)")
println(log, "\nboottest, ar")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, small=false, arubin=true, rng=StableRNG(1231))
println(log, test)
plot(plotpoints(test)...)

println(log, "\nboottest, ar nonull")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, small=false, arubin=true, rng=StableRNG(1231), imposenull=false)
println(log, test)

println(log, "\nscoretest tenure")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, small=false, reps=0)
println(log, test)

println(log, "\nwaldtest tenure, pytpe(upper)")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, small=false, reps=0, imposenull=false, getplot=false, ptype=:upper)
println(log, test)

println(log, "\nivregress liml wage (tenure = collgrad ttl_exp), cluster(industry)")
println(log, "boottest tenure")
df = DataFrame(load(raw"d:\OneDrive\Documents\Macros\nlsw88.dta"))
df = df[:, [:wage, :tenure, :ttl_exp, :collgrad, :industry]]
dropmissing!(df)
f = @formula(wage ~ 1)
f = apply_schema(f, schema(f, df))
resp, predexog = modelcols(f, df)
ivf = @formula(tenure ~ collgrad + ttl_exp)
ivf = apply_schema(ivf, schema(ivf, df))
predendog, inst = modelcols(ivf, df)
test = wildboottest([0 1], [0]; resp, predexog, predendog, inst, liml=true, clustid=df.industry, small=false, rng=StableRNG(1231))
println(log, test)

println(log, "\nivreg2 wage collgrad smsa race age (tenure = union married), cluster(industry) fuller(1)")
println(log, "boottest tenure, nograph weight(webb) reps(9999)")
df = DataFrame(load(raw"d:\OneDrive\Documents\Macros\nlsw88.dta"))
df = df[:, [:wage, :tenure, :ttl_exp, :collgrad, :smsa, :race, :age, :union, :married, :industry]]
dropmissing!(df)
f = @formula(wage ~ 1 + collgrad + smsa + race + age)
f = apply_schema(f, schema(f, df))
resp, predexog = modelcols(f, df)
ivf = @formula(tenure ~ union + married)
ivf = apply_schema(ivf, schema(ivf, df))
predendog, inst = modelcols(ivf, df)
test = wildboottest([0 0 0 0 0 1], [0]; resp, predexog, predendog, inst, fuller=1, clustid=df.industry, small=false, reps=9999, auxwttype=:webb, rng=StableRNG(1231))
println(log, test)

println(log, "boottest tenure, noci bootcluster(individual) weight(webb)")
test = wildboottest([0 0 0 0 0 1], [0]; resp, predexog, predendog, inst, fuller=1, clustid=[collect(1:nrow(df)) df.industry], nbootclustvar=1, nerrclustvar=1, small=false, auxwttype=:webb, getci=false, rng=StableRNG(1231))
println(log, test)

println(log, "boottest tenure, nograph bootcluster(collgrad) cluster(collgrad industry) weight(webb) reps(9999)")
test = wildboottest([0 0 0 0 0 1], [0]; resp, predexog, predendog, inst, fuller=1, clustid=clustid=Matrix(df[:, [:collgrad, :industry]]), nbootclustvar=1, nerrclustvar=2, small=false, reps=9999, auxwttype=:webb, rng=StableRNG(1231))
println(log, test)

println(log, "\nareg wage ttl_exp collgrad tenure [aw=hours] if occupation<., cluster(age) absorb(industry)")
println(log, "boottest tenure, cluster(age occupation) bootcluster(occupation)")
df = DataFrame(load(raw"d:\OneDrive\Documents\Macros\nlsw88.dta"))
dropmissing!(df)
f = @formula(wage ~ ttl_exp + collgrad + tenure)  # constant unneeded in FE model
f = apply_schema(f, schema(f, df))
resp, predexog = modelcols(f, df)
test = wildboottest([0 0 1], [0]; resp, predexog, clustid=Matrix(df[:, [:occupation, :age]]), nbootclustvar=1, nerrclustvar=2, obswt=df.hours, feid=df.industry, rng=StableRNG(1231))
println(log, test)

println(log, "\nareg wage ttl_exp collgrad tenure if occupation<., robust absorb(industry)")
println(log, "boottest tenure")
test = wildboottest([0 0 1], [0]; resp, predexog, feid=df.industry, rng=StableRNG(1231))
println(log, test)

println(log, "\nareg wage ttl_exp collgrad tenure [aw=hours] if occupation<., robust absorb(industry)")
println(log, "boottest tenure")
test = wildboottest([0 0 1], [0]; resp, predexog, obswt=df.hours, feid=df.industry, rng=StableRNG(1231))
println(log, test)

println(log, "\nivreghdfe wage ttl_exp collgrad tenure (occupation = union married) [aw=hours], liml cluster(industry) absorb(industry)")
ivf = @formula(occupation ~ union + married)
ivf = apply_schema(ivf, schema(ivf, df))
predendog, inst = modelcols(ivf, df)
println(log, "boottest tenure")
test = wildboottest([0 0 1 0], [0]; resp, predexog, predendog, inst, clustid=df.industry, obswt=df.hours, feid=df.industry, fedfadj=1, rng=StableRNG(1231), liml=true)
println(log, test)
println(log, "boottest occupation")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, obswt=df.hours, feid=df.industry, fedfadj=1, rng=StableRNG(1231), liml=true)
println(log, test)

println(log, "\nivreghdfe wage ttl_exp collgrad tenure (occupation = union married) [aw=hours] if grade<., liml cluster(industry) absorb(age)")
println(log, "boottest tenure")
test = wildboottest([0 0 1 0], [0]; resp, predexog, predendog, inst, clustid=df.industry, obswt=df.hours, feid=df.age, rng=StableRNG(1231), liml=true)
println(log, test)
println(log, "boottest collgrad tenure")
test = wildboottest([0 0 1 0; 0 1 0 0], [0; 0]; resp, predexog, predendog, inst, clustid=df.industry, obswt=df.hours, feid=df.age, rng=StableRNG(1231), liml=true, reps=99)
println(log, test)
println(log, "boottest occupation")
test = wildboottest([0 0 0 1], [0]; resp, predexog, predendog, inst, clustid=df.industry, obswt=df.hours, feid=df.age, rng=StableRNG(1231), liml=true, gridmin=[-1], gridmax=[1])
println(log, test)

println(log, "boottest tenure | _b[collgrad] = 0")
test = wildboottest([0 0 1 0], [0]; R1=[0 1 0 0], r1=[0], resp, predexog                  , predendog, inst                     , clustid=df.industry, obswt=df.hours, feid=df.age, rng=StableRNG(1231), liml=true, gridmin=[-1], gridmax=[1])
println(log, test)
test = wildboottest([0 1 0], [0];                         resp, predexog=predexog[:,[1,3]], predendog, inst=[inst predexog[:,2]], clustid=df.industry, obswt=df.hours, feid=df.age, rng=StableRNG(1231), liml=true, gridmin=[-1], gridmax=[1])
println(log, test)

df = DataFrame(load(raw"d:\OneDrive\Documents\Macros\abdata.dta"))[:,[:n; :w; :k; :ys; :id; :year; :ind]]
dropmissing!(df)
f = @formula(n ~ w + k)  # constant unneeded in FE model
f = apply_schema(f, schema(f, df))
resp, predexog = modelcols(f, df)
println(log, "\nareg n w k, absorb(ind)")
println(log, "\nboottest k, cluster(id year)")
test = WildBootTests.wildboottest([0 1], [0]; resp, predexog, clustid=round.(Int,Matrix(df[:, [:id, :year]])), nbootclustvar=2, nerrclustvar=2, feid=round.(Int,df.ind), rng=StableRNG(1231))
println(log, test)
println(log, "\nareg n w k [aw=ys], absorb(ind)")
println(log, "\nboottest k, cluster(id year)")
test = WildBootTests.wildboottest([0 1], [0]; resp, predexog, clustid=round.(Int,Matrix(df[:, [:id, :year]])), nbootclustvar=2, nerrclustvar=2, feid=round.(Int,df.ind), rng=StableRNG(1231), obswt=df.ys)
println(log, test)

println(log, "\nglobal pix lnkm pixpetro pixdia pixwaterd pixcapdist pixmal pixsead pixsuit pixelev pixbdist")
println(log, "global geo lnwaterkm lnkm2split mean_elev mean_suit malariasuit petroleum diamondd")
println(log, "global poly capdistance1 seadist1 borderdist1")
println(log, "encode pixwbcode, gen(ccode)  // make numerical country identifier")
println(log, "qui areg lnl0708s centr_tribe lnpd0 \$pix \$geo \$poly, absorb(ccode)")
println(log, "boottest centr_tribe, nogr reps(9999) clust(ccode pixcluster) bootcluster(ccode)")
println(log, "boottest centr_tribe, nogr reps(9999) clust(ccode pixcluster) bootcluster(pixcluster)")
println(log, "boottest centr_tribe, nogr reps(9999) clust(ccode pixcluster) bootcluster(ccode pixcluster)")
df = DataFrame(load(raw"d:\OneDrive\Documents\Work\Econometrics\Wild cluster\pixel-level-baseline-final.dta"))
pix  = [:lnkm, :pixpetro, :pixdia, :pixwaterd, :pixcapdist, :pixmal, :pixsead, :pixsuit, :pixelev, :pixbdist]
geo  = [:lnwaterkm, :lnkm2split, :mean_elev, :mean_suit, :malariasuit, :petroleum, :diamondd]
poly = [:capdistance1, :seadist1, :borderdist1]
df = df[:,[pix; geo; poly; :lnl0708s; :centr_tribe; :lnpd0; :pixwbcode; :pixcluster]]
dropmissing!(df)
df.ccode = levelcode.(categorical(df.pixwbcode, compress=true))
df.pixcode = levelcode.(categorical(df.pixcluster, compress=true))
f = Term(:lnl0708s) ~ sum(term.([:centr_tribe; :lnpd0; pix; geo; poly]))
f = apply_schema(f, schema(f, df))
resp, predexog = modelcols(f, df)

test = wildboottest([1 zeros(1,size(predexog,2)-1)], [0]; resp, predexog, clustid=Matrix(df[:, [:ccode, :pixcode]]), nbootclustvar=1, nerrclustvar=2, feid=df.ccode, reps=9999, rng=StableRNG(1231))
println(log, test)
test = wildboottest([1 zeros(1,size(predexog,2)-1)], [0]; resp, predexog, clustid=Matrix(df[:, [:pixcode, :ccode]]), nbootclustvar=1, nerrclustvar=2, feid=df.ccode, reps=9999, rng=StableRNG(1231))
println(log, test)
test = wildboottest([1 zeros(1,size(predexog,2)-1)], [0]; resp, predexog, clustid=Matrix(df[:, [:pixcode, :ccode]]), nbootclustvar=2, nerrclustvar=2, feid=df.ccode, reps=9999, rng=StableRNG(1231))
println(log, test)


println(log, "\ninfile coll merit male black asian year state chst using regm.raw, clear")
println(log, "qui regress coll merit male black asian i.year i.state if !inlist(state,34,57,59,61,64,71,72,85,88), cluster(state)	")
println(log, "generate individual = _n  // unique ID for each observation")
println(log, "boottest merit, nogr reps(9999) gridpoints(10)  // defaults to bootcluster(state)")
println(log, "boottest merit, nogr reps(9999) gridpoints(10) nonull")
println(log, "boottest merit, nogr reps(9999) gridpoints(10) bootcluster(state year)")
println(log, "boottest merit, nogr reps(9999) gridpoints(10) nonull bootcluster(state year)")
println(log, "boottest merit, nogr reps(9999) gridpoints(10) bootcluster(individual)")
println(log, "boottest merit, nogr reps(9999) gridpoints(10) nonull bootcluster(individual)")
println(log, "boottest merit, nogr reps(9999) gridpoints(10) nonull bootcluster(individual) maxmatsize(.1)")
df = DataFrame(load(raw"d:\OneDrive\Documents\Work\Econometrics\Wild cluster\regm.dta"))
df = DataFrame(coll=Bool.(df.coll), merit=Bool.(df.merit), male=Bool.(df.male), black=Bool.(df.black), asian=Bool.(df.asian), state=categorical(Int8.(df.state)), year=categorical(Int16.(df.year)))
dropmissing!(df)
df = df[df.state .∉ Ref([34,57,59,61,64,71,72,85,88]),:]
f = @formula(coll ~ 1 + merit + male + black + asian + year + state)
f = apply_schema(f, schema(f, df))
resp, predexog = modelcols(f, df)

test = wildboottest([0 1 zeros(1,size(predexog,2)-2)], [0]; resp, predexog, clustid=levelcode.(df.state), gridpoints=[10], reps=9999, rng=StableRNG(1231))
println(log, test)
test = wildboottest([0 1 zeros(1,size(predexog,2)-2)], [0]; resp, predexog, clustid=levelcode.(df.state), reps=9999, imposenull=false, rng=StableRNG(1231))
println(log, test)
test = wildboottest([0 1 zeros(1,size(predexog,2)-2)], [0]; resp, predexog, clustid=[levelcode.(df.year) levelcode.(df.state)], nbootclustvar=2, nerrclustvar=1, reps=9999, rng=StableRNG(1231))
println(log, test)
test = wildboottest([0 1 zeros(1,size(predexog,2)-2)], [0]; resp, predexog, clustid=[levelcode.(df.year) levelcode.(df.state)], nbootclustvar=2, nerrclustvar=1, reps=9999, imposenull=false, rng=StableRNG(1231))
println(log, test)
test = wildboottest([0 1 zeros(1,size(predexog,2)-2)], [0]; resp, predexog, clustid= [collect(1:nrow(df)) levelcode.(df.state)], nbootclustvar=1, nerrclustvar=1, reps=9999, rng=StableRNG(1231))
println(log, test)
test = wildboottest([0 1 zeros(1,size(predexog,2)-2)], [0]; resp, predexog, clustid= [collect(1:nrow(df)) levelcode.(df.state)], nbootclustvar=1, nerrclustvar=1, reps=9999, imposenull=false, rng=StableRNG(1231))
println(log, test)
test = wildboottest([0 1 zeros(1,size(predexog,2)-2)], [0]; resp, predexog, clustid= [collect(1:nrow(df)) levelcode.(df.state)], nbootclustvar=1, nerrclustvar=1, reps=9999, imposenull=false, maxmatsize=.1, rng=StableRNG(1231))
println(log, test)
end
Q = Matrix{Float32}(undef, 40, 40)
A = Matrix{Float32}(undef, 40, 100_00)
B = Matrix{Float32}(undef, 40, 100_00)
X = Matrix{Float32}(undef, 3, 100_00)
row = 2

using LoopVectorization,ArrayInterface

var"###looprangei###1###" = LoopVectorization.canonicalize_range(begin
# $(Expr(:inbounds, true))
local var"#854#val" = LoopVectorization.axes(A, static(2))
# $(Expr(:inbounds, :pop))
var"#854#val"
end)
var"###loopleni###2###" = ArrayInterface.static_length(var"###looprangei###1###")
var"###i_loop_lower_bound###3###" = LoopVectorization.maybestaticfirst(var"###looprangei###1###")
var"###i_loop_upper_bound###4###" = LoopVectorization.maybestaticlast(var"###looprangei###1###")
var"###looprangej###5###" = LoopVectorization.canonicalize_range(begin
# $(Expr(:inbounds, true))
local var"#855#val" = LoopVectorization.axes(A, static(1))
# $(Expr(:inbounds, :pop))
var"#855#val"
end)
var"###looplenj###6###" = ArrayInterface.static_length(var"###looprangej###5###")
var"###j_loop_lower_bound###7###" = LoopVectorization.maybestaticfirst(var"###looprangej###5###")
var"###j_loop_upper_bound###8###" = LoopVectorization.maybestaticlast(var"###looprangej###5###")
var"###looprangek###9###" = LoopVectorization.canonicalize_range(begin
# $(Expr(:inbounds, true))
local var"#856#val" = LoopVectorization.axes(A, static(1))
# $(Expr(:inbounds, :pop))
var"#856#val"
end)
var"###looplenk###10###" = ArrayInterface.static_length(var"###looprangek###9###")
var"###k_loop_lower_bound###11###" = LoopVectorization.maybestaticfirst(var"###looprangek###9###")
var"###k_loop_upper_bound###12###" = LoopVectorization.maybestaticlast(var"###looprangek###9###")
(var"##vptr##_X", var"#X#preserve#buffer#") = LoopVectorization.stridedpointer_preserve(X)
var"##vptr##_X_##subset##_1_##with##_row_##" = LoopVectorization.subsetview(var"##vptr##_X", static(1), row)
(var"##vptr##_A", var"#A#preserve#buffer#") = LoopVectorization.stridedpointer_preserve(A)
(var"##vptr##_Q", var"#Q#preserve#buffer#") = LoopVectorization.stridedpointer_preserve(Q)
(var"##vptr##_B", var"#B#preserve#buffer#") = LoopVectorization.stridedpointer_preserve(B)
var"##vptr##_X_##subset##_1_##with##_row_##" = LoopVectorization.subsetview(var"##vptr##_X", static(1), row)
var"####grouped#strided#pointer####20###" = Core.getfield(LoopVectorization.grouped_strided_pointer((LoopVectorization.densewrapper(LoopVectorization.gespf1(var"##vptr##_A", (var"###j_loop_lower_bound###7###", var"###i_loop_lower_bound###3###")), A), LoopVectorization.densewrapper(LoopVectorization.gespf1(var"##vptr##_Q", (var"###k_loop_lower_bound###11###", var"###j_loop_lower_bound###7###")), Q), LoopVectorization.densewrapper(LoopVectorization.gespf1(var"##vptr##_B", (var"###k_loop_lower_bound###11###", var"###i_loop_lower_bound###3###")), B), LoopVectorization.densewrapper(LoopVectorization.gespf1(var"##vptr##_X_##subset##_1_##with##_row_##", (var"###i_loop_lower_bound###3###",)), X)), Val{()}()), 1)
#=$(Expr(:gc_preserve, quote=#
var"##vargsym#571" = ((LoopVectorization.zerorangestart(var"###looprangei###1###"), LoopVectorization.zerorangestart(var"###looprangej###5###"), LoopVectorization.zerorangestart(var"###looprangek###9###")), (var"####grouped#strided#pointer####20###",))
var"##Tloopeltype##" = LoopVectorization.promote_type(LoopVectorization.eltype(X), LoopVectorization.eltype(A), LoopVectorization.eltype(Q), LoopVectorization.eltype(B))
var"##Wvecwidth##" = LoopVectorization.pick_vector_width(var"##Tloopeltype##")
args = (LoopVectorization.avx_config_val(Val{(false, Int8(0), Int8(0), Int8(0), false, 0x0000000000000001)}(), var"##Wvecwidth##"), Val{(:LoopVectorization, :getindex, LoopVectorization.OperationStruct(0x00000000000000000000000000000021, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, LoopVectorization.memload, 0x0001, 0x01), :LoopVectorization, :getindex, LoopVectorization.OperationStruct(0x00000000000000000000000000000032, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, LoopVectorization.memload, 0x0002, 0x02), :LoopVectorization, :getindex, LoopVectorization.OperationStruct(0x00000000000000000000000000000031, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, LoopVectorization.memload, 0x0003, 0x03), :LoopVectorization, :mul_fast, LoopVectorization.OperationStruct(0x00000000000000000000000000000321, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, 0x00000000000000000000000000020003, 0x00000000000000000000000000000000, LoopVectorization.compute, 0x0004, 0x00), :LoopVectorization, :getindex, LoopVectorization.OperationStruct(0x00000000000000000000000000000001, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, LoopVectorization.memload, 0x0005, 0x04), :numericconstant, Symbol("###reduction##zero###19###"), LoopVectorization.OperationStruct(0x00000000000000000000000000000001, 0x00000000000000000000000000000000, 0x00000000000000000000000000000023, 0x00000000000000000000000000000000, 0x00000000000000000000000000000000, LoopVectorization.constant, 0x0006, 0x00), :LoopVectorization, :vfnmadd_fast, LoopVectorization.OperationStruct(0x00000000000000000000000000000213, 0x00000000000000000000000000000023, 0x00000000000000000000000000000000, 0x00000000000000000000000100040006, 0x00000000000000000000000000000000, LoopVectorization.compute, 0x0006, 0x00), :LoopVectorization, :reduced_add, LoopVectorization.OperationStruct(0x00000000000000000000000000000001, 0x00000000000000000000000000000023, 0x00000000000000000000000000000000, 0x00000000000000000000000000070005, 0x00000000000000000000000000000000, LoopVectorization.compute, 0x0005, 0x00), :LoopVectorization, :setindex!, LoopVectorization.OperationStruct(0x00000000000000000000000000000001, 0x00000000000000000000000000000023, 0x00000000000000000000000000000000, 0x00000000000000000000000000000008, 0x00000000000000000000000000000000, LoopVectorization.memstore, 0x0007, 0x04))}(), Val{(LoopVectorization.ArrayRefStruct{:A, Symbol("##vptr##_A")}(0x00000000000000000000000000000101, 0x00000000000000000000000000000201, 0x00000000000000000000000000000000, 0x00000000000000000000000000000101), LoopVectorization.ArrayRefStruct{:Q, Symbol("##vptr##_Q")}(0x00000000000000000000000000000101, 0x00000000000000000000000000000302, 0x00000000000000000000000000000000, 0x00000000000000000000000000000101), LoopVectorization.ArrayRefStruct{:B, Symbol("##vptr##_B")}(0x00000000000000000000000000000101, 0x00000000000000000000000000000301, 0x00000000000000000000000000000000, 0x00000000000000000000000000000101), LoopVectorization.ArrayRefStruct{:X, Symbol("##vptr##_X_##subset##_1_##with##_row_##")}(0x00000000000000000000000000000001, 0x00000000000000000000000000000001, 0x00000000000000000000000000000000, 0x00000000000000000000000000000001))}(), Val{(0, (), (), (), (), ((6, LoopVectorization.IntOrFloat),), ())}(), Val{(:i, :j, :k)}(), Base.Val(Base.typeof(var"##vargsym#571")), LoopVectorization.flatten_to_tuple(var"##vargsym#571")...)
LoopVectorization._turbo_!(args...)
